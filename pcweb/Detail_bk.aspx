<%@ Page Title="卢勤问答平台官方书城" Language="C#" MasterPageFile="~/pcweb/Master.master" %>

<script runat="server">

</script>
<asp:Content ID="Content1" ContentPlaceHolderID="head" Runat="Server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" Runat="Server">
<div style="background:#fff; padding:10px;">
    <div id="prodimg" style="float:left; width:350px; padding:5px;"></div>
    <div style="float:left; margin-left:10px; width:590px; line-height:35px;">
        <div id="prodtitle" style="margin-top:10px; "></div>
        <div style=""><s id="originalprice" class="gray"></s><span id="prodprice" class="red mgleft"></span></div>
        <div class="prod-list-btn-pcweb" style="margin-top:10px;">
            <a id="addShopCart" class="btn btn-default">加入购物车</a>
            <a id="buyProd" class="btn btn-danger">立即购买</a>
        </div>
    </div>
    <div class="clear"></div>
</div>
<div id="proddescription" style="border-top:1px solid #ccc; min-height:300px; background:#fff; padding:15px;">
        
</div>
<div id="myModal" class="modal hide fade" style="left:50%;" tabindex="-1" role="dialog" aria-labelledby="myModalLabel" aria-hidden="true">
    <div class="modal-body">
    <p>已添加购物车</p>
    </div>
    <div class="modal-footer">
    <button class="btn" data-dismiss="modal" aria-hidden="true">再逛逛</button>
    <a href='ShopCart.aspx?productid=<%=Request["productid"] %>' class="btn btn-primary" >去结算</a>
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
        $("#bk_li").attr("class", "current");
        $("#xly_li").attr("class", "");

        if (prodid == '24') {
            $('#addShopCart').attr({ "disabled": "disabled" });
            $('#buyProd').attr({ "disabled": "disabled" });
        }
        else {
            $('#addShopCart').click(function () {
                detailAddCart(prodid, 1);
            });

            $('#buyProd').click(function () {
                detailAddCart(prodid, 0);
            });
        }
    });
   
</script>
</asp:Content>

