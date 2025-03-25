using System;
using System.Data;
using System.Data.SqlClient;
using System.Configuration;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Diagnostics;
using System.Collections.Generic;
using System.Web.Script.Serialization;

public partial class TicketBooking2 : System.Web.UI.Page
{
    protected void Page_Load(object sender, EventArgs e)
    {
        if (!IsPostBack)
        {
            if (Session["Username"] == null)
            {
                Response.Redirect("~/MasterPages/login.aspx");
                return;
            }

            LoadFlightNumbers();
            LoadCities();
            LoadAirlines();
            SetInitialSummary();

            // If flightId is passed in query string, select it
            string flightId = Request.QueryString["flightId"];
            if (!string.IsNullOrEmpty(flightId))
            {
                DropDownList1.SelectedValue = flightId;
                DropDownList1_SelectedIndexChanged(null, null);
            }
        }
    }

    private void LoadFlightNumbers()
    {
        using (SqlConnection conn = new SqlConnection(ConfigurationManager.ConnectionStrings["conn"].ConnectionString))
        {
            try
            {
                conn.Open();
                using (SqlCommand cmd = new SqlCommand(@"
                    SELECT FlightID, FlightNumber + ' (' + Origin + ' → ' + Destination + ')' as FlightDetails
                    FROM Flights
                    ORDER BY DepartureTime", conn))
                {
                    DropDownList1.Items.Clear();
                    DropDownList1.Items.Add(new ListItem("Select Flight", ""));
                    
                    using (SqlDataReader reader = cmd.ExecuteReader())
                    {
                        while (reader.Read())
                        {
                            string value = reader["FlightID"].ToString();
                            string text = reader["FlightDetails"].ToString();
                            DropDownList1.Items.Add(new ListItem(text, value));
                        }
                    }
                }
            }
            catch (Exception ex)
            {
                ShowError("Error loading flights: " + ex.Message);
            }
        }
    }

    private void LoadCities()
    {
        using (SqlConnection conn = new SqlConnection(ConfigurationManager.ConnectionStrings["conn"].ConnectionString))
        {
            try
            {
                conn.Open();
                
                // Load Origins
                using (SqlCommand cmd = new SqlCommand("SELECT DISTINCT Origin FROM Flights ORDER BY Origin", conn))
                {
                    DropDownList3.Items.Clear();
                    DropDownList3.Items.Add(new ListItem("Select Origin", ""));
                    using (SqlDataReader reader = cmd.ExecuteReader())
                    {
                        while (reader.Read())
                        {
                            DropDownList3.Items.Add(reader["Origin"].ToString());
                        }
                    }
                }

                // Load Destinations
                using (SqlCommand cmd = new SqlCommand("SELECT DISTINCT Destination FROM Flights ORDER BY Destination", conn))
                {
                    DropDownList4.Items.Clear();
                    DropDownList4.Items.Add(new ListItem("Select Destination", ""));
                    using (SqlDataReader reader = cmd.ExecuteReader())
                    {
                        while (reader.Read())
                        {
                            DropDownList4.Items.Add(reader["Destination"].ToString());
                        }
                    }
                }
            }
            catch (Exception ex)
            {
                ShowError("Error loading cities: " + ex.Message);
            }
        }
    }

    private void LoadAirlines()
    {
        DropDownList2.Items.Clear();
        DropDownList2.Items.Add(new ListItem("Select Airline", ""));
        DropDownList2.Items.Add(new ListItem("Air India", "Air India"));
        DropDownList2.Items.Add(new ListItem("Jet Airways", "Jet Airways"));
    }

    private void LoadTravelDates(string flightId)
    {
        using (SqlConnection conn = new SqlConnection(ConfigurationManager.ConnectionStrings["conn"].ConnectionString))
        {
            try
            {
                conn.Open();
                using (SqlCommand cmd = new SqlCommand(@"
                    SELECT DISTINCT FORMAT(DepartureTime, 'MMM dd, yyyy hh:mm tt') as TravelDate
                    FROM Flights
                    WHERE FlightID = @FlightID", conn))
                {
                    cmd.Parameters.AddWithValue("@FlightID", flightId);
                    
                    DropDownList6.Items.Clear();
                    DropDownList6.Items.Add(new ListItem("Select Date", ""));
                    
                    using (SqlDataReader reader = cmd.ExecuteReader())
                    {
                        while (reader.Read())
                        {
                            DropDownList6.Items.Add(reader["TravelDate"].ToString());
                        }
                    }
                }
            }
            catch (Exception ex)
            {
                ShowError("Error loading travel dates: " + ex.Message);
            }
        }
    }

    protected void DropDownList1_SelectedIndexChanged(object sender, EventArgs e)
    {
        if (string.IsNullOrEmpty(DropDownList1.SelectedValue))
            return;

        using (SqlConnection conn = new SqlConnection(ConfigurationManager.ConnectionStrings["conn"].ConnectionString))
        {
            try
            {
                conn.Open();
                using (SqlCommand cmd = new SqlCommand(@"
                    SELECT FlightName, Origin, Destination, 
                           FORMAT(DepartureTime, 'MMM dd, yyyy hh:mm tt') as TravelDate
                    FROM Flights
                    WHERE FlightID = @FlightID", conn))
                {
                    cmd.Parameters.AddWithValue("@FlightID", DropDownList1.SelectedValue);
                    using (SqlDataReader reader = cmd.ExecuteReader())
                    {
                        if (reader.Read())
                        {
                            DropDownList2.SelectedValue = reader["FlightName"].ToString();
                            DropDownList3.SelectedValue = reader["Origin"].ToString();
                            DropDownList4.SelectedValue = reader["Destination"].ToString();
                            LoadTravelDates(DropDownList1.SelectedValue);
                            UpdateSummary();
                        }
                    }
                }
            }
            catch (Exception ex)
            {
                ShowError("Error loading flight details: " + ex.Message);
            }
        }
    }

    protected void SelectSeatBtn_Click(object sender, EventArgs e)
    {
        if (!string.IsNullOrEmpty(DropDownList1.SelectedValue))
        {
            Response.Redirect(string.Format("~/MasterPages/Available seats.aspx?flightId={0}", DropDownList1.SelectedValue));
        }
        else
        {
            ShowError("Please select a flight first");
        }
    }

    protected void Button1_Click(object sender, EventArgs e)
    {
        if (Page.IsValid)
        {
            try
            {
                string jsonPath = Server.MapPath("~/App_Data/bookings.json");
                BookingsData bookingsData;
                var serializer = new JavaScriptSerializer();

                // Read existing bookings
                if (System.IO.File.Exists(jsonPath))
                {
                    string jsonContent = System.IO.File.ReadAllText(jsonPath);
                    bookingsData = serializer.Deserialize<BookingsData>(jsonContent);
                }
                else
                {
                    bookingsData = new BookingsData { bookings = new List<Booking>() };
                }

                // Generate new booking ID
                string newBookingId = "BK" + (bookingsData.bookings.Count + 1).ToString("D3");

                // Create new booking
                var booking = new Booking
                {
                    bookingId = newBookingId,
                    passengerName = TextBox1.Text.Trim(),
                    flightNumber = DropDownList1.SelectedValue,
                    from = DropDownList3.SelectedValue,
                    to = DropDownList4.SelectedValue,
                    date = DropDownList6.SelectedValue,
                    @class = DropDownList5.SelectedValue,
                    seatNumber = "Auto",  // This could be improved to actually select a seat
                    status = "Confirmed"
                };

                // Add to bookings list
                bookingsData.bookings.Add(booking);

                // Save back to file
                string updatedJson = serializer.Serialize(bookingsData);
                System.IO.File.WriteAllText(jsonPath, updatedJson);

                ShowSuccess("Ticket booked successfully!");
                ClearForm();

                // Redirect to view the ticket
                Response.Redirect(string.Format("ViewTicket.aspx?bookingId={0}", newBookingId));
            }
            catch (Exception ex)
            {
                ShowError("Error booking ticket: " + ex.Message);
            }
        }
    }

    private void ShowSuccess(string message)
    {
        BookingStatus.Text = message;
        BookingStatus.CssClass = "booking-status success";
        
        // Add client-side notification - wrapping in try-catch for safety
        try
        {
            ScriptManager.RegisterStartupScript(this, GetType(), "ShowNotification",
                string.Format("showNotification('{0}');", message.Replace("'", "\\'")), true);
        }
        catch (Exception ex)
        {
            Debug.WriteLine("Error registering notification script: " + ex.Message);
        }
    }

    private void ShowError(string message)
    {
        BookingStatus.Text = message;
        BookingStatus.CssClass = "booking-status error";
    }

    private void ClearForm()
    {
        TextBox1.Text = "";
        DropDownList1.SelectedIndex = 0;
        DropDownList2.SelectedIndex = 0;
        DropDownList3.SelectedIndex = 0;
        DropDownList4.SelectedIndex = 0;
        DropDownList5.SelectedIndex = 0;
        DropDownList6.SelectedIndex = 0;
        SetInitialSummary();
    }

    private void SetInitialSummary()
    {
        SummaryPassenger.Text = "Not selected";
        SummaryFlight.Text = "Not selected";
        SummaryRoute.Text = "Not selected";
        SummaryDate.Text = "Not selected";
        SummaryClass.Text = "Not selected";
    }

    private void UpdateSummary()
    {
        SummaryPassenger.Text = TextBox1.Text.Trim();
        SummaryFlight.Text = DropDownList1.SelectedItem.Text;
        SummaryRoute.Text = string.Format("{0} → {1}", 
            DropDownList3.SelectedValue, 
            DropDownList4.SelectedValue);
        SummaryDate.Text = DropDownList6.SelectedValue;
        SummaryClass.Text = DropDownList5.SelectedValue;
    }
}
