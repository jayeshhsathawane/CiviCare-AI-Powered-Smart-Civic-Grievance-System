using System;
using System.Data;
using System.Data.SqlClient;
using System.Configuration;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Net;
using System.Net.Mail;
using System.Collections.Generic;

public partial class MaintenanceSchedule : System.Web.UI.Page
{
    private readonly string connString = ConfigurationManager.AppSettings["DbConnection"];

    // Email Credentials
    private readonly string senderEmail = "jayeshrsathawane123@gmail.com";
    private readonly string senderAppPassword = "rewu zgww qzoa utkq";

    protected void Page_Load(object sender, EventArgs e)
    {
        // 1. Security Check
        if (Session["UserID"] == null || Session["Role"] == null || Session["Role"].ToString() != "Electric")
        {
            Response.Redirect("~/SystemLogin.aspx");
        }

        if (!IsPostBack)
        {
            BindStaffDropdown();
            BindScheduleGrid();
        }
    }

    // =======================================================
    // STEP 1: FETCH ONLY ACTIVE & AVAILABLE FIELD STAFF
    // =======================================================
    private void BindStaffDropdown()
    {
        try
        {
            using (SqlConnection con = new SqlConnection(connString))
            {
                // Select Electric staff who are Active and currently NOT busy
                string query = @"SELECT StaffID, FullName, Email 
                                 FROM tbl_staff 
                                 WHERE Department = 'Electric' AND IsActive = 1 
                                 AND NOT EXISTS (SELECT 1 FROM tbl_Complaints c WHERE c.AssignedTeamID = tbl_staff.StaffID AND c.Status = 'Assigned')";

                using (SqlCommand cmd = new SqlCommand(query, con))
                {
                    using (SqlDataAdapter sda = new SqlDataAdapter(cmd))
                    {
                        DataTable dt = new DataTable();
                        sda.Fill(dt);

                        ddlStaff.Items.Clear();
                        ddlStaff.Items.Add(new ListItem("-- Select Available Staff --", ""));

                        foreach (DataRow row in dt.Rows)
                        {
                            // We store StaffID and Email separated by '|' in the Value property to use it during email sending
                            string valueStr = row["StaffID"].ToString() + "|" + row["Email"].ToString() + "|" + row["FullName"].ToString();
                            ddlStaff.Items.Add(new ListItem(row["FullName"].ToString(), valueStr));
                        }
                    }
                }
            }
        }
        catch { }
    }

    // =======================================================
    // STEP 2: LOAD SCHEDULES INTO GRID
    // =======================================================
    private void BindScheduleGrid()
    {
        try
        {
            using (SqlConnection con = new SqlConnection(connString))
            {
                string query = "SELECT ScheduleID, MaintenanceDate, StartTime, EndTime, AffectedArea, Purpose, AssignedTeam, Status " +
                               "FROM tbl_MaintenanceSchedule ORDER BY MaintenanceDate DESC, ScheduleID DESC";

                using (SqlCommand cmd = new SqlCommand(query, con))
                {
                    using (SqlDataAdapter sda = new SqlDataAdapter(cmd))
                    {
                        DataTable dt = new DataTable();
                        sda.Fill(dt);

                        if (dt.Rows.Count > 0)
                        {
                            rptSchedules.DataSource = dt;
                            rptSchedules.DataBind();
                            trNoData.Visible = false;
                        }
                        else
                        {
                            rptSchedules.DataSource = null;
                            rptSchedules.DataBind();
                            trNoData.Visible = true;
                        }
                    }
                }
            }
        }
        catch { }
    }

    // =======================================================
    // STEP 3: ADD NEW SCHEDULE & FIRE DUAL EMAILS
    // =======================================================
    protected void btnSaveSchedule_Click(object sender, EventArgs e)
    {
        string date = txtDate.Text.Trim();
        string start = txtStart.Text.Trim();
        string end = txtEnd.Text.Trim();
        string area = txtArea.Text.Trim();
        string purpose = txtPurpose.Text.Trim();

        string[] staffData = ddlStaff.SelectedValue.Split('|');
        if (staffData.Length != 3)
        {
            ShowToast("Please select a valid team.", "error");
            ScriptManager.RegisterStartupScript(this, GetType(), "reopen", "openScheduleModal();", true);
            return;
        }

        string staffId = staffData[0];
        string staffEmail = staffData[1];
        string staffName = staffData[2];

        try
        {
            using (SqlConnection con = new SqlConnection(connString))
            {
                string query = "INSERT INTO tbl_MaintenanceSchedule (MaintenanceDate, StartTime, EndTime, AffectedArea, Purpose, AssignedTeam, Status) " +
                               "VALUES (@Date, @Start, @End, @Area, @Purpose, @Team, 'Scheduled')";

                using (SqlCommand cmd = new SqlCommand(query, con))
                {
                    cmd.Parameters.AddWithValue("@Date", date);
                    cmd.Parameters.AddWithValue("@Start", start);
                    cmd.Parameters.AddWithValue("@End", end);
                    cmd.Parameters.AddWithValue("@Area", area);
                    cmd.Parameters.AddWithValue("@Purpose", purpose);
                    cmd.Parameters.AddWithValue("@Team", staffName);

                    con.Open();
                    if (cmd.ExecuteNonQuery() > 0)
                    {
                        // 🔥 1. Broadcast Email to ALL Citizens
                        BroadcastEmailToCitizens(date, start, end, area, purpose);

                        // 🔥 2. Send Task Assignment Email to the specific Field Staff
                        SendTaskEmailToStaff(staffEmail, staffName, date, start, end, area, purpose);

                        ShowToast("Schedule saved & Email Alerts broadcasted!", "success");
                        ScriptManager.RegisterStartupScript(this, GetType(), "close", "closeScheduleModal();", true);
                        
                        // Clear Form
                        txtDate.Text = ""; txtStart.Text = ""; txtEnd.Text = ""; txtArea.Text = ""; txtPurpose.Text = ""; ddlStaff.SelectedIndex = 0;
                        
                        BindScheduleGrid();
                    }
                }
            }
        }
        catch (Exception ex)
        {
            ShowToast("DB Error: " + ex.Message.Replace("'", ""), "error");
        }
    }

    // =======================================================
    // STEP 4: MARK MAINTENANCE AS COMPLETED
    // =======================================================
    protected void rptSchedules_ItemCommand(object source, RepeaterCommandEventArgs e)
    {
        if (e.CommandName == "MarkComplete")
        {
            string scheduleId = e.CommandArgument.ToString();
            try
            {
                using (SqlConnection con = new SqlConnection(connString))
                {
                    string query = "UPDATE tbl_MaintenanceSchedule SET Status = 'Completed' WHERE ScheduleID = @SID";
                    using (SqlCommand cmd = new SqlCommand(query, con))
                    {
                        cmd.Parameters.AddWithValue("@SID", scheduleId);
                        con.Open();
                        if (cmd.ExecuteNonQuery() > 0)
                        {
                            ShowToast("Maintenance marked as Completed!", "success");
                            BindScheduleGrid();
                        }
                    }
                }
            }
            catch { ShowToast("System Error", "error"); }
        }
    }

    // =======================================================
    // 🔥 EMAIL NOTIFICATION MODULES
    // =======================================================
    
    // A. Broadcast to All Citizens
    private void BroadcastEmailToCitizens(string date, string start, string end, string area, string purpose)
    {
        try
        {
            List<string> citizenEmails = new List<string>();

            // Fetch all active citizens
            using (SqlConnection con = new SqlConnection(connString))
            {
                string query = "SELECT Email FROM tbl_Users WHERE UserRole = 'Citizen' AND IsActive = 1";
                using (SqlCommand cmd = new SqlCommand(query, con))
                {
                    con.Open();
                    using (SqlDataReader dr = cmd.ExecuteReader())
                    {
                        while (dr.Read())
                        {
                            citizenEmails.Add(dr["Email"].ToString());
                        }
                    }
                }
            }

            if (citizenEmails.Count == 0) return;

            string formattedDate = Convert.ToDateTime(date).ToString("dd MMMM yyyy");

            SmtpClient smtp = new SmtpClient("smtp.gmail.com", 587);
            smtp.EnableSsl = true;
            smtp.UseDefaultCredentials = false;
            smtp.Credentials = new NetworkCredential(senderEmail, senderAppPassword);

            MailMessage mail = new MailMessage();
            mail.From = new MailAddress(senderEmail, "CiviCare Alerts");
            
            // Add all citizens in BCC to protect privacy
            foreach (string email in citizenEmails)
            {
                mail.Bcc.Add(email);
            }

            mail.Subject = "ALERT: Planned Power Outage in Your Area | CiviCare";
            mail.IsBodyHtml = true;

            string bodyHtml = "<html><body style='font-family:Arial,sans-serif; background-color:#f8fafc; padding:20px;'>" +
                              "<div style='max-width:600px; margin:0 auto; background:#ffffff; border-radius:10px; overflow:hidden; box-shadow:0 4px 6px rgba(0,0,0,0.1);'>" +
                              "<div style='background-color:#ea580c; color:#ffffff; padding:20px; text-align:center;'><h2 style='margin:0; font-size:22px;'><span style='font-size:24px;'>⚠️</span> Power Outage Alert</h2></div>" +
                              "<div style='padding:30px; color:#333333;'>" +
                              "<p>Dear Citizen,</p>" +
                              "<p>This is to inform you that there will be a planned power outage for essential maintenance in your city.</p>" +
                              "<div style='background-color:#fff7ed; border-left:4px solid #ea580c; padding:15px; margin:20px 0;'>" +
                              "<p style='margin:0 0 10px 0;'><strong>Affected Area:</strong> " + area + "</p>" +
                              "<p style='margin:0 0 10px 0;'><strong>Date:</strong> " + formattedDate + "</p>" +
                              "<p style='margin:0 0 10px 0;'><strong>Time:</strong> " + start + " to " + end + "</p>" +
                              "<p style='margin:0;'><strong>Purpose:</strong> " + purpose + "</p>" +
                              "</div><p>We apologize for the inconvenience. Our team will work to restore services as soon as possible.</p><br/><p>Regards,<br/><strong>Electric Dept, CiviCare</strong></p>" +
                              "</div></div></body></html>";

            mail.Body = bodyHtml;
            smtp.Send(mail);
        }
        catch (Exception ex)
        {
            System.Diagnostics.Debug.WriteLine("Broadcast Email Error: " + ex.Message);
        }
    }

    // B. Direct Assignment to Field Staff
    private void SendTaskEmailToStaff(string staffEmail, string staffName, string date, string start, string end, string area, string purpose)
    {
        try
        {
            string formattedDate = Convert.ToDateTime(date).ToString("dd MMMM yyyy");

            SmtpClient smtp = new SmtpClient("smtp.gmail.com", 587);
            smtp.EnableSsl = true;
            smtp.UseDefaultCredentials = false;
            smtp.Credentials = new NetworkCredential(senderEmail, senderAppPassword);

            MailMessage mail = new MailMessage();
            mail.From = new MailAddress(senderEmail, "Electric Dept Operations");
            mail.To.Add(staffEmail);

            mail.Subject = "New Maintenance Task Assigned | CiviCare";
            mail.IsBodyHtml = true;

            string bodyHtml = "<html><body style='font-family:Arial,sans-serif; background-color:#f8fafc; padding:20px;'>" +
                              "<div style='max-width:600px; margin:0 auto; background:#ffffff; border-radius:10px; overflow:hidden; box-shadow:0 4px 6px rgba(0,0,0,0.1);'>" +
                              "<div style='background-color:#2563eb; color:#ffffff; padding:20px; text-align:center;'><h2 style='margin:0; font-size:22px;'>Maintenance Task Assigned</h2></div>" +
                              "<div style='padding:30px; color:#333333;'>" +
                              "<p>Hello <strong>" + staffName + "</strong>,</p>" +
                              "<p>You have been assigned to lead a scheduled maintenance operation.</p>" +
                              "<div style='background-color:#eff6ff; border-left:4px solid #2563eb; padding:15px; margin:20px 0;'>" +
                              "<p style='margin:0 0 10px 0;'><strong>Task Location:</strong> " + area + "</p>" +
                              "<p style='margin:0 0 10px 0;'><strong>Scheduled Date:</strong> " + formattedDate + "</p>" +
                              "<p style='margin:0 0 10px 0;'><strong>Time Window:</strong> " + start + " to " + end + "</p>" +
                              "<p style='margin:0;'><strong>Work Purpose:</strong> " + purpose + "</p>" +
                              "</div><p>Ensure that all safety protocols are followed. Mark the task as completed in the system once finished.</p><br/><p>Regards,<br/><strong>Operations Manager</strong></p>" +
                              "</div></div></body></html>";

            mail.Body = bodyHtml;
            smtp.Send(mail);
        }
        catch (Exception ex)
        {
            System.Diagnostics.Debug.WriteLine("Staff Email Error: " + ex.Message);
        }
    }

    private void ShowToast(string message, string type)
    {
        string safeMessage = message.Replace("'", "\\'").Replace("\r", "").Replace("\n", "");
        string script = "showToast('" + safeMessage + "', '" + type + "');";
        ScriptManager.RegisterStartupScript(this, GetType(), "ServerToast", script, true);
    }
}