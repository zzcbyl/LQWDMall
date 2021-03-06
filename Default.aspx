﻿<%@ Page Title="悦长大平台官方书城" Language="C#" MasterPageFile="~/Master.master" %>

<script runat="server">
    protected void Page_Load(object sender, EventArgs e)
    {
        if (Request["couponCode"] != null && Request["couponCode"] != "")
        {
            this.Session["couponCode"] = Request["couponCode"].ToString();
        }
    }
</script>

<asp:Content ID="Content1" ContentPlaceHolderID="MasterHead" Runat="Server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="MasterContent" Runat="Server">
<div style="width:100%;">
    <img src="images/mall-banner.jpg" width="100%" />
</div>
<%--<div style="background:#fff; padding:5px 20px; margin-top:10px; font-size:14px; font-weight:bold; color:#ff0000; line-height:25px; position:relative;">
    <p>　　因春节快递放假，从1月27日起所有订单将在春节上班后按照付款顺序发货！</p>
    <div style="position:absolute; right:20px; bottom:5px; font-size:14px;"><a style="color:#bbb;" href="Activity11.aspx">活动详情>></a></div>
</div>--%>
<div style="background:#fff; padding:10px; margin-top:10px;">
    1、本店为悦长大平台官方书城，所有图书均有现货。2、本店的运费遵循市场规则，您可以自行拍下。
</div>
<div id="bookNav" style="background:#fff; width:100%; margin-top:10px; ">
    <ul class="nav-default">
        <li id="type-suit">给家长看的书</li>
        <li id="type-single" style="position:relative;">
            给孩子看的书
            <div class="type_menu_list">
                <div><a href="#xuelingqian">学龄前</a></div>
                <div><a href="#xiaoxue">学龄期</a></div>
            </div>
        </li>
        <li id="type-toys">
            儿童乐园
            <div class="type_toys_list">
                <div><a href="#etaq">儿童安全</a></div>
                <div><a href="#ajxdz">精细动作培养</a></div>
                <div><a href="#aswcz">思维创造训练</a></div>
                <div><a href="#akjlj">空间逻辑训练</a></div>
                <div><a href="#ayzty">益智体验</a></div>
            </div>
        </li>
    </ul>
    <div class="clear"></div>
</div>
<div class="m-wrap">
    <ul id="prodlistul" class="m-ul rel">
        <li><div class="loading"><img src="images/loading.gif" /><br />加载中...</div></li>
    </ul>
    <div class="clear" style="height:60px;"></div>
    <div class="m-bottom">
        <ul id="footermenu">
            <%--<li id="ftm-type">
                <div>商品分类</div>
            </li>--%>
            <li id="ftm-user">
                <%--<div><a href="userIndex.aspx">个人中心</a></div>--%>
                <div><a href="ls_order.aspx">我的订单</a></div>
            </li>
            <li id="ftm-cart">
                <div>
                    <a id="my-cart" href="ShopCart.aspx">购物车
                    <em id="my_cart_em" class="abs" style="display: none; right:35%;"></em>
                </a></div>
            </li>
        </ul>
        <div class="clear"></div>
    </div>
</div>
<div id="myModal" class="modal hide fade" style="left:50%;" tabindex="-1" role="dialog" aria-labelledby="myModalLabel" aria-hidden="true">
    <div class="modal-body">
    <p>已添加购物车</p>
    </div>
    <div class="modal-footer">
    <button class="btn" data-dismiss="modal" aria-hidden="true">再逛逛</button>
    <a href='ShopCart.aspx' class="btn btn-primary" >去结算</a>
    </div>
</div>
<script type="text/javascript">
    $(document).ready(function () {
        lineLink = "http://mall.luqinwenda.com/Default.aspx"; //链接
        var typeid = 2;
        if (QueryString('typeid')) {
            typeid = QueryString('typeid');
            $('#bookNav').hide();
        }
        filllist(typeid);
        totalcart('my_cart_em');
        setCookie('source', 1);

        $("#type-single").click(function () {
            $('.nav-default li').each(function () {
                $(this).css("background", "#FDF8D2");
                $(this).css("color", "#46484A");
            });
            $("#type-single").css("background", "#D83337");
            $("#type-single").css("color", "#FDF8D2");
            $('.type_toys_list').hide();
            $('.type_menu_list').show();
        });

        $("#type-toys").click(function () {
            $('.nav-default li').each(function () {
                $(this).css("background", "#FDF8D2");
                $(this).css("color", "#46484A");
            });
            $("#type-toys").css("background", "#D83337");
            $("#type-toys").css("color", "#FDF8D2");
            $('.type_menu_list').hide();
            $('.type_toys_list').show();
        });

        $("#type-suit").click(function () {
            filllist(2);
        });
    });

    function filllist(typeid) {
        $('.nav-default li').each(function () {
            $(this).css("background", "#FDF8D2");
            $(this).css("color", "#46484A");
        });
        $("#type-suit").css("background", "#D83337");
        $("#type-suit").css("color", "#FDF8D2");
        $('.type_menu_list').hide();
        $('.type_toys_list').hide();
        

        //$('#prodlistul').html('<li><div class="loading"><img src="images/loading.gif" /><br />加载中...</div></li>');
        $.ajax({
            type: "post",
            async: false,
            url: domain + 'api/product_get_all.aspx',
            data: { random: Math.random() },
            success: function (data, textStatus) {
                var obj = eval('(' + data + ')');
                if (obj != null) {
                    var prodlist = obj.data;
                    var html = "";

                    if (QueryString('typeid')) {
                        for (var i = 0; i < prodlist.length; i++) {
                            if (prodlist[i].prodtypeid == QueryString('typeid')) {
                                var strprice = '';
                                var iconjiu = '';
                                if (prodlist[i].originalprice != null && prodlist[i].originalprice != '') {
                                    strprice = '<s class="gray">¥' + parseInt(prodlist[i].originalprice) / 100 + '</s><span class="red mgleft">¥' + parseInt(prodlist[i].price) / 100 + '</span>';
                                    iconjiu = ''; //'<span class="icon-jiu"></span>';
                                }
                                else {
                                    strprice = '<span class="red">¥' + parseInt(prodlist[i].price) / 100 + '</span>';
                                }
                                html += '<li class="m-li left rel"><a href="Detail.aspx?productid=' + prodlist[i].prodid + '"><div class="pd5"><img src="' + domain + prodlist[i].imgsrc + '" />' + iconjiu + '</div><div class="m-txt">' + prodlist[i].prodname + '</div><div class="m-price">' + strprice + '</div></a><div class="prod-list-btn"><!--<a id="addShopCart" onclick="detailAddCart(' + prodlist[i].prodid + ', 1);" class="btn btn-default">加入购物车</a>--><a id="buyProd" onclick="detailAddCart(' + prodlist[i].prodid + ', 0);" class="btn btn-danger">购买</a></div></li>';
                            }
                        }
                    }
                    else {

                        for (var i = 0; i < prodlist.length; i++) {
                            if (prodlist[i].prodtypeid == 2) {
                                var strprice = '';
                                var iconjiu = '';
                                if (prodlist[i].originalprice != null && prodlist[i].originalprice != '') {
                                    strprice = '<s class="gray">¥' + parseInt(prodlist[i].originalprice) / 100 + '</s><span class="red mgleft">¥' + parseInt(prodlist[i].price) / 100 + '</span>';
                                    iconjiu = ''; //'<span class="icon-jiu"></span>';
                                }
                                else {
                                    strprice = '<span class="red">¥' + parseInt(prodlist[i].price) / 100 + '</span>';
                                }
                                html += '<li class="m-li left rel"><a href="Detail.aspx?productid=' + prodlist[i].prodid + '"><div class="pd5"><img src="' + domain + prodlist[i].imgsrc + '" />' + iconjiu + '</div><div class="m-txt">' + prodlist[i].prodname + '</div><div class="m-price">' + strprice + '</div></a><div class="prod-list-btn"><!--<a id="addShopCart" onclick="detailAddCart(' + prodlist[i].prodid + ', 1);" class="btn btn-default">加入购物车</a>--><a id="buyProd" onclick="detailAddCart(' + prodlist[i].prodid + ', 0);" class="btn btn-danger">购买</a></div></li>';
                            }
                        }
                        html += "<li style='clear:both; width:100%; height:40px; line-height:40px; background:#D83337; margin:5px 0; padding:0px 3px;'><a name='xuelingqian' style='color:#FDF8D2; margin-left:10px; font-weight:bold;'>学龄前</a></li>";
                        for (var i = 0; i < prodlist.length; i++) {
                            if (prodlist[i].prodtypeid == 4) {
                                var strprice = '';
                                var iconjiu = '';
                                if (prodlist[i].originalprice != null && prodlist[i].originalprice != '') {
                                    strprice = '<s class="gray">¥' + parseInt(prodlist[i].originalprice) / 100 + '</s><span class="red mgleft">¥' + parseInt(prodlist[i].price) / 100 + '</span>';
                                    iconjiu = ''; //'<span class="icon-jiu"></span>';
                                }
                                else {
                                    strprice = '<span class="red">¥' + parseInt(prodlist[i].price) / 100 + '</span>';
                                }
                                html += '<li class="m-li left rel"><a href="Detail.aspx?productid=' + prodlist[i].prodid + '"><div class="pd5"><img src="' + domain + prodlist[i].imgsrc + '" />' + iconjiu + '</div><div class="m-txt">' + prodlist[i].prodname + '</div><div class="m-price">' + strprice + '</div></a><div class="prod-list-btn"><!--<a id="addShopCart" onclick="detailAddCart(' + prodlist[i].prodid + ', 1);" class="btn btn-default">加入购物车</a>--><a id="buyProd" onclick="detailAddCart(' + prodlist[i].prodid + ', 0);" class="btn btn-danger">购买</a></div></li>';
                            }
                        }

                        html += "<li style='clear:both; width:100%; height:40px; line-height:40px; background:#D83337; margin:5px 0; padding:0px 3px;'><a name='xiaoxue' style='color:#FDF8D2; margin-left:10px; font-weight:bold;'>学龄期</a></li>";
                        for (var i = 0; i < prodlist.length; i++) {
                            if (prodlist[i].prodtypeid == 5) {
                                var strprice = '';
                                var iconjiu = '';
                                if (prodlist[i].originalprice != null && prodlist[i].originalprice != '') {
                                    strprice = '<s class="gray">¥' + parseInt(prodlist[i].originalprice) / 100 + '</s><span class="red mgleft">¥' + parseInt(prodlist[i].price) / 100 + '</span>';
                                    iconjiu = ''; //'<span class="icon-jiu"></span>';
                                }
                                else {
                                    strprice = '<span class="red">¥' + parseInt(prodlist[i].price) / 100 + '</span>';
                                }
                                html += '<li class="m-li left rel"><a href="Detail.aspx?productid=' + prodlist[i].prodid + '"><div class="pd5"><img src="' + domain + prodlist[i].imgsrc + '" />' + iconjiu + '</div><div class="m-txt">' + prodlist[i].prodname + '</div><div class="m-price">' + strprice + '</div></a><div class="prod-list-btn"><!--<a id="addShopCart" onclick="detailAddCart(' + prodlist[i].prodid + ', 1);" class="btn btn-default">加入购物车</a>--><a id="buyProd" onclick="detailAddCart(' + prodlist[i].prodid + ', 0);" class="btn btn-danger">购买</a></div></li>';
                            }
                        }

                        html += "<li style='clear:both; width:100%; height:40px; line-height:40px; background:#D83337; margin:5px 0; padding:0px 3px;'><a name='etaq' style='color:#FDF8D2; margin-left:10px; font-weight:bold;'>儿童安全</a></li>";
                        for (var i = 0; i < prodlist.length; i++) {
                            if (prodlist[i].prodtypeid == 10) {
                                var strprice = '';
                                var iconjiu = '';
                                if (prodlist[i].originalprice != null && prodlist[i].originalprice != '') {
                                    strprice = '<s class="gray">¥' + parseInt(prodlist[i].originalprice) / 100 + '</s><span class="red mgleft">¥' + parseInt(prodlist[i].price) / 100 + '</span>';
                                    iconjiu = ''; //'<span class="icon-jiu"></span>';
                                }
                                else {
                                    strprice = '<span class="red">¥' + parseInt(prodlist[i].price) / 100 + '</span>';
                                }
                                html += '<li class="m-li left rel"><a href="Detail.aspx?productid=' + prodlist[i].prodid + '"><div class="pd5"><img src="' + domain + prodlist[i].imgsrc + '" />' + iconjiu + '</div><div class="m-txt">' + prodlist[i].prodname + '</div><div class="m-price">' + strprice + '</div></a><div class="prod-list-btn"><!--<a id="addShopCart" onclick="detailAddCart(' + prodlist[i].prodid + ', 1);" class="btn btn-default">加入购物车</a>--><a id="buyProd" onclick="detailAddCart(' + prodlist[i].prodid + ', 0);" class="btn btn-danger">购买</a></div></li>';
                            }
                        }
                        html += "<li style='clear:both; width:100%; height:40px; line-height:40px; background:#D83337; margin:5px 0; padding:0px 3px;'><a name='ajxdz' style='color:#FDF8D2; margin-left:10px; font-weight:bold;'>精细动作培养</a></li>";
                        for (var i = 0; i < prodlist.length; i++) {
                            if (prodlist[i].prodtypeid == 6) {
                                var strprice = '';
                                var iconjiu = '';
                                if (prodlist[i].originalprice != null && prodlist[i].originalprice != '') {
                                    strprice = '<s class="gray">¥' + parseInt(prodlist[i].originalprice) / 100 + '</s><span class="red mgleft">¥' + parseInt(prodlist[i].price) / 100 + '</span>';
                                    iconjiu = ''; //'<span class="icon-jiu"></span>';
                                }
                                else {
                                    strprice = '<span class="red">¥' + parseInt(prodlist[i].price) / 100 + '</span>';
                                }
                                html += '<li class="m-li left rel"><a href="Detail.aspx?productid=' + prodlist[i].prodid + '"><div class="pd5"><img src="' + domain + prodlist[i].imgsrc + '" />' + iconjiu + '</div><div class="m-txt">' + prodlist[i].prodname + '</div><div class="m-price">' + strprice + '</div></a><div class="prod-list-btn"><!--<a id="addShopCart" onclick="detailAddCart(' + prodlist[i].prodid + ', 1);" class="btn btn-default">加入购物车</a>--><a id="buyProd" onclick="detailAddCart(' + prodlist[i].prodid + ', 0);" class="btn btn-danger">购买</a></div></li>';
                            }
                        }
                        html += "<li style='clear:both; width:100%; height:40px; line-height:40px; background:#D83337; margin:5px 0; padding:0px 3px;'><a name='aswcz' style='color:#FDF8D2; margin-left:10px; font-weight:bold;'>思维创造训练</a></li>";
                        for (var i = 0; i < prodlist.length; i++) {
                            if (prodlist[i].prodtypeid == 7) {
                                var strprice = '';
                                var iconjiu = '';
                                if (prodlist[i].originalprice != null && prodlist[i].originalprice != '') {
                                    strprice = '<s class="gray">¥' + parseInt(prodlist[i].originalprice) / 100 + '</s><span class="red mgleft">¥' + parseInt(prodlist[i].price) / 100 + '</span>';
                                    iconjiu = ''; //'<span class="icon-jiu"></span>';
                                }
                                else {
                                    strprice = '<span class="red">¥' + parseInt(prodlist[i].price) / 100 + '</span>';
                                }
                                html += '<li class="m-li left rel"><a href="Detail.aspx?productid=' + prodlist[i].prodid + '"><div class="pd5"><img src="' + domain + prodlist[i].imgsrc + '" />' + iconjiu + '</div><div class="m-txt">' + prodlist[i].prodname + '</div><div class="m-price">' + strprice + '</div></a><div class="prod-list-btn"><!--<a id="addShopCart" onclick="detailAddCart(' + prodlist[i].prodid + ', 1);" class="btn btn-default">加入购物车</a>--><a id="buyProd" onclick="detailAddCart(' + prodlist[i].prodid + ', 0);" class="btn btn-danger">购买</a></div></li>';
                            }
                        }
                        html += "<li style='clear:both; width:100%; height:40px; line-height:40px; background:#D83337; margin:5px 0; padding:0px 3px;'><a name='akjlj' style='color:#FDF8D2; margin-left:10px; font-weight:bold;'>空间逻辑训练</a></li>";
                        for (var i = 0; i < prodlist.length; i++) {
                            if (prodlist[i].prodtypeid == 8) {
                                var strprice = '';
                                var iconjiu = '';
                                if (prodlist[i].originalprice != null && prodlist[i].originalprice != '') {
                                    strprice = '<s class="gray">¥' + parseInt(prodlist[i].originalprice) / 100 + '</s><span class="red mgleft">¥' + parseInt(prodlist[i].price) / 100 + '</span>';
                                    iconjiu = ''; //'<span class="icon-jiu"></span>';
                                }
                                else {
                                    strprice = '<span class="red">¥' + parseInt(prodlist[i].price) / 100 + '</span>';
                                }
                                html += '<li class="m-li left rel"><a href="Detail.aspx?productid=' + prodlist[i].prodid + '"><div class="pd5"><img src="' + domain + prodlist[i].imgsrc + '" />' + iconjiu + '</div><div class="m-txt">' + prodlist[i].prodname + '</div><div class="m-price">' + strprice + '</div></a><div class="prod-list-btn"><!--<a id="addShopCart" onclick="detailAddCart(' + prodlist[i].prodid + ', 1);" class="btn btn-default">加入购物车</a>--><a id="buyProd" onclick="detailAddCart(' + prodlist[i].prodid + ', 0);" class="btn btn-danger">购买</a></div></li>';
                            }
                        }
                        html += "<li style='clear:both; width:100%; height:40px; line-height:40px; background:#D83337; margin:5px 0; padding:0px 3px;'><a name='ayzty' style='color:#FDF8D2; margin-left:10px; font-weight:bold;'>益智体验</a></li>";
                        for (var i = 0; i < prodlist.length; i++) {
                            if (prodlist[i].prodtypeid == 9) {
                                var strprice = '';
                                var iconjiu = '';
                                if (prodlist[i].originalprice != null && prodlist[i].originalprice != '') {
                                    strprice = '<s class="gray">¥' + parseInt(prodlist[i].originalprice) / 100 + '</s><span class="red mgleft">¥' + parseInt(prodlist[i].price) / 100 + '</span>';
                                    iconjiu = ''; //'<span class="icon-jiu"></span>';
                                }
                                else {
                                    strprice = '<span class="red">¥' + parseInt(prodlist[i].price) / 100 + '</span>';
                                }
                                html += '<li class="m-li left rel"><a href="Detail.aspx?productid=' + prodlist[i].prodid + '"><div class="pd5"><img src="' + domain + prodlist[i].imgsrc + '" />' + iconjiu + '</div><div class="m-txt">' + prodlist[i].prodname + '</div><div class="m-price">' + strprice + '</div></a><div class="prod-list-btn"><!--<a id="addShopCart" onclick="detailAddCart(' + prodlist[i].prodid + ', 1);" class="btn btn-default">加入购物车</a>--><a id="buyProd" onclick="detailAddCart(' + prodlist[i].prodid + ', 0);" class="btn btn-danger">购买</a></div></li>';
                            }
                        }
                    }
                    $('#prodlistul').html(html);
                }
            }
        });
    }
</script>
</asp:Content>

