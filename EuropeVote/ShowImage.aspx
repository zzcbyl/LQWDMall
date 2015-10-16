<%@ Page Language="C#" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">

<script runat="server">

</script>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title></title>
    <script src="../script/jquery-2.0.1.min.js" type="text/javascript"></script>
    <script src="../script/common.js" type="text/javascript"></script>
    <script type="text/javascript">
        $(document).ready(function () {
            $('#showImg').attr('src', 'upload/' + QueryString('name').replace('|', '.'));
        });
    </script>
</head>
<body>
    <form id="form1" runat="server">
    <div>
        <div style="position:absolute; top:20px; right:20px; z-index:999;">
            <a href="javascript:history.go(-1);"><img src="images/returnicon.png" width="120px" /></a>
        </div>
        <div class="">
            <img id="showImg" style="max-width:100%;" />
        </div>
    </div>
    </form>
</body>
</html>
