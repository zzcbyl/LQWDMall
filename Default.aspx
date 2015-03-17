<%@ Page Title="" Language="C#" MasterPageFile="~/Master.master" AutoEventWireup="true" CodeFile="Default.aspx.cs" Inherits="_Default" %>

<asp:Content ID="Content1" ContentPlaceHolderID="MasterHead" Runat="Server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="MasterContent" Runat="Server">
<div style="width:100%;">
    <img src="images/mall-banner.jpg" width="100%" />
</div>
<div class="m-wrap">
    <ul class="m-ul rel">
        <asp:Repeater ID="Repeater1" runat="server">
            <ItemTemplate>
                <li class="m-li left rel">
                    <a href='Detail.aspx?productid=<%# Eval("prodid") %>'>
                        <div class="pd5"><img src='<%# Util.ApiDomainString + Eval("imgsrc").ToString() %>' /></div>
                        <div class="m-txt"><%# Eval("prodname") %></div>
                        <div class="m-price"><span class="red">¥<%# Math.Round(decimal.Parse(Eval("price").ToString()),2) %></span></div>
                    </a>
                </li>
            </ItemTemplate>
        </asp:Repeater>
    </ul>
    <div id="nodata" runat="server" visible="false" style="text-align:center; margin:40px 0;">
        暂无数据
    </div>
    <div class="clear" style="height:60px;"></div>
    <div class="m-bottom">
        <ul id="footermenu">
            <li id="ftm-type">
                <div>商品分类</div>
            </li>
            <li id="ftm-user">
                <div>个人中心</div>
            </li>
            <li id="ftm-cart">
                <div><a href="ShopCart.aspx">购物车</a></div>
            </li>
        </ul>
        <div class="clear"></div>
    </div>
</div>
</asp:Content>

