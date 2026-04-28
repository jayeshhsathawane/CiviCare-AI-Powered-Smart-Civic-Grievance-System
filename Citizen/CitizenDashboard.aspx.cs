using System;
using System.Data;
using System.Data.SqlClient;
using System.Configuration;
using System.Web.UI;

public partial class CitizenDashboard : System.Web.UI.Page
{
    private readonly string connString = ConfigurationManager.AppSettings["DbConnection"];

    protected void Page_Load(object sender, EventArgs e)
    {
        if (Session["UserID"] == null || Session["Role"] == null || Session["Role"].ToString() != "Citizen")
        {
            Response.Redirect("~/Default.aspx");
        }

        if (!IsPostBack)
        {
            litUserName.Text = Session["FullName"].ToString();
            LoadDashboardStats();
            BindActiveComplaints();
        }
    }

    private void LoadDashboardStats()
    {
        try
        {
            int citizenId = Convert.ToInt32(Session["UserID"]);
            using (SqlConnection con = new SqlConnection(connString))
            {
                // Query counts Total Reported, Active/In-Progress, and Resolved
                string query = "SELECT " +
                               "COUNT(ComplaintID) AS TotalReported, " +
                               "SUM(CASE WHEN Status != 'Resolved' AND Status != 'Rejected' THEN 1 ELSE 0 END) AS InProgressCount, " +
                               "SUM(CASE WHEN Status = 'Resolved' THEN 1 ELSE 0 END) AS ResolvedCount " +
                               "FROM tbl_Complaints WHERE CitizenID = @CitizenID AND Status != 'Rejected'";

                using (SqlCommand cmd = new SqlCommand(query, con))
                {
                    cmd.Parameters.AddWithValue("@CitizenID", citizenId);
                    con.Open();
                    using (SqlDataReader dr = cmd.ExecuteReader())
                    {
                        if (dr.Read())
                        {
                            litTotal.Text = dr["TotalReported"] != DBNull.Value ? dr["TotalReported"].ToString() : "0";
                            litProgress.Text = dr["InProgressCount"] != DBNull.Value ? dr["InProgressCount"].ToString() : "0";
                            litResolved.Text = dr["ResolvedCount"] != DBNull.Value ? dr["ResolvedCount"].ToString() : "0";
                        }
                    }
                }
            }
        }
        catch { }
    }

    private void BindActiveComplaints()
    {
        try
        {
            int citizenId = Convert.ToInt32(Session["UserID"]);
            using (SqlConnection con = new SqlConnection(connString))
            {
                // Fetch only complaints that are NOT Resolved or Rejected
                string query = "SELECT ComplaintID, AssignedDepartment, UserDepartment, CreatedAt, LocationName, Status, Description " +
                               "FROM tbl_Complaints " +
                               "WHERE CitizenID = @CitizenID AND Status != 'Resolved' AND Status != 'Rejected' " +
                               "ORDER BY CreatedAt DESC";

                using (SqlCommand cmd = new SqlCommand(query, con))
                {
                    cmd.Parameters.AddWithValue("@CitizenID", citizenId);
                    using (SqlDataAdapter sda = new SqlDataAdapter(cmd))
                    {
                        DataTable dt = new DataTable();
                        sda.Fill(dt);

                        if (dt.Rows.Count > 0)
                        {
                            rptActiveComplaints.DataSource = dt;
                            rptActiveComplaints.DataBind();
                            noDataPanel.Visible = false;
                        }
                        else
                        {
                            rptActiveComplaints.DataSource = null;
                            rptActiveComplaints.DataBind();
                            noDataPanel.Visible = true;
                        }
                    }
                }
            }
        }
        catch { }
    }

    // ==========================================================
    // 🎨 PROFESSIONAL STEPPER UI LOGIC 
    // ==========================================================

    private int GetStatusLevel(string status)
    {
        if (status == "Reported") return 1;
        if (status == "AI Verified") return 2;
        if (status == "Assigned") return 3;
        if (status == "Resolved") return 4;
        return 1;
    }

    protected string GetProgressBarWidth(string status)
    {
        int level = GetStatusLevel(status);
        if (level == 1) return "0%";
        if (level == 2) return "33%";
        if (level == 3) return "66%";
        if (level == 4) return "100%";
        return "0%";
    }

    protected string GetStepCircleClass(string status, int stepIndex)
    {
        int currentLevel = GetStatusLevel(status);

        if (stepIndex < currentLevel)
            return "step-circle-completed"; // Past steps (Blue + Checkmark)

        if (stepIndex == currentLevel)
            return "step-circle-current";   // Current step (Indigo + Pulse effect)

        return "step-circle-inactive";      // Future steps (Gray)
    }

    protected string GetStepIcon(string status, int stepIndex)
    {
        int currentLevel = GetStatusLevel(status);

        // If step is already completed, show a checkmark
        if (stepIndex < currentLevel)
        {
            return "<i class='fa-solid fa-check'></i>";
        }

        // If step is current or future, show its specific icon
        if (stepIndex == 1) return "<i class='fa-solid fa-clipboard-list'></i>";
        if (stepIndex == 2) return "<i class='fa-solid fa-robot'></i>";
        if (stepIndex == 3) return "<i class='fa-solid fa-truck-fast'></i>";
        if (stepIndex == 4) return "<i class='fa-solid fa-flag-checkered'></i>";

        return "<i class='fa-solid fa-circle'></i>";
    }

    protected string GetStepTextClass(string status, int stepIndex)
    {
        int currentLevel = GetStatusLevel(status);

        if (stepIndex < currentLevel) return "step-text-active";
        if (stepIndex == currentLevel) return "step-text-current";

        return "step-text-inactive";
    }

    protected string GetLatestUpdate(string status, string description)
    {
        if (status == "Assigned")
        {
            // Check if department left an instruction
            int idx = description.LastIndexOf("[Dept Instruction:");
            if (idx != -1)
            {
                int endIdx = description.IndexOf("]", idx);
                if (endIdx != -1)
                {
                    string note = description.Substring(idx + 18, endIdx - idx - 18);
                    return "Maintenance Team dispatched! Officer Note: " + note;
                }
            }
            return "A maintenance team has been assigned and dispatched to your location.";
        }
        else if (status == "AI Verified")
        {
            int idx = description.IndexOf("[AI Analysis:");
            if (idx != -1)
            {
                int endIdx = description.IndexOf("]", idx);
                if (endIdx != -1)
                {
                    string aiNote = description.Substring(idx + 13, endIdx - idx - 13);
                    return "AI Verification Complete. Note: " + aiNote;
                }
            }
            return "Our AI model has verified your complaint and auto-routed it to the relevant department.";
        }

        return "Your complaint has been successfully filed and securely recorded. Awaiting AI verification.";
    }

    // Department Specific Styling
    protected string GetDeptBadgeCss(string dept)
    {
        if (dept == "Electric") return "bg-orange-50 text-orange-700 border-orange-200";
        if (dept == "Water") return "bg-blue-50 text-blue-700 border-blue-200";
        if (dept == "Sanitation") return "bg-green-50 text-green-700 border-green-200";
        return "bg-slate-50 text-slate-700 border-slate-200";
    }

    protected string GetDeptIcon(string dept)
    {
        if (dept == "Electric") return "fa-bolt text-orange-500";
        if (dept == "Water") return "fa-faucet-drip text-blue-500";
        if (dept == "Sanitation") return "fa-trash-can text-green-500";
        return "fa-folder";
    }
}