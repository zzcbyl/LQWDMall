<%@ Page Language="C#" %>
<%@ Import Namespace="System.Data" %>
<%@ Import Namespace="System.Data.SqlClient" %>
<script runat="server">

    protected void Page_Load(object sender, EventArgs e)
    {
        string token = Util.GetWebContent("http://weixin.luqinwenda.com/get_token.aspx", "GET", "", "html/text");
        
        string openId = Request["openid"] == null ? "oqrMvt8K6cwKt5T1yAavEylbJaRs" : Request["openid"].Trim();
        SqlDataAdapter da = new SqlDataAdapter(" select  qr_invite_list_detail_openid , qr_invite_list_detail_crt  "
            + " from qr_invite_list_detail left join qr_invite_list on qr_invite_list_id = qr_invite_list_detail_scene "
            + " where qr_invite_list_owner ='" + openId.Trim() + "' order by  qr_invite_list_detail_crt desc  ",
            System.Configuration.ConfigurationSettings.AppSettings["constrWX"].Trim());
        DataTable dt = new DataTable();
        da.Fill(dt);
        da.Dispose();

        SqlConnection conn = new SqlConnection(System.Configuration.ConfigurationSettings.AppSettings["constrWX"].Trim());
        SqlCommand cmd = new SqlCommand(" select * from qr_invite_list_detail where qr_invite_list_detail_openid = @openId and qr_invite_list_detail_crt > @joinTime ", conn);
        cmd.Parameters.Add("@openId", SqlDbType.VarChar);
        cmd.Parameters.Add("@joinTime", SqlDbType.DateTime);

        ArrayList openIdArr = new ArrayList();

        foreach (DataRow dr in dt.Rows)
        {
            cmd.Parameters["@openId"].Value = dr["qr_invite_list_detail_openid"].ToString().Trim();
            cmd.Parameters["@joinTime"].Value = DateTime.Parse(dr["qr_invite_list_detail_crt"].ToString().Trim()).AddSeconds(1);
            conn.Open();
            SqlDataReader reader = cmd.ExecuteReader();
            string[] infoArr = new string[2];
            if (!reader.Read())
            {
                infoArr[0] = dr["qr_invite_list_detail_openid"].ToString().Trim();
                infoArr[1] = dr["qr_invite_list_detail_crt"].ToString().Trim();
                openIdArr.Add(infoArr);
            }
            reader.Close();
            conn.Close();
        }

        
        

        string json = "{\"status\":\"" + openId.Trim() + "\" , \"count\" : " + openIdArr.Count.ToString()
            + " , \"sub-open-id-info\" : [ ";

        string subJson = "";

        foreach (object o in openIdArr)
        {
            string[] infoArr = (string[])o;
            string infoJson = Util.GetWebContent("https://api.weixin.qq.com/cgi-bin/user/info?access_token="
            + token + "&openid=" + infoArr[0] + "&lang=zh_CN", "GET", "", "text/html");
            subJson = subJson + ",{\"join-date\":\"" + infoArr[1].Trim() + "\", \"info\":"+infoJson+"}";
        }

        if (!subJson.Trim().Equals(""))
            subJson = subJson.Remove(0, 1);

        json = json + subJson + "] }";

        Response.Write(json);
    }
    
</script>