<%@ Page Language="C#" %>
<script runat="server">

    protected void Page_Load(object sender, EventArgs e)
    {
        string province = (Request["province"] == null) ? "北京市" : Request["province"].Trim();
        int count = (Request["count"]==null)? 5 : int.Parse(Request["count"].Trim());
        string json = "{\"status\":0, \"amount\" : " + Util.ShipFeeCalculate(province,count) + " }  ";
        Response.Write(json);
    }
</script>