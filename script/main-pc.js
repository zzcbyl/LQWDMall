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
    //alert(openid);
    if (openid == null || openid == '') {
        var jumpurl = document.URL;
        if (jumpurl.toLowerCase().indexOf("default") == -1 && jumpurl.toLowerCase().indexOf("detail") == -1) {
            jumpLogin();
        }
    }
    else {
        var jumpurl = document.URL;
        if (jumpurl.indexOf("#rd") > -1) {
            jumpurl = jumpurl.replace("#rd", "");
            location.href = jumpurl;
        }
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
        url: "/Handler.ashx",
        data: { method: "forcegettoken", openid: openid, random: Math.random() },
        success: function (data, textStatus) {
            if (data != null && data != "-1") {
                //alert(obj.token);
                setCookie('token', data);
                token = data;
            }
        }
    });
}

function jumpLogin() {
    if (confirm("您还没有登录，请您先登录")) {
        location.href = webdomain + "index.php?app=public&mod=Passport&act=login&reurl=" + encodeURIComponent(document.URL);
    }
    
    return;
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

    $.ajax({
        type: "get",
        async: false,
        url: domain + 'api/product_get_detail.aspx',
        data: { productid: pid, random: Math.random() },
        success: function (data, textStatus) {
            var obj = eval('(' + data + ')');
            if (obj != null) {
                $('#prodtitle').html(obj.prodname.replace("<br />", "　"));
                obj.description = obj.description.replace(/width=\"300px\"/g, 'width="500px"');
                $('#proddescription').html(obj.description);
                $('#prodimg').html('<img src="' + domain + obj.imgsrc + '" width="100%" />');
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
                    $('#originalprice').html('&nbsp;');
                    $('#prodprice').html('&nbsp;');
                }
                else {
                    if (obj.originalprice != null && obj.originalprice != '') {
                        $('#originalprice').show();
                        $('#originalprice').html('¥' + parseInt(obj.originalprice) / 100);
                    }
                    else if (pid == 24) {
                        $('#originalprice').hide();
                        $('#prodprice').html('　');
                    }
                    else
                        $('#originalprice').hide();
                }
                document.title = obj.prodname.replace("<br />", "　");
                shareTitle = delHtmlTag(obj.prodname); //标题
                imgUrl = domain + obj.images[0].src; //图片
                descContent = obj.summary; //简介
                lineLink = document.URL + "&source=1"; //链接
            }
        }
    });
}

function totalcart(id) {
    //alert(token);
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
                    $('#' + id).html('(' + obj.count + ')');
                    $('#' + id).show();
                }
                else {
                    $('#' + id).hide();
                }
            }
        }
    });

  
}

function detailAddCart(pid, isshow) {
    if (openid == null || openid == '') {
        jumpLogin();
        return;
    }

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
                $('#my_cart_em').html('(' + obj.count + ')');
                $('#my_cart_em').show();
            }
            else
                $('#my_cart_em').html('(' + obj.count + ')');
            if (isshow == 1)
                $('#myModal').modal('show');
            else
                location.href = "ShopCart.aspx?productid=" + pid;
        }
    });

    
}


//填充购物车
function fillcart() {
    $('#proditems').html('<li><div class="loading"><img src="images/loading.gif" /><br />加载中...</div></li>');
    $.ajax({
        type: "get",
        async: false,
        url: domain + 'api/cart.aspx',
        data: { token: token, random: Math.random() },
        success: function (data, textStatus) {
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
                    prodhtml += '<li id="li' + obj.items[i].product_id + '" class="sc-item"><a class="sc-p-del" onclick="delcartprodsingle(' + obj.items[i].product_id + ');">x</a><a class="cbox"><input type="checkbox" checked="true" onclick="selCbx();" value="' + obj.items[i].product_id + '" /></a><a id="p-img-block" href="Detail_bk.aspx?productid=' + obj.items[i].product_id + '"><img id="p-img" src="' + domain + obj.items[i].imgsrc + '" width="80px" height="80px" /></a><a id="p-title" href="Detail_bk.aspx?productid=' + obj.items[i].product_id + '">' + obj.items[i].prodname + '</a><a id="p-xinghao">无型号</a><div style="margin-left:20px;"><div id="p-price-block"><span id="p-price" class="red">￥' + parseInt(obj.items[i].price) / 100 + '</span></div><div class="sc-p-count"><a href="javascript:SubCount(' + obj.items[i].product_id + ');">－</a><input id="p-count' + obj.items[i].product_id + '" type="text" value="' + obj.items[i].product_count + '" onblur="InCount(' + obj.items[i].product_id + ',' + obj.items[i].inventory + ');" /><a href="javascript:AddCount(' + obj.items[i].product_id + ',' + obj.items[i].inventory + ');">＋</a></div><div class="clear"></div></div></li>';
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
                prodhtml = '<li><div class="loading" style="font-size:14px;">暂无商品</div></li>';
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
    totalcart('my_cart_em');
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
    $('#prodlist').html('<li><div class="loading"><img src="images/loading.gif" /><br />加载中...</div></li>');
    $.ajax({
        type: "get",
        async: false,
        url: domain + 'api/cart.aspx',
        data: { token: token, random: Math.random() },
        success: function (data, textStatus) {
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
                        prodhtml += '<li class="sub-cart-prod"><a class="prod-img" href="Detail_bk.aspx?productid=' + obj.items[i].prodid + '"><img src="' + domain + obj.items[i].imgsrc + '" width="50px" height="50px" /></a><a class="prod-title" href="Detail_bk.aspx?productid=' + obj.items[i].prodid + '">' + obj.items[i].prodname + '</a><a class="prod-xinghao">无型号</a><a class="prod-price"><span class="red">¥' + parseInt(obj.items[i].price) / 100 + '</span></a><a class="prod-count">X ' + obj.items[i].product_count + '</a></li>';
                    }
                    if (str_productids.length > 0)
                        str_productids = str_productids.substring(0, str_productids.length - 1);
                    if (str_counts.length > 0)
                        str_counts = str_counts.substring(0, str_counts.length - 1);
                }
                else
                    prodhtml = "";
                t_prod_price = orderprice;
                var totalHtml = '<li class="sub-total"><a id="freight_fee">运费: <span class="red">--</span></a><a id="total_count">共' + ordercount + '件商品，合计: <span class="red">¥' + parseInt(orderprice) / 100 + '</span></a></li>';
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
                $("#province").append("<option value='0' >请选择省份……</option>");
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
                $("#city").append("<option value='0' >请选择城市……</option>");
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
    var freight_fee = "--";
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
            str_state = "已发货　" + number;
            break;
        case 3:
            str_state = "已退款";
            break;
    }
    return str_state;
}


