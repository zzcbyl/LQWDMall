<%@ Page Language="C#" %>
<%@ Import Namespace="System.Data" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">

<script runat="server">
    public string timeStamp = "";
    public string nonceStr = "e41b6e00dd1f0ba3sf0fcab93b24165ae8f";
    public string ticket = "";
    public string shaParam = "";
    public string appId = System.Configuration.ConfigurationSettings.AppSettings["wxappid"];
    protected void Page_Load(object sender, EventArgs e)
    {
        if (!IsPostBack)
        {
            DataTable ClothingDT = Vote.getClothList();
            this.repeaterCloth.DataSource = ClothingDT;
            this.repeaterCloth.DataBind();

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
    }
</script>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <meta name="viewport" content="width=device-width,initial-scale=1,maximum-scale=1,minimum-scale=1,user-scalable=no">
    <title>快来为北欧游学之旅营服投票，参与有惊喜！</title>
    <script src="../script/common.js" type="text/javascript"></script>
    <link href="/style/bootstrap.min.css" rel="stylesheet" type="text/css" />
    <script src="jquery-1.7.1.min.js" type="text/javascript"></script>
    <style type="text/css">
        body,ul,li,p,h1,h2,h3,h4,h5,h6,dl,dt,dd,form,input,textarea,select{margin:0; padding:0; list-style-type:none;}
        body{ font: normal 14px/1.5 Arial, "Lucida Grande", Verdana, "Microsoft YaHei", hei;  padding:0 10px; color:#333; margin:0 auto; position:relative;}
        .VoteItem { width:100%; margin-top:20px;}
        .VoteItem li { float:left; width:50%; text-align:center;}
        .VoteItem li img { width:90%; border:1px solid #ccc;}
        .CheckItem { padding:10px 0 20px;}
        .VotesCount { margin-left:5px; color:#999; font-weight:bold}
        .ItemCheckIcon { background:url(images/radio_2.jpg) no-repeat; display:inline-block; width:33px; height:33px;}
        .loading { margin:0 auto; padding:30px 0; text-align:center; background:#fff; color:#999; line-height:30px; font-size:12px;}
        .loading img { width:50px; height:50px;}
        input[type=radio] { margin-top:-5px;}
        .bargain_people { padding:10px; background:#fff; margin-top:10px; }
        .bargain_people h3 { font-size:16px; font-weight:400; line-height:25px;}
        .comment_people ul {
            margin-top: 8px;
            border-top: 1px solid #d5d5d5
        }
        .comment_people li {
            padding: 8px 10px;
            border-bottom: 1px solid #d5d5d5;
            overflow: hidden;
            
        }
        .comment_people li .comment_name { float:left;}
        .comment_people li .comment_time { float:right;}
        .comment_people li .comment_content { line-height:18px; text-indent:25px; color:#666; max-height:72px; overflow:hidden; margin-top:5px;}
        .comment_people li .comment_item { float:right; margin-right:15px;}
       
    </style>
</head>
<body>
    <div>
        <div style="width:100%;">
            <img src="images/vote_banner.jpg" style="width:100%;" />
        </div>
        <div style="clear:both;"></div>
        <div style="line-height:20px; margin-top:10px;">
            <div style="height:25px; font-size:16px; font-weight:bold;">活动规则</div>
            1、每位微信用户只能投票一次。<br />
            2、活动时间为：6月4日——6月23日。<br />
            3、得票多者将成为北欧游学之旅的营服。<br />
            4、活动截止后，我们将从得票最多的方案中随机抽取一位投票者，送上该系列整套营服（四件T恤和一件卫衣）。<br />
        </div>
        <ul class="VoteItem">
            <asp:Repeater ID="repeaterCloth" runat="server">
                <ItemTemplate>
                    <li>
                        <a href='Clothing.aspx?clothingid=<%# DataBinder.Eval(Container.DataItem, "clothing_id") %>'><img id='img<%# DataBinder.Eval(Container.DataItem, "clothing_id") %>' src='<%# Util.ApiDomainString + DataBinder.Eval(Container.DataItem, "clothing_src")%>' /></a>
                        <div class="CheckItem"  id='item<%# DataBinder.Eval(Container.DataItem, "clothing_id") %>'>
                            <label>
                                <%# DataBinder.Eval(Container.DataItem, "clothing_name") %>
                                <img src="images/radio_2.jpg" style="width:20px; border:none; margin-top:-5px; margin-left:5px;" /> 
                                <%--<input type="radio" id='item<%# DataBinder.Eval(Container.DataItem, "clothing_id") %>' name="radItem" />
                                <label for='item<%# DataBinder.Eval(Container.DataItem, "clothing_id") %>'>--%>
                                <img src="images/zantongicon.jpg" style="width:30px; border:none; margin-top:-8px;" />
                                <span class="VotesCount"><em><%# DataBinder.Eval(Container.DataItem, "clothing_votes")%></em>人</span>
                            </label>
                        </div>
                    </li>
                </ItemTemplate>
            </asp:Repeater>
        </ul>
        <div style="clear:both;"></div>
        <div style="margin-top:0px; padding:0 10px;">
            <textarea id="memo" name="memo" maxlength="500" style="width:100%; padding:5px; height:60px; line-height:20px;" placeholder="（选填）请留下您宝贵的意见。"></textarea>
        </div>
        <div style="text-align:center; margin:20px;">
            <button type="button" class="btn btn-danger" onclick="submitVote();" style="font-size:16px; padding:8px 15px;">提交</button>
        </div>

        <div class="comment_people">
            <h5>看看大家怎么说</h5>
            <ul id="commentlist">
                
            </ul>
            <div id="pageDiv" style="text-align:center; margin-top:10px;">
                <button class="btn btn-danger" onclick="prevPage();">上一页</button>　
                <button class="btn btn-danger" onclick="nextPage();">下一页</button>
            </div>
        </div>
        <div style="height:20px;"></div>
    </div>
    <script type="text/javascript">
        var shareTitle = "北欧游学之旅营服投票"; //标题
        var imgUrl = "http://mall.luqinwenda.com/dressvote/images/vote_share_icon.jpg"; //图片
        var descContent = "快来为北欧游学之旅营服投票，参与有惊喜！"; //简介
        var lineLink = "http://mall.luqinwenda.com/dressvote/Votes.aspx"; //链接
        var index = 0;
        var openid = '';
        var clothingid = 0;
        var currentpage = 1;
        var pagesize = 20;
        $(document).ready(function () {
            if (QueryString('openid') == null || QueryString('openid') == "") {
                var encodeDomain = encodeURIComponent(document.URL);
                location.href = "http://weixin.luqinwenda.com/authorize_0603.aspx?callback=" + encodeDomain;
            }
            openid = QueryString('openid');

            bindVoteList();

            $('.CheckItem').click(function () {
                for (var i = 0; i < $('.VoteItem li').length; i++) {
                    $('.VoteItem li').eq(i).find('img').eq(0).css({ "border": "1px solid #ccc" });
                    $('.VoteItem li').eq(i).find('.CheckItem').find('img').eq(0).attr("src", "images/radio_2.jpg");
                }
                //if (index == 0) {
                    clothingid = $(this).attr('id').replace('item', '');
                    $('#img' + clothingid).css({ "border": "1px solid #ff0000" });
                    $(this).find('img').eq(0).attr("src", "images/radio_1.jpg");
                //}
                //else {
                //    alert('您已投过票，每人只能投一次票');
                //}
            });
        });

        function bindVoteList() {
            $('#commentlist').html('<li class="loading"><img src="http://mall.luqinwenda.com/images/loading.gif" /><br />加载中...</li>');
            $.ajax({
                type: 'post',
                url: 'VoteHandler.ashx',
                data: { item: 2, currentPage: currentpage, pageSize: pagesize },
                success: function (data, textStatus) {
                    data = data.replace(/\n/g, '');
                    var json = eval("(" + data + ")");
                    var html = "";
                    for (var i = 0; i < json.data.length; i++) {
                        if (json.data[i].vote_name.length < 4) {
                            json.data[i].vote_name = json.data[i].vote_name + "**";
                        }
                        else
                            json.data[i].vote_name = json.data[i].vote_name.substring(0, 3) + "**";
                        html += '<li><div style="line-height:22px;"><p class="comment_name">' + json.data[i].vote_name + '</p><p class="comment_time">' + json.data[i].vote_crt + '</p><p class="comment_item">' + json.data[i].clothing_name + '</p><div style="clear:both;"></div></div><div class="comment_content">' + json.data[i].vote_remark + '</div></li>';
                    }
                    $('#commentlist').html(html);

                    if (currentpage == 1 && json.data.length < pagesize) {
                        $('#pageDiv').hide();
                    }
                    else
                        $('#pageDiv').show();

                    if ($('#commentlist').html() == "") {
                        currentpage--;
                        bindVoteList();
                    }
                }
            });
        }
        function prevPage() {
            currentpage -= 1;
            if (currentpage <= 0) {
                currentpage = 1;
            }
            bindVoteList();
        }
        function nextPage() {
            currentpage += 1;
            bindVoteList();
        }

        function submitVote() {
            if (clothingid > 0) {
                $.ajax({
                    type: 'post',
                    url: 'VoteHandler.ashx',
                    data: { item: 1, openid: openid, clothingid: clothingid, remark: $('#memo').val() },
                    success: function (data, textStatus) {
                        if (data != null && parseInt(data) > 0) {
                            index = 1;
                            if (parseInt(data) == 1) {
                                $("#item" + clothingid).find('em').eq(0).html(parseInt($("#item" + clothingid).find('em').eq(0).html()) + 1);
                                alert('投票成功');
                                bindVoteList();
                            }
                            else {
                                alert('您的投票次数过多');
                            }
                        }
                        else
                            alert('投票失败，请您刷新之后重试');
                    }
                });
            }
            else {
                alert("请选择你喜欢的款式");
            }
        }
    </script>

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
