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