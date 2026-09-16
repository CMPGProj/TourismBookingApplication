using System;
using System.Data;
using System.Data.SqlClient;

namespace TourismBookingApp.DataAccess
{
    public class AttractionDataAccess
    {
        private readonly string _connectionString;

        public AttractionDataAccess(string connectionString)
        {
            _connectionString = connectionString;
        }

        private int ExecuteAttractionProcedure(SqlParameter[] parameters)
        {
            using (SqlConnection conn = new SqlConnection(_connectionString))
            using (SqlCommand cmd = new SqlCommand("usp_MaintainAttraction", conn))
            {
                cmd.CommandType = CommandType.StoredProcedure;
                cmd.Parameters.AddRange(parameters);

                conn.Open();
                return cmd.ExecuteNonQuery();
            }
        }

        public int InsertAttraction(string name, string description, string category,
                                     decimal price, int businessId, int townId)
        {
            return ExecuteAttractionProcedure(new[]
            {
                new SqlParameter("@Action", "INSERT"),
                new SqlParameter("@Attraction_Name", name),
                new SqlParameter("@Description", description),
                new SqlParameter("@Category", category),
                new SqlParameter("@Price", price),
                new SqlParameter("@Business_ID", businessId),
                new SqlParameter("@Town_ID", townId)
            });
        }

        public int UpdateAttraction(int attractionId, string name, string description,
                                     string category, decimal price, int businessId, int townId)
        {
            return ExecuteAttractionProcedure(new[]
            {
                new SqlParameter("@Action", "UPDATE"),
                new SqlParameter("@Attraction_ID", attractionId),
                new SqlParameter("@Attraction_Name", name),
                new SqlParameter("@Description", description),
                new SqlParameter("@Category", category),
                new SqlParameter("@Price", price),
                new SqlParameter("@Business_ID", businessId),
                new SqlParameter("@Town_ID", townId)
            });
        }

        public int DeleteAttraction(int attractionId)
        {
            return ExecuteAttractionProcedure(new[]
            {
                new SqlParameter("@Action", "DELETE"),
                new SqlParameter("@Attraction_ID", attractionId)
            });
        }

        public bool ValidateAttraction(string name, decimal price, out string errorMessage)
        {
            errorMessage = string.Empty;
            if (string.IsNullOrWhiteSpace(name))
                errorMessage = "Attraction name is required.";
            else if (price < 0)
                errorMessage = "Price cannot be negative.";

            return string.IsNullOrEmpty(errorMessage);
        }
    }
}
