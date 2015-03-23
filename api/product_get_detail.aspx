<%@ Page Language="C#" %>
<script runat="server">

    protected void Page_Load(object sender, EventArgs e)
    {
        int productId = (Request["productid"] == null) ? 4 : int.Parse(Request["productid"].Trim());
        Product product = new Product(productId);
        Response.Write(product.GetJsonWithImages());
    }
</script>
