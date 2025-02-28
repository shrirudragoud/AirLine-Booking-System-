$aspxFiles = @(
    "AboutUs",
    "AIRLINE SCHEDULE",
    "Available seats",
    "ContactUs",
    "details",
    "FARE TARIFFS",
    "Feedback",
    "feedback1",
    "Ticket Cancel",
    "TicketBooking2"
)

$template = @"
using System;
using System.Web.UI;

public partial class MasterPages_CLASSNAME : System.Web.UI.Page
{
    protected void Page_Load(object sender, EventArgs e)
    {
        if (!IsPostBack)
        {
            if (Session[""Username""] == null)
            {
                Response.Redirect(""~/MasterPages/login.aspx"");
            }
        }
    }
}
"@

foreach ($file in $aspxFiles) {
    $className = $file -replace ' ',''
    $content = $template -replace 'CLASSNAME',$className
    $filePath = "GUI/MasterPages/$file.aspx.cs"
    $content | Out-File -FilePath $filePath -Encoding UTF8
    Write-Host "Created: $filePath"
}