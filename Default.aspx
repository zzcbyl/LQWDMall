<%@ Page Title="卢勤问答平台官方书城" Language="C#" MasterPageFile="~/Master.master" %>

<asp:Content ID="Content1" ContentPlaceHolderID="MasterHead" Runat="Server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="MasterContent" Runat="Server">
<div style="width:100%;">
    <img src="images/mall-banner.jpg" width="100%" />
</div>
<div class="m-wrap">
    <ul id="prodlistul" class="m-ul rel">
        
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
<script type="text/javascript">
    $(document).ready(function () {
        $('#prodlistul').html('<li><div class="loading"><img src="images/loading.gif" /><br />加载中...</div></li>');
        $.post(domain + 'api/product_get_all.aspx', { random: Math.random() }, function (data) {
            var prodlist = data.data;
            var html = "";
            for (var i = 0; i < prodlist.length; i++) {
                html += '<li class="m-li left rel"><a href="Detail.aspx?productid=' + prodlist[i].prodid + '"><div class="pd5"><img src="' + domain + prodlist[i].imgsrc + '" /></div><div class="m-txt">' + prodlist[i].prodname + '</div><div class="m-price"><span class="red">¥' + parseInt(prodlist[i].price) / 100 + '</span></div></a></li>';
            }
            $('#prodlistul').html(html);
        }, 'json');

        totalcart('my_cart_em');
    });
</script>
</asp:Content>

