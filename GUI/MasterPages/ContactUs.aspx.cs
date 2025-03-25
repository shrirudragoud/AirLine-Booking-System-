using System;
using System.Data;
using System.Data.SqlClient;
using System.Configuration;
using System.Web.UI;
using System.Web.UI.WebControls;

public partial class ContactUs : System.Web.UI.Page
{
    protected void Page_Load(object sender, EventArgs e)
    {
        if (!IsPostBack)
        {
            // Initialize the form
            MessageLabel.Visible = false;
        }
    }

    protected void SubmitButton_Click(object sender, EventArgs e)
    {
        if (Page.IsValid)
        {
            using (SqlConnection conn = new SqlConnection(ConfigurationManager.ConnectionStrings["conn"].ConnectionString))
            {
                try
                {
                    conn.Open();
                    using (SqlCommand cmd = new SqlCommand(@"
                        INSERT INTO ContactMessages (Name, Email, Subject, Message)
                        VALUES (@Name, @Email, @Subject, @Message)", conn))
                    {
                        cmd.Parameters.AddWithValue("@Name", NameTextBox.Text.Trim());
                        cmd.Parameters.AddWithValue("@Email", EmailTextBox.Text.Trim());
                        cmd.Parameters.AddWithValue("@Subject", SubjectDropDown.SelectedItem.Text);
                        cmd.Parameters.AddWithValue("@Message", MessageTextBox.Text.Trim());

                        cmd.ExecuteNonQuery();

                        // Show success message
                        MessageLabel.Text = "Thank you for your message. We will contact you soon!";
                        MessageLabel.CssClass = "message-label success";
                        MessageLabel.Visible = true;

                        // Clear the form
                        ClearForm();

                        // If user is logged in, try to send email notification
                        if (Session["Username"] != null)
                        {
                            try
                            {
                                SendEmailNotification();
                            }
                            catch
                            {
                                // Ignore email errors - message is already saved in database
                            }
                        }
                    }
                }
                catch (Exception ex)
                {
                    MessageLabel.Text = "An error occurred while sending your message. Please try again later.";
                    MessageLabel.CssClass = "message-label error";
                    MessageLabel.Visible = true;
                    System.Diagnostics.Debug.WriteLine("Error saving contact message: " + ex.Message);
                }
            }
        }
    }

    private void ClearForm()
    {
        NameTextBox.Text = "";
        EmailTextBox.Text = "";
        SubjectDropDown.SelectedIndex = 0;
        MessageTextBox.Text = "";
    }

    private void SendEmailNotification()
    {
        // This is a placeholder for email notification functionality
        // You would implement this using System.Net.Mail or a third-party email service
        // Example:
        /*
        using (SmtpClient smtp = new SmtpClient())
        {
            MailMessage message = new MailMessage();
            message.To.Add("support@airlinereservation.com");
            message.Subject = "New Contact Form Submission";
            message.Body = $"Name: {NameTextBox.Text}\nEmail: {EmailTextBox.Text}\nSubject: {SubjectDropDown.SelectedItem.Text}\nMessage: {MessageTextBox.Text}";
            smtp.Send(message);
        }
        */
    }
}
