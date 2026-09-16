<%@ Page Title="My Reviews" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeBehind="MaintainReview.aspx.cs" Inherits="TourismBookingApp.MaintainReview" %>
<asp:Content ID="Content1" ContentPlaceHolderID="MainContent" runat="server">

    <asp:Panel ID="pnlTouristView" runat="server" Visible="false">
        <h2>My reviews</h2>
        <p class="pageIntro">Rate the attractions you have booked and tell other tourists what you thought.</p>

        <div class="splitLayout">
            <div class="splitList">
                <asp:GridView ID="gvMyReviews" runat="server" CssClass="niceTable" AutoGenerateColumns="false" GridLines="None">
                    <Columns>
                        <asp:BoundField DataField="Review_Date" HeaderText="Date" DataFormatString="{0:d MMM yyyy}" />
                        <asp:BoundField DataField="Attraction_Name" HeaderText="Attraction" />
                        <asp:TemplateField HeaderText="Rating">
                            <ItemTemplate><span class="starRating"><%# new string('', Convert.ToInt32(Eval("Rating"))) %></span></ItemTemplate>
                        </asp:TemplateField>
                    </Columns>
                </asp:GridView>
            </div>

            <div class="splitPanel">
                <h3>Write a review</h3>
                <asp:Panel ID="pnlNothingToReview" runat="server" Visible="false">
                    <p class="pageIntro">You don't have any booked attractions to review yet.</p>
                </asp:Panel>
                <asp:Panel ID="pnlWriteReview" runat="server">
                    <p class="pageIntro">Choose an attraction you have booked, give a rating and click Submit review.</p>

                    <label>Attraction <span class="fieldHint">(attractions you have booked)</span></label>
                    <asp:DropDownList ID="ddlBooking" runat="server" DataTextField="Attraction_Name" DataValueField="Booking_ID" />

                    <label>Rating</label>
                    <asp:RadioButtonList ID="rblRating" runat="server" RepeatLayout="Flow">
                        <asp:ListItem Text="  Excellent" Value="5" Selected="True" />
                        <asp:ListItem Text="  Very good" Value="4" />
                        <asp:ListItem Text="  Good" Value="3" />
                        <asp:ListItem Text="  Fair" Value="2" />
                        <asp:ListItem Text="  Poor" Value="1" />
                    </asp:RadioButtonList>

                    <label>Comment <span class="fieldHint">(optional, max 500 characters)</span></label>
                    <asp:TextBox ID="txtComment" runat="server" TextMode="MultiLine" Rows="3" MaxLength="500" />

                    <div class="btnSecondaryRow">
                        <asp:Button ID="btnSubmit" runat="server" Text="Submit review" CssClass="btnPrimary" OnClick="btnSubmit_Click" style="margin-top:0;" />
                        <asp:LinkButton ID="btnClear" runat="server" Text="Clear" CssClass="btnGhost" OnClick="btnClear_Click" CausesValidation="false" />
                    </div>
                </asp:Panel>
                <asp:Label ID="lblMessage" runat="server" CssClass="validationMsg" />
            </div>
        </div>
    </asp:Panel>

    <asp:Panel ID="pnlAdminView" runat="server" Visible="false">
        <h2>All Reviews</h2>
        <p class="pageIntro">Moderate reviews submitted by tourists.</p>
        <asp:GridView ID="gvReviews" runat="server" CssClass="niceTable" AutoGenerateColumns="false"
            DataKeyNames="Review_ID" OnRowCommand="gvReviews_RowCommand" GridLines="None">
            <Columns>
                <asp:BoundField DataField="Attraction_Name" HeaderText="Attraction" />
                <asp:BoundField DataField="Tourist_Name" HeaderText="Tourist" />
                <asp:TemplateField HeaderText="Rating">
                    <ItemTemplate><span class="starRating"><%# new string('', Convert.ToInt32(Eval("Rating"))) %></span></ItemTemplate>
                </asp:TemplateField>
                <asp:BoundField DataField="Comment" HeaderText="Comment" />
                <asp:BoundField DataField="Review_Date" HeaderText="Date" DataFormatString="{0:d}" />
                <asp:TemplateField HeaderText="">
                    <ItemTemplate>
                        <asp:LinkButton runat="server" CommandName="DeleteRow" CommandArgument='<%# Eval("Review_ID") %>' CssClass="btnGhost"
                            OnClientClick="return confirm('Delete this review?');">Delete</asp:LinkButton>
                    </ItemTemplate>
                </asp:TemplateField>
            </Columns>
        </asp:GridView>
        <asp:Label ID="lblAdminMessage" runat="server" CssClass="validationMsg" />
    </asp:Panel>
</asp:Content>
