<%@ Page Language="C#" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">

<script runat="server">
    public string timeStamp = "";
    public string nonceStr = "e4b6e0dd1f0bfu3nf2cab93b165ef";
    public string ticket = "";
    public string shaParam = "";
    public string appId = System.Configuration.ConfigurationSettings.AppSettings["wxappid"];

    protected void Page_Load(object sender, EventArgs e)
    {
        timeStamp = Util.GetTimeStamp();
        //appId = "wx6776682e62b9a524";
        string jsonStrForTicket = Util.GetWebContent("https://api.weixin.qq.com/cgi-bin/ticket/getticket?access_token="
            + Util.GetToken() + "&type=jsapi", "get", "", "form-data");
        //ticket = Util.GetSimpleJsonValueByKey(jsonStrForTicket, "ticket");
        string shaString = "jsapi_ticket=" + ticket.Trim() + "&noncestr=" + nonceStr.Trim()
            + "&timestamp=" + timeStamp.Trim() + "&url=" + Request.Url.ToString().Trim();
        shaParam = Util.GetSHA1(shaString);
    }
</script>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title>快来为北欧游学之旅营服投票，参与有惊喜！</title>
    
    <link href="style.css" rel="stylesheet" type="text/css" />
    <script src="jquery-1.7.1.min.js" type="text/javascript"></script>
    <script src="jquery.event.drag-1.5.min.js" type="text/javascript"></script>
    <script src="jquery.touchSlider.js" type="text/javascript"></script>
    <script src="../script/common.js" type="text/javascript"></script>
    <script type="text/javascript" src="http://res.wx.qq.com/open/js/jweixin-1.0.0.js"></script>
    <script type="text/javascript">
        $(document).ready(function () {
            if (QueryString('clothingid') != null && QueryString('clothingid') != "") {
                var index = parseInt(QueryString('clothingid')) - 1;
                var countArr = [2, 6, 5, 7, 1, 5];
                var lihtml = '';
                var slthtml = '';
                //$("#totalNum").html(countArr[index]);
                for (var i = 0; i < countArr[index]; i++) {
                    lihtml += '<li><span class=""><img src="images/clothing' + QueryString('clothingid') + '/0' + (i + 1) + '.jpg" height="100%" /></span></li>';
                    slthtml += '<img src="images/clothing' + QueryString('clothingid') + '/0' + (i + 1) + '.jpg" style="width:10%; margin-left:10px;" />';
                }
                $("#mainimgul").html(lihtml);
                $("#sltdiv").html(slthtml);
            }
            var pmwidth = document.body.clientWidth;
            $('.main_visual img').eq(0).css('max-width', pmwidth);
            //alert(imgheight);

            $(".main_visual").hover(function () {
                $("#btn_prev,#btn_next").fadeIn()
            }, function () {
                $("#btn_prev,#btn_next").fadeOut()
            });

            $dragBln = false;

            $(".main_image").touchSlider({
                flexible: true,
                speed: 200,
                btn_prev: $("#btn_prev"),
                btn_next: $("#btn_next"),
                paging: $(".flicking_con a"),
                counter: function (e) {
                    //$('#currentNum').html(e.current);
                    $("#sltdiv img").each(function () {
                        $(this).css({ "width": "10%", "border": "none" });
                    });
                    $("#sltdiv img").eq(e.current - 1).css({ "width": "12%", "border": "2px solid #fff" });
                    $(".flicking_con a").removeClass("on").eq(e.current - 1).addClass("on");
                }
            });

            $(".main_image").bind("mousedown", function () {
                $dragBln = false;
            });

            $(".main_image").bind("dragstart", function () {
                $dragBln = true;
            });

            $(".main_image a").click(function () {
                if ($dragBln) {
                    return false;
                }
            });

        });
</script>
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
		    'onMenuShareWeibo'
	    ]
    });
    wx.ready(function () {
        var shareTitle = "快来为北欧游学之旅营服投票"; //标题
        var imgUrl = "http://mall.luqinwenda.com/dressvote/images/vote_share_icon.jpg"; //图片
        var descContent = "快来为北欧游学之旅营服投票，参与有惊喜！"; //简介
        var lineLink = "http://mall.luqinwenda.com/dressvote/Votes.aspx"; //链接

        //分享到朋友圈
        wx.onMenuShareTimeline({
            title: shareTitle, // 分享标题
            link: lineLink, // 分享链接
            imgUrl: imgUrl, // 分享图标
            success: function () {
                // 用户确认分享后执行的回调函数

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
</head>
<body class="keBody" style="background:#000;">
    <div style="position:absolute; top:20px; right:20px; z-index:999;"><a href="javascript:history.go(-1);"><img src="images/returnicon.png" width="120px" /></a></div>
    <%--<div style="font-size:50px; color:#fff; padding:50px 0 0px 50px;">
        <span id="currentNum">1</span>/<span id="totalNum">6</span>
    </div>--%>
    <div class="kePublic">
    <!--效果html开始-->
    <div class="main_visual">
	    <div class="main_image">
		    <ul id="mainimgul">
			    <li><span class=""><img src="images/clothing1/01.jpg" height="100%" /></span></li>
		    </ul>
		    <a href="javascript:;" id="btn_prev"></a>
		    <a href="javascript:;" id="btn_next"></a>
	    </div>
    </div>
    <!--效果html结束-->
    <div class="clear"></div>
    </div>
    <div id="sltdiv" style="text-align:center; margin-top:20px;">
        <img src="images/clothing1/01.jpg" style="width:10%; margin-left:10px;" />
    </div>
</body>
</html>
