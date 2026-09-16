using System;
using System.Web.UI.WebControls;
using System.Data;
using System.Data.SqlClient;
using TourismBookingApp.DataAccess;

namespace TourismBookingApp
{
    public partial class MaintainBusiness : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            AuthHelper.RequireRole(this, "Administrator");

            if (!IsPostBack)
            {
                LoadDropdowns();
                LoadGrid();
            }
        }

        private void LoadDropdowns()
        {
            ddlTown.DataSource = DbHelper.ExecuteQuery("usp_GetTowns");
            ddlTown.DataBind();
        }

        private void LoadGrid()
        {
            gvBusinesses.DataSource = DbHelper.ExecuteQuery("usp_GetBusinesses");
            gvBusinesses.DataBind();
        }

        protected void btnSave_Click(object sender, EventArgs e)
        {
            if (!Page.IsValid) return;

            int businessId = int.Parse(hfBusinessId.Value);
            string action = businessId == 0 ? "INSERT" : "UPDATE";

            try
            {
                DbHelper.ExecuteNonQuery("usp_MaintainBusiness",
                    new SqlParameter("@Action", action),
                    new SqlParameter("@Business_ID", businessId == 0 ? (object)DBNull.Value : businessId),
                    new SqlParameter("@Business_Name", txtName.Text.Trim()),
                    new SqlParameter("@Business_Type", txtType.Text.Trim()),
                    new SqlParameter("@Contact_Email", txtEmail.Text.Trim()),
                    new SqlParameter("@Contact_Phone", txtPhone.Text.Trim()),
                    new SqlParameter("@Town_ID", int.Parse(ddlTown.SelectedValue)));

                lblMessage.Text = "Saved successfully.";
                ClearForm();
                LoadGrid();
            }
            catch (Exception ex)
            {
                lblMessage.Text = "Error saving business: " + ex.Message;
            }
        }

        protected void gvBusinesses_RowCommand(object sender, GridViewCommandEventArgs e)
        {
            int businessId = int.Parse(e.CommandArgument.ToString());

            if (e.CommandName == "EditRow")
            {
                DataTable dt = DbHelper.ExecuteQuery("usp_GetBusinesses");
                DataRow[] rows = dt.Select("Business_ID = " + businessId);
                if (rows.Length == 1)
                {
                    DataRow row = rows[0];
                    hfBusinessId.Value = businessId.ToString();
                    txtName.Text = row["Business_Name"].ToString();
                    txtType.Text = row["Business_Type"].ToString();
                    txtEmail.Text = row["Contact_Email"].ToString();
                    txtPhone.Text = row["Contact_Phone"].ToString();
                    ddlTown.SelectedValue = row["Town_ID"].ToString();
                }
            }
            else if (e.CommandName == "DeleteRow")
            {
                try
                {
                    DbHelper.ExecuteNonQuery("usp_MaintainBusiness",
                        new SqlParameter("@Action", "DELETE"),
                        new SqlParameter("@Business_ID", businessId));
                    lblMessage.Text = "Business deleted.";
                }
                catch (Exception ex)
                {
                    lblMessage.Text = "Cannot delete this business - it still has linked attractions. (" + ex.Message + ")";
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
            hfBusinessId.Value = "0";
            txtName.Text = ""; txtType.Text = ""; txtEmail.Text = ""; txtPhone.Text = "";
        }
    }
}
