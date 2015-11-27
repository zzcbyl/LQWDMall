<%@ Page Language="C#" %>


<script runat="server">

    protected void Page_Load(object sender, EventArgs e)
    {
        string code = Util.GetSafeRequestValue(Request, "code", "XK4CIAPT");
        Coupon coupon = new Coupon(code);
        if (coupon._fields == null)
        {
            Response.Write("{\"status\" : 1 , \"error_message\" : \"Coupon is not exsits\" }");
        }
        else
        {
            Response.Write("{\"status\" : 0 , \"code\": \"" + code + "\" , \"amount\" : " + coupon.Amount.ToString()
                + " , \"used\" : " + (coupon.Used ? "1" : "0") + ", \"expire_date\" : \"" + coupon.ExpireDate.ToString() + "\" ,  "  
                + "\"effect_amount\": " + coupon.EffectAmount.ToString() + "   }  ");
        }
    }
</script>