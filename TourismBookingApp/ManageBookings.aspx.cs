using System;
using System.Web.UI.WebControls;
using System.Data;
using System.Data.SqlClient;
using System.Globalization;
using TourismBookingApp.DataAccess;

namespace TourismBookingApp
{
    public partial class ManageBookings : System.Web.UI.Page
    {
        private static readonly CultureInfo ZAR = CultureInfo.CreateSpecificCulture("en-ZA");

        protected bool IsStaff
        {
            get
            {
                string role = Session["Role"] != null ? Session["Role"].ToString() : "";
                return role == "Administrator" || role == "Assistant";
            }
        }

        protected string SelectedBookingId
        {
            get { return ViewState["SelectedBookingId"] as string ?? ""; }
            set { ViewState["SelectedBookingId"] = value; }
        }

        private decimal SelectedPrice
        {
            get { return ViewState["SelectedPrice"] != null ? (decimal)ViewState["SelectedPrice"] : 0m; }
            set { ViewState["SelectedPrice"] = value; }
        }

        protected string StatusPillClass(object status)
        {
            switch (status?.ToString())
            {
                case "Cancelled": return "pillCancelled";
                case "Changed": return "pillChanged";
                default: return "pillBooked";
            }
        }

        protected void Page_Load(object sender, EventArgs e)
        {
            AuthHelper.RequireLogin(this);

            pnlTouristPicker.Visible = IsStaff;
            litHeading.Text = IsStaff ? "Manage Bookings" : "My Bookings";

            if (!IsPostBack)
            {
                if (IsStaff)
                {
                    DataTable tourists = DbHelper.ExecuteQuery("usp_GetTourists");
                    tourists.Columns.Add("DisplayName", typeof(string), "First_Name + ' ' + Last_Name");
                    ddlTourist.DataSource = tourists;
                    ddlTourist.DataBind();
                }

                LoadBookings();
            }
        }

        private int CurrentTouristId()
        {
            if (IsStaff)
                return ddlTourist.Items.Count > 0 ? int.Parse(ddlTourist.SelectedValue) : 0;

            return int.Parse(Session["UserId"].ToString());
        }

        private void LoadBookings()
        {
            int touristId = CurrentTouristId();
            if (touristId == 0) return;

            gvBookings.DataSource = DbHelper.ExecuteQuery("usp_GetTouristBookings",
                new SqlParameter("@Tourist_ID", touristId));
            gvBookings.DataBind();
        }

        protected void gvBookings_RowDataBound(object sender, GridViewRowEventArgs e)
        {
            if (e.Row.RowType != DataControlRowType.DataRow) return;
            string bookingId = gvBookings.DataKeys[e.Row.RowIndex].Value.ToString();
            if (bookingId == SelectedBookingId)
                e.Row.CssClass = "rowSelected";
        }

        protected void ddlTourist_SelectedIndexChanged(object sender, EventArgs e)
        {
            SelectedBookingId = "";
            pnlDetail.Visible = false;
            pnlNoSelection.Visible = true;
            LoadBookings();
        }

        protected void gvBookings_RowCommand(object sender, GridViewCommandEventArgs e)
        {
            if (e.CommandName != "SelectRow") return;

            int bookingId = int.Parse(e.CommandArgument.ToString());
            int touristId = CurrentTouristId();

            bool owned = Convert.ToInt32(DbHelper.ExecuteScalar("usp_IsBookingOwnedByTourist",
                new SqlParameter("@Booking_ID", bookingId),
                new SqlParameter("@Tourist_ID", touristId))) == 1;

            if (!owned)
            {
                pnlDetail.Visible = false;
                pnlNoSelection.Visible = true;
                LoadBookings();
                return;
            }

            SelectedBookingId = bookingId.ToString();

            DataTable bookings = DbHelper.ExecuteQuery("usp_GetTouristBookings",
                new SqlParameter("@Tourist_ID", touristId));
            DataRow[] rows = bookings.Select("Booking_ID = " + bookingId);
            if (rows.Length == 1)
            {
                DataRow row = rows[0];
                litBookingId.Text = bookingId.ToString();
                litAttractionAndTown.Text = row["Attraction_Name"] + " - " + row["Status"];
                txtDate.Text = Convert.ToDateTime(row["Booking_Date"]).ToString("yyyy-MM-dd");
                txtTime.Text = ((TimeSpan)row["Booking_Time"]).ToString(@"hh\:mm");
                txtParticipants.Text = row["Participants"].ToString();
                SelectedPrice = Convert.ToDecimal(row["Price"]);
                UpdateTotal();

                phAttend.Visible = IsStaff && row["Status"].ToString() != "Cancelled";

                pnlNoSelection.Visible = false;
                pnlDetail.Visible = true;
            }

            LoadBookings();
        }

        private void UpdateTotal()
        {
            int participants = 1;
            int.TryParse(txtParticipants.Text, out participants);
            if (participants < 1) participants = 1;

            litTotal.Text = (SelectedPrice * participants).ToString("C", ZAR);
        }

        protected void txtParticipants_TextChanged(object sender, EventArgs e)
        {
            UpdateTotal();
        }

        protected void btnSave_Click(object sender, EventArgs e)
        {
            if (string.IsNullOrEmpty(SelectedBookingId)) return;

            int bookingId = int.Parse(SelectedBookingId);
            int touristId = CurrentTouristId();

            bool owned = Convert.ToInt32(DbHelper.ExecuteScalar("usp_IsBookingOwnedByTourist",
                new SqlParameter("@Booking_ID", bookingId),
                new SqlParameter("@Tourist_ID", touristId))) == 1;

            if (!owned)
            {
                lblMessage.Text = "That booking is no longer available to change.";
                LoadBookings();
                return;
            }

            int participants;
            if (!int.TryParse(txtParticipants.Text, out participants) || participants < 1 || participants > 20)
            {
                lblMessage.Text = "Participants must be between 1 and 20.";
                return;
            }

            try
            {
                DbHelper.ExecuteNonQuery("usp_ChangeBooking",
                    new SqlParameter("@Booking_ID", bookingId),
                    new SqlParameter("@New_Date", DateTime.Parse(txtDate.Text)),
                    new SqlParameter("@New_Time", TimeSpan.Parse(txtTime.Text)),
                    new SqlParameter("@Participants", participants));

                lblMessage.Text = "Your booking was changed.";
                UpdateTotal();
            }
            catch (Exception ex)
            {
                lblMessage.Text = "Error saving changes: " + ex.Message;
            }

            LoadBookings();
        }

        protected void btnCancelBooking_Click(object sender, EventArgs e)
        {
            if (string.IsNullOrEmpty(SelectedBookingId)) return;

            int bookingId = int.Parse(SelectedBookingId);
            int touristId = CurrentTouristId();

            bool owned = Convert.ToInt32(DbHelper.ExecuteScalar("usp_IsBookingOwnedByTourist",
                new SqlParameter("@Booking_ID", bookingId),
                new SqlParameter("@Tourist_ID", touristId))) == 1;

            if (!owned)
            {
                lblMessage.Text = "That booking is no longer available to cancel.";
            }
            else
            {
                DbHelper.ExecuteNonQuery("usp_CancelBooking", new SqlParameter("@Booking_ID", bookingId));
                lblMessage.Text = "Booking cancelled.";
                phAttend.Visible = false;
            }

            LoadBookings();
        }

        protected void btnAttend_Click(object sender, EventArgs e)
        {
            if (!IsStaff || string.IsNullOrEmpty(SelectedBookingId)) return;

            DbHelper.ExecuteNonQuery("usp_AttendBooking",
                new SqlParameter("@Booking_ID", int.Parse(SelectedBookingId)),
                new SqlParameter("@Attended_YN", "Y"));

            lblMessage.Text = "Booking marked as attended.";
            LoadBookings();
        }
    }
}
