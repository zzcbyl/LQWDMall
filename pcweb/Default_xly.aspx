﻿<%@ Page Title="悦长大平台冬令营" Language="C#" MasterPageFile="~/pcweb/Master.master" %>

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
    .m-li img { height:300px;}
</style>
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" Runat="Server">
<div style="background:#fff; padding:10px; line-height:22px;">
    如果您在参营方面有疑问，可以拨打官方咨询电话18601016361，也可以咨询在线客服。
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
        $("#bk_li").attr("class", "");
        $("#xly_li").attr("class", "current");
    });
    function filllist(typeid) {
        $('#prodlistul').html('<li><div class="loading"><img src="http://mall.luqinwenda.com/images/loading.gif" /><br />加载中...</div></li>');

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
                            if (parseInt(prodlist[i].originalprice) != price)
                                strprice = '<s class="gray">¥' + parseInt(prodlist[i].originalprice) / 100 + '</s><span class="red mgleft">¥' + price / 100 + '</span>';
                            else
                                strprice = '<span class="red mgleft">¥' + price / 100 + '</span>';
                        }
                        else if (prodlist[i].prodid == 30) {
                             strprice = '<span class="red mgleft"></span>';
                        }
                        else {
                            if (prodlist[i].originalprice != null && prodlist[i].originalprice != '') {
                                strprice = '<s class="gray">¥' + parseInt(prodlist[i].originalprice) / 100 + '</s><span class="red mgleft">¥' + parseInt(prodlist[i].price) / 100 + '</span>';
                            }
                            else if (prodlist[i].prodid == 24) {
                                strprice = '';
                            }
                            else {
                                strprice = '<span class="red">¥' + parseInt(prodlist[i].price) / 100 + '</span>';
                            }
                        }
                        var buybtn = '<a id="buyProd_xly" onclick="JoinXLY(' + prodlist[i].prodid + ')" class="btn btn-danger">我要报名</a>';
                        html += '<li class="m-li left rel" style="width:50%"><a href="Detail_xly.aspx?productid=' + prodlist[i].prodid + '"><div class="pd5"><img src="' + domain + prodlist[i].imgsrc + '" /></div><div class="m-txt" style="height:20px; line-height:20px;">' + prodlist[i].prodname.replace("<br />", "　") + '</div><div class="m-price" style="font-size:14px;">' + strprice + '</div></a><div class="prod-list-btn-xly">' + buybtn + '</div></li>';
                    }
                    if (html == "") {
                        html = '<li><div class="loading" style="font-size:14px;">暂无夏令营...</div></li>';
                    }
                    $('#prodlistul').html(html);
                }
            }
        });
    }
    function JoinXLY(productid) {
        if (openid == null || openid == '') {
            jumpLogin();
            return;
        }
        location.href = 'Join_xly.aspx?productid=' + productid;
    }
</script>
</asp:Content>

