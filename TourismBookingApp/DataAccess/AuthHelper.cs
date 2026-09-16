using System;
using System.Web.UI;

namespace TourismBookingApp.DataAccess
{
    public static class AuthHelper
    {
        public static bool IsLoggedIn(Page page)
        {
            return page.Session["Role"] != null;
        }

        public static void RequireLogin(Page page)
        {
            if (!IsLoggedIn(page))
            {
                page.Response.Redirect("Login.aspx");
            }
        }

        public static void RequireRole(Page page, params string[] allowedRoles)
        {
            RequireLogin(page);

            string role = page.Session["Role"] != null ? page.Session["Role"].ToString() : "";
            foreach (string allowed in allowedRoles)
            {
                if (string.Equals(allowed, role, StringComparison.OrdinalIgnoreCase))
                    return;
            }

            page.Response.Redirect("Home.aspx?denied=1");
        }
    }
}
