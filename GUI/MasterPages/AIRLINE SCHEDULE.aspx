<%@ Page Language="C#" MasterPageFile="~/home.master" AutoEventWireup="true" CodeFile="AIRLINE SCHEDULE.aspx.cs" Inherits="AIRLINE_SCHEDULE" Title="Flight Schedule - AirBook" %>

<asp:Content ID="Content1" ContentPlaceHolderID="ContentPlaceHolder1" Runat="Server">
    <div class="schedule-page">
        <!-- Search Section -->
        <div class="search-section card">
            <div class="search-header">
                <h2><span class="material-symbols-outlined">flight</span> Search Flights</h2>
                <p>Find the best flights for your journey</p>
            </div>

            <div class="search-form">
                <div class="form-row">
                    <div class="form-group">
                        <label>
                            <span class="material-symbols-outlined">flight_takeoff</span>
                            From
                        </label>
                        <asp:DropDownList ID="FromCity" runat="server" CssClass="form-control" 
                            AutoPostBack="true" OnSelectedIndexChanged="Filter_Changed">
                        </asp:DropDownList>
                    </div>

                    <div class="form-group">
                        <label>
                            <span class="material-symbols-outlined">flight_land</span>
                            To
                        </label>
                        <asp:DropDownList ID="ToCity" runat="server" CssClass="form-control"
                            AutoPostBack="true" OnSelectedIndexChanged="Filter_Changed">
                        </asp:DropDownList>
                    </div>

                    <div class="form-group">
                        <label>
                            <span class="material-symbols-outlined">sort</span>
                            Sort By
                        </label>
                        <asp:DropDownList ID="SortBy" runat="server" CssClass="form-control"
                            AutoPostBack="true" OnSelectedIndexChanged="Filter_Changed">
                            <asp:ListItem Value="time">Departure Time</asp:ListItem>
                            <asp:ListItem Value="price">Price (Low to High)</asp:ListItem>
                            <asp:ListItem Value="price_desc">Price (High to Low)</asp:ListItem>
                            <asp:ListItem Value="duration">Duration</asp:ListItem>
                        </asp:DropDownList>
                    </div>
                </div>
            </div>

            <!-- Debug Info (visible in development) -->
            <% if (Request.IsLocal) { %>
            <div class="debug-info card">
                <h4>Debug Information:</h4>
                <p>FromCity: <%= FromCity.SelectedValue %></p>
                <p>ToCity: <%= ToCity.SelectedValue %></p>
                <p>Sort: <%= SortBy.SelectedValue %></p>
                <p>Connection: <%= ConfigurationManager.ConnectionStrings["conn"].ConnectionString %></p>
            </div>
            <% } %>
        </div>

        <!-- Flights List -->
        <asp:Repeater ID="FlightsList" runat="server" OnItemCommand="FlightsList_ItemCommand">
            <ItemTemplate>
                <div class="flight-card card">
                    <div class="flight-header">
                        <div class="airline-info">
                            <span class="material-symbols-outlined">flight</span>
                            <div>
                                <h3><%# Eval("FlightName") %></h3>
                                <p class="flight-number"><%# Eval("FlightNumber") %></p>
                            </div>
                        </div>
                        <div class="price-tag">
                            <span class="price">₹<%# Eval("BasePrice", "{0:N0}") %></span>
                            <span class="per-person">per person</span>
                        </div>
                    </div>

                    <div class="flight-details">
                        <div class="route-info">
                            <div class="departure">
                                <div class="time"><%# Eval("DepartureTime", "{0:hh:mm tt}") %></div>
                                <div class="city"><%# Eval("Origin") %></div>
                                <div class="date"><%# Eval("DepartureTime", "{0:MMM dd, yyyy}") %></div>
                            </div>

                            <div class="flight-path">
                                <div class="duration"><%# GetFlightDuration(Eval("DepartureTime"), Eval("ArrivalTime")) %></div>
                                <div class="path-line">
                                    <span class="material-symbols-outlined">arrow_forward</span>
                                </div>
                                <div class="stops">Direct Flight</div>
                            </div>

                            <div class="arrival">
                                <div class="time"><%# Eval("ArrivalTime", "{0:hh:mm tt}") %></div>
                                <div class="city"><%# Eval("Destination") %></div>
                                <div class="date"><%# Eval("ArrivalTime", "{0:MMM dd, yyyy}") %></div>
                            </div>
                        </div>

                        <div class="flight-actions">
                            <div class="seats-info">
                                <span class="material-symbols-outlined">chair</span>
                                <span class="<%# Convert.ToInt32(Eval("AvailableSeats")) > 10 ? "status-available" : "status-limited" %>">
                                    <%# Eval("AvailableSeats") %> seats available
                                </span>
                            </div>
                            <asp:LinkButton ID="BookNow" runat="server" CssClass="btn btn-primary" 
                                CommandName="BookFlight" CommandArgument='<%# Eval("FlightID") %>'>
                                <span class="material-symbols-outlined">airplane_ticket</span>
                                Book Now
                            </asp:LinkButton>
                        </div>
                    </div>
                </div>
            </ItemTemplate>
            <FooterTemplate>
                <asp:Panel ID="NoFlights" runat="server" CssClass="no-flights card" 
                    Visible='<%# FlightsList.Items.Count == 0 %>'>
                    <span class="material-symbols-outlined">info</span>
                    <h3>No Flights Found</h3>
                    <p>Try different search criteria or dates</p>
                </asp:Panel>
            </FooterTemplate>
        </asp:Repeater>
    </div>
</asp:Content>
