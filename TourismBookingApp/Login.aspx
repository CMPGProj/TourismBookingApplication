<%@ Page Title="Log in" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeBehind="Login.aspx.cs" Inherits="TourismBookingApp.Login" %>
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

            <h2>Log in</h2>
            <p class="authSubtitle">Choose who you are, then enter your details.</p>

            <asp:Panel ID="pnlError" runat="server" CssClass="errorBanner" Visible="false">
                <asp:Literal ID="litError" runat="server" />
            </asp:Panel>

            <label>I am logging in as</label>
            <div class="radioCardGroup">
                <label class="radioCard">
                    <asp:RadioButton ID="rbTourist" runat="server" GroupName="userType" Checked="true" AutoPostBack="true" OnCheckedChanged="UserType_Changed" />
                    <span>
                        <span class="radioCardLabel">A tourist</span><br />
                        <span class="radioCardHint">Log in with your email address</span>
                    </span>
                </label>
                <label class="radioCard">
                    <asp:RadioButton ID="rbStaff" runat="server" GroupName="userType" AutoPostBack="true" OnCheckedChanged="UserType_Changed" />
                    <span>
                        <span class="radioCardLabel">A staff member</span><br />
                        <span class="radioCardHint">Log in with your username</span>
                    </span>
                </label>
            </div>

            <label><asp:Literal ID="litUsernameLabel" runat="server" Text="Email address" /> <span class="fieldHint">*</span></label>
            <asp:TextBox ID="txtUsername" runat="server" />
            <asp:RequiredFieldValidator ControlToValidate="txtUsername" ErrorMessage="This field is required" CssClass="fieldError" runat="server" Display="Dynamic" />

            <label>Password <span class="fieldHint">*</span></label>
            <asp:TextBox ID="txtPassword" runat="server" TextMode="Password" />
            <asp:RequiredFieldValidator ControlToValidate="txtPassword" ErrorMessage="This field is required" CssClass="fieldError" runat="server" Display="Dynamic" />

            <asp:Button ID="btnLogin" runat="server" Text=" Log in" CssClass="btnPrimary" OnClick="btnLogin_Click" />

            <div class="authFooter">
                New here? <a href="Register.aspx">Create an account</a><br />
                Staff who forget their password must ask an administrator to reset it.
            </div>
        </div>
    </div>
</asp:Content>
