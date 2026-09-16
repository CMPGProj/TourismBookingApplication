<%@ Page Title="Maintain Towns" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeBehind="MaintainTown.aspx.cs" Inherits="TourismBookingApp.MaintainTown" %>
<asp:Content ID="Content1" ContentPlaceHolderID="MainContent" runat="server">
    <h2>Maintain Towns</h2>

    <div class="formPanel">
        <asp:HiddenField ID="hfTownId" runat="server" Value="0" />

        <label>Town Name</label>
        <asp:TextBox ID="txtTownName" runat="server" />
        <asp:RequiredFieldValidator ControlToValidate="txtTownName" ErrorMessage="Town name is required" CssClass="validationMsg" runat="server" Display="Dynamic" />

        <label>Province</label>
        <asp:TextBox ID="txtProvince" runat="server" />
        <asp:RequiredFieldValidator ControlToValidate="txtProvince" ErrorMessage="Province is required" CssClass="validationMsg" runat="server" Display="Dynamic" />

        <div class="btnRow">
            <asp:Button ID="btnSave" runat="server" Text="Save" OnClick="btnSave_Click" />
            <asp:Button ID="btnClear" runat="server" Text="Clear" OnClick="btnClear_Click" CausesValidation="false" />
        </div>
        <asp:Label ID="lblMessage" runat="server" CssClass="validationMsg" />
    </div>

    <h3>Existing Towns</h3>
    <asp:GridView ID="gvTowns" runat="server" CssClass="grid" AutoGenerateColumns="false"
        DataKeyNames="Town_ID" OnRowCommand="gvTowns_RowCommand">
        <Columns>
            <asp:BoundField DataField="Town_Name" HeaderText="Town" />
            <asp:BoundField DataField="Province" HeaderText="Province" />
            <asp:TemplateField HeaderText="Actions">
                <ItemTemplate>
                    <asp:LinkButton runat="server" CommandName="EditRow" CommandArgument='<%# Eval("Town_ID") %>'>Edit</asp:LinkButton>
                    &nbsp;|&nbsp;
                    <asp:LinkButton runat="server" CommandName="DeleteRow" CommandArgument='<%# Eval("Town_ID") %>'
                        OnClientClick="return confirm('Delete this town? Any linked businesses or attractions must be removed first.');">Delete</asp:LinkButton>
                </ItemTemplate>
            </asp:TemplateField>
        </Columns>
    </asp:GridView>
</asp:Content>
