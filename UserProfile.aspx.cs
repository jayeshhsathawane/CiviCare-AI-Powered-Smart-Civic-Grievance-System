using System;
using System.Data;
using System.Data.SqlClient;
using System.Configuration;
using System.Text.RegularExpressions;
using System.Web.UI;

public partial class UserProfile : System.Web.UI.Page
{
    private readonly string connString = ConfigurationManager.AppSettings["DbConnection"];

    protected void Page_Load(object sender, EventArgs e)
    {
        // 1. SECURE ACCESS: Check if user is logged in
        if (Session["UserID"] == null || Session["Role"] == null)
        {
            Response.Redirect("~/Default.aspx");
        }

        if (!IsPostBack)
        {
            SetSidebarVisibility(); // Show the correct sidebar based on role
            LoadUserProfile();      // Load details into TextBoxes
        }
    }

    // =======================================================
    // STEP 1: DYNAMICALLY LOAD THE CORRECT SIDEBAR
    // =======================================================
    private void SetSidebarVisibility()
    {
        string role = Session["Role"].ToString();

        // Hide all sidebars initially (IDs EXACTLY matching your .aspx file)
        pnlCitizen.Visible = false;
        pnlAdmin.Visible = false;
        pnlWater.Visible = false;
        pnlElectric.Visible = false;
        pnlSanitation.Visible = false;

        // Show only the sidebar for the logged-in role
        switch (role)
        {
            case "Citizen":
                pnlCitizen.Visible = true;
                litRoleBadge.Text = "Citizen User";
                break;
            case "Admin":
                pnlAdmin.Visible = true;
                litRoleBadge.Text = "Super Admin";
                break;
            case "Water":
                pnlWater.Visible = true;
                litRoleBadge.Text = "Water Dept Staff";
                break;
            case "Electric":
                pnlElectric.Visible = true;
                litRoleBadge.Text = "Electric Dept Staff";
                break;
            case "Sanitation":
                pnlSanitation.Visible = true;
                litRoleBadge.Text = "Sanitation Dept Staff";
                break;
        }
    }

    // =======================================================
    // STEP 2: LOAD USER DATA FROM DATABASE
    // =======================================================
    private void LoadUserProfile()
    {
        string userId = Session["UserID"].ToString();

        try
        {
            using (SqlConnection con = new SqlConnection(connString))
            {
                string query = "SELECT FullName, Email, MobileNo, UserRole FROM tbl_Users WHERE UserID = @UID";
                using (SqlCommand cmd = new SqlCommand(query, con))
                {
                    cmd.Parameters.AddWithValue("@UID", userId);
                    con.Open();
                    using (SqlDataReader dr = cmd.ExecuteReader())
                    {
                        if (dr.Read())
                        {
                            string fullName = dr["FullName"].ToString();

                            // Bind TextBoxes
                            txtFullName.Text = fullName;
                            txtEmail.Text = dr["Email"].ToString();
                            txtMobile.Text = dr["MobileNo"].ToString();

                            // Bind Top Header UI Graphics
                            litTopName.Text = fullName;
                            litTopEmail.Text = dr["Email"].ToString();
                            litInitials.Text = GetInitials(fullName);

                            // 🔥 SECURITY CHECK: Restrict editing for Staff
                            string role = dr["UserRole"].ToString();
                            if (role == "Electric" || role == "Water" || role == "Sanitation")
                            {
                                // Staff cannot change their official name and mobile
                                txtFullName.Enabled = false;
                                txtMobile.Enabled = false;
                                btnUpdateProfile.Visible = false; // Hide save button
                                divStaffNotice.Visible = true;    // Show warning banner
                            }
                        }
                    }
                }
            }
        }
        catch (Exception ex)
        {
            ShowToast("Error loading profile: " + ex.Message.Replace("'", ""), "error");
        }
    }

    // =======================================================
    // STEP 3: UPDATE PROFILE DETAILS (Citizen & Admin Only)
    // =======================================================
    protected void btnUpdateProfile_Click(object sender, EventArgs e)
    {
        string userId = Session["UserID"].ToString();
        string newName = txtFullName.Text.Trim();
        string newMobile = txtMobile.Text.Trim();

        // Extra Backend Check: Ensure staff cannot bypass frontend disabled state using DevTools
        string role = Session["Role"].ToString();
        if (role == "Electric" || role == "Water" || role == "Sanitation")
        {
            ShowToast("Staff members are not allowed to update profile info.", "error");
            return;
        }

        // Basic Validations
        if (string.IsNullOrEmpty(newName) || string.IsNullOrEmpty(newMobile))
        {
            ShowToast("Name and Mobile Number cannot be empty.", "error");
            return;
        }

        if (!Regex.IsMatch(newMobile, @"^\d{10}$"))
        {
            ShowToast("Mobile number must be exactly 10 digits.", "error");
            return;
        }

        try
        {
            using (SqlConnection con = new SqlConnection(connString))
            {
                // Note: Email is not updated as it's the primary login identifier
                string query = "UPDATE tbl_Users SET FullName = @Name, MobileNo = @Mobile WHERE UserID = @UID";
                using (SqlCommand cmd = new SqlCommand(query, con))
                {
                    cmd.Parameters.AddWithValue("@Name", newName);
                    cmd.Parameters.AddWithValue("@Mobile", newMobile);
                    cmd.Parameters.AddWithValue("@UID", userId);

                    con.Open();
                    if (cmd.ExecuteNonQuery() > 0)
                    {
                        // Update Session Variable & UI Header
                        Session["FullName"] = newName;
                        litTopName.Text = newName;
                        litInitials.Text = GetInitials(newName);

                        ShowToast("Profile details updated successfully!", "success");
                    }
                    else
                    {
                        ShowToast("Update failed. User not found.", "error");
                    }
                }
            }
        }
        catch (SqlException ex)
        {
            if (ex.Number == 2627 || ex.Number == 2601) // Unique key constraint (Mobile)
            {
                ShowToast("Mobile Number is already associated with another account.", "error");
            }
            else
            {
                ShowToast("Database Error Occurred.", "error");
            }
        }
    }

    // =======================================================
    // STEP 4: CHANGE PASSWORD LOGIC (Available for ALL users)
    // =======================================================
    protected void btnChangePassword_Click(object sender, EventArgs e)
    {
        string userId = Session["UserID"].ToString();
        string oldPass = txtOldPass.Text.Trim();
        string newPass = txtNewPass.Text.Trim();

        // 1. Password Complexity Rule
        if (!Regex.IsMatch(newPass, @"^(?=.*[A-Za-z])(?=.*\d)(?=.*[@$!%*#?&])[A-Za-z\d@$!%*#?&]{6,}$"))
        {
            ShowToast("New Password must have min 6 chars, 1 number & 1 special character.", "error");
            return;
        }

        try
        {
            using (SqlConnection con = new SqlConnection(connString))
            {
                // 2. Verify the Old Password from Database
                string verifyQuery = "SELECT COUNT(1) FROM tbl_Users WHERE UserID = @UID AND PasswordHash = @OldPass";
                using (SqlCommand cmdVerify = new SqlCommand(verifyQuery, con))
                {
                    cmdVerify.Parameters.AddWithValue("@UID", userId);
                    cmdVerify.Parameters.AddWithValue("@OldPass", oldPass);

                    con.Open();
                    int exists = Convert.ToInt32(cmdVerify.ExecuteScalar());

                    if (exists == 0)
                    {
                        ShowToast("Incorrect Current Password. Please try again.", "error");
                        return;
                    }
                }

                // 3. If old password matches, Update to New Password
                string updateQuery = "UPDATE tbl_Users SET PasswordHash = @NewPass WHERE UserID = @UID";
                using (SqlCommand cmdUpdate = new SqlCommand(updateQuery, con))
                {
                    cmdUpdate.Parameters.AddWithValue("@NewPass", newPass);
                    cmdUpdate.Parameters.AddWithValue("@UID", userId);

                    if (cmdUpdate.ExecuteNonQuery() > 0)
                    {
                        ShowToast("Password changed successfully!", "success");
                        // Clear password fields
                        txtOldPass.Text = "";
                        txtNewPass.Text = "";
                        txtConfirmPass.Text = "";
                    }
                    else
                    {
                        ShowToast("Error updating password.", "error");
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
    // HELPER: GET USER INITIALS FOR AVATAR
    // =======================================================
    private string GetInitials(string fullName)
    {
        if (string.IsNullOrEmpty(fullName)) return "U";
        string[] names = fullName.Split(new char[] { ' ' }, StringSplitOptions.RemoveEmptyEntries);
        if (names.Length > 1) return (names[0][0].ToString() + names[1][0].ToString()).ToUpper();
        return names[0][0].ToString().ToUpper();
    }

    // =======================================================
    // HELPER: TOAST NOTIFICATIONS
    // =======================================================
    private void ShowToast(string message, string type)
    {
        string safeMessage = message.Replace("'", "\\'").Replace("\r", "").Replace("\n", "");
        string script = "showToast('" + safeMessage + "', '" + type + "');";
        ScriptManager.RegisterStartupScript(this, GetType(), "ServerToast", script, true);
    }
}