var token = '';
var openid = '';
var from = '';
function GetOpenidToken() {
    openid = QueryString('openid');
    if (openid != null) {
        setCookie('openid', openid);
        GetToken();
    }
    else {
        openid = getCookie('openid');
    }

    from = QueryString('from');
    if (from != null) {
        setCookie('from', from);
    }
    else {
        from = getCookie('from');
    }

    token = getCookie('token');
    if (token == null || token == 'undefined') {
        GetToken();
    }
}
function GetToken() {
    $.ajax({
        type: "get",
        async: false,
        url: domain + 'api/user_get_token.aspx',
        data: { username: openid, random: Math.random() },
        success: function (data, textStatus) {
            var obj = JSON.parse(data);
            if (obj != null && obj.status == 1) {
                //alert(obj.token);
                setCookie('token', obj.token);
                token = obj.token;
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
    $('#prodtitle').html('<div class="loading"><img src="images/loading.gif" /><br />加载中...</div>');
    $.post(domain + 'api/product_get_detail.aspx', { productid: pid, random: Math.random() }, function (data) {
        //alert(data);
        $('#prodtitle').html(data.prodname);
        $('#proddescription').html(data.description);
        $('#prodimg').html('<img src="' + domain + data.images[0].src + '" width="100%" />');
        $('#prodprice').html('¥' + parseInt(data.price)/100);
    }, 'json');
}

function totalcart(id) {
    $.post(domain + 'api/cart.aspx', { token: token, random: Math.random() }, function (data) {
        if (data.status == -1) {
            GetToken();
            totalcart();
        }
        if (data.count > 0) {
            $('#' + id).html(data.count);
            $('#' + id).show();
        }
    }, 'json');
}

function detailAddCart(pid, isshow) {
    $.post(domain + 'api/cart.aspx', { token: token, productid: pid, count: 1, random: Math.random() }, function (data) {
        if (data.status == -1) {
            GetToken();
            detailAddCart();
        }
        if ($("#my_cart_em").is(":hidden")) {
            $('#my_cart_em').html(data.count);
            $('#my_cart_em').show();
        }
        else
            $('#my_cart_em').html(data.count);
        if (isshow == 1)
            $('#myModal').modal('show');
        else
            location.href = "ShopCart.aspx?productid=" + pid;
    }, 'json');
}


//填充购物车
function fillcart() {
    $('#proditems').html('<li><div class="loading"><img src="images/loading.gif" /><br />加载中...</div></li>');
    $.post(domain + 'api/cart.aspx', { token: token, random: Math.random() }, function (data) {
        if (data.status == -1) {
            GetToken();
            fillcart();
        }
        var prodhtml = "";
        if (data.count > 0) {
            var prodids = "";
            for (var i = 0; i < data.items.length; i++) {
                prodids += data.items[i].product_id + ",";
                prodhtml += '<li id="li' + data.items[i].product_id + '" class="sc-item"><a class="sc-p-del" onclick="delcartprodsingle(' + data.items[i].product_id + ');">x</a><a class="cbox"><input type="checkbox" checked="true" onclick="selCbx();" value="' + data.items[i].product_id + '" /></a><a id="p-img-block" href="Detail.aspx?productid=' + data.items[i].product_id + '"><img id="p-img" src="' + data.items[i].imgsrc + '" width="50px" height="50px" /></a><a id="p-title" href="Detail.aspx?productid=' + data.items[i].product_id + '">' + data.items[i].prodname + '</a><a id="p-xinghao">无型号</a><div style="margin-left:20px;"><div id="p-price-block"><span id="p-price" class="red">￥' + parseInt(data.items[i].price) / 100 + '</span></div><div class="sc-p-count"><a href="javascript:SubCount(' + data.items[i].product_id + ');">－</a><input id="p-count' + data.items[i].product_id + '" type="text" value="' + data.items[i].product_count + '" onblur="InCount(' + data.items[i].product_id + ',' + data.items[i].inventory + ');" /><a href="javascript:AddCount(' + data.items[i].product_id + ',' + data.items[i].inventory + ');">＋</a></div><div class="clear"></div></div></li>';
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
        $("#cartTotal").html("￥" + parseInt(data.amount_price) / 100);
    }, 'json');
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
    }
}

function dealCartCount(pid, count) {
    $.post(domain + 'api/cart.aspx', { token: token, productid: pid, count: count, random: Math.random() }, function (data) {
        if (data.status == -1) {
            GetToken();
            dealCartCount(pid, count);
        }
    });
}

function so_fillProd() {
    $('#prodlist').html('<li><div class="loading"><img src="images/loading.gif" /><br />加载中...</div></li>');
    $.post(domain + 'api/cart.aspx', { token: token, random: Math.random() }, function (data) {
        if (data.status == -1) {
            GetToken();
            so_fillProd();
        }
        else {
            var prodhtml = "";
            if (data.count > 0) {
                var str_prodids = QueryString("prodids");
                if (str_prodids.length <= 0) return;
                var prodidsArr = str_prodids.split(',');
                for (var i = 0; i < data.items.length; i++) {
                    //if (prodidsArr.indexOf(data.items[i].prodid) == -1)
                    //    continue;
                    str_productids += data.items[i].prodid + ",";
                    str_counts += data.items[i].product_count + ",";
                    pcount += parseInt(data.items[i].product_count);
                    prodhtml += '<li class="sub-cart-prod"><a class="prod-img" href="Detail.aspx?productid=' + data.items[i].prodid + '"><img src="' + domain + data.items[i].imgsrc + '" width="50px" height="50px" /></a><a class="prod-title" href="Detail.aspx?productid=' + data.items[i].prodid + '">' + data.items[i].prodname + '</a><a class="prod-xinghao">无型号</a><a class="prod-price"><span class="red">¥' + parseInt(data.items[i].price) / 100 + '</span></a><a class="prod-count">X ' + data.items[i].product_count + '</a></li>';
                }
                if (str_productids.length > 0)
                    str_productids = str_productids.substring(0, str_productids.length - 1);
                if (str_counts.length > 0)
                    str_counts = str_counts.substring(0, str_counts.length - 1);
            }
            else
                prodhtml = "";
            t_prod_price = data.amount_price;
            var totalHtml = '<li class="sub-total"><a id="freight_fee">运费: <span class="red">--</span></a><a id="total_count">共' + data.count + '件商品，合计: <span class="red">¥' + parseInt(data.amount_price) / 100 + '</span></a></li>';
            $('#prodlist').html(prodhtml + totalHtml);
            so_fillProvince();
        }
    }, 'json');
}

function so_fillProvince() {
    $.post(domain + 'api/area_get_subarea_by_parentid.aspx', { random: Math.random() }, function (data) {
        if (data.status == -1) {
            GetToken();
            so_fillAddress();
        }
        else {
            $("#province").empty();
            //$("#province").append("<option value='-1'>--省份--</option>");
            for (var i = 0; i < data.area.length; i++) {
                $("#province").append("<option value='" + data.area[i].id + "'>" + data.area[i].name + "</option>");
            }
            totalFeight($("#province option:selected").text(), pcount);
            so_fillAddress();
        }
    }, 'json');
}

function so_fillCity(pid, city) {
    $.post(domain + 'api/area_get_subarea_by_parentid.aspx', { parentid: pid, random: Math.random() }, function (data) {
        if (data.status == -1) {
            GetToken();
            so_fillCity(pid);
        }
        else {
            $("#city").empty();
            //$("#city").append("<option value='-1'>--城市--</option>");
            var seltxt = "";
            for (var i = 0; i < data.area.length; i++) {
                if (city != "" && data.area[i].name == city)
                    seltxt = " selected='true'"
                else
                    seltxt = "";
                $("#city").append("<option value='" + data.area[i].id + "'" + seltxt + ">" + data.area[i].name + "</option>");
            }
        }
    }, 'json');
}

function so_fillAddress() {
    $.post(domain + 'api/user_get_address.aspx', { token: token, random: Math.random() }, function (data) {
        if (data.status == -1) {
            GetToken();
            so_fillAddress();
        }
        else {
            var city_js = '';
            if (data.addresses != null && data.addresses.length > 0) {
                $("#consignee").val(data.addresses[0].name);
                $("#mobile").val(data.addresses[0].cell);
                $("#address").val(data.addresses[0].address);
                $("#province").find("option").each(function () {
                    if ($(this).text() == data.addresses[0].province) {
                        $(this).attr("selected", true);
                    }
                });
                //$("#province").find("option[text='天津市']").attr("selected", "selected");
                city_js = data.addresses[0].city;
            }
            so_fillCity($("#province").val(), city_js);
        }
    }, "json");
}

function totalFeight(province, count) {
    var freight_fee = "--";
    $.ajax({
        type: "get",
        async: false,
        url: domain + 'api/ship_fee_calculate.aspx',
        data: { province: province, count: count, random: Math.random() },
        success: function (data, textStatus) {
            var obj = JSON.parse(data);
            if (obj.status == -1) {
                GetToken();
                totalFeight(province, count);
            }
            else {
                freight_fee = obj.amount;
            }
        }
    });
    $('#freight_fee span').eq(0).html("￥" + (parseInt(freight_fee) / 100).toString());
    $('#total_amount span').eq(0).html("￥" + ((t_prod_price + freight_fee)/100).toString());
}



function orderState(state, oid) {
    var str_state = '';
    switch (state) {
        case 0:
            str_state = '<em class="o-state-close">未付款</em> <a onclick="ls_pay(' + oid + ')" class="btn paybtn">立即付款</a>';
            break;
        case 1:
            str_state = "已付款 未发货";
            break;
        case 2:
            str_state = "已发货";
            break;
        case 3:
            str_state = "已收货";
            break;
    }
    return str_state;
}


