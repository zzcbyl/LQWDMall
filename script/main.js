var token = '';
var openid = '';
var from = '';
var shareTitle = "卢勤问答平台官方商城"; //标题
var imgUrl = "http://mall.luqinwenda.com/images/index-left.jpg"; //图片
var descContent = "卢勤问答平台官方认证商城，包括卢勤老师认证的正版书籍以及家庭教育相关产品。"; //简介
var lineLink = "http://mall.luqinwenda.com/index.aspx?source=1"; //链接
var deadline_28 = (Date.parse(new Date("2015/12/1"))) / 1000;
var deadline_30 = (Date.parse(new Date("2015/12/1"))) / 1000;
var currentDT = (Date.parse(new Date())) / 1000;
function GetOpenidToken() {
    openid = QueryString('openid');
    if (openid != null) {
        setCookie('openid', openid);
        GetToken();
    }
    else {
        openid = getCookie('openid');
    }

    from = QueryString('source');
    if (from != null) {
        setCookie('from', from);
    }
    else {
        from = getCookie('from');
    }
    var refer = document.referrer;
    if (QueryString('source') == null && refer == '') {
        delCookie("from");
        from = null;
    }
    if (openid == null || openid == '' || openid == 'undefined') {
        var encodeDomain = encodeURIComponent(domain + 'index.aspx');
        if (QueryString('productid') != null) {
            var jumpurl = document.URL;
            if (jumpurl.indexOf("#rd") > -1) {
                jumpurl = jumpurl.replace("#rd", "");
            }
            encodeDomain = encodeURIComponent(jumpurl);
        }
        location.href = "http://weixin.luqinwenda.com/authorize_0603.aspx?callback=" + encodeDomain;
    }
    else {
        var jumpurl = document.URL;
        if (jumpurl.indexOf("#rd") > -1) {
            jumpurl = jumpurl.replace("#rd", "");
            location.href = jumpurl;
        }
    }

    var openidtoken = getCookie('token');
    //alert(openidtoken);
    if (openidtoken == null || openidtoken == 'undefined') {
        GetToken();
    }
    else {
        var arr = openidtoken.split('|');
        if (arr[0] == openid)
            token = arr[1];
        else {
            GetToken();    
        }
    }
}
function GetToken() {

    $.ajax({
        type: "get",
        async: false,
        url: "Handler.ashx",
        data: { method: "forcegettoken", openid: openid, random: Math.random() },
        success: function (data, textStatus) {
            if (data != null && data != "-1") {
                //alert(obj.token);
                setCookie('token', openid + "|" + data);
                token = data;
            }
        }
    });
}

//购物车 减少数量
function SubCount(id) {
    var cc = parseInt($("#p-count" + id).val());
    cc -= 1;
    if (cc < 1)
        cc = 1;
    $("#p-count" + id).val(cc);
    dealCartCount(id, cc);
    totalcartprice();
    
}
//购物车 增加数量
function AddCount(id, total) {
    var cc = parseInt($("#p-count" + id).val());
    cc += 1;
    if (cc > total)
        cc = total;
    $("#p-count" + id).val(cc);
    dealCartCount(id, cc);
    totalcartprice();
}
//购物车 输入数量
function InCount(id ,total) {
    if (parseInt($("#p-count" + id).val()) > total)
        $("#p-count" + id).val(total);
    dealCartCount(id, $("#p-count" + id).val());
    totalcartprice();
}

function filldetail(pid) {
    //$('#prodtitle').html('<div class="loading"><img src="images/loading.gif" /><br />加载中...</div>');

    $.ajax({
        type: "get",
        async: false,
        url: domain + 'api/product_get_detail.aspx',
        data: { productid: pid, random: Math.random() },
        success: function (data, textStatus) {
            var obj = eval('(' + data + ')');
            if (obj != null) {
                $('#prodtitle').html(obj.prodname);
                $('#proddescription').html(obj.description);
                $('#prodimg').html('<img src="' + domain + obj.images[0].src + '" width="100%" />');
                $('#prodprice').html('¥' + parseInt(obj.price) / 100);
                if (pid == 28) {
                    var price_1 = parseInt(obj.price);
                    if (repeat == 1) {
                        price_1 -= 30000;
                    }
                    if (currentDT <= deadline_28) {
                        price_1 -= 30000;
                    }
                    if (parseInt(obj.originalprice) != price_1) {
                        $('#originalprice').show();
                        $('#originalprice').html('¥' + parseInt(obj.originalprice) / 100);
                    }
                    $('#prodprice').html('¥' + price_1 / 100);
                }
                else if (pid == 30) {
//                    var price_1 = parseInt(obj.price);
//                    if (repeat == 1) {
//                        price_1 -= 100000;
//                    }
//                    if (currentDT <= deadline_30) {
//                        price_1 -= 80000;
//                    }
//                    if (parseInt(obj.originalprice) != price_1) {
//                        $('#originalprice').show();
//                        $('#originalprice').html('¥' + parseInt(obj.originalprice) / 100);
                    //                    }
                    $('#originalprice').html('');
                    $('#prodprice').html('');
                }
                else {
                    if (obj.originalprice != null && obj.originalprice != '') {
                        $('#originalprice').show();
                        $('#originalprice').html('¥' + parseInt(obj.originalprice) / 100);
                    }
                    else if (pid == 24) {
                        $('#originalprice').hide();
                        $('#prodprice').hide();
                    }
                    else
                        $('#originalprice').hide();
                }


                shareTitle = delHtmlTag(obj.prodname); //标题
                imgUrl = domain + obj.images[0].src; //图片
                descContent = obj.summary; //简介
                lineLink = document.URL + "&source=1"; //链接
            }
        }
    });
}

function totalcart(id) {
    $.ajax({
        type: "get",
        async: false,
        url: domain + 'api/cart.aspx',
        data: { token: token, random: Math.random() },
        success: function (data, textStatus) {
            var obj = eval('(' + data + ')');
            if (obj.status == 1) {
                GetToken();
                totalcart(id);
                return;
            }
            if (obj.status == 0) {
                if (obj.count > 0) {
                    $('#' + id).html(obj.count);
                    $('#' + id).show();
                }
            }
        }
    });

  
}

function detailAddCart(pid, isshow) {
    //alert(token);
    $.ajax({
        type: "get",
        async: false,
        url: domain + 'api/cart.aspx',
        data: { token: token, productid: pid, count: 1, random: Math.random() },
        success: function (data, textStatus) {
            var obj = eval('(' + data + ')');
            if (obj.status == 1) {
                GetToken();
                detailAddCart(pid, isshow);
                return;
            }
            if ($("#my_cart_em").is(":hidden")) {
                $('#my_cart_em').html(obj.count);
                $('#my_cart_em').show();
            }
            else
                $('#my_cart_em').html(obj.count);
            if (isshow == 1)
                $('#myModal').modal('show');
            else
                location.href = "ShopCart.aspx?productid=" + pid;
        }
    });

    
}


//填充购物车
function fillcart() {
    //$('#proditems').html('<li><div class="loading"><img src="images/loading.gif" /><br />加载中...</div></li>');
    //alert('123');
    $.ajax({
        type: "get",
        async: false,
        url: domain + 'api/cart.aspx',
        data: { token: token, random: Math.random() },
        success: function (data, textStatus) {
            //alert(data);
            var obj = eval('(' + data + ')');
            if (obj.status == 1) {
                GetToken();
                fillcart();
                return;
            }
            var prodhtml = "";
            if (obj.count > 0) {
                var prodids = "";
                for (var i = 0; i < obj.items.length; i++) {
                    prodids += obj.items[i].product_id + ",";
                    prodhtml += '<li id="li' + obj.items[i].product_id + '" class="sc-item"><a class="sc-p-del" onclick="delcartprodsingle(' + obj.items[i].product_id + ');">x</a><a class="cbox"><input type="checkbox" checked="true" onclick="selCbx();" value="' + obj.items[i].product_id + '" /></a><a id="p-img-block" href="Detail.aspx?productid=' + obj.items[i].product_id + '"><img id="p-img" src="' + obj.items[i].imgsrc + '" width="50px" height="50px" /></a><a id="p-title" href="Detail.aspx?productid=' + obj.items[i].product_id + '">' + obj.items[i].prodname + '</a><a id="p-xinghao">无型号</a><div style="margin-left:20px;"><div id="p-price-block"><span id="p-price" class="red">￥' + parseInt(obj.items[i].price) / 100 + '</span></div><div class="sc-p-count"><a href="javascript:SubCount(' + obj.items[i].product_id + ');">－</a><input id="p-count' + obj.items[i].product_id + '" type="text" value="' + obj.items[i].product_count + '" onblur="InCount(' + obj.items[i].product_id + ',' + obj.items[i].inventory + ');" /><a href="javascript:AddCount(' + obj.items[i].product_id + ',' + obj.items[i].inventory + ');">＋</a></div><div class="clear"></div></div></li>';
                }
                if (prodids.length > 0)
                    prodids = prodids.substring(0, prodids.length - 1);
                $("#sc_submit").attr("href", "SubmitOrder.aspx?prodids=" + prodids);
                $('#sc_del').attr("onclick", "delcartprod();");
                $('#sc_del').css("color", "");
            }
            else {
                prodhtml = "";
                $("#sc_submit").attr("href", "javascript:void(0);");
                $('#sc_del').attr("onclick", "");
                $('#sc_del').css("color", "#ccc");
            }
            $('#proditems').html(prodhtml);
            $("#cartTotal").html("￥" + parseInt(obj.amount_price) / 100);
        }
    });


}

function selCbx() {
    var isall = false;
    var prodids = "";
    $('.cbox input[type=checkbox]').each(function () {
        if (this.checked) {
            prodids += $(this).val() + ",";
            isall = true;
        }
    });
    if (prodids.length > 0)
        prodids = prodids.substring(0, prodids.length - 1);
    totalcartprice();

    if (isall) {
        $('#sc_del').attr("onclick", "delcartprod();");
        $('#sc_del').css("color", "");
        $("#sc_submit").attr("href", "SubmitOrder.aspx?prodids=" + prodids);
    }
    else {
        $('#sc_del').attr("onclick","");
        $('#sc_del').css("color", "#ccc");
        $("#sc_submit").attr("href", "javascript:void(0);");
    }
}

function totalcartprice() {
    var ctotal = 0;
    $('.cbox input[type=checkbox]').each(function () {
        if (this.checked) {
            var danPrice = parseFloat($(this).parent().parent().find("#p-price").html().replace("￥", ""));
            var danCount = parseInt($(this).parent().parent().find(".sc-p-count input").eq(0).val());
            ctotal += danPrice * danCount;
        }
    });
    $("#cartTotal").html("￥" + Math.round(ctotal * 100) / 100);
}

function delcartprod() {
    if (confirm("确定删除选中的商品吗?")) {
        $('.cbox input[type=checkbox]').each(function () {
            if (this.checked) {
                var pid = $(this).val();
                dealCartCount(pid, 0);
                $('#li' + pid).remove();
                selCbx();
            }
        });
    }
}
function delcartprodsingle(pid) {
    if (confirm("确定删除选中的商品吗?")) {
        dealCartCount(pid, 0);
        $('#li' + pid).remove();
        selCbx();
    }
}

function dealCartCount(pid, count) {
    $.ajax({
        type: "get",
        async: false,
        url: domain + 'api/cart.aspx',
        data: { token: token, productid: pid, count: count, random: Math.random() },
        success: function (data, textStatus) {
            var obj = eval('(' + data + ')');
            if (obj.status == 1) {
                GetToken();
                dealCartCount(pid, count);
            }
        }
    });
}

function so_fillProd() {
    //$('#prodlist').html('<li><div class="loading"><img src="images/loading.gif" /><br />加载中...</div></li>');
    $.ajax({
        type: "get",
        async: false,
        url: domain + 'api/cart.aspx',
        data: { token: token, random: Math.random() },
        success: function (data, textStatus) {
            //alert(data);
            var obj = eval('(' + data + ')');
            if (obj.status == 1) {
                GetToken();
                so_fillProd();
            }
            else {
                var prodhtml = "";
                var orderprice = 0;
                var ordercount = 0;
                if (obj.count > 0) {
                    var str_prodids = QueryString("prodids");
                    if (str_prodids.length <= 0) return;
                    var prodidsArr = str_prodids.split(',');
                    for (var i = 0; i < obj.items.length; i++) {
                        if (prodidsArr.indexOf(obj.items[i].prodid) == -1)
                            continue;
                        str_productids += obj.items[i].prodid + ",";
                        str_counts += obj.items[i].product_count + "|" + obj.items[i].precount + ",";
                        pcount += parseInt(obj.items[i].product_count) * parseInt(obj.items[i].precount);
                        ordercount++;
                        orderprice += parseInt(obj.items[i].price) * parseInt(obj.items[i].product_count);
                        prodhtml += '<li class="sub-cart-prod"><a class="prod-img" href="Detail.aspx?productid=' + obj.items[i].prodid + '"><img src="' + domain + obj.items[i].imgsrc + '" width="50px" height="50px" /></a><a class="prod-title" href="Detail.aspx?productid=' + obj.items[i].prodid + '">' + obj.items[i].prodname + '</a><a class="prod-xinghao">无型号</a><a class="prod-price"><span class="red">￥' + parseInt(obj.items[i].price) / 100 + '</span></a><a class="prod-count">X ' + obj.items[i].product_count + '</a></li>';
                    }
                    if (str_productids.length > 0)
                        str_productids = str_productids.substring(0, str_productids.length - 1);
                    if (str_counts.length > 0)
                        str_counts = str_counts.substring(0, str_counts.length - 1);
                }
                else
                    prodhtml = "";
                t_prod_price = orderprice;
                var preferential = '';
                if (getCookie("followerAmount") != null) {
                    var prePrice = parseInt(getCookie("followerAmount")) * 100;
                    if (prePrice > parseInt(t_prod_price))
                        prePrice = t_prod_price;
                    preferential = '<a id="preferential">六一优惠: <span class="red">￥' + prePrice / 100 + '</span></a>';
                    t_prePrice = 0 - prePrice;
                }

                var totalHtml = '<li class="sub-total"><a id="freight_fee">运费: <span class="red">--</span></a>' + preferential + '<a id="total_count">共' + ordercount + '件商品，合计: <span class="red">￥' + parseInt(orderprice) / 100 + '</span></a><div class="clear"></div></li>';
                $('#prodlist').html(prodhtml + totalHtml);
                so_fillProvince();
            }
        }
    });

}

function so_fillProvince() {
    $.ajax({
        type: "get",
        async: false,
        url: domain + 'api/area_get_subarea_by_parentid.aspx',
        data: { random: Math.random() },
        success: function (data, textStatus) {
            var obj = eval('(' + data + ')');
            if (obj.status == 1) {
                GetToken();
                so_fillProvince();
            }
            else {
                $("#province").empty();
                //$("#province").append("<option value='-1'>--省份--</option>");
                for (var i = 0; i < obj.area.length; i++) {
                    $("#province").append("<option value='" + obj.area[i].id + "'>" + obj.area[i].name + "</option>");
                }
                so_fillAddress();
                totalFeight($("#province option:selected").text(), pcount);
            }
        }
    });
}

function so_fillCity(pid, city) {
    $.ajax({
        type: "get",
        async: false,
        url: domain + 'api/area_get_subarea_by_parentid.aspx',
        data: { parentid: pid, random: Math.random() },
        success: function (data, textStatus) {
            var obj = eval('(' + data + ')');
            if (obj.status == 1) {
                GetToken();
                so_fillCity(pid, city);
            }
            else {
                $("#city").empty();
                //$("#city").append("<option value='-1'>--城市--</option>");
                var seltxt = "";
                for (var i = 0; i < obj.area.length; i++) {
                    if (city != "" && obj.area[i].name == city)
                        seltxt = " selected='true'"
                    else
                        seltxt = "";
                    $("#city").append("<option value='" + obj.area[i].id + "'" + seltxt + ">" + obj.area[i].name + "</option>");
                }
            }
        }
    });
}

function so_fillAddress() {
    //alert(token);
    $.post(domain + 'api/user_get_address.aspx', { token: token, random: Math.random() }, function (data) {
        if (data.status == 1) {
            GetToken();
            so_fillAddress();
        }
        else {
            var city_js = '';
            if (data.addresses != null && data.addresses.length > 0) {
                $("#consignee").val(data.addresses[data.addresses.length - 1].name);
                $("#mobile").val(data.addresses[data.addresses.length - 1].cell);
                $("#address").val(data.addresses[data.addresses.length - 1].address);
                $("#province").find("option").each(function () {
                    if ($(this).text() == data.addresses[data.addresses.length - 1].province) {
                        $(this).attr("selected", true);
                    }
                });
                //$("#province").find("option[text='天津市']").attr("selected", "selected");
                city_js = data.addresses[data.addresses.length - 1].city;
            }
            so_fillCity($("#province").val(), city_js);
        }
    }, "json");
}

function totalFeight(province, count) {
    $.ajax({
        type: "get",
        async: false,
        url: domain + 'api/ship_fee_calculate.aspx',
        data: { province: province, count: count, random: Math.random() },
        success: function (data, textStatus) {
            var obj = JSON.parse(data);
            if (obj.status == 1) {
                GetToken();
                totalFeight(province, count);
            }
            else {
                freight_fee = obj.amount;
            }
        }
    });
    if (parseInt(freight_fee) == 0)
        $('#freight_fee span').eq(0).html("-");
    else
        $('#freight_fee span').eq(0).html("￥" + (parseInt(freight_fee) / 100).toString());
    $('#total_amount span').eq(0).html("￥" + ((t_prod_price + freight_fee + t_prePrice) / 100).toString());
}

function orderState(state, oid, number) {
    var str_state = '';
    switch (state) {
        case 0:
            str_state = '<em class="o-state-close">未付款</em> <a onclick="ls_pay(' + oid + ')" class="btn paybtn">立即付款</a>';
            break;
        case 1:
            str_state = "已付款 未发货";
            break;
        case 2:
            str_state = "已发货　" + number;
            break;
        case 3:
            str_state = "已退款";
            break;
    }
    return str_state;
}


//使用优惠券
function useCoupon() {
    if ($('#conponTxt').val().Trim() == "") {
        $('#conponErrorMsg').html("");
        $('#total_amount span').eq(0).html("￥" + ((t_prod_price + freight_fee + t_prePrice) / 100).toString());
        return true;
    }
    $.ajax({
        type: "get",
        async: true,
        url: domain + 'api/coupon_check.aspx',
        data: { code: $('#conponTxt').val(), random: Math.random() },
        success: function (data, textStatus) {
            var obj = JSON.parse(data);
            if (obj.status == 1) {
                $('#conponErrorMsg').html("优惠券不存在");
                $('#total_amount span').eq(0).html("￥" + ((t_prod_price + freight_fee + t_prePrice) / 100).toString());
                return false;
            }
            else {
                if (obj.used == 1) {
                    $('#conponErrorMsg').html("优惠券已使用");
                    $('#total_amount span').eq(0).html("￥" + ((t_prod_price + freight_fee + t_prePrice) / 100).toString());
                    return false;
                }
                var stringTime = obj.expire_date;
                var timestamp = Date.parse(new Date(stringTime));
                timestamp = timestamp / 1000;

                var currenttimestamp = Date.parse(new Date());
                currenttimestamp = currenttimestamp / 1000;

                if (currenttimestamp > timestamp) {
                    $('#conponErrorMsg').html("优惠券已过期");
                    $('#total_amount span').eq(0).html("￥" + ((t_prod_price + freight_fee + t_prePrice) / 100).toString());
                    return false;
                }

                $('#conponErrorMsg').html("<span style='color:#666;'>优惠:</span>￥" + (obj.amount / 100).toString());
                $('#total_amount span').eq(0).html("￥" + ((t_prod_price + freight_fee + t_prePrice - obj.amount) / 100).toString());
                return true;
            }
        }
    });
}