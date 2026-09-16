using System;
using System.Data;
using System.Data.SqlClient;
using TourismBookingApp.DataAccess;

namespace TourismBookingApp
{
    public partial class Register : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
        }

        protected void btnRegister_Click(object sender, EventArgs e)
        {
            if (!Page.IsValid) return;

            try
            {
                string passwordHash = PasswordHelper.Hash(txtPassword.Text);

                DbHelper.ExecuteNonQuery("usp_MaintainTourist",
                    new SqlParameter("@Action", "INSERT"),
                    new SqlParameter("@Tourist_ID", DBNull.Value),
                    new SqlParameter("@First_Name", txtFirstName.Text.Trim()),
                    new SqlParameter("@Last_Name", txtLastName.Text.Trim()),
                    new SqlParameter("@Email", txtEmail.Text.Trim()),
                    new SqlParameter("@Phone", txtPhone.Text.Trim()),
                    new SqlParameter("@Password_Hash", passwordHash));

                DataTable dt = DbHelper.ExecuteQuery("usp_ValidateTouristLogin",
                    new SqlParameter("@Email", txtEmail.Text.Trim()));

                if (dt.Rows.Count == 1)
                {
                    Session["UserId"] = dt.Rows[0]["Tourist_ID"].ToString();
                    Session["UserName"] = dt.Rows[0]["First_Name"] + " " + dt.Rows[0]["Last_Name"];
                    Session["Role"] = "Tourist";
                    Response.Redirect("Home.aspx");
                }
                else
                {
                    Response.Redirect("Login.aspx");
                }
            }
            catch (SqlException ex) when (ex.Number == 2627 || ex.Number == 2601)
            {
                litError.Text = "An account with that email already exists - try logging in instead.";
                pnlError.Visible = true;
            }
            catch (Exception ex)
            {
                litError.Text = "Error creating account: " + ex.Message;
                pnlError.Visible = true;
            }
        }
    }
}
