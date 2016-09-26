<%@ Page Language="C#" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">

<script runat="server">

</script>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <meta name="viewport" content="width=device-width,initial-scale=1,maximum-scale=1,minimum-scale=1,user-scalable=no">
    <title>“放飞梦想我能行”知心姐姐北京精品营</title>
    <style type="text/css">
        div { line-height:25px; width:100%; text-indent:20px; }
        p { width:100%; text-align:center; }
        h2 { width:100%; text-align:center;}
        img { }
    </style>
</head>
<body style="padding:10px;">
    <form id="form1" runat="server">
    <h2>“放飞梦想我能行”知心姐姐北京精品营</h2>
    <div>
        只要你的朋友足够多，您的孩子就有机会免费参加“放飞梦想我能行”知心姐姐北京精品营！
    </div>
    <div>
        参与规则：
    </div>
    <div>
        1、添加悦长大公共服务号，微信号为：luqinwenda，进入服务号后，点击功能菜单“夏令营”，在上拉菜单中选择“砍价活动”。
    </div>
    <p>
        <img src="images/Activity_bj_1.jpg" />
    </p>
    <div>
        2、收取图文消息，点击图文消息，进入活动页面，并将此页面分享至朋友圈。
    </div>
    <p>
        <img src="images/Activity_bj_2.jpg" />
    </p>
    <div>
        3、每位朋友关注服务号之后，都可以“帮忙砍一刀”，每砍一次优惠10元，无下限设置，只要你的朋友足够多，可以砍至0元。
    </div>
    <p>
        <img src="images/Activity_bj_3.jpg" />
    </p>
    <div>
        4、本活动官方截止时间为5月28日，也可以提前结算。
    </div>
    <div>
        5、悦长大平台保留最终解释权。
    </div>
    <div>
        只要您愿意，就有砍到0的机会，还在等什么，快来参加吧！
    </div>
    <div>
        今年7月23日至7月28日，知心姐姐卢勤老师及知心姐姐团队即将出发，带领“放飞梦想我能行”知心姐姐精品营的营员们放飞自己的梦想，并坚定地向梦想大声说:“我能行！”
    </div>
    <div>
        如果您希望孩子能够拥有“我能行”的信念和坚定的梦想，并且拥有永生难忘的一个暑假，这次机会不容错过！
    </div>
    </form>
    <script src="script/jquery-2.0.1.min.js" type="text/javascript"></script>
    <script type="text/javascript">        
        function browserRedirect() {
            var sUserAgent = navigator.userAgent.toLowerCase();
            var bIsIpad = sUserAgent.match(/ipad/i) == "ipad";
            var bIsIphoneOs = sUserAgent.match(/iphone os/i) == "iphone os";
            var bIsMidp = sUserAgent.match(/midp/i) == "midp";
            var bIsUc7 = sUserAgent.match(/rv:1.2.3.4/i) == "rv:1.2.3.4";
            var bIsUc = sUserAgent.match(/ucweb/i) == "ucweb";
            var bIsAndroid = sUserAgent.match(/android/i) == "android";
            var bIsCE = sUserAgent.match(/windows ce/i) == "windows ce";
            var bIsWM = sUserAgent.match(/windows mobile/i) == "windows mobile";

            if (bIsIpad || bIsIphoneOs || bIsMidp || bIsUc7 || bIsUc || bIsAndroid || bIsCE || bIsWM) {
                $("img").css({ "width": "95%" });
            }
            else {
                $("img").css({ "width": "500px" });
            }
        }
        window.onload = function () { browserRedirect(); }</script>
</body>
</html>
