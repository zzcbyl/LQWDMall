﻿<%@ Page Title="《用眼光创造财富》五一亲子特训营" Language="C#" MasterPageFile="~/Master.master" %>
<%@ Import Namespace="System.Web.Script.Serialization" %>
<%@ Import Namespace="System.Threading" %>

<asp:Content ID="Content1" ContentPlaceHolderID="MasterHead" Runat="Server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="MasterContent" Runat="Server">
<div class="mainpage">
    <div class="titleNav">
        <span class="titleSpan">报名表</span>
    </div>
    <div class="sc-address-block rel" style="margin-bottom:0; padding-bottom:10px;">
        <img src="upload/prodimg/51ying_bai.jpg" width="100%" />
        <div style="line-height:30px; margin-top:10px; font-weight:bold;">
            <h4>《用眼光创造财富》五一亲子特训营</h4>
            <div> 2016年4月30日-5月2日（五一假期）　北京</div></div>
    </div>
    <div class="sc-address-block rel" style="margin-top:10px; padding-top:10px;">
        <a name="ATable"></a>
        <p class="add_list_p rel">
            <input type="text" id="childName" maxlength="50" name="childName" placeholder="请输入姓名" />
        </p>
        <p class="add_list_p rel">
            <input type="text" id="parentMobile" maxlength="11" name="parentMobile" placeholder="请输入手机号码" />
        </p>
        <p class="add_list_p rel">
            <input type="text" id="parentEmail" maxlength="100" name="parentEmail" placeholder="请输入电子邮箱" />
        </p>
    </div>
    <div style="background:#fff; margin:10px; padding:10px; line-height:22px;">
        <ul id="prodlist">
            <li id="prodLi" class="sub-cart-prod"></li>
            <li id="totalLi" class="sub-total" style="text-align:center; font-weight:bold; padding:15px 0;">
                <div style="clear:both; border:1px solid #ccc; height:22px; width:86px; line-height:22px; margin:5px auto; vertical-align:middle; ">
                    <a style="width:22px; height:22px; border-right:1px solid #ccc; line-height:23px; text-align:center; display:block; float:left;" onclick="subANum();">－</a>
                    <input type="text" id="txtCount" name="txtCount" style="width:40px; text-align:center; border:none; display:block; float:left; height:22px; line-height:23px; padding:0; margin:0;" maxlength="3" value="1" onkeyup="updANum();" />
                    <a style="width:22px; height:22px;border-left:1px solid #ccc; line-height:23px; text-align:center; display:block; float:left;" onclick="addANum();">＋</a>
                    <a style="display:block; margin-right:-30px;">人</a>
                </div>
                <div><a class="pd10"><span class="red">需支付：￥<span id="prod_price"></span></span></a></div>
                <div style="clear:both;"></div>
            </li>
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
                <a href="javascript:SubOrder();" style="display:block; margin-top:5px;" ><button type="button" style="width:90%; padding:6px 0;" class="btn btn-danger" onclick="SubOrder();">微信安全支付</button></a>
                <a style="float:right; margin-right:10px; display:none"><strong id="total_amount">应付总额: <span class="red">--</span></strong></a>
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
    public string repeatCustomer = "0";
    public string StartDate = "";
    public string Yprice = "";
    protected void Page_Load(object sender, EventArgs e)
    {
        if (this.Session["RepeatCustomer"] != null)
            repeatCustomer = this.Session["RepeatCustomer"].ToString();
        if (Request.Form["hidIndex"] != null && Request.Form["hidIndex"].ToString() == "1")
        {
            submitOrder(Request.Form["myToken"].ToString());
        }

        string result = HTTPHelper.Get_Http(System.Configuration.ConfigurationManager.AppSettings["apiDomain"].ToString() + "api/product_get_detail.aspx?productid=" + Request["productid"]);
        JavaScriptSerializer json = new JavaScriptSerializer();
        Dictionary<string, object> dic = json.Deserialize<Dictionary<string, object>>(result);
        if (dic.Keys.Contains("startTime"))
        {
            StartDate = dic["startTime"].ToString().Replace("/", "-").Split(' ')[0];
            Yprice = (Convert.ToInt64(dic["price"].ToString()) / 100).ToString();
        }
    }
    private void submitOrder(string token)
    {
        int count = (Request.Form["txtCount"] == null ? 1 : int.Parse(Request.Form["txtCount"].ToString().Trim()));
        string memo = "姓名：" + Request.Form["childName"].ToString() + "，手机号码：" + Request.Form["parentMobile"].ToString()
                    + "，电子邮箱：" + Request.Form["parentEmail"].ToString();
        string parms = "token=" + token + "&name=&cell=&province=&city=&address=&zip=&productid=" + Request["productid"].ToString() + "&count=" + count + "|1&memo=" + memo + "&wechatid=";

        string getUrl = Util.ApiDomainString + "api/order_place.aspx?" + parms;
        string result = HTTPHelper.Get_Http(getUrl);
        JavaScriptSerializer json = new JavaScriptSerializer();
        ReturnOrder jsonorder = json.Deserialize<ReturnOrder>(result);
        if (jsonorder.status == 1)
        {
            submitOrder(MyToken.ForceGetToken(Request.Form["myOpenid"].ToString()));
        }
        else
        {
            //发送报名表
            if (!Request.Form["parentEmail"].ToString().Equals(""))
            {
                string reciveUser = System.Configuration.ConfigurationManager.AppSettings["mail_user"].ToString();
                string recivePwd = System.Configuration.ConfigurationManager.AppSettings["mail_pwd"].ToString();
                string server = System.Configuration.ConfigurationManager.AppSettings["mail_host"].ToString();

                string body = "<div style=\"padding:20px;\">" +
                            "<div>您好，欢迎您参加知心姐姐假日营！</div>" +
                            "<div style=\"margin-top:10px;\">有任何关于假日营的问题，请联系：18601016361 新老师</div>" +
                            "<div style=\"margin-top:10px;\">请按如下要求认真填写报名表：</div>" +
                            "<div style=\"margin-left:20px; color:Red;\">" +
                            "<div>1. 请家长朋友尽可能详尽地填写报名表，这张表是老师们了解孩子的一个重要窗口；</div>" +
                            "<div>2. 填写好请以孩子姓名命名，并报名表请发送到xly@luqinwenda.com；</div>" +
                            "<div>3. 请家长把孩子的身份证或户口本页拍一张照片附在报名表里，便于后勤老师为孩子购买有效保险；</div>" +
                            "</div></div>";
                string subject = "2016假日营报名表";
                string attach = Server.MapPath(@"/upload/file/知心姐姐假日营报名表2016.docx");

                string[] para = new string[]{
                    reciveUser, recivePwd, Request.Form["parentEmail"].ToString(), subject, body, server, attach
                };
                Thread th = new Thread(Mail.SendMailAsyn);
                th.Start(para);
            }
            if (Request["followerAmount"] != null && Request["followerAmount"].ToString() != "" && Convert.ToInt32(Request["followerAmount"].ToString()) > 0)
            {
                string bargainUrl = Util.ApiDomainString + "api/promote_get_sub_users.aspx?openid=" + Request.Form["myOpenid"].ToString();
                string bargainResult = HTTPHelper.Get_Http(bargainUrl);
                Dictionary<string, object> dicBargain = (Dictionary<string, object>)json.DeserializeObject(bargainResult);
                if ((int)dicBargain["count"] > 0)
                {
                    Object[] objList = (Object[])dicBargain["sub-open-id-info"];
                    int objCount = objList.Count<object>();
                    int TotalAmount = objCount * 100 * 10;
                    string discountUrl = Util.ApiDomainString + "api/order_price_discount.aspx?oid=" + jsonorder.order_id + "&discountamount=" + TotalAmount;
                    string discountResult = HTTPHelper.Get_Http(discountUrl);
                    Dictionary<string, object> dicDiscount = (Dictionary<string, object>)json.DeserializeObject(discountResult);
                    if (dicDiscount["status"].ToString() == "1")
                    {
                        Response.Write("优惠金额错误,请重新支付");
                        Response.End();
                        return;
                    }
                }
            }
            if (Request["productid"].ToString().Equals("28"))
            {
                int discount = 0;
                if (this.Session["RepeatCustomer"].ToString().Equals("1"))
                {
                    discount += 30000;
                }
                if (DateTime.Now <= Convert.ToDateTime("2015-12-1"))
                {
                    discount += 30000;
                }
                if (!discount.Equals(0))
                {
                    string discountUrl = Util.ApiDomainString + "api/order_price_discount.aspx?oid=" + jsonorder.order_id + "&discountamount=" + discount;
                    string discountResult = HTTPHelper.Get_Http(discountUrl);
                    Dictionary<string, object> dicDiscount = (Dictionary<string, object>)json.DeserializeObject(discountResult);
                    if (dicDiscount["status"].ToString() == "1")
                    {
                        Response.Write("优惠金额错误,请重新支付");
                        Response.End();
                        return;
                    }
                }
            }

            if (Request["productid"].ToString().Equals("30"))
            {
                //int discount = 0;
                //if (this.Session["RepeatCustomer"].ToString().Equals("1"))
                //{
                //    discount += 100000;
                //}
                //if (DateTime.Now <= Convert.ToDateTime("2015-12-1"))
                //{
                //    discount += 80000;
                //}
                //if (!discount.Equals(0))
                //{
                //    string discountUrl = Util.ApiDomainString + "api/order_price_discount.aspx?oid=" + jsonorder.order_id + "&discountamount=" + discount;
                //    string discountResult = HTTPHelper.Get_Http(discountUrl);
                //    Dictionary<string, object> dicDiscount = (Dictionary<string, object>)json.DeserializeObject(discountResult);
                //    if (dicDiscount["status"].ToString() == "1")
                //    {
                //        Response.Write("优惠金额错误,请重新支付");
                //        Response.End();
                //        return;
                //    }
                //}

                Response.Redirect("JoinSuccess.aspx");
                return;
            }

            int userid = Users.CheckToken(token);
            Order order = new Order(int.Parse(jsonorder.order_id));
            int total = int.Parse(order._fields["orderprice"].ToString()) + int.Parse(order._fields["shipfee"].ToString()) + int.Parse(order._fields["ajustfee"].ToString());
            total = total <= 0 ? 0 : total;
            string param = "?body=卢勤问答平台官方夏令营&detail=卢勤问答平台官方夏令营&userid=" + userid + "&product_id=" + order._fields["oid"] + "&total_fee=" + total.ToString();
            string payurl = "";
            //if (Request.Form["myFrom"] != null && Request.Form["myFrom"].ToString() != "")
            //{
                //微信支付
                payurl = "http://weixin.luqinwenda.com/payment/payment.aspx";
            //}
            //else
            //{
            //    //易宝支付
            //    payurl = "http://yeepay.luqinwenda.com/weixin_payment.aspx";
            //}
            if (Request["productid"].ToString() == "27")
            {
                if (total == 0)
                {
                    this.Response.Redirect("paySuccess.aspx?product_id=" + order._fields["oid"]);
                }
                //微信支付
                payurl = "http://weixin.luqinwenda.com/payment/payment.aspx";
            }
            this.Response.Redirect(payurl + param);
        }
    }

    public class ReturnDiscount
    {
        public int status { get; set; }
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
    var repeat = '<%=repeatCustomer %>';
    var prodid = QueryString('productid');
    var pCount;
    var price_1;
    $(document).ready(function () {
        if (prodid == null) {
            alert('商品参数有误');
            return;
        }
        lineLink = "http://mall.luqinwenda.com/join_xly1.aspx?productid=" + prodid;
        so_fillProd_xly();

    });

    function so_fillProd_xly() {
        $.ajax({
            type: "get",
            async: false,
            url: domain + 'api/product_get_detail.aspx',
            data: { productid: prodid, random: Math.random() },
            success: function (data, textStatus) {
                var obj = eval('(' + data + ')');
                if (obj != null) {
                    price_1 = parseInt(obj.price);
                    var strprice = '<span class="">￥' + price_1 / 100 + '</span>';
                    
                    var prodhtml = '<a class="prod-img" href="Detail_xly.aspx?productid=' + obj.prodid + '"><img src="' + domain + obj.imgsrc + '" width="50px" height="50px" /></a><a class="prod-title" href="Detail_xly.aspx?productid=' + obj.prodid + '">' + obj.prodname + '</a><a class="prod-price">' + strprice + '</a><a class="prod-count"></a>';
                    $("#total_amount span").eq(0).html('¥' + price_1 / 100);

                    $('#prodLi').html(prodhtml);
                    $("#prod_price").html(price_1 / 100);
                }
            }
        });

    }

    function returnxly() {
        //location.href = 'Detail_xly.aspx?productid=' + prodid;
    }

    function SubOrder() {
        if ($("#childName").val().Trim() == "") {
            $("#ModalContent").html("请输入姓名");
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

        if ($("#parentEmail").val().Trim() == "") {
            $("#ModalContent").html("请输入电子邮箱");
            $('#myModal').modal('show');
            return;
        }
        var emailReg = /^[-._A-Za-z0-9]+@([_A-Za-z0-9]+\.)+[A-Za-z0-9]{2,3}$/;
        if (!emailReg.test($("#parentEmail").val().Trim())) {
            $("#ModalContent").html("请输入正确的电子邮箱");
            $('#myModal').modal('show');
            return;
        }

        GetOpenidToken();
        $("#myToken").val(token);
        $("#myOpenid").val(openid);
        $("#myFrom").val(from);
        document.forms[0].submit();
    }

    function subANum()
    {
        pCount = parseInt($("#txtCount").val());
        if (pCount <= 1) {
            $("#txtCount").val("1");
        }
        else {
            $("#txtCount").val(pCount - 1);
        }
        fillPrice();
    }

    function addANum()
    {
        pCount = parseInt($("#txtCount").val());
        if (pCount >= 10) {
            $("#txtCount").val("10");
        }
        else {
            $("#txtCount").val(pCount + 1);
        }
        fillPrice();
    }

    function updANum() {
        
        pCount = parseInt($("#txtCount").val());
        if (!isint($("#txtCount").val())) {
            $("#txtCount").val("1");
        }
        else {
            if (pCount >= 10) {
                $("#txtCount").val("10");
            }
            if (pCount <= 1) {
                $("#txtCount").val("1");
            }
        }
        fillPrice();

    }

    function fillPrice()
    {
        $("#prod_price").html((price_1 * parseInt($("#txtCount").val())) / 100);
    }

</script>

</asp:Content>


