using System;
using System.Data;
using System.Data.SqlClient;
using System.Configuration;
using System.Text.RegularExpressions;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Net;           // ADDED for Email
using System.Net.Mail;      // ADDED for Email

public partial class ManageUsers : System.Web.UI.Page
{
    private readonly string connString = ConfigurationManager.AppSettings["DbConnection"];

    // =======================================================
    // EMAIL CREDENTIALS (Added for Notifications)
    // =======================================================
    private readonly string senderEmail = "jayeshrsathawane123@gmail.com";
    private readonly string senderAppPassword = "rewu zgww qzoa utkq";

    protected void Page_Load(object sender, EventArgs e)
    {
        // Require Admin Role
        if (Session["UserID"] == null || Session["Role"] == null || Session["Role"].ToString() != "Admin")
        {
            Response.Redirect("~/Default.aspx");
        }

        if (!IsPostBack)
        {
            litAdminName.Text = Session["FullName"] != null ? Session["FullName"].ToString() : "Admin User";
            BindUserGrid();
        }
    }

    // =======================================================
    // 1. ADD NEW USER LOGIC
    // =======================================================
    protected void btnCreateUser_Click(object sender, EventArgs e)
    {
        string fullName = txtName.Text.Trim();
        string email = txtEmail.Text.Trim();
        string mobile = txtMobile.Text.Trim();
        string role = ddlRole.SelectedValue;
        string password = txtPass.Text.Trim();

        if (string.IsNullOrEmpty(fullName) || string.IsNullOrEmpty(email) || string.IsNullOrEmpty(mobile) || string.IsNullOrEmpty(role) || string.IsNullOrEmpty(password))
        {
            ShowToast("All fields are required.", "error");
            return;
        }

        if (!Regex.IsMatch(password, @"^(?=.*[A-Za-z])(?=.*\d)(?=.*[@$!%*#?&])[A-Za-z\d@$!%*#?&]{6,}$"))
        {
            ShowToast("Password must have min 6 chars, 1 number & 1 special char.", "error");
            return;
        }

        try
        {
            using (SqlConnection con = new SqlConnection(connString))
            {
                string query = "INSERT INTO tbl_Users (FullName, Email, MobileNo, PasswordHash, UserRole, IsActive) " +
                               "VALUES (@FullName, @Email, @MobileNo, @PasswordHash, @UserRole, 1)";

                using (SqlCommand cmd = new SqlCommand(query, con))
                {
                    cmd.Parameters.AddWithValue("@FullName", fullName);
                    cmd.Parameters.AddWithValue("@Email", email);
                    cmd.Parameters.AddWithValue("@MobileNo", mobile);
                    cmd.Parameters.AddWithValue("@PasswordHash", password);
                    cmd.Parameters.AddWithValue("@UserRole", role);

                    con.Open();
                    int rowsAffected = cmd.ExecuteNonQuery();

                    if (rowsAffected > 0)
                    {
                        // 🔥 FEATURE ADDED: Send Email Notification with Credentials to the New User
                        SendEmailNotification(email, fullName, role, password, "AccountCreated");

                        ShowToast("Successfully created account for " + role + " Dept!", "success");
                        ClearFields();
                        BindUserGrid();
                    }
                }
            }
        }
        catch (SqlException ex)
        {
            if (ex.Number == 2627 || ex.Number == 2601) ShowToast("Email or Mobile Number already exists!", "error");
            else ShowToast("DB Error: " + ex.Message.Replace("'", ""), "error");
        }
    }

    // =======================================================
    // 2. FETCH AND BIND USERS
    // =======================================================
    private void BindUserGrid()
    {
        try
        {
            using (SqlConnection con = new SqlConnection(connString))
            {
                string query = "SELECT UserID, FullName, Email, MobileNo, UserRole, IsActive " +
                               "FROM tbl_Users " +
                               "WHERE UserRole IN ('Electric', 'Water', 'Sanitation') " +
                               "ORDER BY UserID DESC";

                using (SqlCommand cmd = new SqlCommand(query, con))
                {
                    using (SqlDataAdapter sda = new SqlDataAdapter(cmd))
                    {
                        DataTable dt = new DataTable();
                        sda.Fill(dt);

                        if (dt.Rows.Count > 0)
                        {
                            rptUsers.DataSource = dt;
                            rptUsers.DataBind();
                            trNoData.Visible = false;
                        }
                        else
                        {
                            rptUsers.DataSource = null;
                            rptUsers.DataBind();
                            trNoData.Visible = true;
                        }
                    }
                }
            }
        }
        catch { }
    }

    // =======================================================
    // 3. HANDLE BLOCK/UNBLOCK & DELETE (Trigger Modal)
    // =======================================================
    protected void rptUsers_ItemCommand(object source, RepeaterCommandEventArgs e)
    {
        string[] args = e.CommandArgument.ToString().Split('|');
        string userId = args[0];

        hfActionUserId.Value = userId;

        if (e.CommandName == "ToggleStatus")
        {
            bool currentStatus = Convert.ToBoolean(args[1]);
            string userName = args[2];
            hfActionType.Value = "ToggleStatus";
            hfActionCurrentStatus.Value = currentStatus.ToString();

            if (currentStatus)
            {
                // Action to BLOCK
                litModalIcon.Text = "<div class='w-full h-full bg-orange-100 text-orange-500 rounded-full flex items-center justify-center'><i class='fa-solid fa-user-lock'></i></div>";
                litModalTitle.Text = "Block Employee?";
                litModalMessage.Text = "Are you sure you want to block access for <strong>" + userName + "</strong>? They will not be able to log in to the portal.";
                btnModalConfirm.CssClass = "flex-1 bg-orange-500 hover:bg-orange-600 text-white font-bold py-2.5 rounded-lg shadow-md transition cursor-pointer text-sm";
                btnModalConfirm.Text = "Yes, Block Access";
            }
            else
            {
                // Action to UNBLOCK
                litModalIcon.Text = "<div class='w-full h-full bg-green-100 text-green-500 rounded-full flex items-center justify-center'><i class='fa-solid fa-user-check'></i></div>";
                litModalTitle.Text = "Unblock Employee?";
                litModalMessage.Text = "Are you sure you want to restore access for <strong>" + userName + "</strong>? They will be able to log in immediately.";
                btnModalConfirm.CssClass = "flex-1 bg-green-600 hover:bg-green-700 text-white font-bold py-2.5 rounded-lg shadow-md transition cursor-pointer text-sm";
                btnModalConfirm.Text = "Yes, Restore Access";
            }
        }
        else if (e.CommandName == "DeleteUser")
        {
            string userName = args[1];
            hfActionType.Value = "DeleteUser";

            litModalIcon.Text = "<div class='w-full h-full bg-red-100 text-red-500 rounded-full flex items-center justify-center'><i class='fa-solid fa-triangle-exclamation'></i></div>";
            litModalTitle.Text = "Delete Permanently?";
            litModalMessage.Text = "You are about to permanently delete <strong>" + userName + "</strong> from the database. This action cannot be undone. Proceed?";
            btnModalConfirm.CssClass = "flex-1 bg-red-600 hover:bg-red-700 text-white font-bold py-2.5 rounded-lg shadow-md transition cursor-pointer text-sm";
            btnModalConfirm.Text = "Yes, Delete User";
        }

        pnlActionModal.Visible = true;
    }

    // =======================================================
    // 4. CONFIRM MODAL ACTION (Execute DB Query)
    // =======================================================
    protected void btnModalConfirm_Click(object sender, EventArgs e)
    {
        string actionType = hfActionType.Value;
        string userId = hfActionUserId.Value;

        string targetEmail = "";
        string targetName = "";
        string targetRole = "";

        try
        {
            using (SqlConnection con = new SqlConnection(connString))
            {
                con.Open();

                // 🔥 FEATURE ADDED: Fetch target user's details first so we can send them an email
                string getQuery = "SELECT Email, FullName, UserRole FROM tbl_Users WHERE UserID = @UID";
                using (SqlCommand cmdGet = new SqlCommand(getQuery, con))
                {
                    cmdGet.Parameters.AddWithValue("@UID", userId);
                    using (SqlDataReader dr = cmdGet.ExecuteReader())
                    {
                        if (dr.Read())
                        {
                            targetEmail = dr["Email"].ToString();
                            targetName = dr["FullName"].ToString();
                            targetRole = dr["UserRole"].ToString();
                        }
                    }
                }

                if (actionType == "ToggleStatus")
                {
                    bool newStatus = !Convert.ToBoolean(hfActionCurrentStatus.Value);
                    string query = "UPDATE tbl_Users SET IsActive = @Status WHERE UserID = @UID";
                    using (SqlCommand cmd = new SqlCommand(query, con))
                    {
                        cmd.Parameters.AddWithValue("@Status", newStatus);
                        cmd.Parameters.AddWithValue("@UID", userId);
                        if (cmd.ExecuteNonQuery() > 0)
                        {
                            // 🔥 Send Notification Email about Status Change
                            string emailAction = newStatus ? "Unblocked" : "Blocked";
                            SendEmailNotification(targetEmail, targetName, targetRole, "", emailAction);

                            ShowToast(newStatus ? "User unblocked successfully!" : "User blocked successfully!", "success");
                        }
                    }
                }
                else if (actionType == "DeleteUser")
                {
                    // Optionally check if user has assigned complaints before deleting to avoid Foreign Key errors
                    string query = "DELETE FROM tbl_Users WHERE UserID = @UID";
                    using (SqlCommand cmd = new SqlCommand(query, con))
                    {
                        cmd.Parameters.AddWithValue("@UID", userId);
                        if (cmd.ExecuteNonQuery() > 0)
                        {
                            // 🔥 Send Notification Email about Account Deletion
                            SendEmailNotification(targetEmail, targetName, targetRole, "", "Deleted");

                            ShowToast("User deleted permanently from system.", "success");
                        }
                    }
                }
            }

            pnlActionModal.Visible = false;
            BindUserGrid(); // Refresh Grid Live
        }
        catch (SqlException sqlEx)
        {
            if (sqlEx.Number == 547) // Foreign Key Violation
            {
                ShowToast("Cannot delete user! They are assigned to complaints. Block them instead.", "error");
            }
            else
            {
                ShowToast("Database Error Occurred.", "error");
            }
            pnlActionModal.Visible = false;
        }
    }

    // =======================================================
    // 5. 🔥 POWERFUL EMAIL NOTIFICATION LOGIC
    // =======================================================
    private void SendEmailNotification(string toEmail, string name, string role, string password, string actionType)
    {
        try
        {
            if (string.IsNullOrEmpty(toEmail)) return; // Safety check

            string subject = "";
            string bodyHtml = "";

            // Prepare Email Content dynamically based on the Action
            if (actionType == "AccountCreated")
            {
                subject = "Welcome to CiviCare - Your Login Credentials";
                bodyHtml = "<html><body style='font-family:Arial,sans-serif; padding:20px; background-color:#f8fafc;'>" +
                           "<div style='max-width:600px; margin:0 auto; background:#ffffff; border-radius:10px; overflow:hidden; box-shadow:0 4px 6px rgba(0,0,0,0.1);'>" +
                           "<div style='background-color:#2563eb; color:#ffffff; padding:20px; text-align:center;'><h2 style='margin:0;'>Welcome to CiviCare!</h2></div>" +
                           "<div style='padding:30px; color:#333333;'>" +
                           "<p>Hello <strong>" + name + "</strong>,</p>" +
                           "<p>Your official account has been created successfully for the <strong>" + role + " Department</strong>.</p>" +
                           "<div style='background-color:#eff6ff; padding:15px; border-left:4px solid #2563eb; margin:15px 0;'>" +
                           "<p style='margin:0 0 10px 0;'><strong>Login ID (Email):</strong> " + toEmail + "</p>" +
                           "<p style='margin:0;'><strong>Password:</strong> " + password + "</p>" +
                           "</div>" +
                           "<p>Please log in to the Staff portal to view and manage your assigned tasks.</p>" +
                           "<p>Regards,<br/><strong>CiviCare Admin</strong></p></div></div></body></html>";
            }
            else if (actionType == "Blocked")
            {
                subject = "Account Suspended | CiviCare";
                bodyHtml = "<html><body style='font-family:Arial,sans-serif; padding:20px; background-color:#f8fafc;'>" +
                           "<div style='max-width:600px; margin:0 auto; background:#ffffff; border-radius:10px; overflow:hidden; box-shadow:0 4px 6px rgba(0,0,0,0.1);'>" +
                           "<div style='background-color:#ef4444; color:#ffffff; padding:20px; text-align:center;'><h2 style='margin:0;'>Account Suspended</h2></div>" +
                           "<div style='padding:30px; color:#333333;'>" +
                           "<p>Hello <strong>" + name + "</strong>,</p>" +
                           "<p>Your access to the CiviCare portal (<strong>" + role + " Department</strong>) has been <strong style='color:#ef4444;'>BLOCKED</strong> by the Administrator.</p>" +
                           "<p>You will not be able to log in to your dashboard. If you believe this is a mistake, please contact the Main Office.</p>" +
                           "<p>Regards,<br/><strong>CiviCare Admin</strong></p></div></div></body></html>";
            }
            else if (actionType == "Unblocked")
            {
                subject = "Account Restored | CiviCare";
                bodyHtml = "<html><body style='font-family:Arial,sans-serif; padding:20px; background-color:#f8fafc;'>" +
                           "<div style='max-width:600px; margin:0 auto; background:#ffffff; border-radius:10px; overflow:hidden; box-shadow:0 4px 6px rgba(0,0,0,0.1);'>" +
                           "<div style='background-color:#22c55e; color:#ffffff; padding:20px; text-align:center;'><h2 style='margin:0;'>Account Restored</h2></div>" +
                           "<div style='padding:30px; color:#333333;'>" +
                           "<p>Hello <strong>" + name + "</strong>,</p>" +
                           "<p>Your access to the CiviCare portal (<strong>" + role + " Department</strong>) has been <strong style='color:#22c55e;'>RESTORED</strong>.</p>" +
                           "<p>You can now log in normally and continue managing your departmental operations.</p>" +
                           "<p>Regards,<br/><strong>CiviCare Admin</strong></p></div></div></body></html>";
            }
            else if (actionType == "Deleted")
            {
                subject = "Account Deleted | CiviCare";
                bodyHtml = "<html><body style='font-family:Arial,sans-serif; padding:20px; background-color:#f8fafc;'>" +
                           "<div style='max-width:600px; margin:0 auto; background:#ffffff; border-radius:10px; overflow:hidden; box-shadow:0 4px 6px rgba(0,0,0,0.1);'>" +
                           "<div style='background-color:#ef4444; color:#ffffff; padding:20px; text-align:center;'><h2 style='margin:0;'>Account Deleted</h2></div>" +
                           "<div style='padding:30px; color:#333333;'>" +
                           "<p>Hello <strong>" + name + "</strong>,</p>" +
                           "<p>Your profile and access for the CiviCare portal (<strong>" + role + " Department</strong>) has been permanently <strong style='color:#ef4444;'>DELETED</strong> from our system records.</p>" +
                           "<p>Thank you for your services.</p>" +
                           "<p>Regards,<br/><strong>CiviCare Admin</strong></p></div></div></body></html>";
            }

            // Initialize SMTP Client
            SmtpClient smtp = new SmtpClient("smtp.gmail.com", 587);
            smtp.EnableSsl = true;
            smtp.UseDefaultCredentials = false;
            smtp.Credentials = new NetworkCredential(senderEmail, senderAppPassword);

            // Construct and Send Mail
            MailMessage mail = new MailMessage();
            mail.From = new MailAddress(senderEmail, "CiviCare Admin");
            mail.To.Add(toEmail);
            mail.Subject = subject;
            mail.Body = bodyHtml;
            mail.IsBodyHtml = true;

            smtp.Send(mail); // Fire the Email
        }
        catch (Exception ex)
        {
            // System will not crash if Email sending fails
            System.Diagnostics.Debug.WriteLine("Email Error: " + ex.Message);
        }
    }

    protected void btnCloseAction_Click(object sender, EventArgs e)
    {
        pnlActionModal.Visible = false;
    }

    // =======================================================
    // 6. UI FORMATTING HELPERS
    // =======================================================
    protected string GetInitials(string fullName)
    {
        if (string.IsNullOrEmpty(fullName)) return "U";
        string[] names = fullName.Split(' ');
        if (names.Length > 1) return (names[0][0].ToString() + names[1][0].ToString()).ToUpper();
        return names[0][0].ToString().ToUpper();
    }

    protected string GetAvatarCssClass(string role)
    {
        if (role == "Electric") return "bg-orange-50 text-orange-600 border-orange-200";
        if (role == "Water") return "bg-blue-50 text-blue-600 border-blue-200";
        if (role == "Sanitation") return "bg-green-50 text-green-600 border-green-200";
        return "bg-slate-100 text-slate-700 border-slate-200";
    }

    protected string GetBadgeCssClass(string role)
    {
        if (role == "Electric") return "bg-orange-50 text-orange-700 border-orange-200";
        if (role == "Water") return "bg-blue-50 text-blue-700 border-blue-200";
        if (role == "Sanitation") return "bg-green-50 text-green-700 border-green-200";
        return "bg-slate-50 text-slate-700 border-slate-200";
    }

    protected string GetDeptIcon(string role)
    {
        if (role == "Electric") return "fa-bolt";
        if (role == "Water") return "fa-faucet-drip";
        if (role == "Sanitation") return "fa-trash-can";
        return "fa-briefcase";
    }

    protected void btnCancel_Click(object sender, EventArgs e)
    {
        ClearFields();
    }

    private void ClearFields()
    {
        txtName.Text = "";
        txtEmail.Text = "";
        txtMobile.Text = "";
        txtPass.Text = "";
        ddlRole.SelectedIndex = 0;
    }

    private void ShowToast(string message, string type)
    {
        string safeMessage = message.Replace("'", "\\'").Replace("\r", "").Replace("\n", "");
        string script = "showToast('" + safeMessage + "', '" + type + "');";
        ScriptManager.RegisterStartupScript(this, GetType(), "ToastScript", script, true);
    }
}