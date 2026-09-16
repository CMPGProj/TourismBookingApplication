<%@ Page Title="Maintain Attractions" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeBehind="MaintainAttraction.aspx.cs" Inherits="TourismBookingApp.MaintainAttraction" %>
<asp:Content ID="Content1" ContentPlaceHolderID="MainContent" runat="server">
    <h2>Maintain Attractions</h2>

    <div class="formPanel">
        <asp:HiddenField ID="hfAttractionId" runat="server" Value="0" />

        <label>Attraction Name</label>
        <asp:TextBox ID="txtName" runat="server" />
        <asp:RequiredFieldValidator ControlToValidate="txtName" ErrorMessage="Name is required" CssClass="validationMsg" runat="server" Display="Dynamic" />

        <label>Description</label>
        <asp:TextBox ID="txtDescription" runat="server" TextMode="MultiLine" Rows="3" />

        <label>Category</label>
        <asp:TextBox ID="txtCategory" runat="server" />
        <asp:RequiredFieldValidator ControlToValidate="txtCategory" ErrorMessage="Category is required" CssClass="validationMsg" runat="server" Display="Dynamic" />

        <label>Price (R)</label>
        <asp:TextBox ID="txtPrice" runat="server" />
        <asp:RangeValidator ControlToValidate="txtPrice" MinimumValue="0" MaximumValue="99999" Type="Currency"
            ErrorMessage="Price must be 0 or more" CssClass="validationMsg" runat="server" Display="Dynamic" />

        <label>Business</label>
        <asp:DropDownList ID="ddlBusiness" runat="server" DataTextField="Business_Name" DataValueField="Business_ID" />

        <label>Town</label>
        <asp:DropDownList ID="ddlTown" runat="server" DataTextField="Town_Name" DataValueField="Town_ID" />

        <div class="btnRow">
            <asp:Button ID="btnSave" runat="server" Text="Save" OnClick="btnSave_Click" />
            <asp:Button ID="btnClear" runat="server" Text="Clear" OnClick="btnClear_Click" CausesValidation="false" />
        </div>
        <asp:Label ID="lblMessage" runat="server" CssClass="validationMsg" />
    </div>

    <h3>Existing Attractions</h3>
    <asp:GridView ID="gvAttractions" runat="server" CssClass="grid" AutoGenerateColumns="false"
        DataKeyNames="Attraction_ID" OnRowCommand="gvAttractions_RowCommand">
        <Columns>
            <asp:BoundField DataField="Attraction_Name" HeaderText="Name" />
            <asp:BoundField DataField="Category" HeaderText="Category" />
            <asp:BoundField DataField="Price" HeaderText="Price" DataFormatString="{0:C}" />
            <asp:BoundField DataField="Business_Name" HeaderText="Business" />
            <asp:BoundField DataField="Town_Name" HeaderText="Town" />
            <asp:TemplateField HeaderText="Actions">
                <ItemTemplate>
                    <asp:LinkButton runat="server" CommandName="EditRow" CommandArgument='<%# Eval("Attraction_ID") %>'>Edit</asp:LinkButton>
                    &nbsp;|&nbsp;
                    <asp:LinkButton runat="server" CommandName="DeleteRow" CommandArgument='<%# Eval("Attraction_ID") %>'
                        OnClientClick="return confirm('Delete this attraction?');">Delete</asp:LinkButton>
                </ItemTemplate>
            </asp:TemplateField>
        </Columns>
    </asp:GridView>
</asp:Content>
