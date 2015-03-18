<%@ Page Title="" Language="C#" MasterPageFile="~/Master.master" AutoEventWireup="true" CodeFile="ls_order.aspx.cs" Inherits="ls_order" %>

<asp:Content ID="Content1" ContentPlaceHolderID="MasterHead" Runat="Server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="MasterContent" Runat="Server">
<div class="mainpage">
    <div style="height:40px; line-height:40px; padding:0 10px; background:#fff; position:relative;">
        <a href="Default.aspx" class="returnA"> </a>
        <span class="titleSpan">我的订单</span>
    </div>
    <div style="background:#f0f0f0; margin:10px; padding:10px;">
        <ul class="ls-order-ul">
            <li><a class="ok">全部</a></li>
            <li><a>待付款</a></li>
            <li><a>待发货</a></li>
            <li><a>待收货</a></li>
        </ul>
        <div class="clear"></div>
    </div>
    <div class="m-dcontent" style="margin:10px; padding:10px 20px;">
        <div class="ls-order-title">
            <div style="float:left;">订单编号</div>
            <div style="float:right;">2015-03-16 17:17:41</div>
            <div class="clear"></div>
        </div>
        <a class="ls-order-prod rel">
            <p class="lop-img"><img src="images/prodimg/wchj1d43fg.jpg" /></p>
            <p class="lop-name">卢勤老师图书套装，共10本，包含男孩梦、..</p>
            <p class="lop-num">数量：1</p>
            <p class="lop-price o-price">¥288.00</p>
        </a>
        <a class="ls-order-prod rel">
            <p class="lop-img"><img src="images/prodimg/wchj1d43fg.jpg" /></p>
            <p class="lop-name">卢勤老师图书套装，共10本，包含男孩梦、..</p>
            <p class="lop-num">数量：1</p>
            <p class="lop-price o-price">¥288.00</p>
        </a>
        <p class="ls-order-num">数量：2</p>
        <p class="ls-order-state">订单状态：<em class="o-state-close">已关闭</em></p>
        <p class="ls-order-total"><span> 运费：<em class="o-price" style=" padding-right: 20px;">¥12.00</em>总价：<em class="o-price">¥326.80</em></span></p>
        <div class="clear"></div>
    </div>

    <div class="clear" style="height:20px;"></div>
</div>
</asp:Content>

