using System;
using System.Web.UI.WebControls;
using System.Data;
using System.Data.SqlClient;
using TourismBookingApp.DataAccess;

namespace TourismBookingApp
{
    public partial class MaintainTown : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            AuthHelper.RequireRole(this, "Administrator");

            if (!IsPostBack) LoadGrid();
        }

        private void LoadGrid()
        {
            gvTowns.DataSource = DbHelper.ExecuteQuery("usp_GetTowns");
            gvTowns.DataBind();
        }

        protected void btnSave_Click(object sender, EventArgs e)
        {
            if (!Page.IsValid) return;

            int townId = int.Parse(hfTownId.Value);
            string action = townId == 0 ? "INSERT" : "UPDATE";

            try
            {
                DbHelper.ExecuteNonQuery("usp_MaintainTown",
                    new SqlParameter("@Action", action),
                    new SqlParameter("@Town_ID", townId == 0 ? (object)DBNull.Value : townId),
                    new SqlParameter("@Town_Name", txtTownName.Text.Trim()),
                    new SqlParameter("@Province", txtProvince.Text.Trim()));

                lblMessage.Text = "Saved successfully.";
                ClearForm();
                LoadGrid();
            }
            catch (Exception ex)
            {
                lblMessage.Text = "Error saving town: " + ex.Message;
            }
        }

        protected void gvTowns_RowCommand(object sender, GridViewCommandEventArgs e)
        {
            int townId = int.Parse(e.CommandArgument.ToString());

            if (e.CommandName == "EditRow")
            {
                DataTable dt = DbHelper.ExecuteQuery("usp_GetTowns");
                DataRow[] rows = dt.Select("Town_ID = " + townId);
                if (rows.Length == 1)
                {
                    hfTownId.Value = townId.ToString();
                    txtTownName.Text = rows[0]["Town_Name"].ToString();
                    txtProvince.Text = rows[0]["Province"].ToString();
                }
            }
            else if (e.CommandName == "DeleteRow")
            {
                try
                {
                    DbHelper.ExecuteNonQuery("usp_MaintainTown",
                        new SqlParameter("@Action", "DELETE"),
                        new SqlParameter("@Town_ID", townId));
                    lblMessage.Text = "Town deleted.";
                }
                catch (Exception ex)
                {
                    lblMessage.Text = "Cannot delete this town - it is still referenced by a Business or Attraction. (" + ex.Message + ")";
                }
                LoadGrid();
            }
        }

        protected void btnClear_Click(object sender, EventArgs e)
        {
            ClearForm();
        }

        private void ClearForm()
        {
            hfTownId.Value = "0";
            txtTownName.Text = "";
            txtProvince.Text = "";
        }
    }
}
