<%@ Page Language="C#" MasterPageFile="~/home.master" AutoEventWireup="true" CodeFile="MyBookings.aspx.cs" Inherits="MyBookings" Title="My Bookings - AirBook" %>

<asp:Content ID="Content1" ContentPlaceHolderID="ContentPlaceHolder1" Runat="Server">
    <div class="bookings-page">
        <div class="bookings-container">
            <div class="page-header">
                <h1>My Bookings</h1>
                <p>View and manage your flight bookings</p>
            </div>

            <div class="bookings-grid">
                <asp:Repeater ID="BookingsRepeater" runat="server">
                    <ItemTemplate>
                        <div class="booking-card">
                            <div class="booking-header">
                                <div class="booking-id">
                                    <span class="label">Booking ID</span>
                                    <strong><%# Eval("bookingId") %></strong>
                                </div>
                                <div class="booking-status <%# Eval("status").ToString().ToLower() %>">
                                    <%# Eval("status") %>
                                </div>
                            </div>
                            
                            <div class="flight-info">
                                <div class="route">
                                    <div class="location from">
                                        <span class="material-symbols-outlined">flight_takeoff</span>
                                        <div>
                                            <span class="label">From</span>
                                            <strong><%# Eval("from") %></strong>
                                        </div>
                                    </div>
                                    <div class="route-line">
                                        <span class="material-symbols-outlined">arrow_forward</span>
                                    </div>
                                    <div class="location to">
                                        <span class="material-symbols-outlined">flight_land</span>
                                        <div>
                                            <span class="label">To</span>
                                            <strong><%# Eval("to") %></strong>
                                        </div>
                                    </div>
                                </div>

                                <div class="details-grid">
                                    <div class="detail-item">
                                        <span class="label">Passenger</span>
                                        <strong><%# Eval("passengerName") %></strong>
                                    </div>
                                    <div class="detail-item">
                                        <span class="label">Flight</span>
                                        <strong><%# Eval("flightNumber") %></strong>
                                    </div>
                                    <div class="detail-item">
                                        <span class="label">Date</span>
                                        <strong><%# Convert.ToDateTime(Eval("date")).ToString("MMM dd, yyyy") %></strong>
                                    </div>
                                    <div class="detail-item">
                                        <span class="label">Class</span>
                                        <strong><%# Eval("class") %></strong>
                                    </div>
                                    <div class="detail-item">
                                        <span class="label">Seat</span>
                                        <strong><%# Eval("seatNumber") %></strong>
                                    </div>
                                </div>
                            </div>

                            <div class="booking-actions">
                                <asp:Button runat="server" Text="View E-Ticket" 
                                    CssClass="btn btn-primary"
                                    CommandName="ViewTicket" 
                                    CommandArgument='<%# Eval("bookingId") %>'
                                    OnClick="ViewTicket_Click" />
                            </div>
                        </div>
                    </ItemTemplate>
                </asp:Repeater>
            </div>
        </div>
    </div>

    <style>
        .bookings-page {
            padding: 2rem;
            background: linear-gradient(135deg, #f5f7fa 0%, #c3cfe2 100%);
            min-height: calc(100vh - 140px);
        }

        .bookings-container {
            max-width: 1200px;
            margin: 0 auto;
        }

        .page-header {
            text-align: center;
            margin-bottom: 2rem;
        }

        .page-header h1 {
            color: var(--text-color);
            font-size: 2.5rem;
            margin-bottom: 0.5rem;
        }

        .page-header p {
            color: var(--text-light);
        }

        .bookings-grid {
            display: grid;
            gap: 2rem;
        }

        .booking-card {
            background: white;
            border-radius: 12px;
            box-shadow: 0 4px 6px rgba(0,0,0,0.1);
            padding: 1.5rem;
        }

        .booking-header {
            display: flex;
            justify-content: space-between;
            align-items: center;
            margin-bottom: 1.5rem;
            padding-bottom: 1rem;
            border-bottom: 1px solid var(--border-color);
        }

        .booking-id .label {
            display: block;
            color: var(--text-light);
            font-size: 0.875rem;
            margin-bottom: 0.25rem;
        }

        .booking-status {
            padding: 0.5rem 1rem;
            border-radius: 50px;
            font-size: 0.875rem;
            font-weight: 500;
        }

        .booking-status.confirmed {
            background-color: var(--success-light);
            color: var(--success-color);
        }

        .route {
            display: grid;
            grid-template-columns: 1fr auto 1fr;
            gap: 1rem;
            align-items: center;
            margin-bottom: 1.5rem;
        }

        .location {
            display: flex;
            align-items: center;
            gap: 0.5rem;
        }

        .location .material-symbols-outlined {
            color: var(--primary-color);
        }

        .route-line {
            color: var(--text-light);
        }

        .details-grid {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(150px, 1fr));
            gap: 1rem;
            margin-bottom: 1.5rem;
        }

        .detail-item .label {
            display: block;
            color: var(--text-light);
            font-size: 0.875rem;
            margin-bottom: 0.25rem;
        }

        .booking-actions {
            display: flex;
            justify-content: flex-end;
            border-top: 1px solid var(--border-color);
            padding-top: 1rem;
        }

        @media (max-width: 768px) {
            .bookings-page {
                padding: 1rem;
            }

            .route {
                grid-template-columns: 1fr;
                text-align: center;
            }

            .location {
                justify-content: center;
            }

            .route-line {
                transform: rotate(90deg);
            }

            .details-grid {
                grid-template-columns: 1fr 1fr;
            }
        }
    </style>
</asp:Content>