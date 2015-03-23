using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Data;
using System.Data.SqlClient;

/// <summary>
/// Summary description for Product
/// </summary>
public class Product
{

    public DataRow _fields;


    public Product()
    {

    }

    public Product(int id)
    {
        SqlDataAdapter da = new SqlDataAdapter(" select * from m_product where prodid = " + id.ToString(), Util.ConnectionString);
        DataTable dt = new DataTable();
        da.Fill(dt);
        if (dt.Rows.Count > 0)
            _fields = dt.Rows[0];
        da.Dispose();
    }

    public DataTable ImageTable
    {
        get
        {
            DataTable dt = new DataTable();
            SqlDataAdapter da = new SqlDataAdapter(" select * from m_image where prodid = " + _fields["prodid"].ToString().Trim(), Util.ConnectionString);
            da.Fill(dt);
            da.Dispose();
            return dt;
        }
    }

    #region Model

    private int _prodid;
    private int _prodtypeid = 0;
    private string _prodname;
    private string _description;
    private decimal _price;
    private int _inventory;
    private int _freightid;
    private string _imgsrc = "";
    private int _isrecommend = 0;
    private DateTime _ctime = DateTime.Now;
    /// <summary>
    /// 
    /// </summary>
    public int prodid
    {
        set { _prodid = value; }
        get { return _prodid; }
    }
    /// <summary>
    /// 
    /// </summary>
    public int prodtypeid
    {
        set { _prodtypeid = value; }
        get { return _prodtypeid; }
    }
    /// <summary>
    /// 
    /// </summary>
    public string prodname
    {
        set { _prodname = value; }
        get { return _prodname; }
    }
    /// <summary>
    /// 
    /// </summary>
    public string description
    {
        set { _description = value; }
        get { return _description; }
    }
    /// <summary>
    /// 
    /// </summary>
    public decimal price
    {
        set { _price = value; }
        get { return _price; }
    }
    /// <summary>
    /// 
    /// </summary>
    public int inventory
    {
        set { _inventory = value; }
        get { return _inventory; }
    }
    /// <summary>
    /// 
    /// </summary>
    public int freightid
    {
        set { _freightid = value; }
        get { return _freightid; }
    }
    /// <summary>
    /// 
    /// </summary>
    public string imgsrc
    {
        set { _imgsrc = value; }
        get { return _imgsrc; }
    }
    /// <summary>
    /// 推荐
    /// </summary>
    public int isrecommend
    {
        set { _isrecommend = value; }
        get { return _isrecommend; }
    }
    /// <summary>
    /// 
    /// </summary>
    public DateTime ctime
    {
        set { _ctime = value; }
        get { return _ctime; }
    }
    #endregion Model

    public string GetJson()
    { 
        string jsonStr = "";
        foreach (DataColumn c in _fields.Table.Columns)
        {
            jsonStr = jsonStr + ", \"" + c.Caption.Trim() + "\":\"" 
                + _fields[c].ToString().Trim().Replace("\"","\\\"") + "\"";
        }
        jsonStr = jsonStr.Remove(0, 1);
        jsonStr = "{" + jsonStr  + "}";
        return jsonStr.Trim();
    }

    public string GetJsonWithImages()
    {
        string jsonStr = "";
        foreach (DataColumn c in _fields.Table.Columns)
        {
            jsonStr = jsonStr + ", \"" + c.Caption.Trim() + "\":\"" + _fields[c].ToString().Trim() + "\"";
        }
        if (!jsonStr.Trim().Equals(""))
            jsonStr = jsonStr.Remove(0, 1);
        jsonStr = jsonStr.Remove(0, 1);

        string imageJson = "";

        DataTable dtImage = ImageTable;

        for (int i = 0; i < dtImage.Rows.Count; i++)
        {
            imageJson = imageJson + ",{";
            string imageRowJson = "";
            for (int j = 0; j < dtImage.Columns.Count; j++)
            {
                imageRowJson = imageRowJson + ", \"" + dtImage.Columns[j].Caption.Trim() + "\" : \"" + dtImage.Rows[i][j].ToString() + "\" ";
            }
            if (!imageRowJson.Trim().Equals(""))
                imageRowJson = imageRowJson.Remove(0, 1);
            imageJson = imageJson + imageRowJson + "}";
        }
        if (!imageJson.Trim().Equals(""))
            imageJson = imageJson.Remove(0, 1);
        jsonStr = "{" + jsonStr +  ",\"images\":[" + imageJson + "]}";
        return jsonStr.Trim();
    }


    public static Product[] GetAllProduct()
    {
        SqlDataAdapter da = new SqlDataAdapter(" select * from m_product order by isrecommend desc, prodid desc", Util.ConnectionString.Trim());
        DataTable dt = new DataTable();
        da.Fill(dt);
        Product[] productArray = new Product[dt.Rows.Count];

        for (int i = 0; i < dt.Rows.Count; i++)
        {
            productArray[i] = new Product();
            productArray[i]._fields = dt.Rows[i];
        }
        return productArray;
    }

    public static string ConvertProductArrayToJson(Product[] productArray)
    {
        string jsonStr = "{ \"type\":\"Product\" , \"count\":\"" + productArray.Length + "\" , \"data\" : [";
        string subJsonStr = "";
        foreach (Product product in productArray)
        {
            subJsonStr = subJsonStr + "," + product.GetJson();
        }
        subJsonStr = subJsonStr.Remove(0, 1);
        jsonStr = jsonStr + subJsonStr + "]}";
        return jsonStr.Trim();

    }

    public static string ConvertProductArrayToJson(Product[] productArray, int pageSize, int currentPage)
    {
        int productArrayLength = productArray.Length;
        int pageCount = productArrayLength / pageSize;
        if (pageCount * pageSize < productArrayLength)
            pageCount++;
        int startIndex = currentPage * pageSize;
        int endIndex = startIndex + pageSize;

        string subJsonStr = "";

        for (int i = startIndex; i < endIndex && i < productArrayLength; i++)
        {
            subJsonStr = subJsonStr + "," + productArray[i].GetJson();
        }
        subJsonStr = subJsonStr.Remove(0, 1);
        string jsonStr = "{ \"type\":\"Product\" , \"count\":\"" + productArray.Length + "\" , \"PageSize\":\"" + pageSize.ToString()
            + "\" , \"PageCount\" : \"" + pageCount.ToString() + "\" , \"CurrentPage\" : \"" + currentPage.ToString() + "\"  , \"data\" : ["
            + subJsonStr.Trim() + "]}";
        return jsonStr;
    }
}