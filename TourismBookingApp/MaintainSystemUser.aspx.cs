using System;
using System.Web.UI.WebControls;
using System.Data;
using System.Data.SqlClient;
using TourismBookingApp.DataAccess;

namespace TourismBookingApp
{
    public partial class MaintainSystemUser : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            AuthHelper.RequireRole(this, "Administrator");

            if (!IsPostBack) LoadGrid();
        }

        private void LoadGrid()
        {
            gvUsers.DataSource = DbHelper.ExecuteQuery("usp_GetSystemUsers");
            gvUsers.DataBind();
        }

        protected void btnSave_Click(object sender, EventArgs e)
        {
            if (!Page.IsValid) return;

            int userId = int.Parse(hfUserId.Value);
            string action = userId == 0 ? "INSERT" : "UPDATE";

            if (action == "INSERT" && string.IsNullOrEmpty(txtPassword.Text))
            {
                lblMessage.Text = "Password is required for a new staff account.";
                return;
            }

            object passwordHash = string.IsNullOrEmpty(txtPassword.Text)
                ? (object)DBNull.Value
                : PasswordHelper.Hash(txtPassword.Text);

            try
            {
                DbHelper.ExecuteNonQuery("usp_MaintainSystemUser",
                    new SqlParameter("@Action", action),
                    new SqlParameter("@User_ID", userId == 0 ? (object)DBNull.Value : userId),
                    new SqlParameter("@Username", txtUsername.Text.Trim()),
                    new SqlParameter("@Password_Hash", passwordHash),
                    new SqlParameter("@Role", ddlRole.SelectedValue));

                lblMessage.Text = "Saved successfully.";
                ClearForm();
                LoadGrid();
            }
            catch (Exception ex)
            {
                lblMessage.Text = "Error saving staff account: " + ex.Message;
            }
        }

        protected void gvUsers_RowCommand(object sender, GridViewCommandEventArgs e)
        {
            int userId = int.Parse(e.CommandArgument.ToString());

            if (e.CommandName == "EditRow")
            {
                DataTable dt = DbHelper.ExecuteQuery("usp_GetSystemUsers");
                DataRow[] rows = dt.Select("User_ID = " + userId);
                if (rows.Length == 1)
                {
                    hfUserId.Value = userId.ToString();
                    txtUsername.Text = rows[0]["Username"].ToString();
                    txtPassword.Text = "";
                    ddlRole.SelectedValue = rows[0]["Role"].ToString();
                }
            }
            else if (e.CommandName == "DeleteRow")
            {
                int currentUserId = Session["UserId"] != null ? int.Parse(Session["UserId"].ToString()) : -1;
                if (userId == currentUserId)
                {
                    lblMessage.Text = "You cannot delete the account you are currently logged in as.";
                }
                else
                {
                    DbHelper.ExecuteNonQuery("usp_MaintainSystemUser",
                        new SqlParameter("@Action", "DELETE"),
                        new SqlParameter("@User_ID", userId));
                    lblMessage.Text = "Staff account deleted.";
                }
                LoadGrid();
            }
        }

        protected void btnClear_Click(object sender, EventArgs e)
        {
            ClearForm();
        }

        private void ClearForm()
        {
            hfUserId.Value = "0";
            txtUsername.Text = "";
            txtPassword.Text = "";
        }
    }
}
