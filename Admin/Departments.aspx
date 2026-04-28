<%@ Page Language="C#" AutoEventWireup="true" CodeFile="Departments.aspx.cs" Inherits="Departments" %>
<!DOCTYPE html>
<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title>Departments | CiviCare</title>
    <meta name="viewport" content="width=device-width, initial-scale=1.0" />
    
    <script src="https://cdn.tailwindcss.com"></script>
    
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css" />
    
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@300;400;500;600;700&display=swap" rel="stylesheet">
    
    <style>
        body { font-family: 'Inter', sans-serif; background-color: #f8fafc; }
        
        /* Navigation Styles */
        .nav-link {
            border-radius: 8px;
            transition: all 0.2s ease-in-out;
            color: #64748b; /* Standard Slate Color */
        }
        .nav-link:hover {
            background-color: #f1f5f9;
            color: #1e293b;
        }
        /* Active State - Blue Highlight */
        .nav-link.active {
            background-color: #eff6ff;
            color: #2563eb;
            font-weight: 600;
        }

        /* Department Header Card */
        .dept-header {
            background: white;
            border-radius: 12px;
            border: 1px solid #e2e8f0;
            box-shadow: 0 1px 3px 0 rgba(0, 0, 0, 0.1);
            transition: transform 0.2s;
        }
        .dept-header:hover {
            transform: translateY(-2px);
            box-shadow: 0 4px 6px -1px rgba(0, 0, 0, 0.1);
        }

        /* Metric Box */
        .metric-box {
            background-color: #f8fafc;
            border: 1px solid #e2e8f0;
            border-radius: 8px;
            padding: 12px;
            text-align: center;
        }

        /* Mobile Sidebar */
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

                <nav class="flex-1 py-6 px-4 space-y-1.5 overflow-y-auto">
                    <p class="px-4 text-xs font-bold text-slate-400 uppercase tracking-widest mb-3">Overview</p>
                    
                    <a href="AdminDashboard.aspx" class="nav-link flex items-center px-4 py-3 text-sm">
                        <i class="fa-solid fa-chart-pie w-6 opacity-75"></i> Dashboard
                    </a>
                    <a href="ManageUsers.aspx" class="nav-link flex items-center px-4 py-3 text-sm">
                        <i class="fa-solid fa-users w-6 opacity-75"></i> User Management
                    </a>
                    
                    <a href="Departments.aspx" class="nav-link active flex items-center px-4 py-3 text-sm">
                        <i class="fa-solid fa-building w-6 opacity-75"></i> Departments
                    </a>
                    
                    <a href="Reports.aspx" class="nav-link flex items-center px-4 py-3 text-sm">
                        <i class="fa-solid fa-file-invoice w-6 opacity-75"></i> Reports & Data
                    </a>
                    
                    <p class="px-4 text-xs font-bold text-slate-400 uppercase tracking-widest mt-8 mb-3">System</p>
                    <a href="#" class="nav-link flex items-center px-4 py-3 text-sm">
                        <i class="fa-solid fa-gear w-6 opacity-75"></i> Configuration
                    </a>
                    <a href="/Logout.aspx" class="nav-link flex items-center px-4 py-3 text-sm text-red-500 hover:bg-red-50 hover:text-red-600">
                        <i class="fa-solid fa-right-from-bracket w-6 opacity-75"></i> Logout
                    </a>
                </nav>

                <div class="p-4 border-t border-slate-100">
                    <div class="bg-gradient-to-br from-blue-50 to-indigo-50 border border-blue-100 rounded-xl p-4">
                        <div class="flex items-center gap-3 mb-2">
                            <div class="p-2 bg-white rounded-lg shadow-sm text-blue-600"><i class="fa-solid fa-robot"></i></div>
                            <span class="font-bold text-slate-800 text-sm">AI System Active</span>
                        </div>
                        <p class="text-xs text-slate-500 mb-3">Monitoring 3 departments live.</p>
                        <button class="w-full py-1.5 bg-white border border-blue-200 text-blue-600 text-xs font-bold rounded-lg hover:bg-blue-50 transition">View Logs</button>
                    </div>
                </div>
            </aside>

            <div id="mobileSidebar" class="fixed inset-y-0 left-0 w-64 bg-white shadow-2xl z-50 transform -translate-x-full md:hidden flex flex-col border-r border-slate-200">
                <div class="h-16 flex items-center justify-between px-6 border-b border-slate-100">
                    <span class="text-lg font-bold text-slate-800">Menu</span>
                    <button type="button" onclick="toggleSidebar()" class="text-slate-500 hover:text-slate-800"><i class="fa-solid fa-xmark text-xl"></i></button>
                </div>
                <nav class="p-4 space-y-2">
                    <a href="AdminDashboard.aspx" class="block px-4 py-2 text-slate-600 hover:bg-slate-50 rounded-md">Dashboard</a>
                    <a href="ManageUsers.aspx" class="block px-4 py-2 text-slate-600 hover:bg-slate-50 rounded-md">User Management</a>
                    <a href="Departments.aspx" class="block px-4 py-2 bg-blue-50 text-blue-600 rounded-md font-medium">Departments</a>
                    <a href="Reports.aspx" class="block px-4 py-2 text-slate-600 hover:bg-slate-50 rounded-md">Reports</a>
                </nav>
            </div>

            <div class="flex-1 flex flex-col overflow-hidden bg-slate-50">
                
                <header class="h-20 bg-white border-b border-slate-200 flex items-center justify-between px-8 shadow-sm z-10">
                    <div class="flex items-center gap-4">
                        <button type="button" class="md:hidden text-slate-500" onclick="toggleSidebar()"><i class="fa-solid fa-bars text-xl"></i></button>
                        <h2 class="text-xl font-bold text-slate-800">Department Overview</h2>
                    </div>
                    <div class="flex items-center gap-6">
                         <button type="button" class="relative text-slate-400 hover:text-blue-600 transition">
                            <i class="fa-regular fa-bell text-xl"></i>
                        </button>
                         <div class="text-right hidden sm:block pl-6 border-l border-slate-200">
                            <div class="text-sm font-bold text-slate-700">Admin User</div>
                            <div class="text-xs text-slate-400">Super Admin</div>
                        </div>
                        <div class="w-10 h-10 rounded-full bg-slate-100 border border-slate-200 flex items-center justify-center text-slate-600 font-bold shadow-sm">A</div>
                    </div>
                </header>

                <main class="flex-1 overflow-y-auto p-4 md:p-8 space-y-8">
                    
                    <div class="dept-header p-6 border-l-4 border-l-yellow-400">
                        <div class="flex justify-between items-start mb-6">
                            <div class="flex items-center gap-4">
                                <div class="w-12 h-12 bg-yellow-50 rounded-xl flex items-center justify-center text-yellow-600 border border-yellow-100 shadow-sm">
                                    <i class="fa-solid fa-bolt text-2xl"></i>
                                </div>
                                <div>
                                    <h3 class="text-xl font-bold text-slate-800">Electricity Department</h3>
                                    <p class="text-sm text-slate-500">Responsible for Street Lights & Power Lines</p>
                                </div>
                            </div>
                            <button class="px-4 py-2 border border-slate-200 rounded-lg text-sm text-blue-600 font-bold hover:bg-blue-50 transition">View Details</button>
                        </div>

                        <div class="grid grid-cols-2 md:grid-cols-4 gap-4">
                            <div class="metric-box">
                                <p class="text-xs text-slate-400 uppercase font-bold tracking-wider">Total Assets</p>
                                <p class="text-lg font-bold text-slate-800 mt-1">1,240</p>
                                <p class="text-xs text-green-500 font-medium">Active</p>
                            </div>
                            <div class="metric-box">
                                <p class="text-xs text-slate-400 uppercase font-bold tracking-wider">Maint. Cost</p>
                                <p class="text-lg font-bold text-slate-800 mt-1">₹ 4.5L</p>
                                <p class="text-xs text-slate-400 font-medium">This Month</p>
                            </div>
                            <div class="metric-box bg-red-50 border-red-100">
                                <p class="text-xs text-red-400 uppercase font-bold tracking-wider">Failures</p>
                                <p class="text-lg font-bold text-red-600 mt-1">12</p>
                                <p class="text-xs text-red-400 font-medium">Critical</p>
                            </div>
                            <div class="metric-box">
                                <p class="text-xs text-slate-400 uppercase font-bold tracking-wider">Staff On-Duty</p>
                                <p class="text-lg font-bold text-slate-800 mt-1">18 / 25</p>
                                <p class="text-xs text-blue-500 font-medium">7 on Leave</p>
                            </div>
                        </div>
                    </div>

                    <div class="dept-header p-6 border-l-4 border-l-blue-500">
                        <div class="flex justify-between items-start mb-6">
                            <div class="flex items-center gap-4">
                                <div class="w-12 h-12 bg-blue-50 rounded-xl flex items-center justify-center text-blue-600 border border-blue-100 shadow-sm">
                                    <i class="fa-solid fa-faucet-drip text-2xl"></i>
                                </div>
                                <div>
                                    <h3 class="text-xl font-bold text-slate-800">Water Supply & Drainage</h3>
                                    <p class="text-sm text-slate-500">Managing Pipelines, Valves & Sewerage</p>
                                </div>
                            </div>
                            <button class="px-4 py-2 border border-slate-200 rounded-lg text-sm text-blue-600 font-bold hover:bg-blue-50 transition">View Details</button>
                        </div>

                        <div class="grid grid-cols-2 md:grid-cols-4 gap-4">
                            <div class="metric-box">
                                <p class="text-xs text-slate-400 uppercase font-bold tracking-wider">Pipeline</p>
                                <p class="text-lg font-bold text-slate-800 mt-1">450 km</p>
                                <p class="text-xs text-green-500 font-medium">Monitored</p>
                            </div>
                            <div class="metric-box">
                                <p class="text-xs text-slate-400 uppercase font-bold tracking-wider">Quality</p>
                                <p class="text-lg font-bold text-slate-800 mt-1">98%</p>
                                <p class="text-xs text-green-500 font-medium">Safe</p>
                            </div>
                            <div class="metric-box bg-orange-50 border-orange-100">
                                <p class="text-xs text-orange-400 uppercase font-bold tracking-wider">Leakages</p>
                                <p class="text-lg font-bold text-orange-600 mt-1">8</p>
                                <p class="text-xs text-orange-400 font-medium">Repairing</p>
                            </div>
                            <div class="metric-box">
                                <p class="text-xs text-slate-400 uppercase font-bold tracking-wider">Staff On-Duty</p>
                                <p class="text-lg font-bold text-slate-800 mt-1">30 / 32</p>
                                <p class="text-xs text-blue-500 font-medium">Full Strength</p>
                            </div>
                        </div>
                    </div>

                    <div class="dept-header p-6 border-l-4 border-l-green-500">
                        <div class="flex justify-between items-start mb-6">
                            <div class="flex items-center gap-4">
                                <div class="w-12 h-12 bg-green-50 rounded-xl flex items-center justify-center text-green-600 border border-green-100 shadow-sm">
                                    <i class="fa-solid fa-trash-can text-2xl"></i>
                                </div>
                                <div>
                                    <h3 class="text-xl font-bold text-slate-800">Sanitation & Waste</h3>
                                    <p class="text-sm text-slate-500">Garbage Collection & Public Hygiene</p>
                                </div>
                            </div>
                            <button class="px-4 py-2 border border-slate-200 rounded-lg text-sm text-blue-600 font-bold hover:bg-blue-50 transition">View Details</button>
                        </div>

                        <div class="grid grid-cols-2 md:grid-cols-4 gap-4">
                            <div class="metric-box">
                                <p class="text-xs text-slate-400 uppercase font-bold tracking-wider">Collection Pts</p>
                                <p class="text-lg font-bold text-slate-800 mt-1">850</p>
                                <p class="text-xs text-green-500 font-medium">Mapped</p>
                            </div>
                            <div class="metric-box">
                                <p class="text-xs text-slate-400 uppercase font-bold tracking-wider">Trucks Active</p>
                                <p class="text-lg font-bold text-slate-800 mt-1">42</p>
                                <p class="text-xs text-slate-400 font-medium">GPS Tracked</p>
                            </div>
                            <div class="metric-box">
                                <p class="text-xs text-slate-400 uppercase font-bold tracking-wider">Missed</p>
                                <p class="text-lg font-bold text-slate-800 mt-1">5</p>
                                <p class="text-xs text-green-500 font-medium">Low Rate</p>
                            </div>
                            <div class="metric-box">
                                <p class="text-xs text-slate-400 uppercase font-bold tracking-wider">Staff On-Duty</p>
                                <p class="text-lg font-bold text-slate-800 mt-1">110 / 120</p>
                                <p class="text-xs text-blue-500 font-medium">High Turnout</p>
                            </div>
                        </div>
                    </div>

                </main>
            </div>
        </div>

        <script>
            function toggleSidebar() {
                const sidebar = document.getElementById('mobileSidebar');
                if (sidebar.classList.contains('-translate-x-full')) {
                    sidebar.classList.remove('-translate-x-full');
                } else {
                    sidebar.classList.add('-translate-x-full');
                }
            }
        </script>
    </form>
</body>
</html>