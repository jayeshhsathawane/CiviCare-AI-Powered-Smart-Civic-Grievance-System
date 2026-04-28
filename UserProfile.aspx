<%@ Page Language="C#" AutoEventWireup="true" CodeFile="UserProfile.aspx.cs" Inherits="UserProfile" %>



<!DOCTYPE html>
<html xmlns="http://www.w3.org/1999/xhtml" lang="en">
<head runat="server">
    <title>My Profile | CiviCare System</title>
    <meta name="viewport" content="width=device-width, initial-scale=1.0" />
    
    <script src="https://cdn.tailwindcss.com"></script>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css" />
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@300;400;500;600;700;800&display=swap" rel="stylesheet" />

    <style>
        body { font-family: 'Inter', sans-serif; background-color: #f8fafc; }
        .no-scrollbar::-webkit-scrollbar { display: none; }
        .no-scrollbar { -ms-overflow-style: none; }

        .nav-link { border-radius: 8px; transition: all 0.2s ease-in-out; color: #64748b; font-weight: 500; }
        .nav-link:hover { background-color: #f1f5f9; color: #1e293b; }
        
        /* Active states for different departments */
        .nav-link.active-blue { background-color: #eff6ff; color: #2563eb; font-weight: 600; }
        .nav-link.active-orange { background-color: #fff7ed; color: #ea580c; font-weight: 600; }
        .nav-link.active-green { background-color: #f0fdf4; color: #16a34a; font-weight: 600; }

        .input-field { width: 100%; padding: 0.6rem 1rem 0.6rem 2.5rem; border: 1px solid #cbd5e1; border-radius: 8px; outline: none; transition: all 0.2s; color: #334155; font-size: 0.875rem; background-color: #fff; }
        .input-field:focus { border-color: #3b82f6; box-shadow: 0 0 0 3px rgba(59, 130, 246, 0.15); }
        .input-field:disabled { background-color: #f1f5f9; cursor: not-allowed; color: #94a3b8; }
        .input-icon { position: absolute; left: 1rem; top: 50%; transform: translateY(-50%); color: #94a3b8; font-size: 0.85rem; }

        /* Toast Animations */
        @keyframes slideInRight { from { transform: translateX(100%); opacity: 0; } to { transform: translateX(0); opacity: 1; } }
        @keyframes fadeOutUp { from { opacity: 1; transform: translateY(0); } to { opacity: 0; transform: translateY(-20px); } }
        .toast-enter { animation: slideInRight 0.4s cubic-bezier(0.16, 1, 0.3, 1) forwards; }
        .toast-exit { animation: fadeOutUp 0.4s ease forwards; }

        @keyframes popIn { from { opacity: 0; transform: scale(0.98) translateY(10px); } to { opacity: 1; transform: scale(1) translateY(0); } }
        .profile-card { animation: popIn 0.3s cubic-bezier(0.16, 1, 0.3, 1) forwards; }
        
        .mobile-sidebar { transition: transform 0.3s ease-in-out; }
    </style>
</head>
<body class="text-slate-700 antialiased overflow-hidden">
    <div id="toast-container" class="fixed top-5 right-5 z-[99999] flex flex-col gap-3 pointer-events-none"></div>

    <form id="form1" runat="server">
        <asp:ScriptManager runat="server" />

        <div class="flex h-screen overflow-hidden">
            
            <asp:Panel ID="pnlCitizen" runat="server" Visible="false">
                <aside class="hidden md:flex w-72 flex-col bg-white border-r border-slate-200 z-20 shadow-sm relative">
                    <div class="h-20 flex items-center px-8 border-b border-slate-100">
                        <div class="flex items-center gap-3">
                            <div class="w-9 h-9 bg-blue-600 rounded-lg flex items-center justify-center text-white text-xl shadow-lg shadow-blue-200">
                                <i class="fa-solid fa-city"></i>
                            </div>
                            <span class="text-xl font-bold tracking-tight text-slate-800">Civi<span class="text-blue-600">Care</span></span>
                        </div>
                    </div>
                    <nav class="flex-1 py-6 px-4 space-y-1.5 overflow-y-auto no-scrollbar">
                        <p class="px-4 text-xs font-bold text-slate-400 uppercase tracking-widest mb-3">Main Menu</p>
                        <a href="CitizenDashboard.aspx" class="nav-link flex items-center px-4 py-3 text-sm"><i class="fa-solid fa-house w-6 opacity-75"></i> Home Dashboard</a>
                        <a href="ReportIssue.aspx" class="nav-link flex items-center px-4 py-3 text-sm"><i class="fa-solid fa-camera w-6 opacity-75"></i> Report New Issue</a>
                        <a href="MyComplaints.aspx" class="nav-link flex items-center px-4 py-3 text-sm"><i class="fa-solid fa-magnifying-glass-location w-6 opacity-75"></i> Track Complaints</a>
                        <a href="CityAlerts.aspx" class="nav-link flex items-center px-4 py-3 text-sm"><i class="fa-solid fa-bullhorn w-6 opacity-75"></i> City Alerts</a>
                        <p class="px-4 text-xs font-bold text-slate-400 uppercase tracking-widest mt-8 mb-3">Account</p>
                        <a href="Profile.aspx" class="nav-link active-blue flex items-center px-4 py-3 text-sm"><i class="fa-solid fa-user-gear w-6 opacity-75"></i> My Profile</a>
                        <a href="/SystemLogin.aspx?action=logout" class="nav-link flex items-center px-4 py-3 text-sm text-red-500 hover:bg-red-50 hover:text-red-600 mt-2"><i class="fa-solid fa-right-from-bracket w-6 opacity-75"></i> Secure Logout</a>
                    </nav>
                </aside>
                <div class="mobile-sidebar fixed inset-y-0 left-0 w-72 bg-white shadow-2xl z-50 transform -translate-x-full md:hidden flex flex-col border-r border-slate-200">
                    <div class="h-20 flex items-center justify-between px-6 border-b border-slate-100">
                        <div class="flex items-center gap-3">
                            <div class="w-9 h-9 bg-blue-600 rounded-lg flex items-center justify-center text-white text-xl shadow-lg shadow-blue-200"><i class="fa-solid fa-city"></i></div>
                            <span class="text-xl font-bold tracking-tight text-slate-800">Civi<span class="text-blue-600">Care</span></span>
                        </div>
                        <button type="button" onclick="toggleSidebar()" class="text-slate-400 hover:text-red-500 transition text-2xl"><i class="fa-solid fa-xmark"></i></button>
                    </div>
                    <nav class="flex-1 py-6 px-4 space-y-1.5 overflow-y-auto no-scrollbar">
                        <p class="px-4 text-xs font-bold text-slate-400 uppercase tracking-widest mb-3">Main Menu</p>
                        <a href="CitizenDashboard.aspx" class="nav-link flex items-center px-4 py-3 text-sm"><i class="fa-solid fa-house w-6 opacity-75"></i> Home Dashboard</a>
                        <a href="ReportIssue.aspx" class="nav-link flex items-center px-4 py-3 text-sm"><i class="fa-solid fa-camera w-6 opacity-75"></i> Report New Issue</a>
                        <a href="MyComplaints.aspx" class="nav-link flex items-center px-4 py-3 text-sm"><i class="fa-solid fa-magnifying-glass-location w-6 opacity-75"></i> Track Complaints</a>
                        <a href="CityAlerts.aspx" class="nav-link flex items-center px-4 py-3 text-sm"><i class="fa-solid fa-bullhorn w-6 opacity-75"></i> City Alerts</a>
                        <p class="px-4 text-xs font-bold text-slate-400 uppercase tracking-widest mt-8 mb-3">Account</p>
                        <a href="Profile.aspx" class="nav-link active-blue flex items-center px-4 py-3 text-sm"><i class="fa-solid fa-user-gear w-6 opacity-75"></i> My Profile</a>
                        <a href="/SystemLogin.aspx?action=logout" class="nav-link flex items-center px-4 py-3 text-sm text-red-500 hover:bg-red-50 hover:text-red-600 mt-2"><i class="fa-solid fa-right-from-bracket w-6 opacity-75"></i> Secure Logout</a>
                    </nav>
                </div>
            </asp:Panel>

            <asp:Panel ID="pnlAdmin" runat="server" Visible="false">
                <aside class="hidden md:flex w-72 flex-col bg-white border-r border-slate-200 z-20 shadow-sm relative">
                    <div class="h-20 flex items-center px-8 border-b border-slate-100">
                        <div class="flex items-center gap-3">
                            <div class="w-9 h-9 bg-blue-600 rounded-lg flex items-center justify-center text-white text-xl shadow-lg shadow-blue-200"><i class="fa-solid fa-city"></i></div>
                            <span class="text-xl font-bold tracking-tight text-slate-800">Civi<span class="text-blue-600">Care</span></span>
                        </div>
                    </div>
                    <nav class="flex-1 py-6 px-4 space-y-1.5 overflow-y-auto no-scrollbar">
                        <p class="px-4 text-xs font-bold text-slate-400 uppercase tracking-widest mb-3">Overview</p>
                        <a href="AdminDashboard.aspx" class="nav-link flex items-center px-4 py-3 text-sm"><i class="fa-solid fa-chart-pie w-6 opacity-75"></i> Dashboard</a>
                        <a href="ManageUsers.aspx" class="nav-link flex items-center px-4 py-3 text-sm"><i class="fa-solid fa-users w-6 opacity-75"></i> User Management</a>
                        <a href="Departments.aspx" class="nav-link flex items-center px-4 py-3 text-sm"><i class="fa-solid fa-building w-6 opacity-75"></i> Departments</a>
                        <a href="Reports.aspx" class="nav-link flex items-center px-4 py-3 text-sm"><i class="fa-solid fa-file-invoice w-6 opacity-75"></i> Reports & Data</a>
                        <p class="px-4 text-xs font-bold text-slate-400 uppercase tracking-widest mt-8 mb-3">System</p>
                        <a href="#" class="nav-link flex items-center px-4 py-3 text-sm"><i class="fa-solid fa-gear w-6 opacity-75"></i> Configuration</a>
                        <a href="Profile.aspx" class="nav-link active-blue flex items-center px-4 py-3 text-sm"><i class="fa-solid fa-user-shield w-6 opacity-75"></i> Admin Profile</a>
                        <a href="/SystemLogin.aspx?action=logout" class="nav-link flex items-center px-4 py-3 text-sm text-red-500 hover:bg-red-50 hover:text-red-600 mt-2"><i class="fa-solid fa-right-from-bracket w-6 opacity-75"></i> Logout</a>
                    </nav>
                </aside>
                <div class="mobile-sidebar fixed inset-y-0 left-0 w-72 bg-white shadow-2xl z-50 transform -translate-x-full md:hidden flex flex-col border-r border-slate-200">
                    <div class="h-20 flex items-center justify-between px-6 border-b border-slate-100">
                        <div class="flex items-center gap-3">
                            <div class="w-9 h-9 bg-blue-600 rounded-lg flex items-center justify-center text-white text-xl shadow-lg shadow-blue-200"><i class="fa-solid fa-city"></i></div>
                            <span class="text-xl font-bold tracking-tight text-slate-800">Civi<span class="text-blue-600">Care</span></span>
                        </div>
                        <button type="button" onclick="toggleSidebar()" class="text-slate-400 hover:text-red-500 transition text-2xl"><i class="fa-solid fa-xmark"></i></button>
                    </div>
                    <nav class="flex-1 py-6 px-4 space-y-1.5 overflow-y-auto no-scrollbar">
                        <p class="px-4 text-xs font-bold text-slate-400 uppercase tracking-widest mb-3">Overview</p>
                        <a href="AdminDashboard.aspx" class="nav-link flex items-center px-4 py-3 text-sm"><i class="fa-solid fa-chart-pie w-6 opacity-75"></i> Dashboard</a>
                        <a href="ManageUsers.aspx" class="nav-link flex items-center px-4 py-3 text-sm"><i class="fa-solid fa-users w-6 opacity-75"></i> User Management</a>
                        <a href="Departments.aspx" class="nav-link flex items-center px-4 py-3 text-sm"><i class="fa-solid fa-building w-6 opacity-75"></i> Departments</a>
                        <a href="Reports.aspx" class="nav-link flex items-center px-4 py-3 text-sm"><i class="fa-solid fa-file-invoice w-6 opacity-75"></i> Reports & Data</a>
                        <p class="px-4 text-xs font-bold text-slate-400 uppercase tracking-widest mt-8 mb-3">System</p>
                        <a href="#" class="nav-link flex items-center px-4 py-3 text-sm"><i class="fa-solid fa-gear w-6 opacity-75"></i> Configuration</a>
                        <a href="Profile.aspx" class="nav-link active-blue flex items-center px-4 py-3 text-sm"><i class="fa-solid fa-user-shield w-6 opacity-75"></i> Admin Profile</a>
                        <a href="/SystemLogin.aspx?action=logout" class="nav-link flex items-center px-4 py-3 text-sm text-red-500 hover:bg-red-50 hover:text-red-600 mt-2"><i class="fa-solid fa-right-from-bracket w-6 opacity-75"></i> Logout</a>
                    </nav>
                </div>
            </asp:Panel>

            <asp:Panel ID="pnlWater" runat="server" Visible="false">
                <aside class="hidden md:flex w-72 flex-col bg-white border-r border-slate-200 z-20 shadow-sm relative">
                    <div class="h-20 flex items-center px-8 border-b border-slate-100">
                        <div class="flex items-center gap-3">
                            <div class="w-9 h-9 bg-blue-600 rounded-lg flex items-center justify-center text-white text-xl shadow-lg shadow-blue-200"><i class="fa-solid fa-faucet-drip"></i></div>
                            <span class="text-xl font-bold tracking-tight text-slate-800">Water<span class="text-blue-600">Dept</span></span>
                        </div>
                    </div>
                    <nav class="flex-1 py-6 px-4 space-y-1.5 overflow-y-auto no-scrollbar">
                        <p class="px-4 text-xs font-bold text-slate-400 uppercase tracking-widest mb-3">Operations</p>
                        <a href="WaterDeptDashboard.aspx" class="nav-link flex items-center px-4 py-3 text-sm"><i class="fa-solid fa-clipboard-list w-6 opacity-75"></i> Active Complaints</a>
                        <a href="PipelineNetwork.aspx" class="nav-link flex items-center px-4 py-3 text-sm"><i class="fa-solid fa-diagram-project w-6 opacity-75"></i> Pipeline Network</a>
                        <a href="WaterQuality.aspx" class="nav-link flex items-center px-4 py-3 text-sm"><i class="fa-solid fa-water w-6 opacity-75"></i> Water Quality Data</a>
                        <a href="ResolvedHistory.aspx" class="nav-link flex items-center px-4 py-3 text-sm"><i class="fa-solid fa-check-double w-6 opacity-75"></i> Resolved History</a>
                        <p class="px-4 text-xs font-bold text-slate-400 uppercase tracking-widest mt-8 mb-3">Management</p>
                        <a href="TankerDispatch.aspx" class="nav-link flex items-center px-4 py-3 text-sm"><i class="fa-solid fa-truck-droplet w-6 opacity-75"></i> Tanker Dispatch</a>
                        <a href="FieldStaff.aspx" class="nav-link flex items-center px-4 py-3 text-sm"><i class="fa-solid fa-users-gear w-6 opacity-75"></i> Field Staff</a>
                        <p class="px-4 text-xs font-bold text-slate-400 uppercase tracking-widest mt-8 mb-3">Account</p>
                        <a href="Profile.aspx" class="nav-link active-blue flex items-center px-4 py-3 text-sm"><i class="fa-solid fa-user-gear w-6 opacity-75"></i> My Profile</a>
                        <a href="/SystemLogin.aspx?action=logout" class="nav-link flex items-center px-4 py-3 text-sm text-red-500 hover:bg-red-50 hover:text-red-600 mt-2"><i class="fa-solid fa-right-from-bracket w-6 opacity-75"></i> Logout</a>
                    </nav>
                </aside>
                <div class="mobile-sidebar fixed inset-y-0 left-0 w-72 bg-white shadow-2xl z-50 transform -translate-x-full md:hidden flex flex-col border-r border-slate-200">
                    <div class="h-20 flex items-center justify-between px-6 border-b border-slate-100">
                        <div class="flex items-center gap-3">
                            <div class="w-9 h-9 bg-blue-600 rounded-lg flex items-center justify-center text-white text-xl shadow-lg shadow-blue-200"><i class="fa-solid fa-faucet-drip"></i></div>
                            <span class="text-xl font-bold tracking-tight text-slate-800">Water<span class="text-blue-600">Dept</span></span>
                        </div>
                        <button type="button" onclick="toggleSidebar()" class="text-slate-400 hover:text-red-500 transition text-2xl"><i class="fa-solid fa-xmark"></i></button>
                    </div>
                    <nav class="flex-1 py-6 px-4 space-y-1.5 overflow-y-auto no-scrollbar">
                        <p class="px-4 text-xs font-bold text-slate-400 uppercase tracking-widest mb-3">Operations</p>
                        <a href="WaterDeptDashboard.aspx" class="nav-link flex items-center px-4 py-3 text-sm"><i class="fa-solid fa-clipboard-list w-6 opacity-75"></i> Active Complaints</a>
                        <a href="PipelineNetwork.aspx" class="nav-link flex items-center px-4 py-3 text-sm"><i class="fa-solid fa-diagram-project w-6 opacity-75"></i> Pipeline Network</a>
                        <a href="WaterQuality.aspx" class="nav-link flex items-center px-4 py-3 text-sm"><i class="fa-solid fa-water w-6 opacity-75"></i> Water Quality Data</a>
                        <a href="ResolvedHistory.aspx" class="nav-link flex items-center px-4 py-3 text-sm"><i class="fa-solid fa-check-double w-6 opacity-75"></i> Resolved History</a>
                        <p class="px-4 text-xs font-bold text-slate-400 uppercase tracking-widest mt-8 mb-3">Management</p>
                        <a href="TankerDispatch.aspx" class="nav-link flex items-center px-4 py-3 text-sm"><i class="fa-solid fa-truck-droplet w-6 opacity-75"></i> Tanker Dispatch</a>
                        <a href="FieldStaff.aspx" class="nav-link flex items-center px-4 py-3 text-sm"><i class="fa-solid fa-users-gear w-6 opacity-75"></i> Field Staff</a>
                        <p class="px-4 text-xs font-bold text-slate-400 uppercase tracking-widest mt-8 mb-3">Account</p>
                        <a href="Profile.aspx" class="nav-link active-blue flex items-center px-4 py-3 text-sm"><i class="fa-solid fa-user-gear w-6 opacity-75"></i> My Profile</a>
                        <a href="/SystemLogin.aspx?action=logout" class="nav-link flex items-center px-4 py-3 text-sm text-red-500 hover:bg-red-50 hover:text-red-600 mt-2"><i class="fa-solid fa-right-from-bracket w-6 opacity-75"></i> Logout</a>
                    </nav>
                </div>
            </asp:Panel>

            <asp:Panel ID="pnlElectric" runat="server" Visible="false">
                <aside class="hidden md:flex w-72 flex-col bg-white border-r border-slate-200 z-20 shadow-sm relative">
                    <div class="h-20 flex items-center px-8 border-b border-slate-100">
                        <div class="flex items-center gap-3">
                            <div class="w-9 h-9 bg-orange-500 rounded-lg flex items-center justify-center text-white text-xl shadow-lg shadow-orange-200"><i class="fa-solid fa-bolt"></i></div>
                            <span class="text-xl font-bold tracking-tight text-slate-800">Electric<span class="text-orange-500">Dept</span></span>
                        </div>
                    </div>
                    <nav class="flex-1 py-6 px-4 space-y-1.5 overflow-y-auto no-scrollbar">
                        <p class="px-4 text-xs font-bold text-slate-400 uppercase tracking-widest mb-3">Operations</p>
                        <a href="ElectricDeptDashboard.aspx" class="nav-link flex items-center px-4 py-3 text-sm"><i class="fa-solid fa-clipboard-list w-6 opacity-75"></i> Active Tasks</a>
                        <a href="PowerGridStatus.aspx" class="nav-link flex items-center px-4 py-3 text-sm"><i class="fa-solid fa-tower-observation w-6 opacity-75"></i> Power Grid Status</a>
                        <a href="MaintenanceSchedule.aspx" class="nav-link flex items-center px-4 py-3 text-sm"><i class="fa-solid fa-screwdriver-wrench w-6 opacity-75"></i> Maintenance Schedule</a>
                        <a href="ElectricResolvedHistory.aspx" class="nav-link flex items-center px-4 py-3 text-sm"><i class="fa-solid fa-check-double w-6 opacity-75"></i> Resolved History</a>
                        <p class="px-4 text-xs font-bold text-slate-400 uppercase tracking-widest mt-8 mb-3">Management</p>
                        <a href="DispatchUnits.aspx" class="nav-link flex items-center px-4 py-3 text-sm"><i class="fa-solid fa-truck-fast w-6 opacity-75"></i> Dispatch Units</a>
                        <a href="ElectricFieldStaff.aspx" class="nav-link flex items-center px-4 py-3 text-sm"><i class="fa-solid fa-users-gear w-6 opacity-75"></i> Field Staff</a>
                        <p class="px-4 text-xs font-bold text-slate-400 uppercase tracking-widest mt-8 mb-3">Account</p>
                        <a href="Profile.aspx" class="nav-link active-orange flex items-center px-4 py-3 text-sm"><i class="fa-solid fa-user-gear w-6 opacity-75"></i> My Profile</a>
                        <a href="/SystemLogin.aspx?action=logout" class="nav-link flex items-center px-4 py-3 text-sm text-red-500 hover:bg-red-50 hover:text-red-600 mt-2"><i class="fa-solid fa-right-from-bracket w-6 opacity-75"></i> Logout</a>
                    </nav>
                </aside>
                <div class="mobile-sidebar fixed inset-y-0 left-0 w-72 bg-white shadow-2xl z-50 transform -translate-x-full md:hidden flex flex-col border-r border-slate-200">
                    <div class="h-20 flex items-center justify-between px-6 border-b border-slate-100">
                        <div class="flex items-center gap-3">
                            <div class="w-9 h-9 bg-orange-500 rounded-lg flex items-center justify-center text-white text-xl shadow-lg shadow-orange-200"><i class="fa-solid fa-bolt"></i></div>
                            <span class="text-xl font-bold tracking-tight text-slate-800">Electric<span class="text-orange-500">Dept</span></span>
                        </div>
                        <button type="button" onclick="toggleSidebar()" class="text-slate-400 hover:text-red-500 transition text-2xl"><i class="fa-solid fa-xmark"></i></button>
                    </div>
                    <nav class="flex-1 py-6 px-4 space-y-1.5 overflow-y-auto no-scrollbar">
                        <p class="px-4 text-xs font-bold text-slate-400 uppercase tracking-widest mb-3">Operations</p>
                        <a href="ElectricDeptDashboard.aspx" class="nav-link flex items-center px-4 py-3 text-sm"><i class="fa-solid fa-clipboard-list w-6 opacity-75"></i> Active Tasks</a>
                        <a href="PowerGridStatus.aspx" class="nav-link flex items-center px-4 py-3 text-sm"><i class="fa-solid fa-tower-observation w-6 opacity-75"></i> Power Grid Status</a>
                        <a href="MaintenanceSchedule.aspx" class="nav-link flex items-center px-4 py-3 text-sm"><i class="fa-solid fa-screwdriver-wrench w-6 opacity-75"></i> Maintenance Schedule</a>
                        <a href="ElectricResolvedHistory.aspx" class="nav-link flex items-center px-4 py-3 text-sm"><i class="fa-solid fa-check-double w-6 opacity-75"></i> Resolved History</a>
                        <p class="px-4 text-xs font-bold text-slate-400 uppercase tracking-widest mt-8 mb-3">Management</p>
                        <a href="DispatchUnits.aspx" class="nav-link flex items-center px-4 py-3 text-sm"><i class="fa-solid fa-truck-fast w-6 opacity-75"></i> Dispatch Units</a>
                        <a href="ElectricFieldStaff.aspx" class="nav-link flex items-center px-4 py-3 text-sm"><i class="fa-solid fa-users-gear w-6 opacity-75"></i> Field Staff</a>
                        <p class="px-4 text-xs font-bold text-slate-400 uppercase tracking-widest mt-8 mb-3">Account</p>
                        <a href="Profile.aspx" class="nav-link active-orange flex items-center px-4 py-3 text-sm"><i class="fa-solid fa-user-gear w-6 opacity-75"></i> My Profile</a>
                        <a href="/SystemLogin.aspx?action=logout" class="nav-link flex items-center px-4 py-3 text-sm text-red-500 hover:bg-red-50 hover:text-red-600 mt-2"><i class="fa-solid fa-right-from-bracket w-6 opacity-75"></i> Logout</a>
                    </nav>
                </div>
            </asp:Panel>

            <asp:Panel ID="pnlSanitation" runat="server" Visible="false">
                <aside class="hidden md:flex w-72 flex-col bg-white border-r border-slate-200 z-20 shadow-sm relative">
                    <div class="h-20 flex items-center px-8 border-b border-slate-100">
                        <div class="flex items-center gap-3">
                            <div class="w-9 h-9 bg-green-600 rounded-lg flex items-center justify-center text-white text-xl shadow-lg shadow-green-200"><i class="fa-solid fa-trash-can"></i></div>
                            <span class="text-xl font-bold tracking-tight text-slate-800">Sanitation<span class="text-green-600">Dept</span></span>
                        </div>
                    </div>
                    <nav class="flex-1 py-6 px-4 space-y-1.5 overflow-y-auto no-scrollbar">
                        <p class="px-4 text-xs font-bold text-slate-400 uppercase tracking-widest mb-3">Operations</p>
                        <a href="SanitationDeptDashboard.aspx" class="nav-link flex items-center px-4 py-3 text-sm"><i class="fa-solid fa-clipboard-list w-6 opacity-75"></i> Active Complaints</a>
                        <a href="CollectionRoutes.aspx" class="nav-link flex items-center px-4 py-3 text-sm"><i class="fa-solid fa-route w-6 opacity-75"></i> Collection Routes</a>
                        <a href="DumpYardStatus.aspx" class="nav-link flex items-center px-4 py-3 text-sm"><i class="fa-solid fa-dumpster w-6 opacity-75"></i> Dump Yard Status</a>
                        <a href="SanitationResolvedHistory.aspx" class="nav-link flex items-center px-4 py-3 text-sm"><i class="fa-solid fa-check-double w-6 opacity-75"></i> Resolved History</a>
                        <p class="px-4 text-xs font-bold text-slate-400 uppercase tracking-widest mt-8 mb-3">Management</p>
                        <a href="DispatchTrucks.aspx" class="nav-link flex items-center px-4 py-3 text-sm"><i class="fa-solid fa-truck w-6 opacity-75"></i> Dispatch Trucks</a>
                        <a href="SanitationStaff.aspx" class="nav-link flex items-center px-4 py-3 text-sm"><i class="fa-solid fa-users-gear w-6 opacity-75"></i> Field Staff</a>
                        <p class="px-4 text-xs font-bold text-slate-400 uppercase tracking-widest mt-8 mb-3">Account</p>
                        <a href="Profile.aspx" class="nav-link active-green flex items-center px-4 py-3 text-sm"><i class="fa-solid fa-user-gear w-6 opacity-75"></i> My Profile</a>
                        <a href="/SystemLogin.aspx?action=logout" class="nav-link flex items-center px-4 py-3 text-sm text-red-500 hover:bg-red-50 hover:text-red-600 mt-2"><i class="fa-solid fa-right-from-bracket w-6 opacity-75"></i> Logout</a>
                    </nav>
                </aside>
                <div class="mobile-sidebar fixed inset-y-0 left-0 w-72 bg-white shadow-2xl z-50 transform -translate-x-full md:hidden flex flex-col border-r border-slate-200">
                    <div class="h-20 flex items-center justify-between px-6 border-b border-slate-100">
                        <div class="flex items-center gap-3">
                            <div class="w-9 h-9 bg-green-600 rounded-lg flex items-center justify-center text-white text-xl shadow-lg shadow-green-200"><i class="fa-solid fa-trash-can"></i></div>
                            <span class="text-xl font-bold tracking-tight text-slate-800">Sanitation<span class="text-green-600">Dept</span></span>
                        </div>
                        <button type="button" onclick="toggleSidebar()" class="text-slate-400 hover:text-red-500 transition text-2xl"><i class="fa-solid fa-xmark"></i></button>
                    </div>
                    <nav class="flex-1 py-6 px-4 space-y-1.5 overflow-y-auto no-scrollbar">
                        <p class="px-4 text-xs font-bold text-slate-400 uppercase tracking-widest mb-3">Operations</p>
                        <a href="SanitationDeptDashboard.aspx" class="nav-link flex items-center px-4 py-3 text-sm"><i class="fa-solid fa-clipboard-list w-6 opacity-75"></i> Active Complaints</a>
                        <a href="CollectionRoutes.aspx" class="nav-link flex items-center px-4 py-3 text-sm"><i class="fa-solid fa-route w-6 opacity-75"></i> Collection Routes</a>
                        <a href="DumpYardStatus.aspx" class="nav-link flex items-center px-4 py-3 text-sm"><i class="fa-solid fa-dumpster w-6 opacity-75"></i> Dump Yard Status</a>
                        <a href="SanitationResolvedHistory.aspx" class="nav-link flex items-center px-4 py-3 text-sm"><i class="fa-solid fa-check-double w-6 opacity-75"></i> Resolved History</a>
                        <p class="px-4 text-xs font-bold text-slate-400 uppercase tracking-widest mt-8 mb-3">Management</p>
                        <a href="DispatchTrucks.aspx" class="nav-link flex items-center px-4 py-3 text-sm"><i class="fa-solid fa-truck w-6 opacity-75"></i> Dispatch Trucks</a>
                        <a href="SanitationStaff.aspx" class="nav-link flex items-center px-4 py-3 text-sm"><i class="fa-solid fa-users-gear w-6 opacity-75"></i> Field Staff</a>
                        <p class="px-4 text-xs font-bold text-slate-400 uppercase tracking-widest mt-8 mb-3">Account</p>
                        <a href="Profile.aspx" class="nav-link active-green flex items-center px-4 py-3 text-sm"><i class="fa-solid fa-user-gear w-6 opacity-75"></i> My Profile</a>
                        <a href="/SystemLogin.aspx?action=logout" class="nav-link flex items-center px-4 py-3 text-sm text-red-500 hover:bg-red-50 hover:text-red-600 mt-2"><i class="fa-solid fa-right-from-bracket w-6 opacity-75"></i> Logout</a>
                    </nav>
                </div>
            </asp:Panel>


            <div class="flex-1 flex flex-col overflow-hidden bg-slate-50 relative">
                
                <header class="h-20 bg-white border-b border-slate-200 flex items-center justify-between px-6 md:px-10 shadow-sm z-10 sticky top-0">
                    <div class="flex items-center gap-4">
                        <button type="button" class="md:hidden text-slate-600 hover:text-blue-600" onclick="toggleSidebar()">
                            <i class="fa-solid fa-bars text-2xl"></i>
                        </button>
                        <h2 class="text-xl md:text-2xl font-bold text-slate-800">Account Settings</h2>
                    </div>
                </header>

                <main class="flex-1 overflow-y-auto p-4 md:p-8 flex items-start justify-center relative">
                    
                    <asp:UpdatePanel runat="server" UpdateMode="Conditional" class="w-full max-w-3xl relative z-10 mt-2 md:mt-6">
                        <ContentTemplate>
                            
                            <div class="bg-white rounded-xl shadow-sm border border-slate-200 overflow-hidden profile-card">
                                
                                <div class="bg-slate-50 px-6 py-5 border-b border-slate-100 flex justify-between items-center">
                                    <div class="flex items-center gap-4">
                                        <div class="w-14 h-14 rounded-full bg-blue-100 text-blue-600 border border-blue-200 flex items-center justify-center text-xl font-bold shadow-sm">
                                            <asp:Literal ID="litInitials" runat="server"></asp:Literal>
                                        </div>
                                        <div>
                                            <h2 class="text-lg font-bold text-slate-800 tracking-tight"><asp:Literal ID="litTopName" runat="server"></asp:Literal></h2>
                                            <p class="text-xs text-slate-500 mt-0.5 flex items-center gap-1.5 font-medium">
                                                <i class="fa-solid fa-envelope text-slate-400"></i> <asp:Literal ID="litTopEmail" runat="server"></asp:Literal>
                                            </p>
                                        </div>
                                    </div>
                                    <div class="hidden sm:block text-right">
                                        <span class="bg-white px-3 py-1.5 rounded-md text-[10px] font-bold uppercase tracking-wider border border-slate-200 text-slate-600 shadow-sm">
                                            <asp:Literal ID="litRoleBadge" runat="server"></asp:Literal>
                                        </span>
                                    </div>
                                </div>

                                <div class="p-6 md:p-8 grid grid-cols-1 md:grid-cols-2 gap-8">
                                    
                                    <div class="space-y-4">
                                        <div class="flex items-center gap-2 mb-3 pb-2 border-b border-slate-100">
                                            <i class="fa-solid fa-user-pen text-blue-500 text-base"></i>
                                            <h3 class="font-bold text-slate-700 text-sm uppercase tracking-wide">Personal Details</h3>
                                        </div>

                                        <div id="divStaffNotice" runat="server" visible="false" class="bg-amber-50 border border-amber-200 p-2.5 rounded text-xs text-amber-800 mb-3 shadow-sm">
                                            <i class="fa-solid fa-circle-info mr-1"></i> Staff cannot change Name/Mobile. Contact Admin.
                                        </div>

                                        <div>
                                            <label class="block text-[10px] font-bold text-slate-500 mb-1 uppercase tracking-wide">Full Name</label>
                                            <div class="relative">
                                                <i class="fa-solid fa-user input-icon"></i>
                                                <asp:TextBox ID="txtFullName" runat="server" CssClass="input-field" placeholder="Your Name"></asp:TextBox>
                                            </div>
                                        </div>

                                        <div>
                                            <label class="block text-[10px] font-bold text-slate-500 mb-1 uppercase tracking-wide">Registered Email <span class="font-normal lowercase">(read-only)</span></label>
                                            <div class="relative">
                                                <i class="fa-solid fa-envelope input-icon"></i>
                                                <asp:TextBox ID="txtEmail" runat="server" CssClass="input-field" Enabled="false"></asp:TextBox>
                                            </div>
                                        </div>

                                        <div>
                                            <label class="block text-[10px] font-bold text-slate-500 mb-1 uppercase tracking-wide">Mobile Number</label>
                                            <div class="relative">
                                                <i class="fa-solid fa-phone input-icon"></i>
                                                <asp:TextBox ID="txtMobile" runat="server" MaxLength="10" CssClass="input-field" placeholder="10-digit mobile"></asp:TextBox>
                                            </div>
                                        </div>

                                        <div class="pt-2">
                                            <asp:Button ID="btnUpdateProfile" runat="server" Text="Save Details" OnClick="btnUpdateProfile_Click" CssClass="w-full bg-slate-800 hover:bg-slate-900 text-white font-bold py-2.5 rounded-lg shadow-sm transition text-xs cursor-pointer" />
                                        </div>
                                    </div>

                                    <div class="space-y-4 border-t md:border-t-0 md:border-l border-slate-100 md:pl-8 pt-5 md:pt-0">
                                        <div class="flex items-center gap-2 mb-3 pb-2 border-b border-slate-100">
                                            <i class="fa-solid fa-shield-halved text-emerald-500 text-base"></i>
                                            <h3 class="font-bold text-slate-700 text-sm uppercase tracking-wide">Security</h3>
                                        </div>

                                        <div>
                                            <label class="block text-[10px] font-bold text-slate-500 mb-1 uppercase tracking-wide">Current Password <span class="text-red-500">*</span></label>
                                            <div class="relative">
                                                <i class="fa-solid fa-lock input-icon"></i>
                                                <asp:TextBox ID="txtOldPass" runat="server" TextMode="Password" CssClass="input-field" placeholder="Current password" ValidationGroup="ChangePass"></asp:TextBox>
                                            </div>
                                            <asp:RequiredFieldValidator ID="rfvOld" runat="server" ControlToValidate="txtOldPass" ErrorMessage="Required" ValidationGroup="ChangePass" CssClass="text-red-500 text-[10px] font-bold mt-0.5 block" Display="Dynamic" />
                                        </div>

                                        <div>
                                            <label class="block text-[10px] font-bold text-slate-500 mb-1 uppercase tracking-wide">New Password <span class="text-red-500">*</span></label>
                                            <div class="relative">
                                                <i class="fa-solid fa-key input-icon"></i>
                                                <asp:TextBox ID="txtNewPass" runat="server" TextMode="Password" CssClass="input-field" placeholder="New password" ValidationGroup="ChangePass"></asp:TextBox>
                                            </div>
                                            <p class="text-[9px] text-slate-400 mt-1 font-medium">Min 6 chars, 1 Number, 1 Special Char.</p>
                                            <asp:RequiredFieldValidator ID="rfvNew" runat="server" ControlToValidate="txtNewPass" ErrorMessage="Required" ValidationGroup="ChangePass" CssClass="text-red-500 text-[10px] font-bold mt-0.5 block" Display="Dynamic" />
                                        </div>

                                        <div>
                                            <label class="block text-[10px] font-bold text-slate-500 mb-1 uppercase tracking-wide">Confirm Password <span class="text-red-500">*</span></label>
                                            <div class="relative">
                                                <i class="fa-solid fa-check-double input-icon"></i>
                                                <asp:TextBox ID="txtConfirmPass" runat="server" TextMode="Password" CssClass="input-field" placeholder="Verify password" ValidationGroup="ChangePass"></asp:TextBox>
                                            </div>
                                            <asp:CompareValidator ID="cvPass" runat="server" ControlToCompare="txtNewPass" ControlToValidate="txtConfirmPass" ErrorMessage="Passwords do not match!" ValidationGroup="ChangePass" CssClass="text-red-500 text-[10px] font-bold mt-0.5 block" Display="Dynamic" />
                                        </div>

                                        <div class="pt-2">
                                            <asp:Button ID="btnChangePassword" runat="server" Text="Update Password" OnClick="btnChangePassword_Click" ValidationGroup="ChangePass" CssClass="w-full bg-blue-600 hover:bg-blue-700 text-white font-bold py-2.5 rounded-lg shadow-sm transition text-xs cursor-pointer" />
                                        </div>
                                    </div>

                                </div>
                            </div>
                        </ContentTemplate>
                    </asp:UpdatePanel>

                </main>
            </div>
        </div>

        <script>
            function toggleSidebar() {
                // Find and toggle the active mobile sidebar
                const sidebars = document.querySelectorAll('.mobile-sidebar');
                sidebars.forEach(sidebar => {
                    sidebar.classList.toggle('-translate-x-full');
                });
            }

            function showToast(message, type) {
                const container = document.getElementById('toast-container');
                const toast = document.createElement('div');
                const isSuccess = type === 'success';
                const bgColor = isSuccess ? 'bg-emerald-600' : 'bg-red-600';
                const icon = isSuccess ? 'fa-circle-check' : 'fa-circle-exclamation';

                toast.className = "flex items-center gap-3 px-5 py-3.5 rounded-xl shadow-lg text-white text-sm font-bold toast-enter pointer-events-auto " + bgColor;
                toast.innerHTML = "<i class='fa-solid " + icon + " text-lg'></i> <span>" + message + "</span>";
                
                container.appendChild(toast);
                setTimeout(() => {
                    toast.classList.remove('toast-enter');
                    toast.classList.add('toast-exit');
                    setTimeout(() => { if(container.contains(toast)) container.removeChild(toast); }, 400);
                }, 3500); 
            }
        </script>
    </form>
</body>
</html>