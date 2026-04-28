using System;
using System.Data;
using System.Data.SqlClient;
using System.Configuration;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Net;
using System.Net.Mail;

public partial class SanitationStaff : System.Web.UI.Page
{
    private readonly string connString = ConfigurationManager.AppSettings["DbConnection"];

    // Email Credentials
    private readonly string senderEmail = "jayeshrsathawane123@gmail.com";
    private readonly string senderAppPassword = "rewu zgww qzoa utkq";

    protected void Page_Load(object sender, EventArgs e)
    {
        if (Session["UserID"] == null || Session["Role"] == null || Session["Role"].ToString() != "Sanitation")
        {
            Response.Redirect("~/Default.aspx");
        }

        if (!IsPostBack)
        {
            litAdminName.Text = Session["FullName"] != null ? Session["FullName"].ToString() : "Dept Head";
            BindStaffGrid();
        }
    }

    // ==========================================
    // 1. ADD NEW STAFF WITH EMAIL
    // ==========================================
    protected void btnAddStaff_Click(object sender, EventArgs e)
    {
        string fullName = txtName.Text.Trim();
        string mobile = txtMobile.Text.Trim();
        string email = txtEmail.Text.Trim();
        string department = "Sanitation";

        if (string.IsNullOrEmpty(fullName) || string.IsNullOrEmpty(mobile) || string.IsNullOrEmpty(email))
        {
            ShowToast("All fields are required.", "error");
            return;
        }

        try
        {
            using (SqlConnection con = new SqlConnection(connString))
            {
                string query = "INSERT INTO tbl_staff (FullName, ContactNo, Email, Department, IsActive) " +
                               "VALUES (@FullName, @ContactNo, @Email, @Dept, 1)";

                using (SqlCommand cmd = new SqlCommand(query, con))
                {
                    cmd.Parameters.AddWithValue("@FullName", fullName);
                    cmd.Parameters.AddWithValue("@ContactNo", mobile);
                    cmd.Parameters.AddWithValue("@Email", email);
                    cmd.Parameters.AddWithValue("@Dept", department);

                    con.Open();
                    int rowsAffected = cmd.ExecuteNonQuery();

                    if (rowsAffected > 0)
                    {
                        // 🔥 Fire Welcome Email
                        SendWelcomeEmail(email, fullName, department);

                        ShowToast("Field Staff added & notified via email successfully!", "success");
                        txtName.Text = "";
                        txtMobile.Text = "";
                        txtEmail.Text = "";
                        BindStaffGrid();
                    }
                }
            }
        }
        catch (Exception ex)
        {
            ShowToast("DB Error: " + ex.Message.Replace("'", ""), "error");
        }
    }

    private void SendWelcomeEmail(string staffEmail, string staffName, string dept)
    {
        try
        {
            SmtpClient smtp = new SmtpClient("smtp.gmail.com", 587);
            smtp.EnableSsl = true;
            smtp.UseDefaultCredentials = false;
            smtp.Credentials = new NetworkCredential(senderEmail, senderAppPassword);

            MailMessage mail = new MailMessage();
            mail.From = new MailAddress(senderEmail, "CiviCare " + dept + " Dept");
            mail.To.Add(staffEmail);
            mail.Subject = "Welcome to CiviCare Field Operations!";
            mail.IsBodyHtml = true;

            string bodyHtml = "<html><body style='font-family:Arial,sans-serif; background-color:#f8fafc; padding:20px;'>" +
                              "<div style='max-width:600px; margin:0 auto; background:#ffffff; border-radius:10px; overflow:hidden; box-shadow:0 4px 6px rgba(0,0,0,0.1);'>" +
                              "<div style='background-color:#16a34a; color:#ffffff; padding:20px; text-align:center;'>" +
                              "<h2 style='margin:0;'>Welcome to CiviCare!</h2></div>" +
                              "<div style='padding:30px; color:#333333;'>" +
                              "<h3 style='margin-top:0;'>Hello " + staffName + ",</h3>" +
                              "<p>You have been successfully registered as a Field Worker in the <strong>" + dept + " Department</strong>.</p>" +
                              "<p>Whenever a new task is assigned to you, you will receive an email notification here containing the exact issue details, citizen contact number, and a Google Maps tracking link.</p>" +
                              "<br/><p>Best of luck with your operations!<br/><strong>CiviCare Admin Team</strong></p>" +
                              "</div></div></body></html>";

            mail.Body = bodyHtml;
            smtp.Send(mail);
        }
        catch (Exception ex)
        {
            System.Diagnostics.Debug.WriteLine("Email Error: " + ex.Message);
        }
    }

    // ==========================================
    // 2. BIND STAFF TABLE
    // ==========================================
    private void BindStaffGrid()
    {
        try
        {
            using (SqlConnection con = new SqlConnection(connString))
            {
                string query = "SELECT StaffID, FullName, ContactNo, Email, IsActive " +
                               "FROM tbl_staff WHERE Department = 'Sanitation' ORDER BY StaffID DESC";

                using (SqlCommand cmd = new SqlCommand(query, con))
                {
                    using (SqlDataAdapter sda = new SqlDataAdapter(cmd))
                    {
                        DataTable dt = new DataTable();
                        sda.Fill(dt);

                        if (dt.Rows.Count > 0)
                        {
                            rptStaff.DataSource = dt;
                            rptStaff.DataBind();
                            trNoData.Visible = false;
                        }
                        else
                        {
                            rptStaff.DataSource = null;
                            rptStaff.DataBind();
                            trNoData.Visible = true;
                        }
                    }
                }
            }
        }
        catch { }
    }

    // ==========================================
    // 3. HANDLE BLOCK/UNBLOCK & DELETE (Trigger Modal)
    // ==========================================
    protected void rptStaff_ItemCommand(object source, RepeaterCommandEventArgs e)
    {
        string[] args = e.CommandArgument.ToString().Split('|');
        string staffId = args[0];
        hfActionStaffId.Value = staffId;

        if (e.CommandName == "ToggleStatus")
        {
            bool currentStatus = Convert.ToBoolean(args[1]);
            string staffName = args[2];
            hfActionType.Value = "ToggleStatus";
            hfActionCurrentStatus.Value = currentStatus.ToString();

            if (currentStatus)
            {
                litModalIcon.Text = "<div class='w-full h-full bg-green-100 text-green-500 rounded-full flex items-center justify-center'><i class='fa-solid fa-user-lock'></i></div>";
                litModalTitle.Text = "Block Staff?";
                litModalMessage.Text = "Are you sure you want to block <strong>" + staffName + "</strong>? They won't be available for task assignment.";
                btnModalConfirm.CssClass = "flex-1 bg-green-600 hover:bg-green-700 text-white font-bold py-2.5 rounded-lg shadow-md transition cursor-pointer text-sm";
                btnModalConfirm.Text = "Yes, Block";
            }
            else
            {
                litModalIcon.Text = "<div class='w-full h-full bg-red-100 text-red-500 rounded-full flex items-center justify-center'><i class='fa-solid fa-user-check'></i></div>";
                litModalTitle.Text = "Unblock Staff?";
                litModalMessage.Text = "Are you sure you want to unblock <strong>" + staffName + "</strong>?";
                btnModalConfirm.CssClass = "flex-1 bg-red-600 hover:bg-red-700 text-white font-bold py-2.5 rounded-lg shadow-md transition cursor-pointer text-sm";
                btnModalConfirm.Text = "Yes, Unblock";
            }
        }
        else if (e.CommandName == "DeleteStaff")
        {
            string staffName = args[1];
            hfActionType.Value = "DeleteStaff";

            litModalIcon.Text = "<div class='w-full h-full bg-red-100 text-red-500 rounded-full flex items-center justify-center'><i class='fa-solid fa-triangle-exclamation'></i></div>";
            litModalTitle.Text = "Delete Permanently?";
            litModalMessage.Text = "You are about to permanently delete <strong>" + staffName + "</strong>. This action cannot be undone. Proceed?";
            btnModalConfirm.CssClass = "flex-1 bg-red-600 hover:bg-red-700 text-white font-bold py-2.5 rounded-lg shadow-md transition cursor-pointer text-sm";
            btnModalConfirm.Text = "Yes, Delete";
        }

        pnlActionModal.Visible = true;
    }

    // ==========================================
    // 4. EXECUTE MODAL ACTION (DB Queries)
    // ==========================================
    protected void btnModalConfirm_Click(object sender, EventArgs e)
    {
        string actionType = hfActionType.Value;
        string staffId = hfActionStaffId.Value;

        try
        {
            using (SqlConnection con = new SqlConnection(connString))
            {
                con.Open();

                if (actionType == "ToggleStatus")
                {
                    bool newStatus = !Convert.ToBoolean(hfActionCurrentStatus.Value);
                    string query = "UPDATE tbl_staff SET IsActive = @Status WHERE StaffID = @SID";
                    using (SqlCommand cmd = new SqlCommand(query, con))
                    {
                        cmd.Parameters.AddWithValue("@Status", newStatus);
                        cmd.Parameters.AddWithValue("@SID", staffId);
                        if (cmd.ExecuteNonQuery() > 0)
                        {
                            ShowToast(newStatus ? "Staff unblocked successfully!" : "Staff blocked successfully!", "success");
                        }
                    }
                }
                else if (actionType == "DeleteStaff")
                {
                    string query = "DELETE FROM tbl_staff WHERE StaffID = @SID";
                    using (SqlCommand cmd = new SqlCommand(query, con))
                    {
                        cmd.Parameters.AddWithValue("@SID", staffId);
                        if (cmd.ExecuteNonQuery() > 0)
                        {
                            ShowToast("Staff deleted from system.", "success");
                        }
                    }
                }
            }

            pnlActionModal.Visible = false;
            BindStaffGrid();
        }
        catch (SqlException sqlEx)
        {
            if (sqlEx.Number == 547)
            {
                ShowToast("Cannot delete staff! They are already assigned to a complaint. Block them instead.", "error");
            }
            else
            {
                ShowToast("Database Error Occurred.", "error");
            }
            pnlActionModal.Visible = false;
        }
    }

    protected void btnCloseAction_Click(object sender, EventArgs e)
    {
        pnlActionModal.Visible = false;
    }

    protected void btnCancel_Click(object sender, EventArgs e)
    {
        txtName.Text = "";
        txtMobile.Text = "";
        txtEmail.Text = "";
    }

    protected string GetInitials(string fullName)
    {
        if (string.IsNullOrEmpty(fullName)) return "S";
        string[] names = fullName.Split(' ');
        if (names.Length > 1) return (names[0][0].ToString() + names[1][0].ToString()).ToUpper();
        return names[0][0].ToString().ToUpper();
    }

    private void ShowToast(string message, string type)
    {
        string safeMessage = message.Replace("'", "\\'").Replace("\r", "").Replace("\n", "");
        string script = "showToast('" + safeMessage + "', '" + type + "');";
        ScriptManager.RegisterStartupScript(this, GetType(), "ToastScript", script, true);
    }
}