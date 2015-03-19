<%@ Page Language="C#" %>
<%@ Import Namespace="System.Data" %>
<script runat="server">

    protected void Page_Load(object sender, EventArgs e)
    {
        string token = (Request["token"] == null) ? "cc082d4385e9a53993dfdf5c90905cf529ee03e52115ea284ffec23c4956e636c6e88558" : Request["token"].Trim();
        int productId = (Request["productid"] == null) ? 4 : int.Parse(Request["productid"].Trim());
        int count = (Request["count"] == null) ? 0 : int.Parse(Request["count"].Trim());
        int uid = Users.CheckToken(token);

        //token = "27286af8c801dd8e456806bb5e6ef214d518bb006ffb1e2fa0e70f4765449b9b96cb1405";
        
        if (uid == -1)
        {
            Response.Write("{\"status\":-1, \"error_message\":\"The token is invalid.\"}");
        }
        else
        {
            if (uid == -2)
            {
                Response.Write("{\"status\":-1, \"error_message\":\"The token is expire.\"}");
            }
            else
            {
                Cart cart = new Cart(uid);
                cart.ModifyItem(productId, count);
                DataTable dt = new DataTable();
                dt = cart.GetCartTable();
                string itemJson = "";
                foreach (DataRow dr in dt.Rows)
                {
                    string columnJson = "";
                    foreach (DataColumn dc in dt.Columns)
                    {
                        columnJson = columnJson + ", \"" + dc.Caption.Trim() + "\" : \""
                            + dr[dc].ToString().Replace("\"", "\\\"") + "\" "; 
                    }
                    columnJson = columnJson.Remove(0, 1);
                    itemJson = itemJson + ",{" + columnJson + "}";
                }
                if (!itemJson.Trim().Equals(""))
                    itemJson = itemJson.Remove(0, 1);
                Response.Write("{\"status\":0,\"count\":" + dt.Rows.Count + ", \"items\":["
                    + itemJson + "]}");
            }
        }
        
    }
</script>