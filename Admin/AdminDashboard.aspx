<%@ Page Language="C#" AutoEventWireup="true" CodeFile="AdminDashboard.aspx.cs" Inherits="AdminDashboard" %>
<!DOCTYPE html>
<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title>Admin Dashboard | CiviCare</title>
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

        .stat-card { background: white; border: 1px solid #e2e8f0; border-radius: 12px; box-shadow: 0 1px 3px 0 rgba(0, 0, 0, 0.1); transition: transform 0.2s; }
        .stat-card:hover { transform: translateY(-2px); box-shadow: 0 4px 6px -1px rgba(0, 0, 0, 0.1); }

        .chart-container { position: relative; height: 250px; width: 100%; }

        #mobileSidebar { transition: transform 0.3s ease-in-out; }
    </style>
</head>
<body class="text-slate-600 antialiased">
    <form id="form1" runat="server">
        <div class="flex h-screen overflow-hidden">
            
            <aside class="hidden md:flex w-72 flex-col bg-white border-r border-slate-200 z-20">
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
                    
                    <a href="AdminDashboard.aspx" class="nav-link active flex items-center px-4 py-3 text-sm">
                        <i class="fa-solid fa-chart-pie w-6 opacity-75"></i> Dashboard
                    </a>
                    <a href="ManageUsers.aspx" class="nav-link flex items-center px-4 py-3 text-sm">
                        <i class="fa-solid fa-users w-6 opacity-75"></i> User Management
                    </a>
                    <a href="Departments.aspx" class="nav-link flex items-center px-4 py-3 text-sm">
                        <i class="fa-solid fa-building w-6 opacity-75"></i> Departments
                    </a>
                    <a href="Reports.aspx" class="nav-link flex items-center px-4 py-3 text-sm">
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
                        <p class="text-xs text-slate-500 mb-3">System is monitoring all 3 departments live.</p>
                        <button class="w-full py-1.5 bg-white border border-blue-200 text-blue-600 text-xs font-bold rounded-lg hover:bg-blue-50 transition">View Logs</button>
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
                    <a href="AdminDashboard.aspx" class="nav-link active flex items-center px-4 py-3 text-sm">
                        <i class="fa-solid fa-chart-pie w-6 opacity-75"></i> Dashboard
                    </a>
                    <a href="ManageUsers.aspx" class="nav-link flex items-center px-4 py-3 text-sm">
                        <i class="fa-solid fa-users w-6 opacity-75"></i> User Management
                    </a>
                    <a href="Departments.aspx" class="nav-link flex items-center px-4 py-3 text-sm">
                        <i class="fa-solid fa-building w-6 opacity-75"></i> Departments
                    </a>
                    <a href="Reports.aspx" class="nav-link flex items-center px-4 py-3 text-sm">
                        <i class="fa-solid fa-file-invoice w-6 opacity-75"></i> Reports & Data
                    </a>
                    <p class="px-4 text-xs font-bold text-slate-400 uppercase tracking-widest mt-8 mb-3">System</p>
                    <a href="/Logout.aspx" class="nav-link flex items-center px-4 py-3 text-sm text-red-500 hover:bg-red-50 hover:text-red-600 transition mt-2">
                        <i class="fa-solid fa-right-from-bracket w-6 opacity-75"></i> Logout
                    </a>
                </nav>
            </div>

            <div class="flex-1 flex flex-col overflow-hidden bg-slate-50">
                
                <header class="h-20 bg-white border-b border-slate-200 flex items-center justify-between px-4 md:px-8 z-10 shadow-sm">
                    <div class="flex items-center gap-4">
                        <button type="button" class="md:hidden text-slate-500" onclick="toggleSidebar()"><i class="fa-solid fa-bars text-xl"></i></button>
                        <h2 class="text-lg md:text-2xl font-bold text-slate-800">Admin Overview</h2>
                    </div>
                    <div class="flex items-center gap-6">
                        <button type="button" class="relative text-slate-400 hover:text-blue-600 transition">
                            <i class="fa-regular fa-bell text-xl"></i>
                            <span class="absolute top-0 right-0 h-2.5 w-2.5 bg-red-500 rounded-full border-2 border-white"></span>
                        </button>
                        <div class="flex items-center gap-3 pl-6 border-l border-slate-200">
                            <div class="text-right hidden sm:block">
                                <div class="text-sm font-bold text-slate-700"><asp:Literal ID="litAdminName" runat="server"></asp:Literal></div>
                                <div class="text-xs text-slate-400">Super Administrator</div>
                            </div>
                            <div class="w-10 h-10 rounded-full bg-slate-100 border border-slate-200 flex items-center justify-center text-slate-600 font-bold shadow-sm">A</div>
                        </div>
                    </div>
                </header>

                <main class="flex-1 overflow-y-auto p-4 md:p-8">
                    
                    <div class="grid grid-cols-1 sm:grid-cols-2 lg:grid-cols-4 gap-6 mb-8">
                        <div class="stat-card p-5 border-l-4 border-l-blue-500">
                            <div class="flex justify-between items-start">
                                <div>
                                    <p class="text-slate-500 text-xs font-bold uppercase tracking-wider">Total Complaints</p>
                                    <h3 class="text-3xl font-bold text-slate-800 mt-1"><asp:Literal ID="litTotal" runat="server">0</asp:Literal></h3>
                                </div>
                                <div class="p-3 bg-blue-50 text-blue-600 rounded-xl"><i class="fa-solid fa-folder-open text-xl"></i></div>
                            </div>
                        </div>
                        <div class="stat-card p-5 border-l-4 border-l-orange-500">
                            <div class="flex justify-between items-start">
                                <div>
                                    <p class="text-slate-500 text-xs font-bold uppercase tracking-wider">Pending</p>
                                    <h3 class="text-3xl font-bold text-slate-800 mt-1"><asp:Literal ID="litPending" runat="server">0</asp:Literal></h3>
                                </div>
                                <div class="p-3 bg-orange-50 text-orange-500 rounded-xl"><i class="fa-solid fa-clock text-xl"></i></div>
                            </div>
                        </div>
                        <div class="stat-card p-5 border-l-4 border-l-green-500">
                            <div class="flex justify-between items-start">
                                <div>
                                    <p class="text-slate-500 text-xs font-bold uppercase tracking-wider">Resolved</p>
                                    <h3 class="text-3xl font-bold text-slate-800 mt-1"><asp:Literal ID="litResolved" runat="server">0</asp:Literal></h3>
                                </div>
                                <div class="p-3 bg-green-50 text-green-600 rounded-xl"><i class="fa-solid fa-check-circle text-xl"></i></div>
                            </div>
                        </div>
                         <div class="stat-card p-5 border-l-4 border-l-purple-500">
                            <div class="flex justify-between items-start">
                                <div>
                                    <p class="text-slate-500 text-xs font-bold uppercase tracking-wider">Active Staff</p>
                                    <h3 class="text-3xl font-bold text-slate-800 mt-1"><asp:Literal ID="litStaff" runat="server">0</asp:Literal></h3>
                                </div>
                                <div class="p-3 bg-purple-50 text-purple-600 rounded-xl"><i class="fa-solid fa-users text-xl"></i></div>
                            </div>
                        </div>
                    </div>

                    <div class="grid grid-cols-1 lg:grid-cols-3 gap-6 mb-8">
                        <div class="stat-card p-6">
                            <h3 class="font-bold text-slate-800 mb-4 flex items-center gap-2">
                                <span class="w-2 h-6 bg-blue-600 rounded-full"></span> Overall Status
                            </h3>
                            <div class="chart-container">
                                <canvas id="chartStatus"></canvas>
                            </div>
                            <div class="mt-4 text-center text-xs text-slate-400">Total complaints across all zones</div>
                        </div>

                        <div class="stat-card p-6">
                            <h3 class="font-bold text-slate-800 mb-4 flex items-center gap-2">
                                <span class="w-2 h-6 bg-purple-500 rounded-full"></span> Department Load
                            </h3>
                            <div class="chart-container">
                                <canvas id="chartCategory"></canvas>
                            </div>
                             <div class="mt-4 text-center text-xs text-slate-400">Volume of complaints per department</div>
                        </div>

                        <div class="stat-card p-6">
                            <h3 class="font-bold text-slate-800 mb-4 flex items-center gap-2">
                                <span class="w-2 h-6 bg-green-500 rounded-full"></span> Resolution Performance
                            </h3>
                            <div class="chart-container">
                                <canvas id="chartPerformance"></canvas>
                            </div>
                             <div class="mt-4 text-center text-xs text-slate-400">Resolved vs Pending for each Dept</div>
                        </div>
                    </div>

                    <div class="grid grid-cols-1 md:grid-cols-2 gap-6">
                        <div class="stat-card p-6 bg-gradient-to-br from-slate-800 to-slate-900 border-none text-white relative overflow-hidden">
                            <div class="absolute right-0 top-0 opacity-10 text-8xl transform translate-x-4 -translate-y-4"><i class="fa-solid fa-shield-halved"></i></div>
                            <h3 class="font-bold text-lg mb-6 flex items-center gap-2">
                                <i class="fa-solid fa-robot text-blue-400"></i> AI Spam Prevention
                            </h3>
                            
                            <div class="flex items-center gap-5 mb-5 bg-white/10 p-4 rounded-xl backdrop-blur-sm border border-white/10">
                                <div class="w-12 h-12 rounded-full bg-red-500/20 text-red-400 flex items-center justify-center text-xl"><i class="fa-solid fa-ban"></i></div>
                                <div>
                                    <p class="text-slate-300 text-xs font-semibold uppercase tracking-wider mb-0.5">Fake Photos Rejected</p>
                                    <h4 class="text-2xl font-bold"><asp:Literal ID="litFakeCount" runat="server">0</asp:Literal></h4>
                                </div>
                            </div>
                            <p class="text-xs text-slate-400 leading-relaxed">Our Gemini AI model automatically scanned and rejected these uploads, saving hours of manual verification time for our department officers.</p>
                        </div>

                        <div class="stat-card p-6">
                            <h3 class="font-bold text-slate-800 mb-4 flex items-center gap-2 border-b border-slate-100 pb-3">
                                <i class="fa-solid fa-triangle-exclamation text-orange-500"></i> High Priority Alerts
                            </h3>
                            
                            <div class="space-y-4">
                                <div class="flex items-start gap-3">
                                    <div class="mt-0.5 text-red-500"><i class="fa-solid fa-circle-dot text-[10px] animate-pulse"></i></div>
                                    <div>
                                        <p class="text-sm font-bold text-slate-800">Critical Issues Pending</p>
                                        <p class="text-xs text-slate-500 mt-1">There are <strong class="text-red-600"><asp:Literal ID="litHighPriority" runat="server">0</asp:Literal></strong> high priority complaints awaiting action across all departments.</p>
                                    </div>
                                </div>
                                <div class="flex items-start gap-3">
                                    <div class="mt-0.5 text-blue-500"><i class="fa-solid fa-circle-dot text-[10px]"></i></div>
                                    <div>
                                        <p class="text-sm font-bold text-slate-800">Most Active Zone</p>
                                        <p class="text-xs text-slate-500 mt-1">Ward 12 currently has the highest volume of incoming traffic.</p>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>

                </main>
            </div>
        </div>

        <asp:HiddenField ID="hfStatusData" runat="server" />
        <asp:HiddenField ID="hfCategoryData" runat="server" />
        <asp:HiddenField ID="hfPerformanceResolved" runat="server" />
        <asp:HiddenField ID="hfPerformancePending" runat="server" />

        <script>
            function toggleSidebar() {
                const sidebar = document.getElementById('mobileSidebar');
                sidebar.classList.toggle('-translate-x-full');
            }

            document.addEventListener('DOMContentLoaded', function () {
                // Get JSON Data from Backend Hidden Fields
                const statusDataRaw = document.getElementById('<%= hfStatusData.ClientID %>').value;
                const categoryDataRaw = document.getElementById('<%= hfCategoryData.ClientID %>').value;
                const perfResRaw = document.getElementById('<%= hfPerformanceResolved.ClientID %>').value;
                const perfPendRaw = document.getElementById('<%= hfPerformancePending.ClientID %>').value;

                // Parse Data (Fallback to zeros if empty)
                const statusData = statusDataRaw ? JSON.parse(statusDataRaw) : [0, 0, 0];
                const categoryData = categoryDataRaw ? JSON.parse(categoryDataRaw) : [0, 0, 0];
                const perfResolved = perfResRaw ? JSON.parse(perfResRaw) : [0, 0, 0];
                const perfPending = perfPendRaw ? JSON.parse(perfPendRaw) : [0, 0, 0];

                // 1. Overall Status (Doughnut)
                const ctxStatus = document.getElementById('chartStatus').getContext('2d');
                new Chart(ctxStatus, {
                    type: 'doughnut',
                    data: {
                        labels: ['Pending', 'In Progress', 'Resolved'],
                        datasets: [{
                            data: statusData,
                            backgroundColor: ['#ef4444', '#3b82f6', '#22c55e'],
                            borderWidth: 0,
                            hoverOffset: 4
                        }]
                    },
                    options: { responsive: true, maintainAspectRatio: false, plugins: { legend: { position: 'bottom' } } }
                });

                // 2. Department Distribution (Pie)
                const ctxCategory = document.getElementById('chartCategory').getContext('2d');
                new Chart(ctxCategory, {
                    type: 'pie',
                    data: {
                        labels: ['Electricity', 'Water Supply', 'Sanitation'],
                        datasets: [{
                            data: categoryData,
                            backgroundColor: ['#facc15', '#3b82f6', '#4ade80'],
                            borderWidth: 0
                        }]
                    },
                    options: { responsive: true, maintainAspectRatio: false, plugins: { legend: { position: 'bottom' } } }
                });

                // 3. Performance Comparison (Grouped Bar)
                const ctxPerformance = document.getElementById('chartPerformance').getContext('2d');
                new Chart(ctxPerformance, {
                    type: 'bar',
                    data: {
                        labels: ['Electricity', 'Water', 'Sanitation'],
                        datasets: [
                            {
                                label: 'Resolved',
                                data: perfResolved,
                                backgroundColor: '#22c55e',
                                borderRadius: 4
                            },
                            {
                                label: 'Pending',
                                data: perfPending,
                                backgroundColor: '#ef4444',
                                borderRadius: 4
                            }
                        ]
                    },
                    options: {
                        responsive: true, maintainAspectRatio: false,
                        plugins: { legend: { position: 'bottom' } },
                        scales: {
                            y: { beginAtZero: true, grid: { display: false } },
                            x: { grid: { display: false } }
                        }
                    }
                });
            });
        </script>
    </form>
</body>
</html>