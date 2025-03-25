using System;
using System.Web.UI;
using System.IO;
using System.Web.Script.Serialization;
using System.Linq;

public partial class ViewTicket : System.Web.UI.Page
{
    protected void Page_Load(object sender, EventArgs e)
    {
        if (!IsPostBack)
        {
            string bookingId = Request.QueryString["bookingId"];
            if (!string.IsNullOrEmpty(bookingId))
            {
                LoadTicketDetails(bookingId);
            }
            else
            {
                Response.Redirect("MyBookings.aspx");
            }
        }
    }

    private void LoadTicketDetails(string bookingId)
    {
        try
        {
            string jsonPath = Server.MapPath("~/App_Data/bookings.json");
            if (File.Exists(jsonPath))
            {
                string jsonContent = File.ReadAllText(jsonPath);
                var serializer = new JavaScriptSerializer();
                var bookingsData = serializer.Deserialize<BookingsData>(jsonContent);
                
                var booking = bookingsData.bookings.FirstOrDefault(b => b.bookingId == bookingId);
                if (booking != null)
                {
                    // Populate the ticket details
                    BookingIdLabel.Text = booking.bookingId;
                    PassengerNameLabel.Text = booking.passengerName;
                    FlightNumberLabel.Text = booking.flightNumber;
                    ClassLabel.Text = booking.@class;
                    SeatLabel.Text = booking.seatNumber;
                    DateLabel.Text = Convert.ToDateTime(booking.date).ToString("MMMM dd, yyyy");
                    FromLabel.Text = booking.from;
                    ToLabel.Text = booking.to;
                }
                else
                {
                    Response.Redirect("MyBookings.aspx");
                }
            }
        }
        catch (Exception ex)
        {
            // In production, log this error properly
            System.Diagnostics.Debug.WriteLine(string.Format("Error loading ticket details: {0}", ex.Message));
            Response.Redirect("MyBookings.aspx");
        }
    }
}