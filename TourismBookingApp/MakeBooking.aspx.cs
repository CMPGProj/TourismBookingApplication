using System;
using System.Web.UI.WebControls;
using System.Data;
using System.Data.SqlClient;
using System.Globalization;
using TourismBookingApp.DataAccess;

namespace TourismBookingApp
{
    public partial class MakeBooking : System.Web.UI.Page
    {
        private bool IsStaff
        {
            get
            {
                string role = Session["Role"] != null ? Session["Role"].ToString() : "";
                return role == "Administrator" || role == "Assistant";
            }
        }

        protected string SelectedAttractionId
        {
            get { return ViewState["SelectedAttractionId"] as string ?? ""; }
            set { ViewState["SelectedAttractionId"] = value; }
        }

        private decimal SelectedPrice
        {
            get { return ViewState["SelectedPrice"] != null ? (decimal)ViewState["SelectedPrice"] : 0m; }
            set { ViewState["SelectedPrice"] = value; }
        }

        protected string FormatStars(object avgRatingObj)
        {
            if (avgRatingObj == null || avgRatingObj == DBNull.Value) return "No ratings yet";
            double avg = Convert.ToDouble(avgRatingObj);
            int full = (int)Math.Round(avg);
            return new string('?', full) + new string('?', 5 - full);
        }

        protected void Page_Load(object sender, EventArgs e)
        {
            AuthHelper.RequireLogin(this);

            if (!IsPostBack)
            {
                LoadFilterOptions();
                LoadTouristPicker();
                BindAttractions();
            }
        }

        private void LoadFilterOptions()
        {
            DataTable towns = DbHelper.ExecuteQuery("usp_GetTowns");
            foreach (DataRow row in towns.Rows)
                ddlTownFilter.Items.Add(new System.Web.UI.WebControls.ListItem(row["Town_Name"].ToString(), row["Town_Name"].ToString()));

            DataTable attractions = DbHelper.ExecuteQuery("usp_GetAttractions");
            DataView categories = new DataView(attractions);
            DataTable distinctCategories = categories.ToTable(true, "Category");
            foreach (DataRow row in distinctCategories.Rows)
                ddlCategoryFilter.Items.Add(new System.Web.UI.WebControls.ListItem(row["Category"].ToString(), row["Category"].ToString()));
        }

        private void LoadTouristPicker()
        {
            if (IsStaff)
            {
                DataTable tourists = DbHelper.ExecuteQuery("usp_GetTourists");
                tourists.Columns.Add("DisplayName", typeof(string), "First_Name + ' ' + Last_Name");
                ddlTourist.DataSource = tourists;
                ddlTourist.DataBind();
            }
        }

        private void BindAttractions()
        {
            DataTable attractions = DbHelper.ExecuteQuery("usp_GetAttractions");
            DataView view = attractions.DefaultView;

            string filter = "";
            if (ddlTownFilter.SelectedValue != "")
                filter += "Town_Name = '" + ddlTownFilter.SelectedValue.Replace("'", "''") + "'";
            if (ddlCategoryFilter.SelectedValue != "")
                filter += (filter.Length > 0 ? " AND " : "") + "Category = '" + ddlCategoryFilter.SelectedValue.Replace("'", "''") + "'";
            if (!string.IsNullOrWhiteSpace(txtSearch.Text))
                filter += (filter.Length > 0 ? " AND " : "") + "Attraction_Name LIKE '%" + txtSearch.Text.Trim().Replace("'", "''") + "%'";

            view.RowFilter = filter;

            gvAttractions.DataSource = view;
            gvAttractions.DataBind();
        }

        protected void Filter_Changed(object sender, EventArgs e)
        {
            BindAttractions();
        }

        protected void gvAttractions_RowCommand(object sender, GridViewCommandEventArgs e)
        {
            if (e.CommandName != "SelectRow") return;

            int attractionId = int.Parse(e.CommandArgument.ToString());
            SelectedAttractionId = attractionId.ToString();

            DataTable attractions = DbHelper.ExecuteQuery("usp_GetAttractions");
            DataRow[] rows = attractions.Select("Attraction_ID = " + attractionId);
            if (rows.Length == 1)
            {
                DataRow row = rows[0];
                litSelectedName.Text = row["Attraction_Name"].ToString();
                litBusiness.Text = row["Business_Name"].ToString();
                litTown.Text = row["Town_Name"].ToString();
                SelectedPrice = Convert.ToDecimal(row["Price"]);
                litPrice.Text = SelectedPrice.ToString("C", CultureInfo.CreateSpecificCulture("en-ZA"));

                if (!IsStaff)
                {
                    phSelfBooking.Visible = true;
                    phTouristPicker.Visible = false;
                    litSelfName.Text = Session["UserName"] != null ? Session["UserName"].ToString() : "You";
                }
                else
                {
                    phTouristPicker.Visible = true;
                }

                UpdateTotal();

                pnlNoSelection.Visible = false;
                pnlBookingForm.Visible = true;
            }

            BindAttractions();
        }

        private void UpdateTotal()
        {
            int participants = 1;
            int.TryParse(txtParticipants.Text, out participants);
            if (participants < 1) participants = 1;

            decimal total = SelectedPrice * participants;
            litTotal.Text = total.ToString("C", CultureInfo.CreateSpecificCulture("en-ZA"));
        }

        protected void btnCancelSelection_Click(object sender, EventArgs e)
        {
            SelectedAttractionId = "";
            pnlBookingForm.Visible = false;
            pnlNoSelection.Visible = true;
            BindAttractions();
        }

        protected void txtParticipants_TextChanged(object sender, EventArgs e)
        {
            UpdateTotal();
        }

        protected void btnBook_Click(object sender, EventArgs e)
        {
            if (!Page.IsValid || string.IsNullOrEmpty(SelectedAttractionId)) return;

            int touristId = IsStaff
                ? int.Parse(ddlTourist.SelectedValue)
                : int.Parse(Session["UserId"].ToString());

            int participants = int.Parse(txtParticipants.Text);

            try
            {
                DbHelper.ExecuteScalar("usp_MakeBooking",
                    new SqlParameter("@Tourist_ID", touristId),
                    new SqlParameter("@Attraction_ID", int.Parse(SelectedAttractionId)),
                    new SqlParameter("@Booking_Date", DateTime.Parse(txtDate.Text)),
                    new SqlParameter("@Booking_Time", TimeSpan.Parse(txtTime.Text)),
                    new SqlParameter("@Participants", participants));

                lblMessage.Text = "Booking confirmed! See it under My Bookings.";
            }
            catch (Exception ex)
            {
                lblMessage.Text = "Error making booking: " + ex.Message;
            }

            UpdateTotal();
        }
    }
}
