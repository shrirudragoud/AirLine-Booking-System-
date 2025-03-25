# Quick Start Guide - Updated

## Setup and Installation

1. Database Setup:
   ```sql
   -- Open SQL Server Management Studio and run:
   execute create-database.sql
   ```

2. Project Setup in Visual Studio:
   - Open Visual Studio as Administrator
   - File -> Open -> Web Site
   - Select the GUI folder
   - Build the solution

3. Verify Files:
   - GUI/home.master and GUI/home.master.cs (master page)
   - GUI/home.master.designer.cs (control declarations)
   - GUI/Styles/main.css (styles)
   - GUI/Images/destinations/* (placeholder images)

## Running the Application

1. Set Start Page:
   - In Solution Explorer
   - Right-click on GUI/MasterPages/login.aspx
   - Select "Set As Start Page"

2. Launch:
   - Press F5 or click "Start Debugging"
   - Application will open in your default browser

3. Login:
   ```
   Username: admin
   Password: admin123
   ```

## Testing Navigation

1. Before Login:
   - Only login button should be visible
   - Other navigation items are hidden

2. After Login:
   - Full navigation menu appears
   - User info and logout button visible
   - Test all navigation links

3. Responsive Testing:
   - Resize browser window
   - Test hamburger menu on mobile view
   - Verify all transitions and animations

## Troubleshooting

1. If pages don't load:
   - Check IIS Express is running
   - Verify virtual directory settings
   - Clear browser cache

2. If styles don't apply:
   - Verify main.css is in GUI/Styles folder
   - Check browser console for CSS errors
   - Clear browser cache

3. If login fails:
   - Verify database connection string in web.config
   - Check SQL Server is running
   - Verify admin user exists in database

4. Navigation Issues:
   - Clear browser cache
   - Check browser console for JavaScript errors
   - Verify session state is enabled

## UI Features to Test

1. Modern Navigation:
   - Sticky header
   - Smooth transitions
   - Mobile responsive menu
   - User state awareness

2. Login Page:
   - Form validation
   - Error messages
   - Password visibility toggle
   - Responsive layout

3. Home Page:
   - Hero section
   - Search functionality
   - Featured destinations
   - Flight cards

4. General UI:
   - Card hover effects
   - Button states
   - Form interactions
   - Alert messages

## Style Classes Reference

Use these classes for consistent styling:
```css
.btn-primary      /* Primary buttons */
.btn-outline      /* Outline buttons */
.card            /* Content cards */
.form-control    /* Form inputs */
.alert          /* Messages */
```

## Mobile Testing

1. Responsive breakpoints:
   - Desktop: > 992px
   - Tablet: 768px - 992px
   - Mobile: < 768px

2. Test features:
   - Menu collapses to hamburger
   - Cards stack vertically
   - Forms adjust to screen width
   - Touch-friendly buttons

Remember to clear your browser cache when testing changes, and use browser dev tools (F12) to diagnose any issues.