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

    //Dictionary<openid, KeyValuePair<expire_date, token>>
    private static Dictionary<string, KeyValuePair<DateTime, string>> dic = new Dictionary<string, KeyValuePair<DateTime, string>>();

    public static string GetToken(string openid)
    {
        string token = "";
        DateTime nowTime = DateTime.Now;
        if (dic.ContainsKey(openid))
        {
            if (nowTime >= dic[openid].Key)
            {
                token = ForceGetToken(openid);
            }
            else
                token = dic[openid].Value;
        }
        else
            token = ForceGetToken(openid);
        return token;
    }

    private static string ForceGetToken(string openid)
    {
        JavaScriptSerializer json = new JavaScriptSerializer();
        string tokenUrl = Util.ApiDomainString + "api/user_get_token.aspx?username=" + openid;
        string tokenResult = HTTPHelper.Get_Http(tokenUrl);
        Dictionary<string, object> tokendic = (Dictionary<string, object>)json.DeserializeObject(tokenResult);
        if (tokendic["status"].Equals("1"))
            ForceGetToken(openid);

        if (dic.ContainsKey(openid))
            dic[openid] = new KeyValuePair<DateTime, string>(DateTime.Parse(tokendic["expire_date"].ToString()), tokendic["token"].ToString());
        else
            dic.Add(openid, new KeyValuePair<DateTime, string>(DateTime.Parse(tokendic["expire_date"].ToString()), tokendic["token"].ToString()));
        //tokenTime = DateTime.Parse(dic["expire_date"].ToString());
        return tokendic["token"].ToString();
    }
}