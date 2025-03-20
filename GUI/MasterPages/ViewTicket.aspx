<%@ Page Language="C#" MasterPageFile="~/home.master" AutoEventWireup="true" CodeFile="ViewTicket.aspx.cs" Inherits="ViewTicket" Title="View Ticket - AirBook" %>

<asp:Content ID="Content1" ContentPlaceHolderID="ContentPlaceHolder1" Runat="Server">
    <div class="ticket-page">
        <div class="ticket-container">
            <div class="ticket-actions">
                <button type="button" class="btn btn-primary" onclick="generatePDF()">
                    <span class="material-symbols-outlined">download</span>
                    Download E-Ticket
                </button>
            </div>

            <div id="ticket-content" class="ticket-content">
                <div class="ticket-header">
                    <div class="airline-logo">
                        <span class="material-symbols-outlined">flight</span>
                        <span>AirBook</span>
                    </div>
                    <h1>E-Ticket</h1>
                    <div class="booking-id">
                        Booking ID: <strong><asp:Literal ID="BookingIdLabel" runat="server"></asp:Literal></strong>
                    </div>
                </div>

                <div class="passenger-info">
                    <h2>Passenger Information</h2>
                    <div class="info-row">
                        <span class="label">Name:</span>
                        <strong><asp:Literal ID="PassengerNameLabel" runat="server"></asp:Literal></strong>
                    </div>
                </div>

                <div class="flight-info">
                    <h2>Flight Details</h2>
                    <div class="info-grid">
                        <div class="info-row">
                            <span class="label">Flight Number:</span>
                            <strong><asp:Literal ID="FlightNumberLabel" runat="server"></asp:Literal></strong>
                        </div>
                        <div class="info-row">
                            <span class="label">Class:</span>
                            <strong><asp:Literal ID="ClassLabel" runat="server"></asp:Literal></strong>
                        </div>
                        <div class="info-row">
                            <span class="label">Seat:</span>
                            <strong><asp:Literal ID="SeatLabel" runat="server"></asp:Literal></strong>
                        </div>
                        <div class="info-row">
                            <span class="label">Date:</span>
                            <strong><asp:Literal ID="DateLabel" runat="server"></asp:Literal></strong>
                        </div>
                    </div>

                    <div class="route-info">
                        <div class="from">
                            <span class="label">From</span>
                            <strong><asp:Literal ID="FromLabel" runat="server"></asp:Literal></strong>
                        </div>
                        <div class="route-line">
                            <span class="material-symbols-outlined">arrow_forward</span>
                        </div>
                        <div class="to">
                            <span class="label">To</span>
                            <strong><asp:Literal ID="ToLabel" runat="server"></asp:Literal></strong>
                        </div>
                    </div>
                </div>

                <div class="ticket-footer">
                    <div class="qr-code" id="qr-code"></div>
                    <div class="terms">
                        <p>This is a demo e-ticket. For demonstration purposes only.</p>
                    </div>
                </div>
            </div>
        </div>
    </div>

    <!-- Add jsPDF and QR code libraries -->
    <script src="https://cdnjs.cloudflare.com/ajax/libs/jspdf/2.5.1/jspdf.umd.min.js"></script>
    <script src="https://cdn.jsdelivr.net/npm/qrcode-generator@1.4.4/qrcode.min.js"></script>

    <script type="text/javascript">
        window.jsPDF = window.jspdf.jsPDF;

        function generatePDF() {
            const doc = new jsPDF();
            const content = document.getElementById('ticket-content');
            
            // Set font
            doc.setFont('helvetica');
            
            // Add airline logo text
            doc.setFontSize(24);
            doc.text('AirBook', 20, 20);
            
            // Add E-Ticket header
            doc.setFontSize(20);
            doc.text('E-Ticket', 20, 40);
            
            // Add booking details
            doc.setFontSize(12);
            doc.text('Booking ID: ' + document.getElementById('BookingIdLabel').innerText, 20, 55);
            
            // Add passenger info
            doc.setFontSize(14);
            doc.text('Passenger Information', 20, 75);
            doc.setFontSize(12);
            doc.text('Name: ' + document.getElementById('PassengerNameLabel').innerText, 20, 85);
            
            // Add flight details
            doc.setFontSize(14);
            doc.text('Flight Details', 20, 105);
            doc.setFontSize(12);
            doc.text('Flight: ' + document.getElementById('FlightNumberLabel').innerText, 20, 115);
            doc.text('Class: ' + document.getElementById('ClassLabel').innerText, 20, 125);
            doc.text('Seat: ' + document.getElementById('SeatLabel').innerText, 20, 135);
            doc.text('Date: ' + document.getElementById('DateLabel').innerText, 20, 145);
            
            // Add route info
            doc.text('From: ' + document.getElementById('FromLabel').innerText, 20, 165);
            doc.text('To: ' + document.getElementById('ToLabel').innerText, 20, 175);
            
            // Add footer
            doc.setFontSize(10);
            doc.text('This is a demo e-ticket. For demonstration purposes only.', 20, 250);
            
            // Generate QR code
            const qr = qrcode(4, 'L');
            qr.addData(document.getElementById('BookingIdLabel').innerText);
            qr.make();
            const qrImage = qr.createDataURL();
            doc.addImage(qrImage, 'PNG', 150, 230, 40, 40);
            
            // Save the PDF
            doc.save('e-ticket.pdf');
        }

        // Generate QR code on page load
        window.onload = function() {
            const qr = qrcode(4, 'L');
            qr.addData(document.getElementById('BookingIdLabel').innerText);
            qr.make();
            document.getElementById('qr-code').innerHTML = qr.createImgTag();
        };
    </script>

    <style>
        .ticket-page {
            padding: 2rem;
            background: linear-gradient(135deg, #f5f7fa 0%, #c3cfe2 100%);
            min-height: calc(100vh - 140px);
        }

        .ticket-container {
            max-width: 800px;
            margin: 0 auto;
        }

        .ticket-actions {
            margin-bottom: 2rem;
            text-align: right;
        }

        .ticket-content {
            background: white;
            border-radius: 12px;
            box-shadow: 0 4px 6px rgba(0,0,0,0.1);
            padding: 2rem;
        }

        .ticket-header {
            text-align: center;
            margin-bottom: 2rem;
            padding-bottom: 1rem;
            border-bottom: 1px solid var(--border-color);
        }

        .airline-logo {
            display: flex;
            align-items: center;
            justify-content: center;
            gap: 0.5rem;
            margin-bottom: 1rem;
            font-size: 1.5rem;
            color: var(--primary-color);
        }

        .booking-id {
            color: var(--text-light);
        }

        .passenger-info,
        .flight-info {
            margin-bottom: 2rem;
        }

        h2 {
            color: var(--primary-color);
            margin-bottom: 1rem;
            font-size: 1.25rem;
        }

        .info-grid {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(200px, 1fr));
            gap: 1rem;
            margin-bottom: 1.5rem;
        }

        .info-row {
            margin-bottom: 0.5rem;
        }

        .info-row .label {
            color: var(--text-light);
            margin-right: 0.5rem;
        }

        .route-info {
            display: grid;
            grid-template-columns: 1fr auto 1fr;
            gap: 2rem;
            align-items: center;
            margin-top: 1.5rem;
            padding: 1.5rem;
            background: var(--background-light);
            border-radius: 8px;
        }

        .route-line {
            color: var(--primary-color);
        }

        .from,
        .to {
            text-align: center;
        }

        .ticket-footer {
            margin-top: 2rem;
            padding-top: 2rem;
            border-top: 1px solid var(--border-color);
            text-align: center;
        }

        .qr-code {
            margin-bottom: 1rem;
        }

        .qr-code img {
            max-width: 150px;
        }

        .terms {
            color: var(--text-light);
            font-size: 0.875rem;
        }

        @media (max-width: 768px) {
            .ticket-page {
                padding: 1rem;
            }

            .route-info {
                grid-template-columns: 1fr;
                gap: 1rem;
            }

            .route-line {
                transform: rotate(90deg);
            }
        }
    </style>
</asp:Content>