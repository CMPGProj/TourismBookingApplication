<%@ Page Title="My Profile" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeBehind="MyProfile.aspx.cs" Inherits="TourismBookingApp.MyProfile" %>
<asp:Content ID="Content1" ContentPlaceHolderID="MainContent" runat="server">
    <h2>My Profile</h2>
    <p>Update your own account details. Leave the password fields blank to keep your current password.</p>

    <div class="formPanel">
        <label>First Name</label>
        <asp:TextBox ID="txtFirstName" runat="server" />
        <asp:RequiredFieldValidator ControlToValidate="txtFirstName" ErrorMessage="First name is required" CssClass="validationMsg" runat="server" Display="Dynamic" />

        <label>Last Name</label>
        <asp:TextBox ID="txtLastName" runat="server" />
        <asp:RequiredFieldValidator ControlToValidate="txtLastName" ErrorMessage="Last name is required" CssClass="validationMsg" runat="server" Display="Dynamic" />

        <label>Email</label>
        <asp:TextBox ID="txtEmail" runat="server" />
        <asp:RequiredFieldValidator ControlToValidate="txtEmail" ErrorMessage="Email is required" CssClass="validationMsg" runat="server" Display="Dynamic" />
        <asp:RegularExpressionValidator ControlToValidate="txtEmail" ValidationExpression="\S+@\S+\.\S+"
            ErrorMessage="Enter a valid email" CssClass="validationMsg" runat="server" Display="Dynamic" />

        <label>Phone</label>
        <asp:TextBox ID="txtPhone" runat="server" />
        <asp:RequiredFieldValidator ControlToValidate="txtPhone" ErrorMessage="Phone is required" CssClass="validationMsg" runat="server" Display="Dynamic" />

        <label>New Password</label>
        <asp:TextBox ID="txtPassword" runat="server" TextMode="Password" />

        <label>Confirm New Password</label>
        <asp:TextBox ID="txtConfirmPassword" runat="server" TextMode="Password" />
        <asp:CompareValidator ControlToValidate="txtConfirmPassword" ControlToCompare="txtPassword"
            ErrorMessage="Passwords do not match" CssClass="validationMsg" runat="server" Display="Dynamic" />

        <div class="btnRow">
            <asp:Button ID="btnSave" runat="server" Text="Save Changes" OnClick="btnSave_Click" />
        </div>
        <asp:Label ID="lblMessage" runat="server" CssClass="validationMsg" />
    </div>
</asp:Content>
