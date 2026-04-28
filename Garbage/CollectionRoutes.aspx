<%@ Page Language="C#" AutoEventWireup="true" CodeFile="CollectionRoutes.aspx.cs" Inherits="CollectionRoutes" %>
<!DOCTYPE html>
<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title>Collection Routes | Sanitation Dept</title>
    <meta name="viewport" content="width=device-width, initial-scale=1.0" />
    <script src="https://cdn.tailwindcss.com"></script>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css" />
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@300;400;500;600;700&display=swap" rel="stylesheet"/>
    <style>
        body { font-family: 'Inter', sans-serif; background-color: #f8fafc; }
        .no-scrollbar::-webkit-scrollbar { display: none; }
        .no-scrollbar { -ms-overflow-style: none; }
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
                    <a href="CollectionRoutes.aspx" class="nav-link active flex items-center px-4 py-3 text-sm">
                        <i class="fa-solid fa-route w-6 opacity-75"></i> Collection Routes
                    </a>
                    <a href="DumpYardStatus.aspx" class="nav-link flex items-center px-4 py-3 text-sm">
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
                    <h2 class="text-xl font-bold text-slate-800">Live Collection Routes</h2>
                    <div class="flex items-center gap-4 pl-6 border-l border-slate-200">
                        <div class="w-10 h-10 rounded-full bg-green-50 border border-green-100 flex items-center justify-center text-green-600 font-bold shadow-sm">M</div>
                    </div>
                </header>

                <main class="flex-1 overflow-y-auto p-8">
                    <div class="grid grid-cols-3 gap-6 mb-8">
                        <div class="stat-card p-5 border-l-4 border-l-blue-500">
                            <p class="text-slate-500 text-xs font-bold uppercase tracking-wider">Total Routes</p>
                            <h3 class="text-2xl font-bold text-slate-800 mt-1">42</h3>
                        </div>
                        <div class="stat-card p-5 border-l-4 border-l-green-500">
                            <p class="text-slate-500 text-xs font-bold uppercase tracking-wider">Covered Today</p>
                            <h3 class="text-2xl font-bold text-green-600 mt-1">28 <span class="text-sm text-slate-500 font-medium">Areas</span></h3>
                        </div>
                        <div class="stat-card p-5 border-l-4 border-l-orange-500">
                            <p class="text-slate-500 text-xs font-bold uppercase tracking-wider">Pending</p>
                            <h3 class="text-2xl font-bold text-orange-600 mt-1">14 <span class="text-sm text-slate-500 font-medium">Areas</span></h3>
                        </div>
                    </div>

                    <div class="stat-card overflow-hidden">
                        <div class="px-6 py-4 border-b border-slate-100 flex justify-between items-center bg-white">
                            <h3 class="font-bold text-slate-800">Route Monitoring</h3>
                            <button class="text-xs font-bold bg-slate-800 text-white px-3 py-1.5 rounded"><i class="fa-solid fa-map-location-dot mr-1"></i> Map View</button>
                        </div>
                        <table class="w-full text-left text-sm text-slate-600">
                            <thead class="bg-slate-50 text-slate-500 font-semibold uppercase text-xs">
                                <tr>
                                    <th class="p-4">Route Name / Area</th>
                                    <th class="p-4">Assigned Vehicle</th>
                                    <th class="p-4">Driver Details</th>
                                    <th class="p-4">Progress</th>
                                    <th class="p-4 text-right">Status</th>
                                </tr>
                            </thead>
                            <tbody class="divide-y divide-slate-100 bg-white">
                                <tr>
                                    <td class="p-4 font-bold text-slate-800">Zone 1 - Sitabuldi</td>
                                    <td class="p-4 font-mono text-xs">MH-31-CB-1234</td>
                                    <td class="p-4">Ramesh Kumar</td>
                                    <td class="p-4">
                                        <div class="w-full bg-slate-200 rounded-full h-2">
                                            <div class="bg-green-500 h-2 rounded-full" style="width: 100%"></div>
                                        </div>
                                    </td>
                                    <td class="p-4 text-right"><span class="bg-green-100 text-green-700 px-2 py-1 rounded text-xs font-bold">Completed</span></td>
                                </tr>
                                <tr>
                                    <td class="p-4 font-bold text-slate-800">Zone 3 - Dharampeth</td>
                                    <td class="p-4 font-mono text-xs">MH-31-AB-9988</td>
                                    <td class="p-4">Suresh Singh</td>
                                    <td class="p-4">
                                        <div class="w-full bg-slate-200 rounded-full h-2">
                                            <div class="bg-blue-500 h-2 rounded-full" style="width: 60%"></div>
                                        </div>
                                    </td>
                                    <td class="p-4 text-right"><span class="bg-blue-100 text-blue-700 px-2 py-1 rounded text-xs font-bold animate-pulse">In Progress</span></td>
                                </tr>
                                <tr>
                                    <td class="p-4 font-bold text-slate-800">Zone 4 - MIDC</td>
                                    <td class="p-4 font-mono text-xs text-slate-400">Pending Assignment</td>
                                    <td class="p-4">-</td>
                                    <td class="p-4">
                                        <div class="w-full bg-slate-200 rounded-full h-2">
                                            <div class="bg-orange-500 h-2 rounded-full" style="width: 0%"></div>
                                        </div>
                                    </td>
                                    <td class="p-4 text-right"><span class="bg-orange-100 text-orange-700 px-2 py-1 rounded text-xs font-bold">Waiting</span></td>
                                </tr>
                            </tbody>
                        </table>
                    </div>
                </main>
            </div>
        </div>
    </form>
</body>
</html>