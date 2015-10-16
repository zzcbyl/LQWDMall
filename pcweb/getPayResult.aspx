<%@ Page Language="C#" %>
<%@ Import Namespace="System.Web.Script.Serialization" %>
<script runat="server">
    protected void Page_Load(object sender, EventArgs e)
    {
        string result = "UNPAID";
        if (Request["product_id"] != null && Request["product_id"] != "")
        {
            string getUrl = "http://weixin.luqinwenda.com/payment/payment_web_qrcode_query.aspx?product_id=" + Request["product_id"];
            string getResult = HTTPHelper.Get_Http(getUrl);
            JavaScriptSerializer json = new JavaScriptSerializer();
            ReturnResult jsonorder = json.Deserialize<ReturnResult>(getResult);
            if (jsonorder.status == 0)
            {
                result = jsonorder.state;
            }
        }
        Response.Write(result);
    }
    class ReturnResult
    {
        public int status { get; set; }
        public string product_id { get; set; }
        public string state { get; set; }
    }
</script>
