using System;
using System.Data;
using System.Data.SqlClient;
using System.Configuration;
using System.Web.UI.WebControls;

public partial class MyComplaints : System.Web.UI.Page
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
            litUserName.Text = Session["FullName"] != null ? Session["FullName"].ToString() : "Citizen";
            BindComplaints("All"); // Default load all
        }
    }

    // =======================================================
    // 1. DATA BINDING (Grid & Filter)
    // =======================================================
    private void BindComplaints(string filterType)
    {
        // Update Button Styles based on Active Filter
        btnFilterAll.CssClass = "px-5 py-2.5 rounded-lg text-sm font-bold transition cursor-pointer " + (filterType == "All" ? "bg-blue-600 text-white shadow-md" : "bg-slate-50 text-slate-600 hover:bg-slate-100");
        btnFilterPending.CssClass = "px-5 py-2.5 rounded-lg text-sm font-bold transition cursor-pointer " + (filterType == "Pending" ? "bg-orange-500 text-white shadow-md" : "bg-slate-50 text-slate-600 hover:bg-slate-100");
        btnFilterResolved.CssClass = "px-5 py-2.5 rounded-lg text-sm font-bold transition cursor-pointer " + (filterType == "Resolved" ? "bg-green-600 text-white shadow-md" : "bg-slate-50 text-slate-600 hover:bg-slate-100");

        try
        {
            int citizenId = Convert.ToInt32(Session["UserID"]);

            using (SqlConnection con = new SqlConnection(connString))
            {
                string query = "SELECT ComplaintID, AssignedDepartment, LocationName, Description, Status, CreatedAt, ResolvedAt " +
                               "FROM tbl_Complaints WHERE CitizenID = @CitizenID ";

                if (filterType == "Pending")
                {
                    query += "AND Status != 'Resolved' AND Status != 'Rejected' ";
                }
                else if (filterType == "Resolved")
                {
                    query += "AND (Status = 'Resolved' OR Status = 'Rejected') ";
                }

                query += "ORDER BY CreatedAt DESC";

                using (SqlCommand cmd = new SqlCommand(query, con))
                {
                    cmd.Parameters.AddWithValue("@CitizenID", citizenId);

                    using (SqlDataAdapter sda = new SqlDataAdapter(cmd))
                    {
                        DataTable dt = new DataTable();
                        sda.Fill(dt);

                        if (dt.Rows.Count > 0)
                        {
                            rptComplaints.DataSource = dt;
                            rptComplaints.DataBind();
                            divNoData.Visible = false;
                        }
                        else
                        {
                            rptComplaints.DataSource = null;
                            rptComplaints.DataBind();
                            divNoData.Visible = true;
                        }
                    }
                }
            }
        }
        catch { }
    }

    protected void btnFilterAll_Click(object sender, EventArgs e) { BindComplaints("All"); }
    protected void btnFilterPending_Click(object sender, EventArgs e) { BindComplaints("Pending"); }
    protected void btnFilterResolved_Click(object sender, EventArgs e) { BindComplaints("Resolved"); }

    // =======================================================
    // 2. MODAL LOGIC (View Details)
    // =======================================================
    protected void rptComplaints_ItemCommand(object source, RepeaterCommandEventArgs e)
    {
        if (e.CommandName == "ViewDetails")
        {
            string complaintId = e.CommandArgument.ToString();
            LoadModalData(complaintId);
        }
    }

    private void LoadModalData(string complaintId)
    {
        try
        {
            using (SqlConnection con = new SqlConnection(connString))
            {
                string query = "SELECT * FROM tbl_Complaints WHERE ComplaintID = @CompID";
                using (SqlCommand cmd = new SqlCommand(query, con))
                {
                    cmd.Parameters.AddWithValue("@CompID", complaintId);
                    con.Open();
                    using (SqlDataReader dr = cmd.ExecuteReader())
                    {
                        if (dr.Read())
                        {
                            litModalID.Text = dr["ComplaintID"].ToString();
                            imgModalProof.ImageUrl = dr["ImagePath"].ToString();
                            litModalLocation.Text = dr["LocationName"].ToString();
                            litModalDept.Text = dr["AssignedDepartment"].ToString();
                            litModalDesc.Text = dr["Description"].ToString();
                            litModalDate.Text = Convert.ToDateTime(dr["CreatedAt"]).ToString("dd MMM yyyy, hh:mm tt");

                            string status = dr["Status"].ToString();
                            string priority = dr["PriorityLevel"].ToString();

                            // Generate Status Badge
                            string badgeCss = GetBadgeCssClass(status);
                            litModalStatus.Text = "<span class='" + badgeCss + " border px-3 py-1 rounded-md text-[10px] font-bold uppercase tracking-wider'>" + status + "</span>";

                            // Generate Priority Badge
                            string priCss = priority == "High" ? "bg-red-100 text-red-700 border-red-200" : (priority == "Low" ? "bg-green-100 text-green-700 border-green-200" : "bg-orange-100 text-orange-700 border-orange-200");
                            litModalPriority.Text = "<span class='" + priCss + " border px-3 py-1 rounded-md text-[10px] font-bold uppercase tracking-wider'>" + priority + "</span>";

                            if (status == "Resolved" && dr["ResolvedAt"] != DBNull.Value)
                            {
                                divModalResolved.Visible = true;
                                litModalResolvedDate.Text = Convert.ToDateTime(dr["ResolvedAt"]).ToString("dd MMM yyyy, hh:mm tt");
                            }
                            else
                            {
                                divModalResolved.Visible = false;
                            }

                            // Show Modal
                            pnlModal.Visible = true;
                        }
                    }
                }
            }
        }
        catch { }
    }

    protected void btnCloseModal_Click(object sender, EventArgs e)
    {
        pnlModal.Visible = false;
    }

    // =======================================================
    // 3. UI HELPER METHODS FOR REPEATER
    // =======================================================

    protected string GetDeptIcon(string dept)
    {
        if (dept == "Electric") return "fa-bolt";
        if (dept == "Water") return "fa-faucet-drip";
        if (dept == "Sanitation") return "fa-trash-can";
        return "fa-folder";
    }

    protected string GetStatusIcon(string status)
    {
        status = status.ToLower();
        if (status.Contains("progress") || status.Contains("assigned")) return "<i class=\"fa-solid fa-spinner animate-spin\"></i>";
        if (status.Contains("resolved") || status.Contains("completed")) return "<i class=\"fa-solid fa-check-double\"></i>";
        if (status.Contains("reject") || status.Contains("fake")) return "<i class=\"fa-solid fa-xmark\"></i>";
        return "<i class=\"fa-solid fa-clock\"></i>";
    }

    protected string GetBadgeCssClass(string status)
    {
        status = status.ToLower();
        if (status.Contains("progress") || status.Contains("assigned")) return "bg-blue-50 text-blue-700 border-blue-200";
        if (status.Contains("resolved") || status.Contains("completed")) return "bg-green-50 text-green-700 border-green-200";
        if (status.Contains("reject") || status.Contains("fake")) return "bg-red-50 text-red-700 border-red-200";
        return "bg-orange-50 text-orange-700 border-orange-200";
    }

    protected string GetOpacityClass(string status)
    {
        status = status.ToLower();
        if (status.Contains("resolved") || status.Contains("reject")) return "opacity-70 hover:opacity-100 grayscale-[30%]";
        return "opacity-100";
    }

    protected string GetStatusBoxHtml(string status, DateTime createdAt, object resolvedAtObj)
    {
        string formattedDate = createdAt.ToString("dd MMM yyyy, hh:mm tt");
        status = status.ToLower();

        string boxTemplate = "<div class=\"{0} rounded-lg p-3 border mb-4 shadow-sm\">" +
                             "<p class=\"text-[10px] font-bold mb-1 uppercase tracking-wider opacity-80\">{1}</p>" +
                             "<div class=\"text-xs flex items-center gap-2 font-medium\">{2}</div>" +
                             "</div>";

        if (status.Contains("progress") || status.Contains("assigned"))
        {
            return string.Format(boxTemplate, "bg-blue-50 border-blue-100 text-blue-800", "Current Phase:", "<i class=\"fa-solid fa-person-digging\"></i> Team assigned. Work in progress.");
        }
        else if (status.Contains("resolved") || status.Contains("completed"))
        {
            string resolveDate = resolvedAtObj != DBNull.Value ? Convert.ToDateTime(resolvedAtObj).ToString("dd MMM yyyy") : "Recently";
            return string.Format(boxTemplate, "bg-green-50 border-green-100 text-green-800", "Action Taken:", "<i class=\"fa-solid fa-check-circle\"></i> Resolved & Verified on " + resolveDate);
        }
        else if (status.Contains("reject") || status.Contains("fake"))
        {
            return string.Format(boxTemplate, "bg-red-50 border-red-100 text-red-800", "System Alert:", "<i class=\"fa-solid fa-triangle-exclamation\"></i> Marked Invalid by AI/Admin.");
        }
        else
        {
            return string.Format(boxTemplate, "bg-orange-50 border-orange-100 text-orange-800", "Filing Date: " + formattedDate, "<i class=\"fa-solid fa-robot animate-pulse\"></i> Awaiting AI Verification & Routing.");
        }
    }
}