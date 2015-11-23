<%@ Page Language="C#" %>
<%@ Import Namespace="System.Data" %>
<%@ Import Namespace="System.Web.Script.Serialization" %>
<script runat="server">

    protected void Page_Load(object sender, EventArgs e)
    {

        Response.Write(GetMaxOrderIdFromDonateList().ToString());
        int maxOrderId = GetMaxOrderIdFromDonateList();
        InsertOrders(maxOrderId);
        
    }

    public void InsertOrders(int maxOrderId)
    {
        string jsonStr = Util.GetWebContent("http://mall.luqinwenda.com/api/product_get_sales_record.aspx?productid=5", "get", "", "html/json");
        JavaScriptSerializer serializer = new JavaScriptSerializer();
        Dictionary<string, object> jsonOrdersCollection = (Dictionary<string, object>)serializer.DeserializeObject(jsonStr);
        object ordersObject;
        jsonOrdersCollection.TryGetValue("orders", out ordersObject);
        object[] orderArr = (object[])ordersObject;
        for (int i = 0; i < orderArr.Length; i++)
        {
            object orderId;
            Dictionary<string, object> orderDict = (Dictionary<string, object>)orderArr[i];
            orderDict.TryGetValue("oid", out orderId);
            if ((int)orderId > maxOrderId)
            {
                try
                {
                    object userId;
                    orderDict.TryGetValue("uid", out userId);
                    Users user = new Users((int)userId);
                    string userInfoJSONStr = GetUserinfoJSONStringByOpenId(user._fields["uname"].ToString().Trim());
                    
                    object nick;
                    object headImageUrl;
                    object orderDate;
                    object cell;
                    //object orderId;
                    
                    try
                    {
                        Dictionary<string, object> userInfoJson = (Dictionary<string, object>)serializer.DeserializeObject(userInfoJSONStr);
                        userInfoJson.TryGetValue("nickname", out nick);
                        userInfoJson.TryGetValue("headimageurl", out headImageUrl);
                        cell = (object)"";
                    }
                    catch
                    {
                        orderDict.TryGetValue("name", out nick);
                        orderDict.TryGetValue("cell", out cell);
                        headImageUrl = (object)"";
                    }
                    if (nick.ToString().Equals(""))
                        orderDict.TryGetValue("name", out nick);
                    
                    orderDict.TryGetValue("ctime1", out orderDate);
                    InsertIntoList(nick.ToString(), headImageUrl.ToString(), cell.ToString(), "buy", (int)orderId, (DateTime)orderDate);
                }
                catch
                { 
                
                }
            }
            else
            {
                break;
            }
        }
    }

    public string GetUserinfoJSONStringByOpenId(string openId)
    {
        
        return "";
    }
    
    public void InsertIntoList(string nick, string headImage, string cell, string type, int orderId, DateTime date)
    {
        KeyValuePair<string, KeyValuePair<SqlDbType, object>>[] insertParameterArray
            = new KeyValuePair<string, KeyValuePair<SqlDbType, object>>[6];
        insertParameterArray[0] = new KeyValuePair<string, KeyValuePair<SqlDbType, object>>("type",
            new KeyValuePair<SqlDbType, object>(SqlDbType.VarChar, (object)"buy"));
        insertParameterArray[0] = new KeyValuePair<string, KeyValuePair<SqlDbType, object>>("order_id",
            new KeyValuePair<SqlDbType, object>(SqlDbType.Int, (object)orderId));
        insertParameterArray[0] = new KeyValuePair<string, KeyValuePair<SqlDbType, object>>("weixin_nick",
            new KeyValuePair<SqlDbType, object>(SqlDbType.VarChar, (object)nick));
        insertParameterArray[0] = new KeyValuePair<string, KeyValuePair<SqlDbType, object>>("weixin_head_image",
            new KeyValuePair<SqlDbType, object>(SqlDbType.VarChar, (object)headImage));
        insertParameterArray[0] = new KeyValuePair<string, KeyValuePair<SqlDbType, object>>("cell",
            new KeyValuePair<SqlDbType, object>(SqlDbType.VarChar, (object)cell));
        insertParameterArray[0] = new KeyValuePair<string, KeyValuePair<SqlDbType, object>>("create_time",
            new KeyValuePair<SqlDbType, object>(SqlDbType.DateTime, (object)date));
        DBHelper.InsertData("donate_list", insertParameterArray, Util.ConnectionString);
    }
    
    public int GetMaxOrderIdFromDonateList()
    {
        DataTable dt = DBHelper.GetDataTable("select max(order_id) from donate_list where type = 'buy' ", Util.ConnectionString);
        int maxId = 0;
        if (dt.Rows.Count > 0)
        {
            try
            {
                maxId = int.Parse(dt.Rows[0][0].ToString());
            }
            catch
            { 
            
            }
        }
        return maxId;
    }
    
    
    
</script>