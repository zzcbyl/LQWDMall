<%@ Page Title="" Language="C#" MasterPageFile="~/Master.master" %>

<asp:Content ID="Content1" ContentPlaceHolderID="MasterHead" Runat="Server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="MasterContent" Runat="Server">
<div class="mainpage">
    <div class="titleNav">
        <a href="Default.aspx" class="returnA"> </a>
        <span class="titleSpan">个人中心</span>
    </div>
    <div class="m-dcontent" style="margin-top:10px;">
        <ul>
            <li class="u-order-li">
                <a href="ls_order.aspx" style="border-bottom:none;"><em id="orderLi"><%--<span class="unreadMsg">2</span>--%></em>我的订单</a>
            </li>
            <%--<li class="u-order-li">
                <a class="li-right" href="ls_address.aspx"><em id="addressLi"><span></span></em>收获地址</a>
            </li>
            <li class="u-order-li">
                <a style="border-bottom:none;"><em id="collectLi"><span></span></em>我的收藏</a>
            </li>--%>
            <li class="u-order-li">
                <a style="border-bottom:none;" class="li-right"><em id="infoLi"><span></span></em>我的消息</a>
            </li>
        </ul>
        <div class="clear"></div>
    </div>
   
</div>
</asp:Content>

