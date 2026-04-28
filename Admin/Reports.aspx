<%@ Page Language="C#" AutoEventWireup="true" CodeFile="Reports.aspx.cs" Inherits="Reports" %>

<!DOCTYPE html>
<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title>Reports & Analytics | CiviCare Admin</title>
    <meta name="viewport" content="width=device-width, initial-scale=1.0" />
    
    <script src="https://cdn.tailwindcss.com"></script>
    <script src="https://cdn.jsdelivr.net/npm/chart.js"></script>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css" />
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@300;400;500;600;700&display=swap" rel="stylesheet"/>
    
    <style>
        body { font-family: 'Inter', sans-serif; background-color: #f8fafc; }
        .no-scrollbar::-webkit-scrollbar { display: none; }
        .no-scrollbar { -ms-overflow-style: none; scrollbar-width: none; }
        
        .nav-link { border-radius: 8px; transition: all 0.2s ease-in-out; color: #64748b; font-weight: 500; }
        .nav-link:hover { background-color: #f1f5f9; color: #1e293b; }
        .nav-link.active { background-color: #eff6ff; color: #2563eb; font-weight: 600; }

        .form-control { border: 1px solid #cbd5e1; border-radius: 6px; padding: 0.5rem 0.75rem; font-size: 0.875rem; color: #334155; outline: none; transition: border-color 0.2s; width: 100%; }
        .form-control:focus { border-color: #3b82f6; box-shadow: 0 0 0 3px rgba(59, 130, 246, 0.1); }

        .report-card { background: white; border: 1px solid #e2e8f0; border-radius: 12px; box-shadow: 0 1px 3px 0 rgba(0, 0, 0, 0.1); }

        .bordered-table th, .bordered-table td { border: 1px solid #e2e8f0; }

        /* Toast Animations */
        @keyframes slideInRight { from { transform: translateX(100%); opacity: 0; } to { transform: translateX(0); opacity: 1; } }
        @keyframes fadeOutUp { from { opacity: 1; transform: translateY(0); } to { opacity: 0; transform: translateY(-20px); } }
        .toast-enter { animation: slideInRight 0.4s cubic-bezier(0.16, 1, 0.3, 1) forwards; }
        .toast-exit { animation: fadeOutUp 0.4s ease forwards; }

        #mobileSidebar { transition: transform 0.3s ease-in-out; }
    </style>
</head>
<body class="text-slate-600 antialiased">
    <div id="toast-container" class="fixed top-5 right-5 z-[99999] flex flex-col gap-3 pointer-events-none"></div>

    <form id="form1" runat="server">
        <div class="flex h-screen overflow-hidden">
            
            <aside class="hidden md:flex w-72 flex-col bg-white border-r border-slate-200 z-20 shadow-sm">
                <div class="h-20 flex items-center px-8 border-b border-slate-100">
                    <div class="flex items-center gap-3">
                        <div class="w-9 h-9 bg-blue-600 rounded-lg flex items-center justify-center text-white text-xl shadow-lg shadow-blue-200">
                            <i class="fa-solid fa-city"></i>
                        </div>
                        <span class="text-xl font-bold tracking-tight text-slate-800">Civi<span class="text-blue-600">Care</span></span>
                    </div>
                </div>

                <nav class="flex-1 py-6 px-4 space-y-1.5 overflow-y-auto no-scrollbar">
                    <p class="px-4 text-xs font-bold text-slate-400 uppercase tracking-widest mb-3">Overview</p>
                    <a href="AdminDashboard.aspx" class="nav-link flex items-center px-4 py-3 text-sm">
                        <i class="fa-solid fa-chart-pie w-6 opacity-75"></i> Dashboard
                    </a>
                    <a href="ManageUsers.aspx" class="nav-link flex items-center px-4 py-3 text-sm">
                        <i class="fa-solid fa-users w-6 opacity-75"></i> User Management
                    </a>
                    <a href="Departments.aspx" class="nav-link flex items-center px-4 py-3 text-sm">
                        <i class="fa-solid fa-building w-6 opacity-75"></i> Departments
                    </a>
                    <a href="Reports.aspx" class="nav-link active flex items-center px-4 py-3 text-sm">
                        <i class="fa-solid fa-file-invoice w-6 opacity-75"></i> Reports & Data
                    </a>
                    
                    <p class="px-4 text-xs font-bold text-slate-400 uppercase tracking-widest mt-8 mb-3">System</p>
                    <a href="#" class="nav-link flex items-center px-4 py-3 text-sm">
                        <i class="fa-solid fa-gear w-6 opacity-75"></i> Configuration
                    </a>
                    <a href="/SystemLogin.aspx?action=logout" class="nav-link flex items-center px-4 py-3 text-sm text-red-500 hover:bg-red-50 hover:text-red-600 transition">
                        <i class="fa-solid fa-right-from-bracket w-6 opacity-75"></i> Logout
                    </a>
                </nav>

                <div class="p-4 border-t border-slate-100">
                    <div class="bg-gradient-to-br from-blue-50 to-indigo-50 border border-blue-100 rounded-xl p-4">
                        <div class="flex items-center gap-3 mb-2">
                            <div class="p-2 bg-white rounded-lg shadow-sm text-blue-600"><i class="fa-solid fa-robot"></i></div>
                            <span class="font-bold text-slate-800 text-sm">AI System Active</span>
                        </div>
                        <p class="text-xs text-slate-500 mb-3">Monitoring all 3 departments live.</p>
                        <button type="button" class="w-full py-1.5 bg-white border border-blue-200 text-blue-600 text-xs font-bold rounded-lg hover:bg-blue-50 transition">View Logs</button>
                    </div>
                </div>
            </aside>

            <div id="mobileSidebar" class="fixed inset-y-0 left-0 w-72 bg-white shadow-2xl z-50 transform -translate-x-full md:hidden flex flex-col border-r border-slate-200">
                <div class="h-20 flex items-center justify-between px-6 border-b border-slate-100">
                    <div class="flex items-center gap-3">
                        <div class="w-9 h-9 bg-blue-600 rounded-lg flex items-center justify-center text-white text-xl shadow-lg shadow-blue-200">
                            <i class="fa-solid fa-city"></i>
                        </div>
                        <span class="text-xl font-bold tracking-tight text-slate-800">Civi<span class="text-blue-600">Care</span></span>
                    </div>
                    <button type="button" onclick="toggleSidebar()" class="text-slate-400 hover:text-red-500 transition text-2xl"><i class="fa-solid fa-xmark"></i></button>
                </div>
                <nav class="flex-1 py-6 px-4 space-y-1.5 overflow-y-auto no-scrollbar">
                    <p class="px-4 text-xs font-bold text-slate-400 uppercase tracking-widest mb-3">Overview</p>
                    <a href="AdminDashboard.aspx" class="nav-link flex items-center px-4 py-3 text-sm">
                        <i class="fa-solid fa-chart-pie w-6 opacity-75"></i> Dashboard
                    </a>
                    <a href="ManageUsers.aspx" class="nav-link flex items-center px-4 py-3 text-sm">
                        <i class="fa-solid fa-users w-6 opacity-75"></i> User Management
                    </a>
                    <a href="Departments.aspx" class="nav-link flex items-center px-4 py-3 text-sm">
                        <i class="fa-solid fa-building w-6 opacity-75"></i> Departments
                    </a>
                    <a href="Reports.aspx" class="nav-link active flex items-center px-4 py-3 text-sm">
                        <i class="fa-solid fa-file-invoice w-6 opacity-75"></i> Reports & Data
                    </a>
                    <p class="px-4 text-xs font-bold text-slate-400 uppercase tracking-widest mt-8 mb-3">System</p>
                    <a href="/SystemLogin.aspx?action=logout" class="nav-link flex items-center px-4 py-3 text-sm text-red-500 hover:bg-red-50 hover:text-red-600 transition">
                        <i class="fa-solid fa-right-from-bracket w-6 opacity-75"></i> Logout
                    </a>
                </nav>
            </div>

            <div class="flex-1 flex flex-col overflow-hidden bg-slate-50">
                
                <header class="h-20 bg-white border-b border-slate-200 flex items-center justify-between px-4 md:px-8 shadow-sm z-10">
                    <div class="flex items-center gap-4">
                        <button type="button" class="md:hidden text-slate-500" onclick="toggleSidebar()"><i class="fa-solid fa-bars text-xl"></i></button>
                        <h2 class="text-xl font-bold text-slate-800">Analytics & Reports</h2>
                    </div>
                    <div class="flex items-center gap-6">
                        <div class="text-right hidden sm:block pl-6 border-l border-slate-200">
                            <div class="text-sm font-bold text-slate-700"><asp:Literal ID="litAdminName" runat="server">Admin User</asp:Literal></div>
                            <div class="text-xs text-slate-400">Super Admin</div>
                        </div>
                        <div class="w-10 h-10 rounded-full bg-slate-100 border border-slate-200 flex items-center justify-center text-slate-600 font-bold shadow-sm">A</div>
                    </div>
                </header>

                <main class="flex-1 overflow-y-auto p-4 md:p-8">
                    
                    <div class="bg-white p-5 rounded-xl border border-slate-200 shadow-sm mb-6 flex flex-col lg:flex-row justify-between items-start lg:items-end gap-4">
                        <div class="w-full lg:w-auto">
                            <h3 class="text-sm font-bold text-slate-700 uppercase tracking-wide mb-3"><i class="fa-solid fa-filter text-blue-500 mr-1"></i> Generate Custom Report</h3>
                            <div class="flex flex-col sm:flex-row flex-wrap gap-4 items-start sm:items-end">
                                <div class="w-full sm:w-auto">
                                    <span class="text-xs font-semibold text-slate-500 block mb-1">Department</span>
                                    <asp:DropDownList ID="ddlDeptFilter" runat="server" CssClass="form-control min-w-[150px] cursor-pointer">
                                        <asp:ListItem Text="All Departments" Value="All"></asp:ListItem>
                                        <asp:ListItem Text="Electric" Value="Electric"></asp:ListItem>
                                        <asp:ListItem Text="Water" Value="Water"></asp:ListItem>
                                        <asp:ListItem Text="Sanitation" Value="Sanitation"></asp:ListItem>
                                    </asp:DropDownList>
                                </div>
                                <div class="w-full sm:w-auto">
                                    <span class="text-xs font-semibold text-slate-500 block mb-1">From Date</span>
                                    <asp:TextBox ID="txtFromDate" runat="server" TextMode="Date" CssClass="form-control cursor-pointer"></asp:TextBox>
                                </div>
                                <div class="w-full sm:w-auto">
                                    <span class="text-xs font-semibold text-slate-500 block mb-1">To Date</span>
                                    <asp:TextBox ID="txtToDate" runat="server" TextMode="Date" CssClass="form-control cursor-pointer"></asp:TextBox>
                                </div>
                                <div class="flex gap-2 w-full sm:w-auto pt-1 sm:pt-0">
                                    <asp:Button ID="btnFilter" runat="server" Text="Filter Data" OnClick="btnFilter_Click" CssClass="flex-1 sm:flex-none bg-slate-800 hover:bg-slate-900 text-white px-5 py-2 rounded-lg text-sm font-bold shadow-sm transition cursor-pointer" />
                                    <asp:Button ID="btnClear" runat="server" Text="Clear" OnClick="btnClear_Click" CssClass="flex-1 sm:flex-none bg-white border border-slate-300 text-slate-600 hover:bg-slate-50 px-4 py-2 rounded-lg text-sm font-bold transition cursor-pointer" />
                                </div>
                            </div>
                        </div>
                        <div class="w-full lg:w-auto mt-2 lg:mt-0">
                            <asp:Button ID="btnExportCSV" runat="server" Text="Download CSV" OnClick="btnExportCSV_Click" CssClass="w-full lg:w-auto bg-green-600 hover:bg-green-700 text-white px-5 py-2.5 md:py-2 rounded-lg text-sm font-bold shadow-md cursor-pointer transition flex items-center justify-center gap-2" />
                        </div>
                    </div>

                    <div class="grid grid-cols-1 lg:grid-cols-3 gap-6 mb-8">
                        
                        <div class="lg:col-span-2 report-card p-6">
                            <h3 class="font-bold text-slate-800 mb-4 flex items-center gap-2"><i class="fa-solid fa-chart-line text-blue-600"></i> Complaint Trend Analysis</h3>
                            <div class="relative h-64 w-full">
                                <canvas id="reportChart"></canvas>
                            </div>
                        </div>

                        <div class="report-card p-6 flex flex-col justify-center">
                            <h3 class="font-bold text-slate-800 mb-6 border-b border-slate-100 pb-2"><i class="fa-solid fa-chart-simple text-blue-600 mr-1"></i> Report Summary</h3>
                            <div class="space-y-6">
                                <div class="flex justify-between items-center">
                                    <span class="text-sm font-medium text-slate-500">Selected Filter</span>
                                    <span class="font-bold text-slate-800 bg-slate-100 px-2 py-1 rounded text-xs"><asp:Literal ID="litFilterLabel" runat="server">All Data</asp:Literal></span>
                                </div>
                                <div class="flex justify-between items-center">
                                    <span class="text-sm font-medium text-slate-500">Total Records</span>
                                    <span class="font-extrabold text-blue-600 text-2xl"><asp:Literal ID="litTotalRecords" runat="server">0</asp:Literal></span>
                                </div>
                                <div class="flex justify-between items-center">
                                    <span class="text-sm font-medium text-slate-500">Avg. Resolution Time</span>
                                    <span class="font-bold text-green-600 text-lg"><asp:Literal ID="litAvgResolution" runat="server">0 Hrs</asp:Literal></span>
                                </div>
                                <div class="bg-blue-50 p-3 rounded-lg border border-blue-100 mt-4">
                                    <p class="text-xs text-blue-700 text-center font-medium">
                                        <i class="fa-solid fa-info-circle mr-1"></i> Data is ready for export.
                                    </p>
                                </div>
                            </div>
                        </div>
                    </div>

                    <div class="report-card overflow-hidden">
                         <div class="px-4 md:px-6 py-4 border-b border-slate-100 bg-white flex justify-between items-center">
                            <h3 class="font-bold text-slate-800 text-sm uppercase tracking-wide">Detailed Records</h3>
                        </div>
                        
                        <div class="overflow-x-auto w-full p-4">
                            <table class="w-full text-left text-sm text-slate-600 min-w-[800px] bordered-table border-collapse">
                                <thead class="bg-slate-50 text-slate-700 font-bold uppercase text-xs">
                                    <tr>
                                        <th class="p-4 whitespace-nowrap">Filed On</th>
                                        <th class="p-4">Complaint ID</th>
                                        <th class="p-4">Department</th>
                                        <th class="p-4">Priority</th>
                                        <th class="p-4 text-center">Status</th>
                                        <th class="p-4 whitespace-nowrap">Time Taken</th>
                                    </tr>
                                </thead>
                                <tbody class="divide-y divide-slate-100 bg-white">
                                    <asp:Repeater ID="rptDetailedLogs" runat="server">
                                        <ItemTemplate>
                                            <tr class="hover:bg-slate-50 transition duration-150">
                                                <td class="p-4 font-mono text-xs whitespace-nowrap">
                                                    <%# Convert.ToDateTime(Eval("CreatedAt")).ToString("dd MMM yyyy, hh:mm tt") %>
                                                </td>
                                                <td class="p-4 font-bold text-slate-700 font-mono">#CMP-<%# Eval("ComplaintID") %></td>
                                                <td class="p-4 font-semibold text-slate-800">
                                                    <i class="fa-solid <%# GetDeptIcon(Eval("AssignedDepartment").ToString()) %> mr-1"></i> <%# Eval("AssignedDepartment") %>
                                                </td>
                                                <td class="p-4">
                                                    <span class="<%# GetPriorityCss(Eval("PriorityLevel").ToString()) %> px-2 py-1 rounded text-[10px] font-bold uppercase"><%# Eval("PriorityLevel") %></span>
                                                </td>
                                                <td class="p-4 text-center">
                                                    <span class="<%# GetStatusCss(Eval("Status").ToString()) %> px-2.5 py-1 rounded text-[10px] font-bold uppercase inline-flex items-center gap-1">
                                                        <%# GetStatusIcon(Eval("Status").ToString()) %> <%# Eval("Status") %>
                                                    </span>
                                                </td>
                                                <td class="p-4 font-mono text-xs font-semibold text-slate-600">
                                                    <%# CalculateTimeTaken(Eval("CreatedAt"), Eval("ResolvedAt")) %>
                                                </td>
                                            </tr>
                                        </ItemTemplate>
                                    </asp:Repeater>

                                    <tr id="trNoData" runat="server" visible="false">
                                        <td colspan="6" class="p-10 text-center text-slate-500 border-none">
                                            <i class="fa-solid fa-folder-open text-4xl text-slate-300 mb-3 block"></i>
                                            <span class="font-bold text-lg">No Records Found.</span>
                                        </td>
                                    </tr>
                                </tbody>
                            </table>
                        </div>
                    </div>

                </main>
            </div>
        </div>

        <asp:HiddenField ID="hfChartLabels" runat="server" />
        <asp:HiddenField ID="hfChartReceived" runat="server" />
        <asp:HiddenField ID="hfChartResolved" runat="server" />

        <script>
            function toggleSidebar() {
                const sidebar = document.getElementById('mobileSidebar');
                sidebar.classList.toggle('-translate-x-full');
            }

            function showToast(message, type) {
                const container = document.getElementById('toast-container');
                const toast = document.createElement('div');
                const isSuccess = type === 'success';
                const bgColor = isSuccess ? 'bg-emerald-600' : 'bg-red-600';
                const icon = isSuccess ? 'fa-circle-check' : 'fa-circle-exclamation';

                toast.className = "flex items-center gap-3 px-5 py-3.5 rounded-lg shadow-2xl text-white text-sm font-bold toast-enter pointer-events-auto " + bgColor;
                toast.innerHTML = "<i class='fa-solid " + icon + " text-xl'></i><span>" + message + "</span>";
                
                container.appendChild(toast);
                setTimeout(() => {
                    toast.classList.remove('toast-enter');
                    toast.classList.add('toast-exit');
                    setTimeout(() => { if(container.contains(toast)) container.removeChild(toast); }, 400);
                }, 3500);
            }

            document.addEventListener('DOMContentLoaded', function () {
                // Get JSON Data from Backend Hidden Fields
                const labelsRaw = document.getElementById('<%= hfChartLabels.ClientID %>').value;
                const receivedRaw = document.getElementById('<%= hfChartReceived.ClientID %>').value;
                const resolvedRaw = document.getElementById('<%= hfChartResolved.ClientID %>').value;

                // Parse Data (Fallback to dummy data if empty for layout preservation)
                const chartLabels = labelsRaw ? JSON.parse(labelsRaw) : ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];
                const chartReceived = receivedRaw ? JSON.parse(receivedRaw) : [0,0,0,0,0,0,0];
                const chartResolved = resolvedRaw ? JSON.parse(resolvedRaw) : [0,0,0,0,0,0,0];

                // Chart.js Configuration
                const ctx = document.getElementById('reportChart').getContext('2d');
                new Chart(ctx, {
                    type: 'line',
                    data: {
                        labels: chartLabels,
                        datasets: [{
                            label: 'Complaints Received',
                            data: chartReceived,
                            borderColor: '#2563eb',
                            backgroundColor: 'rgba(37, 99, 235, 0.1)',
                            borderWidth: 2,
                            tension: 0.4,
                            fill: true
                        },
                        {
                            label: 'Resolved',
                            data: chartResolved,
                            borderColor: '#22c55e',
                            borderWidth: 2,
                            tension: 0.4,
                            borderDash: [5, 5]
                        }]
                    },
                    options: {
                        responsive: true,
                        maintainAspectRatio: false,
                        plugins: { legend: { position: 'top' } },
                        scales: { y: { beginAtZero: true, grid: { color: '#f1f5f9' } }, x: { grid: { display: false } } }
                    }
                });
            });
        </script>
    </form>
</body>
</html>