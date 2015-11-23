<%@ Page Language="C#" %>
<%@ Import Namespace="System.Data" %>
<script runat="server">

    protected void Page_Load(object sender, EventArgs e)
    {
        DateTime startDate = (Request["startdate"] == null) ? DateTime.Parse("2001-1-1") : DateTime.Parse(Request["startdate"].Trim());
        DateTime endDate = (Request["enddate"] == null) ? DateTime.Parse("2999-1-1") : DateTime.Parse(Request["enddate"].Trim());
        int productId = (Request["productid"] == null) ? 5 : int.Parse(Request["productid"].Trim());
        int isPaid = ((Request["paid"] == null) ? 1 : int.Parse(Request["paid"].Trim()));
        string sql = " select  *  from m_order_detail left join m_order on oid = order_id  where product_id = " + productId.ToString()
            +  ((isPaid!=-1) ? ((isPaid!=0)? " and paystate in (1,2)  " : " and state = 0 ") :"  " )
            + " and  m_order_detail.ctime >= '" + startDate.ToString() + "'   and m_order_detail.ctime <=  '" + endDate.ToString() 
            + "'   order by  oid desc  ";
        DataTable dt = DBHelper.GetDataTable(sql,  Util.ConnectionString);
        string orderJsonStr = "";

        foreach (DataRow dr in dt.Rows)
        {
            string orderDetailJsonStr = "";
            foreach (DataColumn c in dt.Columns)
            {
                if (!c.Caption.Trim().Equals("product_description"))
                {
                    orderDetailJsonStr = orderDetailJsonStr + ",\"" + c.Caption.Trim() + "\" : \""
                        + dr[c].ToString().Trim().Replace("\"", "”").Replace(",", "，").Trim() + "\" ";
                }
            }
            if (orderDetailJsonStr.StartsWith(","))
                orderDetailJsonStr = orderDetailJsonStr.Remove(0, 1);
            orderJsonStr = orderJsonStr + "," + orderDetailJsonStr.Trim();
        }
        if (orderJsonStr.StartsWith(","))
            orderJsonStr = orderJsonStr.Remove(0, 1);
        Response.Write("{\"status\" : 0 , \"orders\" : [" + orderJsonStr + "]}");
        
        
        
    }
</script>