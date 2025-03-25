using System;
using System.Data;
using System.Data.SqlClient;
using System.Configuration;
using System.Web.UI;

public partial class Admin : System.Web.UI.Page
{
    protected void Page_Load(object sender, EventArgs e)
    {
        if (!IsPostBack)
        {
            if (Session["Username"] == null)
            {
                Response.Redirect("~/MasterPages/login.aspx");
            }
            Label1.Visible = false;
        }
    }

    protected void Button1_Click(object sender, EventArgs e)
    {
        string username = TextBox1.Text.Trim();
        string password = TextBox2.Text.Trim();

        if (username == "admin" && password == "admin123")
        {
            Session["AdminUser"] = "admin";
            Response.Redirect("~/MasterPages/AIRLINE SCHEDULE.aspx");
        }
        else
        {
            Label1.Text = "Invalid admin credentials";
            Label1.Visible = true;
            Label1.ForeColor = System.Drawing.Color.Red;
        }
    }
}