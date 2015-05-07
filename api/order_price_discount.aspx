<%@ Page Language="C#" %>
<script runat="server">

    protected void Page_Load(object sender, EventArgs e)
    {
        int orderId = Request["oid"] == null ? 0 : int.Parse(Request["oid"].Trim());
        int discountAmount = Request["discountamount"] == null ? 0 : int.Parse(Request["discountamount"].Trim());
        Order order = new Order(orderId);
        int i = order.Discount(discountAmount);
        if (i == 1)
        {
            Response.Write("{\"status\" : 0 }");
        }
        else
        {
            Response.Write("{\"status\" : 1 }");
        }
    }
</script>