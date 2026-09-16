using System;
using System.Web.UI.WebControls;
using System.Data;
using System.Data.SqlClient;
using TourismBookingApp.DataAccess;

namespace TourismBookingApp
{
    public partial class MaintainReview : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            AuthHelper.RequireRole(this, "Administrator", "Tourist");

            bool isTourist = Session["Role"].ToString() == "Tourist";
            pnlTouristView.Visible = isTourist;
            pnlAdminView.Visible = !isTourist;

            if (!IsPostBack)
            {
                if (isTourist)
                {
                    LoadReviewableBookings();
                    LoadMyReviews();
                }
                else
                {
                    LoadAllReviews();
                }
            }
        }

        private int CurrentTouristId()
        {
            return int.Parse(Session["UserId"].ToString());
        }

        private void LoadReviewableBookings()
        {
            DataTable dt = DbHelper.ExecuteQuery("usp_GetTouristReviewableBookings",
                new SqlParameter("@Tourist_ID", CurrentTouristId()));

            ddlBooking.DataSource = dt;
            ddlBooking.DataBind();

            bool hasAny = dt.Rows.Count > 0;
            pnlWriteReview.Visible = hasAny;
            pnlNothingToReview.Visible = !hasAny;
        }

        private void LoadMyReviews()
        {
            gvMyReviews.DataSource = DbHelper.ExecuteQuery("usp_GetTouristReviews",
                new SqlParameter("@Tourist_ID", CurrentTouristId()));
            gvMyReviews.DataBind();
        }

        private void LoadAllReviews()
        {
            gvReviews.DataSource = DbHelper.ExecuteQuery("usp_GetReviews");
            gvReviews.DataBind();
        }

        protected void btnSubmit_Click(object sender, EventArgs e)
        {
            if (ddlBooking.Items.Count == 0)
            {
                lblMessage.Text = "You have no attended bookings left to review.";
                return;
            }

            try
            {
                int touristId = CurrentTouristId();
                int bookingId = int.Parse(ddlBooking.SelectedValue);

                DataTable dt = DbHelper.ExecuteQuery("usp_GetTouristReviewableBookings",
                    new SqlParameter("@Tourist_ID", touristId));
                DataRow[] rows = dt.Select("Booking_ID = " + bookingId);
                if (rows.Length != 1)
                {
                    lblMessage.Text = "That booking can no longer be reviewed.";
                    return;
                }
                int attractionId = int.Parse(rows[0]["Attraction_ID"].ToString());

                DbHelper.ExecuteNonQuery("usp_MaintainReview",
                    new SqlParameter("@Action", "INSERT"),
                    new SqlParameter("@Booking_ID", bookingId),
                    new SqlParameter("@Tourist_ID", touristId),
                    new SqlParameter("@Attraction_ID", attractionId),
                    new SqlParameter("@Rating", byte.Parse(rblRating.SelectedValue)),
                    new SqlParameter("@Comment", string.IsNullOrEmpty(txtComment.Text) ? (object)DBNull.Value : txtComment.Text.Trim()));

                lblMessage.Text = "Thanks - your review has been submitted.";
                txtComment.Text = "";
                LoadReviewableBookings();
                LoadMyReviews();
            }
            catch (Exception ex)
            {
                lblMessage.Text = "Error submitting review: " + ex.Message;
            }
        }

        protected void btnClear_Click(object sender, EventArgs e)
        {
            txtComment.Text = "";
            rblRating.SelectedValue = "5";
        }

        protected void gvReviews_RowCommand(object sender, GridViewCommandEventArgs e)
        {
            if (e.CommandName == "DeleteRow")
            {
                int reviewId = int.Parse(e.CommandArgument.ToString());
                DbHelper.ExecuteNonQuery("usp_MaintainReview",
                    new SqlParameter("@Action", "DELETE"),
                    new SqlParameter("@Review_ID", reviewId));
                lblAdminMessage.Text = "Review deleted.";
                LoadAllReviews();
            }
        }
    }
}
