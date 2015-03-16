<%@ Page Language="C#" %>
<script runat="server">

    protected void Page_Load(object sender, EventArgs e)
    {
        int pageSize = 0;
        int currentPage = 0;
        
        

        pageSize = ((Request["pagesize"] == null) ? 0 : int.Parse(Request["pagesize"].Trim()));

        currentPage = ((Request["currentpage"] == null) ? 0 : int.Parse(Request["currentpage"].Trim()));

        if (pageSize == 0 && currentPage == 0)
        {
            Response.Write(Product.ConvertProductArrayToJson(Product.GetAllProduct()));
        }
        else
        {
            Response.Write(Product.ConvertProductArrayToJson(Product.GetAllProduct(), pageSize, currentPage));
        }
    }
</script>