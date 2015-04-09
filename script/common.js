var IE = navigator.appName == "Microsoft Internet Explorer";
var NS = navigator.appName == "Netscape";
var Opera = navigator.appName == "Opera";
var ie = IE;
var ns = NS;
var ff = ns;
var FF = ns;
var IsIE = ie;
var IsNs = ns;
var isSa = false;
if (NS && navigator.appVersion.toLowerCase().indexOf("safari") > 0) isSa = true;
var ie7 = IE && navigator.appVersion.toLowerCase().indexOf("ie 7") > 0;
var ie6 = IE && navigator.appVersion.toLowerCase().indexOf("ie 6") > 0;
var Sa = isSa;
var sa = Sa;

function getParamValue(URL, ParamName) {
    var Opt = getParam(URL);
    for (i = 0; i < Opt[0].length; i++) {
        if (Opt[0][i].toLowerCase() == ParamName.toLowerCase()) return Opt[1][i];
    }
    return null;
}
function getParam(URL) {
    URL = URL.substring(URL.indexOf("?") + 1, URL.length);
    var opt = URL.split("&");
    var topt = new Array();
    topt[0] = opt[0];
    for (var i = 1; i < opt.length; i++) {
        if (opt[i].toLocaleString().indexOf("amp;") == 0) {
            topt[topt.length - 1] += "&" + opt[i];
        }
        else {
            topt[topt.length] = opt[i];
        }
    }
    opt = topt;
    var para = new Array();
    var value = new Array();
    for (i = 0; i < opt.length; i++) {
        para[i] = opt[i].substring(0, opt[i].indexOf("="));
        value[i] = opt[i].substring(opt[i].indexOf("=") + 1, opt[i].length);
    }
    var result = new Array(para, value);
    return result;
}
function QueryString(ParamName) {
    return getParamValue(window.location.href, ParamName);
}

//获得Cookie解码后的值
function GetCookieVal(offset) {
    var endstr = document.cookie.indexOf(";", offset);
    if (endstr == -1) {
        endstr = document.cookie.length;
    }
    return unescape(document.cookie.substring(offset, endstr));
}

//获得Cookie解码后的值
function GetCookieV(sName) {
    var aCookie = document.cookie.split("; ");
    for (var i = 0; i < aCookie.length; i++) {
        var aCrumb = aCookie[i].split("=");
        if (escape(sName) == aCrumb[0])
            return unescape(aCrumb[1]);
    }
    return null;
}
// 写 cookie
function setCookieT(sName, sValue, iTime) {
    if (ie) {
        setCookie(sName, sValue, iTime);
    }
    else {
        var date = new Date();
        if (iTime)
            date.setTime(date.getTime() + iTime * 1000);
        else
            date.setTime(date.getTime() + 3600 * 24 * 365 * 3 * 1000);
        //alert(date.getYear() + "," + date.getMonth() + "," + date.getDate());
        document.cookie = escape(sName) + "=" + escape(sValue) + "; Expires=" + date.toGMTString();
    }
}
// 读 cookie
function getCookieT(sName) {
    if (ie) {
        getCookie(sName);
    }
    else {
        var aCookie = document.cookie.split("; ");
        for (var i = 0; i < aCookie.length; i++) {
            var aCrumb = aCookie[i].split("=");
            if (escape(sName) == aCrumb[0])
                return unescape(aCrumb[1]);
        }
        return null;
    }
}
//设定Cookie值
function SetCookie(name, value) {
    var expdate = new Date();
    var argv = SetCookie.arguments;
    var argc = SetCookie.arguments.length;
    var expires = (argc > 2) ? argv[2] : null;
    var path = (argc > 3) ? argv[3] : null;
    var domain = (argc > 4) ? argv[4] : null;
    var secure = (argc > 5) ? argv[5] : false;
    if (expires != null) expdate.setTime(expdate.getTime() + (expires * 1000));
    //alert(expdate.getYear() + "," + expdate.getMonth() + "," + expdate.getDate());
    if (ie) {
        UserData.setValue(name, value, arguments.length > 2 ? arguments[2] : null);
    }
    else {
        var str = name + "=" + escape(value) + ";" + ((expires == null) ? "" : (" Expires=" + expdate.toGMTString() + ";")) + ((path == null) ? "" : (" path=" + path + ";")) + ((domain == null) ? "" : ("domain=" + domain + ";")) + ((secure == true) ? "secure;" : "");
        document.cookie = str;
    }
}
var setCookie = SetCookie;

//删除Cookie
function delCookie(name) { DelCookie(name); }
function removeCookie(name) { DelCookie(name); }
function RemoveCookie(name) { DelCookie(name); }
function DelCookie(name) {
    if (ie) {
        UserData.removeValue(name);
    }
    else {
        var exp = new Date();
        exp.setTime(exp.getTime() - 1);
        var cval = GetCookie(name);
        document.cookie = name + "=" + cval + "; Expires=" + exp.toGMTString();
    }
}
//获得Cookie的原始值
function getCookie(name) { return GetCookie(name) }
function GetCookie(name) {
    if (ie) {
        return UserData.getValue(name);
    }
    else {
        var arg = name + "=";
        var alen = arg.length;
        var clen = document.cookie.length;
        var i = 0;
        while (i < clen) {
            var j = i + alen;
            if (document.cookie.substring(i, j) == arg) {
                return GetCookieVal(j);
            }
            i = document.cookie.indexOf(" ", i) + 1;
            if (i == 0) {
                break;
            }
        }
        return null;
    }
}
var UserData = {};
UserData.DataFile = "UDCookie";
UserData.Object = null;
UserData.init = function () {
    if (!UserData.Object) {
        try {
            UserData.Object = document.createElement('input');
            UserData.Object.type = "hidden";
            UserData.Object.addBehavior("#default#userData");
            document.body.appendChild(UserData.Object);
        }
        catch (e) {
            UserData.Object = null;
            return false;
        }
    }
    return true;
}
UserData.setValue = function (Name, Value, Time) {
    if (!UserData.Object) {
        if (!UserData.init()) return;
    }
    if (UserData.Object) {
        var o = UserData.Object;
        o.load(UserData.DataFile);
        if (UserData.DataFile) o.setAttribute(Name, escape(Value));
        var d = new Date(); //.Time.Date();
        d.setTime(d.getTime() + Time ? Time : 365 * 24 * 3600 * 1000);
        o.expires = d.toUTCString();
        o.save(UserData.DataFile);
    }
}
UserData.getValue = function (Name) {
    if (!UserData.Object) {
        if (!UserData.init()) return;
    }
    if (UserData.Object) {
        var o = UserData.Object;
        o.load(UserData.DataFile);
        return o.getAttribute(Name) ? unescape(o.getAttribute(Name)) : null;
    }
}
UserData.removeValue = function (Name) {
    //debugger;
    UserData.setValue(Name, null);
    return;
    if (!UserData.Object) {
        if (!UserData.init()) return;
    }
    if (UserData.Object) {
        var o = UserData.Object;
        o.load(UserData.DataFile);
        d.setTime(d.getTime() - 1000);
        o.expires = d.toUTCString();
        o.save(UserData.DataFile);
    }
}

String.prototype.Trim = function () {
    return this.replace(/(^\s*)|(\s*$)/g, "");
}
String.prototype.LTrim = function () {
    return this.replace(/(^\s*)/g, "");
}
String.prototype.RTrim = function () {
    return this.replace(/(\s*$)/g, "");
}

String.prototype.isMobile = function () {
    var p = /^0*(13|15|17|18)\d{9}$/;
    return p.test(this)
}

Date.prototype.Format = function (format) {
    var o = {
        "M+": this.getMonth() + 1, //month 
        "d+": this.getDate(), //day 
        "h+": this.getHours(), //hour 
        "m+": this.getMinutes(), //minute 
        "s+": this.getSeconds(), //second 
        "q+": Math.floor((this.getMonth() + 3) / 3), //quarter 
        "S": this.getMilliseconds() //millisecond 
    }

    if (/(y+)/.test(format)) {
        format = format.replace(RegExp.$1, (this.getFullYear() + "").substr(4 - RegExp.$1.length));
    }

    for (var k in o) {
        if (new RegExp("(" + k + ")").test(format)) {
            format = format.replace(RegExp.$1, RegExp.$1.length == 1 ? o[k] : ("00" + o[k]).substr(("" + o[k]).length));
        }
    }
    return format;
}


function isIdCardNo(num) {
    var result = "";
    num = num.toUpperCase();
    //身份证号码为15位或者18位，15位时全为数字，18位前17位为数字，最后一位是校验位，可能为数字或字符X。
    var myReg15 = /^(\/d{15})|(\/d{17}([0-9]|X))$/;
    if (!(myReg15.test(num))) {
        result = '输入的身份证号格式不正确！';
    }
    //校验位按照ISO 7064:1983.MOD 11-2的规定生成，X可以认为是数字10。 
    //下面分别分析出生日期和校验位 
    var len, re;
    len = num.length;
    if (len == 15) {
        re = new RegExp(/^(\/d{6})(\/d{2})(\/d{2})(\/d{2})(\/d{3})$/);
        var arrSplit = num.match(re);

        //检查生日日期是否正确 
        var dtmBirth = new Date('19' + arrSplit[2] + '/' + arrSplit[3] + '/' + arrSplit[4]);
        var bGoodDay;
        bGoodDay = (dtmBirth.getYear() == Number(arrSplit[2])) && ((dtmBirth.getMonth() + 1) == Number(arrSplit[3])) && (dtmBirth.getDate() == Number(arrSplit[4]));
        if (!bGoodDay) {
            result = '输入的身份证号里出生日期不对！';
        }
        else {
            //将15位身份证转成18位 
            //校验位按照ISO 7064:1983.MOD 11-2的规定生成，X可以认为是数字10。 
            var arrInt = new Array(7, 9, 10, 5, 8, 4, 2, 1, 6, 3, 7, 9, 10, 5, 8, 4, 2);
            var arrCh = new Array('1', '0', 'X', '9', '8', '7', '6', '5', '4', '3', '2');
            var nTemp = 0, i;
            num = num.substr(0, 6) + '19' + num.substr(6, num.length - 6);
            for (i = 0; i < 17; i++) {
                nTemp += num.substr(i, 1) * arrInt[i];
            }
            num += arrCh[nTemp % 11];
            result = "";
        }
    }
    if (len == 18) {
        //re = new RegExp(/^(\/d{6})(\/d{4})(\/d{2})(\/d{2})(\/d{3})([0-9]|X)$/);
        re = new RegExp(/^(\d{6})(\d{4})(\d{2})(\d{2})(\d{3})([0-9]|X)$/);
        var arrSplit = num.match(re);

        //检查生日日期是否正确 
        var dtmBirth = new Date(arrSplit[2] + "/" + arrSplit[3] + "/" + arrSplit[4]);
        var bGoodDay;
        bGoodDay = (dtmBirth.getFullYear() == Number(arrSplit[2])) && ((dtmBirth.getMonth() + 1) == Number(arrSplit[3])) && (dtmBirth.getDate() == Number(arrSplit[4]));
        if (!bGoodDay) {
            //alert(dtmBirth.getYear());
            //alert(arrSplit[2]);
            result = '输入的身份证号里出生日期不对！';
        }
        else {
            //检验18位身份证的校验码是否正确。 
            //校验位按照ISO 7064:1983.MOD 11-2的规定生成，X可以认为是数字10。 
            var valnum;
            var arrInt = new Array(7, 9, 10, 5, 8, 4, 2, 1, 6, 3, 7, 9, 10, 5, 8, 4, 2);
            var arrCh = new Array('1', '0', 'X', '9', '8', '7', '6', '5', '4', '3', '2');
            var nTemp = 0, i;
            for (i = 0; i < 17; i++) {
                nTemp += num.substr(i, 1) * arrInt[i];
            }
            valnum = arrCh[nTemp % 11];
            if (valnum != num.substr(17, 1)) {
                //result = '18位身份证的校验码不正确！应该为：' + valnum;
                result = '输入的身份证号格式不正确';
            }
            else
                result = '';
        }
    }
    return result;
}