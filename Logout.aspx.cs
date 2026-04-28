using System;
using System.Web;

public partial class Logout : System.Web.UI.Page
{
    protected void Page_Load(object sender, EventArgs e)
    {
                Session.Clear();

        
        Session.Abandon();

       
        if (Request.Cookies["ASP.NET_SessionId"] != null)
        {
            Response.Cookies["ASP.NET_SessionId"].Value = string.Empty;
            Response.Cookies["ASP.NET_SessionId"].Expires = DateTime.Now.AddMonths(-20);
        }

        
        Response.Redirect("Default.aspx", false);
        Context.ApplicationInstance.CompleteRequest();
    }
}