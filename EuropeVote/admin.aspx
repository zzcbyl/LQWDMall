<%@ Page Title="" Language="C#" MasterPageFile="~/EuropeVote/EuropeMaster.master" %>

<script runat="server">
    private string[] nameList = { "张诚" };
    protected void Page_Load(object sender, EventArgs e)
    {
        if (Request.Cookies["openid"] != null && Request.Cookies["username"] != null)
        {
            string openid = Server.UrlDecode(Request.Cookies["openid"].Value);
            string username = Server.UrlDecode(Request.Cookies["username"].Value);

            if (!nameList.ToList().Contains(username))
            {
                this.errorInfo.InnerText = "您没有参数资格";
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
    }
</script>

<asp:Content ID="Content1" ContentPlaceHolderID="head" Runat="Server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" Runat="Server">
<form runat="server">
<div class="d-admin form-inline">
    <div class="form-group">
        <lable>姓名：</lable>
        <input id="username" type="text" class="form-control" placeholder="请输入姓名" />　
        <button class="btn btn-default" onclick="BtnSubmit();">确定</button>
    </div>
    <div class="form-group">
        <span id="errorInfo" runat="server" class="red"></span>
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
        if (username != null && username != '' && $('#<%=errorInfo.ClientID %>').html() == '' ) {
            location.href = 'Upload.aspx?openid=' + QueryString('openid');
        }
    });

    function BtnSubmit() {
        var openid = QueryString('openid');
        var username = $('#username').val();

        if (username.Trim() == '') {
            $('#<%=errorInfo.ClientID %>').html("姓名不能为空");
            return;
        }

        setCookie('openid', openid);
        setCookie('username', username);

        document.forms[0].submit();
    }

</script>
</asp:Content>

