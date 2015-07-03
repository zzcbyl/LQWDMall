<%@ Page Title="" Language="C#" MasterPageFile="~/EuropeVote/EuropeMaster.master" %>
<%@ Import Namespace="System.IO" %>
<%@ Import Namespace="System.Drawing" %>
<%@ Import Namespace="System.Drawing.Drawing2D" %>
<script runat="server">
    protected void Page_Load(object sender, EventArgs e)
    {
        HttpFileCollection files = Request.Files;
        if (files.Count > 0)
        {
            string openid = Request.Form["openid"];
            string username = Request.Form["username"];
            if (!EuropeVote.checkName(openid, username))
            {
                this.errorInfo.InnerText = "您的姓名和微信不符";
                return;
            }
            
            if (!EuropeVote.checkUpload(openid, username, DateTime.Now))
            {
                HttpPostedFile file = files[0];
                string uploadPath = HttpContext.Current.Server.MapPath("upload") + "\\";
                if (!Directory.Exists(uploadPath))
                {
                    Directory.CreateDirectory(uploadPath);
                }
                int extStart = file.FileName.LastIndexOf(".");
                string ext = file.FileName.Substring(extStart);
                Guid g = Guid.NewGuid();
                string FileName = g.ToString().Substring(0, 10) + DateTime.Now.ToString("yyyyMMdd") + ext;
                file.SaveAs(uploadPath + FileName);
                string ThumFileName = g.ToString().Substring(0, 10) + DateTime.Now.ToString("yyyyMMdd") + "_thum" + ext;
                Util.CreateImageOutput(500, 500, uploadPath + FileName, uploadPath + ThumFileName);

                int result = EuropeVote.Upload(openid, username, ThumFileName, DateTime.Now);

                if (result > 0)
                    this.errorInfo.InnerText = "上传成功";
                else
                    this.errorInfo.InnerText = "上传失败";
            }
            else
            {
                this.errorInfo.InnerText = "今天的照片已经上传";
            }
        }
    }
</script>

<asp:Content ID="Content1" ContentPlaceHolderID="head" Runat="Server">
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<style type="text/css">
    #preview{width:260px;height:190px;border:1px solid #ccc;overflow:hidden; margin:0 auto; text-align:center;}
    #imghead {filter:progid:DXImageTransform.Microsoft.AlphaImageLoader(sizingMethod=image);}
    .comment_people li { border:none; padding:0 10px;}
    .CheckItem, .comment_people, .VoteItem { padding-bottom:0;}
</style>
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" Runat="Server">
<div style="margin-top:10px; background:#fff; padding:20px 0;">
    <form runat="server" method="post" encType="multipart/form-data">
        <div id="preview">
            <img id="imghead" width="100%" height="100%" border="0" src="images/noimage.jpg">
        </div>
        <div id="uploadDiv" style="margin-top:10px; text-align:center;">
            <input id="uploadFile" name="uploadFile" type="file" onchange="previewImage(this)" style="border:none; width:150px;" />     
        </div> 
        <div id="delDiv" style="margin-top:10px; text-align:center; display:none;">
            <input type="button" value="重新选择" style="padding:3px 8px;" onclick="reUpload();" />　　
            <input type="submit" value="上传" style="padding:3px 8px;" />
        </div>
        <div style="margin-top:20px; text-align:center;">
            <span id="errorInfo" runat="server" style="color:Red;"></span>
        </div>
        <input type="hidden" id="openid" name="openid" value="" />
        <input type="hidden" id="username" name="username" value="" />
    </form>
</div>
<div class="comment_people">
    <h5>已上传照片</h5>
    <ul id="VoteItem" class="VoteItem">
            
    </ul>
    <div class="clear"></div>
</div>
<div id="divLoading" onclick="LoadNextData();">点击加载下一页</div>
<script type="text/javascript">
    var imgcurrentpage = 1;
    var imgpagesize = 10;
    var username = '';
    var openid = '';
    $(document).ready(function () {
        if (QueryString('openid') == null || QueryString('openid') == "") {
            var encodeDomain = encodeURIComponent(document.URL);
            location.href = "http://weixin.luqinwenda.com/authorize_0603.aspx?callback=" + encodeDomain;
            return;
        }
        openid = QueryString('openid');
        $('#openid').val(openid);

        username = getCookie('username');
        if (username == null || username == '') {
            location.href = 'admin.aspx?openid=' + QueryString('openid');
        }
        else
            $('#username').val(username);

        LoadData();
    });

    function LoadData() {
        if (username == '' || openid == '') {
            return;
        }
        $('#VoteItem').html($('#VoteItem').html() + '<li class="loading" style="width:100%;"><img style="width:50px; height:50px; border:none;" src="http://mall.luqinwenda.com/images/loading.gif" /><br />加载中...</li><div class="clear"></div>');
        $.ajax({
            type: 'post',
            url: 'VoteHandler.ashx',
            data: { item: 4, openid: openid, username: username, currentPage: imgcurrentpage, pageSize: imgpagesize },
            success: function (data, textStatus) {
                data = data.replace(/\n/g, '');
                var json = eval("(" + data + ")");
                var html = "";
                for (var i = 0; i < json.data.length; i++) {
                    var imgName = json.data[i].image_url.replace('_thum.', '|')
                    html += '<li><a href="ShowImage.aspx?name=' + imgName + '"><img id="image_' + json.data[i].image_id + '" src="http://192.168.1.133:8001/EuropeVote/upload/' + json.data[i].image_url + '" /></a><div id="item' + json.data[i].image_id + '" class="CheckItem"><label><span>' + json.data[i].image_username + ' </span><img style="width:30px; border:none; margin-bottom:5px;" src="images/zantongicon.jpg"><span class="VotesCount"> <em>' + json.data[i].image_count + '</em> 人</span></label></div></li>';
                }
                $(".loading").remove();
                //alert($('#VoteItem').html());
                if (html != "") {
                    $('#VoteItem').html($('#VoteItem').html() + html + '<div class="clear"></div>');
                    imgcurrentpage++;
                }
                else if ($('#VoteItem li').length <= 0)
                    $('#VoteItem').html('<li class="loading" style="width:100%;">暂无照片</li><div class="clear"></div>');

                if (json.data.length < imgpagesize)
                    $("#divLoading").hide();
                else
                    $("#divLoading").show();

            }
        });
    }

    function LoadNextData() {
        LoadData();
    }


    //照片上传预览    IE是用了滤镜。
    function previewImage(file) {
        if (!checkFile(file)) {
            reUpload();
            return;
        }
        var MAXWIDTH = 260;
        var MAXHEIGHT = 180;
        var div = document.getElementById('preview');
        if (file.files && file.files[0]) {
            div.innerHTML = '<img id=imghead>';
            var img = document.getElementById('imghead');
            img.onload = function () {
                var rect = clacImgZoomParam(MAXWIDTH, MAXHEIGHT, img.offsetWidth, img.offsetHeight);
                img.width = rect.width;
                img.height = rect.height;
                img.style.marginTop = rect.top + 'px';
            }
            var reader = new FileReader();
            reader.onload = function (evt) { img.src = evt.target.result; }
            reader.readAsDataURL(file.files[0]);
        }
        else //兼容IE
        {
            var sFilter = 'filter:progid:DXImageTransform.Microsoft.AlphaImageLoader(sizingMethod=scale,src="';
            file.select();
            var src = document.selection.createRange().text;
            div.innerHTML = '<img id=imghead>';
            var img = document.getElementById('imghead');
            img.filters.item('DXImageTransform.Microsoft.AlphaImageLoader').src = src;
            var rect = clacImgZoomParam(MAXWIDTH, MAXHEIGHT, img.offsetWidth, img.offsetHeight);
            status = ('rect:' + rect.top + ',' + rect.left + ',' + rect.width + ',' + rect.height);
            div.innerHTML = "<div id=divhead style='width:" + rect.width + "px;height:" + rect.height + "px;margin-top:" + rect.top + "px;" + sFilter + src + "\"'></div>";
        }
        $('#uploadDiv').hide();
        $('#delDiv').show();
    }
    function clacImgZoomParam(maxWidth, maxHeight, width, height) {
        var param = { top: 0, left: 0, width: width, height: height };
        if (width > maxWidth || height > maxHeight) {
            rateWidth = width / maxWidth;
            rateHeight = height / maxHeight;

            if (rateWidth > rateHeight) {
                param.width = maxWidth;
                param.height = Math.round(height / rateWidth);
            } else {
                param.width = Math.round(width / rateHeight);
                param.height = maxHeight;
            }
        }

        param.left = Math.round((maxWidth - param.width) / 2);
        param.top = Math.round((maxHeight - param.height) / 2);
        return param;
    }

    //文件检测
    function checkFile(file) {
        var filepath = $(file).val();
        var extStart = filepath.lastIndexOf(".");
        var ext = filepath.substring(extStart, filepath.length).toUpperCase();
        if (ext != ".PNG" && ext != ".GIF" && ext != ".JPG") {
            alert("照片限于png,gif,jpg格式");
            return false;
        }
        var file_size = 0;
        if (file.files && file.files[0]) {
            file_size = file.files[0].size;
            var size = file_size;
            if (size > 5 * 1024 * 1024) {
                alert("上传的照片大小不能超过5M。");
                return false;
            }
        } else {
            var img = new Image();
            img.src = filepath;
            if (img.fileSize > 0) {
                if (img.fileSize > 5 * 1024) {
                    alert("上传的照片大小不能超过5M。");
                    return false;
                }
            }
        }
        return true;
    }

    function reUpload() {
        var file = $('#uploadFile');
        file.after(file.clone().val(""));
        file.remove();
        $('#uploadDiv').show();
        $('#delDiv').hide();
        $('#imghead').css({ "width": "100%", "height": "100%" });
        $('#imghead').attr("src", "images/noimage.jpg");
    }
</script>
</asp:Content>

