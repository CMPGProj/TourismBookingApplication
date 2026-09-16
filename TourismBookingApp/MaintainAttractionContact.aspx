<%@ Page Title="Maintain Attraction Contacts" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeBehind="MaintainAttractionContact.aspx.cs" Inherits="TourismBookingApp.MaintainAttractionContact" %>
<asp:Content ID="Content1" ContentPlaceHolderID="MainContent" runat="server">
    <h2>Maintain Attraction Contact Person</h2>
    <p>Each attraction may have one or more on-site contact people (a child record of Attraction).</p>

    <div class="formPanel">
        <asp:HiddenField ID="hfContactId" runat="server" Value="0" />

        <label>Attraction</label>
        <asp:DropDownList ID="ddlAttraction" runat="server" DataTextField="Attraction_Name" DataValueField="Attraction_ID" />

        <label>Contact Name</label>
        <asp:TextBox ID="txtContactName" runat="server" />
        <asp:RequiredFieldValidator ControlToValidate="txtContactName" ErrorMessage="Contact name is required" CssClass="validationMsg" runat="server" Display="Dynamic" />

        <label>Contact Phone</label>
        <asp:TextBox ID="txtContactPhone" runat="server" />
        <asp:RequiredFieldValidator ControlToValidate="txtContactPhone" ErrorMessage="Phone is required" CssClass="validationMsg" runat="server" Display="Dynamic" />

        <label>Contact Email</label>
        <asp:TextBox ID="txtContactEmail" runat="server" />
        <asp:RegularExpressionValidator ControlToValidate="txtContactEmail" ValidationExpression="\S+@\S+\.\S+"
            ErrorMessage="Enter a valid email" CssClass="validationMsg" runat="server" Display="Dynamic" />

        <div class="btnRow">
            <asp:Button ID="btnSave" runat="server" Text="Save" OnClick="btnSave_Click" />
            <asp:Button ID="btnClear" runat="server" Text="Clear" OnClick="btnClear_Click" CausesValidation="false" />
        </div>
        <asp:Label ID="lblMessage" runat="server" CssClass="validationMsg" />
    </div>

    <h3>Existing Contacts</h3>
    <asp:GridView ID="gvContacts" runat="server" CssClass="grid" AutoGenerateColumns="false"
        DataKeyNames="Contact_ID" OnRowCommand="gvContacts_RowCommand">
        <Columns>
            <asp:BoundField DataField="Attraction_Name" HeaderText="Attraction" />
            <asp:BoundField DataField="Contact_Name" HeaderText="Contact" />
            <asp:BoundField DataField="Contact_Phone" HeaderText="Phone" />
            <asp:BoundField DataField="Contact_Email" HeaderText="Email" />
            <asp:TemplateField HeaderText="Actions">
                <ItemTemplate>
                    <asp:LinkButton runat="server" CommandName="EditRow" CommandArgument='<%# Eval("Contact_ID") %>'>Edit</asp:LinkButton>
                    &nbsp;|&nbsp;
                    <asp:LinkButton runat="server" CommandName="DeleteRow" CommandArgument='<%# Eval("Contact_ID") %>'
                        OnClientClick="return confirm('Delete this contact?');">Delete</asp:LinkButton>
                </ItemTemplate>
            </asp:TemplateField>
        </Columns>
    </asp:GridView>
</asp:Content>
