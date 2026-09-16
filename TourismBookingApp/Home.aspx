<%@ Page Title="Home" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeBehind="Home.aspx.cs" Inherits="TourismBookingApp.Home" %>
<asp:Content ID="Content1" ContentPlaceHolderID="MainContent" runat="server">
    <h2>Welcome to the Tourism Management and Booking System</h2>

    <asp:Panel ID="pnlGuest" runat="server" Visible="false">
        <p>Log in to make bookings and manage your trips, or create a free account if you're new here.</p>
        <div class="btnRow">
            <asp:HyperLink runat="server" NavigateUrl="~/Login.aspx" CssClass="ctaButton">Login</asp:HyperLink>
            <asp:HyperLink runat="server" NavigateUrl="~/Register.aspx" CssClass="ctaButton ctaButtonSecondary">Sign Up</asp:HyperLink>
        </div>
    </asp:Panel>

    <asp:Panel ID="pnlStaff" runat="server" Visible="false">
        <div class="statsRow">
            <div class="statBox"><span class="statNum"><asp:Literal ID="litTourists" runat="server" /></span><br />Tourists</div>
            <div class="statBox"><span class="statNum"><asp:Literal ID="litAttractions" runat="server" /></span><br />Attractions</div>
            <div class="statBox"><span class="statNum"><asp:Literal ID="litBookings" runat="server" /></span><br />Active Bookings</div>
            <div class="statBox"><span class="statNum"><asp:Literal ID="litRevenue" runat="server" /></span><br />Revenue</div>
        </div>
        <p>Use the menu above to maintain data, manage bookings, and view reports.</p>
    </asp:Panel>

    <asp:Panel ID="pnlTourist" runat="server" Visible="false">
        <h3>Your Upcoming Bookings</h3>
        <asp:GridView ID="gvUpcoming" runat="server" CssClass="grid" AutoGenerateColumns="false">
            <Columns>
                <asp:BoundField DataField="Attraction_Name" HeaderText="Attraction" />
                <asp:BoundField DataField="Booking_Date" HeaderText="Date" DataFormatString="{0:d}" />
                <asp:BoundField DataField="Booking_Time" HeaderText="Time" />
                <asp:BoundField DataField="Status" HeaderText="Status" />
            </Columns>
        </asp:GridView>
        <asp:Label ID="lblNoUpcoming" runat="server" Visible="false" Text="You have no upcoming bookings - try Make Booking above." />

        <h3>Featured Attractions</h3>
        <asp:GridView ID="gvFeatured" runat="server" CssClass="grid" AutoGenerateColumns="false">
            <Columns>
                <asp:BoundField DataField="Attraction_Name" HeaderText="Attraction" />
                <asp:BoundField DataField="Category" HeaderText="Category" />
                <asp:BoundField DataField="Price" HeaderText="Price" DataFormatString="{0:C}" />
                <asp:BoundField DataField="Town_Name" HeaderText="Town" />
            </Columns>
        </asp:GridView>
    </asp:Panel>

    <p>Click the "Help ?" button in the bottom-right corner at any time for booking help.</p>
</asp:Content>
