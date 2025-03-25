$aspxFiles = Get-ChildItem -Path "GUI/MasterPages" -Filter "*.aspx"

foreach ($file in $aspxFiles) {
    # Skip files we've already fixed
    if ($file.Name -in @('login.aspx', 'home.aspx', 'Admin.aspx')) {
        continue
    }

    # Read the ASPX file content
    $content = Get-Content $file.FullName -Raw
    
    # Extract the Inherits value using regex
    if ($content -match 'Inherits="([^"]+)"') {
        $inheritsClass = $matches[1]
        
        # Create the code-behind content
        $codeTemplate = @"
using System;
using System.Web.UI;

public partial class $inheritsClass : System.Web.UI.Page
{
    protected void Page_Load(object sender, EventArgs e)
    {
        if (!IsPostBack)
        {
            if (Session["Username"] == null)
            {
                Response.Redirect("~/MasterPages/login.aspx");
            }
        }
    }
}
"@
        
        # Save the code-behind file
        $codeBehindPath = $file.FullName + ".cs"
        $codeTemplate | Out-File -FilePath $codeBehindPath -Encoding UTF8
        Write-Host "Created: $codeBehindPath with class $inheritsClass"
    }
    else {
        Write-Host "Warning: Could not find Inherits attribute in $($file.Name)"
    }
}