// Script to convert bookings.json to an HTML report
const fs = require('fs');
const path = require('path');

// Read bookings.json
const bookingsPath = path.join(__dirname, '..', 'App_Data', 'bookings.json');
const reportPath = path.join(__dirname, '..', 'report.html');

// Read and parse the bookings data
const bookingsData = JSON.parse(fs.readFileSync(bookingsPath, 'utf8'));

// Create HTML content
const htmlContent = `
<!DOCTYPE html>
<html>
<head>
    <title>Airline Booking Report</title>
    <style>
        body {
            font-family: Arial, sans-serif;
            margin: 40px;
            background-color: #f5f5f5;
        }
        .container {
            max-width: 800px;
            margin: 0 auto;
            background: white;
            padding: 20px;
            box-shadow: 0 0 10px rgba(0,0,0,0.1);
        }
        .header {
            text-align: center;
            padding: 20px;
            background: #007bff;
            color: white;
            margin-bottom: 20px;
        }
        .booking {
            border: 1px solid #ddd;
            padding: 15px;
            margin-bottom: 15px;
            border-radius: 5px;
        }
        .booking h3 {
            margin: 0 0 10px 0;
            color: #007bff;
            border-bottom: 2px solid #007bff;
            padding-bottom: 5px;
        }
        .detail {
            margin: 5px 0;
        }
        .footer {
            text-align: center;
            margin-top: 20px;
            padding: 20px;
            color: #666;
        }
        @media print {
            body {
                margin: 0;
                background: white;
            }
            .container {
                box-shadow: none;
            }
        }
    </style>
</head>
<body>
    <div class="container">
        <div class="header">
            <h1>Airline Booking Report</h1>
            <p>Generated on: ${new Date().toLocaleString()}</p>
            <p>Total Bookings: ${bookingsData.bookings.length}</p>
        </div>

        ${bookingsData.bookings.map((booking, index) => `
            <div class="booking">
                <h3>Booking #${index + 1} (${booking.bookingId})</h3>
                <div class="detail"><strong>Passenger:</strong> ${booking.passengerName}</div>
                <div class="detail"><strong>Flight Number:</strong> ${booking.flightNumber}</div>
                <div class="detail"><strong>Route:</strong> ${booking.from} → ${booking.to}</div>
                <div class="detail"><strong>Date:</strong> ${booking.date}</div>
                <div class="detail"><strong>Class:</strong> ${booking.class}</div>
                <div class="detail"><strong>Seat:</strong> ${booking.seatNumber}</div>
                <div class="detail"><strong>Status:</strong> ${booking.status}</div>
            </div>
        `).join('')}

        <div class="footer">
            <p>End of Report</p>
            <p>To save as PDF, use your browser's Print function (Ctrl+P) and select "Save as PDF"</p>
        </div>
    </div>
</body>
</html>
`;

// Write HTML file
fs.writeFileSync(reportPath, htmlContent);

console.log('HTML Report generated successfully at:', reportPath);
console.log('Open this file in a browser and use Print (Ctrl+P) to save as PDF');