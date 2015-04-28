<%@ Page Title="" Language="C#" MasterPageFile="~/pcweb/Master.master" %>

<script runat="server">
    protected void Page_Load(object sender, EventArgs e)
    {
        if (Request["orderid"] != null && Request["orderid"] != string.Empty)
        {
            int orderid = 0;
            int.TryParse(Request["orderid"], out orderid);
            if (orderid > 0)
            {
                Order order = new Order(orderid);
                int total = int.Parse(order._fields["orderprice"].ToString()) + int.Parse(order._fields["shipfee"].ToString());
                this.total.InnerHtml = "￥" + (decimal.Parse(total.ToString()) / 100).ToString();
                this.payImg.Src = "http://weixin.luqinwenda.com/payment/payment_web_qrcode.aspx?product_id=" + order._fields["oid"].ToString() + "&total_fee=" + total + "&body=卢勤问答平台官方商城PC&detail=卢勤问答平台官方商城PC";
            }
        }
        else
        {
            Response.Write("参数错误");
            Response.End();
            return;
        }
    }
</script>
<asp:Content ID="Content1" ContentPlaceHolderID="head" Runat="Server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" Runat="Server">
<div style="background:#fff; margin:10px; padding:10px;">
    <h3 style="height:50px; line-height:50px; font-family:宋体; border-bottom:1px solid #ccc;">使用微信支付<span id="total" runat="server" class="red mgleft"></span></h3>
    <div style="margin-top:20px; text-align:center;">
        <img id="payImg" runat="server" style="width:350px;" />
    </div>
    <div class="payment-description">
      <img alt="请使用微信扫描二维码以完成支付" src="../images/wx_pay_icon.png" class="btn-icon">
      请使用微信扫描<br>二维码以完成支付
    </div>
</div>
<script type="text/javascript">
    $(document).ready(function () {
        setInterval("checkpay()", 2000);
    });
    function checkpay() {
        $.ajax({
            type: "get",
            async: false,
            url: domain + 'pcweb/getPayResult.aspx',
            data: { product_id: QueryString('orderid'), random: Math.random() },
            success: function (data, textStatus) {
                if (data.Trim() == "PAID") {
                    location.href = domain + "pcweb/paySuccess.aspx?product_id=" + QueryString('orderid');
                }
            }
        });
    }
</script>
</asp:Content>

