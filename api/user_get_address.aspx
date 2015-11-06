<%@ Page Language="C#" %>
<%@ Import Namespace="System.Data" %>
<%@ Import Namespace="System.Data.SqlClient" %>
<script runat="server">

    protected void Page_Load(object sender, EventArgs e)
    {
        string token = ((Request["token"] == null) ? "ca72da43b4a6abc65713f4fff4728753c4df3d1765fb3b299837361aa64a47b15d3138ab" : Request["token"].Trim());
        int userId = Users.CheckToken(token);
        if (userId > 0)
        {
            SqlDataAdapter da = new SqlDataAdapter(" select distinct name,cell,province,city,address,zip from m_order where uid = "
                + userId.ToString(), Util.ConnectionString);
            DataTable dt = new DataTable();
            da.Fill(dt);
            da.Dispose();
            string jsonDetail = "";
            foreach (DataRow dr in dt.Rows)
            {
                string jsonDetailRow = "";
                foreach (DataColumn c in dt.Columns)
                {
                    jsonDetailRow = jsonDetailRow + ", \"" + c.Caption.Trim() + "\" : \"" + dr[c].ToString().Trim() + "\" ";
                }
                if (jsonDetailRow.StartsWith(","))
                    jsonDetailRow = jsonDetailRow.Remove(0, 1);
                jsonDetail = jsonDetail + ",{" + jsonDetailRow + "}";
            }
            if (jsonDetail.StartsWith(","))
                jsonDetail = jsonDetail.Remove(0, 1);
            Response.Write("{\"status\":0, \"addresses\":[" + jsonDetail.Trim() + "]}");
        }
        else
        {
            Response.Write("{\"status\":1, \"message\":\"Invalid token!\"}");
        }
    }
</script>