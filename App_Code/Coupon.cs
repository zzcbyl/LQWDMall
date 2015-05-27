using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Data;
using System.Data.SqlClient;

/// <summary>
///Coupon 的摘要说明
/// </summary>
public class Coupon
{
    public DataRow _fields;


	public Coupon()
	{
		//
		//TODO: 在此处添加构造函数逻辑
		//
	}

    public static Coupon[] GetCoupons(int userId, int activityid)
    {
        string sql = " select * from m_coupon where coupon_uid=" + userId + "  and coupon_activityid=" + activityid;
        SqlDataAdapter da = new SqlDataAdapter(sql, Util.ConnectionString.Trim());
        DataTable dt = new DataTable();
        da.Fill(dt);
        da.Dispose();
        Coupon[] couponArray = new Coupon[dt.Rows.Count];
        for (int i = 0; i < dt.Rows.Count; i++)
        {
            couponArray[i] = new Coupon();
            couponArray[i]._fields = dt.Rows[i];
        }
        return couponArray;
    }
}