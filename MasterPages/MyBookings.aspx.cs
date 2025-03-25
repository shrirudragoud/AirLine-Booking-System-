using System;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.IO;
using System.Web;
using System.Web.Script.Serialization;
using System.Collections.Generic;

public partial class MyBookings : System.Web.UI.Page
{
    protected void Page_Load(object sender, EventArgs e)
    {
        if (!IsPostBack)
        {
            LoadBookings();
        }
    }

    private void LoadBookings()
    {
        try
        {
            string jsonPath = Server.MapPath("~/App_Data/bookings.json");
            if (File.Exists(jsonPath))
            {
                string jsonContent = File.ReadAllText(jsonPath);
                var serializer = new JavaScriptSerializer();
                var bookingsData = serializer.Deserialize<BookingsData>(jsonContent);
                BookingsRepeater.DataSource = bookingsData.bookings;
                BookingsRepeater.DataBind();
            }
        }
        catch (Exception ex)
        {
            // In production, log this error properly
            System.Diagnostics.Debug.WriteLine($"Error loading bookings: {ex.Message}");
        }
    }

    protected void ViewTicket_Click(object sender, EventArgs e)
    {
        Button btn = (Button)sender;
        string bookingId = btn.CommandArgument;
        
        // Redirect to ticket viewer page
        Response.Redirect(string.Format("ViewTicket.aspx?bookingId={0}", bookingId));
    }
}