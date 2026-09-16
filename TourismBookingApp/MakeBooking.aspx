<%@ Page Title="Explore Attractions" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeBehind="MakeBooking.aspx.cs" Inherits="TourismBookingApp.MakeBooking" %>
<asp:Content ID="Content1" ContentPlaceHolderID="MainContent" runat="server">
    <h2>Explore attractions</h2>
    <p class="pageIntro">Choose a place to see what you can book, then click Book.</p>

    <div class="splitLayout">
        <div class="splitList">
            <div class="filterRow">
                <asp:DropDownList ID="ddlTownFilter" runat="server" AutoPostBack="true" OnSelectedIndexChanged="Filter_Changed">
                    <asp:ListItem Text="All towns" Value="" />
                </asp:DropDownList>
                <asp:DropDownList ID="ddlCategoryFilter" runat="server" AutoPostBack="true" OnSelectedIndexChanged="Filter_Changed">
                    <asp:ListItem Text="All categories" Value="" />
                </asp:DropDownList>
                <asp:TextBox ID="txtSearch" runat="server" placeholder="Search attractions..." />
                <asp:Button ID="btnSearch" runat="server" Text="Search" CssClass="btnGhost" OnClick="Filter_Changed" />
            </div>

            <asp:GridView ID="gvAttractions" runat="server" CssClass="niceTable" AutoGenerateColumns="false"
                DataKeyNames="Attraction_ID" OnRowCommand="gvAttractions_RowCommand" GridLines="None">
                <Columns>
                    <asp:TemplateField HeaderText="Attraction">
                        <ItemTemplate><strong><%# Eval("Attraction_Name") %></strong></ItemTemplate>
                    </asp:TemplateField>
                    <asp:BoundField DataField="Town_Name" HeaderText="Town" />
                    <asp:BoundField DataField="Price" HeaderText="Price" DataFormatString="{0:C}" />
                    <asp:TemplateField HeaderText="Rating">
                        <ItemTemplate>
                            <span class="starRating"><%# FormatStars(Eval("Avg_Rating")) %></span>
                        </ItemTemplate>
                    </asp:TemplateField>
                    <asp:TemplateField HeaderText="">
                        <ItemTemplate>
                            <asp:LinkButton runat="server" CommandName="SelectRow" CommandArgument='<%# Eval("Attraction_ID") %>'
                                CssClass='<%# Eval("Attraction_ID").ToString() == SelectedAttractionId ? "pillBooked" : "btnGhost" %>'>
                                <%# Eval("Attraction_ID").ToString() == SelectedAttractionId ? "Selected" : "Book" %>
                            </asp:LinkButton>
                        </ItemTemplate>
                    </asp:TemplateField>
                </Columns>
            </asp:GridView>
        </div>

        <div class="splitPanel">
            <asp:Panel ID="pnlNoSelection" runat="server">
                <h3>Book an attraction</h3>
                <p class="pageIntro">Pick an attraction on the left to book it.</p>
            </asp:Panel>

            <asp:Panel ID="pnlBookingForm" runat="server" Visible="false">
                <h3>Book <asp:Literal ID="litSelectedName" runat="server" /></h3>
                <p class="pageIntro">
                    Offered by <asp:Literal ID="litBusiness" runat="server" /><br />
                    <asp:Literal ID="litTown" runat="server" /> &middot;
                    <asp:Literal ID="litPrice" runat="server" /> per person
                </p>

                <asp:PlaceHolder ID="phTouristPicker" runat="server">
                    <label>Tourist</label>
                    <asp:DropDownList ID="ddlTourist" runat="server" DataTextField="DisplayName" DataValueField="Tourist_ID" />
                </asp:PlaceHolder>
                <asp:PlaceHolder ID="phSelfBooking" runat="server" Visible="false">
                    <label>Booking as</label>
                    <p><strong><asp:Literal ID="litSelfName" runat="server" /></strong></p>
                </asp:PlaceHolder>

                <label>Date <span class="fieldHint">*</span></label>
                <asp:TextBox ID="txtDate" runat="server" TextMode="Date" />
                <asp:RequiredFieldValidator ControlToValidate="txtDate" ErrorMessage="Date is required" CssClass="fieldError" runat="server" Display="Dynamic" ValidationGroup="booking" />

                <label>Time <span class="fieldHint">*</span></label>
                <asp:TextBox ID="txtTime" runat="server" TextMode="Time" />
                <asp:RequiredFieldValidator ControlToValidate="txtTime" ErrorMessage="Time is required" CssClass="fieldError" runat="server" Display="Dynamic" ValidationGroup="booking" />

                <label>Participants <span class="fieldHint">(1 to 20)</span></label>
                <asp:TextBox ID="txtParticipants" runat="server" TextMode="Number" Text="1" AutoPostBack="true" OnTextChanged="txtParticipants_TextChanged" />
                <asp:RangeValidator ControlToValidate="txtParticipants" MinimumValue="1" MaximumValue="20" Type="Integer"
                    ErrorMessage="Enter 1 to 20" CssClass="fieldError" runat="server" Display="Dynamic" ValidationGroup="booking" />

                <p class="pageIntro" style="margin-top:14px;">TOTAL</p>
                <div class="priceTotal"><asp:Literal ID="litTotal" runat="server" /></div>

                <div class="btnSecondaryRow">
                    <asp:Button ID="btnBook" runat="server" Text="Confirm booking" CssClass="btnPrimary" OnClick="btnBook_Click" ValidationGroup="booking" style="margin-top:0;" />
                    <asp:LinkButton ID="btnCancelSelection" runat="server" Text="Cancel" CssClass="btnGhost" OnClick="btnCancelSelection_Click" CausesValidation="false" />
                </div>
                <asp:Label ID="lblMessage" runat="server" CssClass="validationMsg" />
            </asp:Panel>
        </div>
    </div>
</asp:Content>
