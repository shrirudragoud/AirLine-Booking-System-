<%@ Application Language="C#" %>

<script runat="server">
    void Application_Start(object sender, EventArgs e)
    {
        // Initialize application
        System.Diagnostics.Debug.WriteLine("Application starting...");
        
        // Verify paths
        string physicalPath = Server.MapPath("~/");
        string stylesPath = Server.MapPath("~/Styles");
        string imagesPath = Server.MapPath("~/Images");
        
        System.Diagnostics.Debug.WriteLine(string.Format("Physical Path: {0}", physicalPath));
        System.Diagnostics.Debug.WriteLine(string.Format("Styles Path: {0}", stylesPath));
        System.Diagnostics.Debug.WriteLine(string.Format("Images Path: {0}", imagesPath));
        
        // Verify CSS files exist
        string mainCss = System.IO.Path.Combine(stylesPath, "main.css");
        string themeCss = System.IO.Path.Combine(stylesPath, "modern-theme.css");
        
        System.Diagnostics.Debug.WriteLine(string.Format("Main CSS exists: {0}", System.IO.File.Exists(mainCss)));
        System.Diagnostics.Debug.WriteLine(string.Format("Theme CSS exists: {0}", System.IO.File.Exists(themeCss)));
    }

    void Application_Error(object sender, EventArgs e)
    {
        // Log any unhandled errors
        Exception ex = Server.GetLastError();
        System.Diagnostics.Debug.WriteLine(string.Format("Application Error: {0}", ex.Message));
        System.Diagnostics.Debug.WriteLine(string.Format("Stack Trace: {0}", ex.StackTrace));
    }

    void Session_Start(object sender, EventArgs e)
    {
        // Initialize session
        System.Diagnostics.Debug.WriteLine(string.Format("Session started: {0}", Session.SessionID));
    }

    void Application_BeginRequest(object sender, EventArgs e)
    {
        // Log request details in debug mode
        if (Context.IsDebuggingEnabled)
        {
            string path = Request.Path;
            string physicalPath = Request.PhysicalPath;
            System.Diagnostics.Debug.WriteLine(string.Format("Request Path: {0}", path));
            System.Diagnostics.Debug.WriteLine(string.Format("Physical Path: {0}", physicalPath));

            // Log CSS file requests
            if (path.EndsWith(".css"))
            {
                System.Diagnostics.Debug.WriteLine(string.Format("CSS Request - Path: {0}", path));
                System.Diagnostics.Debug.WriteLine(string.Format("CSS Physical Path: {0}", physicalPath));
                
                if (System.IO.File.Exists(physicalPath))
                {
                    System.Diagnostics.Debug.WriteLine("CSS file exists");
                }
                else
                {
                    System.Diagnostics.Debug.WriteLine("CSS file not found");
                }
            }
        }
    }
</script>