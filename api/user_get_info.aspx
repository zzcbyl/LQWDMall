<%@ Page Language="C#" %>
<%@ Import Namespace="System.Data" %>

<script runat="server">
    protected void Page_Load(object sender, EventArgs e)
    {
        string token = (Request["token"] == null) ? "d95edf1ed1fe71c1591cabb0252e5bafaa80e95f5651fe756a8c4d13185058e8349a0ba1" : Request["token"].Trim();
        int userId = Users.CheckToken(token);

        if (userId <= 0)
        {
            Response.Write("{\"status\":1, \"message\":\"Invalid token!\"}");
            Response.End();
        }

        Users user = new Users(userId);

        string jsonStr = "";
        foreach (DataColumn c in user._fields.Table.Columns)
        {
            jsonStr = jsonStr + ", \"" + c.Caption.Trim() + "\":\""
                + user._fields[c].ToString().Trim().Replace("\"", "\\\"") + "\"";
        }
        jsonStr = jsonStr.Remove(0, 1);
        jsonStr = "{" + jsonStr + "}";

        Response.Write("{\"status\":0, \"user_info\": " + jsonStr + " }");
    }
</script>
