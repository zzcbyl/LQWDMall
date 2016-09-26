<%@ Page Title="购物车-悦长大平台官方书城" Language="C#" MasterPageFile="~/pcweb/Master.master" %>

<script runat="server">
    
    
</script>

<asp:Content ID="Content1" ContentPlaceHolderID="head" Runat="Server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" Runat="Server">
<div style="min-height:600px;">
    <div style="background:#fff; margin:10px;">
        <ul id="proditems">
            
        </ul>
    </div>
</div>
<div class="clear" style="height:80px;"></div>
<div class="m-bottom">
    <div style="height:30px; line-height:30px; width:980px; margin:0 auto; background:#fff;">
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
        $("#bk_li").attr("class", "current");
        $("#xly_li").attr("class", "");
    });
</script>
</asp:Content>

