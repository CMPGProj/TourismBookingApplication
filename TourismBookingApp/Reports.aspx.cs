using System;
using System.Data;
using System.Data.SqlClient;
using TourismBookingApp.DataAccess;

namespace TourismBookingApp
{
    public partial class Reports : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            AuthHelper.RequireRole(this, "Administrator", "Assistant");

            if (!IsPostBack)
            {
                gvRevenue.DataSource = DbHelper.ExecuteQuery("usp_Report_RevenueByAttraction");
                gvRevenue.DataBind();

                DataTable tourists = DbHelper.ExecuteQuery("usp_GetTourists");
                tourists.Columns.Add("DisplayName", typeof(string), "First_Name + ' ' + Last_Name");
                ddlTourist.DataSource = tourists;
                ddlTourist.DataBind();
            }
        }

        protected void btnSearch_Click(object sender, EventArgs e)
        {
            gvBookings.DataSource = DbHelper.ExecuteQuery("usp_Report_BookingsByDateRange",
                new SqlParameter("@Tourist_ID", int.Parse(ddlTourist.SelectedValue)),
                new SqlParameter("@FromDate", DateTime.Parse(txtFrom.Text)),
                new SqlParameter("@ToDate", DateTime.Parse(txtTo.Text)));
            gvBookings.DataBind();
        }
    }
}
