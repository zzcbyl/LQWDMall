<%@ Page Title="" Language="C#" MasterPageFile="~/Master.master" %>
<%@ Import Namespace="System.Web.Script.Serialization" %>
<%@ Import Namespace="System.Threading" %>

<asp:Content ID="Content1" ContentPlaceHolderID="MasterHead" Runat="Server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="MasterContent" Runat="Server">
<div class="mainpage">
    <div class="titleNav">
        <a onclick="returnxly();" class="returnA"> </a>
        <span class="titleSpan">报名表</span>
    </div>
    <div class="sc-address-block rel" style="margin-bottom:0; padding-bottom:10px;">
        <img src="<%=HeadImg %>" width="100%" />
        <div style="line-height:32px; margin-top:10px; font-weight:bold;">
            <h4><%=Title %></h4>
            <div><%=showDate %>　<%=Location %></div></div>
    </div>
    <div class="sc-address-block rel" style="margin-top:10px; padding-top:10px;">
        <%--<a name="ATable"></a>--%>
        <p class="add_list_p rel">
            <input type="text" id="childName" maxlength="50" name="childName" placeholder="请输入孩子姓名" onblur="checkoldcamp();" />
        </p>
        <p class="add_list_p rel">
            <select id="childSex" name="childSex">
                <option value="">请选择孩子性别</option>
                <option value="男">男</option>
                <option value="女">女</option>
            </select>
        </p>
        <p class="add_list_p rel">
            <select id="childAge" name="childAge">
                <option value="">请选择孩子年龄</option>
                <option value="8">8</option>
                <option value="9">9</option>
                <option value="10">10</option>
                <option value="11">11</option>
                <option value="12">12</option>
                <option value="13">13</option>
                <option value="14">14</option>
                <option value="15">15</option>
                <option value="16">16</option>
                <option value="17">17</option>
                <option value="18">18</option>
            </select>
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
                <input type="hidden" name="yingDate" id="yingDate" value="<%=showDate %>" />
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
    public string EndDate = "";
    public string showDate = "";
    public string Yprice = "";
    public string HeadImg = "";
    public string Title = "";
    public string Location = "";
    public string openid = "";
    protected void Page_Load(object sender, EventArgs e)
    {
        if (Request.Cookies["openid"] != null)
            openid = Request.Cookies["openid"].Value;
        else
            if (Request["openid"] != null)
                openid = Request["openid"].ToString();
        
        JavaScriptSerializer json = new JavaScriptSerializer();
        
        
        if (Request.Form["hidIndex"] != null && Request.Form["hidIndex"].ToString() == "1")
        {
            submitOrder(Request.Form["myToken"].ToString());
        }

        string result = HTTPHelper.Get_Http(System.Configuration.ConfigurationManager.AppSettings["apiDomain"].ToString() + "api/product_get_detail.aspx?productid=" + Request["productid"]);
        Dictionary<string, object> dic = json.Deserialize<Dictionary<string, object>>(result);
        if (dic.Keys.Contains("startTime"))
        {
            //StartDate = dic["startTime"].ToString().Replace("/", "-").Split(' ')[0];
            //Yprice = (Convert.ToInt64(dic["price"].ToString()) / 100).ToString();
            StartDate = dic["startTime"].ToString(); //dic["startTime"].ToString().Replace("/", "-").Split(' ')[0];
            showDate = Convert.ToDateTime(StartDate).Year.ToString() + "年" + Convert.ToDateTime(StartDate).Month.ToString() + "月" + Convert.ToDateTime(StartDate).Day.ToString() + "日";
            EndDate = dic["endTime"].ToString();
            if (!EndDate.Equals(""))
                showDate += "－" + Convert.ToDateTime(EndDate).Month.ToString() + "月" + Convert.ToDateTime(EndDate).Day.ToString() + "日";
        }
        if (dic.Keys.Contains("imgsrc"))
        {
            HeadImg = dic["imgsrc"].ToString(); 
        }
        if (dic.Keys.Contains("prodname"))
        {
            Title = dic["prodname"].ToString();
        }
        if (dic.Keys.Contains("yingplace"))
        {
            Location = dic["yingplace"].ToString();
        }
        
    }
    private void submitOrder(string token)
    {
        string memo = "孩子姓名：" + Request.Form["childName"].ToString() + "，孩子性别：" + Request.Form["childSex"].ToString() + "，孩子年龄：" + Request.Form["childAge"].ToString() + "岁，孩子身份证：" + Request.Form["childIDcard"].ToString()
                    + "，家长姓名：" + Request.Form["parentName"].ToString() + "，手机号码：" + Request.Form["parentMobile"].ToString()
                    + "，电子邮箱：" + Request.Form["parentEmail"].ToString() + "，参营日期：" + Request.Form["yingDate"].ToString();
        string parms = "token=" + token + "&name=&cell=&province=&city=&address=&zip=&productid=" + Request["productid"].ToString() + "&count=1|1&memo=" + memo + "&wechatid=";

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
                            "<div>您好，欢迎您参加2016年假日营！</div>" +
                            "<div style=\"margin-top:10px;\">有任何关于假日营的问题，请联系：18601016361 新老师</div>" +
                            "<div style=\"margin-top:10px;\">请按如下要求认真填写报名表：</div>" +
                            "<div style=\"margin-left:20px; color:Red;\">" +
                            "<div>1. 请家长朋友尽可能详尽地填写报名表，这张表是老师们了解孩子的一个重要窗口；</div>" +
                            "<div>2. 填写好请以孩子姓名命名，并报名表请发送到xly@luqinwenda.com；</div>" +
                            "<div>3. 请家长把孩子的身份证或户口本页拍一张照片附在报名表里，便于后勤老师为孩子购买有效保险；</div>" +
                            "</div></div>";
                string subject = "2016年假日营报名表";
                string attach = Server.MapPath(@"/upload/file/假日营报名表2016.docx");

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
                    
                    string getorderurl = Util.ApiDomainString + "api/order_get_list.aspx?token=" + token + "&paid=1&typeid=3,1000";
                    string orderlist = HTTPHelper.Get_Http(getorderurl);
                    Dictionary<string, object> dicBargain = (Dictionary<string, object>)json.DeserializeObject(orderlist);
                    object[] orderArr = (object[])dicBargain["orders"];
                    if (orderArr.Length > 0)
                    {
                        for (int i = 0; i < orderArr.Length; i++)
                        {
                            Dictionary<string, object> dicOrder = (Dictionary<string, object>)orderArr[i];
                            if (dicOrder["memo"].ToString().IndexOf(Request.Form["childName"].ToString()) > -1)
                            {
                                discount += int.Parse(product._fields["discount_oldcamp_price"].ToString());
                                break;
                            }
                        }
                        
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
            
            //Response.Redirect("JoinSuccess.aspx");
            //return;

            int userid = Users.CheckToken(token);
            Order order = new Order(int.Parse(jsonorder.order_id));
            int total = int.Parse(order._fields["orderprice"].ToString()) + int.Parse(order._fields["shipfee"].ToString()) + int.Parse(order._fields["ajustfee"].ToString());
            total = total <= 0 ? 0 : total;
            string param = "?body=卢勤问答平台官方夏令营&detail=卢勤问答平台官方夏令营&userid=" + userid + "&product_id=" + order._fields["oid"] + "&total_fee=" + total.ToString();
            string payurl = "http://weixin.luqinwenda.com/payment/payment.aspx";
            
            //if (Request.Form["myFrom"] != null && Request.Form["myFrom"].ToString() != "")
            //{
            //    //微信支付
            //    payurl = "http://weixin.luqinwenda.com/payment/payment.aspx";
            //}
            //else
            //{
            //    //易宝支付
            //    payurl = "http://yeepay.luqinwenda.com/weixin_payment.aspx";
            //}
            
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
    var repeat = '0';
    var prodid = QueryString('productid');
    $(document).ready(function () {
        if (prodid == null) {
            alert('商品参数有误');
            return;
        }
        so_fillProd_xly();

    });

    function checkoldcamp()
    {
        repeat = '0';
        so_fillProd_xly();
        $.ajax({
            type: "get",
            async: false,
            url: domain + 'api/order_get_list.aspx',
            data: { token: token, paid: 1, typeid: '3,1000', random: Math.random() },
            success: function (data, textStatus) {
                var obj = eval('(' + data + ')');
                if (obj != null) {
                    if (obj.orders.length > 0) {
                        for (var i = 0; i < obj.orders.length; i++) {
                            if ($('#childName').val().Trim() != "" && obj.orders[i].memo.indexOf($('#childName').val()) > -1) {
                                repeat = '1';
                                so_fillProd_xly();
                                break;
                            }
                        }
                    }
                }
            }
        });
    }

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
                    var totalHtml = '<li class="sub-total" style="height:20px; text-align:center; font-weight:bold; padding:15px 0;"><a class="pd10"><span class="red">需支付：￥' + price_1 / 100 + '</span></a></li>';

                    if (QueryString('followerAmount') != null && parseInt(QueryString('followerAmount')) > 0) {
                        var amount = (parseInt(obj.price) / 100) - parseInt(QueryString('followerAmount'));
                        amount = amount <= 0 ? 0 : amount;
                        $("#total_amount span").eq(0).html('¥' + amount);
                        totalHtml = '<li class="sub-total" style="height:20px; text-align:center; font-weight:bold; padding:15px 0;"><a>优惠：<span class="red">￥' + QueryString('followerAmount') + '</span></a><a class="pd10"><span class="red">需支付：¥' + amount + '</span></a></li>';
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
        if ($("#childSex").val().Trim() == "") {
            $("#ModalContent").html("请选择孩子性别");
            $('#myModal').modal('show');
            return;
        }
        if ($("#childIDcard").val().Trim() == "") {
            $("#ModalContent").html("请输入孩子身份证");
            $('#myModal').modal('show');
            return;
        }
        if ($("#childAge").val().Trim() == "") {
            $("#ModalContent").html("请选择孩子年龄");
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
</script>

</asp:Content>


