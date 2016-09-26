<%@ Page Language="C#" %>
<%@ Import Namespace="System.Data" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">

<script runat="server">
    public string timeStamp = "";
    public string nonceStr = "e4b6e00dd1f0bf0fcab93b165ae8f";
    public string ticket = "";
    public string shaParam = "";
    public string appId = System.Configuration.ConfigurationSettings.AppSettings["wxappid_dingyue"];
    public int activate = 1;
    public int endState = 0;
    
    protected void Page_Load(object sender, EventArgs e)
    {
        try
        {
            timeStamp = Util.GetTimeStamp();
            ticket = Util.GetTicket();
            string shaString = "jsapi_ticket=" + ticket.Trim() + "&noncestr=" + nonceStr.Trim()
                + "&timestamp=" + timeStamp.Trim() + "&url=" + Request.Url.ToString().Trim();
            shaParam = Util.GetSHA1(shaString);
        }
        catch { }

        if (Request["preopenid"] != null && Request["preopenid"] == Request["openid"])
            this.joinBtn.Visible = true;
        else
            this.joinBtn.Visible = false;

        if (DateTime.Now >= Convert.ToDateTime("2015-05-28 23:00"))
        {
            endState = 1;
        }
        
        if (Request["preopenid"] != null)
        {
            if (Users.IsExistsUser("username", Request["preopenid"]))
            {
                Users user = Users.GetUser("username", Request["preopenid"]);
                if (user != null && int.Parse(user._fields["uid"].ToString()) > 0)
                {
                    Order[] orderArr = Order.GetOrders(int.Parse(user._fields["uid"].ToString()), Convert.ToDateTime("2015-05-08"), Convert.ToDateTime("2015-05-29"));
                    for (int i = 0; i < orderArr.Length; i++)
                    {
                        if (orderArr[i]._fields["paystate"].ToString() == "1")
                        {
                            DataTable dt = orderArr[i].GetOrderDetails();
                            if (dt != null && dt.Rows.Count > 0)
                            {
                                foreach (DataRow row in dt.Rows)
                                {
                                    if (row["product_id"].ToString() == "27")
                                    {
                                        activate = 0;
                                        break;
                                    }
                                }
                            }
                            if (activate == 0)
                                break;
                        }
                    }
                }
            }
        }
    }
</script>

<html xmlns="http://www.w3.org/1999/xhtml">
<head id="Head1" runat="server">
    <meta charset="utf-8">
    <meta name="viewport" content="width=device-width,initial-scale=1,maximum-scale=1,minimum-scale=1,user-scalable=no">
    <meta content="telephone=no" name="format-detection">
    <meta name="apple-touch-fullscreen" content="yes">
    <meta name="apple-mobile-web-app-capable" content="yes">
    <meta name="apple-mobile-web-app-status-bar-style" content="black">
    <title>“放飞梦想我能行”知心姐姐北京精品营</title>
    <script src="script/config.js" type="text/javascript"></script>
    <link href="style/bootstrap.min.css" rel="stylesheet" type="text/css" />
    <link href="style/font-awesome.min.css" rel="stylesheet" type="text/css" />
    <link href="style/bootstrap-spinner.css" rel="stylesheet" type="text/css" />
    <script src="script/jquery-2.0.1.min.js" type="text/javascript"></script>
    <script src="script/bootstrap.js" type="text/javascript"></script>
    <script src="script/jquery.spinner.js" type="text/javascript"></script>
    <link href="style/main.css" rel="stylesheet" type="text/css" />
    <script src="script/common.js" type="text/javascript"></script>
    <link href="style/activity.css" rel="stylesheet" type="text/css" />
</head>
<body>
    <form id="form1" runat="server">
    <div class="mainpage">
        <div class="m-dcontent" style="margin-top:10px;">
            <div id="prodimg" style="border:1px solid #ccc;">
                <img src="images/activity_bj_banner.jpg" width="100%" />
            </div>
            <div class="prod_box">
                <% if (activate == 1)
                       { %>
                <h3>好友帮Ta共砍掉了</h3>
                <p><span class="dfn">¥</span><span class="js_fruit" id="bargainTotal"> -</span></p>
                <div>
                    <div><s class="gray" id="originalprice" style="margin-right:10px;">￥6380</s><span class="red pd5">￥<q class="red" id="prodprice">6380</q></span></div>
                    <div style="margin-top:5px;" id="joinBtn" runat="server" visible="false">按此价格<a onclick="javascript:joinxly();" class="btn btn-danger">报名</a></div>
                </div>
                <%} else { %>
                <h2 style="color:#ff0000">已报名</h2>
                <%} %>
            </div>
        </div>
        <div style="background:#fff; padding:10px; margin-top:10px;">
            <div style="margin-top:5px;">
                　7月23日至7月28日，“放飞梦想我能行”知心姐姐北京精品营即将出发。卢勤老师全程陪同，知心团队精英老师全程带队，这个夏天让孩子和知心团队一起出发，放飞梦想，并且坚定地对梦想喊出“我能行”！　　
                <a style="font-size:12px; color:#0B659D; text-decoration:underline; display:inline-block;" href='http://mall.luqinwenda.com/Detail_xly.aspx?productid=25&openid=<%=Request["openid"] %>'>详细介绍>></a>
            </div>
        </div>
        <div style="background:#fff; padding:10px; margin-top:10px;">
            <h5>砍价规则：</h5>
            <div style="margin-top:5px;">
                　1、点击“帮忙砍一刀”按钮，根据提示完成砍价，每砍一次优惠10元。<br />
                　2、点击“我也要发起”按钮，你也可以发起活动，邀请好友帮忙砍价。<br />
                　3、本活动官方截止结算日期为5月28日，也可以提前结算。<br />
                　4、在活动结束前报名成功，活动即会提前结束。<br />
            </div>
        </div>
        <div class="bargain_people">
            <h3>谁砍过</h3>
            <p>目前<span class="red pd2" id="bargainCount">0</span>位好友一共砍掉了<span class="red pd2" id="bargainAmount">-</span>元</p>
            <div class="bargain_list_scroll">
                <ul id="bargainlist" class="bargain_list_info">
                    
                </ul>
            </div>
        </div>
        
        <div class="clear" style="height:60px;"></div>
        <div class="m-bottom">
            <div id="footermenu">
                <% if (endState == 0) {%>
                    <span class="barmaigin_btn leftbtn btnwith" onclick="ActiveService();">
                        我也要发起
                    </span>
                    <span class="barmaigin_btn rightbtn btnwith" onclick="follwerService();">
                        帮忙砍一刀
                    </span>
                <%} else {%>
                    <span class="no_barmaigin_btn leftbtn btnwith">
                        我也要发起
                    </span>
                    <span class="no_barmaigin_btn rightbtn btnwith">
                        帮忙砍一刀
                    </span>
                <%} %>
                     
                <div class="clear"></div>
            </div>
        </div>
    </div>
    <div id="popbg"></div>
    <div id="popdiv">
        <% if (endState == 0) {%>
        <div style="padding:10px;">
            <img src='http://weixin.luqinwenda.com/get_promote_qrcode_with_background.aspx?openid=<%=Request["preopenid"] %>' style="width:100%" />
            <div style="margin-top:10px; color:#fff; font-size:16px;">
                长按指纹关注悦长大，帮TA砍一刀
            </div>
        </div>
        <%} %>
    </div>
    <div id="popdiv1">
        <div style="padding:10px;">
            <img src='http://weixin.luqinwenda.com/get_promote_qrcode_with_background.aspx?openid=<%=Request["preopenid"] %>' style="width:100%" />
            <div style="margin-top:10px; color:#fff; font-size:16px;">
                长按二维码并识别后关注悦长大，进入该公众服务号后，点击最新收到的图文消息后分享到朋友圈。
            </div>
        </div>
    </div>
    <div id="showShare" style="display:none;" onclick="javascript:document.getElementById('showShare').style.display='none';">
        <div style="width:100%; height:100%; background:#ccc; color:#000; position:absolute; top:0px; left:0px; text-align:center; filter:alpha(opacity=90); -moz-opacity:0.9;-khtml-opacity: 0.9; opacity: 0.9;  z-index:9;"></div>
        <div style="width:170px; height:200px;  color:#000; position:absolute;  right:2pt; top:10pt; z-index:10; font-size:20pt;  background:url(images/jiantou.png) no-repeat"></div>
        <div style="width:149px; height:200px;  color:#000; position:absolute; top:60pt; margin-left:70pt; z-index:20; font-size:15pt; line-height:30pt; text-align:center;">点击右上角“┇”<br />分享到朋友圈</div>

    <script type="text/javascript">
        var shareTitle = "推荐给你一个好活动"; //标题
        var imgUrl = "http://mall.luqinwenda.com/images/activity_bj_icon.jpg"; //图片
        var descContent = "大家快来帮我砍价砍到0"; //简介
        var lineLink = "http://mall.luqinwenda.com/Activity_bj.aspx?source=1&preopenid="; //链接
        var prodid = 27;
        if (QueryString('openid') == null) {
            var encodeDomain = encodeURIComponent(document.URL);
            location.href = "http://weixin.luqinwenda.com/authorize.aspx?callback=" + encodeDomain;
        }
        lineLink += QueryString('preopenid');
        $(document).ready(function () {
            if (prodid == null) {
                alert('商品参数有误');
                return;
            }

            var from = QueryString('source');
            if (from != null) {
                setCookie('from', from);
            }
            else {
                from = getCookie('from');
            }
            if (QueryString('preopenid') != null) {
                fillbarmaigin(QueryString('preopenid'));
            }
        });

        function joinxly() {
            location.href = 'Join_xly.aspx?productid=' + prodid + '&followerAmount=' + ($("#bargainAmount").html() == '-' ? "" : $("#bargainAmount").html());
        }
//        function LaunchJump() {
//            location.href = 'Activity_bj.aspx?preopenid=' + QueryString('openid') + "&openid=" + QueryString('openid') + "&source=1";
//        }

        function follwerService() {
            $("#popbg").attr("onclick", "follwerService();");
            $("#popdiv1").fadeOut();
            if ($("#popdiv").css("display") == "none") {
                $("#popbg").css({ height: $(document).height()})
                var A = window.pageYOffset || document.documentElement.scrollTop || document.body.scrollTop || 0;
                var D = Math.min(document.body.clientHeight, document.documentElement.clientHeight);
                if (D == 0) {
                    D = Math.max(document.body.clientHeight, document.documentElement.clientHeight)
                }
                var topheight = (A + (D - 300) / 2) - 120 + "px";
                $("#popdiv").css({ top: topheight });
                $("#popbg").fadeIn();
                $("#popdiv").fadeIn();
            }
            else {
                $("#popbg").fadeOut();
                $("#popdiv").fadeOut();
            }
        }

        function ActiveService() {
            if (QueryString("fromsource") == "message" || QueryString("fromsource") == "subscribe") {
                $("#showShare").show();
                return;
            }
            $("#popbg").attr("onclick", "ActiveService();");
            $("#popdiv").fadeOut();
            if ($("#popdiv1").css("display") == "none") {
                $("#popbg").css({ height: $(document).height() })
                var A = window.pageYOffset || document.documentElement.scrollTop || document.body.scrollTop || 0;
                var D = Math.min(document.body.clientHeight, document.documentElement.clientHeight);
                if (D == 0) {
                    D = Math.max(document.body.clientHeight, document.documentElement.clientHeight)
                }
                var topheight = (A + (D - 300) / 2) - 90 + "px";
                $("#popdiv1").css({ top: topheight });
                $("#popbg").fadeIn();
                $("#popdiv1").fadeIn();
            }
            else {
                $("#popbg").fadeOut();
                $("#popdiv1").fadeOut();
            }
        }


        function fillbarmaigin(open_id) {
            $('#bargainlist').html('<li class="loading"><img src="images/loading.gif" /><br />加载中...</li>');
            //alert(open_id);
            $.ajax({
                type: "get",
                async: false,
                url: domain + 'api/promote_get_sub_users.aspx',
                data: { openid: open_id, random: Math.random() },
                success: function (data, textStatus) {
                    //alert(data);
                    var obj = eval('(' + data + ')');
                    var innerHtml = '';
                    if (obj != null) {
                        //alert(obj['sub-open-id-info'].length);
                        var infoObj;
                        var infoDate;
                        for (var i = 0; i < obj['sub-open-id-info'].length; i++) {
                            infoObj = obj['sub-open-id-info'][i];

                            infoObj['join-date'] = infoObj['join-date'].replace(/\//g, "-");
                            if (infoObj.info.nickname == undefined) {
                                infoObj.info.nickname = "匿名网友";
                            }
                            else if (infoObj.info.nickname.length < 4) {
                                infoObj.info.nickname = infoObj.info.nickname + "**";
                            }
                            else
                                infoObj.info.nickname = infoObj.info.nickname.substring(0, 3) + "**";
                            innerHtml += '<li><span class="bargain_price" style="width:80px">砍一刀</span><p class="bargain_name">' + infoObj.info.nickname + '</p><p class="bargain_time">' + infoObj['join-date'] + '</p></li>';
                        }

                        var amount = obj['sub-open-id-info'].length * 10;

                        $("#bargainCount").html(obj['sub-open-id-info'].length);
                        $("#bargainAmount").html(amount);
                        $("#bargainTotal").html(amount);

                        $('#prodprice').html((parseFloat($('#prodprice').html()) - parseFloat(amount)) <= 0 ? "0" : (parseFloat($('#prodprice').html()) - parseFloat(amount)));
                    }
                    $("#bargainlist").html(innerHtml);
                }
            });
        }
    </script>
    </form>
</body>
<script type="text/javascript" src="http://res.wx.qq.com/open/js/jweixin-1.0.0.js"></script>
<script type="text/javascript">
    wx.config({
        debug: false, // 开启调试模式,调用的所有api的返回值会在客户端alert出来，若要查看传入的参数，可以在pc端打开，参数信息会通过log打出，仅在pc端时才会打印。
        appId: '<%=appId%>', // 必填，公众号的唯一标识
        timestamp: '<%=timeStamp%>', // 必填，生成签名的时间戳
        nonceStr: '<%=nonceStr%>', // 必填，生成签名的随机串
        signature: '<%=shaParam %>', // 必填，签名，见附录1
        jsApiList: [
	            'onMenuShareTimeline',
	            'onMenuShareAppMessage',
	            'onMenuShareQQ',
	            'onMenuShareWeibo']
    });
    wx.ready(function () {

        //分享到朋友圈
        wx.onMenuShareTimeline({
            title: descContent, // 分享标题
            link: lineLink, // 分享链接
            imgUrl: imgUrl, // 分享图标
            success: function () {
                // 用户确认分享后执行的回调函数
                //alert("asdf");
                //location.href = "shareResult.aspx?openid=" + QueryString("openid") + "&preopenid=" + QueryString("preopenid");
            }
        });

        //分享给朋友
        wx.onMenuShareAppMessage({
            title: shareTitle, // 分享标题
            desc: descContent, // 分享描述
            link: lineLink, // 分享链接
            imgUrl: imgUrl, // 分享图标
            success: function () {
                // 用户确认分享后执行的回调函数
                //alert("asdf");
                //location.href = "shareResult.aspx?openid=" + QueryString("openid") + "&preopenid=" + QueryString("preopenid");
            }
        });

        //分享到QQ
        wx.onMenuShareQQ({
            title: shareTitle, // 分享标题
            desc: descContent, // 分享描述
            link: lineLink, // 分享链接
            imgUrl: imgUrl // 分享图标
        });

        //分享到腾讯微博
        wx.onMenuShareWeibo({
            title: shareTitle, // 分享标题
            desc: descContent, // 分享描述
            link: lineLink, // 分享链接
            imgUrl: imgUrl // 分享图标
        });
    });
    </script>
    <%
        if (Request["fromsource"] != null && Request["fromsource"].Trim().Equals("subscribe"))
        { 
        %>
    <script type="text/javascript" >

        ActiveService();

    </script>
    <%
        }
         %>
</html>
