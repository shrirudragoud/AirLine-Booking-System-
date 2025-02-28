using System;
using System.Data;
using System.Data.SqlClient;
using System.Configuration;
using System.Web.UI;
using System.Web.UI.WebControls;

public partial class Available_seats : System.Web.UI.Page
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

            LoadFlights();

            // If flightId is passed in query string, select it
            string flightId = Request.QueryString["flightId"];
            if (!string.IsNullOrEmpty(flightId))
            {
                FlightList.SelectedValue = flightId;
                LoadSeatMap();
            }
        }
    }

    private void LoadFlights()
    {
        using (SqlConnection conn = new SqlConnection(ConfigurationManager.ConnectionStrings["conn"].ConnectionString))
        {
            try
            {
                conn.Open();
                using (SqlCommand cmd = new SqlCommand(@"
                    SELECT FlightID, 
                           FlightNumber + ' - ' + Origin + ' to ' + Destination + 
                           ' (' + FORMAT(DepartureTime, 'MMM dd, yyyy hh:mm tt') + ')' as FlightDetails
                    FROM Flights 
                    ORDER BY DepartureTime", conn))
                {
                    FlightList.Items.Clear();
                    FlightList.Items.Add(new ListItem("-- Select Flight --", ""));

                    using (SqlDataReader reader = cmd.ExecuteReader())
                    {
                        while (reader.Read())
                        {
                            string value = reader["FlightID"].ToString();
                            string text = reader["FlightDetails"].ToString();
                            FlightList.Items.Add(new ListItem(text, value));
                        }
                    }
                }
            }
            catch (Exception ex)
            {
                System.Diagnostics.Debug.WriteLine("Error loading flights: " + ex.Message);
            }
        }
    }

    private void LoadSeatMap()
    {
        if (string.IsNullOrEmpty(FlightList.SelectedValue))
            return;

        using (SqlConnection conn = new SqlConnection(ConfigurationManager.ConnectionStrings["conn"].ConnectionString))
        {
            try
            {
                conn.Open();
                using (SqlCommand cmd = new SqlCommand(@"
                    SELECT SeatID, SeatNumber, IsAvailable
                    FROM Seats
                    WHERE FlightID = @FlightID
                    ORDER BY SeatNumber", conn))
                {
                    cmd.Parameters.AddWithValue("@FlightID", FlightList.SelectedValue);

                    using (SqlDataAdapter da = new SqlDataAdapter(cmd))
                    {
                        DataTable dt = new DataTable();
                        da.Fill(dt);

                        if (dt.Rows.Count > 0)
                        {
                            SeatMapRepeater.DataSource = dt;
                            SeatMapRepeater.DataBind();
                        }
                        else
                        {
                            // No seats found
                            SeatMapRepeater.DataSource = null;
                            SeatMapRepeater.DataBind();
                        }
                    }
                }

                // Get flight details for header
                using (SqlCommand cmd = new SqlCommand(@"
                    SELECT FlightNumber, Origin, Destination, 
                           FORMAT(DepartureTime, 'MMM dd, yyyy hh:mm tt') as DepartureTime
                    FROM Flights
                    WHERE FlightID = @FlightID", conn))
                {
                    cmd.Parameters.AddWithValue("@FlightID", FlightList.SelectedValue);
                    using (SqlDataReader reader = cmd.ExecuteReader())
                    {
                        if (reader.Read())
                        {
                            string flightDetails = string.Format("Flight {0} - {1} to {2} ({3})",
                                reader["FlightNumber"],
                                reader["Origin"],
                                reader["Destination"],
                                reader["DepartureTime"]);
                            
                            SelectedSeatInfo.Text = flightDetails;
                            SelectedSeatInfo.Visible = true;
                        }
                    }
                }
            }
            catch (Exception ex)
            {
                System.Diagnostics.Debug.WriteLine("Error loading seat map: " + ex.Message);
            }
        }
    }

    protected void FlightList_SelectedIndexChanged(object sender, EventArgs e)
    {
        LoadSeatMap();
    }
}
