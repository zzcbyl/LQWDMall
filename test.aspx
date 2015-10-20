<%@ Page Language="C#" %>
<%@ Import Namespace="System.Net.Mail" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">

<script runat="server">

    protected void Button1_Click(object sender, EventArgs e)
    {

    }
</script>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title></title>
</head>
<body>
    <form id="form1" runat="server">
    <div>
        <asp:Button ID="Button1" runat="server" Text="发送" onclick="Button1_Click" />
        <div style="padding:20px;">
            <div>您好，欢迎您参加知心姐姐假日营！</div>
            <div style="margin-top:10px;">有任何关于假日营的问题，请联系：18601016361 新老师</div>
            <div style="margin-top:10px;">请按如下要求认真填写报名表：</div>
            <div style="margin-left:20px; color:Red;">
                <div>1. 请家长朋友尽可能详尽地填写报名表，这张表是老师们了解孩子的一个重要窗口；</div>
                <div>2. 填写好请以孩子姓名命名，并报名表请发送到xly@luqinwenda.com；</div>
                <div>3. 请家长把孩子的身份证或户口本页拍一张照片附在报名表里，便于后勤老师为孩子购买有效保险；</div>
            </div>
        </div>
    </div>
    </form>
    
</body>
</html>
