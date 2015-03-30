<%@ Page Title="" Language="C#" MasterPageFile="~/Master.master" %>

<asp:Content ID="Content1" ContentPlaceHolderID="MasterHead" Runat="Server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="MasterContent" Runat="Server">
<div class="mainpage">
    <div class="titleNav">
        <a href="Default.aspx" class="returnA"> </a>
        <span class="titleSpan">我的地址</span>
    </div>
    <div style="background:#fff; margin:10px 0; padding:10px; line-height:22px;">
        <div style="padding:10px; line-height:30px; padding-right:80px;" class="rel">
            <div>张忠诚 <p style="float:right;">18001292506</p></div>
            <div>北京 北京 朝阳区 青年路大悦公寓北楼2609</div>
            <span style="position:absolute; right:0px; top:0px; height:100%; width:65px; border-left:1px solid #f2f2f2; display:block;">
                <em class="red-em" style="margin:32px auto;"><i> </i></em>
            </span>
        </div>
    </div>
    <div style="background:#fff; margin:10px 0; padding:10px; line-height:22px;">
        <div style="padding:10px; line-height:30px; padding-right:80px;" class="rel">
            <div>张忠诚 <p style="float:right;">18001292506</p></div>
            <div>北京 北京 朝阳区 青年路大悦公寓北楼2609</div>
        </div>
    </div>

    <div class="clear" style="height:60px;"></div>
    <div class="m-bottom">
        <ul id="footermenu">
            <li style="width:100%; text-align:right;">
                <a href="ls_address.aspx"><button type="button" class="btn btn-default" style="width:40%;">修改收货地址</button></a>
                <a href="ad_address.aspx" style="margin:0 10px;"><button type="button" class="btn btn-danger" style="width:40%;">添加新地址</button></a>
            </li>
        </ul>
        <div class="clear"></div>
    </div>
</div>
</asp:Content>

