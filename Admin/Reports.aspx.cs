using System;
using System.Data;
using System.Data.SqlClient;
using System.Configuration;
using System.Web.UI;
using System.Text;
using System.Collections.Generic;

public partial class Reports : System.Web.UI.Page
{
    private readonly string connString = ConfigurationManager.AppSettings["DbConnection"];

    protected void Page_Load(object sender, EventArgs e)
    {
        if (Session["UserID"] == null || Session["Role"] == null || Session["Role"].ToString() != "Admin")
        {
            Response.Redirect("~/Default.aspx");
        }

        if (!IsPostBack)
        {
            litAdminName.Text = Session["FullName"] != null ? Session["FullName"].ToString() : "Admin";
            BindReportData(); // Load all data initially
        }
    }

    private void BindReportData()
    {
        try
        {
            string deptFilter = ddlDeptFilter.SelectedValue;
            DateTime? startDate = null;
            DateTime? endDate = null;

            DateTime sDate;
            if (DateTime.TryParse(txtFromDate.Text, out sDate)) startDate = sDate;

            DateTime eDate;
            if (DateTime.TryParse(txtToDate.Text, out eDate)) endDate = eDate;

            using (SqlConnection con = new SqlConnection(connString))
            {
                string baseQuery = "SELECT ComplaintID, AssignedDepartment, PriorityLevel, Status, CreatedAt, ResolvedAt FROM tbl_Complaints WHERE Status != 'Rejected' ";

                if (deptFilter != "All")
                {
                    baseQuery += "AND AssignedDepartment = @Dept ";
                }
                if (startDate.HasValue)
                {
                    baseQuery += "AND CreatedAt >= @StartDate ";
                }
                if (endDate.HasValue)
                {
                    baseQuery += "AND CreatedAt <= @EndDate ";
                }

                baseQuery += "ORDER BY CreatedAt DESC";

                using (SqlCommand cmd = new SqlCommand(baseQuery, con))
                {
                    if (deptFilter != "All") cmd.Parameters.AddWithValue("@Dept", deptFilter);
                    if (startDate.HasValue) cmd.Parameters.AddWithValue("@StartDate", startDate.Value.Date);
                    if (endDate.HasValue) cmd.Parameters.AddWithValue("@EndDate", endDate.Value.Date.AddDays(1).AddSeconds(-1));

                    using (SqlDataAdapter sda = new SqlDataAdapter(cmd))
                    {
                        DataTable dt = new DataTable();
                        sda.Fill(dt);

                        // 1. Bind Table
                        if (dt.Rows.Count > 0)
                        {
                            rptDetailedLogs.DataSource = dt;
                            rptDetailedLogs.DataBind();
                            trNoData.Visible = false;
                        }
                        else
                        {
                            rptDetailedLogs.DataSource = null;
                            rptDetailedLogs.DataBind();
                            trNoData.Visible = true;
                        }

                        // 2. Summary Statistics
                        litTotalRecords.Text = dt.Rows.Count.ToString("N0");
                        litAvgResolution.Text = CalculateAverageResolutionTime(dt) + " Hrs";

                        string filterLbl = deptFilter == "All" ? "All Departments" : deptFilter + " Dept";
                        if (startDate.HasValue && endDate.HasValue) filterLbl += " (" + startDate.Value.ToString("dd MMM") + " - " + endDate.Value.ToString("dd MMM") + ")";
                        litFilterLabel.Text = filterLbl;

                        // 3. Generate Chart Data (Last 7 Days)
                        GenerateChartData(con, deptFilter);
                    }
                }
            }
        }
        catch (Exception ex)
        {
            ShowToast("Error loading report: " + ex.Message.Replace("'", ""), "error");
        }
    }

    private string CalculateAverageResolutionTime(DataTable dt)
    {
        double totalHours = 0;
        int resolvedCount = 0;

        foreach (DataRow row in dt.Rows)
        {
            if (row["Status"].ToString() == "Resolved" && row["ResolvedAt"] != DBNull.Value)
            {
                DateTime created = Convert.ToDateTime(row["CreatedAt"]);
                DateTime resolved = Convert.ToDateTime(row["ResolvedAt"]);
                totalHours += (resolved - created).TotalHours;
                resolvedCount++;
            }
        }

        if (resolvedCount == 0) return "0";
        return Math.Round(totalHours / resolvedCount, 1).ToString();
    }

    private void GenerateChartData(SqlConnection con, string deptFilter)
    {
        // Simple logic for last 7 days chart
        List<string> labels = new List<string>();
        List<int> received = new List<int>();
        List<int> resolved = new List<int>();

        for (int i = 6; i >= 0; i--)
        {
            DateTime targetDate = DateTime.Now.Date.AddDays(-i);
            labels.Add("\"" + targetDate.ToString("MMM dd") + "\"");

            string recQuery = "SELECT COUNT(*) FROM tbl_Complaints WHERE CAST(CreatedAt AS DATE) = @TargetDate AND Status != 'Rejected'";
            string resQuery = "SELECT COUNT(*) FROM tbl_Complaints WHERE CAST(ResolvedAt AS DATE) = @TargetDate AND Status = 'Resolved'";

            if (deptFilter != "All")
            {
                recQuery += " AND AssignedDepartment = '" + deptFilter + "'";
                resQuery += " AND AssignedDepartment = '" + deptFilter + "'";
            }

            using (SqlCommand cmdRec = new SqlCommand(recQuery, con))
            {
                cmdRec.Parameters.AddWithValue("@TargetDate", targetDate);
                if (con.State == ConnectionState.Closed) con.Open();
                received.Add(Convert.ToInt32(cmdRec.ExecuteScalar()));
            }

            using (SqlCommand cmdRes = new SqlCommand(resQuery, con))
            {
                cmdRes.Parameters.AddWithValue("@TargetDate", targetDate);
                resolved.Add(Convert.ToInt32(cmdRes.ExecuteScalar()));
            }
        }

        // Set Hidden Fields as JSON Arrays
        hfChartLabels.Value = "[" + string.Join(",", labels) + "]";
        hfChartReceived.Value = "[" + string.Join(",", received) + "]";
        hfChartResolved.Value = "[" + string.Join(",", resolved) + "]";
    }

    protected void btnFilter_Click(object sender, EventArgs e)
    {
        DateTime? startDate = null;
        DateTime? endDate = null;

        DateTime sDate;
        if (DateTime.TryParse(txtFromDate.Text, out sDate)) startDate = sDate;

        DateTime eDate;
        if (DateTime.TryParse(txtToDate.Text, out eDate)) endDate = eDate;

        if (startDate.HasValue && endDate.HasValue && startDate > endDate)
        {
            ShowToast("Start Date cannot be greater than End Date.", "error");
            return;
        }

        BindReportData();
    }

    protected void btnClear_Click(object sender, EventArgs e)
    {
        txtFromDate.Text = "";
        txtToDate.Text = "";
        ddlDeptFilter.SelectedIndex = 0;
        BindReportData();
    }

    // =======================================================
    // EXPORT TO CSV FEATURE
    // =======================================================
    protected void btnExportCSV_Click(object sender, EventArgs e)
    {
        try
        {
            string deptFilter = ddlDeptFilter.SelectedValue;
            DateTime? startDate = null;
            DateTime? endDate = null;

            DateTime sDate;
            if (DateTime.TryParse(txtFromDate.Text, out sDate)) startDate = sDate;

            DateTime eDate;
            if (DateTime.TryParse(txtToDate.Text, out eDate)) endDate = eDate;

            using (SqlConnection con = new SqlConnection(connString))
            {
                string baseQuery = "SELECT ComplaintID, AssignedDepartment, UserDepartment, LocationName, PriorityLevel, Status, CreatedAt, ResolvedAt FROM tbl_Complaints WHERE Status != 'Rejected' ";

                if (deptFilter != "All") baseQuery += "AND AssignedDepartment = @Dept ";
                if (startDate.HasValue) baseQuery += "AND CreatedAt >= @StartDate ";
                if (endDate.HasValue) baseQuery += "AND CreatedAt <= @EndDate ";

                baseQuery += "ORDER BY CreatedAt DESC";

                using (SqlCommand cmd = new SqlCommand(baseQuery, con))
                {
                    if (deptFilter != "All") cmd.Parameters.AddWithValue("@Dept", deptFilter);
                    if (startDate.HasValue) cmd.Parameters.AddWithValue("@StartDate", startDate.Value.Date);
                    if (endDate.HasValue) cmd.Parameters.AddWithValue("@EndDate", endDate.Value.Date.AddDays(1).AddSeconds(-1));

                    using (SqlDataAdapter sda = new SqlDataAdapter(cmd))
                    {
                        DataTable dt = new DataTable();
                        sda.Fill(dt);

                        if (dt.Rows.Count > 0)
                        {
                            StringBuilder sb = new StringBuilder();
                            // Headers
                            sb.AppendLine("Complaint ID,Department,Issue Type,Location,Priority,Status,Filed On,Resolved On,Time Taken(Hrs)");

                            foreach (DataRow row in dt.Rows)
                            {
                                string compId = "CMP-" + row["ComplaintID"].ToString();
                                string dept = "\"" + row["AssignedDepartment"].ToString() + "\"";
                                string issue = "\"" + row["UserDepartment"].ToString() + "\"";
                                string loc = "\"" + row["LocationName"].ToString().Replace("\"", "\"\"") + "\"";
                                string pri = row["PriorityLevel"].ToString();
                                string status = row["Status"].ToString();
                                string filedOn = Convert.ToDateTime(row["CreatedAt"]).ToString("yyyy-MM-dd HH:mm");

                                string resOn = "Pending";
                                string timeTaken = "-";

                                if (status == "Resolved" && row["ResolvedAt"] != DBNull.Value)
                                {
                                    DateTime created = Convert.ToDateTime(row["CreatedAt"]);
                                    DateTime resolved = Convert.ToDateTime(row["ResolvedAt"]);
                                    resOn = resolved.ToString("yyyy-MM-dd HH:mm");
                                    timeTaken = Math.Round((resolved - created).TotalHours, 1).ToString();
                                }

                                sb.AppendLine(compId + "," + dept + "," + issue + "," + loc + "," + pri + "," + status + "," + filedOn + "," + resOn + "," + timeTaken);
                            }

                            Response.Clear();
                            Response.Buffer = true;
                            Response.AddHeader("content-disposition", "attachment;filename=CiviCare_Report_" + DateTime.Now.ToString("yyyyMMdd") + ".csv");
                            Response.Charset = "";
                            Response.ContentType = "application/text";
                            Response.Output.Write(sb.ToString());
                            Response.Flush();
                            Response.End();
                        }
                        else
                        {
                            ShowToast("No data available to download.", "error");
                        }
                    }
                }
            }
        }
        catch (Exception ex)
        {
            if (!(ex is System.Threading.ThreadAbortException)) // Ignore Response.End() exception
            {
                ShowToast("Export Failed.", "error");
            }
        }
    }

    // =======================================================
    // UI HELPERS
    // =======================================================

    protected string CalculateTimeTaken(object startObj, object endObj)
    {
        if (startObj == DBNull.Value || endObj == DBNull.Value) return "-";
        DateTime start = Convert.ToDateTime(startObj);
        DateTime end = Convert.ToDateTime(endObj);
        TimeSpan ts = end - start;
        if (ts.TotalDays >= 1) return (int)ts.TotalDays + "d " + ts.Hours + "h";
        if (ts.TotalHours >= 1) return (int)ts.TotalHours + "h " + ts.Minutes + "m";
        return (int)ts.TotalMinutes + "m";
    }

    protected string GetDeptIcon(string dept)
    {
        if (dept == "Electric") return "fa-bolt text-orange-500";
        if (dept == "Water") return "fa-faucet-drip text-blue-500";
        if (dept == "Sanitation") return "fa-trash-can text-green-500";
        return "fa-folder";
    }

    protected string GetPriorityCss(string pri)
    {
        if (pri == "High") return "bg-red-100 text-red-700";
        if (pri == "Low") return "bg-green-100 text-green-700";
        return "bg-orange-100 text-orange-700";
    }

    protected string GetStatusCss(string status)
    {
        if (status == "Resolved") return "bg-green-50 text-green-600 border border-green-200";
        if (status == "Assigned" || status.Contains("Progress")) return "bg-blue-50 text-blue-600 border border-blue-200";
        return "bg-slate-50 text-slate-600 border border-slate-200";
    }

    protected string GetStatusIcon(string status)
    {
        if (status == "Resolved") return "<i class=\"fa-solid fa-check\"></i>";
        if (status == "Assigned" || status.Contains("Progress")) return "<i class=\"fa-solid fa-spinner animate-spin\"></i>";
        return "<i class=\"fa-solid fa-clock\"></i>";
    }

    private void ShowToast(string message, string type)
    {
        string safeMessage = message.Replace("'", "\\'").Replace("\r", "").Replace("\n", "");
        string script = "showToast('" + safeMessage + "', '" + type + "');";
        ScriptManager.RegisterStartupScript(this, GetType(), "ServerToast", script, true);
    }
}