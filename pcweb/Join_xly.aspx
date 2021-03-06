﻿<%@ Page Title="报名表-悦长大平台官方书城" Language="C#" MasterPageFile="~/pcweb/Master.master" %>
<%@ Import Namespace="System.Web.Script.Serialization" %>
<%@ Import Namespace="System.Threading" %>

<script runat="server">

</script>

<asp:Content ID="Content1" ContentPlaceHolderID="head" Runat="Server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" Runat="Server">
<div class="mainpage">
    <div class="sc-address-block rel">
        <p style="line-height:20px; font-weight:bold; margin:0 0 10px 10px;">填写报名信息</p>
        <p class="add_list_p rel list_pdl">
            <label>孩子姓名</label>
            <input type="text" id="childName" maxlength="50" name="childName" placeholder="请输入孩子姓名" />
        </p>
        <p class="add_list_p rel list_pdl">
            <label>孩子身份证</label>
            <input type="text" id="childIDcard" maxlength="50" name="childIDcard" placeholder="请输入孩子身份证" />
        </p>
        <p class="add_list_p rel list_pdl">
            <label>家长姓名</label>
            <input type="text" id="parentName" maxlength="50" name="parentName" placeholder="请输入家长姓名" />
        </p>
        <p class="add_list_p rel list_pdl">
            <label>手机号码</label>
            <input type="text" id="parentMobile" maxlength="11" name="parentMobile" placeholder="请输入手机号码" />
        </p>
        <p class="add_list_p rel list_pdl">
            <label>电子邮箱</label>
            <input type="text" id="parentEmail" maxlength="100" name="parentEmail" placeholder="请输入电子邮箱" />
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
    public string repeatCustomer = "0";
    public string openid = "";
    protected void Page_Load(object sender, EventArgs e)
    {
        if (Request.Cookies["openid"] != null)
            openid = Request.Cookies["openid"].Value;
        else
            if (Request["openid"] != null)
                openid = Request["openid"].ToString();

        JavaScriptSerializer json = new JavaScriptSerializer();
        if (openid != "")
        {
            string token = MyToken.ForceGetToken(Request["openid"].ToString());
            string getorderurl = Util.ApiDomainString + "api/order_get_list.aspx?token=" + token + "&paid=1&typeid=3,1000";
            string orderlist = HTTPHelper.Get_Http(getorderurl);
            Dictionary<string, object> dicBargain = (Dictionary<string, object>)json.DeserializeObject(orderlist);
            object[] orderArr = (object[])dicBargain["orders"];
            if (orderArr.Length > 0)
                repeatCustomer = "1";
        }
        
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

            try
            {
                Product product = new Product(int.Parse(Request["productid"].ToString()));
                if (product._fields != null)
                {
                    int discount = 0;
                    if (product._fields["discount_deadline"] != null && DateTime.Now <= Convert.ToDateTime(product._fields["discount_deadline"].ToString()))
                    {
                        discount += int.Parse(product._fields["discount_price"].ToString());
                    }
                    if (repeatCustomer.Equals("1"))
                    {
                        discount += int.Parse(product._fields["discount_oldcamp_price"].ToString());
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
            }
            catch { }
            

            if (Request["productid"].ToString().Equals("30"))
            {
                Response.Redirect("JoinSuccess.aspx");
                return;
            }
            
            this.Response.Redirect("payment.aspx?orderid=" + jsonorder.order_id);
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
    var repeat = '<%=repeatCustomer %>';
    var prodid = QueryString('productid');
    $(document).ready(function () {
        if (prodid == null) {
            alert('商品参数有误');
            return;
        }
        so_fillProd_xly();
        $("#bk_li").attr("class", "");
        $("#xly_li").attr("class", "current");
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
                    var price_1 = parseInt(obj.price);
                    var strprice = '';
                    if (repeat == '1') {
                        price_1 -= parseInt(obj.discount_oldcamp_price);
                    }
                    if (obj.discount_deadline != '' && ((Date.parse(new Date())) / 1000) <= ((Date.parse(new Date(obj.discount_deadline))) / 1000)) {
                        price_1 -= parseInt(obj.discount_price);
                    }
                    strprice = '<span class="">￥' + price_1 / 100 + '</span>';

                    var prodhtml = '<li class="sub-cart-prod"><a class="prod-img" href="Detail_xly.aspx?productid=' + obj.prodid + '"><img src="' + domain + obj.imgsrc + '" width="50px" height="50px" /></a><a class="prod-title" href="Detail_xly.aspx?productid=' + obj.prodid + '">' + obj.prodname + '</a><a class="prod-price">' + strprice + '</a><a class="prod-count">X 1</a></li>';
                    $("#total_amount span").eq(0).html('¥' + price_1 / 100);
                    var totalHtml = '<li class="sub-total" style="height:20px; text-align:right; padding:15px 0;"><a class="pd10">合计: <span class="red">¥' + price_1 / 100 + '</span></a></li>';

                    if (QueryString('followerAmount') != null && parseInt(QueryString('followerAmount')) > 0) {
                        var amount = (parseInt(obj.price) / 100) - parseInt(QueryString('followerAmount'));
                        amount = amount <= 0 ? 0 : amount;
                        $("#total_amount span").eq(0).html('¥' + amount);
                        totalHtml = '<li class="sub-total" style="height:20px; text-align:right; padding:15px 0;"><a>优惠：<span class="red">¥' + QueryString('followerAmount') + '</span></a><a class="pd10">合计: <span class="red">¥' + amount + '</span></a></li>';
                    }

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
</script>

</asp:Content>

