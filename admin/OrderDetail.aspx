<%@ Page Language="C#" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title></title>
    <script src="../script/config.js" type="text/javascript"></script>
    <link href="../style/bootstrap.css" rel="stylesheet" type="text/css" />
    <link href="../style/admin.css" rel="stylesheet" type="text/css" />
</head>
<body>
    <form id="form1" runat="server">
    <div class="headMaster">
        <div class="left-logo">卢勤问答官方商城</div>
        <div class="right-info">XXX，你好　|　退出</div>
    </div>
    <div class="mainPage">
        <div class="orderdetail_state">
            订单状态：已关闭
        </div>

        <div class="orderdetail_info">
            <div class="od_info_title">订单信息   </div>
            <div class="od_info_consignee">
                <p>收货人信息：赵秀丽　　13691499958</p>
                <p>　　　　　　北京 北京 大兴区 亦庄镇泰河园三里9号楼2单元401</p>
            </div>
            <div class="od_info_buyer">　买家留言：无</div>
            <div class="od_info_timer">订单编号：1144960140　　下单时间：2015-04-03 09:50:50</div>
        </div>

        <ul class="prod_item">
            <li class="list_hd">
                <div id="prod_item_a">商品名称</div>
                <div id="prod_item_b">型号</div>
                <div id="prod_item_c">价格</div>
                <div id="prod_item_d">数量</div>
            </li>
            <li class="list_prod">
                <div id="prod_item_a">
                    <a id="prodimg"><img src="../upload/prodimg/fumus.jpg" /></a>
                    <a id="prodtitle">卢勤老师图书套装，共10本，包含男孩梦、..</a>
                </div>
                <div id="prod_item_b">无型号</div>
                <div id="prod_item_c">288</div>
                <div id="prod_item_d">1</div>
            </li>
            <li class="list_prod">
                <div class="dashline" id="prod_item_a">
                    <a id="prodimg"><img src="../upload/prodimg/fumus.jpg" /></a>
                    <a id="prodtitle">卢勤老师图书套装，共10本，包含男孩梦、..</a>
                </div>
                <div class="dashline" id="prod_item_b">无型号</div>
                <div class="dashline" id="prod_item_c">288</div>
                <div class="dashline" id="prod_item_d">1</div>
            </li>
        </ul>
        <div class="clear"></div>
    </div>
    </form>
</body>
</html>
