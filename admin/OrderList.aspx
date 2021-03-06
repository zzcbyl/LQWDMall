﻿<%@ Page Title="" Language="C#" MasterPageFile="~/admin/AdminMaster.master" %>
<%@ Register Assembly="AspNetPager" Namespace="Wuqi.Webdiyer" TagPrefix="webdiyer" %>
<%@ Import Namespace="System.Data" %>

<script runat="server">
    public Order[] orderArray = null;
    public Order order = new Order();
    public int PageSize = 30;
    protected void Page_Load(object sender, EventArgs e)
    {
        BindOrderList(1);
        this.AspNetPager1.PageSize = PageSize;
    }

    private void BindOrderList(int currentPage)
    {
        DateTime startDate = (Request["startdate"] == null) ? DateTime.Parse("2015-10-1") : DateTime.Parse(Request["startdate"].Trim());
        DateTime endDate = (Request["enddate"] == null) ? DateTime.Parse("2999-1-1") : DateTime.Parse(Request["enddate"].Trim());
        string where = string.Empty;
        string orderby = "oid desc";
        if (Request["state"] != null && Request["state"] == "1")
        {
            where = " and paystate in (1,2) ";
            orderby = "paysuccesstime desc, oid desc";
        }
        else if (Request["state"] != null && Request["state"] == "2")
        {
            where = " and paystate in (1) and name <> '' ";
            orderby = "paysuccesstime desc, oid desc";
        }
        orderArray = Order.GetOrdersByPages(0, startDate, endDate, currentPage, PageSize, where, orderby);
        this.AspNetPager1.RecordCount = Order.GetOrdersCount(0, startDate, endDate, where);
        this.lbl_count.Text = this.AspNetPager1.RecordCount.ToString();
    }
    protected void AspNetPager1_PageChanged(object src, EventArgs e)
    {
        BindOrderList(this.AspNetPager1.CurrentPageIndex);
    }
</script>
<asp:Content ID="Content1" ContentPlaceHolderID="head" Runat="Server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" Runat="Server">
    <div style=" position:absolute; right:50px; top:70px;">
        <a style='padding:3px 10px; margin-right:10px; <%= (Request["state"] == null || Request["state"].Equals("")) ? "background:#55798C; color:#fff;" : "background:#ccc; color:#666;"%>' href="OrderList.aspx">全部</a>
        <a style='padding:3px 10px; <%= (Request["state"] != null && Request["state"].Equals("1")) ? "background:#55798C; color:#fff;" : "background:#ccc; color:#666;" %>' href="OrderList.aspx?state=1">已付款</a>　
        <a style='padding:3px 10px; <%= (Request["state"] != null && Request["state"].Equals("2")) ? "background:#55798C; color:#fff;" : "background:#ccc; color:#666;" %>' href="OrderList.aspx?state=2">未发货</a>
        <a style='padding:3px 10px;'>总计：<asp:Label ID="lbl_count" runat="server" Text=""></asp:Label></a>
    </div>
    <ul class="tabletitle">
        <li id="product_li">商品</li>
        <li id="consignee_li">收货人信息</li>
        <li id="remark_li">留言</li>
        <li id="totals_li">金额</li>
        <li id="paystate_li">状态</li>
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
                <span style="margin-left:50px;">下单时间：<%=Convert.ToDateTime(order._fields["ctime"]).ToString("yyyy-MM-dd HH:mm") %></span></div>
            <div class="orderproduct">
                <div id="prodimg">
                    <%if (detailDT.Rows.Count > 0)
                        { %>
                        <a><img src='<%=Util.ApiDomainString + detailDT.Rows[0]["imgsrc"].ToString() %>' /></a>
                    <%} %>
                </div>
                <div id="address">
                    <p><%=order._fields["name"].ToString()%>    <%=order._fields["cell"].ToString()%></p>
                    <p><%=order._fields["province"].ToString()%> <%=order._fields["city"].ToString()%> <%=order._fields["address"].ToString()%></p>
                </div>
                <div id="remarks"><%=order._fields["memo"].ToString().Trim() == string.Empty ? "无" : order._fields["memo"].ToString().Trim()%></div>
                <div id="totals">
                    <% if (detailDT.Rows[0]["product_id"].ToString() == "75")
                       { %>
                        <%= (int.Parse(order._fields["orderprice"].ToString()) / 100) == 13000 ? 12500 : (int.Parse(order._fields["orderprice"].ToString()) / 100) == 19500 ? 18000 : (int.Parse(order._fields["orderprice"].ToString()) / 100) == 26000 ? 24000 : 6500 %>
                    <%} else { %>
                        <%=float.Parse(order._fields["orderprice"].ToString()) / 100 %><%=int.Parse(order._fields["shipfee"].ToString()) > 0 ? "<br />(快递费:" + int.Parse(order._fields["shipfee"].ToString()) / 100 + ")" : int.Parse(order._fields["shipfee"].ToString()) < 0 ? "<br />(优惠:" + (1 - int.Parse(order._fields["shipfee"].ToString())) / 100 + ")" : ""%>
                        <%=int.Parse(order._fields["ajustfee"].ToString()) < 0 ? "<br />(优惠:" + (1 - int.Parse(order._fields["ajustfee"].ToString())) / 100 + ")" : "" %>
                    <%} %>
                </div>
                <div id="paystate"><%=order._fields["paystate"].ToString() == "0" ? "未付款" : order._fields["paystate"].ToString() == "2" ? "已发货<br />" + order._fields["shipNumber"].ToString() : order._fields["paystate"].ToString() == "3" ? "已退款" : "已付款(" + order._fields["paymethod"].ToString() + ")<br/>" + (order._fields["paysuccesstime"] != DBNull.Value ? Convert.ToDateTime(order._fields["paysuccesstime"]).ToString("yyyy-MM-dd HH:mm") : "")%></div>
                <div class="operation">
                    <p><a href='OrderDetail.aspx?oid=<%=order._fields["oid"].ToString() %>'>订单详情</a></p>
                </div>
            </div>

            <div class="clear"></div>
        </div>
        <%}
            } %>
    </div>
    <div style="padding:10px 0; margin-top:10px; background:#fff;">
        <webdiyer:aspnetpager id="AspNetPager1" runat="server" horizontalalign="Center" onpagechanged="AspNetPager1_PageChanged"
            width="100%" ShowFirstLast="false" PagingButtonsStyle="margin:0 5px;" CurrentPageButtonStyle="color:#666; font-weight:bold; font-size:16px; margin:0 5px;"  FirstPageText="首页" LastPageText="末页" NextPageText="下一页" PrevPageText="上一页" ></webdiyer:aspnetpager>
    </div>
</asp:Content>
