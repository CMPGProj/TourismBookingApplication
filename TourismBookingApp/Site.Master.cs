using System;

namespace TourismBookingApp
{
    public partial class SiteMaster : System.Web.UI.MasterPage
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            string role = Session["Role"] != null ? Session["Role"].ToString() : null;

            if (role != null)
            {
                lblUser.InnerText = "Logged in as " + Session["UserName"] + " (" + role + ")";
                phGuest.Visible = false;
                phLoggedIn.Visible = true;
                phLoggedInOnly.Visible = true;
                phAdminOnly.Visible = role == "Administrator";
                phStaff.Visible = role == "Administrator" || role == "Assistant";
                phTouristOnly.Visible = role == "Tourist";
                phReviewsNav.Visible = role == "Administrator" || role == "Tourist";
            }
            else
            {
                lblUser.InnerText = "Not logged in";
                phGuest.Visible = true;
                phLoggedIn.Visible = false;
                phLoggedInOnly.Visible = false;
                phAdminOnly.Visible = false;
                phStaff.Visible = false;
                phTouristOnly.Visible = false;
                phReviewsNav.Visible = false;
            }
        }
    }
}
