<%@ Page Language="C#" %>
<%@ Import Namespace="System.Data" %>
<%@ Import Namespace="System.Data.SqlClient" %>
<script runat="server">

    protected void Page_Load(object sender, EventArgs e)
    {
        string token = (Request["token"] == null) ? "c4d86ec6a5f03ca3d92f7c43a67e1dcf9bf0bdfe4c1ffee253f5907a4ddc592b92306a62" : Request["token"].Trim();
        int userId = Users.CheckToken(token);
        int typeId = ((Request["typeid"] == null) ? 0 : int.Parse(Request["typeid"].Trim()));
        DateTime startDate = (Request["startdate"] == null) ? DateTime.Parse("2001-1-1") : DateTime.Parse(Request["startdate"].Trim());
        DateTime endDate = (Request["enddate"] == null) ? DateTime.Parse("2999-1-1") : DateTime.Parse(Request["enddate"].Trim());
        int isPaid = ((Request["paid"] == null) ? 0 : int.Parse(Request["paid"].Trim()));
        Order[] orderArray = Order.GetOrders(userId, startDate, endDate);
        string orderJsonStr = "";
        foreach (Order order in orderArray)
        {
          
            if (isPaid != 0 && !order._fields["paystate"].ToString().Trim().Equals(isPaid.ToString()) )
            {
                continue;
            }
            
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
                Product product = new Product(int.Parse(dr["product_id"].ToString().Trim()));
                if (typeId != 0 && int.Parse(product._fields["prodtypeid"].ToString().Trim()) != typeId)
                {
                    continue;
                }
                
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