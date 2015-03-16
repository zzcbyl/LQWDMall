<%@ Page Title="" Language="C#" MasterPageFile="~/Master.master" AutoEventWireup="true" CodeFile="Detail.aspx.cs" Inherits="Detail" %>

<%@ Register src="RecommendControl.ascx" tagname="RecommendControl" tagprefix="uc1" %>

<asp:Content ID="Content1" ContentPlaceHolderID="MasterHead" Runat="Server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="MasterContent" Runat="Server">
<div class="mainpage">
    <div style="height:40px; line-height:40px; padding:0 10px; background:#fff;">
        <a href="Default.aspx"><<返回</a>
    </div>
    <div class="m-dcontent" style="margin-top:10px;">
        <div style="border:1px solid #ccc;">
            <img src="image/111.jpg" style="width:100%;" />
        </div>
        <div style="line-height:22px; font-size:16px; padding:10px 0;">
            山东分公司对方告诉对方山东分公司对方告诉对方第三分公司对方告诉对方告诉对方山东分公司对方告诉对方告诉对方告诉对方告诉对方告诉对方告诉对方告诉对方告诉对方
        </div>
        <div class="m-dprice"><span class="red">¥22.55</span></div>
        <div class="m-express" style="display: block;">
            <span>运费: ¥12.00</span>
        </div>
    </div>
    <div class="m-ddescription">
        asdfasdfas阿萨德发射点发烧饭弃我而去围绕区委撒旦法撒旦<br />
        asdfasdfas阿萨德发射点发烧饭弃我而去围绕区委撒旦法撒旦<br />
        asdfasdfas阿萨德发射点发烧饭弃我而去围绕区委撒旦法撒旦<br /><br />
        asdfasdfas阿萨德发射点发烧饭弃我而去围绕区委撒旦法撒旦<br />
        asdfasdfas阿萨德发射点发烧饭弃我而去围绕区委撒旦法撒旦<br />
        asdfasdfas阿萨德发射点发烧饭弃我而去围绕区委撒旦法撒旦<br /><br />
        asdfasdfas阿萨德发射点发烧饭弃我而去围绕区委撒旦法撒旦<br />
        asdfasdfas阿萨德发射点发烧饭弃我而去围绕区委撒旦法撒旦<br />
    </div>

    <uc1:RecommendControl ID="RecommendControl1" runat="server" />

    <div class="clear" style="height:60px;"></div>
    <div class="m-bottom">
        <ul id="footermenu">
            <li>
                首页
            </li>
            <li>
                购物车
            </li>
            <li>
                加入购物车
            </li>
            <li>
                <a href="ShopCart.aspx">立即购买</a>
            </li>
        </ul>
        <div class="clear"></div>
    </div>
</div>
</asp:Content>

