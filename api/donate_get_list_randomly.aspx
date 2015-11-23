<%@ Page Language="C#" %>
<%@ Import Namespace="System.Data" %>
<%@ Import Namespace="System.Web.Script.Serialization" %>
<script runat="server">

    protected void Page_Load(object sender, EventArgs e)
    {
        
        
        string jsonStr = Util.GetWebContent("http://mall.luqinwenda.com/api/product_get_sales_record.aspx?productid=5", "get", "", "html/json");
       
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
            dr["weixin_nick"] = name.ToString();
            dr["weixin_head_image"] = "";
            dr["cell"] = cell.ToString();
            dr["date"] = ctime1.ToString();
            dr["donate_type"] = "buy";
            dtResult.Rows.Add(dr);
        }

        DataTable dtForward = DBHelper.GetDataTable(" select * from donate_list order by create_time desc ", Util.ConnectionString.Trim());
        

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