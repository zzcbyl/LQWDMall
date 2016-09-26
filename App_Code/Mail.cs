using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Net.Mail;

/// <summary>
///Mail 的摘要说明
/// </summary>
public class Mail
{
    public Mail()
    {
        //
        //TODO: 在此处添加构造函数逻辑
        //
    }

    /// <summary>
    /// 多线程调用
    /// </summary>
    /// <param name="obj"></param>
    public static void SendMailAsyn(object obj)
    {
        string[] parameter = obj as string[];
        SendMail(parameter[0], parameter[1], parameter[2], parameter[3], parameter[4], parameter[5], parameter[6]);
    }

    public static void SendMail(string strFrom, string strFromPass, string strTo, string strSubject, string strBody, string strSmtpServer, string strFileName = "", string displayName = "悦长大平台")
    {
        MailAddress from = new MailAddress(strFrom, displayName);
        MailAddress to = new MailAddress(strTo);
        System.Net.Mail.MailMessage message = new System.Net.Mail.MailMessage(from, to);
        message.Subject = strSubject;
        message.SubjectEncoding = System.Text.Encoding.UTF8;
        message.Body = strBody;
        message.BodyEncoding = System.Text.Encoding.UTF8;
        message.IsBodyHtml = true;
        if (strFileName != "" && strFileName != null)
        {
            Attachment data = new Attachment(strFileName);
            message.Attachments.Add(data);
        }

        try
        {
            SmtpClient client = new SmtpClient(strSmtpServer);
            client.UseDefaultCredentials = true;
            client.Credentials = new System.Net.NetworkCredential(strFrom, strFromPass);
            client.DeliveryMethod = SmtpDeliveryMethod.Network;
            client.Send(message);
        }
        catch { }
    }
}