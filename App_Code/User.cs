﻿using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Data;
using System.Data.SqlClient;

/// <summary>
/// Summary description for User
/// </summary>
[Serializable]
public class Users
{

    public DataRow _fields;

	public Users()
	{
		//
		// TODO: Add constructor logic here
		//
	}

    public Users(int userId)
    {
        SqlDataAdapter da = new SqlDataAdapter(" select * from m_user where uid = " + userId.ToString(), Util.ConnectionString);
        DataTable dt = new DataTable();
        da.Fill(dt);
        da.Dispose();
        if (dt.Rows.Count == 0)
        {
            throw new Exception("User is not exists.");
        }
        else
        {
            _fields = dt.Rows[0];  
        }
    }


    public int Integral
    {
        get
        {
            if (_fields != null)
                return int.Parse(_fields["integral"].ToString().Trim());
            else
                return 0;
        }
        set
        {
            int integral = value;
            string[,] updateParameters = { { "integral", "int", integral.ToString() } };
            string[,] keyParameters = { { "uid", "int", ID.ToString() } };
            DBHelper.UpdateData("m_user", updateParameters, keyParameters, Util.ConnectionString);
        }
    }

    public string CreateToken(DateTime expireDate)
    {
        string stringWillBeToken = _fields["uid"].ToString()+Util.GetLongTimeStamp(DateTime.Now)
            +Util.GetLongTimeStamp(expireDate)
            + (new Random()).Next(10000).ToString().PadLeft(4,'0');
        string token = Util.GetMd5(stringWillBeToken)+Util.GetSHA1(stringWillBeToken);

        SqlConnection conn = new SqlConnection(Util.ConnectionString);
        SqlCommand cmd = new SqlCommand(" update m_token set isvalid = 0 where uid = '" + _fields["uid"].ToString().Trim() + "'  ",conn);
        conn.Open();
        cmd.ExecuteNonQuery();
        cmd.CommandText = " insert m_token (token,isvalid,expire,uid) values  ('" + token.Trim() + "' "
            + " , 1 , '"  +  expireDate.ToString() + "' , '" + _fields["uid"].ToString() + "' ) ";
        cmd.ExecuteNonQuery();
        conn.Close();
        cmd.Dispose();
        conn.Dispose();
        return token;
    }



    public int ID { get { return int.Parse(_fields["uid"].ToString().Trim()); } }
    public string Name { get; set; }
    public string Sex { get; set; }

    public string DingyueOpenid
    {
        get
        {
            return _fields["openid"].ToString().Trim();
        }
        set
        {
            string[,] updateParameter = new string[,] { { "dingyue_openid", "varchar", value.Trim() } };
            string[,] keyParameter = new string[,] { { "uid", "int", _fields["uid"].ToString().Trim() } };
            DBHelper.UpdateData("m_user", updateParameter, keyParameter, Util.ConnectionString);
        }
    }

    public static int CheckToken(string token)
    {
        int ret = 0;
        SqlDataAdapter da = new SqlDataAdapter(" select * from m_token where token = '" + token.Trim().Replace("'", "").Trim() + "' ", Util.ConnectionString);
        DataTable dt = new DataTable();
        da.Fill(dt);
        da.Dispose();
        if (dt.Rows.Count == 1)
        {
            if (!dt.Rows[0]["isvalid"].ToString().Trim().Equals("1"))
                ret = -1;
            DateTime expireDate = DateTime.Parse(dt.Rows[0]["expire"].ToString());
            if (expireDate <= DateTime.Now)
                ret = -2;
            if (ret == 0)
                ret = int.Parse(dt.Rows[0]["uid"].ToString().Trim());
        }
        dt.Dispose();
        return ret;
    }

    

    public static int AddUser(string type, string userName)
    {
        string sql = "";
        switch (type.Trim())
        { 
            case "username":
                sql = " insert into m_user (uname) values ('" + userName.Trim().Replace("'", "").Trim() + "' ) ";
                break;
            case "openid":
                sql = " insert into m_user (openid) values ('" + userName.Trim().Replace("'", "").Trim() + "' ) ";
                break;
            default:
                break;
        }
        int uid = 0;
        SqlConnection conn = new SqlConnection(Util.ConnectionString);
        SqlCommand cmd = new SqlCommand(sql, conn);
        conn.Open();
        cmd.ExecuteNonQuery();
        cmd.CommandText = " select max(uid) from m_user ";
        SqlDataReader sdr = cmd.ExecuteReader();
        if (sdr.Read())
            uid = sdr.GetInt32(0);
        sdr.Close();
        conn.Close();
        cmd.Dispose();
        conn.Dispose();
        return uid;
    }

    public static string GetToken(int userId)
    {
        return "";
    }

    public static int CreateUser(string type, string userName)
    {
        return 0;
    }

    public static bool IsExistsUser(string type, string userName)
    {
        bool ret = false;
        try
        {
            GetUser(type, userName);
            ret = true;
        }
        catch (Exception err)
        {
            if (err.Message.Trim().Equals("User is not exists."))
                ret = false;
                
        }
        return ret;
    }

    public static Users GetUser(string type, string userName)
    {
        string sql = " select * from m_user where  ";
        switch (type.Trim())
        {
            case "username":
                sql = sql + "  uname = '" + userName.Trim() + "'  ";
                break;
            case "openid":
                sql = sql + " openid = '" + userName.Trim() + "'  ";
                break;
            default:
                break;
        }
        Users user = new Users();
        SqlDataAdapter da = new SqlDataAdapter(sql, Util.ConnectionString.Trim());
        DataTable dt = new DataTable();
        da.Fill(dt);
        if (dt.Rows.Count == 0)
        {
            throw new Exception("User is not exists.");
        }
        else
        {
            user._fields = dt.Rows[0];
        }
        da.Dispose();
        return user;
    }

}