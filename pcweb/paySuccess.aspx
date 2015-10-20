<%@ Page Title="支付成功-卢勤问答平台官方商城" Language="C#" MasterPageFile="~/pcweb/Master.master" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" Runat="Server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" Runat="Server">
<div style="padding-bottom:50px; background:#fff; ">
    <div class="payresult">
        <i class="icon-success"></i><span>支付成功</span>
    </div>
    <div style="text-align:center; margin-top:20px;">
        <a href="Default_xly.aspx">返回夏令营首页</a>　　　<a href="Default_bk.aspx">返回书城首页</a>　　　<a href="ls_order.aspx">查看订单</a>
    </div>
</div>
<script runat="server">
    protected void Page_Load(object sender, EventArgs e)
    {
        if (Request["product_id"] != null && int.Parse(Request["product_id"]) > 0)
        {
            string paymethod = "";
            if (Request["paymethod"] != null && !Request["paymethod"].ToString().Equals(""))
            {
                paymethod = Request["paymethod"].ToString().Replace("'", "");
            }
            Order order = new Order();
            int result = order.updPayState(int.Parse(Request["product_id"]), paymethod);
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
        //setTimeout(function () { location.href = "ls_order.aspx"; }, 2000);
    });
</script>
</asp:Content>

