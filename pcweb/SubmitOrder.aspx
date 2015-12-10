<%@ Page Title="确认下单-卢勤问答平台官方书城" Language="C#" MasterPageFile="~/pcweb/Master.master" %>
<%@ Import Namespace="System.Web.Script.Serialization" %>
<script runat="server">

</script>

<asp:Content ID="Content1" ContentPlaceHolderID="head" Runat="Server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" Runat="Server">
    <div class="sc-address-block rel">
        <p style="line-height:20px; font-weight:bold; margin:0 0 10px 10px;">填写收货人地址</p>
        <p class="add_list_p rel list_pdl">
            <label>收货人</label>
            <input type="text" id="consignee" name="consignee" placeholder="请输入收货人姓名" />
        </p>
        <p class="add_list_p rel list_pdl">
            <label>手机号</label>
            <input type="text" id="mobile" name="mobile" placeholder="请输入手机号" />
        </p>
        <p class="add_list_p rel list_pdl">
            <label>所在地区</label>
            <select id="province" name="province"></select>
        </p>
        <p class="add_list_p rel list_pdl">
            <select id="city" name="city"></select>
        </p>
        <%--<p class="add_list_p rel">
            <select></select>
        </p>--%>
        <p class="add_list_p rel list_pdl">
            <label>详细地址</label>
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
            
        </ul>
    </div>
    <div style="background:#fff; margin:10px; padding:10px; height:100px; position:relative;">
        <div style="padding-right:10px; height:60px;" class="rel">   
            <textarea id="memo" name="memo" style="width:100%; padding:5px; height:40px; line-height:20px;" placeholder="（选填）留言：如果您需要卢勤老师亲笔签名，请留下需要被签名者姓名以及签名要求。"></textarea>
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
            </li>
        </ul>
        <div class="clear"></div>
    </div>


<div id="myModal" class="modal hide fade"  >
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
        string parms = "token=" + token + "&name=" + Request.Form["consignee"].ToString() + "&cell=" + Request.Form["mobile"].ToString()
                + "&province=" + Request.Form["myProvince"].ToString() + "&city=" + Request.Form["myCity"].ToString() + "&address=" + Request.Form["address"].ToString()
                + "&zip=&productid=" + Request.Form["prodids"].ToString() + "&count=" + Request.Form["counts"].ToString() + "&memo=" + Request.Form["memo"].ToString() 
                + "&wechatid=" + Request.Form["wechatid"].ToString();

        
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
    var str_productids = "";
    var str_counts = "";
    var pcount = 0;
    var t_prod_price = 0;
    $(document).ready(function () {
        so_fillProd();
        $("#bk_li").attr("class", "current");
        $("#xly_li").attr("class", "");
        $("#province").change(function () {
            totalFeight($("#province option:selected").text(), pcount);
            so_fillCity($(this).val());
        });

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

        GetOpenidToken();
        $("#myToken").val(token);
        $("#myOpenid").val(openid);
        $("#myFrom").val(from);
        $("#prodids").val(str_productids);
        $("#counts").val(str_counts);
        $("#myProvince").val($("#province option:selected").text());
        $("#myCity").val($("#city option:selected").text());
        delCookie("followerAmount");
        document.forms[0].submit();
    }
</script>

</asp:Content>

