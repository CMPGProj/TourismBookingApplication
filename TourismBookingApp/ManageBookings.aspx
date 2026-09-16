<%@ Page Title="My Bookings" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeBehind="ManageBookings.aspx.cs" Inherits="TourismBookingApp.ManageBookings" %>
<asp:Content ID="Content1" ContentPlaceHolderID="MainContent" runat="server">
    <h2><asp:Literal ID="litHeading" runat="server" Text="My Bookings" /></h2>
    <p class="pageIntro">Change the date, time or number of people of a booking, or cancel it.</p>

    <asp:Panel ID="pnlTouristPicker" runat="server" CssClass="formPanel" Visible="false">
        <label>Tourist</label>
        <asp:DropDownList ID="ddlTourist" runat="server" AutoPostBack="true"
            OnSelectedIndexChanged="ddlTourist_SelectedIndexChanged"
            DataTextField="DisplayName" DataValueField="Tourist_ID" />
    </asp:Panel>

    <div class="splitLayout">
        <div class="splitList">
            <asp:GridView ID="gvBookings" runat="server" CssClass="niceTable" AutoGenerateColumns="false"
                DataKeyNames="Booking_ID" OnRowCommand="gvBookings_RowCommand" GridLines="None"
                OnRowDataBound="gvBookings_RowDataBound">
                <Columns>
                    <asp:BoundField DataField="Booking_Date" HeaderText="Date" DataFormatString="{0:d MMM yyyy}" />
                    <asp:BoundField DataField="Booking_Time" HeaderText="Time" />
                    <asp:BoundField DataField="Attraction_Name" HeaderText="Attraction" />
                    <asp:BoundField DataField="Participants" HeaderText="People" />
                    <asp:BoundField DataField="Total" HeaderText="Total" DataFormatString="{0:C}" />
                    <asp:TemplateField HeaderText="Status">
                        <ItemTemplate>
                            <span class='<%# StatusPillClass(Eval("Status")) %>'><%# Eval("Status") %></span>
                        </ItemTemplate>
                    </asp:TemplateField>
                    <asp:TemplateField HeaderText="">
                        <ItemTemplate>
                            <asp:LinkButton runat="server" CommandName="SelectRow" CommandArgument='<%# Eval("Booking_ID") %>' CssClass="btnGhost">Select</asp:LinkButton>
                        </ItemTemplate>
                    </asp:TemplateField>
                </Columns>
            </asp:GridView>
        </div>

        <div class="splitPanel">
            <asp:Panel ID="pnlNoSelection" runat="server">
                <h3>Booking details</h3>
                <p class="pageIntro">Select a booking on the left to view or change it.</p>
            </asp:Panel>

            <asp:Panel ID="pnlDetail" runat="server" Visible="false">
                <h3>Booking <asp:Literal ID="litBookingId" runat="server" /></h3>
                <p class="pageIntro"><asp:Literal ID="litAttractionAndTown" runat="server" /></p>

                <label>Date <span class="fieldHint">*</span></label>
                <asp:TextBox ID="txtDate" runat="server" TextMode="Date" />

                <label>Time <span class="fieldHint">*</span></label>
                <asp:TextBox ID="txtTime" runat="server" TextMode="Time" />

                <label>Participants <span class="fieldHint">(1 to 20)</span></label>
                <asp:TextBox ID="txtParticipants" runat="server" TextMode="Number" AutoPostBack="true" OnTextChanged="txtParticipants_TextChanged" />

                <p class="pageIntro" style="margin-top:14px;">TOTAL</p>
                <div class="priceTotal"><asp:Literal ID="litTotal" runat="server" /></div>

                <div class="btnSecondaryRow">
                    <asp:Button ID="btnSave" runat="server" Text="Save changes" CssClass="btnPrimary" OnClick="btnSave_Click" style="margin-top:0;" />
                    <asp:LinkButton ID="btnCancelBooking" runat="server" Text="Cancel booking" CssClass="btnGhost" OnClick="btnCancelBooking_Click"
                        OnClientClick="return confirm('Cancel this booking?');" />
                </div>
                <asp:PlaceHolder ID="phAttend" runat="server" Visible="false">
                    <div class="btnSecondaryRow">
                        <asp:LinkButton ID="btnAttend" runat="server" Text="Mark attended" CssClass="btnGhost" OnClick="btnAttend_Click" />
                    </div>
                </asp:PlaceHolder>
                <p class="pageIntro">You can change or cancel a booking any time before its date.</p>
                <asp:Label ID="lblMessage" runat="server" CssClass="validationMsg" />
            </asp:Panel>
        </div>
    </div>
</asp:Content>
