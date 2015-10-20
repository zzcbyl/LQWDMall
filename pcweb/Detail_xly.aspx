<%@ Page Title="卢勤问答平台冬令营" Language="C#" MasterPageFile="~/pcweb/Master.master" %>

<script runat="server">
    public string repeatCustomer = "0";
    protected void Page_Load(object sender, EventArgs e)
    {
        if (this.Session["RepeatCustomer"] != null)
            repeatCustomer = this.Session["RepeatCustomer"].ToString();
    }
</script>

<asp:Content ID="Content1" ContentPlaceHolderID="head" Runat="Server">
<style type="text/css">
    .btn-danger{ width:200px; font-size: 16px; padding: 10px 0; }
</style>
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" Runat="Server">
<div style="background:#fff; padding:10px;">
    <div class="m-dcontent" style="margin-top:10px;">
        <div id="prodimg" style="border:1px solid #ccc; width:600px; margin:0 auto;">
            
        </div>
        <div id="prodtitle" style="line-height:22px; font-size:16px; padding:10px 0 10px 180px;">
        </div>
        <div class="m-dprice rel" style="padding:0 0 0 180px;">
            <s class="gray" id="originalprice" style="margin-right:10px;"></s><span class="red" id="prodprice"></span>
            <a onclick="joinxly();" class="btn btn-danger" style="position:absolute; left:400px; top:30px; ">我要报名</a>
        </div>
    </div>
    <div id="proddescription" class="m-ddescription" style="border-top:1px solid #ccc; min-height:300px; padding:15px; margin-top:65px;">
    </div>
    <div style="background:#fff; padding:10px; text-align:center;">
        <a onclick="javascript:joinxly();" class="btn btn-danger" >我要报名</a>
    </div>
    <div class="clear" style="height:20px;"></div>
</div>
<script type="text/javascript">
    var repeat = <%=repeatCustomer %>;
    var prodid = QueryString('productid');
    $(document).ready(function () {
        if (prodid == null) {
            alert('商品参数有误');
            return;
        }
        filldetail(prodid);
        $("#bk_li").attr("class", "");
        $("#xly_li").attr("class", "current");
    });

    function joinxly() {
        if (openid == null || openid == '') {
            jumpLogin();
            return;
        }
        location.href = 'Join_xly.aspx?productid=' + prodid;
    }
</script>
</asp:Content>

