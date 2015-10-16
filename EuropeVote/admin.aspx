<%@ Page Title="" Language="C#" MasterPageFile="~/EuropeVote/EuropeMaster.master" %>

<script runat="server">
    private string[] nameList = { "张三", "陈一喆", "姜欣怡", "周家宇", "周航羽", "任凤仪", "邱露微", "覃昱淞", "张博涵", "王昱晖", "朱灏", "姜美竹", "李杨", "曹安琪", "刘一泽", "陈巍午", "刘赫", "赵家正", "段思羽", "梁子正", "张心烨", "张峻滔", "金佳怡", "孙雅兰", "赵岱妮", "薛骏", "陈子彬", "袁千涵", "徐俊屹", "林李涵", "巫诗荻", "黄思霖","赵茁涵","李尚" };
    protected void Page_Load(object sender, EventArgs e)
    {
        if (this.hidSubmit.Value == "1")
        {
            if (Request.Cookies["username"] == null || Request.Cookies["username"].Value == "")
            {
                this.errorInfo.InnerText = "姓名不能为空";
                return;
            }

            if (Request.Cookies["openid"] != null && Request.Cookies["username"] != null)
            {
                string openid = Server.UrlDecode(Request.Cookies["openid"].Value);
                string username = Server.UrlDecode(Request.Cookies["username"].Value);

                if (!nameList.ToList().Contains(username))
                {
                    this.errorInfo.InnerText = "您没有参赛资格";
                    return;
                }

                if (openid != string.Empty && username != string.Empty)
                {
                    if (!EuropeVote.checkName(openid, username))
                    {
                        this.errorInfo.InnerText = "您的姓名和微信不符";
                        return;
                    }
                    else
                    {
                        this.Response.Redirect("Upload.aspx?openid=" + openid);
                    }
                }
            }
            this.hidSubmit.Value = "";
        }
    }
</script>

<asp:Content ID="Content1" ContentPlaceHolderID="head" Runat="Server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" Runat="Server">
<form id="Form1" runat="server">
<div class="d-admin form-inline">
    <div class="form-group">
        <lable>姓名：</lable>
        <input id="username" type="text" class="form-control" placeholder="请输入姓名" />　
        <input type="hidden" id="hidSubmit" runat="server" value="" />
        <button class="btn btn-default" onclick="BtnSubmit();">确定</button>
    </div>
    <div class="form-group">
        <span id="errorInfo" runat="server" class="red"></span>
    </div>
    <div style="margin-top:5px; background:#fff; line-height:35px; padding:10px 20px 20px;">
        <h4 style="border-bottom: 1px solid #6699CC; padding:10px 0 5px; margin-bottom:10px;">活动规则</h4>
        <div style="line-height:25px; text-indent:28px;">1、用手机进行拍摄。</div>
        <div style="line-height:25px; text-indent:28px;">2、每人每天只能上传一张照片到活动页面，且照片不可修改。</div>
        <div style="line-height:25px; text-indent:28px;">3、照片要带有与夏令营有关的元素，比如队旗，营服，夏令营活动等。</div>
        <div style="line-height:25px; text-indent:28px;">4、活动时间为：8月6日——8月17日。</div>
        <br />
        <br />
    </div>
</div>
</form>
<script type="text/javascript">
    $(document).ready(function () {
        if (QueryString('openid') == null || QueryString('openid') == "") {
            var encodeDomain = encodeURIComponent(document.URL);
            location.href = "http://weixin.luqinwenda.com/authorize_0603.aspx?callback=" + encodeDomain;
            return;
        }

        var username = getCookie('username');
        if (username != null && username != '' && $('#<%=errorInfo.ClientID %>').html() == '') {
            location.href = 'Upload.aspx?openid=' + QueryString('openid');
        }
    });

    function BtnSubmit() {
        var openid = QueryString('openid');
        var username = $('#username').val();
        $("#<%=hidSubmit.ClientID %>").val("1");

        setCookie('openid', openid);
        setCookie('username', username);

        document.forms[0].submit();
    }

</script>
</asp:Content>

