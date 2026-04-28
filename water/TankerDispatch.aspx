<%@ Page Language="C#" AutoEventWireup="true" CodeFile="TankerDispatch.aspx.cs" Inherits="TankerDispatch" %>
<!DOCTYPE html>
<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title>Tanker Dispatch | Water Dept</title>
    <meta name="viewport" content="width=device-width, initial-scale=1.0" />
    <script src="https://cdn.tailwindcss.com"></script>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css" />
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@300;400;500;600;700&display=swap" rel="stylesheet"/>
    <style>
        body { font-family: 'Inter', sans-serif; background-color: #f8fafc; }
        .nav-link { border-radius: 8px; transition: all 0.2s ease-in-out; color: #64748b; }
        .nav-link:hover { background-color: #f1f5f9; color: #1e293b; }
        .nav-link.active { background-color: #eff6ff; color: #2563eb; font-weight: 600; }
        .stat-card { background: white; border: 1px solid #e2e8f0; border-radius: 12px; box-shadow: 0 1px 3px 0 rgba(0,0,0,0.1); }
    </style>
</head>
<body class="text-slate-600 antialiased">
    <form id="form1" runat="server">
        <div class="flex h-screen overflow-hidden">
            
            <aside class="hidden md:flex w-72 flex-col bg-white border-r border-slate-200 z-20">
                 <div class="h-20 flex items-center px-8 border-b border-slate-100">
                    <div class="flex items-center gap-3">
                        <div class="w-9 h-9 bg-blue-600 rounded-lg flex items-center justify-center text-white text-xl shadow-lg shadow-blue-200">
                            <i class="fa-solid fa-faucet-drip"></i>
                        </div>
                        <span class="text-xl font-bold tracking-tight text-slate-800">Water<span class="text-blue-600">Dept</span></span>
                    </div>
                </div>
                <nav class="flex-1 py-6 px-4 space-y-1.5 overflow-y-auto">
                    <p class="px-4 text-xs font-bold text-slate-400 uppercase tracking-widest mb-3">Operations</p>
                    <a href="WaterDeptDashboard.aspx" class="nav-link flex items-center px-4 py-3 text-sm">
                        <i class="fa-solid fa-clipboard-list w-6 opacity-75"></i> Active Complaints
                    </a>
                    <a href="PipelineNetwork.aspx" class="nav-link flex items-center px-4 py-3 text-sm">
                        <i class="fa-solid fa-diagram-project w-6 opacity-75"></i> Pipeline Network
                    </a>
                    <a href="WaterQuality.aspx" class="nav-link flex items-center px-4 py-3 text-sm">
                        <i class="fa-solid fa-water w-6 opacity-75"></i> Water Quality Data
                    </a>
                    <a href="ResolvedHistory.aspx" class="nav-link flex items-center px-4 py-3 text-sm">
                        <i class="fa-solid fa-check-double w-6 opacity-75"></i> Resolved History
                    </a>
                     <p class="px-4 text-xs font-bold text-slate-400 uppercase tracking-widest mt-8 mb-3">Management</p>
                    <a href="TankerDispatch.aspx" class="nav-link active flex items-center px-4 py-3 text-sm">
                        <i class="fa-solid fa-truck-droplet w-6 opacity-75"></i> Tanker Dispatch
                    </a>
                    <a href="FieldStaff.aspx" class="nav-link flex items-center px-4 py-3 text-sm">
                        <i class="fa-solid fa-users-gear w-6 opacity-75"></i> Field Staff
                    </a>
                </nav>
            </aside>

            <div class="flex-1 flex flex-col overflow-hidden bg-slate-50">
                <header class="h-20 bg-white border-b border-slate-200 flex items-center justify-between px-8 shadow-sm z-10">
                    <h2 class="text-xl font-bold text-slate-800">Emergency Tanker Dispatch</h2>
                    <button class="bg-blue-600 hover:bg-blue-700 text-white px-4 py-2 rounded-lg text-sm font-bold shadow-sm transition"><i class="fa-solid fa-truck-fast mr-2"></i>New Dispatch</button>
                </header>

                <main class="flex-1 overflow-y-auto p-8">
                    <div class="grid grid-cols-3 gap-6 mb-8">
                        <div class="stat-card p-5 border-l-4 border-l-orange-500">
                            <p class="text-slate-500 text-xs font-bold uppercase tracking-wider">Pending Requests</p>
                            <h3 class="text-3xl font-bold text-slate-800 mt-1">12</h3>
                        </div>
                        <div class="stat-card p-5 border-l-4 border-l-blue-500">
                            <p class="text-slate-500 text-xs font-bold uppercase tracking-wider">Tankers In Transit</p>
                            <h3 class="text-3xl font-bold text-blue-600 mt-1">8</h3>
                        </div>
                        <div class="stat-card p-5 border-l-4 border-l-green-500">
                            <p class="text-slate-500 text-xs font-bold uppercase tracking-wider">Delivered Today</p>
                            <h3 class="text-3xl font-bold text-slate-800 mt-1">45</h3>
                        </div>
                    </div>

                    <div class="stat-card overflow-hidden">
                        <div class="px-6 py-4 border-b border-slate-100 flex justify-between items-center bg-white">
                            <h3 class="font-bold text-slate-800 uppercase text-sm tracking-wide">Live Dispatch Queue</h3>
                        </div>
                        <table class="w-full text-left text-sm text-slate-600">
                            <thead class="bg-slate-50 text-slate-500 font-semibold uppercase text-xs">
                                <tr>
                                    <th class="p-4">Req ID</th>
                                    <th class="p-4">Destination Area</th>
                                    <th class="p-4">Driver / Vehicle</th>
                                    <th class="p-4">Status</th>
                                    <th class="p-4 text-right">Action</th>
                                </tr>
                            </thead>
                            <tbody class="divide-y divide-slate-100">
                                <tr>
                                    <td class="p-4 font-mono text-xs">#TNK-091</td>
                                    <td class="p-4 font-bold text-slate-700">Dharampeth (No Water Supply)</td>
                                    <td class="p-4">Ramesh (MH-31-CB-1122)</td>
                                    <td class="p-4"><span class="bg-blue-100 text-blue-700 px-2 py-1 rounded text-xs font-bold"><i class="fa-solid fa-truck-arrow-right mr-1"></i> In Transit</span></td>
                                    <td class="p-4 text-right"><button class="text-blue-600 font-bold hover:underline">Track</button></td>
                                </tr>
                                <tr>
                                    <td class="p-4 font-mono text-xs">#TNK-092</td>
                                    <td class="p-4 font-bold text-slate-700">Sitabuldi (Pipeline Repair)</td>
                                    <td class="p-4 text-slate-400 italic">Unassigned</td>
                                    <td class="p-4"><span class="bg-orange-100 text-orange-700 px-2 py-1 rounded text-xs font-bold"><i class="fa-solid fa-clock mr-1"></i> Waiting</span></td>
                                    <td class="p-4 text-right"><button class="bg-slate-800 text-white px-3 py-1 rounded text-xs font-bold">Assign</button></td>
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