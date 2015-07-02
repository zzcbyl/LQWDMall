<%@ Page Title="" Language="C#" MasterPageFile="~/EuropeVote/EuropeMaster.master" %>

<script runat="server">
    public DateTime startDt = Convert.ToDateTime("2015-07-2");
    public DateTime endDt = Convert.ToDateTime("2015-06-25");
</script>

<asp:Content ID="Content1" ContentPlaceHolderID="head" Runat="Server">
    <style type="text/css">
        .loading { margin:0 auto; padding:30px 0; text-align:center; background:#fff; color:#999; line-height:30px; font-size:14px;}
    </style>
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" Runat="Server">
    <div class="navBar">
        <div><a href="Rule.aspx">活动规则</a></div>
        <div><a href="Ranking.aspx">排行榜</a></div>
        <%--<div><a href="Upload.aspx">上传照片</a></div>--%>
    </div>
    <div class="navMenu">
        <div class="leftPrev" onclick="LeftNav();">&lt;</div>
        <div class="showMenu">
            <ul id="DateNav" class="navDate">
            <%for (DateTime i = startDt; i >= endDt; i = i.AddDays(-1))
              { %>
                <li onclick="ChangeDate('<%=i.ToString("yyyy-MM-dd")%>',this);"><%=i.ToString("M月dd日")%></li>
            <% } %>
            </ul>
        </div>
        <div class="rightNext" onclick="RightNav();">&gt;</div>
        <div class="clear"></div>
    </div>
    <ul id="VoteItem" class="VoteItem">
        
    </ul>
    <div id="divLoading" onclick="LoadNextData();">点击加载下一页</div>
    <div class="comment_people">
        <h5>看看大家怎么说</h5>
        <ul id="commentlist">
                
        </ul>
        <div id="pageDiv" style="text-align:center; margin-top:10px;">
            <button class="btn btn-danger" onclick="prevPage();">上一页</button>　
            <button class="btn btn-danger" onclick="nextPage();">下一页</button>
        </div>
    </div>
    <div style="height:20px;"></div>

    <div id="popoverVote" class="theme-popover" style="width:300px;">
         <div class="theme-poptit">
              <a href="javascript:;" title="关闭" class="close">×</a>
              <h5>投票</h5>
         </div>
         <div class="theme-popbod dform">
             <p><textarea id="memo" name="memo" maxlength="500" style="width:90%; padding:5px; height:80px; line-height:20px;" placeholder="（选填）请留下您宝贵的意见。"></textarea></p>
             <p style="margin-top:20px;><button type="button" class="btn btn-danger" onclick="submitVote();" style="font-size:16px; padding:8px 15px;">提交</button></p>
         </div>
    </div>
    <div class="theme-popover-mask"></div>
    <script type="text/javascript">
        var shareTitle = "北欧游学之旅"; //标题
        var imgUrl = "http://mall.luqinwenda.com/dressvote/images/vote_share_icon.jpg"; //照片
        var descContent = "快来为北欧游学之旅，参与有惊喜！"; //简介
        var lineLink = "http://mall.luqinwenda.com/EuropeVote/Default.aspx"; //链接
        var checkItemid = 0;
        var checkName = '';
        var openid = '';
        var currentpage = 1;
        var pagesize = 20;
        var imgcurrentpage = 1;
        var imgpagesize = 10;
        var currentDate;
        var currentObj;
        $(document).ready(function () {
            if (QueryString('openid') == null || QueryString('openid') == "") {
                var encodeDomain = encodeURIComponent(document.URL);
                location.href = "http://weixin.luqinwenda.com/authorize_0603.aspx?callback=" + encodeDomain;
            }
            openid = QueryString('openid');

            LoadData('<%=startDt %>', $("#DateNav li").eq(0));

            bindVoteList();

            $('.theme-poptit .close').click(function () {
                closeVoteItem();
            })

        });

        function voteItem(obj) {
            for (var i = 0; i < $('#VoteItem li').length; i++) {
                $('#VoteItem li').eq(i).find('img').eq(0).css({ "border": "1px solid #ccc" });
            }

            checkItemid = $(obj).attr("id").replace("item", "");
            checkName = $(obj).find('span').eq(0).html();
            $('#image_' + checkItemid).css({ "border": "1px solid #ff0000" });
            $('#memo').val("");
            $('.theme-popover-mask').fadeIn(100);
            $('#popoverVote').slideDown(200);
        }

        function closeVoteItem() {
            $('.theme-popover-mask').fadeOut(100);
            $('#popoverVote').slideUp(200);
        }

        var m = 0;
        function RightNav() {
            m += 1;
            if (m <= $("#DateNav li").length - 4)
                MoveNav();
            else
                m -= 1;
        }
        function LeftNav() {
            m -= 1;
            if (m >= 0)
                MoveNav();
            else
                m += 1;
        }
        function MoveNav() {
            var leftwidth = $(".leftPrev").eq(0).css("width").replace('px', '');
            var liwidth = $("#DateNav li").eq(0).css("width").replace('px', '');
            var movewidth = 0 - (parseInt(liwidth) * m) + parseInt(leftwidth);
            $("#DateNav").animate({ left: movewidth + 'px', opacity: 1 }, 800, function () { });
        }

        function ChangeDate(d, obj) {
            imgcurrentpage = 1;
            $('#VoteItem').html("");
            LoadData(d, obj);
        }

        function LoadNextData() {
            LoadData(currentDate, currentObj);
        }

        function LoadData(d, o) {
            currentDate = d;
            currentObj = o;
            $("#DateNav li").each(function () {
                $(this).removeAttr("class");
            });
            $(o).attr("class", "selectCurrent");
            $('#VoteItem').html($('#VoteItem').html() + '<li class="loading" style="width:100%;"><img style="width:50px; height:50px; border:none;" src="http://mall.luqinwenda.com/images/loading.gif" /><br />加载中...</li><div class="clear"></div>');
            $.ajax({
                type: 'post',
                url: 'VoteHandler.ashx',
                data: { item: 1, date: d, currentPage: imgcurrentpage, pageSize: imgpagesize },
                success: function (data, textStatus) {
                    data = data.replace(/\n/g, '');
                    var json = eval("(" + data + ")");
                    var html = "";
                    for (var i = 0; i < json.data.length; i++) {
                        var imgName = json.data[i].image_url.replace('_thum.', '|')
                        html += '<li><a href="ShowImage.aspx?name=' + imgName + '"><img id="image_' + json.data[i].image_id + '" src="http://192.168.1.133:8001/EuropeVote/upload/' + json.data[i].image_url + '" /></a><div id="item' + json.data[i].image_id + '" class="CheckItem" onclick="voteItem(this);"><label><span>' + json.data[i].image_username + ' </span><img style="width:30px; border:none; margin-bottom:5px;" src="images/zantongicon.jpg"><span class="VotesCount"> <em>' + json.data[i].image_count + '</em> 人</span></label></div></li>';
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
        function submitVote() {
            if (checkItemid > 0) {
                $.ajax({
                    type: 'post',
                    url: 'VoteHandler.ashx',
                    data: { item: 2, openid: openid, imageid: checkItemid, imageName: checkName, remark: $('#memo').val() },
                    success: function (data, textStatus) {
                        if (data != null && parseInt(data) > 0) {
                            index = 1;
                            if (parseInt(data) == 1) {
                                $("#item" + checkItemid).find('em').eq(0).html(parseInt($("#item" + checkItemid).find('em').eq(0).html()) + 1);
                                alert('投票成功');
                                bindVoteList();
                            }
                            else if (parseInt(data) == 2) {
                                alert('您今天的投票次数已用完');
                            }
                            else if (parseInt(data) == 3) {
                                alert('这张照片您今天已经投过票了');
                            }
                        }
                        else
                            alert('投票失败，请您刷新之后重试');

                        closeVoteItem();
                        checkItemid = 0;
                        checkName = "";
                    }
                });
            }
            else {
                alert("请选择你喜欢的照片");
            }
        }

        function bindVoteList() {
            $('#commentlist').html('<li class="loading"><img src="http://mall.luqinwenda.com/images/loading.gif" /><br />加载中...</li>');
            $.ajax({
                type: 'post',
                url: 'VoteHandler.ashx',
                data: { item: 3, currentPage: currentpage, pageSize: pagesize },
                success: function (data, textStatus) {
                    data = data.replace(/\n/g, '');
                    var json = eval("(" + data + ")");
                    var html = "";
                    for (var i = 0; i < json.data.length; i++) {
                        if (json.data[i].vote_name != "匿名网友")
                            if (json.data[i].vote_name.length < 4)
                                json.data[i].vote_name = json.data[i].vote_name + "**";
                            else
                                json.data[i].vote_name = json.data[i].vote_name.substring(0, 3) + "**";
                        html += '<li><div style="line-height:22px;"><p class="comment_name">' + json.data[i].vote_name + '</p><p class="comment_time">' + json.data[i].vote_crt + '</p><p class="comment_item">' + json.data[i].clothing_name + '</p><div style="clear:both;"></div></div><div class="comment_content">' + json.data[i].vote_remark + '</div></li>';
                    }
                    $('#commentlist').html(html);

                    if (currentpage == 1 && json.data.length < pagesize) {
                        $('#pageDiv').hide();
                    }
                    else
                        $('#pageDiv').show();

                    if ($('#commentlist').html() == "") {
                        currentpage--;
                        bindVoteList();
                    }
                }
            });
        }

        function prevPage() {
            currentpage -= 1;
            if (currentpage <= 0) {
                currentpage = 1;
            }
            bindVoteList();
        }
        function nextPage() {
            currentpage += 1;
            bindVoteList();
        }

    </script>

</asp:Content>

