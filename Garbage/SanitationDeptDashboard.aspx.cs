using System;
using System.Data;
using System.Data.SqlClient;
using System.Configuration;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Net;
using System.Net.Mail;

public partial class SanitationDeptDashboard : System.Web.UI.Page
{
    private readonly string connString = ConfigurationManager.AppSettings["DbConnection"];

    // Email Credentials
   private readonly string senderEmail = "enter email";
    private readonly string senderAppPassword = "app password";

    protected void Page_Load(object sender, EventArgs e)
    {
        if (Session["UserID"] == null || Session["Role"] == null || Session["Role"].ToString() != "Sanitation")
        {
            Response.Redirect("~/Default.aspx");
        }

        if (!IsPostBack)
        {
            litAdminName.Text = Session["FullName"].ToString();
            LoadDashboardStats();
            BindComplaints();
            BindStaffDropdown();
        }
    }

    private void BindComplaints()
    {
        try
        {
            using (SqlConnection con = new SqlConnection(connString))
            {
                string query = "SELECT " +
                               "c.ComplaintID, c.ImagePath, c.UserDepartment, c.Description, " +
                               "c.PriorityLevel, c.Status, c.LocationName, c.Latitude, c.Longitude, c.CreatedAt, c.ProximityAlert, " +
                               "c.CitizenID, " +
                               "u.FullName AS CitizenName, u.MobileNo AS CitizenMobile, " +
                               "staff.FullName AS StaffName " +
                               "FROM tbl_Complaints c " +
                               "INNER JOIN tbl_Users u ON c.CitizenID = u.UserID " +
                               "LEFT JOIN tbl_staff staff ON c.AssignedTeamID = staff.StaffID " +
                               "WHERE c.AssignedDepartment = 'Sanitation' AND c.Status != 'Rejected' AND c.Status != 'Resolved' " +
                               "ORDER BY CASE c.PriorityLevel WHEN 'High' THEN 1 WHEN 'Medium' THEN 2 WHEN 'Low' THEN 3 ELSE 4 END ASC, c.CreatedAt DESC";

                using (SqlCommand cmd = new SqlCommand(query, con))
                {
                    using (SqlDataAdapter sda = new SqlDataAdapter(cmd))
                    {
                        DataTable dt = new DataTable();
                        sda.Fill(dt);
                        if (dt.Rows.Count > 0) { rptComplaints.DataSource = dt; rptComplaints.DataBind(); noDataPanel.Visible = false; }
                        else { rptComplaints.DataSource = null; rptComplaints.DataBind(); noDataPanel.Visible = true; }
                    }
                }
            }
        }
        catch (Exception ex) { ShowToast("Error loading data.", "error"); }
    }

    private void LoadDashboardStats()
    {
        try
        {
            using (SqlConnection con = new SqlConnection(connString))
            {
                string query = "SELECT " +
                               "SUM(CASE WHEN Status = 'AI Verified' OR Status = 'Reported' THEN 1 ELSE 0 END) AS PendingCount, " +
                               "SUM(CASE WHEN Status = 'Assigned' THEN 1 ELSE 0 END) AS InProgressCount, " +
                               "SUM(CASE WHEN Status = 'Resolved' AND CAST(ResolvedAt AS DATE) = CAST(GETDATE() AS DATE) THEN 1 ELSE 0 END) AS ResolvedCount " +
                               "FROM tbl_Complaints WHERE AssignedDepartment = 'Sanitation' AND Status != 'Rejected'";

                using (SqlCommand cmd = new SqlCommand(query, con))
                {
                    con.Open();
                    using (SqlDataReader dr = cmd.ExecuteReader())
                    {
                        if (dr.Read())
                        {
                            litPendingCount.Text = dr["PendingCount"] != DBNull.Value ? dr["PendingCount"].ToString() : "0";
                            litInProgressCount.Text = dr["InProgressCount"] != DBNull.Value ? dr["InProgressCount"].ToString() : "0";
                            litResolvedCount.Text = dr["ResolvedCount"] != DBNull.Value ? dr["ResolvedCount"].ToString() : "0";
                        }
                    }
                }
            }
        }
        catch { }
    }

    private void BindStaffDropdown()
    {
        try
        {
            using (SqlConnection con = new SqlConnection(connString))
            {
                string query = "SELECT s.StaffID, s.FullName, " +
                               "CASE WHEN EXISTS (SELECT 1 FROM tbl_Complaints c WHERE c.AssignedTeamID = s.StaffID AND c.Status = 'Assigned') " +
                               "THEN 'Busy' ELSE 'Available' END AS CurrentStatus " +
                               "FROM tbl_staff s WHERE s.Department = 'Sanitation' AND s.IsActive = 1";

                using (SqlCommand cmd = new SqlCommand(query, con))
                {
                    using (SqlDataAdapter sda = new SqlDataAdapter(cmd))
                    {
                        DataTable dt = new DataTable();
                        sda.Fill(dt);
                        ddlStaff.Items.Clear();
                        ddlStaff.Items.Add(new ListItem("-- Select Staff Member --", ""));
                        foreach (DataRow row in dt.Rows)
                        {
                            string displayText = "[" + row["CurrentStatus"].ToString() + "] " + row["FullName"].ToString();
                            ddlStaff.Items.Add(new ListItem(displayText, row["StaffID"].ToString()));
                        }
                    }
                }
            }
        }
        catch { }
    }

    protected void btnConfirmAssign_Click(object sender, EventArgs e)
    {
        string complaintId = hfSelectedComplaintId.Value;
        string staffId = ddlStaff.SelectedValue;
        string adminComment = txtAdminComment.Text.Trim();
        string selectedText = ddlStaff.SelectedItem != null ? ddlStaff.SelectedItem.Text : "";

        if (string.IsNullOrEmpty(complaintId) || string.IsNullOrEmpty(staffId))
        {
            ShowToast("Please select a staff member.", "error");
            ScriptManager.RegisterStartupScript(this, GetType(), "ReopenAssign", "document.getElementById('assignModal').classList.remove('hidden'); document.getElementById('assignModal').classList.add('flex');", true);
            return;
        }

        if (selectedText.Contains("[Busy]"))
        {
            ShowToast("Staff is currently busy with another task.", "error");
            ScriptManager.RegisterStartupScript(this, GetType(), "ReopenAssign", "document.getElementById('assignModal').classList.remove('hidden'); document.getElementById('assignModal').classList.add('flex');", true);
            return;
        }

        try
        {
            using (SqlConnection con = new SqlConnection(connString))
            {
                string query = "UPDATE tbl_Complaints SET Status = 'Assigned', AssignedTeamID = @TeamID WHERE ComplaintID = @CompID";
                using (SqlCommand cmd = new SqlCommand(query, con))
                {
                    cmd.Parameters.AddWithValue("@TeamID", staffId);
                    cmd.Parameters.AddWithValue("@CompID", complaintId);
                    con.Open();
                    if (cmd.ExecuteNonQuery() > 0)
                    {
                        if (!string.IsNullOrEmpty(adminComment))
                        {
                            string commentQuery = "UPDATE tbl_Complaints SET Description = Description + @AdminNote WHERE ComplaintID = @CompID";
                            using (SqlCommand cmdNote = new SqlCommand(commentQuery, con))
                            {
                                cmdNote.Parameters.AddWithValue("@AdminNote", " \n\n[Dept Instruction: " + adminComment + "]");
                                cmdNote.Parameters.AddWithValue("@CompID", complaintId);
                                cmdNote.ExecuteNonQuery();
                            }
                        }

                        string cleanStaffName = selectedText.Replace("[Available] ", "").Replace("[Busy] ", "");

                        // 🔥 Fire Dual Email Notification
                        SendEmailNotification(Convert.ToInt32(complaintId), "Assigned", cleanStaffName, adminComment);

                        ShowToast("Task assigned successfully!", "success");
                        ScriptManager.RegisterStartupScript(this, GetType(), "CloseAssign", "closeAssignModal();", true);
                        txtAdminComment.Text = "";
                        ddlStaff.SelectedIndex = 0;
                        BindComplaints(); LoadDashboardStats(); BindStaffDropdown();
                    }
                }
            }
        }
        catch { ShowToast("System Error", "error"); }
    }

    protected void btnConfirmResolve_Click(object sender, EventArgs e)
    {
        string complaintId = hfResolveComplaintId.Value;
        string resolveRemark = txtResolveRemark.Text.Trim();

        if (string.IsNullOrEmpty(complaintId) || string.IsNullOrEmpty(resolveRemark))
        {
            ShowToast("Action remark required.", "error");
            ScriptManager.RegisterStartupScript(this, GetType(), "ReopenRes", "document.getElementById('resolveModal').classList.remove('hidden'); document.getElementById('resolveModal').classList.add('flex');", true);
            return;
        }

        try
        {
            using (SqlConnection con = new SqlConnection(connString))
            {
                string query = "UPDATE tbl_Complaints SET Status = 'Resolved', ResolvedAt = GETDATE() WHERE ComplaintID = @CompID";
                using (SqlCommand cmd = new SqlCommand(query, con))
                {
                    cmd.Parameters.AddWithValue("@CompID", complaintId);
                    con.Open();
                    if (cmd.ExecuteNonQuery() > 0)
                    {
                        string commentQuery = "UPDATE tbl_Complaints SET Description = Description + @ResNote WHERE ComplaintID = @CompID";
                        using (SqlCommand cmdNote = new SqlCommand(commentQuery, con))
                        {
                            cmdNote.Parameters.AddWithValue("@ResNote", " \n\n[Resolved Remark: " + resolveRemark + "]");
                            cmdNote.Parameters.AddWithValue("@CompID", complaintId);
                            cmdNote.ExecuteNonQuery();
                        }

                        // 🔥 Send Email Notification
                        SendEmailNotification(Convert.ToInt32(complaintId), "Resolved", "", resolveRemark);

                        ShowToast("Complaint Resolved!", "success");
                        ScriptManager.RegisterStartupScript(this, GetType(), "CloseRes", "closeResolveModal();", true);
                        txtResolveRemark.Text = "";
                        BindComplaints(); LoadDashboardStats(); BindStaffDropdown();
                    }
                }
            }
        }
        catch { ShowToast("System Error", "error"); }
    }

    // ==========================================================
    // 🔥 POWERFUL DUAL EMAIL SYSTEM (CITIZEN + STAFF)
    // ==========================================================
    private void SendEmailNotification(int complaintId, string actionType, string staffName, string remarks)
    {
        try
        {
            string citizenName = "", citizenEmail = "", citizenMobile = "";
            string locationName = "", lat = "", lng = "", description = "";
            string staffEmail = "";

            using (SqlConnection con = new SqlConnection(connString))
            {
                string query = @"SELECT u.FullName AS CitizenName, u.Email AS CitizenEmail, u.MobileNo AS CitizenMobile, 
                                        c.LocationName, c.Latitude, c.Longitude, c.Description, 
                                        s.Email AS StaffEmail 
                                 FROM tbl_Complaints c 
                                 INNER JOIN tbl_Users u ON c.CitizenID = u.UserID 
                                 LEFT JOIN tbl_staff s ON c.AssignedTeamID = s.StaffID 
                                 WHERE c.ComplaintID = @CompID";

                using (SqlCommand cmd = new SqlCommand(query, con))
                {
                    cmd.Parameters.AddWithValue("@CompID", complaintId);
                    con.Open();
                    using (SqlDataReader dr = cmd.ExecuteReader())
                    {
                        if (dr.Read())
                        {
                            citizenName = dr["CitizenName"].ToString();
                            citizenEmail = dr["CitizenEmail"].ToString();
                            citizenMobile = dr["CitizenMobile"].ToString();
                            locationName = dr["LocationName"].ToString();
                            lat = dr["Latitude"].ToString();
                            lng = dr["Longitude"].ToString();
                            description = dr["Description"].ToString();
                            staffEmail = dr["StaffEmail"].ToString();
                        }
                    }
                }
            }

            string fullCompId = "SNT-" + complaintId;

            SmtpClient smtp = new SmtpClient("smtp.gmail.com", 587);
            smtp.EnableSsl = true;
            smtp.UseDefaultCredentials = false;
            smtp.Credentials = new NetworkCredential(senderEmail, senderAppPassword);

            // --------------------------------------------------------
            // 📧 A: SEND EMAIL TO CITIZEN
            // --------------------------------------------------------
            if (!string.IsNullOrEmpty(citizenEmail))
            {
                MailMessage citMail = new MailMessage();
                citMail.From = new MailAddress(senderEmail, "CiviCare Sanitation Dept");
                citMail.To.Add(citizenEmail);
                citMail.IsBodyHtml = true;

                if (actionType == "Assigned")
                {
                    citMail.Subject = "Team Dispatched: " + fullCompId + " | CiviCare";
                    citMail.Body = "<html><body style='font-family:Arial,sans-serif; background-color:#f8fafc; margin:0; padding:20px;'>" +
                                   "<div style='max-width:600px; margin:0 auto; background:#ffffff; border-radius:10px; overflow:hidden; box-shadow:0 4px 6px rgba(0,0,0,0.1);'>" +
                                   "<div style='background-color:#16a34a; color:#ffffff; padding:20px; text-align:center;'><h2 style='margin:0; font-size:24px;'>Team Assigned</h2></div>" +
                                   "<div style='padding:30px; color:#333333;'><h3 style='margin-top:0;'>Hello " + citizenName + ",</h3>" +
                                   "<p>A field team has been dispatched to resolve your Sanitation complaint.</p>" +
                                   "<div style='background-color:#f0fdf4; border-left:4px solid #16a34a; padding:15px; margin:20px 0;'>" +
                                   "<p style='margin:0 0 10px 0;'><strong>Complaint ID:</strong> " + fullCompId + "</p>" +
                                   "<p style='margin:0 0 10px 0;'><strong>Location:</strong> " + locationName + "</p>" +
                                   "<p style='margin:0 0 10px 0;'><strong>Assigned Team:</strong> " + staffName + "</p>" +
                                   (!string.IsNullOrEmpty(remarks) ? "<p style='margin:0;'><strong>Instruction:</strong> " + remarks + "</p>" : "") +
                                   "</div><p>Our team is on the way. Track live updates on your dashboard.</p><br/><p>Regards,<br/><strong>Sanitation Dept, CiviCare</strong></p>" +
                                   "</div></div></body></html>";
                }
                else if (actionType == "Resolved")
                {
                    citMail.Subject = "Issue Resolved: " + fullCompId + " | CiviCare";
                    citMail.Body = "<html><body style='font-family:Arial,sans-serif; background-color:#f8fafc; margin:0; padding:20px;'>" +
                                   "<div style='max-width:600px; margin:0 auto; background:#ffffff; border-radius:10px; overflow:hidden; box-shadow:0 4px 6px rgba(0,0,0,0.1);'>" +
                                   "<div style='background-color:#22c55e; color:#ffffff; padding:20px; text-align:center;'><h2 style='margin:0; font-size:24px;'>Issue Resolved</h2></div>" +
                                   "<div style='padding:30px; color:#333333;'><h3 style='margin-top:0;'>Hello " + citizenName + ",</h3>" +
                                   "<p>Your Sanitation complaint has been successfully resolved.</p>" +
                                   "<div style='background-color:#f0fdf4; border-left:4px solid #22c55e; padding:15px; margin:20px 0;'>" +
                                   "<p style='margin:0 0 10px 0;'><strong>Complaint ID:</strong> " + fullCompId + "</p>" +
                                   "<p style='margin:0 0 10px 0;'><strong>Location:</strong> " + locationName + "</p>" +
                                   "<p style='margin:0;'><strong>Action Taken:</strong> " + remarks + "</p>" +
                                   "</div><p>Thank you for helping us keep the city clean!</p><br/><p>Regards,<br/><strong>Sanitation Dept, CiviCare</strong></p>" +
                                   "</div></div></body></html>";
                }
                smtp.Send(citMail);
            }

            // --------------------------------------------------------
            // 📧 B: SEND TASK EMAIL TO FIELD STAFF
            // --------------------------------------------------------
            if (actionType == "Assigned" && !string.IsNullOrEmpty(staffEmail))
            {
                string mapLink = "https://www.google.com/maps/search/?api=1&query=" + lat + "," + lng;

                MailMessage staffMail = new MailMessage();
                staffMail.From = new MailAddress(senderEmail, "CiviCare Operations");
                staffMail.To.Add(staffEmail);
                staffMail.Subject = "NEW TASK ALERT: " + fullCompId;
                staffMail.IsBodyHtml = true;

                string staffBody = "<html><body style='font-family:Arial,sans-serif; background-color:#f8fafc; margin:0; padding:20px;'>" +
                                   "<div style='max-width:600px; margin:0 auto; background:#ffffff; border-radius:10px; overflow:hidden; box-shadow:0 4px 6px rgba(0,0,0,0.1);'>" +
                                   "<div style='background-color:#f59e0b; color:#ffffff; padding:20px; text-align:center;'><h2 style='margin:0; font-size:24px;'>New Task Assigned</h2></div>" +
                                   "<div style='padding:30px; color:#333333;'><h3 style='margin-top:0;'>Hello " + staffName + ",</h3>" +
                                   "<p>You have been assigned a new field task by the Sanitation Department.</p>" +
                                   "<div style='background-color:#fffbeb; border-left:4px solid #f59e0b; padding:15px; margin:20px 0;'>" +
                                   "<p style='margin:0 0 10px 0;'><strong>Complaint ID:</strong> " + fullCompId + "</p>" +
                                   "<p style='margin:0 0 10px 0;'><strong>Issue:</strong> " + description + "</p>" +
                                   "<p style='margin:0 0 10px 0;'><strong>Location:</strong> " + locationName + "</p>" +
                                   "<p style='margin:0 0 10px 0;'><strong>Google Maps:</strong> <a href='" + mapLink + "' style='color:#16a34a; font-weight:bold;'>Click Here for Directions</a></p>" +
                                   "<p style='margin:0 0 10px 0;'><strong>Citizen Contact:</strong> <a href='tel:" + citizenMobile + "' style='color:#2563eb; font-weight:bold;'>" + citizenMobile + "</a></p>" +
                                   (!string.IsNullOrEmpty(remarks) ? "<p style='margin:0;'><strong>Admin Instruction:</strong> " + remarks + "</p>" : "") +
                                   "</div><p>Please resolve this issue at the earliest.</p><br/><p>Regards,<br/><strong>Sanitation Dept Operations</strong></p>" +
                                   "</div></div></body></html>";

                staffMail.Body = staffBody;
                smtp.Send(staffMail);
            }
        }
        catch (Exception ex)
        {
            System.Diagnostics.Debug.WriteLine("Email Error: " + ex.Message);
        }
    }

    protected string GetPriorityHeaderCss(string priority) { return priority.ToLower() == "high" ? "bg-red-50 border-red-100 text-red-700" : (priority.ToLower() == "low" ? "bg-green-50 border-green-100 text-green-700" : "bg-orange-50 border-orange-100 text-orange-700"); }
    protected string GetPriorityIcon(string priority) { return priority.ToLower() == "high" ? "<span class=\"flex h-2.5 w-2.5 relative\"><span class=\"animate-ping absolute inline-flex h-full w-full rounded-full bg-red-400 opacity-75\"></span><span class=\"relative inline-flex rounded-full h-2.5 w-2.5 bg-red-600\"></span></span>" : (priority.ToLower() == "low" ? "<span class=\"h-2.5 w-2.5 rounded-full bg-green-500\"></span>" : "<span class=\"h-2.5 w-2.5 rounded-full bg-orange-500\"></span>"); }
    protected string GetStatusColor(string status) { return status == "Resolved" ? "bg-green-100 text-green-700 border-green-200" : (status == "Assigned" ? "bg-blue-100 text-blue-700 border-blue-200" : (status == "Rejected" ? "bg-red-100 text-red-700 border-red-200" : "bg-orange-100 text-orange-700 border-orange-200")); }
    protected string GetProximityBadge(object proximityObj) { return proximityObj != DBNull.Value && !string.IsNullOrEmpty(proximityObj.ToString()) ? "<div class=\"mt-3 inline-block bg-red-100 text-red-700 text-[10px] font-bold px-2 py-1 rounded-md border border-red-200\"><i class=\"fa-solid fa-triangle-exclamation mr-1\"></i> " + proximityObj.ToString() + "</div>" : ""; }

    private void ShowToast(string message, string type)
    {
        string safeMessage = message.Replace("'", "\\'").Replace("\r", "").Replace("\n", "");
        string script = "showToast('" + safeMessage + "', '" + type + "');";
        ScriptManager.RegisterStartupScript(this, GetType(), "ServerToast", script, true);
    }
}
