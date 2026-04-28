using System;
using System.Data;
using System.Data.SqlClient;
using System.Configuration;
using System.Web.UI;
using System.Web.UI.WebControls;

public partial class ResolvedHistory : System.Web.UI.Page
{
    private readonly string connString = ConfigurationManager.AppSettings["DbConnection"];

    protected void Page_Load(object sender, EventArgs e)
    {
        // Security Check
        if (Session["UserID"] == null || Session["Role"] == null || Session["Role"].ToString() != "Water")
        {
            Response.Redirect("~/Default.aspx");
        }

        if (!IsPostBack)
        {
            litAdminName.Text = Session["FullName"].ToString();
            BindResolvedLogs(null, null);
        }
    }

    private void BindResolvedLogs(DateTime? startDate, DateTime? endDate)
    {
        try
        {
            using (SqlConnection con = new SqlConnection(connString))
            {
                // Select only 'Resolved' complaints that belong to 'Water' Department
                string query = "SELECT c.ComplaintID, c.UserDepartment, c.Description, c.LocationName, " +
                               "c.CreatedAt, c.ResolvedAt, staff.FullName AS StaffName " +
                               "FROM tbl_Complaints c " +
                               "LEFT JOIN tbl_Users staff ON c.AssignedTeamID = staff.UserID " +
                               "WHERE c.AssignedDepartment = 'Water' AND c.Status = 'Resolved' ";

                // Apply Date Filters if selected
                if (startDate.HasValue)
                {
                    query += "AND c.ResolvedAt >= @StartDate ";
                }
                if (endDate.HasValue)
                {
                    query += "AND c.ResolvedAt <= @EndDate ";
                }

                query += "ORDER BY c.ResolvedAt DESC";

                using (SqlCommand cmd = new SqlCommand(query, con))
                {
                    if (startDate.HasValue)
                        cmd.Parameters.AddWithValue("@StartDate", startDate.Value.Date);

                    if (endDate.HasValue)
                        cmd.Parameters.AddWithValue("@EndDate", endDate.Value.Date.AddDays(1).AddSeconds(-1)); // End of the day

                    using (SqlDataAdapter sda = new SqlDataAdapter(cmd))
                    {
                        DataTable dt = new DataTable();
                        sda.Fill(dt);

                        if (dt.Rows.Count > 0)
                        {
                            rptResolvedLogs.DataSource = dt;
                            rptResolvedLogs.DataBind();
                            trNoData.Visible = false;
                        }
                        else
                        {
                            rptResolvedLogs.DataSource = null;
                            rptResolvedLogs.DataBind();
                            trNoData.Visible = true;
                        }
                    }
                }
            }
        }
        catch (Exception ex)
        {
            ShowToast("Error loading logs: " + ex.Message.Replace("'", ""), "error");
        }
    }

    protected void btnFilter_Click(object sender, EventArgs e)
    {
        DateTime? startDate = null;
        DateTime? endDate = null;

        // No inline Out declarations to support older Visual Studio
        DateTime sDate;
        if (DateTime.TryParse(txtStartDate.Text, out sDate))
        {
            startDate = sDate;
        }

        DateTime eDate;
        if (DateTime.TryParse(txtEndDate.Text, out eDate))
        {
            endDate = eDate;
        }

        if (startDate.HasValue && endDate.HasValue && startDate > endDate)
        {
            ShowToast("Start Date cannot be greater than End Date.", "error");
            return;
        }

        BindResolvedLogs(startDate, endDate);
    }

    protected void btnClear_Click(object sender, EventArgs e)
    {
        txtStartDate.Text = "";
        txtEndDate.Text = "";
        BindResolvedLogs(null, null);
    }

    // Function to calculate time taken between filing and resolving
    protected string CalculateTimeTaken(object startObj, object endObj)
    {
        if (startObj == DBNull.Value || endObj == DBNull.Value) return "-";

        DateTime start = Convert.ToDateTime(startObj);
        DateTime end = Convert.ToDateTime(endObj);
        TimeSpan ts = end - start;

        if (ts.TotalDays >= 1)
        {
            return (int)ts.TotalDays + "d " + ts.Hours + "h";
        }
        else if (ts.TotalHours >= 1)
        {
            return (int)ts.TotalHours + "h " + ts.Minutes + "m";
        }
        else
        {
            return (int)ts.TotalMinutes + "m";
        }
    }

    private void ShowToast(string message, string type)
    {
        string safeMessage = message.Replace("'", "\\'").Replace("\r", "").Replace("\n", "");
        string script = "showToast('" + safeMessage + "', '" + type + "');";
        ScriptManager.RegisterStartupScript(this, GetType(), "ServerToast", script, true);
    }
}