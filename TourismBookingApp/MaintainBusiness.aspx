<%@ Page Title="Maintain Businesses" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeBehind="MaintainBusiness.aspx.cs" Inherits="TourismBookingApp.MaintainBusiness" %>
<asp:Content ID="Content1" ContentPlaceHolderID="MainContent" runat="server">
    <h2>Maintain Businesses</h2>

    <div class="formPanel">
        <asp:HiddenField ID="hfBusinessId" runat="server" Value="0" />

        <label>Business Name</label>
        <asp:TextBox ID="txtName" runat="server" />
        <asp:RequiredFieldValidator ControlToValidate="txtName" ErrorMessage="Name is required" CssClass="validationMsg" runat="server" Display="Dynamic" />

        <label>Business Type</label>
        <asp:TextBox ID="txtType" runat="server" />
        <asp:RequiredFieldValidator ControlToValidate="txtType" ErrorMessage="Type is required" CssClass="validationMsg" runat="server" Display="Dynamic" />

        <label>Contact Email</label>
        <asp:TextBox ID="txtEmail" runat="server" />
        <asp:RegularExpressionValidator ControlToValidate="txtEmail" ValidationExpression="\S+@\S+\.\S+"
            ErrorMessage="Enter a valid email" CssClass="validationMsg" runat="server" Display="Dynamic" />

        <label>Contact Phone</label>
        <asp:TextBox ID="txtPhone" runat="server" />
        <asp:RequiredFieldValidator ControlToValidate="txtPhone" ErrorMessage="Phone is required" CssClass="validationMsg" runat="server" Display="Dynamic" />

        <label>Town</label>
        <asp:DropDownList ID="ddlTown" runat="server" DataTextField="Town_Name" DataValueField="Town_ID" />

        <div class="btnRow">
            <asp:Button ID="btnSave" runat="server" Text="Save" OnClick="btnSave_Click" />
            <asp:Button ID="btnClear" runat="server" Text="Clear" OnClick="btnClear_Click" CausesValidation="false" />
        </div>
        <asp:Label ID="lblMessage" runat="server" CssClass="validationMsg" />
    </div>

    <h3>Existing Businesses</h3>
    <asp:GridView ID="gvBusinesses" runat="server" CssClass="grid" AutoGenerateColumns="false"
        DataKeyNames="Business_ID" OnRowCommand="gvBusinesses_RowCommand">
        <Columns>
            <asp:BoundField DataField="Business_Name" HeaderText="Name" />
            <asp:BoundField DataField="Business_Type" HeaderText="Type" />
            <asp:BoundField DataField="Contact_Email" HeaderText="Email" />
            <asp:BoundField DataField="Contact_Phone" HeaderText="Phone" />
            <asp:TemplateField HeaderText="Actions">
                <ItemTemplate>
                    <asp:LinkButton runat="server" CommandName="EditRow" CommandArgument='<%# Eval("Business_ID") %>'>Edit</asp:LinkButton>
                    &nbsp;|&nbsp;
                    <asp:LinkButton runat="server" CommandName="DeleteRow" CommandArgument='<%# Eval("Business_ID") %>'
                        OnClientClick="return confirm('Delete this business? Any linked attractions must be removed first.');">Delete</asp:LinkButton>
                </ItemTemplate>
            </asp:TemplateField>
        </Columns>
    </asp:GridView>
</asp:Content>
