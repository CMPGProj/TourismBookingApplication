<%@ Page Title="Reports" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeBehind="Reports.aspx.cs" Inherits="TourismBookingApp.Reports" %>
<asp:Content ID="Content1" ContentPlaceHolderID="MainContent" runat="server">
    <h2>Report 1: Revenue by Attraction (summary)</h2>
    <asp:GridView ID="gvRevenue" runat="server" CssClass="grid" AutoGenerateColumns="false">
        <Columns>
            <asp:BoundField DataField="Attraction_Name" HeaderText="Attraction" />
            <asp:BoundField DataField="Town_Name" HeaderText="Town" />
            <asp:BoundField DataField="Total_Bookings" HeaderText="Bookings" />
            <asp:BoundField DataField="Total_Revenue" HeaderText="Revenue" DataFormatString="{0:C}" />
        </Columns>
    </asp:GridView>

    <h2>Report 2: Bookings by Tourist and Date Range</h2>
    <div class="formPanel">
        <label>Tourist</label>
        <asp:DropDownList ID="ddlTourist" runat="server" DataTextField="DisplayName" DataValueField="Tourist_ID" />

        <label>From</label>
        <asp:TextBox ID="txtFrom" runat="server" TextMode="Date" />

        <label>To</label>
        <asp:TextBox ID="txtTo" runat="server" TextMode="Date" />

        <div class="btnRow">
            <asp:Button ID="btnSearch" runat="server" Text="Search" OnClick="btnSearch_Click" />
        </div>
    </div>

    <asp:GridView ID="gvBookings" runat="server" CssClass="grid" AutoGenerateColumns="false">
        <Columns>
            <asp:BoundField DataField="Attraction_Name" HeaderText="Attraction" />
            <asp:BoundField DataField="Booking_Date" HeaderText="Date" DataFormatString="{0:yyyy-MM-dd}" />
            <asp:BoundField DataField="Booking_Time" HeaderText="Time" />
            <asp:BoundField DataField="Status" HeaderText="Status" />
        </Columns>
    </asp:GridView>
</asp:Content>
