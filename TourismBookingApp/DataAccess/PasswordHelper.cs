using System.Security.Cryptography;
using System.Text;

namespace TourismBookingApp.DataAccess
{
    public static class PasswordHelper
    {
        public static string Hash(string plainText)
        {
            using (SHA256 sha = SHA256.Create())
            {
                byte[] bytes = sha.ComputeHash(Encoding.UTF8.GetBytes(plainText));
                StringBuilder sb = new StringBuilder();
                foreach (byte b in bytes) sb.Append(b.ToString("x2"));
                return sb.ToString();
            }
        }
    }
}
