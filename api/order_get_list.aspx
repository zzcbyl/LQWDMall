<%@ Page Language="C#" %>
<%@ Import Namespace="System.Data" %>
<%@ Import Namespace="System.Data.SqlClient" %>
<script runat="server">

    protected void Page_Load(object sender, EventArgs e)
    {
        string token = (Request["token"] == null) ? "ec3113c0caa6991ce9078158d7b4f2c9bc10995e149e6db2cc2975c15fe6398ef448d182" : Request["token"].Trim();
        int userId = Users.CheckToken(token);
        DateTime startDate = (Request["startdate"] == null) ? DateTime.Parse("2001-1-1") : DateTime.Parse(Request["startdate"].Trim());
        DateTime endDate = (Request["enddate"] == null) ? DateTime.Parse("2999-1-1") : DateTime.Parse(Request["enddate"].Trim());
        Order[] orderArray = Order.GetOrders(userId, startDate, endDate);
        string orderJsonStr = "";
        foreach (Order order in orderArray)
        {
            orderJsonStr = orderJsonStr + ",{";
            string orderInfoJsonStr = "";
            foreach (DataColumn c in order._fields.Table.Columns)
            { 
                orderInfoJsonStr = orderInfoJsonStr + ", \""+c.Caption.Trim() + "\" : \"" 
                    + order._fields[c].ToString().Replace("\"","\\\\").Trim() + "\"";
            }
            if (orderInfoJsonStr.Trim().StartsWith(","))
                orderInfoJsonStr = orderInfoJsonStr.Remove(0,1);
            orderJsonStr = orderJsonStr + orderInfoJsonStr.Trim() + ", \"details\":[";
            string orderDetailJsonStr = "";
            foreach (DataRow dr in order.GetOrderDetails().Rows)
            {
                orderDetailJsonStr = orderDetailJsonStr + ",{";
                string orderDetailRowJsonStr = "";
                foreach (DataColumn c in dr.Table.Columns)
                {
                    orderDetailRowJsonStr = orderDetailRowJsonStr + ",\""
                        + c.Caption.Trim() + "\":\"" + dr[c].ToString().Replace("\"", "\\\\").Trim() + "\" ";
                }
                if (orderDetailRowJsonStr.Trim().StartsWith(","))
                    orderDetailRowJsonStr = orderDetailRowJsonStr.Remove(0, 1);
                orderDetailJsonStr = orderDetailJsonStr + orderDetailRowJsonStr + "}  ";
            }
            if (orderDetailJsonStr.Trim().StartsWith(","))
                orderDetailJsonStr = orderDetailJsonStr.Remove(0, 1);

            orderJsonStr = orderJsonStr + orderDetailJsonStr.Trim() + "]} ";
        }
        if (orderJsonStr.Trim().StartsWith(","))
            orderJsonStr = orderJsonStr.Remove(0, 1);
        Response.Write("{\"status\":0, \"orders\":[" + orderJsonStr.Trim() + "]}");
    }
</script>