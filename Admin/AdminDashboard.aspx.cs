using System;
using System.Data;
using System.Data.SqlClient;
using System.Configuration;

public partial class AdminDashboard : System.Web.UI.Page
{
    private readonly string connString = ConfigurationManager.AppSettings["DbConnection"];

    protected void Page_Load(object sender, EventArgs e)
    {
        // Require Admin Role
        if (Session["UserID"] == null || Session["Role"] == null || Session["Role"].ToString() != "Admin")
        {
            Response.Redirect("~/Default.aspx");
        }

        if (!IsPostBack)
        {
            litAdminName.Text = Session["FullName"] != null ? Session["FullName"].ToString() : "Admin";
            LoadDashboardData();
        }
    }

    private void LoadDashboardData()
    {
        try
        {
            using (SqlConnection con = new SqlConnection(connString))
            {
                con.Open();

                // 1. Fetch Top Cards Statistics
                string statsQuery = "SELECT " +
                                    "COUNT(*) AS TotalComplaints, " +
                                    "SUM(CASE WHEN Status != 'Resolved' AND Status != 'Rejected' THEN 1 ELSE 0 END) AS PendingTotal, " +
                                    "SUM(CASE WHEN Status = 'Resolved' THEN 1 ELSE 0 END) AS ResolvedTotal, " +
                                    "SUM(CASE WHEN IsFake = 1 OR Status = 'Rejected' THEN 1 ELSE 0 END) AS FakeTotal, " +
                                    "SUM(CASE WHEN PriorityLevel = 'High' AND Status != 'Resolved' AND Status != 'Rejected' THEN 1 ELSE 0 END) AS HighPriorityPending " +
                                    "FROM tbl_Complaints";

                using (SqlCommand cmd = new SqlCommand(statsQuery, con))
                {
                    using (SqlDataReader dr = cmd.ExecuteReader())
                    {
                        if (dr.Read())
                        {
                            litTotal.Text = dr["TotalComplaints"] != DBNull.Value ? dr["TotalComplaints"].ToString() : "0";
                            litPending.Text = dr["PendingTotal"] != DBNull.Value ? dr["PendingTotal"].ToString() : "0";
                            litResolved.Text = dr["ResolvedTotal"] != DBNull.Value ? dr["ResolvedTotal"].ToString() : "0";
                            litFakeCount.Text = dr["FakeTotal"] != DBNull.Value ? dr["FakeTotal"].ToString() : "0";
                            litHighPriority.Text = dr["HighPriorityPending"] != DBNull.Value ? dr["HighPriorityPending"].ToString() : "0";
                        }
                    }
                }

                // 2. Fetch Active Staff Count
                string staffQuery = "SELECT COUNT(*) FROM tbl_Users WHERE UserRole IN ('Electric', 'Water', 'Sanitation') AND IsActive = 1";
                using (SqlCommand cmd = new SqlCommand(staffQuery, con))
                {
                    object staffCount = cmd.ExecuteScalar();
                    litStaff.Text = staffCount != null ? staffCount.ToString() : "0";
                }

                // 3. Fetch Data for Charts
                LoadChartData(con);
            }
        }
        catch { }
    }

    private void LoadChartData(SqlConnection con)
    {
        // Variables to hold counts
        int statPending = 0, statInProgress = 0, statResolved = 0;
        int deptElectric = 0, deptWater = 0, deptSanitation = 0;

        int elecRes = 0, elecPend = 0;
        int waterRes = 0, waterPend = 0;
        int saniRes = 0, saniPend = 0;

        string chartQuery = "SELECT AssignedDepartment, Status FROM tbl_Complaints WHERE Status != 'Rejected'";

        using (SqlCommand cmd = new SqlCommand(chartQuery, con))
        {
            using (SqlDataReader dr = cmd.ExecuteReader())
            {
                while (dr.Read())
                {
                    string dept = dr["AssignedDepartment"].ToString();
                    string status = dr["Status"].ToString();

                    // Status Doughnut Chart Logic
                    if (status == "Reported" || status == "AI Verified") statPending++;
                    else if (status == "Assigned") statInProgress++;
                    else if (status == "Resolved") statResolved++;

                    // Department Pie Chart Logic
                    if (dept == "Electric") deptElectric++;
                    else if (dept == "Water") deptWater++;
                    else if (dept == "Sanitation") deptSanitation++;

                    // Performance Bar Chart Logic
                    if (dept == "Electric")
                    {
                        if (status == "Resolved") elecRes++; else elecPend++;
                    }
                    else if (dept == "Water")
                    {
                        if (status == "Resolved") waterRes++; else waterPend++;
                    }
                    else if (dept == "Sanitation")
                    {
                        if (status == "Resolved") saniRes++; else saniPend++;
                    }
                }
            }
        }

        // Create simple JSON arrays string manually to avoid older Newtonsoft.Json dependency issues
        // Format: [num1, num2, num3]

        hfStatusData.Value = "[" + statPending + "," + statInProgress + "," + statResolved + "]";
        hfCategoryData.Value = "[" + deptElectric + "," + deptWater + "," + deptSanitation + "]";

        hfPerformanceResolved.Value = "[" + elecRes + "," + waterRes + "," + saniRes + "]";
        hfPerformancePending.Value = "[" + elecPend + "," + waterPend + "," + saniPend + "]";
    }
}