<%@ Page Language="C#" %>
<%@ Import Namespace="System.Data" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">

<script runat="server">
    public string timeStamp = "";
    public string nonceStr = "e4b6e00dd1f0bf0fcab93b165ae8f";
    public string ticket = "";
    public string shaParam = "";
    public string appId = System.Configuration.ConfigurationSettings.AppSettings["wxappid"];
    public int activate = 1;
    public int endState = 0;
    
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
    <title>“关爱留守儿童”爱心公益活动公益活动</title>
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
        </div>
        <div style="background:#fff; padding:10px; margin-top:10px;">
            <h5>活动介绍：</h5>
            <div style="margin-top:5px;">
                　他们都是来自贫困山区的留守儿童，他们都热爱演说，他们渴望在今年寒假走出大山，希望能够像城里的孩子一样参加一次冬令营，和电视上的明星老师们面对面过一个难忘的寒假，圆一个演说家的梦想！<br />
                　一秒钟，一个点击，一份关注，帮助两名留守儿童实现参加“我要学演说”冬令营的梦想！
            </div>
            <div><a style="font-size:12px; color:#0B659D; text-decoration:underline; display:inline-block; float:right;" href='#'>详细介绍>></a></div>
            <br style="clear:both;" />
        </div>
        <div style="clear:both; height:1px;"></div>
        <div style="background:#fff; padding:10px; margin-top:10px;">
            <h5>助梦方式：</h5>
            <div style="margin-top:5px;">
                以下助梦方式您可任选其一，也可同时选择。<br />
                <div style="margin-left:10px;">
                    <div>1、点击<a href='http://mall.luqinwenda.com/Detail.aspx?productid=5&openid=123' style="color:#0B659D; text-decoration:underline; font-weight:bold;">“爱要拍”</a>，拍下一套“家庭教育专题讲座”，您支付的全款我们将全部用于助梦活动；</div>
                    <div style="text-align:center; padding:5px;">
                        <a href='http://mall.luqinwenda.com/Detail.aspx?productid=5&openid=123'><img src="http://mall.luqinwenda.com/upload/prodimg/act_yimai.jpg" width="500px" /></a>
                    </div>
                    <div>2、点击<a href="javascript:void(0);" onclick="ActiveService();" style="color:#0B659D; text-decoration:underline; font-weight:bold;">“爱转发”</a>，转发当前活动页面后并截图，然后通过卢勤问答平台公众号把截图发给我们，您转发一次我们就为该活动捐助一元钱；</div>
                    <div>3、活动截止日期：以捐款满额为截止点；</div>
                </div>
            </div>
        </div>
        <div style="background:#fff; padding:10px; margin-top:10px;">
            <h5>演讲营介绍：</h5>
            <div style="margin-top:5px;">
                <div style="text-align:center; padding:0 5px 5px;">
                    <a href='http://mall.luqinwenda.com/Detail_xly.aspx?productid=28&openid=123'><img src="http://mall.luqinwenda.com/upload/prodimg/ying_ys3.jpg" width="500px" /></a>
                </div>
                <div>　　让孩子敢说话，会说话，说自己的话，善于运用语言的力量！</div>
                <div>　　想学说话，就要找会说话的人！</div>
                <div>　　2016年 1月29日——2月3日，《我要学演说》少年口才培训营特邀北京人民广播电台的金话筒节目主持人“小雨姐姐”和“知心姐姐”卢勤老师联合倾力策划，全程陪伴；邀请著名少儿节目主持人鞠萍姐姐、深圳卫视著名节目主持人强子哥哥倾情分享，名师带领，为8-18岁的青少年带来终身难忘的演说特训营！</div>
                <div>　　给孩子一个舞台，点燃孩子的激情；名师专家口传心授，释放孩子的潜能；星光璀璨，展示孩子的才华。在这里，表达自己不再是埋藏在心里的一个冲动，话语权也不再是少数人的特权，舞台聚光灯将属于勇于挑战自我的你！</div>
                <div><a style="font-size:12px; color:#0B659D; text-decoration:underline; display:inline-block; float:right;" 
                        href='http://mall.luqinwenda.com/Detail_xly.aspx?productid=28&openid=123'>详细介绍>></a></div>
                <br style="clear:both;" />
            </div>
        </div>
        <div class="bargain_people">
            <h5>爱心榜：</h5>
            <div class="bargain_list_scroll">
                <ul id="bargainlist" class="bargain_list_info">
                    
                </ul>
            </div>
        </div>
        
        <div style="background:#fff; padding:10px; margin-top:10px;">
            <h5>“关爱留守儿童”爱心公益活动公益活动：</h5>
            <div style="margin-top:5px;">
                　　由卢勤问答平台发起，号召全社会爱心人士积极参与，以“关爱留守儿童的精神世界，丰富留守儿童的精神生活”为宗旨。2015年11月24日，该项目的首场爱心接力捐助活动现已开启！<br />
                　　知心姐姐卢勤欢迎你的加入！
            </div>
        </div>

        <div class="clear" style="height:60px;"></div>
        <div class="m-bottom">
            <div id="footermenu">
                    <span class="barmaigin_btn leftbtn btnwith" onclick="ActiveService();">
                        爱转发
                    </span>
                    <a href='http://mall.luqinwenda.com/Detail.aspx?productid=5&openid=123'>
                    <span class="barmaigin_btn rightbtn btnwith">
                        爱要拍
                    </span></a>
                <div class="clear"></div>
            </div>
        </div>
    </div>
    <div id="popbg"></div>
    <div id="showShare" style="display:none;" onclick="javascript:document.getElementById('showShare').style.display='none';">
        <div style="width:100%; height:100%; background:#ccc; color:#000; position:absolute; top:-10px; left:0px; text-align:center; filter:alpha(opacity=90); -moz-opacity:0.9;-khtml-opacity: 0.9; opacity: 0.9;  z-index:9;"></div>
        <div class="arrowDiv"></div>
        <div class="promptDiv">点击右上角“┇”<br />分享到朋友圈</div>

    <script type="text/javascript">
        var shareTitle = "“关爱留守儿童”爱心公益活动公益活动"; //标题
        var imgUrl = "http://mall.luqinwenda.com/images/activity_bj_icon.jpg"; //图片
        var descContent = "“关爱留守儿童”爱心公益活动公益活动"; //简介
        var lineLink = "http://mall.luqinwenda.com/Activity_ym.aspx"; //链接
        $(document).ready(function () {
            if (QueryString('openid') != null) {
                fillbarmaigin(QueryString('openid'));
            }
            else {
                var encodeDomain = encodeURIComponent(document.URL);
                location.href = "http://weixin.luqinwenda.com/authorize_0603.aspx?callback=" + encodeDomain;
            }
        });

        function ActiveService() {
            //alert(document.documentElement.scrollTop);
            if (document.documentElement.scrollTop == 0) {
                $(".arrowDiv").css({ top: document.body.scrollTop + "px" });
                $(".promptDiv").css({ top: document.body.scrollTop + 80 + "px" });
            }
            else {
                $(".arrowDiv").css({ top: document.documentElement.scrollTop + "px" });
                $(".promptDiv").css({ top: document.documentElement.scrollTop + 80 + "px" });
            }
            $("#showShare").show();
            return;
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
</html>
