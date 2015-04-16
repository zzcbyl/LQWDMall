using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Data;
using System.Data.SqlClient;

/// <summary>
/// Summary description for Order
/// </summary>
public class Order
{

    public DataRow _fields;

    public int _orderId;

    public Order()
    {
        //_orderId = int.Parse(_fields["oid"].ToString().Trim());
    }

	public Order(int orderId)
	{
        _orderId = orderId;
        SqlDataAdapter da = new SqlDataAdapter(" select * from m_order where oid = " + orderId.ToString(), Util.ConnectionString);
        DataTable dt = new DataTable();
        da.Fill(dt);
        _fields = dt.Rows[0];
        da.Dispose();

	}

    public DataTable GetOrderDetails()
    {
        SqlDataAdapter da = new SqlDataAdapter(" select * from m_order_detail where order_id = " + int.Parse(_fields["oid"].ToString().Trim()), Util.ConnectionString);
        DataTable dt = new DataTable();
        da.Fill(dt);
        da.Dispose();
        return dt;
    }

    public static Order[] GetOrders(int userId, DateTime startDate, DateTime endDate)
    {
        string sql = " select * from m_order where ctime > '" + startDate.ToString() + "' and ctime < '"
            + endDate.AddDays(1).ToString() + "'  " + ((userId == 0) ? "" : " and uid = " + userId.ToString())
            + "  order by oid desc ";
        SqlDataAdapter da = new SqlDataAdapter(sql, Util.ConnectionString.Trim());
        DataTable dt = new DataTable();
        da.Fill(dt);
        da.Dispose();
        Order[] orderArray = new Order[dt.Rows.Count];
        for (int i = 0; i < dt.Rows.Count; i++)
        {
            orderArray[i] = new Order();
            orderArray[i]._fields = dt.Rows[i];
        }
        return orderArray;
    }

    public int updPayState(int orderid)
    {
        string sqlUpdPay = "update m_order set paystate = 1, paysuccesstime = '" + DateTime.Now.ToString() + "' where oid = " + orderid;
        SqlConnection conn = new SqlConnection(Util.ConnectionString.Trim());
        SqlCommand cmdUpdPayOrder = new SqlCommand(sqlUpdPay, conn);
        conn.Open();
        int result = cmdUpdPayOrder.ExecuteNonQuery();
        return result;
    }
}