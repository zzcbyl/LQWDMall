<%@ Page Title="" Language="C#" MasterPageFile="~/Master.master" AutoEventWireup="true" CodeFile="Detail.aspx.cs" Inherits="Detail" %>

<%@ Register src="RecommendControl.ascx" tagname="RecommendControl" tagprefix="uc1" %>

<asp:Content ID="Content1" ContentPlaceHolderID="MasterHead" Runat="Server">
    <%--<link href="style/proddetail.css" rel="stylesheet" type="text/css" />
    <script src="script/touchslider.js" type="text/javascript"></script>
    <script src="script/zepto_min.js" type="text/javascript"></script>--%>
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="MasterContent" Runat="Server">
<div class="mainpage">
    <div style="height:40px; line-height:40px; padding:0 10px; background:#fff; position:relative;">
        <a href="Default.aspx" class="returnA"> </a>
    </div>
    <div class="m-dcontent" style="margin-top:10px;">
        <div id="prodimg" style="border:1px solid #ccc;">
            
        </div>
        <div id="prodtitle" style="line-height:22px; font-size:16px; padding:10px 0;">
        </div>
        <div class="m-dprice"><span class="red" id="prodprice"></span></div>
        <%--<div class="m-express" style="display: block;">
            <span>运费: ¥12.00</span>
        </div>--%>
    </div>
    <div id="proddescription" class="m-ddescription">
    </div>

    <uc1:RecommendControl ID="RecommendControl1" runat="server" />

    <div class="clear" style="height:60px;"></div>
    <div class="m-bottom">
        <div id="footermenu">
            <div style="float:left; width:30%;">
                <a href="Default.aspx" style="width:45%; display:inline-block;">首页</a>
                <a id="my-cart" class="rel" href="ShopCart.aspx" style="width:45%; display:inline-block;">
                    购物车
                    <em id="my_cart_em" class="abs" style="display: none;"></em>
                </a>
            </div>
            <div style="float:left; width:70%;">
                <a id="addShopCart" class="btn btn-default" style="width:45%; padding-left:0; padding-right:0;" >加入购物车</a>
                <a id="buyProd" class="btn btn-danger" style="width:45%; padding-left:0; padding-right:0;" >立即购买</a>
            </div>
            <div class="clear"></div>
        </div>
    </div>
    <div id="myModal" class="modal hide fade" tabindex="-1" role="dialog" aria-labelledby="myModalLabel" aria-hidden="true">
      <div class="modal-body">
        <p>已添加购物车</p>
      </div>
      <div class="modal-footer">
        <button class="btn" data-dismiss="modal" aria-hidden="true">再逛逛</button>
        <a href="ShopCart.aspx" class="btn btn-primary" >去结算</a>
      </div>
    </div>
</div>

<script type="text/javascript">
    $(document).ready(function () {
        var prodid = QueryString('productid');
        if (prodid == null) {
            alert('商品参数有误');
            return;
        }
        filldetail(prodid);
        totalcart('my_cart_em');


        $('#addShopCart').click(function () {
            detailAddCart(prodid);
        });

        $('#buyProd').click(function () {
            location.href = "ShopCart.aspx?prodid=" + prodid;
        });
    });
</script>
</asp:Content>

