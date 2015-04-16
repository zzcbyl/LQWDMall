﻿<%@ Page Title="" Language="C#" MasterPageFile="~/pcweb/Master.master" %>

<script runat="server">

</script>

<asp:Content ID="Content1" ContentPlaceHolderID="head" Runat="Server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" Runat="Server">
<div style="background:#fff; padding:10px; line-height:22px;">
    1、本店为卢勤问答平台官方书城，所有图书均有现货。<br />2、本店的运费遵循市场规则，您可以自行拍下。<br />3、如果有任何疑问，或者其他要求，可以在线咨询客服。
</div>
<div style="background:#fff; width:100%; margin-top:10px; ">
    <ul class="nav-default">
        <li id="type-suit"><img src="../images/menu11.jpg" /></li>
        <li id="type-single"><img src="../images/menu21.jpg" /></li>
    </ul>
    <div class="clear"></div>
</div>
<div class="m-wrap">
    <ul id="prodlistul" class="m-ul rel">
    </ul>
    <div class="clear" style="height:20px;"></div>
</div>


<script type="text/javascript">
    $(document).ready(function () {
        filllist(2);
        //totalcart('my_cart_em');
        //setCookie('source', 1);

        $("#type-single").click(function () {
            filllist(1);
        });

        $("#type-suit").click(function () {
            filllist(2);
        });
    });

    function filllist(typeid) {
        if (typeid == 1) {
            $("#type-single").css("background", "#D83337");
            $("#type-suit").css("background", "#FDF8D2");
            $("#type-single img").eq(0).attr("src", "../images/menu2.jpg");
            $("#type-suit img").eq(0).attr("src", "../images/menu11.jpg");

        }
        else if (typeid == 2) {
            $("#type-suit").css("background", "#D83337");
            $("#type-single").css("background", "#FDF8D2");
            $("#type-single img").eq(0).attr("src", "../images/menu21.jpg");
            $("#type-suit img").eq(0).attr("src", "../images/menu1.jpg");
        }

        $('#prodlistul').html('<li><div class="loading"><img src="../images/loading.gif" /><br />加载中...</div></li>');
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
                        if (typeid != 0 && prodlist[i].prodtypeid != typeid)
                            continue;
                        var strprice = '';
                        var iconjiu = '';
                        if (prodlist[i].originalprice != null && prodlist[i].originalprice != '') {
                            strprice = '<s class="gray">¥' + parseInt(prodlist[i].originalprice) / 100 + '</s><span class="red mgleft">¥' + parseInt(prodlist[i].price) / 100 + '</span>';
                            iconjiu = '<span class="icon-jiu"></span>';
                        }
                        else {
                            strprice = '<span class="red">¥' + parseInt(prodlist[i].price) / 100 + '</span>';
                        }
                        html += '<li class="m-li left rel"><a href="Detail_bk.aspx?productid=' + prodlist[i].prodid + '"><div class="pd5"><img src="' + domain + prodlist[i].imgsrc + '" />' + iconjiu + '</div><div class="m-txt">' + prodlist[i].prodname + '</div><div class="m-price">' + strprice + '</div></a><div class="prod-list-btn"><a id="addShopCart" onclick="detailAddCart(' + prodlist[i].prodid + ', 1);" class="btn btn-default">加入购物车</a><a id="buyProd" onclick="detailAddCart(' + prodlist[i].prodid + ', 0);" class="btn btn-danger">立即购买</a></div></li>';
                    }
                    $('#prodlistul').html(html);
                }
            }
        });
    }
</script>
</asp:Content>
