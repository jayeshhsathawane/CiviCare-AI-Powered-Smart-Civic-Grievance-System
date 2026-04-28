using System;
using System.Data;
using System.Data.SqlClient;
using System.Configuration;
using System.Web.UI;

public partial class SystemLogin : System.Web.UI.Page
{
    private readonly string connString = ConfigurationManager.AppSettings["DbConnection"];

    protected void Page_Load(object sender, EventArgs e)
    {
        if (!IsPostBack)
        {
            // =======================================================
            // SECURE LOGOUT LOGIC IMPLEMENTED HERE
            // If the URL contains "?action=logout", clear the session.
            // =======================================================
            if (Request.QueryString["action"] != null && Request.QueryString["action"] == "logout")
            {
                // Clear all sessions securely
                Session.Clear();
                Session.Abandon();

                // Prevent caching of the secured pages after logout
                Response.Cache.SetCacheability(System.Web.HttpCacheability.NoCache);
                Response.Cache.SetExpires(DateTime.UtcNow.AddHours(-1));
                Response.Cache.SetNoStore();

                ShowToast("You have been successfully logged out.", "success");
            }
        }
    }

    // =======================================================
    // SECURE LOGIN LOGIC
    // =======================================================
    protected void btnLogin_Click(object sender, EventArgs e)
    {
        string selectedRole = ddlRole.SelectedValue;
        string loginId = txtLoginId.Text.Trim();
        string password = txtPassword.Text.Trim();

        // 1. Basic Validation
        if (string.IsNullOrEmpty(selectedRole) || string.IsNullOrEmpty(loginId) || string.IsNullOrEmpty(password))
        {
            ShowToast("All fields are required for authentication.", "error");
            return;
        }

        try
        {
            using (SqlConnection con = new SqlConnection(connString))
            {
                // 2. Querying tbl_Users based on Role, Email/Mobile and Password
                string query = "SELECT UserID, FullName, UserRole, IsActive " +
                               "FROM tbl_Users " +
                               "WHERE (Email = @LoginId OR MobileNo = @LoginId) " +
                               "AND PasswordHash = @Password " +
                               "AND UserRole = @Role";

                using (SqlCommand cmd = new SqlCommand(query, con))
                {
                    cmd.Parameters.AddWithValue("@LoginId", loginId);
                    cmd.Parameters.AddWithValue("@Password", password);
                    cmd.Parameters.AddWithValue("@Role", selectedRole);

                    con.Open();
                    using (SqlDataReader dr = cmd.ExecuteReader())
                    {
                        if (dr.Read())
                        {
                            bool isActive = Convert.ToBoolean(dr["IsActive"]);

                            // 3. Check if Admin/Staff account is active
                            if (isActive)
                            {
                                // Set Secure Sessions
                                Session["UserID"] = dr["UserID"].ToString();
                                Session["FullName"] = dr["FullName"].ToString();
                                Session["Role"] = dr["UserRole"].ToString();

                                // Redirect to appropriate Dashboard
                                RedirectToDashboard(selectedRole);
                            }
                            else
                            {
                                ShowToast("Access Denied: Your account has been suspended.", "error");
                            }
                        }
                        else
                        {
                            ShowToast("Authentication Failed. Invalid Credentials.", "error");
                        }
                    }
                }
            }
        }
        catch (Exception ex)
        {
            ShowToast("System Error: " + ex.Message.Replace("'", ""), "error");
        }
    }

    // =======================================================
    // HELPER: REDIRECT TO DASHBOARDS
    // =======================================================
    private void RedirectToDashboard(string role)
    {
        switch (role)
        {
            case "Admin":
                Response.Redirect("admin/AdminDashboard.aspx", false);
                break;
            case "Electric":
                Response.Redirect("electricity/ElectricDeptDashboard.aspx", false);
                break;
            case "Water":
                Response.Redirect("water/WaterDeptDashboard.aspx", false);
                break;
            case "Sanitation":
                Response.Redirect("Garbage/SanitationDeptDashboard.aspx", false);
                break;
            default:
                ShowToast("Invalid Designation Mapping.", "error");
                break;
        }
    }

    // =======================================================
    // HELPER: TOAST NOTIFICATION
    // =======================================================
    private void ShowToast(string message, string type)
    {
        string safeMessage = message.Replace("'", "\\'").Replace("\r", "").Replace("\n", "");
        string script = "showToast('" + safeMessage + "', '" + type + "');";
        ScriptManager.RegisterStartupScript(this, GetType(), "ServerToast", script, true);
    }
}