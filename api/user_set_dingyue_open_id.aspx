<%@ Page Language="C#" %>
<script runat="server">

    protected void Page_Load(object sender, EventArgs e)
    {
        string token = Util.GetSafeRequestValue(Request, "token", "");
        string dingyueOpenid = Util.GetSafeRequestValue(Request, "dingyue_openid", "");
        int userId = Users.CheckToken(token);
        if (userId > 0)
        {
            Users user = new Users(userId);
            user.DingyueOpenid = dingyueOpenid;
            Response.Write("{\"status\" : 0}");
        }
        else
        {
            Response.Write("{\"status\": 1 , \"error_message\" : \"User is not find.\" }");
        }
    }
</script>