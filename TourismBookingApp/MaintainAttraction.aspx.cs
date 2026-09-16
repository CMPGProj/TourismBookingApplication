using System;
using System.Web.UI.WebControls;
using System.Data;
using System.Data.SqlClient;
using TourismBookingApp.DataAccess;

namespace TourismBookingApp
{
    public partial class MaintainAttraction : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            AuthHelper.RequireRole(this, "Administrator", "Assistant");

            if (!IsPostBack)
            {
                LoadDropdowns();
                LoadGrid();
            }
        }

        private void LoadDropdowns()
        {
            ddlBusiness.DataSource = DbHelper.ExecuteQuery("usp_GetBusinesses");
            ddlBusiness.DataBind();

            ddlTown.DataSource = DbHelper.ExecuteQuery("usp_GetTowns");
            ddlTown.DataBind();
        }

        private void LoadGrid()
        {
            gvAttractions.DataSource = DbHelper.ExecuteQuery("usp_GetAttractions");
            gvAttractions.DataBind();
        }

        protected void btnSave_Click(object sender, EventArgs e)
        {
            if (!Page.IsValid) return;

            int attractionId = int.Parse(hfAttractionId.Value);
            string action = attractionId == 0 ? "INSERT" : "UPDATE";

            try
            {
                DbHelper.ExecuteNonQuery("usp_MaintainAttraction",
                    new SqlParameter("@Action", action),
                    new SqlParameter("@Attraction_ID", attractionId == 0 ? (object)DBNull.Value : attractionId),
                    new SqlParameter("@Attraction_Name", txtName.Text.Trim()),
                    new SqlParameter("@Description", string.IsNullOrEmpty(txtDescription.Text) ? (object)DBNull.Value : txtDescription.Text.Trim()),
                    new SqlParameter("@Category", txtCategory.Text.Trim()),
                    new SqlParameter("@Price", decimal.Parse(txtPrice.Text)),
                    new SqlParameter("@Business_ID", int.Parse(ddlBusiness.SelectedValue)),
                    new SqlParameter("@Town_ID", int.Parse(ddlTown.SelectedValue)));

                lblMessage.Text = "Saved successfully.";
                ClearForm();
                LoadGrid();
            }
            catch (Exception ex)
            {
                lblMessage.Text = "Error saving attraction: " + ex.Message;
            }
        }

        protected void gvAttractions_RowCommand(object sender, GridViewCommandEventArgs e)
        {
            int attractionId = int.Parse(e.CommandArgument.ToString());

            if (e.CommandName == "EditRow")
            {
                DataTable dt = DbHelper.ExecuteQuery("usp_GetAttractions");
                DataRow[] rows = dt.Select("Attraction_ID = " + attractionId);
                if (rows.Length == 1)
                {
                    DataRow row = rows[0];
                    hfAttractionId.Value = attractionId.ToString();
                    txtName.Text = row["Attraction_Name"].ToString();
                    txtDescription.Text = row["Description"].ToString();
                    txtCategory.Text = row["Category"].ToString();
                    txtPrice.Text = row["Price"].ToString();
                    ddlBusiness.SelectedValue = row["Business_ID"].ToString();
                    ddlTown.SelectedValue = row["Town_ID"].ToString();
                }
            }
            else if (e.CommandName == "DeleteRow")
            {
                DbHelper.ExecuteNonQuery("usp_MaintainAttraction",
                    new SqlParameter("@Action", "DELETE"),
                    new SqlParameter("@Attraction_ID", attractionId));
                lblMessage.Text = "Attraction deleted.";
                LoadGrid();
            }
        }

        protected void btnClear_Click(object sender, EventArgs e)
        {
            ClearForm();
        }

        private void ClearForm()
        {
            hfAttractionId.Value = "0";
            txtName.Text = ""; txtDescription.Text = ""; txtCategory.Text = ""; txtPrice.Text = "";
        }
    }
}
