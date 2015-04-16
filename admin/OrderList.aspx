<%@ Page Title="" Language="C#" MasterPageFile="~/admin/AdminMaster.master" %>
<%@ Import Namespace="System.Data" %>

<script runat="server">
    public Order[] orderArray = null;
    public Order order = new Order();
    protected void Page_Load(object sender, EventArgs e)
    {
        DateTime startDate = (Request["startdate"] == null) ? DateTime.Parse("2001-1-1") : DateTime.Parse(Request["startdate"].Trim());
        DateTime endDate = (Request["enddate"] == null) ? DateTime.Parse("2999-1-1") : DateTime.Parse(Request["enddate"].Trim());
        orderArray = Order.GetOrders(0, startDate, endDate);
    }
</script>
<asp:Content ID="Content1" ContentPlaceHolderID="head" Runat="Server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" Runat="Server">
    <ul class="tabletitle">
        <li id="product_li">商品</li>
        <li id="consignee_li">收货人信息</li>
        <li id="remark_li">留言</li>
        <li id="paystate_li">是否付款</li>
        <li id="operation_id">操作</li>
    </ul>
    <div id="orderContent">
        <% if (orderArray != null && orderArray.Length > 0)
            {
                for (int i = 0; i < orderArray.Length; i++)
                {
                    order = orderArray[i];
                    DataTable detailDT = order.GetOrderDetails();
                       
                %>
        <div class="orderlist">
            <div class="ordertitle"><span>订单编号：<%=order._fields["oid"].ToString() %></span>
                <span style="margin-left:50px;">下单时间：<%=order._fields["ctime"].ToString() %></span></div>
            <div class="orderproduct">
                <div id="prodimg">
                    <%if (detailDT.Rows.Count > 0)
                        { %>
                        <a><img src='<%=Util.ApiDomainString + detailDT.Rows[0]["imgsrc"].ToString() %>' /></a></div>
                    <%} %>
                <div id="address">
                    <p><%=order._fields["name"].ToString()%>    <%=order._fields["cell"].ToString()%></p>
                    <p><%=order._fields["province"].ToString()%> <%=order._fields["city"].ToString()%> <%=order._fields["address"].ToString()%></p>
                </div>
                <div id="remarks"><%=order._fields["memo"].ToString().Trim() == string.Empty ? "无" : order._fields["memo"].ToString().Trim()%></div>
                <div id="paystate"><%=order._fields["paystate"].ToString() == "0" ? "未付款" : "已付款<br/>" + order._fields["paysuccesstime"].ToString() %></div>
                <div class="operation">
                    <p><a href='OrderDetail.aspx?oid=<%=order._fields["oid"].ToString() %>'>订单详情</a></p>
                </div>
            </div>

            <div class="clear"></div>
        </div>
        <%}
            } %>
    </div>
</asp:Content>
