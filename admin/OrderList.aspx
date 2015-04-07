<%@ Page Language="C#" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title></title>
    <script src="../script/config.js" type="text/javascript"></script>
    <link href="../style/bootstrap.css" rel="stylesheet" type="text/css" />
    <link href="../style/admin.css" rel="stylesheet" type="text/css" />
    <script src="../script/main.js" type="text/javascript"></script>
    <script src="../script/jquery-2.0.1.min.js" type="text/javascript"></script>
</head>
<body>
    <form id="form1" runat="server">
    <div class="headMaster">
        <div class="left-logo">卢勤问答官方商城</div>
        <div class="right-info">XXX，你好　|　退出</div>
    </div>
    <div class="mainPage">
        <ul class="navMaster">
            <li>已付款</li>
            <li>退款中</li>
            <li>未付款</li>
            <li>已发货</li>
            <li style="border-right:none;">已关闭</li>
        </ul>

        <ul class="tabletitle">
            <li id="product_li">商品</li>
            <li id="consignee_li">收货人信息</li>
            <li id="remark_li">留言</li>
            <li id="operation_id">操作</li>
        </ul>
        <div id="orderContent">
            <div class="orderlist">
                <div class="ordertitle"><span>订单编号：</span><span style="margin-left:50px;">下单时间：</span></div>
                <div class="orderproduct">
                    <div id="prodimg"><a><img src="../upload/prodimg/fumus.jpg" /></a></div>
                    <div id="address">
                        <p>赵秀丽    13691499958</p>
                        <p>北京 北京 朝阳区 青年路大悦公寓北楼2609</p>
                    </div>
                    <div id="remarks">无</div>
                    <div class="operation">
                        <p>联系买家</p>
                        <p>订单详情</p>
                    </div>
                </div>
                <div class="clear"></div>
            </div>
            <div class="orderlist">
                <div class="ordertitle"><span>订单编号：</span><span style="margin-left:50px;">下单时间：</span></div>
                <div class="orderproduct">
                    <div id="prodimg"><a><img src="../upload/prodimg/fumus.jpg" /></a></div>
                    <div id="address">
                        <p>赵秀丽    13691499958</p>
                        <p>北京 北京 朝阳区 青年路大悦公寓北楼2609</p>
                    </div>
                    <div id="remarks">无</div>
                    <div class="operation">
                        <p>联系买家</p>
                        <p>订单详情</p>
                    </div>
                </div>
                <div class="clear"></div>
            </div>
        </div>
    </div>
    </form>
    <script runat="server">
        protected void Page_Load(object sender, EventArgs e)
        {
            DateTime startDate = (Request["startdate"] == null) ? DateTime.Parse("2001-1-1") : DateTime.Parse(Request["startdate"].Trim());
            DateTime endDate = (Request["enddate"] == null) ? DateTime.Parse("2999-1-1") : DateTime.Parse(Request["enddate"].Trim());
            Order[] orderArray = Order.GetOrders(0, startDate, endDate);
        }
    </script>
</body>
</html>
