using System;
using System.Data;
using System.Data.SqlClient;
using System.Configuration;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Diagnostics;

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
                    WHERE DepartureTime > GETDATE()
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
            using (SqlConnection conn = new SqlConnection(ConfigurationManager.ConnectionStrings["conn"].ConnectionString))
            {
                try
                {
                    conn.Open();
                    using (SqlCommand cmd = new SqlCommand(@"
                        INSERT INTO Bookings (PassengerName, FlightId, FlightName, FromStation, ToStation, 
                                            Category, TravelDateTime, Username)
                        VALUES (@PassengerName, @FlightId, @FlightName, @FromStation, @ToStation, 
                                @Category, @TravelDateTime, @Username)", conn))
                    {
                        cmd.Parameters.AddWithValue("@PassengerName", TextBox1.Text.Trim());
                        cmd.Parameters.AddWithValue("@FlightId", DropDownList1.SelectedValue);
                        cmd.Parameters.AddWithValue("@FlightName", DropDownList2.SelectedValue);
                        cmd.Parameters.AddWithValue("@FromStation", DropDownList3.SelectedValue);
                        cmd.Parameters.AddWithValue("@ToStation", DropDownList4.SelectedValue);
                        cmd.Parameters.AddWithValue("@Category", DropDownList5.SelectedValue);
                        cmd.Parameters.AddWithValue("@TravelDateTime", DropDownList6.SelectedValue);
                        cmd.Parameters.AddWithValue("@Username", Session["Username"].ToString());

                        cmd.ExecuteNonQuery();

                        ShowSuccess("Ticket booked successfully!");
                        ClearForm();
                    }
                }
                catch (Exception ex)
                {
                    ShowError("Error booking ticket: " + ex.Message);
                }
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
