using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Web.Script.Serialization;

public partial class _Default : System.Web.UI.Page
{
    protected void Page_Load(object sender, EventArgs e)
    {
        string prodListStr = HTTPHelper.Get_Http(Util.ApiDomainString + "/api/product_get_all.aspx").Trim();

        prodListStr = prodListStr.Substring(prodListStr.IndexOf("data") + 8);
        prodListStr = prodListStr.Substring(0, prodListStr.Length - 1);

        JavaScriptSerializer json = new JavaScriptSerializer();
        try
        {
            List<Product> list = json.Deserialize<List<Product>>(prodListStr);
            if (list.Count > 0 && list[0].prodid != null)
            {
                this.Repeater1.DataSource = list;
                this.Repeater1.DataBind();
            }
        }
        catch {
            this.nodata.Visible = true;
        }
    }
}