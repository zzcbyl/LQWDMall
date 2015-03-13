using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

/// <summary>
/// Summary description for User
/// </summary>
[Serializable]
public class Users
{
	public Users()
	{
		//
		// TODO: Add constructor logic here
		//
	}

    public int ID { get; set; }
    public string Name { get; set; }
    public string Sex { get; set; }  
}