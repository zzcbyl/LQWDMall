using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Data.SqlClient;
using System.Data;

/// <summary>
///EuropeVote 的摘要说明
/// </summary>
public class EuropeVote
{
	public EuropeVote()
	{
		//
		//TODO: 在此处添加构造函数逻辑
		//
	}

    public static bool checkUpload(string openid, string username, DateTime currentDate)
    {
        bool result = false;
        SqlDataAdapter da = new SqlDataAdapter("select image_id from Europe_image where image_openid='" + openid + "' and image_username = '" + username + "' and image_date = '" + currentDate.ToString("yyyy-MM-dd") + "'", Util.ConnectionString);
        DataTable dt = new DataTable();
        da.Fill(dt);
        if (dt != null && dt.Rows.Count > 0)
            result = true;
        return result;
    }

    public static bool checkName(string openid, string username)
    {
        bool result = true;
        SqlDataAdapter da = new SqlDataAdapter("select image_username from Europe_image where image_openid='" + openid + "' group by image_username", Util.ConnectionString);
        DataTable dt = new DataTable();
        da.Fill(dt);
        if (dt != null && dt.Rows.Count > 0)
            if (dt.Rows[0]["image_username"].ToString() != username)
                result = false;
        return result;
    }

    public static int Upload(string openid, string username, string imgurl, DateTime currentDate)
    {
        string sql = "INSERT INTO Europe_image ([image_url],[image_openid],[image_username],[image_count],[image_date]) VALUES (" +
            "'" + imgurl + "','" + openid + "','" + username + "',0,'" + currentDate.ToString("yyyy-MM-dd") + "')";
        SqlConnection conn = new SqlConnection(Util.ConnectionString);
        SqlCommand cmd = new SqlCommand(sql, conn);
        conn.Open();
        int result = cmd.ExecuteNonQuery();
        return result;
    }


    public static int voteImage(string openid, string username, int imageid, string remark)
    {
        string sql = "INSERT INTO vote_list(vote_openid, vote_name, vote_clothingid, vote_remark) "
            + "VALUES ('" + openid + "','" + username + "'," + imageid + ",'" + remark + "')";

        SqlConnection conn = new SqlConnection(Util.ConnectionString);
        SqlCommand cmd = new SqlCommand(sql, conn);
        conn.Open();
        int result = cmd.ExecuteNonQuery();
        if (result > 0)
        {
            sql = "update Europe_image set image_count = image_count + 1 where image_id = " + imageid;
            cmd = new SqlCommand(sql, conn);
            cmd.ExecuteNonQuery();
        }
        conn.Close();
        cmd.Dispose();
        conn.Dispose();
        return result;
    }


    public static DataTable getImageList(string date, int pageSize, int currentPage)
    {
        int intop = pageSize * (currentPage - 1);
        string sql = "select top " + pageSize + " * from Europe_image where image_date>='" + date + "' and image_date<'" + Convert.ToDateTime(date).AddDays(1) + "' and image_id not in (select top " + intop + " image_id from Europe_image where image_date>='" + date + "' and image_date<'" + Convert.ToDateTime(date).AddDays(1) + "' order by image_count desc ) order by image_count desc ";
        SqlDataAdapter da = new SqlDataAdapter(sql, Util.ConnectionString); 
        DataTable dt = new DataTable();
        da.Fill(dt);
        return dt;
    }

    public static DataTable getEuropeVotes()
    {
        string sql = "select image_username,sum(image_count) cc from dbo.Europe_image group by image_username order by cc desc";
        SqlDataAdapter da = new SqlDataAdapter(sql, Util.ConnectionString);
        DataTable dt = new DataTable();
        da.Fill(dt);
        return dt;
    }

    public static DataTable getOwnImageList(string openid, string username, int pageSize, int currentPage)
    {
        int intop = pageSize * (currentPage - 1);
        string sql = "select top " + pageSize + " * from Europe_image where image_openid='" + openid + "' and image_username='" + username + "' and image_id not in (select top " + intop + " image_id from Europe_image where image_openid='" + openid + "' and image_username='" + username + "' order by image_count desc ) order by image_count desc ";
        SqlDataAdapter da = new SqlDataAdapter(sql, Util.ConnectionString);
        DataTable dt = new DataTable();
        da.Fill(dt);
        return dt;
    }

}