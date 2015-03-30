<%@ Page Title="" Language="C#" MasterPageFile="~/Master.master" %>

<asp:Content ID="Content1" ContentPlaceHolderID="MasterHead" Runat="Server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="MasterContent" Runat="Server">
<div class="mainpage">
    <div class="titleNav">
        <a href="Default.aspx" class="returnA"> </a>
        <span class="titleSpan">我的订单</span>
    </div>
    <%--<div style="background:#f0f0f0; margin:10px; padding:10px;">
        <ul class="ls-order-ul">
            <li><a class="ok">全部</a></li>
            <li><a>待付款</a></li>
            <li><a>待发货</a></li>
            <li><a>待收货</a></li>
        </ul>
        <div class="clear"></div>
    </div>--%>
    <div id="orderlist">
        <%--<div class="m-dcontent" style="margin:10px; padding:10px 20px;">
            <div class="ls-order-title">
                <div style="float:left;">订单编号</div>
                <div style="float:left;">2015-03-16 17:17:41</div>
                <div class="clear"></div>
            </div>
            <a class="ls-order-prod rel">
                <p class="lop-img"><img src="images/prodimg/wchj1d43fg.jpg" /></p>
                <p class="lop-name">卢勤老师图书套装，共10本，包含男孩梦、..</p>
                <p class="lop-num">数量：1</p>
                <p class="lop-price o-price">¥288.00</p>
            </a>
            <p class="ls-order-num">数量：2</p>
            <p class="ls-order-state rel">订单状态：<em class="o-state-close">已关闭</em> <a onclick="ls_pay()" class="btn paybtn">立即付款</a></p>
            <p class="ls-order-total"><span> 运费：<em class="o-price" style=" padding-right: 20px;">¥12.00</em>总价：<em class="o-price">¥326.80</em></span></p>
            <div class="clear"></div>
        </div>--%>
    </div>
    <div class="clear" style="height:20px;"></div>
    <input type="hidden" id="hidOID" name="hidOID" />
    <input type="hidden" name="myToken" id="myToken" value="" />
    <input type="hidden" name="myOpenid" id="myOpenid" value="" />
    <input type="hidden" name="myFrom" id="myFrom" value="" />
</div>
<script runat="server">
    protected void Page_Load(object sender, EventArgs e)
    {
        if (Request["hidOID"] != null && !Request["hidOID"].ToString().Equals(string.Empty))
        {
            GetOrder(Request["hidOID"].ToString());
        }
    }
    private void GetOrder(string orderid)
    {
        Order order = new Order(int.Parse(orderid));
        int total = int.Parse(order._fields["orderprice"].ToString()) + int.Parse(order._fields["shipfee"].ToString());
        string param = "?body=卢勤问答平台官方书城&detail=卢勤问答平台官方书城&product_id=" + order._fields["oid"] + "&total_fee=" + total.ToString();
        string payurl = "";
        if (Request["myFrom"] != null && Request["myFrom"].ToString() == "1")
        {
            //微信支付
            payurl = "http://weixin.luqinwenda.com/payment/payment.aspx";
        }
        else
        {
            //易宝支付
            payurl = "http://yeepay.luqinwenda.com/weixin_payment.aspx";
        }
        this.Response.Redirect(payurl + param);
    }
</script>
<script type="text/javascript">
    $(document).ready(function () {
        loadOrder();
    });

    function loadOrder() {
        $('#orderlist').html('<div class="loading" style="margin:10px;"><img src="images/loading.gif" /><br />加载中...</div>');
        $.post(domain + 'api/order_get_list.aspx', { token: token, random: Math.random() }, function (data) {
            if (data.status == -1) {
                GetToken();
                loadOrder();
            }
            else {
                var orderHtml = '';
                for (var i = 0; i < data.orders.length; i++) {
                    var ct = new Date(data.orders[i].ctime);
                    orderHtml += '<div class="m-dcontent" style="margin:10px; padding:10px 20px;"><div class="ls-order-title"><div>订单编号：' + new Date(data.orders[i].ctime).valueOf().toString() + data.orders[i].oid + '</div><div>订单日期：' + ct.Format("yyyy-MM-dd hh:mm:ss") + '</div><div class="clear"></div></div>';
                    for (var j = 0; j < data.orders[i].details.length; j++) {
                        orderHtml += '<a class="ls-order-prod rel" href="Detail.aspx?productid=' + data.orders[i].details[j].product_id + '"><p class="lop-img"><img src="' + domain + data.orders[i].details[j].imgsrc + '" /></p><p class="lop-name">' + data.orders[i].details[j].product_name + '</p><p class="lop-num">数量：' + data.orders[i].details[j].product_count + '</p><p class="lop-price o-price">¥' + parseInt(data.orders[i].details[j].price * data.orders[i].details[j].product_count) / 100 + '</p></a>';
                    }
                    orderHtml += '<!--<p class="ls-order-num">数量：' + data.orders[i].details.length + '</p>--><p class="ls-order-state rel">订单状态：' + orderState(parseInt(data.orders[i].paystate), data.orders[i].oid) + '</p><p class="ls-order-total"><span> 运费：<em class="o-price" style=" padding-right: 20px;">¥' + parseInt(data.orders[i].shipfee) / 100 + '</em>总价：<em class="o-price">¥' + (parseInt(data.orders[i].orderprice) + parseInt(data.orders[i].shipfee)) / 100 + '</em></span></p><div class="clear"></div></div>';
                }
                $("#orderlist").html(orderHtml);
            }
        }, 'json');
    }

    function ls_pay(oid) {
        GetOpenidToken();
        $("#myToken").val(token);
        $("#myOpenid").val(openid);
        $("#myFrom").val(from);
        $("#hidOID").val(oid);
        document.forms[0].submit();
    }
</script>
</asp:Content>

