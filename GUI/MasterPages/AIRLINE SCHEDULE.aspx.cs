﻿using System;
using System.Data;
using System.Data.SqlClient;
using System.Configuration;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Diagnostics;

public partial class AIRLINE_SCHEDULE : System.Web.UI.Page
{
    protected void Page_Load(object sender, EventArgs e)
    {
        if (!IsPostBack)
        {
            Debug.WriteLine("Initial page load - checking database connection...");
            try
            {
                LoadCities();
                LoadFlights();
                Debug.WriteLine("Initial data load complete");
            }
            catch (Exception ex)
            {
                Debug.WriteLine("Error in Page_Load: " + ex.Message);
                Debug.WriteLine("Stack trace: " + ex.StackTrace);
                // Show error in debug mode only
                if (Request.IsLocal)
                {
                    Response.Write(string.Format("<div class='alert alert-danger'>Error: {0}</div>", ex.Message));
                }
            }
        }
    }

    private void LoadCities()
    {
        string connString = ConfigurationManager.ConnectionStrings["conn"].ConnectionString;
        Debug.WriteLine("Using connection string: " + connString);

        using (SqlConnection conn = new SqlConnection(connString))
        {
            try
            {
                conn.Open();
                Debug.WriteLine("Database connection opened successfully");
                
                // Load Origins
                using (SqlCommand cmd = new SqlCommand(@"
                    SELECT DISTINCT Origin 
                    FROM Flights 
                    WHERE DepartureTime > GETDATE()
                    ORDER BY Origin", conn))
                {
                    FromCity.Items.Clear();
                    FromCity.Items.Add(new ListItem("All Cities", ""));
                    
                    using (SqlDataReader reader = cmd.ExecuteReader())
                    {
                        while (reader.Read())
                        {
                            string city = reader["Origin"].ToString();
                            FromCity.Items.Add(new ListItem(city));
                            Debug.WriteLine(string.Format("Added origin city: {0}", city));
                        }
                    }
                }

                // Load Destinations
                using (SqlCommand cmd = new SqlCommand(@"
                    SELECT DISTINCT Destination 
                    FROM Flights 
                    WHERE DepartureTime > GETDATE()
                    ORDER BY Destination", conn))
                {
                    ToCity.Items.Clear();
                    ToCity.Items.Add(new ListItem("All Cities", ""));
                    
                    using (SqlDataReader reader = cmd.ExecuteReader())
                    {
                        while (reader.Read())
                        {
                            string city = reader["Destination"].ToString();
                            ToCity.Items.Add(new ListItem(city));
                            Debug.WriteLine(string.Format("Added destination city: {0}", city));
                        }
                    }
                }
            }
            catch (Exception ex)
            {
                Debug.WriteLine("Error in LoadCities: " + ex.Message);
                Debug.WriteLine("Stack trace: " + ex.StackTrace);
                throw; // Rethrow to handle in Page_Load
            }
        }
    }

    private void LoadFlights()
    {
        string connString = ConfigurationManager.ConnectionStrings["conn"].ConnectionString;

        using (SqlConnection conn = new SqlConnection(connString))
        {
            try
            {
                conn.Open();
                Debug.WriteLine("Loading flights with filters...");

                string query = @"
                    SELECT 
                        f.FlightID,
                        f.FlightNumber,
                        f.FlightName,
                        f.Origin,
                        f.Destination,
                        f.DepartureTime,
                        f.ArrivalTime,
                        f.BasePrice,
                        (SELECT COUNT(*) FROM Seats s WHERE s.FlightID = f.FlightID AND s.IsAvailable = 1) as AvailableSeats
                    FROM Flights f
                    WHERE DepartureTime > GETDATE()";

                // Apply filters
                if (!string.IsNullOrEmpty(FromCity.SelectedValue))
                {
                    query += " AND Origin = @Origin";
                    Debug.WriteLine("Filtering by Origin: " + FromCity.SelectedValue);
                }
                if (!string.IsNullOrEmpty(ToCity.SelectedValue))
                {
                    query += " AND Destination = @Destination";
                    Debug.WriteLine("Filtering by Destination: " + ToCity.SelectedValue);
                }

                // Apply sorting
                switch (SortBy.SelectedValue)
                {
                    case "price":
                        query += " ORDER BY BasePrice ASC";
                        break;
                    case "price_desc":
                        query += " ORDER BY BasePrice DESC";
                        break;
                    case "duration":
                        query += " ORDER BY DATEDIFF(MINUTE, DepartureTime, ArrivalTime)";
                        break;
                    default:
                        query += " ORDER BY DepartureTime";
                        break;
                }

                Debug.WriteLine("Executing query: " + query);

                using (SqlCommand cmd = new SqlCommand(query, conn))
                {
                    if (!string.IsNullOrEmpty(FromCity.SelectedValue))
                    {
                        cmd.Parameters.AddWithValue("@Origin", FromCity.SelectedValue);
                    }
                    if (!string.IsNullOrEmpty(ToCity.SelectedValue))
                    {
                        cmd.Parameters.AddWithValue("@Destination", ToCity.SelectedValue);
                    }

                    using (SqlDataAdapter da = new SqlDataAdapter(cmd))
                    {
                        DataTable dt = new DataTable();
                        da.Fill(dt);
                        Debug.WriteLine(string.Format("Found {0} flights", dt.Rows.Count));
                        
                        FlightsList.DataSource = dt;
                        FlightsList.DataBind();
                    }
                }
            }
            catch (Exception ex)
            {
                Debug.WriteLine("Error in LoadFlights: " + ex.Message);
                Debug.WriteLine("Stack trace: " + ex.StackTrace);
                throw; // Rethrow to handle in Page_Load
            }
        }
    }

    protected void Filter_Changed(object sender, EventArgs e)
    {
        try
        {
            Debug.WriteLine("Filter changed - reloading flights");
            Debug.WriteLine(string.Format("From: {0}, To: {1}, Sort: {2}", 
                FromCity.SelectedValue, 
                ToCity.SelectedValue, 
                SortBy.SelectedValue));
            LoadFlights();
        }
        catch (Exception ex)
        {
            Debug.WriteLine("Error in Filter_Changed: " + ex.Message);
            if (Request.IsLocal)
            {
                Response.Write(string.Format("<div class='alert alert-danger'>Filter Error: {0}</div>", ex.Message));
            }
        }
    }

    protected string GetFlightDuration(object departureTime, object arrivalTime)
    {
        if (departureTime != DBNull.Value && arrivalTime != DBNull.Value)
        {
            DateTime departure = Convert.ToDateTime(departureTime);
            DateTime arrival = Convert.ToDateTime(arrivalTime);
            TimeSpan duration = arrival - departure;
            return string.Format("{0}h {1}m", (int)duration.TotalHours, duration.Minutes);
        }
        return string.Empty;
    }

    protected void FlightsList_ItemCommand(object source, RepeaterCommandEventArgs e)
    {
        if (e.CommandName == "BookFlight")
        {
            string flightId = e.CommandArgument.ToString();
            Debug.WriteLine(string.Format("Booking flight ID: {0}", flightId));
            Response.Redirect(string.Format("~/MasterPages/TicketBooking2.aspx?flightId={0}", flightId));
        }
    }
}
