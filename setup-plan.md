# Setup Plan for Airline Reservation System

## Prerequisites
1. Install Required Software
   - Microsoft Visual Studio (2015 or later)
   - SQL Server Management Studio (2012 or later)
   - SQL Server Express or Developer Edition
   - .NET Framework 3.5 (required for application compatibility)

2. System Requirements
   - Windows OS (Windows 7 or later)
   - IIS (Internet Information Services) enabled

## Setup Steps

### 1. Database Setup
1. SQL Server Configuration:
   - Install SQL Server with Mixed Mode authentication
   - Create a new database named "shubham"
   - Configure SQL Server authentication:
     - User: sa
     - Password: sql (ensure to change this in production)
   - Enable TCP/IP protocol in SQL Server Configuration Manager
   - Start SQL Server Browser service

2. Database Connection:
   The application uses three connection strings (ensure server name matches your setup):
   ```
   Primary Connection (conn):
   server=YOUR_SERVER_NAME; Database=shubham; Uid=sa; pwd=sql

   Airline Connection:
   server=YOUR_SERVER_NAME; Database=shubham; Uid=sa; pwd=sql

   Shubham Connection:
   Data Source=YOUR_SERVER_NAME;Initial Catalog=shubham;Persist Security Info=True;User ID=sa;Password=sql
   ```
   
3. Database Security:
   - Create necessary SQL Server logins
   - Configure proper database permissions
   - For production, use a less privileged account than 'sa'

### 2. Project Setup
- Open the project in Visual Studio
- Restore any NuGet packages
- Update the database connection string in web.config
- Build the solution to ensure all dependencies are resolved

### 3. Configuration Review

1. Web.config Settings:
   - Authentication mode is set to Windows (`<authentication mode="Windows"/>`)
   - Debug mode is enabled (`<compilation debug="true">`)
   - .NET Framework version 3.5 assemblies are required
   - Script and handler configurations for ASP.NET AJAX support

2. Required Database Schema:
   Based on the application pages, the database should support:
   - User authentication tables (for login.aspx)
   - Flight schedules (for AIRLINE SCHEDULE.aspx)
   - Seat inventory (for Available seats.aspx)
   - Ticket booking records (for TicketBooking2.aspx)
   - Fare information (for FARE TARIFFS.aspx)
   - Ticket cancellation records (for Ticket Cancel.aspx)
   - Customer feedback (for Feedback.aspx)

3. IIS Configuration:
   - Enable ASP.NET in IIS
   - Configure application pool to use .NET Framework 3.5
   - Set up proper MIME types
   - Configure handler mappings for .aspx files

### 4. Running the Application
1. Build the solution in Visual Studio
2. Debug any build errors if they occur
3. Run the application using IIS Express from Visual Studio
4. Navigate to home.aspx as the starting page

### 5. Testing Core Functionality
Test the following key features to ensure proper setup:
- User login/authentication
- Viewing airline schedules
- Checking seat availability
- Ticket booking process
- Fare tariffs display
- Ticket cancellation

## Potential Challenges and Solutions
1. Database Connection Issues
   - Verify SQL Server is running
   - Check connection string format
   - Ensure proper permissions are set

2. Missing Dependencies
   - Restore NuGet packages
   - Check for required .NET Framework version
   - Verify all project references

3. Runtime Errors
   - Check application pool settings
   - Verify proper .NET Framework version
   - Review error logs

## Next Steps
Once the basic setup is complete, we can:
1. Review the codebase in detail
2. Document any technical debt or upgrade requirements
3. Plan any necessary modernization efforts