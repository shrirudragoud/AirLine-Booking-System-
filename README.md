# Airline Reservation System

It is a web-based implementation of ASP.NET with C# and SQL Server that allows users to book flights, manage reservations, and generate reports.

## Development Environment
- Microsoft Visual Studio 2015
- SQL Server Management Studio 2012

## Features

- User Authentication and Authorization
- Flight Booking Management
- Seat Selection
- Booking History
- Report Generation
- Feedback System

## Report Generation

### Booking Reports
The system includes a report generation feature that converts booking data into professionally formatted reports:

```bash
# Generate the report
node Scripts/generate-report.js
```

This will create:
1. An HTML report (report.html) that can be:
   - Viewed in any web browser
   - Printed to PDF using browser's print function (Ctrl+P)
   - Styled with a professional layout
   - Contains all booking details including:
     - Booking ID
     - Passenger Information
     - Flight Details
     - Seat Assignment
     - Booking Status

The report automatically formats the data from `App_Data/bookings.json` into a clean, professional layout with:
- Header section with timestamp and total bookings
- Individual booking cards with complete details
- Responsive design for various screen sizes
- Print-friendly formatting

To generate and view a report:
1. Run `node Scripts/generate-report.js`
2. Open `report.html` in your browser
3. To save as PDF:
   - Press Ctrl+P in your browser
   - Select "Save as PDF" as the destination
   - Click Save

The generated report provides a comprehensive view of all bookings in the system, perfect for administrative review and record-keeping.
