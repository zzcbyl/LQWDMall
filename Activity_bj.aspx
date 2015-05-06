<%@ Page Language="C#" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">

<script runat="server">
    public string timeStamp = "";
    public string nonceStr = "e4b6e00dd1f0bf0fcab93b165ae8f";
    public string ticket = "";
    public string shaParam = "";
    public string appId = System.Configuration.ConfigurationSettings.AppSettings["wxappid"];
    
    protected void Page_Load(object sender, EventArgs e)
    {
        try
        {
            timeStamp = Util.GetTimeStamp();
            //appId = "wx6776682e62b9a524";
            string jsonStrForTicket = Util.GetWebContent("https://api.weixin.qq.com/cgi-bin/ticket/getticket?access_token="
                + Util.GetToken() + "&type=jsapi", "get", "", "form-data");
            ticket = Util.GetSimpleJsonValueByKey(jsonStrForTicket, "ticket");
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
    <title></title>
    <script src="script/config.js" type="text/javascript"></script>
    <%--<link href="style/bootstrap.css" rel="stylesheet" type="text/css" />--%>
    <link href="style/bootstrap.min.css" rel="stylesheet" type="text/css" />
    <%--<link href="style/font-awesome.css" rel="stylesheet" type="text/css" />--%>
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
            
            </div>
            <div class="prod_box">
                <h3>好友帮Ta砍掉了</h3>
                <p><span class="dfn">¥</span><span class="js_fruit">94.97</span></p>
                <%--<s class="gray" id="originalprice" style="margin-right:10px;"></s><span class="red" id="prodprice"></span>--%>
                <%--<a onclick="javascript:joinxly();" class="btn btn-danger" style="width:20%; ">我要报名</a>--%>
            </div>
        </div>
        <%--<div id="proddescription" class="m-ddescription">
        </div>--%>
        <div class="bargain_people">
            <h3>谁砍过</h3>
            <p>目前<span class="red pd2">12</span>位好友一共砍掉了<span class="red pd2">94.97</span>元</p>
            <div class="bargain_list_scroll">
                <ul class="bargain_list_info">
                    <li>
                        <span class="bargain_price" style="width:80px">-16.58</span>
                        <p class="bargain_name">匿名好友</p>
                        <p class="bargain_time">2015-5-5 22:00</p>
                    </li>
                </ul>
            </div>
        </div>
        <%--<div style="background:#fff; padding:10px; text-align:center;">
            <a onclick="javascript:joinxly();" class="btn btn-danger" style="width:25%;" >我要报名</a>
        </div>--%>
        <div style="padding:20px;">
            <img src='http://weixin.luqinwenda.com/get_promote_qrcode.aspx?openid=<%=Request["preopenid"] %>' style="width:100%" />
        </div>
        
        <div class="clear" style="height:60px;"></div>
        <div class="m-bottom">
            <div id="footermenu">
                <span class="barmaigin_btn leftbtn btnwith">
                    我也要发起
                </span>
                <span class="barmaigin_btn rightbtn btnwith">
                    帮忙砍一刀
                </span>
                <div class="clear"></div>
            </div>
        </div>
    </div>

    <script type="text/javascript">
        var shareTitle = "分享测试"; //标题
        var imgUrl = "http://mall.luqinwenda.com/images/index-left.jpg"; //图片
        var descContent = "分享测试，分享测试。"; //简介
        var lineLink = "http://mall.luqinwenda.com/shareTest.aspx?preopenid="; //链接
        var prodid = 25;
        if (QueryString('openid') == null) {
            var encodeDomain = encodeURIComponent(document.URL);
            //location.href = "http://weixin.luqinwenda.com/authorize.aspx?callback=" + encodeDomain;
        }
        lineLink += QueryString('openid');
        $(document).ready(function () {
            if (prodid == null) {
                alert('商品参数有误');
                return;
            }
            if (QueryString('openid') != null) {
                filldetail(prodid);
            }
        });

        function joinxly() {
            location.href = 'Join_xly.aspx?productid=' + prodid;
        }

        function filldetail(pid) {
            $('#prodtitle').html('<div class="loading"><img src="images/loading.gif" /><br />加载中...</div>');

            $.ajax({
                type: "get",
                async: false,
                url: domain + 'api/product_get_detail.aspx',
                data: { productid: pid, random: Math.random() },
                success: function (data, textStatus) {
                    var obj = eval('(' + data + ')');
                    if (obj != null) {
                        //$('#prodtitle').html(obj.prodname);
                        //$('#proddescription').html(obj.description);
                        $('#prodimg').html('<img src="' + domain + obj.images[0].src + '" width="100%" />');
//                        if (obj.originalprice != null && obj.originalprice != '') {
//                            $('#originalprice').show();
//                            $('#originalprice').html('¥' + parseInt(obj.originalprice) / 100);
//                        }
//                        else if (pid == 24) {
//                            $('#originalprice').hide();
//                            $('#prodprice').hide();
//                        }
//                        else
//                            $('#originalprice').hide();
                        //$('#prodprice').html('¥' + parseInt(obj.price) / 100);
                    }
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
            title: shareTitle, // 分享标题
            link: lineLink, // 分享链接
            imgUrl: imgUrl, // 分享图标
            success: function () {
                // 用户确认分享后执行的回调函数
                //alert("asdf");
                location.href = "shareResult.aspx?openid=" + QueryString("openid") + "&preopenid=" + QueryString("preopenid");
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
                location.href = "shareResult.aspx?openid=" + QueryString("openid") + "&preopenid=" + QueryString("preopenid");
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
