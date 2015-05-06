using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Data;
using System.Data.SqlClient;

/// <summary>
///Relation 的摘要说明
/// </summary>
public class Relation
{
	public Relation()
	{
		//
		//TODO: 在此处添加构造函数逻辑
		//
	}

    public static void Add(string openid, string parentopenid)
    {
        SqlDataAdapter da = new SqlDataAdapter("select * from m_relation where openid = '" + openid + "' and parentopenid = '" + parentopenid + "'", Util.ConnectionString);
        DataTable dt = new DataTable();
        da.Fill(dt);
        if (dt.Rows.Count <= 0)
        {
            string sql = "insert into m_relation (openid, parentopenid) values ('" + openid + "','" + parentopenid + "' )";
            SqlConnection conn = new SqlConnection(Util.ConnectionString);
            SqlCommand cmd = new SqlCommand(sql, conn);
            conn.Open();
            cmd.ExecuteNonQuery();
            conn.Close();
            cmd.Dispose();
            conn.Dispose();
        }
    }
}