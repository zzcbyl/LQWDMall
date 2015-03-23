<%@ Page Language="C#" %>
<script runat="server">

    protected void Page_Load(object sender, EventArgs e)
    {
        string token = ((Request["token"] == null) ? "" : Request["token"].Trim());
        string[] productIdStrArr = new string[]{};
        string[] countIdStrArr = new string[] { };

        string name = ((Request["name"] == null) ? "" : Request["name"].Trim());
        string cell = ((Request["cell"] == null) ? "" : Request["cell"].Trim());
        string province = ((Request["province"] == null) ? "" : Request["province"].Trim());
        string city = ((Request["city"] == null) ? "" : Request["city"].Trim());
        string address = ((Request["address"] == null) ? "" : Request["address"].Trim());
        string zip = ((Request["zip"] == null) ? "" : Request["zip"].Trim());
        
        if (Request["productid"] != null)
        {
            try
            {
                productIdStrArr = Request["productid"].Trim().Split(',');
            }
            catch
            { 
            
            }
        }
        if (Request["count"] != null)
        {
            try
            {
                countIdStrArr = Request["count"].Trim().Split(',');
            }
            catch
            { 
            
            }
        }

        int[] productIdArr = new int[productIdStrArr.Length];
        int[] countIdArr = new int[countIdStrArr.Length];
        for (int i = 0; i < productIdArr.Length; i++)
        {
            productIdArr[i] = int.Parse(productIdStrArr[i].Trim());
            countIdArr[i] = int.Parse(countIdStrArr[i].Trim());
        }
        int userId = Users.CheckToken(token);
        Cart cart = new Cart(userId);
        int orderId = cart.PlaceOrder(name, cell, province, city, address, zip, productIdArr, countIdArr);
        Response.Write("{\"status\": 0 , \"order_id\" : " + orderId.ToString() + " } ");
    }
</script>