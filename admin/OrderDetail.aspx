<%@ Page Title="" Language="C#" MasterPageFile="~/admin/AdminMaster.master" %>
<%@ Import Namespace="System.Data" %>
<script runat="server">
    public Order order = new Order();
    public DataTable detailDT = new DataTable();
    protected void Page_Load(object sender, EventArgs e)
    {
        if (Request["oid"] == null || Request["oid"] == string.Empty)
        {
            Response.Write("参数错误");
            Response.End();
            return;
        }

        order = new Order(int.Parse(Request["oid"]));
        detailDT = order.GetOrderDetails();

        if (order._fields["paystate"].ToString() == "1" && Request.Form["shipNum"] != null && Request.Form["shipNum"].Trim() != string.Empty)
        {
            order.updPayState(int.Parse(Request["oid"].Trim()), 2, Request.Form["shipNum"].Trim());
        }
    }
</script>

<asp:Content ID="Content1" ContentPlaceHolderID="head" Runat="Server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" Runat="Server">
    <div class="orderdetail_state">
        订单状态：<%=order._fields["paystate"].ToString() == "0" ? "未付款" : order._fields["paystate"].ToString() == "1" ? "已付款　" + Convert.ToDateTime(order._fields["paysuccesstime"]).ToString("yyyy-MM-dd HH:mm") + "　　快递：<input type=\"text\" name=\"shipNum\" style=\"width:200px;\" /> <input type=\"button\" value=\"发货\" style=\"padding:0px 10px;\" onclick=\"document.forms[0].submit();\" />" : order._fields["paystate"].ToString() == "2" ? "已发货　" + order._fields["shipNumber"].ToString() : "已收货" %>
    </div>

    <div class="orderdetail_info">
        <div class="od_info_title">订单信息   </div>
        <div class="od_info_consignee">
            <p>收货人信息：<%=order._fields["name"].ToString()%>　　<%=order._fields["cell"].ToString()%></p>
            <p>　　　　　　<%=order._fields["province"].ToString()%> <%=order._fields["city"].ToString()%> <%=order._fields["address"].ToString()%></p>
        </div>
        <div class="od_info_buyer">　买家留言：<%=order._fields["memo"].ToString().Trim() == string.Empty ? "无" : order._fields["memo"].ToString().Trim()%></div>
        <div class="od_info_timer">订单编号：<%=order._fields["oid"].ToString() %>　　下单时间：<%=Convert.ToDateTime(order._fields["ctime"]).ToString("yyyy-MM-dd HH:mm")%></div>
    </div>

    <ul class="prod_item">
        <li class="list_hd">
            <div id="prod_item_a">商品名称</div>
            <div id="prod_item_b">型号</div>
            <div id="prod_item_c">价格</div>
            <div id="prod_item_d">数量</div>
        </li>
        <% if (detailDT.Rows.Count > 0)
           {
               for (int i = 0; i < detailDT.Rows.Count; i++)
               { %>
        <li class="list_prod" >
            <div class="dashline" id="prod_item_a">
                <a id="prodimg"><img src='<%=Util.ApiDomainString + detailDT.Rows[i]["imgsrc"].ToString()%>' /></a>
                <a id="prodtitle"><%=detailDT.Rows[i]["product_name"].ToString()%></a>
            </div>
            <div class="dashline" id="prod_item_b">无型号</div>
            <div class="dashline" id="prod_item_c"><%=Math.Round(decimal.Parse(detailDT.Rows[i]["price"].ToString()) / 100, 2) %></div>
            <div class="dashline" id="prod_item_d"><%=detailDT.Rows[i]["product_count"].ToString()%></div>
        </li>
        <%}
           } %>
    </ul>
    <div class="clear"></div>
</asp:Content>
