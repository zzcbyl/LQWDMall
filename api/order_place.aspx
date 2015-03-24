<%@ Page Language="C#" %>
<script runat="server">

    protected void Page_Load(object sender, EventArgs e)
    {
        string token = ((Request["token"] == null) ? "ca72da43b4a6abc65713f4fff4728753c4df3d1765fb3b299837361aa64a47b15d3138ab" : Request["token"].Trim());
        string[] productIdStrArr = new string[]{"4","5"};
        string[] countIdStrArr = new string[] {"2","1"};

        string name = ((Request["name"] == null) ? "aaa" : Request["name"].Trim());
        string cell = ((Request["cell"] == null) ? "13501177897" : Request["cell"].Trim());
        string province = ((Request["province"] == null) ? "北京市" : Request["province"].Trim());
        string city = ((Request["city"] == null) ? "东城区" : Request["city"].Trim());
        string address = ((Request["address"] == null) ? "金狮子胡同" : Request["address"].Trim());
        string zip = ((Request["zip"] == null) ? "100007" : Request["zip"].Trim());
        
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