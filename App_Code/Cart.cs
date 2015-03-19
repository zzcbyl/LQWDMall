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
}