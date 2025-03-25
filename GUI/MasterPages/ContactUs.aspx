<%@ Page Language="C#" MasterPageFile="~/home.master" AutoEventWireup="true" CodeFile="ContactUs.aspx.cs" Inherits="ContactUs" Title="Contact Us - Airline Reservation" %>

<asp:Content ID="Content1" ContentPlaceHolderID="ContentPlaceHolder1" Runat="Server">
    <div class="dashboard">
        <div class="contact-container">
            <!-- Contact Information -->
            <div class="card contact-info">
                <h2><span class="material-symbols-outlined">contact_support</span> Contact Us</h2>
                <div class="info-section">
                    <div class="info-item">
                        <span class="material-symbols-outlined">location_on</span>
                        <div class="info-content">
                            <h3>Address</h3>
                            <p>123 Airline Plaza</p>
                            <p>New Delhi, India 110001</p>
                        </div>
                    </div>
                    <div class="info-item">
                        <span class="material-symbols-outlined">phone</span>
                        <div class="info-content">
                            <h3>Phone</h3>
                            <p>Toll Free: 1800-123-4567</p>
                            <p>Support: +91 98765-43210</p>
                        </div>
                    </div>
                    <div class="info-item">
                        <span class="material-symbols-outlined">mail</span>
                        <div class="info-content">
                            <h3>Email</h3>
                            <p>support@airlinereservation.com</p>
                            <p>bookings@airlinereservation.com</p>
                        </div>
                    </div>
                    <div class="info-item">
                        <span class="material-symbols-outlined">schedule</span>
                        <div class="info-content">
                            <h3>Business Hours</h3>
                            <p>Monday - Friday: 9:00 AM - 8:00 PM</p>
                            <p>Saturday: 10:00 AM - 6:00 PM</p>
                        </div>
                    </div>
                </div>
            </div>

            <!-- Contact Form -->
            <div class="card contact-form">
                <h2><span class="material-symbols-outlined">message</span> Send us a Message</h2>
                <div class="form-group">
                    <asp:Label runat="server" Text="Name"></asp:Label>
                    <asp:TextBox ID="NameTextBox" runat="server" CssClass="form-control" placeholder="Your name"></asp:TextBox>
                    <asp:RequiredFieldValidator ID="NameValidator" runat="server" 
                        ControlToValidate="NameTextBox" ErrorMessage="Name is required"
                        CssClass="validation-error" Display="Dynamic">
                    </asp:RequiredFieldValidator>
                </div>

                <div class="form-group">
                    <asp:Label runat="server" Text="Email"></asp:Label>
                    <asp:TextBox ID="EmailTextBox" runat="server" CssClass="form-control" placeholder="Your email"></asp:TextBox>
                    <asp:RequiredFieldValidator ID="EmailValidator" runat="server" 
                        ControlToValidate="EmailTextBox" ErrorMessage="Email is required"
                        CssClass="validation-error" Display="Dynamic">
                    </asp:RequiredFieldValidator>
                    <asp:RegularExpressionValidator ID="EmailFormatValidator" runat="server" 
                        ControlToValidate="EmailTextBox" 
                        ValidationExpression="\w+([-+.']\w+)*@\w+([-.]\w+)*\.\w+([-.]\w+)*" 
                        ErrorMessage="Invalid email format"
                        CssClass="validation-error" Display="Dynamic">
                    </asp:RegularExpressionValidator>
                </div>

                <div class="form-group">
                    <asp:Label runat="server" Text="Subject"></asp:Label>
                    <asp:DropDownList ID="SubjectDropDown" runat="server" CssClass="form-control">
                        <asp:ListItem Text="Select a subject" Value="" />
                        <asp:ListItem Text="Booking Inquiry" Value="booking" />
                        <asp:ListItem Text="Flight Information" Value="flight" />
                        <asp:ListItem Text="Cancellation" Value="cancel" />
                        <asp:ListItem Text="General Query" Value="general" />
                    </asp:DropDownList>
                    <asp:RequiredFieldValidator ID="SubjectValidator" runat="server" 
                        ControlToValidate="SubjectDropDown" ErrorMessage="Please select a subject"
                        CssClass="validation-error" Display="Dynamic">
                    </asp:RequiredFieldValidator>
                </div>

                <div class="form-group">
                    <asp:Label runat="server" Text="Message"></asp:Label>
                    <asp:TextBox ID="MessageTextBox" runat="server" TextMode="MultiLine" 
                        Rows="5" CssClass="form-control" placeholder="Your message">
                    </asp:TextBox>
                    <asp:RequiredFieldValidator ID="MessageValidator" runat="server" 
                        ControlToValidate="MessageTextBox" ErrorMessage="Message is required"
                        CssClass="validation-error" Display="Dynamic">
                    </asp:RequiredFieldValidator>
                </div>

                <asp:Button ID="SubmitButton" runat="server" Text="Send Message" 
                    CssClass="btn btn-primary" OnClick="SubmitButton_Click" />
                
                <asp:Label ID="MessageLabel" runat="server" CssClass="message-label"></asp:Label>
            </div>
        </div>

        <!-- Map Section -->
        <div class="card map-section">
            <h2><span class="material-symbols-outlined">map</span> Our Location</h2>
            <div class="map-container">
                <iframe src="https://www.google.com/maps/embed?pb=!1m18!1m12!1m3!1d3504.556145342946!2d77.20651831492145!3d28.5508741894546!2m3!1f0!2f0!3f0!3m2!1i1024!2i768!4f13.1!3m3!1m2!1s0x390ce26e02e24ef1%3A0x546859509bc3c5c2!2sIndira%20Gandhi%20International%20Airport!5e0!3m2!1sen!2sin!4v1645523645281!5m2!1sen!2sin"
                    width="100%" height="450" style="border:0;" allowfullscreen="" loading="lazy"></iframe>
            </div>
        </div>
    </div>

    <style>
        .contact-container {
            display: grid;
            grid-template-columns: 1fr 1fr;
            gap: 2rem;
            margin-bottom: 2rem;
        }

        .info-section {
            display: grid;
            gap: 1.5rem;
        }

        .info-item {
            display: flex;
            align-items: flex-start;
            gap: 1rem;
        }

        .info-item .material-symbols-outlined {
            color: var(--primary-color);
            font-size: 2rem;
        }

        .info-content h3 {
            margin: 0;
            color: var(--primary-color);
            font-size: 1.1rem;
        }

        .info-content p {
            margin: 0.25rem 0;
            color: var(--light-text);
        }

        .contact-form {
            padding: 2rem;
        }

        .message-label {
            display: block;
            margin-top: 1rem;
            padding: 1rem;
            border-radius: 4px;
        }

        .message-label.success {
            background-color: #d4edda;
            color: #155724;
        }

        .message-label.error {
            background-color: #f8d7da;
            color: #721c24;
        }

        .map-section {
            margin-top: 2rem;
        }

        .map-container {
            margin-top: 1rem;
            border-radius: 8px;
            overflow: hidden;
        }

        @media (max-width: 768px) {
            .contact-container {
                grid-template-columns: 1fr;
            }
        }
    </style>
</asp:Content>
