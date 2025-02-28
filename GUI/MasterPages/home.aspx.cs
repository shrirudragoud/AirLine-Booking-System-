using System;
using System.Data;
using System.Data.SqlClient;
using System.Configuration;
using System.Web.UI;
using System.Web.UI.WebControls;

public partial class home : System.Web.UI.Page
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

            LoadCities();
            LoadFeaturedFlights();
            LoadPopularDestinations();

            // Set default departure date to tomorrow
            DepartureDate.Text = DateTime.Now.AddDays(1).ToString("yyyy-MM-dd");
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
                    FromCity.Items.Clear();
                    FromCity.Items.Add(new ListItem("Select Departure City", ""));
                    using (SqlDataReader reader = cmd.ExecuteReader())
                    {
                        while (reader.Read())
                        {
                            FromCity.Items.Add(reader["Origin"].ToString());
                        }
                    }
                }

                // Load Destinations
                using (SqlCommand cmd = new SqlCommand("SELECT DISTINCT Destination FROM Flights ORDER BY Destination", conn))
                {
                    ToCity.Items.Clear();
                    ToCity.Items.Add(new ListItem("Select Arrival City", ""));
                    using (SqlDataReader reader = cmd.ExecuteReader())
                    {
                        while (reader.Read())
                        {
                            ToCity.Items.Add(reader["Destination"].ToString());
                        }
                    }
                }
            }
            catch (Exception ex)
            {
                System.Diagnostics.Debug.WriteLine("Error loading cities: " + ex.Message);
            }
        }
    }

    private void LoadFeaturedFlights()
    {
        using (SqlConnection conn = new SqlConnection(ConfigurationManager.ConnectionStrings["conn"].ConnectionString))
        {
            try
            {
                conn.Open();
                using (SqlCommand cmd = new SqlCommand(@"
                    SELECT TOP 4 FlightID, FlightNumber, Origin, Destination, 
                           DepartureTime, ArrivalTime, BasePrice, FlightName
                    FROM Flights 
                    WHERE DepartureTime > GETDATE()
                    ORDER BY BasePrice ASC", conn))
                {
                    using (SqlDataAdapter da = new SqlDataAdapter(cmd))
                    {
                        DataTable dt = new DataTable();
                        da.Fill(dt);
                        FeaturedFlights.DataSource = dt;
                        FeaturedFlights.DataBind();
                    }
                }
            }
            catch (Exception ex)
            {
                System.Diagnostics.Debug.WriteLine("Error loading featured flights: " + ex.Message);
            }
        }
    }

    private void LoadPopularDestinations()
    {
        using (SqlConnection conn = new SqlConnection(ConfigurationManager.ConnectionStrings["conn"].ConnectionString))
        {
            try
            {
                conn.Open();
                using (SqlCommand cmd = new SqlCommand(@"
                    SELECT DISTINCT TOP 6 Destination, MIN(BasePrice) as BasePrice
                    FROM Flights
                    WHERE DepartureTime > GETDATE()
                    GROUP BY Destination
                    ORDER BY MIN(BasePrice)", conn))
                {
                    using (SqlDataAdapter da = new SqlDataAdapter(cmd))
                    {
                        DataTable dt = new DataTable();
                        da.Fill(dt);
                        DestinationsRepeater.DataSource = dt;
                        DestinationsRepeater.DataBind();
                    }
                }
            }
            catch (Exception ex)
            {
                System.Diagnostics.Debug.WriteLine("Error loading destinations: " + ex.Message);
            }
        }
    }

    protected string GetDestinationImage(object dataItem)
    {
        DataRowView row = (DataRowView)dataItem;
        string destination = row["Destination"].ToString().ToLower();
        return string.Format("../Images/destinations/{0}.jpg", destination);
    }

    protected string FormatTime(object time)
    {
        if (time != null && time != DBNull.Value)
        {
            return Convert.ToDateTime(time).ToString("hh:mm tt");
        }
        return string.Empty;
    }

    protected void SearchFlights_Click(object sender, EventArgs e)
    {
        string queryString = string.Format("~/MasterPages/AIRLINE SCHEDULE.aspx?from={0}&to={1}&date={2}&passengers={3}",
            Server.UrlEncode(FromCity.SelectedValue),
            Server.UrlEncode(ToCity.SelectedValue),
            Server.UrlEncode(DepartureDate.Text),
            Server.UrlEncode(PassengerCount.SelectedValue));
        
        Response.Redirect(queryString);
    }

    protected void BookNow_Click(object sender, EventArgs e)
    {
        Button btn = (Button)sender;
        string flightId = btn.CommandArgument;
        Response.Redirect(string.Format("~/MasterPages/TicketBooking2.aspx?flightId={0}", flightId));
    }

    protected void ExploreBtn_Click(object sender, EventArgs e)
    {
        Button btn = (Button)sender;
        string destination = btn.CommandArgument;
        Response.Redirect(string.Format("~/MasterPages/AIRLINE SCHEDULE.aspx?to={0}", 
            Server.UrlEncode(destination)));
    }
}