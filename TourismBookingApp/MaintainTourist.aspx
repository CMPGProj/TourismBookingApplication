<%@ Page Title="Maintain Tourists" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeBehind="MaintainTourist.aspx.cs" Inherits="TourismBookingApp.MaintainTourist" %>
<asp:Content ID="Content1" ContentPlaceHolderID="MainContent" runat="server">
    <h2>Maintain Tourists</h2>
    <div class="formPanel">
        <asp:HiddenField ID="hfTouristId" runat="server" Value="0" />

        <label>First Name</label>
        <asp:TextBox ID="txtFirstName" runat="server" />
        <asp:RequiredFieldValidator ControlToValidate="txtFirstName" ErrorMessage="Required" CssClass="validationMsg" runat="server" Display="Dynamic" />

        <label>Last Name</label>
        <asp:TextBox ID="txtLastName" runat="server" />
        <asp:RequiredFieldValidator ControlToValidate="txtLastName" ErrorMessage="Required" CssClass="validationMsg" runat="server" Display="Dynamic" />

        <label>Email</label>
        <asp:TextBox ID="txtEmail" runat="server" />
        <asp:RegularExpressionValidator ControlToValidate="txtEmail" ValidationExpression="\S+@\S+\.\S+"
            ErrorMessage="Enter a valid email" CssClass="validationMsg" runat="server" Display="Dynamic" />

        <label>Phone</label>
        <asp:TextBox ID="txtPhone" runat="server" />

        <label>Password (leave blank when editing to keep unchanged)</label>
        <asp:TextBox ID="txtPassword" runat="server" TextMode="Password" />

        <div class="btnRow">
            <asp:Button ID="btnSave" runat="server" Text="Save" OnClick="btnSave_Click" />
            <asp:Button ID="btnClear" runat="server" Text="Clear" OnClick="btnClear_Click" CausesValidation="false" />
        </div>
        <asp:Label ID="lblMessage" runat="server" CssClass="validationMsg" />
    </div>

    <h3>Existing Tourists</h3>
    <asp:GridView ID="gvTourists" runat="server" CssClass="grid" AutoGenerateColumns="false"
        DataKeyNames="Tourist_ID" OnRowCommand="gvTourists_RowCommand">
        <Columns>
            <asp:BoundField DataField="First_Name" HeaderText="First Name" />
            <asp:BoundField DataField="Last_Name" HeaderText="Last Name" />
            <asp:BoundField DataField="Email" HeaderText="Email" />
            <asp:BoundField DataField="Phone" HeaderText="Phone" />
            <asp:TemplateField HeaderText="Actions">
                <ItemTemplate>
                    <asp:LinkButton runat="server" CommandName="EditRow" CommandArgument='<%# Eval("Tourist_ID") %>'>Edit</asp:LinkButton>
                    &nbsp;|&nbsp;
                    <asp:LinkButton runat="server" CommandName="DeleteRow" CommandArgument='<%# Eval("Tourist_ID") %>'
                        OnClientClick="return confirm('Delete this tourist?');">Delete</asp:LinkButton>
                </ItemTemplate>
            </asp:TemplateField>
        </Columns>
    </asp:GridView>
</asp:Content>
