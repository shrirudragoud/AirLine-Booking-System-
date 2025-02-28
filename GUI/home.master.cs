using System;
using System.Web.UI;
using System.Web.UI.WebControls;

public partial class home : System.Web.UI.MasterPage
{
    protected void Page_Load(object sender, EventArgs e)
    {
        if (!IsPostBack)
        {
            if (Session["Username"] != null)
            {
                ShowLoggedInControls();
            }
            else
            {
                HideLoggedInControls();
            }

            SetActiveNavigation();
        }
    }

    private void ShowLoggedInControls()
    {
        if (LogoutBtn != null)
        {
            LogoutBtn.Visible = true;
        }
    }

    private void HideLoggedInControls()
    {
        if (LogoutBtn != null)
        {
            LogoutBtn.Visible = false;
        }
    }

    private void SetActiveNavigation()
    {
        string currentPage = Request.Url.AbsolutePath.ToLower();

        // Reset all navigation links
        HomeLink.CssClass = "nav-link";
        FlightsLink.CssClass = "nav-link";
        SeatsLink.CssClass = "nav-link";
        ContactLink.CssClass = "nav-link";

        // Set active class based on current page
        if (currentPage.EndsWith("home.aspx"))
        {
            HomeLink.CssClass += " active";
        }
        else if (currentPage.EndsWith("airline schedule.aspx"))
        {
            FlightsLink.CssClass += " active";
        }
        else if (currentPage.EndsWith("available seats.aspx"))
        {
            SeatsLink.CssClass += " active";
        }
        else if (currentPage.EndsWith("contactus.aspx"))
        {
            ContactLink.CssClass += " active";
        }
    }

    protected void LogoutBtn_Click(object sender, EventArgs e)
    {
        Session.Clear();
        Session.Abandon();
        Response.Redirect("~/MasterPages/login.aspx");
    }
}