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
    
    }

    public string GetJson()
    {
        string jsonStr = "";
        foreach (DataColumn c in _fields.Table.Columns)
        {
            jsonStr = jsonStr + ", \"" + c.Caption.Trim() + "\":\"" + _fields[c].ToString().Trim() + "\"";
        }
        jsonStr = jsonStr.Remove(0, 1);
        jsonStr = "{" + jsonStr + "}";
        return jsonStr.Trim();
    }


    public static Product[] GetAllProduct()
    {
        SqlDataAdapter da = new SqlDataAdapter(" select * from m_product ", Util.ConnectionString.Trim());
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
}