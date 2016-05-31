<%@ Page Title="" Language="C#" MasterPageFile="~/Master.master" %>
<%@ Import Namespace="System.Web.Script.Serialization" %>
<asp:Content ID="Content1" ContentPlaceHolderID="MasterHead" Runat="Server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="MasterContent" Runat="Server">
<div class="mainpage">
    <div class="titleNav">
        <a href="ShopCart.aspx" class="returnA"> </a>
        <span class="titleSpan">确认下单</span>
    </div>
    <div class="sc-address-block rel">
        <p class="add_list_p rel">
                        <input type="text" id="consignee" name="consignee" placeholder="请输入收货人姓名" />
        </p>
        <p class="add_list_p rel">
                        <input type="text" id="mobile" name="mobile" placeholder="请输入手机号" />
        </p>
        <p class="add_list_p rel">
                        <select id="province" name="province"></select>
        </p>
        <p class="add_list_p rel">
            <select id="city" name="city"></select>
        </p>
        <%--<p class="add_list_p rel">
            <select></select>
        </p>--%>
        <p class="add_list_p rel">
            <input type="text" id="address" name="address" placeholder="请输入详细地址" />
        </p>
    </div>
    <%--<div style="background:#fff; margin:10px; padding:10px; line-height:22px; margin-bottom:0;">
        在线支付
    </div>
    <div style="background:#f0f0f0; margin:10px; padding:10px; line-height:30px; margin-top:0;">
        <div class="radio"><label><input type="radio"> 微信支付</label></div>
        <div class="radio"><label><input type="radio"> 银行卡支付</label></div>
    </div>--%>
    <div style="background:#fff; margin:10px; padding:10px; line-height:22px;">
        <ul id="prodlist">
            <li><div class="loading"><img src="images/loading.gif" /><br />加载中...</div></li>
        </ul>
    </div>
    <% if(DateTime.Now > Convert.ToDateTime("2016-6-1 00:00") && DateTime.Now < Convert.ToDateTime("2016-6-2 00:00")) { %>
        <div style="background:#fff; margin:10px; padding:10px; position:relative;">
            <div style="height:30px; line-height:30px; font-weight:bold;">使用积分优惠</div>
            <input id="IntegralTxt" name="IntegralTxt" type="text" onblur="useIntegral();" style="width:40%; padding:5px; line-height:20px; margin-bottom:0;" placeholder="" maxlength="20" value="" />
            <button type="button" class="btn" onclick="useIntegral();">使用</button>
            <span id="IntegralErrorMsg" class="red right" style="padding-top: 5px;"></span>
        </div>
    <%} else { %>
        <div style="background:#fff; margin:10px; padding:10px; position:relative;">
            <input id="conponTxt" name="conponTxt" type="text" onblur="useCoupon();" style="width:40%; padding:5px; line-height:20px; margin-bottom:0;" placeholder="优惠码" maxlength="20" value="<%=couponStr %>" />
            <button type="button" class="btn" onclick="useCoupon();">使用</button>
            <span id="conponErrorMsg" class="red right" style="padding-top: 5px;"></span>
        </div>
    <%} %>
    <div style="background:#fff; margin:10px; padding:10px; height:100px; position:relative;">
        <div style="padding-right:10px; height:60px;" class="rel">   
            <textarea id="memo" name="memo" style="width:100%; padding:5px; height:40px; line-height:20px;" placeholder="（选填）留言"></textarea>
            </div>
        <div style="padding-right:10px;" class="rel">
            <input id="wechatid" name="wechatid" type="text" style="width:50%; padding:5px; line-height:20px;" placeholder="（选填）微信号" maxlength="50" />
        </div>
    </div>
    <div class="clear" style="height:60px;"></div>
    <div class="m-bottom">
        <ul id="footermenu">
            <li style="width:100%;">
                <input type="hidden" name="hidIndex" id="hidIndex" value="1" />
                <input type="hidden" name="myProvince" id="myProvince" value="" />
                <input type="hidden" name="myCity" id="myCity" value="" />
                <input type="hidden" name="myToken" id="myToken" value="" />
                <input type="hidden" name="myOpenid" id="myOpenid" value="" />
                <input type="hidden" name="myFrom" id="myFrom" value="" />
                <input type="hidden" name="prodids" id="prodids" value="" />
                <input type="hidden" name="counts" id="counts" value="" />
                <a href="javascript:SubOrder();" style="float:right; margin:8px 10px 0 0;"><button type="button" class="btn btn-danger" onclick="SubOrder();">提交订单</button></a>
                <a style="float:right; margin-right:10px;"><strong id="total_amount">应付总额: <span class="red">--</span></strong></a>
                <span id="errorMsg_Server" runat="server" class="red right mgright"></span>
            </li>
        </ul>
        <div class="clear"></div>
    </div>
</div>

<div id="myModal" class="modal hide fade" style="left:auto" >
    <div class="modal-body">
        <p id="ModalContent"></p>
    </div>
    <div class="modal-footer">
        <button class="btn" data-dismiss="modal" aria-hidden="true">确定</button>
    </div>
</div>

<script runat="server">
    public string couponStr = "";
    protected void Page_Load(object sender, EventArgs e)
    {
        if (Request.Form["hidIndex"] != null && Request.Form["hidIndex"].ToString() == "1")
        {
            submitOrder(Request.Form["myToken"].ToString());
        }
        if (this.Session["couponCode"] != null)
        {
            couponStr = this.Session["couponCode"].ToString();
        }
    }
    private void submitOrder(string token)
    {
        int userid = Users.CheckToken(token);
        JavaScriptSerializer json = new JavaScriptSerializer();
        int couponAmount = 0;
        if (Request.Form["conponTxt"] != null && !Request.Form["conponTxt"].ToString().Trim().Equals(string.Empty))
        {
            string couponUrl = Util.ApiDomainString + "api/coupon_check.aspx?code=" + Request.Form["conponTxt"].ToString();
            string couponResult = HTTPHelper.Get_Http(couponUrl);
            Dictionary<string, object> dicCoupon = (Dictionary<string, object>)json.DeserializeObject(couponResult);
            if (dicCoupon["status"].ToString() == "1")
            {
                this.errorMsg_Server.InnerText = "优惠券不存在";
                return;
            }
            else if (dicCoupon["used"].ToString() == "1")
            {
                this.errorMsg_Server.InnerText = "优惠券已使用";
                return;
            }
            else if (Convert.ToDateTime(dicCoupon["expire_date"].ToString()) < DateTime.Now)
            {
                this.errorMsg_Server.InnerText = "优惠券已过期";
                return;
            }
            else
                couponAmount = Convert.ToInt32(dicCoupon["amount"].ToString());
        }

        int integralAmount = 0;
        if (Request.Form["IntegralTxt"] != null && !Request.Form["IntegralTxt"].ToString().Trim().Equals(string.Empty))
        {
            int inputIntegral = 0;
            int.TryParse(Request.Form["IntegralTxt"].ToString(), out inputIntegral);
            if (inputIntegral > 0)
            {
                Users user = new Users(userid);
                int userIntegral = user.Integral;
                if (userIntegral > 0 && inputIntegral <= userIntegral)
                {
                    integralAmount = inputIntegral * 100;
                }
            }
        }
        
        string parms = "token=" + token + "&name=" + Request.Form["consignee"].ToString() + "&cell=" + Request.Form["mobile"].ToString()
                + "&province=" + Request.Form["myProvince"].ToString() + "&city=" + Request.Form["myCity"].ToString() + "&address=" + Request.Form["address"].ToString()
                + "&zip=&productid=" + Request.Form["prodids"].ToString() + "&count=" + Request.Form["counts"].ToString() + "&memo=" + Request.Form["memo"].ToString() 
                + "&wechatid=" + Request.Form["wechatid"].ToString();

        
        string getUrl = Util.ApiDomainString + "api/order_place.aspx?" + parms;
        string result = HTTPHelper.Get_Http(getUrl);
        ReturnOrder jsonorder = json.Deserialize<ReturnOrder>(result);
        if (jsonorder.status == 1)
        {
            //submitOrder(MyToken.ForceGetToken(Request.Form["myOpenid"].ToString()));
            Response.Redirect("Default.aspx");
        }
        else
        {

            #region 夏令营优惠（砍价活动）
            //if (Request.Form["myOpenid"] != null)
            //{
            //    if (Users.IsExistsUser("username", Request.Form["myOpenid"]))
            //    {
            //        Users user = Users.GetUser("username", Request.Form["myOpenid"]);
            //        if (user != null && int.Parse(user._fields["uid"].ToString()) > 0)
            //        {
            //            Order[] orderArr = Order.GetOrders(int.Parse(user._fields["uid"].ToString()), Convert.ToDateTime("2015-01-01"), Convert.ToDateTime("2015-06-30"));
            //            int index = 0;
            //            for (int i = 0; i < orderArr.Length; i++)
            //            {
            //                if (int.Parse(orderArr[i]._fields["ajustfee"].ToString()) != 0)
            //                {
            //                    index = 1;
            //                    break;
            //                }
            //            }
            //            if (index == 0)
            //            {
            //                string bargainUrl = Util.ApiDomainString + "api/promote_get_sub_users.aspx?grouponid=1&openid=" + Request.Form["myOpenid"].ToString();
            //                string bargainResult = HTTPHelper.Get_Http(bargainUrl);
            //                Dictionary<string, object> dicBargain = (Dictionary<string, object>)json.DeserializeObject(bargainResult);
            //                if ((int)dicBargain["count"] > 0)
            //                {
            //                    Object[] objList = (Object[])dicBargain["sub-open-id-info"];
            //                    int objCount = objList.Count<object>();
            //                    int TotalAmount = objCount * 100 * 1;
            //                    Order myorder = new Order(int.Parse(jsonorder.order_id));
            //                    if (TotalAmount > int.Parse(myorder._fields["orderprice"].ToString()))
            //                    {
            //                        TotalAmount = int.Parse(myorder._fields["orderprice"].ToString());
            //                    }
            //                    string discountUrl = Util.ApiDomainString + "api/order_price_discount.aspx?oid=" + jsonorder.order_id + "&discountamount=" + TotalAmount;
            //                    string discountResult = HTTPHelper.Get_Http(discountUrl);
            //                    Dictionary<string, object> dicDiscount = (Dictionary<string, object>)json.DeserializeObject(discountResult);
            //                    if (dicDiscount["status"].ToString() == "1")
            //                    {
            //                        Response.Write("优惠金额错误,请重新支付");
            //                        Response.End();
            //                        return;
            //                    }

            //                }
            //            }
            //        }
            //    }
            //} 
            #endregion

            if (couponAmount > 0)
            {
                string discountUrl = Util.ApiDomainString + "api/order_price_discount.aspx?oid=" + jsonorder.order_id + "&discountamount=" + couponAmount;
                string discountResult = HTTPHelper.Get_Http(discountUrl);
                Dictionary<string, object> dicDiscount = (Dictionary<string, object>)json.DeserializeObject(discountResult);
                if (dicDiscount["status"].ToString() == "1")
                {
                    Response.Write("优惠金额错误,请重新支付");
                    Response.End();
                    return;
                }

                string couponUrl = Util.ApiDomainString + "api/coupon_use.aspx?orderid=" + jsonorder.order_id + "&code=" + Request.Form["conponTxt"].ToString() + "&token=" + token;
                string couponResult = HTTPHelper.Get_Http(couponUrl);
                Dictionary<string, object> dicCoupon = (Dictionary<string, object>)json.DeserializeObject(couponResult);
                if (dicCoupon["status"].ToString() == "1")
                {
                    //submitOrder(MyToken.ForceGetToken(Request.Form["myOpenid"].ToString()));
                    Response.Redirect("Default.aspx");
                }
            }

            if (integralAmount > 0)
            {
                string discountUrl = Util.ApiDomainString + "api/order_price_discount.aspx?oid=" + jsonorder.order_id + "&discountamount=" + integralAmount;
                string discountResult = HTTPHelper.Get_Http(discountUrl);
                Dictionary<string, object> dicDiscount = (Dictionary<string, object>)json.DeserializeObject(discountResult);
                if (dicDiscount["status"].ToString() == "1")
                {
                    Response.Write("优惠金额错误,请重新支付");
                    Response.End();
                    return;
                }

                string type = "shopping";
                Integral.AddIntegral(userid, (0 - (integralAmount / 100)), "购书：订单编号 " + jsonorder.order_id, type, int.Parse(jsonorder.order_id), 0);
            }

            Order order = new Order(int.Parse(jsonorder.order_id));
            int total = (order.OrderPriceToPay < 0 ? 0 : order.OrderPriceToPay);
            if (total == 0)
            {
                this.Response.Redirect("paySuccess.aspx?product_id=" + order._fields["oid"] + "&paymethod=Integral");
            }
            string param = "?body=卢勤问答平台官方书城&detail=卢勤问答平台官方书城&userid=" + userid + "&product_id=" + order._fields["oid"] + "&total_fee=" + total.ToString();
            string payurl = "";
            //微信支付
            payurl = "http://weixin.luqinwenda.com/payment/payment.aspx";
            
            //易宝支付
            //payurl = "http://yeepay.luqinwenda.com/weixin_payment.aspx";
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
    var str_productids = "";
    var str_counts = "";
    var pcount = 0;
    var t_prod_price = 0;
    var t_prePrice = 0;
    var freight_fee = "--";
    var userIntegral = 0;
    $(document).ready(function () {
        so_fillProd();

        $("#province").change(function () {
            totalFeight($("#province option:selected").text(), pcount);
            so_fillCity($(this).val());
        });


        GetOpenidToken();
        $("#myToken").val(token);
        $("#myOpenid").val(openid);
        $("#myFrom").val(from);
        $("#prodids").val(str_productids);
        $("#counts").val(str_counts);
        $("#myProvince").val($("#province option:selected").text());
        $("#myCity").val($("#city option:selected").text());

        getUser_Info();
        useCoupon();
    });

    function SubOrder() {
        if ($("#consignee").val().Trim() == "") {
            $("#ModalContent").html("请输入收件人姓名");
            $('#myModal').modal('show');
            return;
        }
        if ($("#mobile").val().Trim() == "") {
            $("#ModalContent").html("请输入手机号");
            $('#myModal').modal('show');
            return;
        }
        if (!$("#mobile").val().isMobile()) {
            $("#ModalContent").html("请输入正确的手机号");
            $('#myModal').modal('show');
            return;
        }
        if ($("#address").val().Trim() == "") {
            $("#ModalContent").html("请输入详细地址");
            $('#myModal').modal('show');
            return;
        }
        if ($("#memo").val().length > 300) {
            $("#ModalContent").html("留言太长，请简要填写");
            $('#myModal').modal('show');
            return;
        }
        if ($("#province").val().Trim() == "0") {
            $("#ModalContent").html("请选择省份");
            $('#myModal').modal('show');
            return;
        }
        if ($("#city").val().Trim() == "0") {
            $("#ModalContent").html("请选择城市");
            $('#myModal').modal('show');
            return;
        }

        $("#myProvince").val($("#province option:selected").text());
        $("#myCity").val($("#city option:selected").text());
        delCookie("followerAmount");
        document.forms[0].submit();
    }

    function getUser_Info() {
        $.ajax({
            type: "get",
            async: true,
            url: domain + 'api/user_get_info.aspx',
            data: { token: token, random: Math.random() },
            dataType: 'json',
            success: function (data, textStatus) {
                if (data.status == 0) {
                    userIntegral = data.user_info.integral;
                    $('#IntegralTxt').attr('placeholder', '您有' + userIntegral + '积分可用');
                }
            }
        });
    }

    function useIntegral() {
        if ($('#IntegralTxt').val().Trim() != '' && isint($('#IntegralTxt').val().Trim())) {
            if (parseInt($('#IntegralTxt').val()) > userIntegral) {
                $('#IntegralErrorMsg').html("你的积分不足");
                $('#total_amount span').eq(0).html("￥" + ((t_prod_price + freight_fee + t_prePrice) / 100).toString());
            }
            else {
                $('#IntegralErrorMsg').html("<span style='color:#666;'>优惠:</span>￥" + $('#IntegralTxt').val());
                var total_amount = t_prod_price + freight_fee + t_prePrice - parseInt($('#IntegralTxt').val()) * 100;
                if (total_amount < 0) total_amount = 0;
                $('#total_amount span').eq(0).html("￥" + (total_amount / 100).toString());
            }
        }
        else {
            $('#IntegralErrorMsg').html('请输入积分');
            $('#total_amount span').eq(0).html("￥" + ((t_prod_price + freight_fee + t_prePrice) / 100).toString());
        }
    }
</script>

</asp:Content>

