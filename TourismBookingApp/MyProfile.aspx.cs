using System;
using System.Data;
using System.Data.SqlClient;
using TourismBookingApp.DataAccess;

namespace TourismBookingApp
{
    public partial class MyProfile : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            AuthHelper.RequireRole(this, "Tourist");

            if (!IsPostBack) LoadProfile();
        }

        private int CurrentTouristId()
        {
            return int.Parse(Session["UserId"].ToString());
        }

        private void LoadProfile()
        {
            DataTable dt = DbHelper.ExecuteQuery("usp_GetTourists");
            DataRow[] rows = dt.Select("Tourist_ID = " + CurrentTouristId());
            if (rows.Length == 1)
            {
                txtFirstName.Text = rows[0]["First_Name"].ToString();
                txtLastName.Text = rows[0]["Last_Name"].ToString();
                txtEmail.Text = rows[0]["Email"].ToString();
                txtPhone.Text = rows[0]["Phone"].ToString();
            }
        }

        protected void btnSave_Click(object sender, EventArgs e)
        {
            if (!Page.IsValid) return;

            object passwordHash = string.IsNullOrEmpty(txtPassword.Text)
                ? (object)DBNull.Value
                : PasswordHelper.Hash(txtPassword.Text);

            try
            {
                DbHelper.ExecuteNonQuery("usp_MaintainTourist",
                    new SqlParameter("@Action", "UPDATE"),
                    new SqlParameter("@Tourist_ID", CurrentTouristId()),
                    new SqlParameter("@First_Name", txtFirstName.Text.Trim()),
                    new SqlParameter("@Last_Name", txtLastName.Text.Trim()),
                    new SqlParameter("@Email", txtEmail.Text.Trim()),
                    new SqlParameter("@Phone", txtPhone.Text.Trim()),
                    new SqlParameter("@Password_Hash", passwordHash));

                Session["UserName"] = txtFirstName.Text.Trim() + " " + txtLastName.Text.Trim();
                lblMessage.Text = "Saved successfully.";
                txtPassword.Text = "";
                txtConfirmPassword.Text = "";
            }
            catch (SqlException ex) when (ex.Number == 2627 || ex.Number == 2601)
            {
                lblMessage.Text = "That email is already used by another account.";
            }
            catch (Exception ex)
            {
                lblMessage.Text = "Error saving profile: " + ex.Message;
            }
        }
    }
}
