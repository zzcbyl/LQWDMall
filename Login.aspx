<%@ Page Title="" Language="C#" MasterPageFile="~/Master.master" AutoEventWireup="true" CodeFile="Login.aspx.cs" Inherits="Login" %>

<asp:Content ID="Content1" ContentPlaceHolderID="MasterHead" Runat="Server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="MasterContent" Runat="Server">
<div style="width:100%;">
    <img src="images/mall-banner.jpg" width="100%" />
</div>
<div class="mainpage">
    <div style="background:#fff; margin:10px; padding:10px 10px 50px 10px;">
        <div style="padding:30px 0; font-size:20px; text-align:center;"">用户登录</div>
        <div style="padding-left:80px; position:relative;"><span style="position:absolute; left:5px; top:3px;" >用户名：</span><input type="text" style="width:95%;" /></div>
        <div style="padding-left:80px; position:relative;"><span style="position:absolute; left:5px; top:3px;" >　密码：</span><input type="password" style="width:95%;" /></div>
        <div style="margin-top:20px;"><a href="Default.aspx"><button type="button" style="width:100%; padding:8px;" class="btn btn-danger">确认登陆</button></a></div>
    </div>
</div>
</asp:Content>

