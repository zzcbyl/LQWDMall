using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.Script.Serialization;

/// <summary>
///MyToken 的摘要说明
/// </summary>
public class MyToken
{
	public MyToken()
	{
		//
		//TODO: 在此处添加构造函数逻辑
		//
	}

    private static DateTime tokenTime = DateTime.MinValue;
    private static string token = "";

    public static string GetToken(string openid)
    {
        DateTime nowTime = DateTime.Now;
        if (nowTime >= tokenTime)
        {
            token = ForceGetToken(openid);
        }
        return token;
    }

    private static string ForceGetToken(string openid)
    {
        JavaScriptSerializer json = new JavaScriptSerializer();
        string tokenUrl = Util.ApiDomainString + "api/user_get_token.aspx?username=" + openid;
        string tokenResult = HTTPHelper.Get_Http(tokenUrl);
        Dictionary<string, object> dic = (Dictionary<string, object>)json.DeserializeObject(tokenResult);
        if (dic["status"].Equals("0"))
            ForceGetToken(openid);

        tokenTime = DateTime.Parse(dic["expire_date"].ToString());
        return dic["token"].ToString();
    }
}