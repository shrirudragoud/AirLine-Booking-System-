<%@ Page Language="C#" MasterPageFile="~/home.master" AutoEventWireup="true" CodeFile="TicketBooking2.aspx.cs" Inherits="TicketBooking2" Title="Book Ticket - AirBook" %>

<asp:Content ID="Content1" ContentPlaceHolderID="ContentPlaceHolder1" Runat="Server">
    <div class="booking-page">
        <div class="booking-container">
            <!-- Booking Form -->
            <div class="booking-form-section card">
                <div class="booking-header">
                    <span class="material-symbols-outlined">flight_takeoff</span>
                    <h2>Book Your Flight</h2>
                    <p>Complete your booking details</p>
                </div>

                <div class="booking-progress">
                    <div class="progress-step active">
                        <span class="step-number">1</span>
                        <span class="step-text">Flight Details</span>
                    </div>
                    <div class="progress-step">
                        <span class="step-number">2</span>
                        <span class="step-text">Passenger Info</span>
                    </div>
                    <div class="progress-step">
                        <span class="step-number">3</span>
                        <span class="step-text">Confirmation</span>
                    </div>
                </div>

                <div class="form-sections">
                    <!-- Passenger Details -->
                    <div class="form-section">
                        <h3>Passenger Information</h3>
                        <div class="form-group">
                            <label for="TextBox1">
                                <span class="material-symbols-outlined">person</span>
                                Full Name
                            </label>
                            <asp:TextBox ID="TextBox1" runat="server" CssClass="form-control" placeholder="Enter passenger name"></asp:TextBox>
                            <asp:RequiredFieldValidator ID="RequiredFieldValidator3" runat="server" 
                                ControlToValidate="TextBox1" ErrorMessage="Passenger name is required"
                                CssClass="validation-error" Display="Dynamic">
                            </asp:RequiredFieldValidator>
                        </div>
                    </div>

                    <!-- Flight Details -->
                    <div class="form-section">
                        <h3>Flight Selection</h3>
                        <div class="form-row">
                            <div class="form-group">
                                <label for="DropDownList1">
                                    <span class="material-symbols-outlined">flight</span>
                                    Flight Number
                                </label>
                                <asp:DropDownList ID="DropDownList1" runat="server" CssClass="form-control" 
                                    AutoPostBack="true" OnSelectedIndexChanged="DropDownList1_SelectedIndexChanged">
                                </asp:DropDownList>
                                <asp:RequiredFieldValidator ID="RequiredFieldValidator4" runat="server" 
                                    ControlToValidate="DropDownList1" ErrorMessage="Select a flight"
                                    CssClass="validation-error" Display="Dynamic">
                                </asp:RequiredFieldValidator>
                            </div>

                            <div class="form-group">
                                <label for="DropDownList2">
                                    <span class="material-symbols-outlined">airlines</span>
                                    Airline
                                </label>
                                <asp:DropDownList ID="DropDownList2" runat="server" CssClass="form-control">
                                </asp:DropDownList>
                                <asp:RequiredFieldValidator ID="RequiredFieldValidator5" runat="server" 
                                    ControlToValidate="DropDownList2" ErrorMessage="Select an airline"
                                    CssClass="validation-error" Display="Dynamic">
                                </asp:RequiredFieldValidator>
                            </div>
                        </div>

                        <div class="form-row">
                            <div class="form-group">
                                <label for="DropDownList3">
                                    <span class="material-symbols-outlined">flight_takeoff</span>
                                    From
                                </label>
                                <asp:DropDownList ID="DropDownList3" runat="server" CssClass="form-control">
                                </asp:DropDownList>
                                <asp:RequiredFieldValidator ID="RequiredFieldValidator6" runat="server" 
                                    ControlToValidate="DropDownList3" ErrorMessage="Select departure city"
                                    CssClass="validation-error" Display="Dynamic">
                                </asp:RequiredFieldValidator>
                            </div>

                            <div class="form-group">
                                <label for="DropDownList4">
                                    <span class="material-symbols-outlined">flight_land</span>
                                    To
                                </label>
                                <asp:DropDownList ID="DropDownList4" runat="server" CssClass="form-control">
                                </asp:DropDownList>
                                <asp:RequiredFieldValidator ID="RequiredFieldValidator7" runat="server" 
                                    ControlToValidate="DropDownList4" ErrorMessage="Select destination city"
                                    CssClass="validation-error" Display="Dynamic">
                                </asp:RequiredFieldValidator>
                            </div>
                        </div>
                    </div>

                    <!-- Travel Preferences -->
                    <div class="form-section">
                        <h3>Travel Preferences</h3>
                        <div class="form-row">
                            <div class="form-group">
                                <label for="DropDownList5">
                                    <span class="material-symbols-outlined">airline_seat_recline_extra</span>
                                    Class
                                </label>
                                <asp:DropDownList ID="DropDownList5" runat="server" CssClass="form-control">
                                    <asp:ListItem Value="">Select Class</asp:ListItem>
                                    <asp:ListItem>Business Class</asp:ListItem>
                                    <asp:ListItem>First Class</asp:ListItem>
                                    <asp:ListItem>Economy Class</asp:ListItem>
                                </asp:DropDownList>
                                <asp:RequiredFieldValidator ID="RequiredFieldValidator8" runat="server" 
                                    ControlToValidate="DropDownList5" ErrorMessage="Select travel class"
                                    CssClass="validation-error" Display="Dynamic">
                                </asp:RequiredFieldValidator>
                            </div>

                            <div class="form-group">
                                <label for="DropDownList6">
                                    <span class="material-symbols-outlined">schedule</span>
                                    Travel Date
                                </label>
                                <asp:DropDownList ID="DropDownList6" runat="server" CssClass="form-control">
                                </asp:DropDownList>
                                <asp:RequiredFieldValidator ID="RequiredFieldValidator9" runat="server" 
                                    ControlToValidate="DropDownList6" ErrorMessage="Select travel date"
                                    CssClass="validation-error" Display="Dynamic">
                                </asp:RequiredFieldValidator>
                            </div>
                        </div>
                    </div>

                    <!-- Action Buttons -->
                    <div class="form-actions">
                        <asp:Button ID="SelectSeatBtn" runat="server" Text="Select Seat" 
                            CssClass="btn btn-outline-primary" OnClick="SelectSeatBtn_Click" CausesValidation="false" />
                        
                        <asp:Button ID="Button1" runat="server" Text="Book Ticket" 
                            OnClick="Button1_Click" CssClass="btn btn-primary" />
                    </div>

                    <!-- Booking Status -->
                    <asp:Label ID="BookingStatus" runat="server" CssClass="booking-status"></asp:Label>
                </div>
            </div>

            <!-- Booking Summary -->
            <div class="booking-summary card">
                <h3>Booking Summary</h3>
                <div class="summary-content">
                    <div class="summary-item">
                        <span>Passenger</span>
                        <strong><asp:Literal ID="SummaryPassenger" runat="server"></asp:Literal></strong>
                    </div>
                    <div class="summary-item">
                        <span>Flight</span>
                        <strong><asp:Literal ID="SummaryFlight" runat="server"></asp:Literal></strong>
                    </div>
                    <div class="summary-item">
                        <span>Route</span>
                        <strong><asp:Literal ID="SummaryRoute" runat="server"></asp:Literal></strong>
                    </div>
                    <div class="summary-item">
                        <span>Travel Date</span>
                        <strong><asp:Literal ID="SummaryDate" runat="server"></asp:Literal></strong>
                    </div>
                    <div class="summary-item">
                        <span>Class</span>
                        <strong><asp:Literal ID="SummaryClass" runat="server"></asp:Literal></strong>
                    </div>
                </div>
            </div>
        </div>
    </div>

    <style>
        .booking-page {
            padding: 2rem;
            background: linear-gradient(135deg, #f5f7fa 0%, #c3cfe2 100%);
            min-height: calc(100vh - 140px);
        }

        .booking-container {
            max-width: 1200px;
            margin: 0 auto;
            display: grid;
            grid-template-columns: 2fr 1fr;
            gap: 2rem;
        }

        .booking-header {
            text-align: center;
            margin-bottom: 2rem;
        }

        .booking-header .material-symbols-outlined {
            font-size: 3rem;
            color: var(--primary-color);
            margin-bottom: 1rem;
        }

        .booking-progress {
            display: flex;
            justify-content: space-between;
            margin-bottom: 2rem;
            padding: 0 2rem;
        }

        .progress-step {
            display: flex;
            flex-direction: column;
            align-items: center;
            position: relative;
            flex: 1;
        }

        .progress-step::before {
            content: '';
            position: absolute;
            top: 15px;
            left: -50%;
            width: 100%;
            height: 2px;
            background: var(--border-color);
            z-index: 0;
        }

        .progress-step:first-child::before {
            display: none;
        }

        .step-number {
            width: 30px;
            height: 30px;
            border-radius: 50%;
            background: var(--border-color);
            color: var(--text-light);
            display: flex;
            align-items: center;
            justify-content: center;
            position: relative;
            z-index: 1;
            margin-bottom: 0.5rem;
        }

        .progress-step.active .step-number {
            background: var(--primary-color);
            color: white;
        }

        .step-text {
            color: var(--text-light);
            font-size: 0.875rem;
        }

        .progress-step.active .step-text {
            color: var(--primary-color);
            font-weight: 500;
        }

        .form-sections {
            display: flex;
            flex-direction: column;
            gap: 2rem;
        }

        .form-section {
            padding: 1.5rem;
            border: 1px solid var(--border-color);
            border-radius: 8px;
            background: white;
        }

        .form-section h3 {
            margin-bottom: 1.5rem;
            color: var(--primary-color);
            display: flex;
            align-items: center;
            gap: 0.5rem;
        }

        .form-actions {
            display: flex;
            gap: 1rem;
            margin-top: 2rem;
        }

        .booking-summary {
            position: sticky;
            top: 2rem;
        }

        .summary-content {
            display: flex;
            flex-direction: column;
            gap: 1rem;
        }

        .summary-item {
            display: flex;
            justify-content: space-between;
            padding: 0.5rem 0;
            border-bottom: 1px solid var(--border-color);
        }

        .summary-item:last-child {
            border-bottom: none;
        }

        .summary-item span {
            color: var(--text-light);
        }

        .booking-status {
            margin-top: 1rem;
            padding: 1rem;
            border-radius: 4px;
            display: none;
        }

        .booking-status.success {
            display: block;
            background-color: var(--success-color);
            color: white;
        }

        .booking-status.error {
            display: block;
            background-color: var(--danger-color);
            color: white;
        }

        @media (max-width: 992px) {
            .booking-container {
                grid-template-columns: 1fr;
            }

            .booking-summary {
                position: static;
            }
        }

        @media (max-width: 768px) {
            .booking-page {
                padding: 1rem;
            }

            .form-row {
                grid-template-columns: 1fr;
            }

            .form-actions {
                flex-direction: column;
            }

            .progress-step .step-text {
                display: none;
            }
        }
    </style>
</asp:Content>