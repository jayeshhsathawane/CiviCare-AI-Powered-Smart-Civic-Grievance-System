<%@ Page Language="C#" AutoEventWireup="true" CodeFile="ResolvedHistory.aspx.cs" Inherits="ResolvedHistory" %>

<!DOCTYPE html>
<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title>Resolved History | Water Dept</title>
    <meta name="viewport" content="width=device-width, initial-scale=1.0" />
    
    <script src="https://cdn.tailwindcss.com"></script>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css" />
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@300;400;500;600;700&display=swap" rel="stylesheet"/>
    
    <style>
        body { font-family: 'Inter', sans-serif; background-color: #f8fafc; }
        .no-scrollbar::-webkit-scrollbar { display: none; }
        .no-scrollbar { -ms-overflow-style: none; scrollbar-width: none; }
        
        .nav-link { border-radius: 8px; transition: all 0.2s ease-in-out; color: #64748b; font-weight: 500; }
        .nav-link:hover { background-color: #f1f5f9; color: #1e293b; }
        .nav-link.active { background-color: #eff6ff; color: #2563eb; font-weight: 600; }

        .content-card { background: white; border: 1px solid #e2e8f0; border-radius: 12px; box-shadow: 0 1px 3px 0 rgba(0, 0, 0, 0.1); }
        .form-control { border: 1px solid #cbd5e1; border-radius: 6px; padding: 0.5rem 0.75rem; font-size: 0.875rem; color: #334155; outline: none; transition: border-color 0.2s; width: 100%; }
        .form-control:focus { border-color: #3b82f6; box-shadow: 0 0 0 3px rgba(59, 130, 246, 0.1); }

        /* Toast Animations */
        @keyframes slideInRight { from { transform: translateX(100%); opacity: 0; } to { transform: translateX(0); opacity: 1; } }
        @keyframes fadeOutUp { from { opacity: 1; transform: translateY(0); } to { opacity: 0; transform: translateY(-20px); } }
        .toast-enter { animation: slideInRight 0.4s cubic-bezier(0.16, 1, 0.3, 1) forwards; }
        .toast-exit { animation: fadeOutUp 0.4s ease forwards; }

        /* Custom Table Borders */
        .bordered-table th, .bordered-table td {
            border: 1px solid #cbd5e1; /* Visible gray/black borders */
        }
        
        #mobileSidebar { transition: transform 0.3s ease-in-out; }
    </style>
</head>
<body class="text-slate-600 antialiased">
    <div id="toast-container" class="fixed top-5 right-5 z-[99999] flex flex-col gap-3 pointer-events-none"></div>

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
                <nav class="flex-1 py-6 px-4 space-y-1.5 overflow-y-auto no-scrollbar">
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
                    <a href="ResolvedHistory.aspx" class="nav-link active flex items-center px-4 py-3 text-sm">
                        <i class="fa-solid fa-check-double w-6 opacity-75"></i> Resolved History
                    </a>
                    <p class="px-4 text-xs font-bold text-slate-400 uppercase tracking-widest mt-8 mb-3">Management</p>
                    <a href="TankerDispatch.aspx" class="nav-link flex items-center px-4 py-3 text-sm">
                        <i class="fa-solid fa-truck-droplet w-6 opacity-75"></i> Tanker Dispatch
                    </a>
                    <a href="FieldStaff.aspx" class="nav-link flex items-center px-4 py-3 text-sm">
                        <i class="fa-solid fa-users-gear w-6 opacity-75"></i> Field Staff
                    </a>
                    <a href="/Default.aspx" class="nav-link flex items-center px-4 py-3 text-sm text-red-500 hover:bg-red-50 hover:text-red-600 mt-2">
                        <i class="fa-solid fa-right-from-bracket w-6 opacity-75"></i> Logout
                    </a>
                </nav>
            </aside>

            <div id="mobileSidebar" class="fixed inset-y-0 left-0 w-72 bg-white shadow-2xl z-50 transform -translate-x-full md:hidden flex flex-col border-r border-slate-200">
                <div class="h-20 flex items-center justify-between px-6 border-b border-slate-100">
                    <div class="flex items-center gap-3">
                        <div class="w-9 h-9 bg-blue-600 rounded-lg flex items-center justify-center text-white text-xl shadow-lg shadow-blue-200">
                            <i class="fa-solid fa-faucet-drip"></i>
                        </div>
                        <span class="text-xl font-bold tracking-tight text-slate-800">Water<span class="text-blue-600">Dept</span></span>
                    </div>
                    <button type="button" onclick="toggleSidebar()" class="text-slate-500 hover:text-red-500 transition text-2xl"><i class="fa-solid fa-xmark"></i></button>
                </div>
                <nav class="flex-1 py-6 px-4 space-y-1.5 overflow-y-auto no-scrollbar">
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
                    <a href="ResolvedHistory.aspx" class="nav-link active flex items-center px-4 py-3 text-sm">
                        <i class="fa-solid fa-check-double w-6 opacity-75"></i> Resolved History
                    </a>
                    <p class="px-4 text-xs font-bold text-slate-400 uppercase tracking-widest mt-8 mb-3">Management</p>
                    <a href="TankerDispatch.aspx" class="nav-link flex items-center px-4 py-3 text-sm">
                        <i class="fa-solid fa-truck-droplet w-6 opacity-75"></i> Tanker Dispatch
                    </a>
                    <a href="FieldStaff.aspx" class="nav-link flex items-center px-4 py-3 text-sm">
                        <i class="fa-solid fa-users-gear w-6 opacity-75"></i> Field Staff
                    </a>
                    <a href="/Default.aspx" class="nav-link flex items-center px-4 py-3 text-sm text-red-500 hover:bg-red-50 hover:text-red-600 mt-2">
                        <i class="fa-solid fa-right-from-bracket w-6 opacity-75"></i> Logout
                    </a>
                </nav>
            </div>

            <div class="flex-1 flex flex-col overflow-hidden bg-slate-50">
                
                <header class="h-20 bg-white border-b border-slate-200 flex items-center justify-between px-4 md:px-8 shadow-sm z-10">
                    <div class="flex items-center gap-4">
                        <button type="button" class="md:hidden text-slate-500" onclick="toggleSidebar()"><i class="fa-solid fa-bars text-xl"></i></button>
                        <h2 class="text-lg md:text-xl font-bold text-slate-800">Resolved Complaints History</h2>
                    </div>
                    <div class="flex items-center gap-4 pl-4 md:pl-6 border-l border-slate-200">
                        <div class="text-right hidden sm:block">
                            <div class="text-sm font-bold text-slate-700"><asp:Literal ID="litAdminName" runat="server"></asp:Literal></div>
                            <div class="text-xs text-slate-400">Dept Head</div>
                        </div>
                        <div class="w-10 h-10 rounded-full bg-blue-100 border border-blue-200 flex items-center justify-center text-blue-600 font-bold shadow-sm">A</div>
                    </div>
                </header>

                <main class="flex-1 overflow-y-auto p-4 md:p-8">
                    
                    <div class="content-card p-4 md:p-5 mb-6 flex flex-col lg:flex-row justify-between items-start lg:items-center gap-4">
                        <div class="w-full lg:w-auto">
                            <h3 class="text-sm font-bold text-slate-700 uppercase tracking-wide mb-3">Filter History by Date</h3>
                            <div class="flex flex-col sm:flex-row flex-wrap gap-4 items-start sm:items-end">
                                <div class="w-full sm:w-auto">
                                    <span class="text-xs text-slate-500 block mb-1 font-semibold">Start Date</span>
                                    <asp:TextBox ID="txtStartDate" runat="server" TextMode="Date" CssClass="form-control cursor-pointer"></asp:TextBox>
                                </div>
                                <div class="w-full sm:w-auto">
                                    <span class="text-xs text-slate-500 block mb-1 font-semibold">End Date</span>
                                    <asp:TextBox ID="txtEndDate" runat="server" TextMode="Date" CssClass="form-control cursor-pointer"></asp:TextBox>
                                </div>
                                <div class="flex gap-2 w-full sm:w-auto pt-1 sm:pt-0">
                                    <asp:Button ID="btnFilter" runat="server" Text="Apply Filter" OnClick="btnFilter_Click" CssClass="flex-1 sm:flex-none bg-slate-800 hover:bg-slate-900 text-white px-5 py-2 rounded-lg text-sm font-bold shadow-sm transition cursor-pointer" />
                                    <asp:Button ID="btnClear" runat="server" Text="Clear" OnClick="btnClear_Click" CssClass="flex-1 sm:flex-none bg-white border border-slate-300 text-slate-600 hover:bg-slate-50 px-4 py-2 rounded-lg text-sm font-bold transition cursor-pointer" />
                                </div>
                            </div>
                        </div>
                        <div class="w-full lg:w-auto mt-2 lg:mt-0">
                            <asp:Button ID="btnExportCSV" runat="server" Text="Export CSV" CssClass="w-full lg:w-auto bg-green-600 hover:bg-green-700 text-white px-4 py-2.5 md:py-2 rounded-lg text-sm font-bold shadow-md transition flex items-center justify-center gap-2 cursor-pointer" />
                        </div>
                    </div>

                    <div class="content-card overflow-hidden">
                        <div class="px-4 md:px-6 py-4 border-b border-slate-100 flex justify-between items-center bg-white">
                            <h3 class="font-bold text-slate-800 uppercase text-sm tracking-wide">Work Logs</h3>
                        </div>
                        
                        <div class="overflow-x-auto w-full p-4">
                            <table class="w-full text-left text-sm text-slate-600 min-w-[700px] bordered-table border-collapse">
                                <thead class="bg-slate-100 text-slate-700 font-bold uppercase text-xs">
                                    <tr>
                                        <th class="p-4 whitespace-nowrap bg-slate-200/50">Date Resolved</th>
                                        <th class="p-4 bg-slate-200/50">Complaint Details</th>
                                        <th class="p-4 bg-slate-200/50">Location</th>
                                        <th class="p-4 whitespace-nowrap bg-slate-200/50">Resolved By</th>
                                        <th class="p-4 whitespace-nowrap bg-slate-200/50">Time Taken</th>
                                        <th class="p-4 text-center bg-slate-200/50">Status</th>
                                    </tr>
                                </thead>
                                <tbody class="bg-white">
                                    <asp:Repeater ID="rptResolvedLogs" runat="server">
                                        <ItemTemplate>
                                            <tr class="hover:bg-blue-50/30 transition duration-150">
                                                <td class="p-4 font-mono text-xs whitespace-nowrap">
                                                    <%# Convert.ToDateTime(Eval("ResolvedAt")).ToString("dd MMM yyyy") %><br/>
                                                    <span class="text-slate-400 font-bold"><%# Convert.ToDateTime(Eval("ResolvedAt")).ToString("hh:mm tt") %></span>
                                                </td>
                                                <td class="p-4 min-w-[200px]">
                                                    <div class="font-mono text-xs text-blue-600 font-bold mb-0.5">#WTR-<%# Eval("ComplaintID") %></div>
                                                    <div class="font-semibold text-slate-800 line-clamp-2" title='<%# Eval("Description") %>'>
                                                        <%# Eval("UserDepartment") %> Issue
                                                    </div>
                                                </td>
                                                <td class="p-4 font-medium text-slate-800 min-w-[200px]" title='<%# Eval("LocationName") %>'>
                                                    <div class="flex items-start gap-1">
                                                        <i class="fa-solid fa-location-dot text-slate-400 mt-1"></i> 
                                                        <span class="line-clamp-2"><%# Eval("LocationName") %></span>
                                                    </div>
                                                </td>
                                                <td class="p-4 font-semibold text-blue-700 whitespace-nowrap">
                                                    <%# string.IsNullOrEmpty(Eval("StaffName").ToString()) ? "Water Dept Staff" : Eval("StaffName") %>
                                                </td>
                                                <td class="p-4 font-mono text-xs font-bold text-slate-600 whitespace-nowrap">
                                                    <i class="fa-regular fa-clock text-slate-400"></i> <%# CalculateTimeTaken(Eval("CreatedAt"), Eval("ResolvedAt")) %>
                                                </td>
                                                <td class="p-4 text-center whitespace-nowrap">
                                                    <span class="inline-flex items-center gap-1 px-3 py-1 rounded-md text-xs font-bold bg-green-50 text-green-700 border border-green-300 shadow-sm">
                                                        <i class="fa-solid fa-check"></i> Closed
                                                    </span>
                                                </td>
                                            </tr>
                                        </ItemTemplate>
                                    </asp:Repeater>

                                    <tr id="trNoData" runat="server" visible="false">
                                        <td colspan="6" class="p-10 text-center text-slate-500 border-none">
                                            <i class="fa-solid fa-folder-open text-4xl text-slate-300 mb-3 block"></i>
                                            <span class="font-bold text-lg">No Resolved Complaints Found.</span>
                                        </td>
                                    </tr>
                                </tbody>
                            </table>
                        </div>
                    </div>

                </main>
            </div>
        </div>

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
        </script>
    </form>
</body>
</html>