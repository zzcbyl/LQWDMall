﻿<%@ Page Title="" Language="C#" MasterPageFile="~/Master.master" %>

<asp:Content ID="Content1" ContentPlaceHolderID="MasterHead" Runat="Server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="MasterContent" Runat="Server">
<div class="mainpage">
    <div class="titleNav">
        <a href="Default.aspx" class="returnA"> </a>
        <span class="titleSpan">添加地址</span>
    </div>
    <div style="background:#fff; margin:10px; padding:20px 10px 10px; line-height:22px;" class="rel">
        <p class="add_list_p rel">
            <label>收货人</label>
            <input type="text" />
        </p>
        <p class="add_list_p rel">
            <label>手机号码</label>
            <input type="text" />
        </p>
        <p class="add_list_p rel">
            <label>所在地区</label>
            <select></select>
        </p>
        <p class="add_list_p rel">
            <select></select>
        </p>
        <p class="add_list_p rel">
            <select></select>
        </p>
        <p class="add_list_p rel">
            <label>详细地址</label>
            <input type="text" />
        </p>
    </div>
    
    <div class="clear" style="height:60px;"></div>
    <div class="m-bottom">
        <ul id="footermenu">
            <li style="width:100%; text-align:right;">
                <a style="margin:0 10px;"><button type="button" class="btn btn-danger" style="width:40%;">确定</button></a>
            </li>
        </ul>
        <div class="clear"></div>
    </div>
</div>
</asp:Content>

