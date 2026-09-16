using System;
using System.Web.UI.WebControls;
using System.Data;
using System.Data.SqlClient;
using TourismBookingApp.DataAccess;

namespace TourismBookingApp
{
    public partial class MaintainTourist : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            AuthHelper.RequireRole(this, "Administrator");

            if (!IsPostBack) LoadGrid();
        }

        private void LoadGrid()
        {
            gvTourists.DataSource = DbHelper.ExecuteQuery("usp_GetTourists");
            gvTourists.DataBind();
        }

        protected void btnSave_Click(object sender, EventArgs e)
        {
            if (!Page.IsValid) return;

            int touristId = int.Parse(hfTouristId.Value);
            string action = touristId == 0 ? "INSERT" : "UPDATE";

            string passwordHash = string.IsNullOrEmpty(txtPassword.Text)
                ? null
                : PasswordHelper.Hash(txtPassword.Text);

            if (action == "INSERT" && passwordHash == null)
            {
                lblMessage.Text = "Password is required for a new tourist.";
                return;
            }

            try
            {
                DbHelper.ExecuteNonQuery("usp_MaintainTourist",
                    new SqlParameter("@Action", action),
                    new SqlParameter("@Tourist_ID", touristId == 0 ? (object)DBNull.Value : touristId),
                    new SqlParameter("@First_Name", txtFirstName.Text.Trim()),
                    new SqlParameter("@Last_Name", txtLastName.Text.Trim()),
                    new SqlParameter("@Email", txtEmail.Text.Trim()),
                    new SqlParameter("@Phone", txtPhone.Text.Trim()),
                    new SqlParameter("@Password_Hash", (object)passwordHash ?? DBNull.Value));

                lblMessage.Text = "Saved successfully.";
                ClearForm();
                LoadGrid();
            }
            catch (Exception ex)
            {
                lblMessage.Text = "Error saving tourist: " + ex.Message;
            }
        }

        protected void gvTourists_RowCommand(object sender, GridViewCommandEventArgs e)
        {
            int touristId = int.Parse(e.CommandArgument.ToString());

            if (e.CommandName == "EditRow")
            {
                DataTable dt = DbHelper.ExecuteQuery("usp_GetTourists");
                DataRow[] rows = dt.Select("Tourist_ID = " + touristId);
                if (rows.Length == 1)
                {
                    DataRow row = rows[0];
                    hfTouristId.Value = touristId.ToString();
                    txtFirstName.Text = row["First_Name"].ToString();
                    txtLastName.Text = row["Last_Name"].ToString();
                    txtEmail.Text = row["Email"].ToString();
                    txtPhone.Text = row["Phone"].ToString();
                    txtPassword.Text = "";
                }
            }
            else if (e.CommandName == "DeleteRow")
            {
                DbHelper.ExecuteNonQuery("usp_MaintainTourist",
                    new SqlParameter("@Action", "DELETE"),
                    new SqlParameter("@Tourist_ID", touristId));
                lblMessage.Text = "Tourist deleted.";
                LoadGrid();
            }
        }

        protected void btnClear_Click(object sender, EventArgs e) { ClearForm(); }

        private void ClearForm()
        {
            hfTouristId.Value = "0";
            txtFirstName.Text = ""; txtLastName.Text = ""; txtEmail.Text = "";
            txtPhone.Text = ""; txtPassword.Text = "";
        }
    }
}
