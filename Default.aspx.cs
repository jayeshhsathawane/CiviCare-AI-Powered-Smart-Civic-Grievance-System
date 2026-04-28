using System;
using System.Data;
using System.Data.SqlClient;
using System.Configuration;
using System.Text.RegularExpressions;
using System.Web.UI;
using System.Net;
using System.Net.Mail;

public partial class _Default : System.Web.UI.Page
{
    private readonly string connString = ConfigurationManager.AppSettings["DbConnection"];

    // Setup Gmail Credentials
    private readonly string senderEmail = "enter email";
    private readonly string senderAppPassword = "app password";

    protected void Page_Load(object sender, EventArgs e)
    {
        if (!IsPostBack)
        {
            LoadPublicAnalytics(); // Fetches Live DB Stats for the Public Modal
        }
    }

    // =======================================================
    // LOAD PUBLIC ANALYTICS LOGIC
    // =======================================================
    private void LoadPublicAnalytics()
    {
        try
        {
            using (SqlConnection con = new SqlConnection(connString))
            {
                string query = @"
                    SELECT 
                        COUNT(ComplaintID) as TotalComplaints,
                        SUM(CASE WHEN Status = 'Resolved' THEN 1 ELSE 0 END) as ResolvedComplaints,
                        SUM(CASE WHEN Status != 'Resolved' AND Status != 'Rejected' THEN 1 ELSE 0 END) as ActiveComplaints,
                        SUM(CASE WHEN AssignedDepartment = 'Water' THEN 1 ELSE 0 END) as WaterCount,
                        SUM(CASE WHEN AssignedDepartment = 'Electric' THEN 1 ELSE 0 END) as ElectricCount,
                        SUM(CASE WHEN AssignedDepartment = 'Sanitation' THEN 1 ELSE 0 END) as SanitationCount
                    FROM tbl_Complaints WHERE Status != 'Rejected'";

                using (SqlCommand cmd = new SqlCommand(query, con))
                {
                    con.Open();
                    using (SqlDataReader dr = cmd.ExecuteReader())
                    {
                        if (dr.Read())
                        {
                            litTotalComplaints.Text = dr["TotalComplaints"] != DBNull.Value ? dr["TotalComplaints"].ToString() : "0";
                            litResolvedComplaints.Text = dr["ResolvedComplaints"] != DBNull.Value ? dr["ResolvedComplaints"].ToString() : "0";
                            litActiveComplaints.Text = dr["ActiveComplaints"] != DBNull.Value ? dr["ActiveComplaints"].ToString() : "0";

                            litWaterCount.Text = dr["WaterCount"] != DBNull.Value ? dr["WaterCount"].ToString() : "0";
                            litElectricCount.Text = dr["ElectricCount"] != DBNull.Value ? dr["ElectricCount"].ToString() : "0";
                            litSanitationCount.Text = dr["SanitationCount"] != DBNull.Value ? dr["SanitationCount"].ToString() : "0";
                        }
                    }
                }
            }
        }
        catch (Exception ex)
        {
            System.Diagnostics.Debug.WriteLine("Analytics Load Error: " + ex.Message);
        }
    }

    // =======================================================
    // 1. STANDARD CITIZEN LOGIN LOGIC
    // =======================================================
    protected void btnLogin_Click(object sender, EventArgs e)
    {
        string loginId = txtLoginId.Text.Trim();
        string password = txtLoginPass.Text.Trim();
        string requestedRole = hfRole.Value;

        if (string.IsNullOrEmpty(loginId) || string.IsNullOrEmpty(password))
        {
            ShowToast("Please enter both Email and Password.", "error");
            KeepModalOpen(requestedRole, "login");
            return;
        }

        try
        {
            using (SqlConnection con = new SqlConnection(connString))
            {
                string query = "SELECT UserID, FullName, UserRole, IsActive " +
                               "FROM tbl_Users " +
                               "WHERE (Email = @LoginIdentifier OR MobileNo = @LoginIdentifier) " +
                               "AND PasswordHash = @Password";

                using (SqlCommand cmd = new SqlCommand(query, con))
                {
                    cmd.CommandType = CommandType.Text;
                    cmd.Parameters.AddWithValue("@LoginIdentifier", loginId);
                    cmd.Parameters.AddWithValue("@Password", password);

                    con.Open();
                    using (SqlDataReader dr = cmd.ExecuteReader())
                    {
                        if (dr.Read())
                        {
                            bool isActive = Convert.ToBoolean(dr["IsActive"]);

                            if (isActive)
                            {
                                string actualRole = dr["UserRole"].ToString();

                                if (!IsRoleValidForPortal(requestedRole, actualRole))
                                {
                                    ShowToast("Access Denied: Admin and Staff must use the Secure Portal.", "error");
                                    KeepModalOpen(requestedRole, "login");
                                    return;
                                }

                                Session["UserID"] = dr["UserID"].ToString();
                                Session["FullName"] = dr["FullName"].ToString();
                                Session["Role"] = actualRole;

                                RedirectBasedOnRole(actualRole);
                            }
                            else
                            {
                                ShowToast("Your account is inactive or blocked. Contact Admin.", "error");
                                KeepModalOpen(requestedRole, "login");
                            }
                        }
                        else
                        {
                            ShowToast("Invalid Credentials! Check your ID and Password.", "error");
                            KeepModalOpen(requestedRole, "login");
                        }
                    }
                }
            }
        }
        catch (Exception ex)
        {
            ShowToast("Database Error: " + ex.Message.Replace("'", "\\'"), "error");
            KeepModalOpen(requestedRole, "login");
        }
    }

    // =======================================================
    // 2. REGISTRATION (STEP 1) - SEND OTP
    // =======================================================
    protected void btnRegister_Click(object sender, EventArgs e)
    {
        string fullName = txtRegName.Text.Trim();
        string email = txtRegEmail.Text.Trim();
        string mobile = txtRegMobile.Text.Trim();
        string password = txtRegPass.Text.Trim();

        if (string.IsNullOrEmpty(fullName) || string.IsNullOrEmpty(email) || string.IsNullOrEmpty(mobile) || string.IsNullOrEmpty(password))
        {
            ShowToast("Please fill all the registration fields.", "error");
            KeepModalOpen("Citizen", "register");
            return;
        }

        if (!Regex.IsMatch(email, @"^[^@\s]+@[^@\s]+\.[^@\s]+$"))
        {
            ShowToast("Please enter a valid Email Address.", "error");
            KeepModalOpen("Citizen", "register");
            return;
        }

        if (!Regex.IsMatch(mobile, @"^\d{10}$"))
        {
            ShowToast("Mobile number must be exactly 10 digits.", "error");
            KeepModalOpen("Citizen", "register");
            return;
        }

        if (!Regex.IsMatch(password, @"^(?=.*[A-Za-z])(?=.*\d)(?=.*[@$!%*#?&])[A-Za-z\d@$!%*#?&]{6,}$"))
        {
            ShowToast("Password must be at least 6 characters, contain 1 number and 1 special character.", "error");
            KeepModalOpen("Citizen", "register");
            return;
        }

        if (IsUserExists(email, mobile))
        {
            ShowToast("Email or Mobile Number is already registered!", "error");
            KeepModalOpen("Citizen", "register");
            return;
        }

        Random random = new Random();
        string otpCode = random.Next(100000, 999999).ToString();

        SaveOTPToDatabase(email, otpCode);
        bool isSent = SendOTPEmail(email, fullName, otpCode);

        if (isSent)
        {
            Session["TempReg_Name"] = fullName;
            Session["TempReg_Email"] = email;
            Session["TempReg_Mobile"] = mobile;
            Session["TempReg_Pass"] = password;

            ShowToast("OTP sent to your email. Please verify.", "success");
            KeepModalOpen("Citizen", "otp");
        }
        else
        {
            ShowToast("Failed to send OTP email. Try again later.", "error");
            KeepModalOpen("Citizen", "register");
        }
    }

    // =======================================================
    // 3. REGISTRATION (STEP 2) - VERIFY OTP & CREATE ACCOUNT
    // =======================================================
    protected void btnVerifyOTP_Click(object sender, EventArgs e)
    {
        string enteredOTP = txtOTP.Text.Trim();
        string tempEmail = Session["TempReg_Email"] as string;
        string tempName = Session["TempReg_Name"] as string; // Needed for Welcome Email

        if (string.IsNullOrEmpty(enteredOTP) || string.IsNullOrEmpty(tempEmail))
        {
            ShowToast("Please enter the OTP.", "error");
            KeepModalOpen("Citizen", "otp");
            return;
        }

        bool isOTPValid = VerifyOTPFromDatabase(tempEmail, enteredOTP);

        if (isOTPValid)
        {
            try
            {
                using (SqlConnection con = new SqlConnection(connString))
                {
                    string query = "INSERT INTO tbl_Users (FullName, Email, MobileNo, PasswordHash, UserRole, IsActive) " +
                                   "VALUES (@FullName, @Email, @MobileNo, @PasswordHash, 'Citizen', 1)";

                    using (SqlCommand cmd = new SqlCommand(query, con))
                    {
                        cmd.Parameters.AddWithValue("@FullName", tempName);
                        cmd.Parameters.AddWithValue("@Email", tempEmail);
                        cmd.Parameters.AddWithValue("@MobileNo", Session["TempReg_Mobile"].ToString());
                        cmd.Parameters.AddWithValue("@PasswordHash", Session["TempReg_Pass"].ToString());

                        con.Open();
                        if (cmd.ExecuteNonQuery() > 0)
                        {
                            txtRegName.Text = ""; txtRegEmail.Text = ""; txtRegMobile.Text = ""; txtOTP.Text = "";

                            // 🔥 Send Welcome Email upon successful OTP registration
                            SendWelcomeEmail(tempEmail, tempName);

                            Session.Remove("TempReg_Name"); Session.Remove("TempReg_Email"); Session.Remove("TempReg_Mobile"); Session.Remove("TempReg_Pass");

                            ShowToast("Registration Successful! Please login now.", "success");
                            KeepModalOpen("Citizen", "login");
                        }
                        else
                        {
                            ShowToast("Registration failed at database.", "error");
                            KeepModalOpen("Citizen", "register");
                        }
                    }
                }
            }
            catch (Exception ex)
            {
                ShowToast("Database Error: " + ex.Message.Replace("'", ""), "error");
                KeepModalOpen("Citizen", "register");
            }
        }
        else
        {
            ShowToast("Invalid or Expired OTP.", "error");
            KeepModalOpen("Citizen", "otp");
        }
    }

    // =======================================================
    // 4. GOOGLE LOGIN/REGISTRATION LOGIC
    // =======================================================
    protected void btnGoogleSubmit_Click(object sender, EventArgs e)
    {
        string token = hfGoogleToken.Value;
        if (string.IsNullOrEmpty(token)) return;

        try
        {
            string[] parts = token.Split('.');
            if (parts.Length < 3) return;

            string payload = parts[1];
            payload = payload.Replace('-', '+').Replace('_', '/');
            switch (payload.Length % 4)
            {
                case 2: payload += "=="; break;
                case 3: payload += "="; break;
            }

            byte[] bytes = Convert.FromBase64String(payload);
            string jsonPayload = System.Text.Encoding.UTF8.GetString(bytes);

            string email = ExtractJsonValue(jsonPayload, "email");
            string name = ExtractJsonValue(jsonPayload, "name");

            if (!string.IsNullOrEmpty(email))
            {
                ProcessGoogleAuthentication(email, name);
            }
        }
        catch
        {
            ShowToast("Google Authentication Error.", "error");
            KeepModalOpen("Citizen", "login");
        }
    }

    private void ProcessGoogleAuthentication(string email, string fullName)
    {
        if (hfRole.Value != "Citizen")
        {
            ShowToast("Google Login is only available for Citizens.", "error");
            KeepModalOpen(hfRole.Value, "login");
            return;
        }

        try
        {
            using (SqlConnection con = new SqlConnection(connString))
            {
                // Check if user exists
                string checkQuery = "SELECT UserID, FullName, UserRole, IsActive FROM tbl_Users WHERE Email = @Email";
                using (SqlCommand checkCmd = new SqlCommand(checkQuery, con))
                {
                    checkCmd.Parameters.AddWithValue("@Email", email);
                    con.Open();
                    using (SqlDataReader dr = checkCmd.ExecuteReader())
                    {
                        if (dr.Read())
                        {
                            bool isActive = Convert.ToBoolean(dr["IsActive"]);
                            if (isActive)
                            {
                                string userActualRole = dr["UserRole"].ToString();
                                if (!IsRoleValidForPortal("Citizen", userActualRole))
                                {
                                    ShowToast("Access Denied: Staff/Admin must use Secure Portal.", "error");
                                    KeepModalOpen("Citizen", "login");
                                    return;
                                }

                                // Login Success
                                Session["UserID"] = dr["UserID"].ToString();
                                Session["FullName"] = dr["FullName"].ToString();
                                Session["Role"] = userActualRole;
                                RedirectBasedOnRole(userActualRole);
                            }
                            else
                            {
                                ShowToast("Your account is blocked.", "error");
                                KeepModalOpen("Citizen", "login");
                            }
                            return;
                        }
                    }
                    con.Close();
                }

                // If User doesn't exist, Auto-Register them
                string dummyMobile = "GOOG-" + Guid.NewGuid().ToString().Substring(0, 5);
                string dummyPass = "GOOGLE_OAUTH_" + Guid.NewGuid().ToString();

                string regQuery = "INSERT INTO tbl_Users (FullName, Email, MobileNo, PasswordHash, UserRole, IsActive) " +
                                  "VALUES (@FullName, @Email, @MobileNo, @PasswordHash, 'Citizen', 1); SELECT SCOPE_IDENTITY();";

                using (SqlCommand regCmd = new SqlCommand(regQuery, con))
                {
                    regCmd.Parameters.AddWithValue("@FullName", fullName);
                    regCmd.Parameters.AddWithValue("@Email", email);
                    regCmd.Parameters.AddWithValue("@MobileNo", dummyMobile);
                    regCmd.Parameters.AddWithValue("@PasswordHash", dummyPass);

                    con.Open();
                    object newId = regCmd.ExecuteScalar();
                    if (newId != null)
                    {
                        // 🔥 Send Welcome Email to the new Google User
                        SendWelcomeEmail(email, fullName);

                        Session["UserID"] = newId.ToString();
                        Session["FullName"] = fullName;
                        Session["Role"] = "Citizen";
                        RedirectBasedOnRole("Citizen");
                    }
                    else
                    {
                        ShowToast("Failed to link Google account.", "error");
                        KeepModalOpen("Citizen", "login");
                    }
                }
            }
        }
        catch
        {
            ShowToast("System Error during Google Auth.", "error");
            KeepModalOpen("Citizen", "login");
        }
    }

    private string ExtractJsonValue(string json, string key)
    {
        string searchKey = "\"" + key + "\":\"";
        int startIndex = json.IndexOf(searchKey);
        if (startIndex == -1) return "";
        startIndex += searchKey.Length;
        int endIndex = json.IndexOf("\"", startIndex);
        return json.Substring(startIndex, endIndex - startIndex);
    }


    // =======================================================
    // 5. HELPER METHODS (OTP, DB Checks, Emails)
    // =======================================================

    private bool IsUserExists(string email, string mobile)
    {
        bool exists = false;
        try
        {
            using (SqlConnection con = new SqlConnection(connString))
            {
                string query = "SELECT COUNT(1) FROM tbl_Users WHERE Email = @Email OR MobileNo = @Mobile";
                using (SqlCommand cmd = new SqlCommand(query, con))
                {
                    cmd.Parameters.AddWithValue("@Email", email);
                    cmd.Parameters.AddWithValue("@Mobile", mobile);
                    con.Open();
                    exists = Convert.ToInt32(cmd.ExecuteScalar()) > 0;
                }
            }
        }
        catch { }
        return exists;
    }

    private void SaveOTPToDatabase(string email, string otp)
    {
        try
        {
            using (SqlConnection con = new SqlConnection(connString))
            {
                string updateQ = "UPDATE tbl_OTP SET IsUsed = 1 WHERE Email = @Email";
                using (SqlCommand cmdU = new SqlCommand(updateQ, con))
                {
                    cmdU.Parameters.AddWithValue("@Email", email);
                    con.Open();
                    cmdU.ExecuteNonQuery();
                    con.Close();
                }

                string insertQ = "INSERT INTO tbl_OTP (Email, OTPCode, ExpiryTime, IsUsed) VALUES (@Email, @OTP, @Expiry, 0)";
                using (SqlCommand cmdI = new SqlCommand(insertQ, con))
                {
                    cmdI.Parameters.AddWithValue("@Email", email);
                    cmdI.Parameters.AddWithValue("@OTP", otp);
                    cmdI.Parameters.AddWithValue("@Expiry", DateTime.Now.AddMinutes(10));
                    con.Open();
                    cmdI.ExecuteNonQuery();
                }
            }
        }
        catch { }
    }

    private bool VerifyOTPFromDatabase(string email, string otp)
    {
        bool isValid = false;
        try
        {
            using (SqlConnection con = new SqlConnection(connString))
            {
                string query = "SELECT ID FROM tbl_OTP WHERE Email = @Email AND OTPCode = @OTP AND IsUsed = 0 AND ExpiryTime > GETDATE()";
                using (SqlCommand cmd = new SqlCommand(query, con))
                {
                    cmd.Parameters.AddWithValue("@Email", email);
                    cmd.Parameters.AddWithValue("@OTP", otp);
                    con.Open();
                    object result = cmd.ExecuteScalar();

                    if (result != null)
                    {
                        isValid = true;
                        string markQ = "UPDATE tbl_OTP SET IsUsed = 1 WHERE ID = @ID";
                        using (SqlCommand cmdM = new SqlCommand(markQ, con))
                        {
                            cmdM.Parameters.AddWithValue("@ID", result);
                            cmdM.ExecuteNonQuery();
                        }
                    }
                }
            }
        }
        catch { }
        return isValid;
    }

    private bool SendOTPEmail(string toEmail, string name, string otp)
    {
        try
        {
            SmtpClient smtp = new SmtpClient("smtp.gmail.com", 587) { EnableSsl = true, UseDefaultCredentials = false, Credentials = new NetworkCredential(senderEmail, senderAppPassword) };

            string bodyHtml = "<html><body style='font-family:Arial; padding:20px;'>" +
                              "<h2 style='color:#2563eb;'>CiviCare Registration OTP</h2>" +
                              "<p>Hello " + name + ",</p>" +
                              "<p>Please use the following 6-digit OTP to complete your registration. This OTP is valid for 10 minutes.</p>" +
                              "<h1 style='background:#f1f5f9; padding:10px; display:inline-block; border-radius:5px; letter-spacing:5px;'>" + otp + "</h1>" +
                              "<p>Do not share this code with anyone.</p></body></html>";

            MailMessage mail = new MailMessage(senderEmail, toEmail, "CiviCare Registration - Your OTP Code", bodyHtml) { IsBodyHtml = true };
            smtp.Send(mail);
            return true;
        }
        catch { return false; }
    }

    // 🔥 NEW FUNCTION: Welcome Email sent after successful registration
    private void SendWelcomeEmail(string toEmail, string name)
    {
        try
        {
            SmtpClient smtp = new SmtpClient("smtp.gmail.com", 587) { EnableSsl = true, UseDefaultCredentials = false, Credentials = new NetworkCredential(senderEmail, senderAppPassword) };

            string bodyHtml = "<html><body style='font-family:Arial,sans-serif; background-color:#f4f7f6; margin:0; padding:20px;'>" +
                              "<div style='max-width:600px; margin:0 auto; background:#ffffff; border-radius:10px; overflow:hidden; box-shadow:0 4px 6px rgba(0,0,0,0.1);'>" +
                              "<div style='background-color:#2563eb; color:#ffffff; padding:20px; text-align:center;'>" +
                              "<h2 style='margin:0; font-size:24px;'>Welcome to CiviCare!</h2>" +
                              "</div>" +
                              "<div style='padding:30px; color:#333333;'>" +
                              "<h3 style='margin-top:0;'>Hello " + name + ",</h3>" +
                              "<p>Your registration was successful. Welcome to the CiviCare Smart Citizen Portal!</p>" +
                              "<p>You can now easily report civic issues like broken roads, water leaks, or electrical hazards. Our AI-driven system will ensure your complaints are tracked and resolved efficiently.</p>" +
                              "<p>Thank you for helping us build a better city.</p>" +
                              "<br/><p>Regards,<br/><strong>CiviCare Admin Team</strong></p>" +
                              "</div></div></body></html>";

            MailMessage mail = new MailMessage(senderEmail, toEmail, "Welcome to CiviCare - Registration Successful", bodyHtml) { IsBodyHtml = true };

            // Note: We don't wait for this to finish or show an error if it fails, 
            // to ensure a smooth login experience.
            smtp.Send(mail);
        }
        catch
        {
            // Silent catch to not disrupt the user registration flow if email fails
            System.Diagnostics.Debug.WriteLine("Welcome Email failed to send.");
        }
    }

    private bool IsRoleValidForPortal(string requestedPortal, string userActualRole)
    {
        if (requestedPortal == "Citizen" && userActualRole == "Citizen") return true;
        return false;
    }

    private void RedirectBasedOnRole(string role)
    {
        if (role == "Citizen")
        {
            Response.Redirect("citizen/CitizenDashboard.aspx", false);
        }
        else
        {
            Response.Redirect("Default.aspx", false);
        }
    }

    private void ShowToast(string message, string type)
    {
        string safeMessage = message.Replace("'", "\\'").Replace("\r", "").Replace("\n", "");
        string script = "showToast('" + safeMessage + "', '" + type + "');";
        ScriptManager.RegisterStartupScript(this, GetType(), "ServerToast", script, true);
    }

    private void KeepModalOpen(string role, string view)
    {
        string script = "openModal('" + role + "'); toggleView('" + view + "');";
        ScriptManager.RegisterStartupScript(this, GetType(), "ReopenModal", script, true);
    }
}
