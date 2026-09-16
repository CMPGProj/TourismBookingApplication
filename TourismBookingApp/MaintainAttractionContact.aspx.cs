using System;
using System.Web.UI.WebControls;
using System.Data;
using System.Data.SqlClient;
using TourismBookingApp.DataAccess;

namespace TourismBookingApp
{
    public partial class MaintainAttractionContact : System.Web.UI.Page
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
            ddlAttraction.DataSource = DbHelper.ExecuteQuery("usp_GetAttractions");
            ddlAttraction.DataBind();
        }

        private void LoadGrid()
        {
            gvContacts.DataSource = DbHelper.ExecuteQuery("usp_GetAttractionContacts");
            gvContacts.DataBind();
        }

        protected void btnSave_Click(object sender, EventArgs e)
        {
            if (!Page.IsValid) return;

            int contactId = int.Parse(hfContactId.Value);
            string action = contactId == 0 ? "INSERT" : "UPDATE";

            try
            {
                DbHelper.ExecuteNonQuery("usp_MaintainAttractionContact",
                    new SqlParameter("@Action", action),
                    new SqlParameter("@Contact_ID", contactId == 0 ? (object)DBNull.Value : contactId),
                    new SqlParameter("@Contact_Name", txtContactName.Text.Trim()),
                    new SqlParameter("@Contact_Phone", txtContactPhone.Text.Trim()),
                    new SqlParameter("@Contact_Email", txtContactEmail.Text.Trim()),
                    new SqlParameter("@Attraction_ID", int.Parse(ddlAttraction.SelectedValue)));

                lblMessage.Text = "Saved successfully.";
                ClearForm();
                LoadGrid();
            }
            catch (Exception ex)
            {
                lblMessage.Text = "Error saving contact: " + ex.Message;
            }
        }

        protected void gvContacts_RowCommand(object sender, GridViewCommandEventArgs e)
        {
            int contactId = int.Parse(e.CommandArgument.ToString());

            if (e.CommandName == "EditRow")
            {
                DataTable dt = DbHelper.ExecuteQuery("usp_GetAttractionContacts");
                DataRow[] rows = dt.Select("Contact_ID = " + contactId);
                if (rows.Length == 1)
                {
                    DataRow row = rows[0];
                    hfContactId.Value = contactId.ToString();
                    txtContactName.Text = row["Contact_Name"].ToString();
                    txtContactPhone.Text = row["Contact_Phone"].ToString();
                    txtContactEmail.Text = row["Contact_Email"].ToString();
                    ddlAttraction.SelectedValue = row["Attraction_ID"].ToString();
                }
            }
            else if (e.CommandName == "DeleteRow")
            {
                DbHelper.ExecuteNonQuery("usp_MaintainAttractionContact",
                    new SqlParameter("@Action", "DELETE"),
                    new SqlParameter("@Contact_ID", contactId));
                lblMessage.Text = "Contact deleted.";
                LoadGrid();
            }
        }

        protected void btnClear_Click(object sender, EventArgs e)
        {
            ClearForm();
        }

        private void ClearForm()
        {
            hfContactId.Value = "0";
            txtContactName.Text = ""; txtContactPhone.Text = ""; txtContactEmail.Text = "";
        }
    }
}
