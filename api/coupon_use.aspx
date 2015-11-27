<%@ Page Language="C#" %>

<script runat="server">

    protected void Page_Load(object sender, EventArgs e)
    {
        string code = Util.GetSafeRequestValue(Request, "code", "KCUCFNQA");
        string token = Util.GetSafeRequestValue(Request, "token", "2a7502285681f8a61061fcbba73c552f40f0809375c84fb3ca1998d35cc19a3fb0a7e45e");
        int orderId = int.Parse(Util.GetSafeRequestValue(Request, "orderid", "1068"));
        Order order = new Order(orderId);
        int userId = Users.CheckToken(token);
        if (userId > 0 && userId == order.UserId )
        {
            bool success = Coupon.UseCoupon(code, orderId);
            if (success)
                Response.Write("{\"status\": 0 , \"success\" : 1 }");
            else
                Response.Write("{\"status\": 0 , \"success\" : 0 }");
            
        }
        else
        {
            Response.Write("{\"status\": 1 , \"error_message\" : \"Token is invalid\" }");
        }
        
    }
</script>
