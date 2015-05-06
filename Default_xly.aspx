<%@ Page Title="卢勤问答平台夏令营" Language="C#" MasterPageFile="~/Master.master" %>

<asp:Content ID="Content1" ContentPlaceHolderID="MasterHead" Runat="Server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="MasterContent" Runat="Server">
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
                        if (prodlist[i].prodid == 26) {
                            strprice = '<span class="red mgleft">¥' + parseInt(prodlist[i].originalprice) / 100 + '</span>';
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
                        var buybtn = '<a id="buyProd_xly" onclick="location.href=\'Join_xly.aspx?productid=' + prodlist[i].prodid + '\';" class="btn btn-danger">我要报名</a>';
                        html += '<li class="m-li left rel" style="width:100%"><a href="Detail_xly.aspx?productid=' + prodlist[i].prodid + '"><div class="pd5"><img src="' + domain + prodlist[i].imgsrc + '" /></div><div class="m-txt" style="height:40px; line-height:20px;">' + prodlist[i].prodname + '</div><div class="m-price" style="font-size:14px;">' + strprice + '</div></a><div class="prod-list-btn"><!--<a id="addShopCart" onclick="detailAddCart(' + prodlist[i].prodid + ', 1);" class="btn btn-default">加入购物车</a>-->' + buybtn + '</div></li>';
                    }
                    $('#prodlistul').html(html);
                }
            }
        });
    }
</script>
</asp:Content>

