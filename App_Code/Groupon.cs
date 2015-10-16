using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Data;

/// <summary>
/// Summary description for Groupon
/// </summary>
public class Groupon
{
    public DataRow _field;

	public Groupon(int id)
	{
        DataTable dt = DBHelper.GetDataTable(" select * from m_groupon where [id] = " + id.ToString(), Util.ConnectionString);
        _field = dt.Rows[0];
	}

    public int ID
    {
        get
        {
            return int.Parse(_field["id"].ToString().Trim());
        }
    }

    public DateTime StartDateTime
    {
        get
        {
            return DateTime.Parse(_field["start_date"].ToString().Trim());
        }
    }

    public DateTime EndDateTime
    {
        get
        {
            return DateTime.Parse(_field["end_date"].ToString().Trim());
        }
    }
}