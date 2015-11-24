<%@ Page Language="C#" %>
<%@ Import Namespace="System.Data" %>
<%@ Import Namespace="System.Web.Script.Serialization" %>
<%@ Import Namespace="System.Threading" %>
<script runat="server">

    public static void FillData()
    {
        int maxOrderId = GetMaxOrderIdFromDonateList();
        InsertOrders(maxOrderId);
    }

    protected void Page_Load(object sender, EventArgs e)
    {

        //Response.Write(GetMaxOrderIdFromDonateList().ToString());
        try
        {
            ThreadStart threadStart = new ThreadStart(FillData);
            
            
        }
        catch
        { 
        
        }

        DataTable dt = DBHelper.GetDataTable(" select * from donate_list order by create_time desc", Util.ConnectionString.Trim());
        DataTable dtResult = dt.Clone();

        int topNum = 3;

        DataRow[] drBuyArr = dt.Select(" type = 'buy' ");
        for (int i = 0; i < topNum && i < drBuyArr.Length ; i++)
        {
            DataRow drResult = dtResult.NewRow();
            foreach(DataColumn c in dtResult.Columns)
            {
                drResult[c] = drBuyArr[i][c.Caption];
                
            }
            dtResult.Rows.Add(drResult);
            dt.Rows.Remove(drBuyArr[i]);
        }

        foreach (DataRow dr in dt.Rows)
        {
            DataRow drResult = dtResult.NewRow();
            foreach (DataColumn c in dtResult.Columns)
            {
                drResult[c] = dr[c.Caption];
                //dt.Rows.Remove(drBuyArr[i]);
            }
            dtResult.Rows.Add(drResult);
        }

        string jsonRecordCollection = "";
        foreach (DataRow dr in dtResult.Rows)
        {
            string jsonPerRecord = "";
            foreach (DataColumn c in dtResult.Columns)
            {
                jsonPerRecord = jsonPerRecord + " , \"" + c.Caption.Trim() + "\" : \""
                    + dr[c].ToString().Replace("'", "”").Replace(",", "，").Trim() + "\"  ";
            }
            if (jsonPerRecord.Trim().StartsWith(","))
                jsonPerRecord = jsonPerRecord.Trim().Remove(0, 1);
            jsonRecordCollection = jsonRecordCollection + ", {" + jsonPerRecord.Trim() + "} ";
        }
        if (jsonRecordCollection.Trim().StartsWith(","))
            jsonRecordCollection = jsonRecordCollection.Trim().Remove(0, 1);
        Response.Write("{\"status\":0, donate_list:[" + jsonRecordCollection + "]}");
        
    }

    public static void InsertOrders(int maxOrderId)
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
            if (int.Parse(orderId.ToString()) > maxOrderId)
            {
                try
                {
                    object userId;
                    orderDict.TryGetValue("uid", out userId);
                    Users user = new Users(int.Parse(userId.ToString()));
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
                    try
                    {
                        orderDict.TryGetValue("ctime1", out orderDate);
                    }
                    catch
                    {
                        orderDate = (object)DateTime.Now;
                    }
                    InsertIntoList(nick.ToString(), headImageUrl.ToString(), cell.ToString(), "buy", int.Parse(orderId.ToString()), DateTime.Parse(orderDate.ToString()));
                }
                catch(Exception err)
                {
                    System.Console.WriteLine(err.ToString());
                }
            }
            else
            {
                break;
            }
        }
    }

    public static string GetUserinfoJSONStringByOpenId(string openId)
    {
        
        return "";
    }

    public static void InsertIntoList(string nick, string headImage, string cell, string type, int orderId, DateTime date)
    {
        KeyValuePair<string, KeyValuePair<SqlDbType, object>>[] insertParameterArray
            = new KeyValuePair<string, KeyValuePair<SqlDbType, object>>[6];
        insertParameterArray[0] = new KeyValuePair<string, KeyValuePair<SqlDbType, object>>("type",
            new KeyValuePair<SqlDbType, object>(SqlDbType.VarChar, (object)"buy"));
        insertParameterArray[1] = new KeyValuePair<string, KeyValuePair<SqlDbType, object>>("order_id",
            new KeyValuePair<SqlDbType, object>(SqlDbType.Int, (object)orderId));
        insertParameterArray[2] = new KeyValuePair<string, KeyValuePair<SqlDbType, object>>("weixin_nick",
            new KeyValuePair<SqlDbType, object>(SqlDbType.VarChar, (object)nick));
        insertParameterArray[3] = new KeyValuePair<string, KeyValuePair<SqlDbType, object>>("weixin_head_image",
            new KeyValuePair<SqlDbType, object>(SqlDbType.VarChar, (object)headImage));
        insertParameterArray[4] = new KeyValuePair<string, KeyValuePair<SqlDbType, object>>("cell",
            new KeyValuePair<SqlDbType, object>(SqlDbType.VarChar, (object)cell));
        insertParameterArray[5] = new KeyValuePair<string, KeyValuePair<SqlDbType, object>>("create_time",
            new KeyValuePair<SqlDbType, object>(SqlDbType.DateTime, (object)date));
        DBHelper.InsertData("donate_list", insertParameterArray, Util.ConnectionString);
    }
    
    public static int GetMaxOrderIdFromDonateList()
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