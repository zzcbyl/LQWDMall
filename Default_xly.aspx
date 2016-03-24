<%@ Page Title="卢勤问答平台夏令营" Language="C#" MasterPageFile="~/Master.master" %>

<asp:Content ID="Content1" ContentPlaceHolderID="MasterHead" Runat="Server">
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
<div style="width:100%;">
    <img src="images/xly-banner.jpg" width="100%" />
</div>
<div style="background:#fff; padding:10px;">
    如果您在参营方面有疑问，可以拨打官方咨询电话18601016361,也可以咨询在线客服。
</div>
<div class="m-wrap">
    <ul id="prodlistul" class="m-ul rel">
    </ul>
    <div class="clear" style="height:20px;"></div>
</div>
<script type="text/javascript">
    var repeat = <%=repeatCustomer %>;
    $(document).ready(function () {
        filllist(3);
        setCookie('source', 3);
    });
    function filllist(typeid) {
        $('#prodlistul').html('<li><div class="loading"><img src="images/loading.gif" /><br />加载中...</div></li>');

        $.ajax({
            type: "post",
            async: false,
            url: domain + 'api/product_get_all.aspx',
            data: { random: Math.random() },
            success: function (data, textStatus) {
                var obj = eval('(' + data + ')');
                if (obj != null) {
                    var prodlist = obj.data;
                    var html = "";
                    for (var i = 0; i < prodlist.length; i++) {
                        if (typeid != 0 && prodlist[i].prodtypeid != typeid)
                            continue;
                        var strprice = '';
                        var price = parseInt(prodlist[i].price);
                        if (prodlist[i].prodid == 28) {
                            if (repeat == 1) {
                                price -= 30000;
                            }
                            if (currentDT <= deadline_28) {
                                price -= 30000;
                            }
                            if(parseInt(prodlist[i].originalprice)!=price)
                                strprice = '<s class="gray">¥' + parseInt(prodlist[i].originalprice) / 100 + '</s><span class="red mgleft">¥' + price / 100 + '</span>';
                            else
                                strprice = '<span class="red mgleft">¥' + price / 100 + '</span>';
                        }
                        else if (prodlist[i].prodid == 30) {
                            strprice = '<span class="red mgleft"></span>';
                        }
                        else {
                            if (prodlist[i].originalprice != null && prodlist[i].originalprice != '') {
                                strprice = '<s class="gray">¥' + parseInt(prodlist[i].originalprice) / 100 + '</s><span class="red mgleft">¥' + price / 100 + '</span>';
                            }
                            else {
                                strprice = '<span class="red">¥' + price / 100 + '</span>';
                            }
                        }

                        
                        var sDt =new Date(Date.parse(prodlist[i].startTime.replace(/-/g, "/")));
                        var eDt =new Date(Date.parse(prodlist[i].endTime.replace(/-/g, "/")));
                        var dtTitle =(sDt.getFullYear()).toString()+'年'+(sDt.getMonth()+1).toString()+'月'+(sDt.getDate()).toString()+'日'+
                            '－'+(eDt.getMonth()+1).toString()+'月'+(eDt.getDate()).toString()+'日';
                        
                        var buybtn = '<a id="buyProd_xly" onclick="location.href=\'Join_xly.aspx?productid=' + prodlist[i].prodid + '&#ATable\';" class="btn btn-danger">我要报名</a>';
                        html += '<li class="m-li left rel" style="width:100%"><a href="Detail_xly.aspx?productid=' + prodlist[i].prodid + '"><div class="pd5"><img src="' + domain + prodlist[i].imgsrc + '" /></div><div class="m-txt" style="line-height:20px; height:auto;">' + prodlist[i].prodname + '<br />' + dtTitle + '</div><div class="m-price" style="font-size:14px;">' + strprice + '</div></a><div class="prod-list-btn"><!--<a id="addShopCart" onclick="detailAddCart(' + prodlist[i].prodid + ', 1);" class="btn btn-default">加入购物车</a>-->' + buybtn + '</div></li>';
                    }
                    $('#prodlistul').html(html);
                }
            }
        });
    }
</script>
</asp:Content>

