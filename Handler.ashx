<%@ WebHandler Language="C#" Class="Handler" %>

using System;
using System.Web;
using System.Web.Script.Serialization;
using System.Collections.Generic;

public class Handler : IHttpHandler {
    
    public void ProcessRequest (HttpContext context) {
        context.Response.ContentType = "text/plain";
        if (context.Request["method"] != null && !context.Request["method"].Equals(""))
        {
            switch (context.Request["method"].ToLower())
            {
                case "gettoken":
                    GetToken(context);
                    break;
                case "forcegettoken":
                    ForceGetToken(context);
                    break;
            }
        }
    }
    public void GetToken(HttpContext context)
    {
        if (context.Request["openid"] != null && !context.Request["openid"].Equals(""))
        {
            context.Response.Write(MyToken.GetToken(context.Request["openid"].ToString()));
            return;
        }
        context.Response.Write("-1");
    }

    public void ForceGetToken(HttpContext context)
    {
        if (context.Request["openid"] != null && !context.Request["openid"].Equals(""))
        {
            JavaScriptSerializer json = new JavaScriptSerializer();
            string tokenUrl = Util.ApiDomainString + "api/user_get_token.aspx?username=" + context.Request["openid"].ToString();
            string tokenResult = HTTPHelper.Get_Http(tokenUrl);
            Dictionary<string, object> tokendic = (Dictionary<string, object>)json.DeserializeObject(tokenResult);
            if (tokendic["status"].Equals("1"))
                ForceGetToken(context);

            context.Response.Write(tokendic["token"].ToString());
            return;
        }
        context.Response.Write("-1");
    }
    
    public bool IsReusable {
        get {
            return false;
        }
    }

}