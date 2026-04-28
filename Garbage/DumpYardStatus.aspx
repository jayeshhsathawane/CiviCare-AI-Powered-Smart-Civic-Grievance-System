<%@ Page Language="C#" AutoEventWireup="true" CodeFile="DumpYardStatus.aspx.cs" Inherits="DumpYardStatus" %>
<!DOCTYPE html>
<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title>Dump Yard Status | Sanitation Dept</title>
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
        .nav-link.active { background-color: #f0fdf4; color: #16a34a; font-weight: 600; }
        .stat-card { background: white; border: 1px solid #e2e8f0; border-radius: 12px; box-shadow: 0 1px 3px 0 rgba(0,0,0,0.1); }
    </style>
</head>
<body class="text-slate-600 antialiased">
    <form id="form1" runat="server">
        <div class="flex h-screen overflow-hidden">
            
            <aside class="hidden md:flex w-72 flex-col bg-white border-r border-slate-200 z-20">
                <div class="h-20 flex items-center px-8 border-b border-slate-100">
                    <div class="flex items-center gap-3">
                        <div class="w-9 h-9 bg-green-600 rounded-lg flex items-center justify-center text-white text-xl shadow-lg shadow-green-200">
                            <i class="fa-solid fa-trash-can"></i>
                        </div>
                        <span class="text-xl font-bold tracking-tight text-slate-800">Sanitation<span class="text-green-600">Dept</span></span>
                    </div>
                </div>
                <nav class="flex-1 py-6 px-4 space-y-1.5 overflow-y-auto no-scrollbar">
                    <p class="px-4 text-xs font-bold text-slate-400 uppercase tracking-widest mb-3">Operations</p>
                    <a href="SanitationDeptDashboard.aspx" class="nav-link flex items-center px-4 py-3 text-sm">
                        <i class="fa-solid fa-clipboard-list w-6 opacity-75"></i> Active Complaints
                    </a>
                    <a href="CollectionRoutes.aspx" class="nav-link flex items-center px-4 py-3 text-sm">
                        <i class="fa-solid fa-route w-6 opacity-75"></i> Collection Routes
                    </a>
                    <a href="DumpYardStatus.aspx" class="nav-link active flex items-center px-4 py-3 text-sm">
                        <i class="fa-solid fa-dumpster w-6 opacity-75"></i> Dump Yard Status
                    </a>
                    <a href="SanitationResolvedHistory.aspx" class="nav-link flex items-center px-4 py-3 text-sm">
                        <i class="fa-solid fa-check-double w-6 opacity-75"></i> Resolved History
                    </a>
                    <p class="px-4 text-xs font-bold text-slate-400 uppercase tracking-widest mt-8 mb-3">Management</p>
                    <a href="DispatchTrucks.aspx" class="nav-link flex items-center px-4 py-3 text-sm">
                        <i class="fa-solid fa-truck w-6 opacity-75"></i> Dispatch Trucks
                    </a>
                    <a href="SanitationStaff.aspx" class="nav-link flex items-center px-4 py-3 text-sm">
                        <i class="fa-solid fa-users-gear w-6 opacity-75"></i> Field Staff
                    </a>
                    <a href="/Logout.aspx" class="nav-link flex items-center px-4 py-3 text-sm text-red-500 hover:bg-red-50 hover:text-red-600">
                        <i class="fa-solid fa-right-from-bracket w-6 opacity-75"></i> Logout
                    </a>
                </nav>
            </aside>

            <div class="flex-1 flex flex-col overflow-hidden bg-slate-50">
                <header class="h-20 bg-white border-b border-slate-200 flex items-center justify-between px-8 shadow-sm z-10">
                    <h2 class="text-xl font-bold text-slate-800">City Landfill & Dump Yards</h2>
                    <button class="bg-green-600 text-white px-4 py-2 rounded-lg text-sm font-bold shadow-sm hover:bg-green-700 transition"><i class="fa-solid fa-arrows-rotate mr-2"></i>Refresh Data</button>
                </header>

                <main class="flex-1 overflow-y-auto p-8">
                    <div class="grid grid-cols-1 md:grid-cols-3 gap-6 mb-8">
                        <div class="stat-card p-6 text-center">
                            <i class="fa-solid fa-scale-unbalanced text-3xl text-slate-400 mb-3"></i>
                            <h3 class="text-3xl font-bold text-slate-800">450 <span class="text-sm text-slate-500">Tons</span></h3>
                            <p class="text-xs font-bold text-slate-500 uppercase mt-1">Total Waste Collected Today</p>
                        </div>
                        <div class="stat-card p-6 text-center">
                            <i class="fa-solid fa-recycle text-3xl text-green-500 mb-3"></i>
                            <h3 class="text-3xl font-bold text-green-600">60%</h3>
                            <p class="text-xs font-bold text-slate-500 uppercase mt-1">Segregated (Dry/Wet)</p>
                        </div>
                        <div class="stat-card p-6 text-center">
                            <i class="fa-solid fa-fire-burner text-3xl text-orange-500 mb-3"></i>
                            <h3 class="text-3xl font-bold text-slate-800">120 <span class="text-sm text-slate-500">Tons</span></h3>
                            <p class="text-xs font-bold text-slate-500 uppercase mt-1">Processed at Plant</p>
                        </div>
                    </div>

                    <h3 class="font-bold text-slate-800 text-lg mb-4">Yard Capacities</h3>
                    <div class="grid grid-cols-1 md:grid-cols-2 gap-6">
                        
                        <div class="stat-card p-6">
                            <div class="flex justify-between items-center mb-4">
                                <div>
                                    <h4 class="font-bold text-slate-800 text-lg">Bhandewadi Main Yard</h4>
                                    <p class="text-xs text-slate-500">Zone 5</p>
                                </div>
                                <span class="text-red-500 font-bold bg-red-50 px-3 py-1 rounded-full text-sm">Critical</span>
                            </div>
                            <div class="mb-2 flex justify-between text-sm font-bold">
                                <span class="text-slate-600">Capacity Used</span>
                                <span class="text-red-600">85%</span>
                            </div>
                            <div class="w-full bg-slate-200 rounded-full h-3">
                                <div class="bg-red-500 h-3 rounded-full" style="width: 85%"></div>
                            </div>
                            <p class="text-xs text-slate-500 mt-4"><i class="fa-solid fa-triangle-exclamation text-red-400"></i> Approaching maximum limit. Redirect trucks to Zone 3.</p>
                        </div>

                        <div class="stat-card p-6">
                            <div class="flex justify-between items-center mb-4">
                                <div>
                                    <h4 class="font-bold text-slate-800 text-lg">Zone 3 Transfer Station</h4>
                                    <p class="text-xs text-slate-500">MIDC Area</p>
                                </div>
                                <span class="text-green-600 font-bold bg-green-50 px-3 py-1 rounded-full text-sm">Normal</span>
                            </div>
                            <div class="mb-2 flex justify-between text-sm font-bold">
                                <span class="text-slate-600">Capacity Used</span>
                                <span class="text-green-600">40%</span>
                            </div>
                            <div class="w-full bg-slate-200 rounded-full h-3">
                                <div class="bg-green-500 h-3 rounded-full" style="width: 40%"></div>
                            </div>
                            <p class="text-xs text-slate-500 mt-4"><i class="fa-solid fa-check text-green-400"></i> Operating under normal limits.</p>
                        </div>

                    </div>
                </main>
            </div>
        </div>
    </form>
</body>
</html>