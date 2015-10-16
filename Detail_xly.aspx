<%@ Page Title="" Language="C#" MasterPageFile="~/Master.master"  %>

<asp:Content ID="Content1" ContentPlaceHolderID="MasterHead" Runat="Server">
    <%--<link href="style/proddetail.css" rel="stylesheet" type="text/css" />
    <script src="script/touchslider.js" type="text/javascript"></script>
    <script src="script/zepto_min.js" type="text/javascript"></script>--%>
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="MasterContent" Runat="Server">
<script runat="server">
    public string repeatCustomer = "0";
    protected void Page_Load(object sender, EventArgs e)
    {
        if (this.Session["RepeatCustomer"] != null)
            repeatCustomer = this.Session["RepeatCustomer"].ToString();
    }
</script>
<div class="mainpage">
    <div class="titleNav">
        <a onclick="location.href = 'Default_xly.aspx';" class="returnA"> </a>
        <span class="titleSpan">夏令营详情</span>
    </div>
    <div class="m-dcontent" style="margin-top:10px;">
        <div id="prodimg" style="border:1px solid #ccc;">
            
        </div>
        <div id="prodtitle" style="line-height:22px; font-size:16px; padding:10px 0;">
        </div>
        <div class="m-dprice rel">
            <s class="gray" id="originalprice" style="margin-right:10px;"></s><span class="red" id="prodprice"></span>
            <a onclick="javascript:joinxly();" class="btn btn-danger" style="width:20%; position:absolute; right:0px; bottom:0px;">我要报名</a>
        </div>
    </div>
    <div id="proddescription" class="m-ddescription">
    </div>
    <div style="background:#fff; padding:10px; text-align:center;">
        <a onclick="javascript:joinxly();" class="btn btn-danger" style="width:25%;" >我要报名</a>
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
    });

    function joinxly() {
        location.href = 'Join_xly.aspx?productid=' + prodid;
    }
</script>
</asp:Content>

