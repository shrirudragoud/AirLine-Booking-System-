<%@ Page Language="C#" MasterPageFile="~/home.master" AutoEventWireup="true" CodeFile="Available seats.aspx.cs" Inherits="Available_seats" Title="Available Seats - Airline Reservation" %>

<asp:Content ID="Content1" ContentPlaceHolderID="ContentPlaceHolder1" Runat="Server">
    <div class="dashboard">
        <!-- Flight Selection -->
        <div class="card">
            <h3>Select Flight</h3>
            <div class="search-filters">
                <div class="form-group">
                    <asp:Label runat="server" Text="Flight Number"></asp:Label>
                    <asp:DropDownList ID="FlightList" runat="server" CssClass="form-control" AutoPostBack="true" 
                        OnSelectedIndexChanged="FlightList_SelectedIndexChanged">
                    </asp:DropDownList>
                </div>
            </div>
        </div>

        <!-- Seat Map -->
        <div class="card">
            <h3>Seat Map</h3>
            <div class="seat-map-container">
                <div class="seat-map-legend">
                    <div class="legend-item">
                        <div class="seat-icon available"></div>
                        <span>Available</span>
                    </div>
                    <div class="legend-item">
                        <div class="seat-icon occupied"></div>
                        <span>Occupied</span>
                    </div>
                    <div class="legend-item">
                        <div class="seat-icon selected"></div>
                        <span>Selected</span>
                    </div>
                </div>

                <div class="seat-map">
                    <asp:Repeater ID="SeatMapRepeater" runat="server">
                        <ItemTemplate>
                            <div class="seat <%# Convert.ToBoolean(Eval("IsAvailable")) ? "available" : "occupied" %>"
                                 data-seat-id="<%# Eval("SeatID") %>"
                                 data-seat-number="<%# Eval("SeatNumber") %>">
                                <%# Eval("SeatNumber") %>
                            </div>
                        </ItemTemplate>
                    </asp:Repeater>
                </div>

                <div class="seat-info">
                    <asp:Label ID="SelectedSeatInfo" runat="server" CssClass="alert alert-info" Visible="false"></asp:Label>
                </div>
            </div>
        </div>
    </div>

    <style>
        .seat-map-container {
            padding: 20px;
        }

        .seat-map-legend {
            display: flex;
            gap: 20px;
            margin-bottom: 20px;
            justify-content: center;
        }

        .legend-item {
            display: flex;
            align-items: center;
            gap: 8px;
        }

        .seat-icon {
            width: 30px;
            height: 30px;
            border-radius: 4px;
            border: 2px solid #ddd;
        }

        .seat-map {
            display: grid;
            grid-template-columns: repeat(6, 1fr);
            gap: 10px;
            max-width: 600px;
            margin: 0 auto;
            padding: 20px;
            background: var(--background-color);
            border-radius: 8px;
        }

        .seat {
            aspect-ratio: 1;
            display: flex;
            align-items: center;
            justify-content: center;
            border: 2px solid #ddd;
            border-radius: 4px;
            cursor: pointer;
            font-weight: bold;
            transition: all 0.3s ease;
        }

        .seat.available {
            background-color: var(--white);
            border-color: var(--primary-color);
            color: var(--primary-color);
        }

        .seat.occupied {
            background-color: #f5f5f5;
            border-color: #ddd;
            color: #999;
            cursor: not-allowed;
        }

        .seat.selected {
            background-color: var(--primary-color);
            border-color: var(--primary-color);
            color: var(--white);
        }

        .seat.available:hover {
            transform: scale(1.1);
            box-shadow: 0 2px 4px rgba(0,0,0,0.1);
        }

        .seat-info {
            margin-top: 20px;
            text-align: center;
        }

        @media (max-width: 768px) {
            .seat-map {
                grid-template-columns: repeat(4, 1fr);
                gap: 8px;
                padding: 10px;
            }

            .seat-map-legend {
                flex-direction: column;
                align-items: center;
            }
        }
    </style>

    <script type="text/javascript">
        function selectSeat(seatId, seatNumber) {
            // Remove previous selections
            document.querySelectorAll('.seat.selected').forEach(seat => {
                seat.classList.remove('selected');
            });

            // Add selected class to clicked seat
            const seat = document.querySelector(`[data-seat-id="${seatId}"]`);
            if (seat && seat.classList.contains('available')) {
                seat.classList.add('selected');
                document.getElementById('<%= SelectedSeatInfo.ClientID %>').innerHTML = 
                    `Selected Seat: ${seatNumber}`;
                document.getElementById('<%= SelectedSeatInfo.ClientID %>').style.display = 'block';
            }
        }
    </script>
</asp:Content>
