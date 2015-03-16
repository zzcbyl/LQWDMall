<%@ Page Title="" Language="C#" MasterPageFile="~/Master.master" AutoEventWireup="true" CodeFile="ls_address.aspx.cs" Inherits="ls_address" %>

<asp:Content ID="Content1" ContentPlaceHolderID="MasterHead" Runat="Server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="MasterContent" Runat="Server">
<div class="mainpage">
    <div style="height:40px; line-height:40px; padding:0 10px; background:#fff;">
        <a href="Default.aspx"><<返回</a>
        <span style="margin-left:100px;">我的地址</span>
    </div>
    <div style="background:#fff; margin:10px 0; padding:10px; line-height:22px;">
        <div style="padding:10px; line-height:30px;" class="rel">
            <div>张忠诚 <p style="float:right;">18001292506</p></div>
            <div>北京 北京 朝阳区 青年路大悦公寓北楼2609</div>
        </div>
        <div style="padding:10px; line-height:30px; border-top:1px solid #f2f2f2;" class="rel">
            <div class="radio" style="float:left; margin-top:10px;"><label><input type="radio" />默认地址</label></div>
            <div style="float:right;">
                <a class="add_upd" style="float:left; border-right:1px solid #f2f2f2;"></a>
                <a class="add_del" style="float:right;"></a>
            </div>
            <div class="clear"></div>
        </div>
    </div>
    <div style="background:#fff; margin:10px 0; padding:10px; line-height:22px;">
        <div style="padding:10px; line-height:30px;" class="rel">
            <div>张忠诚 <p style="float:right;">18001292506</p></div>
            <div>北京 北京 朝阳区 青年路大悦公寓北楼2609</div>
        </div>
        <div style="padding:10px; line-height:30px; border-top:1px solid #f2f2f2;" class="rel">
            <div class="radio" style="float:left; margin-top:10px;"><label><input type="radio" />默认地址</label></div>
            <div style="float:right;">
                <a class="add_upd" style="float:left; border-right:1px solid #f2f2f2;"></a>
                <a class="add_del" style="float:right;"></a>
            </div>
            <div class="clear"></div>
        </div>
    </div>

    <div class="clear" style="height:60px;"></div>
    <div class="m-bottom">
        <ul id="footermenu">
            <li style="width:100%; height:50px; padding-top:8px; text-align:right;">
                <a><button type="button" class="btn btn-default" style="width:40%;">修改收货地址</button></a>
                <a style="margin:0 10px;"><button type="button" class="btn btn-danger" style="width:40%;">添加新地址</button></a>
            </li>
        </ul>
        <div class="clear"></div>
    </div>
</div>
</asp:Content>

