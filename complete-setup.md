# Complete Setup Guide for Enhanced Airline Reservation System

## 1. Database Setup
Run these scripts in order:
```sql
1. execute create-database.sql   -- Creates base structure
2. execute update-routes.sql     -- Adds comprehensive routes
```

## 2. Visual Resources Setup
Run the PowerShell script to create visual assets:
```powershell
./create-resources.ps1
```
This creates:
- Background images
- Airline logos
- Destination images
- SVG patterns and gradients

## 3. Style Files
Verify these CSS files are in GUI/Styles/:
- main.css
- modern-theme.css

## 4. Visual Studio Project Setup
1. Open Visual Studio as Administrator
2. Open the GUI folder as a website
3. Build the solution
4. Set login.aspx as start page

## 5. Database Connection
1. Open web.config
2. Verify connection string:
   ```xml
   <add name="conn" 
        connectionString="Data Source=(LocalDB)\MSSQLLocalDB;Initial Catalog=AirlineDB;Integrated Security=True" 
        providerName="System.Data.SqlClient"/>
   ```

## 6. Testing the Enhanced UI

### A. Test Login Page
1. Run the application
2. Verify:
   - Modern gradient background
   - Animated login form
   - Social icons and features section
   - Validation messages styling

### B. Test Home Page
1. Log in with admin/admin123
2. Verify:
   - Hero section with background
   - Flight search form
   - Featured destinations
   - Price cards

### C. Test Flight Schedule
1. Check:
   - Route filtering works
   - Price sorting works
   - Flight cards show all details
   - Connecting flights are visible

### D. Test Booking Process
1. Select a flight
2. Verify:
   - Progress indicators
   - Seat selection interface
   - Price summary
   - Booking confirmation

## 7. Visual Elements to Verify

### Colors and Gradients
- Primary Blue: #00509d
- Secondary Gold: #ffd700
- Success Green: #00b894
- Warning Orange: #fdcb6e
- Error Red: #d63031

### UI Components
- Cards with hover effects
- Animated buttons
- Progress indicators
- Status badges
- Route visualizations
- Price tags

### Responsive Design
Test on:
- Desktop (>992px)
- Tablet (768px-992px)
- Mobile (<768px)

## 8. Features to Test

### Flight Routes
- Direct flights
- Connecting flights
- International routes
- Domestic routes

### Pricing Display
- Base prices
- Class upgrades
- Total calculation

### Interactive Elements
- Seat selection
- Flight filtering
- Price sorting
- Date selection

## Troubleshooting

### If Images Don't Load
1. Check GUI/Images/ directory structure:
   ```
   GUI/Images/
   ├── backgrounds/
   ├── airlines/
   └── destinations/
   ```
2. Run create-resources.ps1 again

### If Styles Don't Apply
1. Clear browser cache
2. Verify CSS paths in home.master
3. Check browser console for errors

### If Routes Don't Show
1. Run update-routes.sql again
2. Check SQL Server Object Explorer
3. Verify FlightRoutes table data

### If UI Looks Basic
1. Verify modern-theme.css is loaded
2. Check browser compatibility
3. Enable JavaScript
4. Clear browser cache

## Final Checks
- All images load correctly
- Gradients and colors appear
- Animations work smoothly
- Mobile menu functions
- Flight search works
- Booking process completes

The enhanced UI should now provide a modern, professional booking experience with proper visual feedback and smooth interactions.