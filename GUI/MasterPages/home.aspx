<%@ Page Language="C#" MasterPageFile="~/home.master" AutoEventWireup="true" CodeFile="home.aspx.cs" Inherits="home" Title="Home - Airline Reservation" %>

<asp:Content ID="Content1" ContentPlaceHolderID="ContentPlaceHolder1" Runat="Server">
    <!-- Hero Section -->
    <div class="hero-section">
        <div class="hero-content">
            <h1>Your Journey Begins Here</h1>
            <p>Discover amazing destinations with our best flight deals</p>
        </div>

        <!-- Flight Search Form -->
        <div class="search-card">
            <div class="search-tabs">
                <button class="tab-btn active" onclick="return false;">Book Flights</button>
                <button class="tab-btn" onclick="return false;">Flight Status</button>
                <button class="tab-btn" onclick="return false;">Check-in</button>
            </div>
            <div class="search-form">
                <div class="form-row">
                    <div class="form-group">
                        <label><span class="material-symbols-outlined">flight_takeoff</span> From</label>
                        <asp:DropDownList ID="FromCity" runat="server" CssClass="form-control"></asp:DropDownList>
                    </div>
                    <div class="form-group">
                        <label><span class="material-symbols-outlined">flight_land</span> To</label>
                        <asp:DropDownList ID="ToCity" runat="server" CssClass="form-control"></asp:DropDownList>
                    </div>
                </div>
                <div class="form-row">
                    <div class="form-group">
                        <label><span class="material-symbols-outlined">calendar_month</span> Departure</label>
                        <asp:TextBox ID="DepartureDate" runat="server" CssClass="form-control" TextMode="Date"></asp:TextBox>
                    </div>
                    <div class="form-group">
                        <label><span class="material-symbols-outlined">person</span> Passengers</label>
                        <asp:DropDownList ID="PassengerCount" runat="server" CssClass="form-control">
                            <asp:ListItem Value="1">1 Passenger</asp:ListItem>
                            <asp:ListItem Value="2">2 Passengers</asp:ListItem>
                            <asp:ListItem Value="3">3 Passengers</asp:ListItem>
                            <asp:ListItem Value="4">4 Passengers</asp:ListItem>
                        </asp:DropDownList>
                    </div>
                </div>
                <div class="search-button">
                    <asp:Button ID="SearchFlights" runat="server" Text="Search Flights" 
                        CssClass="btn btn-primary btn-large" OnClick="SearchFlights_Click" />
                </div>
            </div>
        </div>
    </div>


    <!-- Featured Destinations -->
    <div class="content-section">
        <h2 class="section-title">Popular Destinations</h2>
        <div class="destinations-grid">
            <asp:Repeater ID="DestinationsRepeater" runat="server">
                <ItemTemplate>
                    <div class="destination-card">
                        <div class="destination-image" style="background-image: url('<%# GetDestinationImage(Container.DataItem) %>')">
                            <div class="destination-overlay">
                                <h3><%# Eval("Destination") %></h3>
                                <p>from ₹<%# Eval("BasePrice") %></p>
                                <asp:Button ID="ExploreBtn" runat="server" Text="Explore" 
                                    CssClass="btn btn-light" 
                                    CommandName="Explore" 
                                    CommandArgument='<%# Eval("Destination") %>'
                                    OnClick="ExploreBtn_Click" />
                            </div>
                        </div>
                    </div>
                </ItemTemplate>
            </asp:Repeater>
        </div>
    </div>

    <!-- Featured Flights -->
    <div class="content-section">
        <h2 class="section-title">Today's Best Deals</h2>
        <div class="flights-grid">
            <asp:Repeater ID="FeaturedFlights" runat="server">
                <ItemTemplate>
                    <div class="flight-card">
                        <div class="flight-header">
                            <div class="airline-logo">
                                <span class="material-symbols-outlined">flight</span>
                            </div>
                            <div class="flight-title">
                                <h3><%# Eval("FlightNumber") %></h3>
                                <p class="airline-name"><%# Eval("FlightName") %></p>
                            </div>
                        </div>
                        <div class="flight-details">
                            <div class="route">
                                <div class="origin">
                                    <h4><%# Eval("Origin") %></h4>
                                    <p><%# FormatTime(Eval("DepartureTime")) %></p>
                                </div>
                                <div class="flight-path">
                                    <span class="material-symbols-outlined">arrow_forward</span>
                                </div>
                                <div class="destination">
                                    <h4><%# Eval("Destination") %></h4>
                                    <p><%# FormatTime(Eval("ArrivalTime")) %></p>
                                </div>
                            </div>
                            <div class="booking-section">
                                <div class="price">From ₹<%# Eval("BasePrice") %></div>
                                <asp:Button ID="BookNow" runat="server" Text="Book Now" 
                                    CssClass="btn btn-primary" 
                                    CommandName="BookFlight" 
                                    CommandArgument='<%# Eval("FlightID") %>'
                                    OnClick="BookNow_Click" />
                            </div>
                        </div>
                    </div>
                </ItemTemplate>
            </asp:Repeater>
        </div>
    </div>

    <style>
        /* Hero Section */
        .hero-section {
            background-color: var(--primary-dark);
            background-image: linear-gradient(rgba(0, 0, 0, 0.5), rgba(0, 0, 0, 0.5)),
                        url('<%= Page.ResolveClientUrl("~/Images/backgrounds/hero-bg.jpg") %>');
            background-repeat: no-repeat;
            background-position: center center;
            background-size: cover;
            padding: 100px 20px;
            color: white;
            text-align: center;
            position: relative;
        }

        .hero-content {
            margin-bottom: 2rem;
        }

        .hero-content h1 {
            font-size: 3rem;
            margin-bottom: 1rem;
            text-shadow: 2px 2px 4px rgba(0,0,0,0.5);
        }

        /* Search Form */
        .search-card {
            background: white;
            border-radius: 12px;
            box-shadow: 0 4px 6px rgba(0,0,0,0.1);
            max-width: 1000px;
            margin: 0 auto;
            padding: 2rem;
        }

        .search-tabs {
            display: flex;
            gap: 1rem;
            margin-bottom: 2rem;
            border-bottom: 1px solid #eee;
        }

        .tab-btn {
            padding: 1rem 2rem;
            border: none;
            background: none;
            color: #666;
            cursor: pointer;
            position: relative;
        }

        .tab-btn.active {
            color: var(--primary-color);
            font-weight: bold;
        }

        .tab-btn.active::after {
            content: '';
            position: absolute;
            bottom: -1px;
            left: 0;
            right: 0;
            height: 2px;
            background: var(--primary-color);
        }

        .search-form {
            display: flex;
            flex-direction: column;
            gap: 1.5rem;
        }

        .form-row {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(250px, 1fr));
            gap: 1.5rem;
        }

        .search-button {
            text-align: center;
        }

        .btn-large {
            padding: 1rem 3rem;
            font-size: 1.1rem;
        }

        /* Destinations Grid */
        .content-section {
            padding: 4rem 2rem;
        }

        .section-title {
            text-align: center;
            margin-bottom: 2rem;
            color: var(--text-color);
            font-size: 2rem;
        }

        .destinations-grid {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(300px, 1fr));
            gap: 2rem;
            margin: 0 auto;
            max-width: 1200px;
        }

        .destination-card {
            border-radius: 12px;
            overflow: hidden;
            box-shadow: 0 4px 6px rgba(0,0,0,0.1);
            transition: transform 0.3s ease;
        }

        .destination-card:hover {
            transform: translateY(-5px);
        }

        .destination-image {
            height: 250px;
            background-size: cover;
            background-position: center;
            position: relative;
        }

        .destination-overlay {
            position: absolute;
            bottom: 0;
            left: 0;
            right: 0;
            padding: 2rem;
            background: linear-gradient(transparent, rgba(0,0,0,0.8));
            color: white;
        }

        .destination-overlay h3 {
            margin: 0;
            font-size: 1.5rem;
            margin-bottom: 0.5rem;
        }

        /* Flights Grid */
        .flights-grid {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(350px, 1fr));
            gap: 2rem;
            margin: 0 auto;
            max-width: 1200px;
        }

        .flight-card {
            background: white;
            border-radius: 12px;
            box-shadow: 0 4px 6px rgba(0,0,0,0.1);
            padding: 1.5rem;
            transition: transform 0.3s ease;
        }

        .flight-card:hover {
            transform: translateY(-5px);
        }

        .flight-header {
            display: flex;
            align-items: center;
            gap: 1rem;
            margin-bottom: 1.5rem;
        }

        .airline-logo {
            width: 50px;
            height: 50px;
            background: var(--primary-color);
            border-radius: 50%;
            display: flex;
            align-items: center;
            justify-content: center;
            color: white;
        }

        .flight-details {
            border-top: 1px solid #eee;
            padding-top: 1.5rem;
        }

        .route {
            display: grid;
            grid-template-columns: 1fr auto 1fr;
            gap: 1rem;
            align-items: center;
            margin-bottom: 1.5rem;
        }

        .flight-path {
            color: var(--primary-color);
        }

        .booking-section {
            display: flex;
            justify-content: space-between;
            align-items: center;
        }

        .price {
            font-size: 1.5rem;
            font-weight: bold;
            color: var(--primary-color);
        }

        @media (max-width: 768px) {
            .hero-content h1 {
                font-size: 2rem;
            }

            .search-card {
                padding: 1rem;
            }

            .tab-btn {
                padding: 0.5rem 1rem;
            }

            .destinations-grid,
            .flights-grid {
                grid-template-columns: 1fr;
            }
        }
    </style>

</asp:Content>
