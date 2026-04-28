<%@ Page Language="C#" AutoEventWireup="true" CodeFile="PowerGridStatus.aspx.cs" Inherits="PowerGridStatus" %>
<!DOCTYPE html>
<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title>Power Grid Status | Electric Dept</title>
    <meta name="viewport" content="width=device-width, initial-scale=1.0" />
    <script src="https://cdn.tailwindcss.com"></script>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css" />
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@300;400;500;600;700&display=swap" rel="stylesheet"/>
    <style>
        body { font-family: 'Inter', sans-serif; background-color: #f8fafc; }
        .no-scrollbar::-webkit-scrollbar { display: none; }
        .no-scrollbar { -ms-overflow-style: none;  }
        .nav-link { border-radius: 8px; transition: all 0.2s ease-in-out; color: #64748b; }
        .nav-link:hover { background-color: #f1f5f9; color: #1e293b; }
        .nav-link.active { background-color: #fff7ed; color: #ea580c; font-weight: 600; }
        .stat-card { background: white; border: 1px solid #e2e8f0; border-radius: 12px; box-shadow: 0 1px 3px 0 rgba(0,0,0,0.1); }
        .grid-bg { background-image: linear-gradient(to right, #e2e8f0 1px, transparent 1px), linear-gradient(to bottom, #e2e8f0 1px, transparent 1px); background-size: 40px 40px; }
    </style>
</head>
<body class="text-slate-600 antialiased">
    <form id="form1" runat="server">
        <div class="flex h-screen overflow-hidden">
            
            <aside class="hidden md:flex w-72 flex-col bg-white border-r border-slate-200 z-20">
                <div class="h-20 flex items-center px-8 border-b border-slate-100">
                    <div class="flex items-center gap-3">
                        <div class="w-9 h-9 bg-orange-500 rounded-lg flex items-center justify-center text-white text-xl shadow-lg shadow-orange-200">
                            <i class="fa-solid fa-bolt"></i>
                        </div>
                        <span class="text-xl font-bold tracking-tight text-slate-800">Electric<span class="text-orange-500">Dept</span></span>
                    </div>
                </div>
                <nav class="flex-1 py-6 px-4 space-y-1.5 overflow-y-auto no-scrollbar">
                    <p class="px-4 text-xs font-bold text-slate-400 uppercase tracking-widest mb-3">Operations</p>
                    <a href="ElectricDeptDashboard.aspx" class="nav-link flex items-center px-4 py-3 text-sm">
                        <i class="fa-solid fa-clipboard-list w-6 opacity-75"></i> Active Tasks
                    </a>
                    <a href="PowerGridStatus.aspx" class="nav-link active flex items-center px-4 py-3 text-sm">
                        <i class="fa-solid fa-tower-observation w-6 opacity-75"></i> Power Grid Status
                    </a>
                    <a href="MaintenanceSchedule.aspx" class="nav-link flex items-center px-4 py-3 text-sm">
                        <i class="fa-solid fa-screwdriver-wrench w-6 opacity-75"></i> Maintenance Schedule
                    </a>
                    <a href="ElectricResolvedHistory.aspx" class="nav-link flex items-center px-4 py-3 text-sm">
                        <i class="fa-solid fa-check-double w-6 opacity-75"></i> Resolved History
                    </a>
                    <p class="px-4 text-xs font-bold text-slate-400 uppercase tracking-widest mt-8 mb-3">Management</p>
                    <a href="DispatchUnits.aspx" class="nav-link flex items-center px-4 py-3 text-sm">
                        <i class="fa-solid fa-truck-fast w-6 opacity-75"></i> Dispatch Units
                    </a>
                    <a href="ElectricFieldStaff.aspx" class="nav-link flex items-center px-4 py-3 text-sm">
                        <i class="fa-solid fa-users-gear w-6 opacity-75"></i> Field Staff
                    </a>
                    <a href="/Logout.aspx" class="nav-link flex items-center px-4 py-3 text-sm text-red-500 hover:bg-red-50 hover:text-red-600">
                        <i class="fa-solid fa-right-from-bracket w-6 opacity-75"></i> Logout
                    </a>
                </nav>
            </aside>

            <div class="flex-1 flex flex-col overflow-hidden bg-slate-50">
                <header class="h-20 bg-white border-b border-slate-200 flex items-center justify-between px-8 shadow-sm z-10">
                    <h2 class="text-xl font-bold text-slate-800">Live Power Grid</h2>
                    <div class="flex items-center gap-4 pl-6 border-l border-slate-200">
                        <div class="text-right">
                            <div class="text-sm font-bold text-slate-700">Officer Rajesh</div>
                            <div class="text-xs text-slate-400">Zone 4 Manager</div>
                        </div>
                        <div class="w-10 h-10 rounded-full bg-orange-50 border border-orange-100 flex items-center justify-center text-orange-600 font-bold shadow-sm">R</div>
                    </div>
                </header>

                <main class="flex-1 overflow-y-auto p-8">
                    <div class="grid grid-cols-1 md:grid-cols-3 gap-6 mb-8">
                        <div class="stat-card p-5 border-l-4 border-l-orange-500">
                            <p class="text-slate-500 text-xs font-bold uppercase tracking-wider">Current Grid Load</p>
                            <h3 class="text-2xl font-bold text-slate-800 mt-1">450 <span class="text-sm text-slate-500 font-medium">MW</span></h3>
                            <p class="text-xs text-orange-600 font-bold mt-1"><i class="fa-solid fa-arrow-trend-up"></i> Peak Hours</p>
                        </div>
                        <div class="stat-card p-5 border-l-4 border-l-green-500">
                            <p class="text-slate-500 text-xs font-bold uppercase tracking-wider">Active Substations</p>
                            <h3 class="text-2xl font-bold text-slate-800 mt-1">12 / 12</h3>
                            <p class="text-xs text-green-600 font-bold mt-1"><i class="fa-solid fa-check-circle"></i> All Normal</p>
                        </div>
                        <div class="stat-card p-5 border-l-4 border-l-red-500">
                            <p class="text-slate-500 text-xs font-bold uppercase tracking-wider">Transformer Faults</p>
                            <h3 class="text-2xl font-bold text-red-600 mt-1">2 <span class="text-sm font-medium">Alerts</span></h3>
                            <p class="text-xs text-red-500 font-bold mt-1"><i class="fa-solid fa-triangle-exclamation"></i> Action Required</p>
                        </div>
                    </div>

                    <div class="grid grid-cols-1 lg:grid-cols-3 gap-6">
                        <div class="lg:col-span-2 stat-card overflow-hidden flex flex-col">
                            <div class="px-6 py-4 border-b border-slate-100 flex justify-between items-center bg-white">
                                <h3 class="font-bold text-slate-800">Grid Topology Map</h3>
                                <span class="px-3 py-1 bg-green-50 text-green-600 text-xs font-bold rounded-full border border-green-200">Live Sync</span>
                            </div>
                            <div class="flex-1 bg-slate-50 grid-bg min-h-[350px] relative flex items-center justify-center p-6">
                                <div class="text-center p-6 bg-white/90 backdrop-blur rounded-xl border border-slate-200 shadow-lg">
                                    <i class="fa-solid fa-bolt text-4xl text-orange-400 mb-3 animate-pulse"></i>
                                    <p class="text-sm font-bold text-slate-800">SCADA System Integration</p>
                                    <p class="text-xs text-slate-500 mt-1">Live grid mapping will render here via API.</p>
                                </div>
                            </div>
                        </div>

                        <div class="stat-card overflow-hidden">
                            <div class="px-6 py-4 border-b border-slate-100 bg-white">
                                <h3 class="font-bold text-slate-800">Substation Status</h3>
                            </div>
                            <div class="p-0">
                                <div class="p-4 border-b border-slate-100 flex justify-between items-center hover:bg-slate-50">
                                    <div>
                                        <h4 class="font-bold text-sm text-slate-800">Substation A (Dharampeth)</h4>
                                        <p class="text-xs text-slate-500">Load: 85% • Temp: Normal</p>
                                    </div>
                                    <span class="text-green-500"><i class="fa-solid fa-circle-check"></i></span>
                                </div>
                                <div class="p-4 border-b border-slate-100 flex justify-between items-center bg-red-50/30 hover:bg-red-50">
                                    <div>
                                        <h4 class="font-bold text-sm text-red-700">Substation B (MIDC)</h4>
                                        <p class="text-xs text-red-500">Load: 98% • Temp: HIGH</p>
                                    </div>
                                    <span class="text-red-500 animate-pulse"><i class="fa-solid fa-triangle-exclamation"></i></span>
                                </div>
                                <div class="p-4 flex justify-between items-center hover:bg-slate-50">
                                    <div>
                                        <h4 class="font-bold text-sm text-slate-800">Substation C (Civil Lines)</h4>
                                        <p class="text-xs text-slate-500">Load: 45% • Temp: Normal</p>
                                    </div>
                                    <span class="text-green-500"><i class="fa-solid fa-circle-check"></i></span>
                                </div>
                            </div>
                        </div>
                    </div>
                </main>
            </div>
        </div>
    </form>
</body>
</html>