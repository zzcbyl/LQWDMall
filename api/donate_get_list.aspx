<%@ Page Language="C#" %>
<%@ Import Namespace="System.Data" %>
<%@ Import Namespace="System.Web.Script.Serialization" %>
<script runat="server">

    protected void Page_Load(object sender, EventArgs e)
    {
        /*
        string currentUrl = Request.Url.ToString();
        int lastSepratorPosition = currentUrl.IndexOf("donate_get_list.aspx");
        currentUrl = currentUrl.Substring(0, lastSepratorPosition);
        
        string jsonStr = Util.GetWebContent(currentUrl + "/product_get_sales_record.aspx?productid=5", "get", "", "html/json");
         */

        string jsonStr = "";
        DateTime startDate = (Request["startdate"] == null) ? DateTime.Parse("2001-1-1") : DateTime.Parse(Request["startdate"].Trim());
        DateTime endDate = (Request["enddate"] == null) ? DateTime.Parse("2999-1-1") : DateTime.Parse(Request["enddate"].Trim());
        int productId = (Request["productid"] == null) ? 5 : int.Parse(Request["productid"].Trim());
        int isPaid = ((Request["paid"] == null) ? 1 : int.Parse(Request["paid"].Trim()));
        string sql = " select  *  from m_order_detail left join m_order on oid = order_id  where product_id = " + productId.ToString()
            + ((isPaid != -1) ? ((isPaid != 0) ? " and paystate in (1,2)  " : " and state = 0 ") : "  ")
            + " and  m_order_detail.ctime >= '" + startDate.ToString() + "'   and m_order_detail.ctime <=  '" + endDate.ToString()
            + "'   order by  oid desc  ";
        DataTable dt = DBHelper.GetDataTable(sql, Util.ConnectionString);
        string orderJsonStr = "";

        foreach (DataRow dr in dt.Rows)
        {
            string orderDetailJsonStr = "";
            foreach (DataColumn c in dt.Columns)
            {
                orderDetailJsonStr = orderDetailJsonStr + ",\"" + c.Caption.Trim() + "\" : \""
                    + dr[c].ToString().Trim().Replace("\"", "”").Replace(",","，").Trim() + "\" ";
            }
            if (orderDetailJsonStr.StartsWith(","))
                orderDetailJsonStr = orderDetailJsonStr.Remove(0, 1);
            orderJsonStr = orderJsonStr + ",{" + orderDetailJsonStr.Trim()+"}" ;
        }
        if (orderJsonStr.StartsWith(","))
            orderJsonStr = orderJsonStr.Remove(0, 1);

        jsonStr = "{\"status\" : 0 , \"orders\" : [" + orderJsonStr + "]}";

        JavaScriptSerializer serializer = new JavaScriptSerializer();
        Dictionary<string, object> json = (Dictionary<string, object>)serializer.DeserializeObject(jsonStr);
        object v;
        json.TryGetValue("orders", out v);
        object[] vArr = (object[])v;

        int headLineCount = 3;

        DataTable dtResult = new DataTable();
        dtResult.Columns.Add("weixin_nick");
        dtResult.Columns.Add("weixin_head_image");
        dtResult.Columns.Add("cell");
        dtResult.Columns.Add("date");
        dtResult.Columns.Add("donate_type");
        int i = 0;
        for (; ((i < headLineCount) && (i < vArr.Length)); i++)
        {
            DataRow dr = dtResult.NewRow();
            Dictionary<string, object> values = (Dictionary<string, object>)vArr[i];
            object name;
            object cell;
            object ctime1;
            values.TryGetValue("name", out name);
            values.TryGetValue("cell", out cell);
            values.TryGetValue("ctime1", out ctime1);
            
            //string weixinJsonStr = Util.GetWebContent("http://weixin.luqinwenda.com/dingyue/get_user_info.aspx?openid=" + 
            
            
            dr["weixin_nick"] = name.ToString();
            dr["weixin_head_image"] = "";
            dr["cell"] = cell.ToString();
            dr["date"] = ctime1.ToString();
            dr["donate_type"] = "buy";
            dtResult.Rows.Add(dr);
        }

        DataTable dtForward = DBHelper.GetDataTable(" select * from donate_from_forward order by create_time desc ", Util.ConnectionString.Trim());
        

        int j = i;
        int k = 0;

        for (; j < vArr.Length || k < dtForward.Rows.Count; )
        {
            DataRow dr = dtResult.NewRow();
            bool fromForward = true;
            if (j < vArr.Length && k < dtForward.Rows.Count)
            {
                int randNumber = new Random().Next(10);
                if (randNumber > 5)
                    fromForward = false;
            }
            else
            {
                if (k < dtForward.Rows.Count)
                {
                    fromForward = true;
                }
                else
                {
                    fromForward = false;
                }
            }
            if (fromForward)
            {
                dr["weixin_nick"] = dtForward.Rows[k]["weixin_nick"].ToString().Trim();
                dr["weixin_head_image"] = dtForward.Rows[k]["weixin_head_image"].ToString().Trim();
                dr["cell"] = "";
                dr["date"] = dtForward.Rows[k]["create_time"].ToString().Trim();
                dr["donate_type"] = "forward";
                k++;
            }
            else
            {
                Dictionary<string, object> values = (Dictionary<string, object>)vArr[j];
                object name;
                object cell;
                object ctime1;
                values.TryGetValue("name", out name);
                values.TryGetValue("cell", out cell);
                values.TryGetValue("ctime1", out ctime1);
                dr["weixin_nick"] = name.ToString();
                dr["weixin_head_image"] = "";
                dr["cell"] = cell.ToString();
                dr["date"] = ctime1.ToString();
                dr["donate_type"] = "buy";
                dt.Rows.Add(dr);   
                j++;
            }

            dtResult.Rows.Add(dr);
            
        }

        string jsonResultMember = "";

        foreach (DataRow dr in dtResult.Rows)
        {
            string jsonResultMemberCell = "";
            foreach (DataColumn c in dtResult.Columns)
            {
                jsonResultMemberCell = jsonResultMemberCell + ", \"" + c.Caption.Trim() + "\" : \""
                    + dr[c].ToString().Replace("\"", "”").Replace(",", "，").Trim() + "\"  ";
            }
            if (jsonResultMemberCell.StartsWith(","))
                jsonResultMemberCell = jsonResultMemberCell.Remove(0, 1);
            jsonResultMember = jsonResultMember + ",{" + jsonResultMemberCell + "}";
        }
        if (jsonResultMember.StartsWith(","))
            jsonResultMember = jsonResultMember.Remove(0, 1);
        Response.Write("{\"status\":0, list:[" + jsonResultMember + "]}");
        
        
        
        
        
        string status = Util.GetSimpleJsonValueByKey(jsonStr, "status");
    }
</script>