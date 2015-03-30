<%@ Page Language="C#" %>
<script runat="server">

    protected void Page_Load(object sender, EventArgs e)
    {
        string type = (Request["type"]==null)? "username" :  Request["type"].Trim();
        string userName = Request["username"]==null? "abce" : Request["username"].Trim();
        DateTime expireDate = DateTime.Now.AddHours(2);
        
        Users user;
        if (Users.IsExistsUser(type, userName))
        {
            user = Users.GetUser(type, userName);
        }
        else
        {
            int userId = Users.AddUser(type, userName);
            user = new Users(userId);
        }
        string token = "";
        int status = 1;
        try
        {
            token = user.CreateToken(expireDate);
        }
        catch
        {
            status = 0;
        }
        
        Response.Write("{\"status\":" + status + " , \"token\" : \"" + token.Trim() + "\" , \"expire_date\":\""
            + expireDate.ToString() + "\" }");
        
        
    }
</script>