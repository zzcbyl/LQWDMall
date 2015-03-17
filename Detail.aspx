<%@ Page Title="" Language="C#" MasterPageFile="~/Master.master" AutoEventWireup="true" CodeFile="Detail.aspx.cs" Inherits="Detail" %>

<%@ Register src="RecommendControl.ascx" tagname="RecommendControl" tagprefix="uc1" %>

<asp:Content ID="Content1" ContentPlaceHolderID="MasterHead" Runat="Server">
    <link href="style/proddetail.css" rel="stylesheet" type="text/css" />
    <script src="script/touchslider.js" type="text/javascript"></script>
    <script src="script/zepto_min.js" type="text/javascript"></script>
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="MasterContent" Runat="Server">
<div class="mainpage">
    <div style="height:40px; line-height:40px; padding:0 10px; background:#fff; position:relative;">
        <a href="Default.aspx" class="returnA"> </a>
    </div>
    <div class="m-dcontent" style="margin-top:10px;">
        <%--<div class="hdp-box rel" style="border:1px solid #ccc;">
            <div id="slider" class="swipe">
		        <ul class="piclist">
			        <li><img src="images/explorations1.jpg"></li>
			        <li><img src="images/explorations2.jpg"></li>
			        <li><img src="images/explorations3.jpg"></li>
			        <li><img src="images/fiftyandtwothirds3.jpg"></li>
		        </ul>
	        </div>
            <nav>
                <ul id="position">
                    <li class="on"></li>
                    <li class=""></li>
                    <li class=""></li>
                    <li class=""></li>
                </ul>
            </nav>
        </div>--%>
        <div id="prodimg" style="border:1px solid #ccc;">
            
        </div>
        <div id="prodtitle" style="line-height:22px; font-size:16px; padding:10px 0;">
        </div>
        <div class="m-dprice"><span class="red" id="prodprice"></span></div>
        <div class="m-express" style="display: block;">
            <span>运费: ¥12.00</span>
        </div>
    </div>
    <div id="proddescription" class="m-ddescription">
    </div>

    <uc1:RecommendControl ID="RecommendControl1" runat="server" />

    <div class="clear" style="height:60px;"></div>
    <div class="m-bottom">
        <div class="d-footermenu">
            <div style="float:left; width:30%;">
                <a href="Default.aspx" style="width:45%; display:inline-block;">首页</a>
                <a href="ShopCart.aspx" style="width:45%; display:inline-block;">购物车</a>
            </div>
            <div style="float:left; width:70%;">
                <a class="btn btn-default" style="width:45%; padding-left:0; padding-right:0;" href="ShopCart.aspx">加入购物车</a>
                <a class="btn btn-danger" style="width:45%; padding-left:0; padding-right:0;" href="ShopCart.aspx">立即购买</a>
            </div>
            <div class="clear"></div>
        </div>
    </div>
</div>

<script type="text/javascript">
    $(document).ready(function () {
        $.post(domain + 'api/product_get_detail.aspx', { productid: QueryString('productid'), random: Math.random() }, function (data) {
            $('#prodtitle').html(data.prodname);
            $('#proddescription').html(data.description);
            $('#prodimg').html('<img src="' + domain + data.images[0].src + '" width="100%" />');
            $('#prodprice').html('¥' + data.price);
        }, 'json');

        //        var bullets = document.getElementById('position').getElementsByTagName('li');
        //        var tt = new TouchSlider({ id: 'slider', 'auto': '-1', fx: 'ease-out', direction: 'left', speed: 600, timeout: 5000, 'before': function (index) {
        //            var i = bullets.length;
        //            while (i--) {
        //                bullets[i].className = ' ';
        //            }
        //            bullets[index].className = 'on';
        //        } 
        //        });
    });
</script>
</asp:Content>

