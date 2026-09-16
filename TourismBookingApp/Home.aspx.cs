using System;
using System.Data;
using System.Data.SqlClient;
using TourismBookingApp.DataAccess;

namespace TourismBookingApp
{
    public partial class Home : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            string role = Session["Role"] != null ? Session["Role"].ToString() : null;

            if (role == null)
            {
                pnlGuest.Visible = true;
                return;
            }

            if (role == "Administrator" || role == "Assistant")
            {
                pnlStaff.Visible = true;
                DataTable stats = DbHelper.ExecuteQuery("usp_GetHomeStats");
                if (stats.Rows.Count == 1)
                {
                    litTourists.Text = stats.Rows[0]["Total_Tourists"].ToString();
                    litAttractions.Text = stats.Rows[0]["Total_Attractions"].ToString();
                    litBookings.Text = stats.Rows[0]["Active_Bookings"].ToString();
                    litRevenue.Text = string.Format("{0:C}", stats.Rows[0]["Total_Revenue"]);
                }
            }
            else if (role == "Tourist")
            {
                pnlTourist.Visible = true;
                int touristId = int.Parse(Session["UserId"].ToString());

                DataTable upcoming = DbHelper.ExecuteQuery("usp_GetTouristUpcomingBookings",
                    new SqlParameter("@Tourist_ID", touristId));
                gvUpcoming.DataSource = upcoming;
                gvUpcoming.DataBind();
                lblNoUpcoming.Visible = upcoming.Rows.Count == 0;

                gvFeatured.DataSource = DbHelper.ExecuteQuery("usp_GetFeaturedAttractions");
                gvFeatured.DataBind();
            }
        }
    }
}
