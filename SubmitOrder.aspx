﻿<%@ Page Title="" Language="C#" MasterPageFile="~/Master.master" %>
<%@ Import Namespace="System.Web.Script.Serialization" %>
<asp:Content ID="Content1" ContentPlaceHolderID="MasterHead" Runat="Server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="MasterContent" Runat="Server">
<div class="mainpage">
    <div style="height:40px; line-height:40px; padding:0 10px; background:#fff;position:relative;">
        <a href="javascript:history.go(-1);" class="returnA"> </a>
        <span class="titleSpan">确认下单</span>
    </div>
    <div class="sc-address-block rel">
        <p class="add_list_p rel">
            <label>收货人</label>
            <input type="text" id="consignee" name="consignee" placeholder="请输入收货人姓名" />
        </p>
        <p class="add_list_p rel">
            <label>手机号码</label>
            <input type="text" id="mobile" name="mobile" placeholder="请输入手机号" />
        </p>
        <p class="add_list_p rel">
            <label>所在地区</label>
            <select id="province" name="province"></select>
        </p>
        <p class="add_list_p rel">
            <select id="city" name="city"></select>
        </p>
        <%--<p class="add_list_p rel">
            <select></select>
        </p>--%>
        <p class="add_list_p rel">
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
            <textarea style="width:100%; padding:5px; height:40px; line-height:20px;" placeholder="（选填）给我们留言"></textarea></div>
        <div style="padding-right:10px;" class="rel">
            <input type="text" style="width:50%; padding:5px; line-height:20px;"  placeholder="（选填）微信号" />
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
            submitOrder();
        }
    }
    private void submitOrder()
    {
        string parms = "token=" + Request.Form["myToken"].ToString() + "&name=" + Request.Form["consignee"].ToString() + "&cell=" + Request.Form["mobile"].ToString()
                + "&province=" + Request.Form["myProvince"].ToString() + "&city=" + Request.Form["myCity"].ToString() + "&address=" + Request.Form["address"].ToString()
                + "&zip=&productid=" + Request.Form["prodids"].ToString() + "&count=" + Request.Form["counts"].ToString();

        string getUrl = Util.ApiDomainString + "api/order_place.aspx?" + parms;
        string result = HTTPHelper.Get_Http(getUrl);
        JavaScriptSerializer json = new JavaScriptSerializer();
        ReturnOrder order = json.Deserialize<ReturnOrder>(result);
        if (order.status == -1)
        {
            submitOrder();
        }        
    }

    public class ReturnOrder
    {
        public int status { get; set; }
        public string order_id { get; set; }
    }
</script>

<script type="text/javascript">
    var str_productids = "";
    var str_counts = "";
    var pcount = 0;
    var t_prod_price = 0;
    $(document).ready(function () {
        so_fillProd();
        
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

        GetOpenidToken();
        $("#myToken").val(token);
        $("#myOpenid").val(openid);
        $("#myFrom").val(from);
        $("#prodids").val(str_productids);
        $("#counts").val(str_counts);
        $("#myProvince").val($("#province option:selected").text());
        $("#myCity").val($("#city option:selected").text());

        document.forms[0].submit();
    }
</script>

</asp:Content>

