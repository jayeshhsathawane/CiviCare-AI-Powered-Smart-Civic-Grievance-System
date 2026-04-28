<%@ Page Language="C#" AutoEventWireup="true" CodeFile="PipelineNetwork.aspx.cs" Inherits="PipelineNetwork" %>
<!DOCTYPE html>
<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title>Pipeline Network | Water Dept</title>
    <meta name="viewport" content="width=device-width, initial-scale=1.0" />
    <script src="https://cdn.tailwindcss.com"></script>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css" />
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@300;400;500;600;700&display=swap" rel="stylesheet"/>
    <style>
        body { font-family: 'Inter', sans-serif; background-color: #f8fafc; }
        .nav-link { border-radius: 8px; transition: all 0.2s ease-in-out; color: #64748b; }
        .nav-link:hover { background-color: #f1f5f9; color: #1e293b; }
        .nav-link.active { background-color: #eff6ff; color: #2563eb; font-weight: 600; }
        .stat-card { background: white; border: 1px solid #e2e8f0; border-radius: 12px; box-shadow: 0 1px 3px 0 rgba(0,0,0,0.1); transition: transform 0.2s; }
        .stat-card:hover { transform: translateY(-2px); box-shadow: 0 4px 6px -1px rgba(0,0,0,0.1); }
        .map-bg { background-image: radial-gradient(#cbd5e1 1px, transparent 1px); background-size: 20px 20px; }
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
                    <a href="PipelineNetwork.aspx" class="nav-link active flex items-center px-4 py-3 text-sm">
                        <i class="fa-solid fa-diagram-project w-6 opacity-75"></i> Pipeline Network
                    </a>
                    <a href="WaterQuality.aspx" class="nav-link flex items-center px-4 py-3 text-sm">
                        <i class="fa-solid fa-water w-6 opacity-75"></i> Water Quality Data
                    </a>
                    <a href="ResolvedHistory.aspx" class="nav-link flex items-center px-4 py-3 text-sm">
                        <i class="fa-solid fa-check-double w-6 opacity-75"></i> Resolved History
                    </a>
                    
                    <p class="px-4 text-xs font-bold text-slate-400 uppercase tracking-widest mt-8 mb-3">Management</p>
                    <a href="TankerDispatch.aspx" class="nav-link flex items-center px-4 py-3 text-sm">
                        <i class="fa-solid fa-truck-droplet w-6 opacity-75"></i> Tanker Dispatch
                    </a>
                    <a href="FieldStaff.aspx" class="nav-link flex items-center px-4 py-3 text-sm">
                        <i class="fa-solid fa-users-gear w-6 opacity-75"></i> Field Staff
                    </a>
                </nav>
            </aside>

            <div class="flex-1 flex flex-col overflow-hidden bg-slate-50">
                <header class="h-20 bg-white border-b border-slate-200 flex items-center justify-between px-8 shadow-sm z-10">
                    <h2 class="text-xl font-bold text-slate-800">Pipeline & Infrastructure</h2>
                    <div class="flex items-center gap-4 pl-6 border-l border-slate-200">
                        <div class="text-right">
                            <div class="text-sm font-bold text-slate-700">Officer Amit</div>
                            <div class="text-xs text-slate-400">Head Engineer</div>
                        </div>
                        <div class="w-10 h-10 rounded-full bg-blue-100 border border-blue-200 flex items-center justify-center text-blue-600 font-bold shadow-sm">A</div>
                    </div>
                </header>

                <main class="flex-1 overflow-y-auto p-8">
                    <div class="grid grid-cols-3 gap-6 mb-8">
                        <div class="stat-card p-5 border-l-4 border-l-blue-500">
                            <p class="text-slate-500 text-xs font-bold uppercase tracking-wider">Total Network</p>
                            <h3 class="text-2xl font-bold text-slate-800 mt-1">1,240 <span class="text-sm text-slate-500 font-medium">km</span></h3>
                        </div>
                        <div class="stat-card p-5 border-l-4 border-l-orange-400">
                            <p class="text-slate-500 text-xs font-bold uppercase tracking-wider">Low Pressure Zones</p>
                            <h3 class="text-2xl font-bold text-slate-800 mt-1">4 <span class="text-sm text-orange-500 font-bold ml-2">Alerts</span></h3>
                        </div>
                        <div class="stat-card p-5 border-l-4 border-l-green-500">
                            <p class="text-slate-500 text-xs font-bold uppercase tracking-wider">Active Pumping Stations</p>
                            <h3 class="text-2xl font-bold text-slate-800 mt-1">24 / 24</h3>
                        </div>
                    </div>

                    <div class="grid grid-cols-1 lg:grid-cols-3 gap-6">
                        <div class="lg:col-span-2 stat-card overflow-hidden flex flex-col">
                            <div class="px-6 py-4 border-b border-slate-100 flex justify-between items-center bg-white">
                                <h3 class="font-bold text-slate-800">Live Network Map</h3>
                                <span class="px-3 py-1 bg-green-50 text-green-600 text-xs font-bold rounded-full border border-green-200"><i class="fa-solid fa-satellite-dish mr-1"></i> Sensors Online</span>
                            </div>
                            <div class="flex-1 bg-slate-100 map-bg min-h-[400px] relative flex items-center justify-center">
                                <div class="absolute top-1/4 left-1/4 w-4 h-4 bg-blue-500 rounded-full border-2 border-white shadow-lg animate-pulse"></div>
                                <div class="absolute top-1/2 right-1/3 w-4 h-4 bg-orange-500 rounded-full border-2 border-white shadow-lg animate-pulse"></div>
                                <div class="absolute bottom-1/3 left-1/2 w-4 h-4 bg-red-500 rounded-full border-2 border-white shadow-lg animate-pulse"></div>
                                
                                <div class="text-center p-4 bg-white/80 backdrop-blur rounded-lg border border-slate-200 shadow-sm">
                                    <i class="fa-solid fa-map-location-dot text-3xl text-slate-400 mb-2"></i>
                                    <p class="text-sm font-bold text-slate-700">GIS Map Integration Pending</p>
                                    <p class="text-xs text-slate-500">Connect Google Maps / Leaflet API here</p>
                                </div>
                            </div>
                        </div>

                        <div class="stat-card p-0 flex flex-col">
                            <div class="px-6 py-4 border-b border-slate-100 bg-white">
                                <h3 class="font-bold text-slate-800">Sensor Alerts</h3>
                            </div>
                            <div class="p-6 space-y-4 flex-1 bg-slate-50">
                                <div class="bg-white p-4 rounded-lg border border-red-100 shadow-sm">
                                    <div class="flex items-center gap-2 mb-2">
                                        <i class="fa-solid fa-droplet text-red-500"></i>
                                        <h4 class="font-bold text-sm text-slate-800">Pressure Drop</h4>
                                    </div>
                                    <p class="text-xs text-slate-500 mb-2">Valve V-402 showing 30% drop in pressure. Possible major leak.</p>
                                    <span class="text-xs font-bold text-red-600">Location: MIDC Area</span>
                                </div>
                                <div class="bg-white p-4 rounded-lg border border-orange-100 shadow-sm">
                                    <div class="flex items-center gap-2 mb-2">
                                        <i class="fa-solid fa-water text-orange-500"></i>
                                        <h4 class="font-bold text-sm text-slate-800">High Flow Rate</h4>
                                    </div>
                                    <p class="text-xs text-slate-500 mb-2">Abnormal water flow detected during non-peak hours.</p>
                                    <span class="text-xs font-bold text-orange-600">Location: Ward 12</span>
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