using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Data;
using System.Data.SqlClient;

/// <summary>
/// Summary description for Cart
/// </summary>
public class Cart
{

    public int _userId = 0;

	public Cart()
	{
		//
		// TODO: Add constructor logic here
		//
	}

    public Cart(int userId)
    {
        _userId = userId;

        
    }

    public void ModifyItem(int productId, int count)
    {
        string sql = "";
        if (count == 0)
        {
            sql = " delete m_cart where uid = " + _userId.ToString() + " and product_id = " + productId.ToString();
        }
        else
        {
            if (ExistInCart(productId))
            {
                sql = " update m_cart set product_count = " + count.ToString() + "  where uid = " + _userId.ToString()
                    + "  and product_id = " + productId.ToString();
            }
            else
            {
                sql = " insert into m_cart (uid,product_id,product_count) values (" + _userId.ToString() + ","
                    + productId.ToString() + "," + count.ToString() + ") ";
            }
        }

        SqlConnection conn = new SqlConnection(Util.ConnectionString);
        SqlCommand cmd = new SqlCommand(sql, conn);
        conn.Open();
        cmd.ExecuteNonQuery();
        conn.Close();
        cmd.Dispose();
        conn.Dispose();

        
    }

    public bool ExistInCart(int productId)
    {
        SqlConnection conn = new SqlConnection(Util.ConnectionString);
        SqlCommand cmd = new SqlCommand(" select 'a' from m_cart where product_id = " + productId.ToString() + " and uid = " + _userId.ToString(), conn);
        bool exists = false;
        conn.Open();
        SqlDataReader dr = cmd.ExecuteReader();
        if (dr.Read())
            exists = true;
        dr.Close();
        conn.Close();
        cmd.Dispose();
        conn.Dispose();
        return exists;
    }

    public DataTable GetCartTable()
    {
        SqlDataAdapter da = new SqlDataAdapter(" select * from m_cart left join m_product on m_cart.product_id = m_product.prodid  where uid = " 
            + _userId.ToString(), Util.ConnectionString);
        DataTable cartTable = new DataTable();
        da.Fill(cartTable);
        da.Dispose();
        return cartTable;
    }

    public int PlaceOrder(string name, string cell, string province, string city, string address,
        string zip, int[] productIdArray, int[] countArray, string memo, string wechatId)
    {
        if (productIdArray.Length != countArray.Length)
            return -1;

        string sqlInsertIntoOrders = " insert into m_order (uid,name,cell,province,city,address,zip,memo,wechat_id) values ("
            + _userId.ToString() + ",'" + name.Trim().Replace("'", "") + "','" + cell.Trim().Replace("'", "") + "' , '"
            + province.Replace("'", "").Trim() + "','" + city.Replace("'", "").Trim() + "' , '" + address.Trim().Replace("'", "")
            + "' , '" + zip.Trim() + "',  '" + memo.Trim().Replace("'","").Trim() + "' , '" + wechatId.Trim().Replace("'","").Trim() + "' ) ";

        SqlConnection conn = new SqlConnection(Util.ConnectionString.Trim());
        SqlCommand cmdInsertIntoOrder = new SqlCommand(sqlInsertIntoOrders, conn);

        conn.Open();

        cmdInsertIntoOrder.ExecuteNonQuery();


        /*
        int countTotal = 0;


        foreach (int count in countArray)
        {
            countTotal = countTotal + count;
        }

        int shipFee = Util.ShipFeeCalculate(province, countTotal);

         * 
         */

        int countTotal = 0;
        int shipFee = 0;

        int totalAmount = 0;


        int orderId = 0;

        cmdInsertIntoOrder.CommandText = " select max(oid) from m_order ";

        SqlDataReader dataReaderMaxOrderId = cmdInsertIntoOrder.ExecuteReader();
        if (dataReaderMaxOrderId.Read())
            orderId = dataReaderMaxOrderId.GetInt32(0);
        dataReaderMaxOrderId.Close();

        SqlCommand cmdInsertOrderDetail = new SqlCommand(" insert into m_order_detail ( "
            + " order_id , product_name , product_description , imgsrc , price , product_count , product_id )  "
            + " values ( " + orderId.ToString() + " , @product_name, @product_description , @imgsrc, "
            + "@price , @count , @productId) ", conn);
        cmdInsertOrderDetail.Parameters.Add("@product_name", SqlDbType.VarChar);
        cmdInsertOrderDetail.Parameters.Add("@product_description", SqlDbType.VarChar);
        cmdInsertOrderDetail.Parameters.Add("@imgsrc", SqlDbType.VarChar);
        cmdInsertOrderDetail.Parameters.Add("@price", SqlDbType.Int);
        cmdInsertOrderDetail.Parameters.Add("@count", SqlDbType.Int);
        cmdInsertOrderDetail.Parameters.Add("@productId", SqlDbType.Int);
        SqlCommand cmdDeleteCart = new SqlCommand(" delete m_cart where uid = " + _userId.ToString()
            + "  and product_id = @productId ", conn);
        cmdDeleteCart.Parameters.Add("@productId", SqlDbType.Int);

        

        for (int i = 0; i < productIdArray.Length; i++)
        {
            Product product = new Product(productIdArray[i]);
            cmdInsertOrderDetail.Parameters["@product_name"].Value = product._fields["prodname"].ToString().Trim();
            cmdInsertOrderDetail.Parameters["@product_description"].Value = product._fields["description"].ToString().Substring(0, 300).Trim();
            cmdInsertOrderDetail.Parameters["@imgsrc"].Value = product._fields["imgsrc"].ToString().Trim();
            cmdInsertOrderDetail.Parameters["@price"].Value = int.Parse(product._fields["price"].ToString().Trim());
            cmdInsertOrderDetail.Parameters["@count"].Value = countArray[i];

            cmdInsertOrderDetail.Parameters["@productId"].Value = productIdArray[i];
            cmdInsertOrderDetail.ExecuteNonQuery();
            cmdDeleteCart.Parameters["@productId"].Value = productIdArray[i];
            cmdDeleteCart.ExecuteNonQuery();
            totalAmount = totalAmount + int.Parse(product._fields["price"].ToString().Trim()) * countArray[i];

            countTotal = countTotal + int.Parse(product._fields["precount"].ToString().Trim()) * countArray[i];

        }

        if (countTotal > 0)
            shipFee = Util.ShipFeeCalculate(province, countTotal);

        SqlCommand cmdOrderUpdate = new SqlCommand(" update m_order set orderprice = " + totalAmount.ToString()
            + " ,   shipfee = " + shipFee.ToString() + "  where oid = " + orderId.ToString(), conn);

        cmdOrderUpdate.ExecuteNonQuery();

        conn.Close();
        cmdOrderUpdate.Dispose();
        cmdDeleteCart.Dispose();
        cmdInsertOrderDetail.Parameters.Clear();
        cmdInsertOrderDetail.Dispose();
        cmdInsertIntoOrder.Dispose();
        conn.Dispose();

        return orderId;
    }

}