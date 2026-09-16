<%@ Page Title="Maintain Staff Accounts" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeBehind="MaintainSystemUser.aspx.cs" Inherits="TourismBookingApp.MaintainSystemUser" %>
<asp:Content ID="Content1" ContentPlaceHolderID="MainContent" runat="server">
    <h2>Maintain Staff Accounts</h2>
    <p>Administrator and Assistant login accounts.</p>

    <div class="formPanel">
        <asp:HiddenField ID="hfUserId" runat="server" Value="0" />

        <label>Username</label>
        <asp:TextBox ID="txtUsername" runat="server" />
        <asp:RequiredFieldValidator ControlToValidate="txtUsername" ErrorMessage="Username is required" CssClass="validationMsg" runat="server" Display="Dynamic" />

        <label>Password <small>(leave blank when editing to keep the current password)</small></label>
        <asp:TextBox ID="txtPassword" runat="server" TextMode="Password" />

        <label>Role</label>
        <asp:DropDownList ID="ddlRole" runat="server">
            <asp:ListItem Text="Administrator" Value="Administrator" />
            <asp:ListItem Text="Assistant" Value="Assistant" />
        </asp:DropDownList>

        <div class="btnRow">
            <asp:Button ID="btnSave" runat="server" Text="Save" OnClick="btnSave_Click" />
            <asp:Button ID="btnClear" runat="server" Text="Clear" OnClick="btnClear_Click" CausesValidation="false" />
        </div>
        <asp:Label ID="lblMessage" runat="server" CssClass="validationMsg" />
    </div>

    <h3>Existing Staff Accounts</h3>
    <asp:GridView ID="gvUsers" runat="server" CssClass="grid" AutoGenerateColumns="false"
        DataKeyNames="User_ID" OnRowCommand="gvUsers_RowCommand">
        <Columns>
            <asp:BoundField DataField="Username" HeaderText="Username" />
            <asp:BoundField DataField="Role" HeaderText="Role" />
            <asp:TemplateField HeaderText="Actions">
                <ItemTemplate>
                    <asp:LinkButton runat="server" CommandName="EditRow" CommandArgument='<%# Eval("User_ID") %>'>Edit</asp:LinkButton>
                    &nbsp;|&nbsp;
                    <asp:LinkButton runat="server" CommandName="DeleteRow" CommandArgument='<%# Eval("User_ID") %>'
                        OnClientClick="return confirm('Delete this staff account?');">Delete</asp:LinkButton>
                </ItemTemplate>
            </asp:TemplateField>
        </Columns>
    </asp:GridView>
</asp:Content>
