<%@ Page Title="卢勤问答平台官方书城" Language="C#" MasterPageFile="~/Master.master" %>

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
<%--<div style="background:#fff; padding:10px 20px; margin-top:10px; font-size:16px; color:#ff0000; font-weight:bold; line-height:25px; position:relative;">
    <p>　　满50送218！！！是的，您没看错哦，购书还送专家课程，小编为了您的家庭教育也是蛮拼的！</p>
    <div style="position:absolute; right:20px; bottom:5px; font-size:14px;"><a style="color:#bbb;" href="Activity11.aspx">活动详情>></a></div>
</div>--%>
<div style="background:#fff; padding:10px; margin-top:10px;">
    1、本店为卢勤问答平台官方书城，所有图书均有现货。2、本店的运费遵循市场规则，您可以自行拍下。
</div>
<div style="background:#fff; width:100%; margin-top:10px; ">
    <ul class="nav-default">
        <li id="type-suit">给家长看的书</li>
        <li id="type-single" style="position:relative;">
            给孩子看的书
            <div class="type_menu_list">
                <div><a href="#xuelingqian">学龄前</a></div>
                <div><a href="#xiaoxue">学龄期/少年期</a></div>
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
        filllist(2);
        totalcart('my_cart_em');
        setCookie('source', 1);

        $("#type-single").click(function () {
            $("#type-single").css("background", "#D83337");
            $("#type-single").css("color", "#FDF8D2");
            $("#type-suit").css("background", "#FDF8D2");
            $("#type-suit").css("color", "#46484A");
            $('.type_menu_list').show();
        });

        $("#type-suit").click(function () {
            filllist(2);
        });
    });

    function filllist(typeid) {
        $("#type-suit").css("background", "#D83337");
        $("#type-single").css("background", "#FDF8D2");
        $("#type-suit").css("color", "#FDF8D2");
        $("#type-single").css("color", "#46484A");
        $('.type_menu_list').hide();
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

                    html += "<li style='clear:both; width:100%; height:40px; line-height:40px; background:#D83337; margin:5px 0; padding:0px 3px;'><a name='xiaoxue' style='color:#FDF8D2; margin-left:10px; font-weight:bold;'>学龄期/少年期</a></li>";
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

                    $('#prodlistul').html(html);
                }
            }
        });
    }
</script>
</asp:Content>

