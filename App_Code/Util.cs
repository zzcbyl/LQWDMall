using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Text;
using System.Security.Cryptography;
using System.Data;
using System.Data.SqlClient;
using System.Net;
using System.IO;
using System.Web.Script.Serialization;
/// <summary>
/// Summary description for Util
/// </summary>
public class Util
{

    public static string ConnectionString = System.Configuration.ConfigurationSettings.AppSettings["constr"].Trim();
    
    public static string ApiDomainString = System.Configuration.ConfigurationSettings.AppSettings["apiDomain"].Trim();
    public static string WebDomainString = System.Configuration.ConfigurationSettings.AppSettings["webDomain"].Trim();


    protected static string token = "";

    protected static DateTime tokenTime = DateTime.MinValue;

    public static string conStr = "";

	public Util()
	{
		//
		// TODO: Add constructor logic here
		//
	}

    public static string GetSHA1(string str)
    {
        SHA1 sha = SHA1.Create();
        ASCIIEncoding enc = new ASCIIEncoding();
        byte[] bArr = enc.GetBytes(str);
        bArr = sha.ComputeHash(bArr);
        string validResult = "";
        for (int i = 0; i < bArr.Length; i++)
        {
            validResult = validResult + bArr[i].ToString("x").PadLeft(2, '0');
        }
        return validResult.Trim();
    }

    public static string GetMd5(string str)
    {
        System.Security.Cryptography.MD5 md5 = System.Security.Cryptography.MD5.Create();
        byte[] bArr = md5.ComputeHash(Encoding.UTF8.GetBytes(str));
        string ret = "";
        foreach (byte b in bArr)
        {
            ret = ret + b.ToString("x").PadLeft(2, '0');
        }
        return ret;
    }

    public static string GetLongTimeStamp(DateTime currentDateTime)
    {
        TimeSpan ts = currentDateTime - new DateTime(1970, 1, 1, 0, 0, 0, 0);
        return Convert.ToInt64(ts.TotalMilliseconds).ToString();
    }

    public static int ShipFeeCalculate(string province, int count)
    {
        DataTable dtShipFee = new DataTable();
        dtShipFee.Columns.Add("province");
        dtShipFee.Columns.Add("start_weight_fee");
        dtShipFee.Columns.Add("addintional_weight_fee");

        DataRow drShipFee = dtShipFee.NewRow();
        drShipFee["province"] = "北京市";
        drShipFee["start_weight_fee"] = 800;
        drShipFee["addintional_weight_fee"] = 400;
        dtShipFee.Rows.Add(drShipFee);

        drShipFee = dtShipFee.NewRow();
        drShipFee["province"] = "宁夏回族自治区";
        drShipFee["start_weight_fee"] = 1800;
        drShipFee["addintional_weight_fee"] = 800;
        dtShipFee.Rows.Add(drShipFee);

        drShipFee = dtShipFee.NewRow();
        drShipFee["province"] = "青海省";
        drShipFee["start_weight_fee"] = 1800;
        drShipFee["addintional_weight_fee"] = 800;
        dtShipFee.Rows.Add(drShipFee);

        drShipFee = dtShipFee.NewRow();
        drShipFee["province"] = "内蒙古自治区";
        drShipFee["start_weight_fee"] = 1800;
        drShipFee["addintional_weight_fee"] = 800;
        dtShipFee.Rows.Add(drShipFee);

        drShipFee = dtShipFee.NewRow();
        drShipFee["province"] = "云南省";
        drShipFee["start_weight_fee"] = 1800;
        drShipFee["addintional_weight_fee"] = 800;
        dtShipFee.Rows.Add(drShipFee);

        drShipFee = dtShipFee.NewRow();
        drShipFee["province"] = "黑龙江省";
        drShipFee["start_weight_fee"] = 1500;
        drShipFee["addintional_weight_fee"] = 800;
        dtShipFee.Rows.Add(drShipFee);

        drShipFee = dtShipFee.NewRow();
        drShipFee["province"] = "吉林省";
        drShipFee["start_weight_fee"] = 1500;
        drShipFee["addintional_weight_fee"] = 800;
        dtShipFee.Rows.Add(drShipFee);

        drShipFee = dtShipFee.NewRow();
        drShipFee["province"] = "辽宁省";
        drShipFee["start_weight_fee"] = 1500;
        drShipFee["addintional_weight_fee"] = 800;
        dtShipFee.Rows.Add(drShipFee);

        drShipFee = dtShipFee.NewRow();
        drShipFee["province"] = "广西壮族自治区";
        drShipFee["start_weight_fee"] = 1500;
        drShipFee["addintional_weight_fee"] = 800;
        dtShipFee.Rows.Add(drShipFee);

        drShipFee = dtShipFee.NewRow();
        drShipFee["province"] = "新疆维吾尔自治区";
        drShipFee["start_weight_fee"] = 2000;
        drShipFee["addintional_weight_fee"] = 1500;
        dtShipFee.Rows.Add(drShipFee);

        drShipFee = dtShipFee.NewRow();
        drShipFee["province"] = "西藏自治区";
        drShipFee["start_weight_fee"] = 2000;
        drShipFee["addintional_weight_fee"] = 1500;
        dtShipFee.Rows.Add(drShipFee);

        int startWeight = 1200;
        int addintionalWeight = 800;
        DataRow[] drArr = dtShipFee.Select(" province = '" + province.Trim() + "'  " );
        if (drArr.Length > 0)
        {
            startWeight = int.Parse(drArr[0]["start_weight_fee"].ToString().Trim());
            addintionalWeight = int.Parse(drArr[0]["addintional_weight_fee"].ToString().Trim());
        }

        int amount = startWeight;

        if (count > 2)
        {
            if ((count / 2) * 2 == count)
            {
                amount = amount + addintionalWeight * ((count / 2) - 1);
            }
            else
            {
                amount = amount + addintionalWeight * (count / 2);
            }
        }
        else if (count == 0)
            amount = 0;

        return amount;

    }

    public static string GetTimeStamp()
    {
        TimeSpan ts = DateTime.UtcNow - new DateTime(1970, 1, 1, 0, 0, 0, 0);
        return Convert.ToInt64(ts.TotalSeconds).ToString();
    }
    public static string GetWebContent(string url, string method, string content, string contentType)
    {
        HttpWebRequest req = (HttpWebRequest)WebRequest.Create(url);
        req.Method = method.Trim();
        req.ContentType = contentType;
        if (!content.Trim().Equals(""))
        {
            StreamWriter sw = new StreamWriter(req.GetRequestStream());
            sw.Write(content);
            sw.Close();
        }
        HttpWebResponse res = (HttpWebResponse)req.GetResponse();
        Stream s = res.GetResponseStream();
        StreamReader sr = new StreamReader(s);
        string str = sr.ReadToEnd();
        sr.Close();
        s.Close();
        res.Close();
        req.Abort();
        return str;
    }

    public static string GetToken()
    {
        DateTime nowDate = DateTime.Now;
        if (nowDate - tokenTime > new TimeSpan(0, 10, 0))
        {
            token = ForceGetToken();
        }
        return token;
    }

    public static string ForceGetToken()
    {
        DateTime nowDate = DateTime.Now;
        token = GetAccessToken(System.Configuration.ConfigurationSettings.AppSettings["wxappid"].Trim(),
                System.Configuration.ConfigurationSettings.AppSettings["wxappsecret"].Trim());
        tokenTime = nowDate;
        return token;

    }

    public static string GetAccessToken(string appId, string appSecret)
    {
        string token = "";
        string url = "https://api.weixin.qq.com/cgi-bin/token?grant_type=client_credential&appid=" + appId.Trim() + "&secret=" + appSecret.Trim();
        HttpWebRequest req = (HttpWebRequest)WebRequest.Create(url);
        HttpWebResponse res = (HttpWebResponse)req.GetResponse();
        Stream s = res.GetResponseStream();
        string ret = (new StreamReader(s)).ReadToEnd();
        s.Close();
        res.Close();
        req.Abort();

        JavaScriptSerializer serializer = new JavaScriptSerializer();
        Dictionary<string, object> json = (Dictionary<string, object>)serializer.DeserializeObject(ret);
        object v;
        json.TryGetValue("access_token", out v);
        token = v.ToString();

        return token;
    }

    public static string GetSimpleJsonValueByKey(string jsonStr, string key)
    {
        JavaScriptSerializer serializer = new JavaScriptSerializer();
        Dictionary<string, object> json = (Dictionary<string, object>)serializer.DeserializeObject(jsonStr);
        object v;
        json.TryGetValue(key, out v);
        return v.ToString();
    }
}