<%@ Page Title="" Language="C#" MasterPageFile="~/Master.master" AutoEventWireup="true" CodeFile="ShopCart.aspx.cs" Inherits="ShopCart" %>

<asp:Content ID="Content1" ContentPlaceHolderID="MasterHead" Runat="Server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="MasterContent" Runat="Server">
<div class="mainpage">
    <div style="height:40px; line-height:40px; padding:0 10px; background:#fff;position:relative;">
        <a href="Default.aspx" class="returnA"> </a>
        <span class="titleSpan">购物车</span>
    </div>
    <div style="background:#fff; margin:10px;">
        <ul>
            <li style="padding:10px; position:relative; height:90px; border-bottom:1px solid #e3e2e2;">
                <a style="left:8px; top:45px; position:absolute;"><input type="checkbox" /></a>
                <a style="left:30px; top:13px; position:absolute;"><img src="image/111.jpg" width="50px" height="50px" /></a>
                <a style="margin-left:80px; display:block; height:36px; line-height:18px; overflow:hidden;">卢勤老师图书套装，共10本，包含男孩梦、女孩梦、和烦恼说再见、把孩子培养成财富、告诉孩子你真棒、告诉世界我能行、好父母好孩子、写给年轻妈妈、写卢勤老师图书套装，共10本，包含男孩梦、女孩梦、和烦恼说再见、把孩子培养成财富、告诉孩子你真棒、告诉世界我能行、好父母好孩子、写给年轻妈妈、写</a>
                <a style="margin-left:80px; display:block; height:18px; line-height:18px; color:#999; font-size:12px; margin-top:5px;">无型号</a>
                <div style="margin-left:20px;">
                    <div style="float:left; margin-top:5px;">
                        <span class="red">¥22.55</span></div>
                    <div style="float:right;">
                        <%--<center class="cart-prod-num">
                            <a>－</a>
                            <input type="text" value="1">
                            <a>＋</a>
                        </center>--%>
                        <div class="input-append spinner" data-trigger="spinner">
                          <input type="text" value="1" data-rule="quantity">
                          <div class="add-on">
                            <a href="javascript:;" class="spin-up" data-spin="up"><i class="icon-sort-up"></i></a>
                            <a href="javascript:;" class="spin-down" data-spin="down"><i class="icon-sort-down"></i></a>
                          </div>
                        </div>
                    </div>
                    <div class="clear"></div>
                </div>
            </li>
            <li style="padding:10px; position:relative; height:90px; border-bottom:1px solid #e3e2e2;">
                <a style="left:8px; top:45px; position:absolute;"><input type="checkbox" /></a>
                <a style="left:30px; top:13px; position:absolute;"><img src="image/111.jpg" width="50px" height="50px" /></a>
                <a style="margin-left:80px; display:block; height:36px; line-height:18px; overflow:hidden;">卢勤老师图书套装，共10本，包含男孩梦、女孩梦、和烦恼说再见、把孩子培养成财富、告诉孩子你真棒、告诉世界我能行、好父母好孩子、写给年轻妈妈、写卢勤老师图书套装，共10本，包含男孩梦、女孩梦、和烦恼说再见、把孩子培养成财富、告诉孩子你真棒、告诉世界我能行、好父母好孩子、写给年轻妈妈、写</a>
                <a style="margin-left:80px; display:block; height:18px; line-height:18px; color:#999; font-size:12px; margin-top:5px;">无型号</a>
                <div style="margin-left:20px;">
                    <div style="float:left; margin-top:5px;">
                        <span class="red">¥22.55</span></div>
                    <div style="float:right;">
                        <div class="input-append spinner" data-trigger="spinner">
                          <input type="text" value="1" data-rule="quantity">
                          <div class="add-on">
                            <a href="javascript:;" class="spin-up" data-spin="up"><i class="icon-sort-up"></i></a>
                            <a href="javascript:;" class="spin-down" data-spin="down"><i class="icon-sort-down"></i></a>
                          </div>
                        </div>
                    </div>
                    <div class="clear"></div>
                </div>
            </li>
        </ul>
    </div>
    <div class="clear" style="height:60px;"></div>
    <div class="m-bottom">
        <ul id="footermenu">
            <li style="width:100%; ">
                <a href="SubmitOrder.aspx" style="float:right; margin:8px 10px 0 0;"><button type="button" class="btn btn-danger">继续购买(2)</button></a>
            </li>
        </ul>
        <div class="clear"></div>
    </div>
</div>
</asp:Content>

