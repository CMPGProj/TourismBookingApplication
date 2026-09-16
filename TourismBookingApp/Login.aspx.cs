using System;
using System.Data;
using System.Data.SqlClient;
using TourismBookingApp.DataAccess;

namespace TourismBookingApp
{
    public partial class Login : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack) UpdateUsernameLabel();
        }

        private void UpdateUsernameLabel()
        {
            litUsernameLabel.Text = rbTourist.Checked ? "Email address" : "Username";
        }

        protected void UserType_Changed(object sender, EventArgs e)
        {
            UpdateUsernameLabel();
        }

        protected void btnLogin_Click(object sender, EventArgs e)
        {
            UpdateUsernameLabel();

            if (!Page.IsValid) return;

            string hashedInput = PasswordHelper.Hash(txtPassword.Text);

            if (rbTourist.Checked)
            {
                DataTable dt = DbHelper.ExecuteQuery("usp_ValidateTouristLogin",
                    new SqlParameter("@Email", txtUsername.Text.Trim()));

                if (dt.Rows.Count == 1 && dt.Rows[0]["Password_Hash"].ToString() == hashedInput)
                {
                    Session["UserId"] = dt.Rows[0]["Tourist_ID"];
                    Session["UserName"] = dt.Rows[0]["First_Name"] + " " + dt.Rows[0]["Last_Name"];
                    Session["Role"] = "Tourist";
                    Response.Redirect("Home.aspx");
                }
                else
                {
                    ShowError("The email or password is incorrect. Try again.");
                }
            }
            else
            {
                DataTable dt = DbHelper.ExecuteQuery("usp_ValidateSystemUserLogin",
                    new SqlParameter("@Username", txtUsername.Text.Trim()));

                if (dt.Rows.Count == 1 && dt.Rows[0]["Password_Hash"].ToString() == hashedInput)
                {
                    Session["UserId"] = dt.Rows[0]["User_ID"];
                    Session["UserName"] = dt.Rows[0]["Username"];
                    Session["Role"] = dt.Rows[0]["Role"];
                    Response.Redirect("Home.aspx");
                }
                else
                {
                    ShowError("The username or password is incorrect. Try again.");
                }
            }
        }

        private void ShowError(string message)
        {
            litError.Text = message;
            pnlError.Visible = true;
        }
    }
}
