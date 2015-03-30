<%@ Page Title="" Language="C#" MasterPageFile="~/Master.master" %>

<asp:Content ID="Content1" ContentPlaceHolderID="MasterHead" Runat="Server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="MasterContent" Runat="Server">
<div style="width:100%;">
    <img src="images/mall-banner.jpg" width="100%" />
</div>
<div style="background:#fff; padding:10px;">
    1、本店为卢勤问答平台官方书城，所有图书均有现货。2、本店的运费遵循市场规则，您可以自行拍下。3、如果有任何疑问，或者其他要求，可以在线咨询客服。
</div>
<div style="background:#fff; width:100%; margin-top:10px; ">
    <ul class="nav-default">
        <li id="type-suit">套装</li>
        <li id="type-single">单品</li>
    </ul>
    <div class="clear"></div>
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

        $("#type-single").click(function () {
            filllist(1);
        });

        $("#type-suit").click(function () {
            filllist(2);
        });
    });

    function filllist(typeid) {
        if (typeid == 1) {
            $("#type-single").css("color", "#d93229");
            $("#type-suit").css("color", "");
        }
        else if (typeid == 2) {
            $("#type-suit").css("color", "#d93229");
            $("#type-single").css("color", "");
        }
        $('#prodlistul').html('<li><div class="loading"><img src="images/loading.gif" /><br />加载中...</div></li>');
        $.post(domain + 'api/product_get_all.aspx', { random: Math.random() }, function (data) {
            var prodlist = data.data;
            var html = "";
            for (var i = 0; i < prodlist.length; i++) {
                if (typeid != 0 && prodlist[i].prodtypeid != typeid)
                    continue;
                html += '<li class="m-li left rel"><a href="Detail.aspx?productid=' + prodlist[i].prodid + '"><div class="pd5"><img src="' + domain + prodlist[i].imgsrc + '" /></div><div class="m-txt">' + prodlist[i].prodname + '</div><div class="m-price"><span class="red">¥' + parseInt(prodlist[i].price) / 100 + '</span></div></a><div class="prod-list-btn"><!--<a id="addShopCart" onclick="detailAddCart(' + prodlist[i].prodid + ', 1);" class="btn btn-default">加入购物车</a>--><a id="buyProd" onclick="detailAddCart(' + prodlist[i].prodid + ', 0);" class="btn btn-danger">立即购买</a></div></li>';
            }
            $('#prodlistul').html(html);
        }, 'json');
    }
</script>
</asp:Content>

