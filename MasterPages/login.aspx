<%@ Page Language="C#" MasterPageFile="~/home.master" AutoEventWireup="true" CodeFile="login.aspx.cs" Inherits="login" Title="Login - AirBook" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
    <script src="../Scripts/verify-styles.js" type="text/javascript"></script>
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" Runat="Server">
    <div class="login-page">
        <div class="login-container">
            <!-- Login Form Card -->
            <div class="login-card card animate-slide-in">
                <div class="login-header">
                    <div class="logo-container">
                        <span class="material-symbols-outlined">flight</span>
                    </div>
                    <h2>Welcome to AirBook</h2>
                    <p class="text-light">Sign in to continue your journey</p>
                </div>

                <div class="login-form">
                    <div class="form-group">
                        <label for="<%= TextBox1.ClientID %>">
                            <span class="material-symbols-outlined">person</span>
                            Username
                        </label>
                        <asp:TextBox ID="TextBox1" runat="server" CssClass="form-control" 
                            placeholder="Enter your username">
                        </asp:TextBox>
                        <asp:RequiredFieldValidator ID="RequiredFieldValidator1" runat="server" 
                            ControlToValidate="TextBox1" ErrorMessage="Username is required"
                            CssClass="validation-error" Display="Dynamic">
                        </asp:RequiredFieldValidator>
                    </div>

                    <div class="form-group">
                        <label for="<%= TextBox2.ClientID %>">
                            <span class="material-symbols-outlined">lock</span>
                            Password
                        </label>
                        <div class="password-input">
                            <asp:TextBox ID="TextBox2" runat="server" TextMode="Password" CssClass="form-control" 
                                placeholder="Enter your password">
                            </asp:TextBox>
                            <button type="button" class="toggle-password" onclick="togglePassword()">
                                <span class="material-symbols-outlined">visibility</span>
                            </button>
                        </div>
                        <asp:RequiredFieldValidator ID="RequiredFieldValidator2" runat="server" 
                            ControlToValidate="TextBox2" ErrorMessage="Password is required"
                            CssClass="validation-error" Display="Dynamic">
                        </asp:RequiredFieldValidator>
                    </div>

                    <div class="form-group">
                        <asp:Button ID="Button1" runat="server" Text="Sign In" OnClick="Button1_Click" 
                            CssClass="btn btn-primary w-100" />
                    </div>

                    <asp:Label ID="Label1" runat="server" CssClass="alert alert-danger" Visible="False"></asp:Label>

                    <div class="login-help">
                        <p>Default Credentials:</p>
                        <code>Username: admin</code>
                        <code>Password: admin123</code>
                    </div>
                </div>
            </div>

            <!-- Features Section -->
            <div class="features-section">
                <div class="feature-card card animate-slide-in">
                    <span class="material-symbols-outlined">flight_takeoff</span>
                    <h3>Easy Booking</h3>
                    <p>Book flights to your favorite destinations with just a few clicks</p>
                </div>

                <div class="feature-card card animate-slide-in" style="animation-delay: 0.2s;">
                    <span class="material-symbols-outlined">chair</span>
                    <h3>Seat Selection</h3>
                    <p>Choose your preferred seats with our interactive seat map</p>
                </div>

                <div class="feature-card card animate-slide-in" style="animation-delay: 0.4s;">
                    <span class="material-symbols-outlined">support_agent</span>
                    <h3>24/7 Support</h3>
                    <p>Get assistance anytime with our dedicated support team</p>
                </div>
            </div>
        </div>
    </div>

    <!-- Style Verification -->
    <div id="styleDebug" class="style-debug" style="display: none;">
        <div class="debug-info"></div>
    </div>

    <script type="text/javascript">
        function togglePassword() {
            var passwordInput = document.getElementById('<%= TextBox2.ClientID %>');
            var toggleBtn = document.querySelector('.toggle-password .material-symbols-outlined');
            
            if (passwordInput.type === 'password') {
                passwordInput.type = 'text';
                toggleBtn.textContent = 'visibility_off';
            } else {
                passwordInput.type = 'password';
                toggleBtn.textContent = 'visibility';
            }
        }
    </script>
</asp:Content>
