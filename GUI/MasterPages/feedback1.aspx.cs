using System;
using System.Web.UI;

public partial class feedback1 : System.Web.UI.Page
{
    protected void Page_Load(object sender, EventArgs e)
    {
        if (!IsPostBack)
        {
            if (Session["Username"] == null)
            {
                Response.Redirect("~/MasterPages/login.aspx");
            }
        }
    }
}
