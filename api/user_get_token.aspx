﻿<%@ Page Language="C#" %>
<script runat="server">

    protected void Page_Load(object sender, EventArgs e)
    {
        string type = (Request["type"]==null)? "openid" :  Request["type"].Trim();
        string userName = Request["username"] == null ? "oqrMvt6yRAWFu3DmhGe4Td0nKZRo" : Request["username"].Trim();
        DateTime expireDate = DateTime.Now.AddHours(2);
        
        if(userName.Trim()=="")
            Response.Write("{\"status\": 1 }");
        
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
        int status = 0;
        try
        {
            token = user.CreateToken(expireDate);
        }
        catch
        {
            status = 1;
        }
        
        Response.Write("{\"status\":" + status + " , \"token\" : \"" + token.Trim() + "\" , \"expire_date\":\""
            + expireDate.ToString() + "\" }");
        
        
    }
</script>