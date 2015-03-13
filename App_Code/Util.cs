using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

/// <summary>
/// Summary description for Util
/// </summary>
public class Util
{

    public static string ConnectionString = System.Configuration.ConfigurationSettings.AppSettings["constr"].Trim();


	public Util()
	{
		//
		// TODO: Add constructor logic here
		//
	}
}