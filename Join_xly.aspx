<%@ Page Title="" Language="C#" MasterPageFile="~/Master.master" %>
<%@ Import Namespace="System.Web.Script.Serialization" %>

<asp:Content ID="Content1" ContentPlaceHolderID="MasterHead" Runat="Server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="MasterContent" Runat="Server">
<div class="mainpage">
    <div class="titleNav">
        <a onclick="returnxly();" class="returnA"> </a>
        <span class="titleSpan">报名表</span>
    </div>
    <div class="sc-address-block rel">
        <p class="add_list_p rel">
            <input type="text" id="childName" maxlength="50" name="childName" placeholder="请输入孩子姓名" />
        </p>
        <p class="add_list_p rel">
            <input type="text" id="childIDcard" maxlength="50" name="childIDcard" placeholder="请输入孩子身份证" />
        </p>
        <p class="add_list_p rel">
            <input type="text" id="parentName" maxlength="50" name="parentName" placeholder="请输入家长姓名" />
        </p>
        <p class="add_list_p rel">
            <input type="text" id="parentMobile" maxlength="11" name="parentMobile" placeholder="请输入手机号码" />
        </p>
        <p class="add_list_p rel">
            <input type="text" id="parentEmail" maxlength="100" name="parentEmail" placeholder="（选填）请输入电子邮箱" />
        </p>
    </div>
    <div style="background:#fff; margin:10px; padding:10px; line-height:22px;">
        <ul id="prodlist">
            
        </ul>
    </div>
    <%--<div style="background:#fff; margin:10px; padding:10px; height:100px; position:relative;">
        <div style="padding-right:10px; height:60px;" class="rel">   
            <textarea id="memo" name="memo" style="width:100%; padding:5px; height:40px; line-height:20px;" placeholder="（选填）留言：如果您需要卢勤老师亲笔签名，请留下需要被签名者姓名以及签名要求。"></textarea>
            </div>
        <div style="padding-right:10px;" class="rel">
            <input id="wechatid" name="wechatid" type="text" style="width:50%; padding:5px; line-height:20px;" placeholder="（选填）微信号" maxlength="50" />
        </div>
    </div>--%>
    <div class="clear" style="height:60px;"></div>
    <div class="m-bottom">
        <ul id="footermenu">
            <li style="width:100%;">
                <input type="hidden" name="hidIndex" id="hidIndex" value="1" />
                <input type="hidden" name="myToken" id="myToken" value="" />
                <input type="hidden" name="myOpenid" id="myOpenid" value="" />
                <input type="hidden" name="myFrom" id="myFrom" value="" />
                <a href="javascript:SubOrder();" style="float:right; margin:8px 10px 0 0;"><button type="button" class="btn btn-danger" onclick="SubOrder();">提交报名</button></a>
                <a style="float:right; margin-right:10px;"><strong id="total_amount">应付总额: <span class="red">--</span></strong></a>
            </li>
        </ul>
        <div class="clear"></div>
    </div>
</div>

<div id="myModal" class="modal hide fade" style="left:50%;" >
    <div class="modal-body">
        <p id="ModalContent"></p>
    </div>
    <div class="modal-footer">
        <button class="btn" data-dismiss="modal" aria-hidden="true">确定</button>
    </div>
</div>

<script runat="server">
    protected void Page_Load(object sender, EventArgs e)
    {
        if (Request.Form["hidIndex"] != null && Request.Form["hidIndex"].ToString() == "1")
        {
            submitOrder(Request.Form["myToken"].ToString());
        }
    }
    private void submitOrder(string token)
    {
        string memo = "孩子姓名：" + Request.Form["childName"].ToString() + "，孩子身份证：" + Request.Form["childIDcard"].ToString()
                    + "，家长姓名：" + Request.Form["parentName"].ToString() + "，手机号码：" + Request.Form["parentMobile"].ToString()
                    + "，电子邮箱：" + Request.Form["parentEmail"].ToString();
        string parms = "token=" + token + "&name=&cell=&province=&city=&address=&zip=&productid=" + Request["productid"].ToString() + "&count=1|1&memo=" + memo + "&wechatid=";

        string getUrl = Util.ApiDomainString + "api/order_place.aspx?" + parms;
        string result = HTTPHelper.Get_Http(getUrl);
        JavaScriptSerializer json = new JavaScriptSerializer();
        ReturnOrder jsonorder = json.Deserialize<ReturnOrder>(result);
        if (jsonorder.status == -1)
        {
            //理论不可能过期，提交之前已获取最新token
            string tokenUrl = Util.ApiDomainString + "api/user_get_token.aspx?username=" + Request.Form["myOpenid"].ToString();
            string tokenResult = HTTPHelper.Get_Http(tokenUrl);
            ReturnToken jsontoken = json.Deserialize<ReturnToken>(tokenResult);
            if (jsontoken.status != -1)
                submitOrder(jsontoken.token);
        }
        else
        {
            if (Request["productid"].ToString() == "24")
            {
                Response.Redirect("JoinSuccess.aspx");
                return;
            }
            int userid = Users.CheckToken(token);
            Order order = new Order(int.Parse(jsonorder.order_id));
            int total = int.Parse(order._fields["orderprice"].ToString()) + int.Parse(order._fields["shipfee"].ToString());
            string param = "?body=卢勤问答平台官方书城&detail=卢勤问答平台官方书城&userid=" + userid + "&product_id=" + order._fields["oid"] + "&total_fee=" + total.ToString();
            string payurl = "";
            if (Request.Form["myFrom"] != null && Request.Form["myFrom"].ToString() != "")
            {
                //微信支付
                payurl = "http://weixin.luqinwenda.com/payment/payment.aspx";
            }
            else
            {
                //易宝支付
                payurl = "http://yeepay.luqinwenda.com/weixin_payment.aspx";
            }
            this.Response.Redirect(payurl + param);
        }
    }

    public class ReturnOrder
    {
        public int status { get; set; }
        public string order_id { get; set; }
    }
    public class ReturnToken
    {
        public int status { get; set; }
        public string token { get; set; }
        public string expire_date { get; set; }
    }
</script>

<script type="text/javascript">

    var prodid = QueryString('productid');
    $(document).ready(function () {
        if (prodid == null) {
            alert('商品参数有误');
            return;
        }
        so_fillProd_xly();

    });

    function so_fillProd_xly() {
        $('#prodlist').html('<li><div class="loading"><img src="images/loading.gif" /><br />加载中...</div></li>');
        $.ajax({
            type: "get",
            async: false,
            url: domain + 'api/product_get_detail.aspx',
            data: { productid: prodid, random: Math.random() },
            success: function (data, textStatus) {
                var obj = eval('(' + data + ')');
                if (obj != null) {
                    var totalHtml = '<li class="sub-total" style="height:20px; text-align:right; padding:15px 0;"><a>合计: <span class="red">¥' + parseInt(obj.price) / 100 + '</span></a></li>';
                    var strprice = '<span class="red">¥' + parseInt(obj.price) / 100 + '</span>';
                    if (obj.prodid == 24) {
                        strprice = '';
                        totalHtml = '';
                        $("#total_amount").hide();
                    }
                    var prodhtml = '<li class="sub-cart-prod"><a class="prod-img" href="Detail_xly.aspx?productid=' + obj.prodid + '"><img src="' + domain + obj.imgsrc + '" width="50px" height="50px" /></a><a class="prod-title" href="Detail_xly.aspx?productid=' + obj.prodid + '">' + obj.prodname + '</a><a class="prod-price">' + strprice + '</a><a class="prod-count">X 1</a></li>';
                    $("#total_amount span").eq(0).html('¥' + parseInt(obj.price) / 100);
                    $('#prodlist').html(prodhtml + totalHtml);
                }
            }
        });

    }

    function returnxly() {
        location.href = 'Detail_xly.aspx?productid=' + prodid;
    }

    function SubOrder() {
        if ($("#childName").val().Trim() == "") {
            $("#ModalContent").html("请输入孩子姓名");
            $('#myModal').modal('show');
            return;
        }
        if ($("#childIDcard").val().Trim() == "") {
            $("#ModalContent").html("请输入孩子身份证");
            $('#myModal').modal('show');
            return;
        }
        var result = isIdCardNo($("#childIDcard").val().Trim());
        if (result != "") {
            $("#ModalContent").html("请输入正确的身份证");
            $('#myModal').modal('show');
            return;
        }
        if ($("#parentName").val().Trim() == "") {
            $("#ModalContent").html("请输入家长姓名");
            $('#myModal').modal('show');
            return;
        }

        if ($("#parentMobile").val().Trim() == "") {
            $("#ModalContent").html("请输入手机号码");
            $('#myModal').modal('show');
            return;
        }
        if (!$("#parentMobile").val().isMobile()) {
            $("#ModalContent").html("请输入正确的手机号码");
            $('#myModal').modal('show');
            return;
        }

        var emailReg = /^[-._A-Za-z0-9]+@([_A-Za-z0-9]+\.)+[A-Za-z0-9]{2,3}$/;
        if ($("#parentEmail").val().Trim() != "") {
            if (!emailReg.test($("#parentEmail").val().Trim())) {
                $("#ModalContent").html("请输入正确的电子邮箱");
                $('#myModal').modal('show');
                return;
            }
        }

        GetOpenidToken();
        $("#myToken").val(token);
        $("#myOpenid").val(openid);
        $("#myFrom").val(from);
        document.forms[0].submit();
    }
</script>

</asp:Content>


