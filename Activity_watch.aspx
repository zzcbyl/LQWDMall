<%@ Page Title="恭喜你获得100元【星空侠安全电话手表】代金券" Language="C#" %>
<%@ Import Namespace="System.Web.Script.Serialization" %>
<%@ Import Namespace="System.Threading" %>

<!DOCTYPE html>

<script runat="server">
    public string token = "";
    public int userId = 0;
    
    public string timeStamp = "";
    public string nonceStr = "fd4e2f0br01sa12dfasdf23fcw5ba9fa2d";
    public string ticket = "";
    public string shaParam = "";
    public string appId = System.Configuration.ConfigurationManager.AppSettings["wxappid_dingyue"];
    protected void Page_Load(object sender, EventArgs e)
    {
        token = Util.GetSafeRequestValue(Request, "token", "");
        if (token.Trim().Equals(""))
            if (Session["watch_token"] != null)
                token = Session["watch_token"].ToString().Trim();

        userId = Users.CheckToken(token);
        if (userId <= 0)
        {
            Response.Redirect("http://weixin.luqinwenda.com/authorize_final.aspx?callback=" + Server.UrlEncode(Request.Url.ToString()), true);
        }
        Session["watch_token"] = token;

        try
        {
            timeStamp = Util.GetTimeStamp();
            ticket = Util.GetTicket();
            string shaString = "jsapi_ticket=" + ticket.Trim() + "&noncestr=" + nonceStr.Trim()
                + "&timestamp=" + timeStamp.Trim() + "&url=" + Request.Url.ToString().Trim();
            shaParam = Util.GetSHA1(shaString);
        }
        catch (Exception ex) { }

        if (Request.Form["hidIndex"] != null && Request.Form["hidIndex"].ToString() == "1")
        {
            submitOrder(token);
        }
    }
    private void submitOrder(string token)
    {
        JavaScriptSerializer json = new JavaScriptSerializer();
        int count = 1;
        int.TryParse(Request.Form["hidCount"].ToString(), out count);

        string parms = "token=" + token + "&name=" + Request.Form["consignee"].ToString() + "&cell=" + Request.Form["mobile"].ToString()
                + "&address=" + Request.Form["address"].ToString() + "&memo=" + Request.Form["hidColor"].ToString()
                + "&zip=&productid=71&count=" + count + "|0";

        string getUrl = Util.ApiDomainString + "api/order_place.aspx?" + parms;
        string result = HTTPHelper.Get_Http(getUrl);
        ReturnOrder jsonorder = json.Deserialize<ReturnOrder>(result);
        if (jsonorder.status == 1)
        {
            Response.Redirect(Request.Url.ToString());
        }
        else
        {
            int userid = Users.CheckToken(token);
            Order order = new Order(int.Parse(jsonorder.order_id));
            int total = (order.OrderPriceToPay < 0 ? 0 : order.OrderPriceToPay);
            string param = "?body=卢勤问答平台官方商城&detail=手表&userid=" + userid + "&product_id=" + order._fields["oid"] + "&total_fee=" + total.ToString();
            string payurl = "";
            //微信支付
            payurl = "http://weixin.luqinwenda.com/payment/payment.aspx";

            this.Response.Redirect(payurl + param);
        }
    }

    public class ReturnOrder
    {
        public int status { get; set; }
        public string order_id { get; set; }
    }
    
</script>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
    <meta name="viewport" content="width=device-width,initial-scale=1,maximum-scale=1,minimum-scale=1,user-scalable=no">
    <title></title>
    <link href="style/jquery.spinner.css" rel="stylesheet" />
    <link href="style/font-awesome.min.css" rel="stylesheet" type="text/css" />
    <link href="style/bootstrap.min.css" rel="stylesheet" />
    <link href="style/bootstrap-spinner.css" rel="stylesheet" type="text/css" />
    <link href="style/main.css" rel="stylesheet" />

    <script src="script/jquery-1.7.2.min.js"></script>
    <script src="script/jquery.spinner.js"></script>
    <script src="script/bootstrap.js"></script>
    <script src="script/common.js"></script>
    <style type="text/css">
        #footermenu {
            height: 50px;
            line-height: 50px;
            padding: 0;
        }

        .add_list_p {
            padding: 5px 10px 5px 10px;
        }

        .sc-address-block {
            padding-top: 10px;
        }

        input[type=text] {
            padding: 5px 5px;
        }

        .add_list_p input, .add_list_p select {
            height: auto;
        }

        .watch_color_left {
            height: 30px;
            width: 80px;
            line-height: 30px;
            display: block;
            border: 1px solid #ccc;
            border-radius: 4px;
            float: left;
        }

        .watch_color_right {
            height: 30px;
            width: 80px;
            line-height: 30px;
            display: block;
            border: 1px solid #ccc;
            border-radius: 4px;
            float: left;
            margin-left: 10px;
        }

        .watch_blue {
            background: #12A7E7;
            color: #fff;
        }

        .watch_red {
            background: #FA3A9B;
            color: #fff;
        }
    </style>
</head>
<body>
    <form method="post">
        <div class="mainpage" style="max-width: 640px; margin: 0 auto; padding: 0 10px;">
            <div style="background: #fff; margin-top: 10px; padding: 10px; text-align: center; line-height: 25px;">
                <img src="http://img.wfenxiao.com.cn/static/js/ueditor/jsp/upload/image/20151211/1449821529496085775.png" width="100%" />
            </div>
            <div style="background: #fff; margin-top: 10px; padding: 10px; text-align: center; line-height: 25px;">
                <div style="width: 180px; margin: 10px auto;">
                    <a id="color_1" class="watch_color_left watch_blue" onclick="changeColor(1);">星空蓝</a>
                    <a id="color_2" class="watch_color_right" onclick="changeColor(2);">仙女红</a>
                    <div class="clear" style="height: 10px;"></div>
                </div>
                <div style="width: 300px; margin: 0px auto; text-align:center;">
                    <div style="">原价：<span class="red">￥399</span><br />　优惠券：<span class="red" id="couponVal">￥-100</span></div>
                    <div style="width:72px; margin:10px auto;">
                        <input type="text" class="spinner" />
                    </div>
                </div>
                <div class="clear" style="height: 10px;"></div>
                <a><strong id="total_amount">应付总额: <span class="red">--</span></strong></a>
            </div>

            <div class="sc-address-block rel" style="margin: 10px 0 0;">
                <p class="add_list_p rel">
                    <input type="text" id="consignee" name="consignee" placeholder="请输入收货人姓名" />
                </p>
                <p class="add_list_p rel">
                    <input type="text" id="mobile" name="mobile" placeholder="请输入手机号" maxlength="11" />
                </p>
                <p class="add_list_p rel">
                    <input type="text" id="address" name="address" placeholder="请输入地址" />
                </p>
            </div>
            <div style="background: #fff; margin-top: 10px; padding: 10px; text-align: left; line-height: 25px;">
                <h3>手表介绍：</h3>
                <p>
                    <br />
                </p>
                <p>　　星空侠，卫安全，为安心。</p>
                <p>　　星空侠儿童安全电话手表，适用于3-12岁儿童使用，为亲子家庭提供基于儿童安全为核心的定位，电话，SOS，儿童安全教育等互联网服务。</p>
                <p>　　国内首款内置中国移动SIM卡的儿童定位安全智能可穿戴设备:采集孩子各类信息，上传云端，实时同步到家长APP，缔造中国儿童安全智能守护的新标准!</p>
                <p>
                    <br />
                </p>
                <p>
                    <img alt="" title="1449821528872078775.jpg" src="http://img.wfenxiao.com.cn/static/js/ueditor/jsp/upload/image/20151211/1449821528872078775.jpg"></p>
                <p>
                    <img alt="" title="1449821528950066669.jpg" src="http://img.wfenxiao.com.cn/static/js/ueditor/jsp/upload/image/20151211/1449821528950066669.jpg"></p>
                <p>
                    <img alt="" title="1449821529959018941.jpg" src="http://img.wfenxiao.com.cn/static/js/ueditor/jsp/upload/image/20151211/1449821529959018941.jpg">
                </p>
                <p>
                    <img alt="" title="1449821530122074199.png" src="http://img.wfenxiao.com.cn/static/js/ueditor/jsp/upload/image/20151211/1449821530122074199.png">
                </p>
                <p>
                    <img alt="" title="1449821530816060298.png" src="http://img.wfenxiao.com.cn/static/js/ueditor/jsp/upload/image/20151211/1449821530816060298.png">
                </p>
                <p>　　本手表已内置移动SIM卡，手表收到后开机即可使用，无需再另行购买SIM卡</p>
                <p>　　①基础套餐：月套餐费13元/月，含30分钟全国漫游主叫，30M包月流量； </p>
                <p>　　②套餐外语音包：10元含40分钟主叫时长；接听免费！</p>
                <p>
                    <br />
                </p>
                <p>星空侠手表的常见问题和使用方法</p>
                <p><a href="http://tbjiaoyu.com/changjianwenti.html">http://tbjiaoyu.com/changjianwenti.html</a></p>
                <p>新东方创始人俞敏洪倾力推荐星空儿童卫士</p>
                <p><a href="http://v.youku.com/v_show/id_XOTQ1MzYwMTAw.html">http://v.youku.com/v_show/id_XOTQ1MzYwMTAw.html</a></p>
            </div>
            <div class="clear" style="height: 60px;"></div>
            <div class="m-bottom">
                <ul id="footermenu">
                    <li style="width: 100%;">
                        <input type="hidden" name="hidIndex" id="hidIndex" value="1" />
                        <input type="hidden" name="hidCount" id="hidCount" />
                        <input type="hidden" name="hidColor" id="hidColor" value="星空蓝" />
                        <a href="javascript:SubOrder();" style="display: block;">
                            <button type="button" style="width: 90%; padding: 6px 0;" class="btn btn-danger">微信安全支付</button>
                        </a>
                    </li>
                </ul>
                <div class="clear"></div>
            </div>
        </div>
        <div id="myModal" class="modal hide fade" style="left: auto">
            <div class="modal-body">
                <p id="ModalContent"></p>
            </div>
            <div class="modal-footer">
                <button class="btn" data-dismiss="modal" aria-hidden="true">确定</button>
            </div>
        </div>
    </form>

    <script type="text/javascript" src="http://res.wx.qq.com/open/js/jweixin-1.0.0.js"></script>
    <script type="text/javascript">

        var shareTitle = "恭喜你获得100元【星空侠安全电话手表】代金券"; //标题
        var shareImg = "http://img.wfenxiao.com.cn/static/js/ueditor/jsp/upload/image/20151211/1449821529496085775.png"; //图片
        var shareContent = '恭喜你获得100元【星空侠安全电话手表】代金券。代金券有效期为2016年3月10日23点59分。'; //简介
        var shareLink = 'http://mall.luqinwenda.com/Activity_watch.aspx'; //链接
        wx.config({
            debug: false, // 开启调试模式,调用的所有api的返回值会在客户端alert出来，若要查看传入的参数，可以在pc端打开，参数信息会通过log打出，仅在pc端时才会打印。
            appId: '<%=appId%>', // 必填，公众号的唯一标识
            timestamp: '<%=timeStamp%>', // 必填，生成签名的时间戳
            nonceStr: '<%=nonceStr%>', // 必填，生成签名的随机串
            signature: '<%=shaParam %>', // 必填，签名，见附录1
            jsApiList: [
                    'onMenuShareTimeline',
                    'onMenuShareAppMessage']
        });

        $(document).ready(function () {
            $('.spinner').spinner({});


            wx.ready(function () {
                //分享到朋友圈
                wx.onMenuShareTimeline({
                    title: shareTitle, // 分享标题
                    link: shareLink, // 分享链接
                    imgUrl: shareImg, // 分享图标
                    success: function () {
                        // 用户确认分享后执行的回调函数
                        shareSuccess();
                    }
                });

                //分享给朋友
                wx.onMenuShareAppMessage({
                    title: shareTitle, // 分享标题
                    desc: shareContent, // 分享描述
                    link: shareLink, // 分享链接
                    imgUrl: shareImg, // 分享图标
                    success: function () {
                        // 用户确认分享后执行的回调函数

                    }
                });
            });
        });

        function changeColor(o) {
            var str = '星空蓝';
            if (o == 2) {
                str = '仙女红';
                $('#color_1').removeClass('watch_blue');
                $('#color_2').addClass('watch_red');
            }
            else {
                $('#color_1').addClass('watch_blue');
                $('#color_2').removeClass('watch_red');
            }
            $('#hidColor').val(str);
        }

        function SubOrder() {

            if ($("#consignee").val().Trim() == "") {
                alert("请输入收件人姓名");
                return;
            }
            if ($("#mobile").val().Trim() == "") {
                alert("请输入手机号");
                return;
            }
            if (!$("#mobile").val().isMobile()) {
                alert("请输入正确的手机号");
                return;
            }
            if ($("#address").val().Trim() == "") {
                alert("请输入地址");
                return;
            }
            $('#hidCount').val($('#in_count').val());
            document.forms[0].submit();
        }

    </script>
</body>
</html>
