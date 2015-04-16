<%@ Page Title="" Language="C#" MasterPageFile="~/pcweb/Master.master" %>

<script runat="server">
    
    
</script>

<asp:Content ID="Content1" ContentPlaceHolderID="head" Runat="Server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" Runat="Server">
<div class="titleNav">
    <%--<a href="ShopCart.aspx" class="returnA"> </a>--%>
    <span class="titleSpan">购物车</span>
</div>
<div style="min-height:300px;">
    <div style="background:#fff; margin:10px;">
        <ul id="proditems">
        </ul>
    </div>
</div>
<div class="clear" style="height:80px;"></div>
<div class="m-bottom">
    <div style="height:30px; line-height:30px; width:100%; margin:0 auto; background:#fff;">
        <p style="color:#919191; float:left; margin-left:20px;">不含运费</p>
        <p style="float:right; margin-right:20px;">合计：<span id="cartTotal" class="red"></span></p>
    </div>
    <ul id="footermenu">
        <li style="width:100%; ">
            <a id="sc_submit" href="javascript:void(0);" style="float:right; margin:8px 10px 0 0;"><button type="button" class="btn btn-danger">继续购买</button></a>
        </li>
    </ul>
    <div class="clear"></div>
</div>
<script type="text/javascript">
    $(document).ready(function () {
        fillcart();
    });
</script>
</asp:Content>

