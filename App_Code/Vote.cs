﻿using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Data;
using System.Data.SqlClient;

/// <summary>
///Vote 的摘要说明
/// </summary>
public class Vote
{
	public Vote()
	{
		//
		//TODO: 在此处添加构造函数逻辑
		//
	}

    public static DataTable getClothList()
    {
        SqlDataAdapter da = new SqlDataAdapter("select * from vote_clothing order by clothing_id", Util.ConnectionString);
        DataTable dt = new DataTable();
        da.Fill(dt);
        return dt;
    }

    public static bool checkVote(string openid)
    {
        bool result = false;
        SqlDataAdapter da = new SqlDataAdapter("select vote_id from vote_list where vote_openid='" + openid + "'", Util.ConnectionString);
        DataTable dt = new DataTable();
        da.Fill(dt);
        if (dt != null && dt.Rows.Count > 15)
        {
            result = true;
        }
        return result;
    }

    public static int voteClothing(string openid, string nickname, int clothingid, string remark)
    {
        string sql = "INSERT INTO vote_list(vote_openid, vote_name, vote_clothingid, vote_remark) "
            + "VALUES ('" + openid + "','" + nickname + "'," + clothingid + ",'" + remark + "')";

        SqlConnection conn = new SqlConnection(Util.ConnectionString);
        SqlCommand cmd = new SqlCommand(sql, conn);
        conn.Open();
        int result = cmd.ExecuteNonQuery();
        if (result > 0)
        {
            sql = "update vote_clothing set clothing_votes=clothing_votes+1,clothing_lastvotes_crt='" + DateTime.Now + "' where clothing_id =" + clothingid;
            cmd = new SqlCommand(sql, conn);
            cmd.ExecuteNonQuery();
        }
        conn.Close();
        cmd.Dispose();
        conn.Dispose();
        return result;
    }

    public static DataTable getVoteListByPage(int currentPage, int pageSize)
    {
        int intop = pageSize * (currentPage - 1);
        string sql = "SELECT TOP " + pageSize + " * FROM vote_list WHERE  vote_remark <> '' and vote_id NOT IN (SELECT TOP " + intop + " vote_id FROM vote_list where vote_remark <> '' ORDER BY vote_id desc) ORDER BY vote_id desc";
        SqlDataAdapter da = new SqlDataAdapter(sql, Util.ConnectionString);
        DataTable dt = new DataTable();
        da.Fill(dt);
        return dt;
    }
}