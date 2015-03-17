<%@ Page Title="" Language="C#" MasterPageFile="~/Master.master" AutoEventWireup="true" CodeFile="SubmitOrder.aspx.cs" Inherits="SubmitOrder" %>

<asp:Content ID="Content1" ContentPlaceHolderID="MasterHead" Runat="Server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="MasterContent" Runat="Server">
<div class="mainpage">
    <div style="height:40px; line-height:40px; padding:0 10px; background:#fff;">
        <a href="Default.aspx"><<返回</a>
        <span style="margin-left:100px;">确认下单</span>
    </div>
    <div style="background:#fff; margin:10px; padding:10px; line-height:22px;" class="rel" onclick="javascript:location.href='sel_address.aspx';">
        <div>张忠诚</div>
        <div>18001292506</div>
        <div>北京 北京 朝阳区 青年路大悦公寓北楼2609</div>
        <div style="position:absolute; right:10px; top:30px;">></div>
    </div>
    <div style="background:#fff; margin:10px; padding:10px; line-height:22px; margin-bottom:0;">
        在线支付
    </div>
    <div style="background:#f0f0f0; margin:10px; padding:10px; line-height:30px; margin-top:0;">
        <div class="radio"><label><input type="radio"> 微信支付</label></div>
        <div class="radio"><label><input type="radio"> 银行卡支付</label></div>
    </div>
    <div style="background:#fff; margin:10px; padding:10px; line-height:22px;">
        <ul>
            <li style="padding:15px; position:relative; height:60px; border-bottom:1px solid #e3e2e2;">
                <a style="left:10px; top:13px; position:absolute;"><img src="image/111.jpg" width="50px" height="50px" /></a>
                <a style="margin-left:60px; margin-right:70px; display:block; height:36px; line-height:18px; overflow:hidden;">卢勤老师图书套装，共10本，包含男孩梦、女孩梦、和烦恼说再见、把孩子培养成财富、告诉孩子你真棒、告诉世界我能行、好父母好孩子、写给年轻妈妈、写卢勤老师图书套装，共10本，包含男孩梦、女孩梦、和烦恼说再见、把孩子培养成财富、告诉孩子你真棒、告诉世界我能行、好父母好孩子、写给年轻妈妈、写</a>
                <a style="margin-left:60px; margin-right:70px; display:block; height:18px; line-height:18px; color:#666; font-size:12px; margin-top:5px;">无型号</a>
                <a style="top:13px; right:5px; position:absolute"><span class="red">¥22.55</span></a>
                <a style="top:40px; right:5px; position:absolute; font-size:12px;">X 1</a>
            </li>
            <li style="padding:15px; position:relative; height:60px; border-bottom:1px solid #e3e2e2;">
                <a style="left:10px; top:13px; position:absolute;"><img src="image/111.jpg" width="50px" height="50px" /></a>
                <a style="margin-left:60px; margin-right:70px; display:block; height:36px; line-height:18px; overflow:hidden;">卢勤老师图书套装，共10本，包含男孩梦、女孩梦、和烦恼说再见、把孩子培养成财富、告诉孩子你真棒、告诉世界我能行、好父母好孩子、写给年轻妈妈、写卢勤老师图书套装，共10本，包含男孩梦、女孩梦、和烦恼说再见、把孩子培养成财富、告诉孩子你真棒、告诉世界我能行、好父母好孩子、写给年轻妈妈、写</a>
                <a style="margin-left:60px; margin-right:70px; display:block; height:18px; line-height:18px; color:#666; font-size:12px; margin-top:5px;">无型号</a>
                <a style="top:13px; right:5px; position:absolute"><span class="red">¥22.55</span></a>
                <a style="top:40px; right:5px; position:absolute; font-size:12px;">X 1</a>
            </li>
            <li style="padding:15px; position:relative; height:40px;">
                <a style="top:13px; right:5px; position:absolute; color:#666">运费: <span class="red">¥22.55</span></a>
                <a style="top:40px; right:5px; position:absolute; color:#666">共2件商品，合计: <span class="red">¥22.55</span></a>
            </li>
        </ul>
    </div>
    <div style="background:#fff; margin:10px; padding:10px; height:100px; position:relative;">
        <div style="padding-right:10px; height:60px;" class="rel">   
            <textarea style="width:100%; padding:5px; height:40px; line-height:20px;" placeholder="（选填）给我们留言"></textarea></div>
        <div style="padding-right:10px;" class="rel">
            <input type="text" style="width:50%; padding:5px; line-height:20px;"  placeholder="（选填）微信号" />
        </div>
    </div>
    <div class="clear" style="height:60px;"></div>
    <div class="m-bottom">
        <ul id="footermenu">
            <li style="width:100%; height:50px; ">
                <a href="SubmitOrder.aspx" style="float:right; margin:8px 10px 0 0;"><button type="button" class="btn btn-danger">提交订单</button></a>
                <a style="float:right; margin:13px 10px 0 0;"><strong>应付总额: <span class="red">¥22.55</span></strong></a>
            </li>
        </ul>
        <div class="clear"></div>
    </div>
</div>
</asp:Content>

