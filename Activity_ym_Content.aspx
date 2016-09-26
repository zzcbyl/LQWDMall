<%@ Page Language="C#" %>
<%@ Import Namespace="System.Data" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">

<script runat="server">
    public string timeStamp = "";
    public string nonceStr = "e4b6e0d1f0bf0fa9s34d2f13b165ae8f";
    public string ticket = "";
    public string shaParam = "";
    public string appId = System.Configuration.ConfigurationSettings.AppSettings["wxappid_dingyue"];
    
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
    <title>“助梦留守儿童”爱心义卖活动</title>
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
                <img src="images/activity_ym_banner.jpg" width="100%" />
            </div>
        </div>
        <div style="background:#fff; width:100%; margin-top:10px; ">
            <ul class="nav-default">
                <li id="type-suit" style="line-height:40px; font-weight:bold; background:#FDF8D2; color:#f00;" onclick="showDiv(1);">王国梁</li>
                <li id="type-single" style="line-height:40px; font-weight:bold; background:#fff; color:#333;" onclick="showDiv(2);">邓 芸</li>
            </ul>
            <div class="clear"></div>
        </div>
        <div id="div_wgl" style="background:#fff; padding:10px; margin-top:10px;">
            <div style="text-align:center;"><img src="images/wangguoliang.jpg" /></div>
            <div style="margin-top:10px; line-height:23px;">
                <div style="font-size:14px; font-weight:bold;">山东省临沂市费县大田庄乡堂子小学王国梁：</div>
                <div style="text-indent:30px;">两年前，“手拉手，让留守儿童笑起来”活动在山东启动，那是我第一次见到王国梁：黑黑壮壮的小伙子，略显腼腆，印象最深刻的是他一口方言热情的向我做自我介绍，可惜我几乎一句都没听懂。活动结束后，听说他开始每天对着镜子，用普通话练习我送给他的三句话“太好了、我能行、我帮你”。</div>
                <div style="text-indent:30px;">今年11月初，在北京的活动总结会上，我又见到了王国梁：他作为留守儿童的代表发言，讲话依然有很重的方言口音，但是大部分话语我们都听明白了，尤其那三句“太好了，我能行、我帮你”发音标准、咬字清晰，声音洪亮！</div>
                <div style="text-indent:30px;">那一刻我很感动，一句普通话却让我们感受到王国梁的坚持、努力、不放弃的学习精神，他告诉我希望未来还有机会站在演讲台上，他会让我听到更标准的普通话！</div>
            </div>
        </div>

        <div id="div_dy" style="background:#fff; padding:10px; margin-top:10px; display:none;">
            <div style="text-align:center;"><img src="images/dengyun.jpg" /></div>
            <div style="margin-top:10px; line-height:23px;">
                <div style="font-size:14px; font-weight:bold;">江西省兴国县埠头中心小学邓芸：</div>
                <div style="text-indent:30px;">今年，知心姐姐在江西的一个小学和孩子们分享梦想的力量时，孩子们争先恐后地站起来告诉知心姐姐自己的梦想是什么。这时我发现有一个女孩站起来又坐下，想说话却又很胆怯的样子，并且反复了好几次。于是，我让大家安静，点名让这个女孩子站起来，大声的告诉大家她的梦想是什么？她用低弱的声音很不自信的说“知心姐姐，我想要一个生日蛋糕”。这个女孩就是邓芸。</div>
                <div style="text-indent:30px;">通过邓芸讲述，我们大致了解到：家里的弟弟每次过生日奶奶都给煮碗面，以示庆贺，可邓芸长这么大从来没有过过生日，所以她很希望也有人能给她过生日，并且能像电视里那样，还有生日蛋糕！</div>
                <div style="text-indent:30px;">我当时就答应邓芸：6月份过生日时，我一定会送你生日蛋糕！等到她过生日的时候，我掏钱给她买了生日蛋糕，在学校里，老师和全班同学帮我给她过了一个难忘的生日，而更让她惊喜的是晚上回家，奶奶竟然给她煮了一碗面，说祝她生日快乐！</div>
                <div style="text-indent:30px;">后来我收到了邓芸给我的一封信，仔细给我描述了第一次过生日的心情，她说通过这次生日，她发现原来“表达”有这么大的魔力！因为敢于表达，她竟然拥有了梦寐以求的生日蛋糕；因为敢于表达，她和同学们的关系在这次生日活动中变得更融洽了；因为敢于表达，奶奶现在也开始变得更加关心她。</div>
                <div style="text-indent:30px;">她说以后她要学着自信、大胆的与别人沟通，勇敢的去表达自己的想法！</div>
            </div>
        </div>

        <div style="background:#fff; padding:10px; margin-top:10px;">
            <h5>“助梦留守儿童”爱心义卖活动：</h5>
            <div style="margin-top:5px;">
                　　由悦长大平台发起，号召全社会爱心人士积极参与，以“关爱留守儿童的精神世界，丰富留守儿童的精神生活”为宗旨。2015年11月24日，该项目的首场爱心接力捐助活动现已开启！<br />
                　　<span style="color:#EC3E35; font-weight:bold;">一秒钟，一个点击，一份关注，帮助两名留守儿童实现参加“我要学演说”冬令营的梦想！</span><br />
                　　知心姐姐卢勤欢迎你的加入！
            </div>
            <div style="text-align:center; margin-top:10px;"><img src="images/dyh_code.jpg" width="80%" /></div>
        </div>
    </div>

    <script type="text/javascript">
        var shareTitle = "“助梦留守儿童”爱心义卖活动"; //标题
        var imgUrl = "http://mall.luqinwenda.com/images/activity_ym_icon.jpg"; //图片
        var descContent = "一秒钟，一个点击，一份关注，帮助两名留守儿童实现参加“我要学演说”冬令营的梦想！"; //简介
        var lineLink = "http://mall.luqinwenda.com/Activity_ym.aspx"; //链接
        $(document).ready(function () {
            showDiv(QueryString('obj'));
        });

        function showDiv(m) {
            if (m == 1) {
                $('#type-suit').css({ background: '#FDF8D2', color: '#f00' });
                $('#type-single').css({ background: '#fff', color: '#333' });
                $('#div_wgl').show();
                $('#div_dy').hide();
            } else if (m == 2) {
                $('#type-single').css({ background: '#FDF8D2', color: '#f00' });
                $('#type-suit').css({ background: '#fff', color: '#333' });
                $('#div_wgl').hide();
                $('#div_dy').show();
            }
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
</html>
