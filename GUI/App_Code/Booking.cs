using System.Collections.Generic;
using System;

[Serializable]
public class BookingsData
{
    public List<Booking> bookings { get; set; }
}

[Serializable]
public class Booking
{
    public string bookingId { get; set; }
    public string passengerName { get; set; }
    public string flightNumber { get; set; }
    public string from { get; set; }
    public string to { get; set; }
    public string date { get; set; }
    public string @class { get; set; }
    public string seatNumber { get; set; }
    public string status { get; set; }
}