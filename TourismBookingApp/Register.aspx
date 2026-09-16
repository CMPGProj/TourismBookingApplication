<%@ Page Title="Sign Up" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeBehind="Register.aspx.cs" Inherits="TourismBookingApp.Register" %>
<asp:Content ID="Content1" ContentPlaceHolderID="MainContent" runat="server">
    <div class="authWrap">
        <div class="authCard">
            <div class="authBrand">
                <span class="brandIcon"></span>
                <span class="brandText">
                    <span class="brandTitle">Tourism Booking</span><br />
                    <span class="brandSubtitle">Management System</span>
                </span>
            </div>

            <h2>Create a tourist account</h2>
            <p class="authSubtitle">Register once to explore attractions, make bookings and write reviews.</p>

            <asp:Panel ID="pnlError" runat="server" CssClass="errorBanner" Visible="false">
                <asp:Literal ID="litError" runat="server" />
            </asp:Panel>

            <div class="authRow2">
                <div>
                    <label>First name <span class="fieldHint">*</span></label>
                    <asp:TextBox ID="txtFirstName" runat="server" />
                    <asp:RequiredFieldValidator ControlToValidate="txtFirstName" ErrorMessage="Required" CssClass="fieldError" runat="server" Display="Dynamic" />
                </div>
                <div>
                    <label>Last name <span class="fieldHint">*</span></label>
                    <asp:TextBox ID="txtLastName" runat="server" />
                    <asp:RequiredFieldValidator ControlToValidate="txtLastName" ErrorMessage="Required" CssClass="fieldError" runat="server" Display="Dynamic" />
                </div>
            </div>

            <label>Email address <span class="fieldHint">* (you log in with this)</span></label>
            <asp:TextBox ID="txtEmail" runat="server" />
            <asp:RequiredFieldValidator ControlToValidate="txtEmail" ErrorMessage="Email is required" CssClass="fieldError" runat="server" Display="Dynamic" />
            <asp:RegularExpressionValidator ControlToValidate="txtEmail" ValidationExpression="\S+@\S+\.\S+"
                ErrorMessage="Enter a valid email" CssClass="fieldError" runat="server" Display="Dynamic" />

            <label>Phone number <span class="fieldHint">(optional, 10 digits, no spaces)</span></label>
            <asp:TextBox ID="txtPhone" runat="server" />
            <asp:RegularExpressionValidator ControlToValidate="txtPhone" ValidationExpression="^$|^\d{10}$"
                ErrorMessage="Enter 10 digits, no spaces" CssClass="fieldError" runat="server" Display="Dynamic" />

            <label>Password <span class="fieldHint">* at least 8 characters</span></label>
            <asp:TextBox ID="txtPassword" runat="server" TextMode="Password" />
            <asp:RequiredFieldValidator ControlToValidate="txtPassword" ErrorMessage="Password is required" CssClass="fieldError" runat="server" Display="Dynamic" />
            <asp:RegularExpressionValidator ControlToValidate="txtPassword" ValidationExpression=".{8,}"
                ErrorMessage="Password must be at least 8 characters" CssClass="fieldError" runat="server" Display="Dynamic" />

            <label>Confirm password <span class="fieldHint">*</span></label>
            <asp:TextBox ID="txtConfirmPassword" runat="server" TextMode="Password" />
            <asp:CompareValidator ControlToValidate="txtConfirmPassword" ControlToCompare="txtPassword"
                ErrorMessage="The passwords do not match" CssClass="fieldError" runat="server" Display="Dynamic" />

            <asp:Button ID="btnRegister" runat="server" Text="Create account" CssClass="btnPrimary" OnClick="btnRegister_Click" />

            <div class="authFooter">
                Already registered? <a href="Login.aspx">Log in</a>
            </div>
        </div>
    </div>
</asp:Content>
