<%@ Page Title="" Language="C#" MasterPageFile="~/Master.master" %>

<asp:Content ID="Content1" ContentPlaceHolderID="MasterHead" Runat="Server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="MasterContent" Runat="Server">
<div class="mainpage">
    <div class="titleNav">
        <a href="Default.aspx" class="returnA"> </a>
        <span class="titleSpan">支付成功</span>
    </div>
    <div class="m-dcontent" style="margin-top:10px; padding-bottom:50px;">
        <div class="payresult">
            <i class="icon-success"></i><span>支付成功</span>
        </div>
        <div style="text-align:center; margin-top:20px;">
            首页　　　查看订单
        </div>
    </div>
</div>
<script runat="server">
    protected void Page_Load(object sender, EventArgs e)
    {
        if (Request["product_id"] != null && int.Parse(Request["product_id"]) > 0)
        {
            Order order = new Order();
            int result = order.updPayState(int.Parse(Request["product_id"]));
            if (result > 0)
            {
                
            }    
        }
        else
        {
            Response.Write("参数错误");
            Response.End();
        }
    }
</script>
<script type="text/javascript">
    $(document).ready(function () {
        setTimeout(function () {
            location.href = "ls_order.aspx";
        }, 1000);
    });
</script>
</asp:Content>

