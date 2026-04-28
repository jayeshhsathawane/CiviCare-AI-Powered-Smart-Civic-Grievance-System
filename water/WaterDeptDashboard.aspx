<%@ Page Language="C#" AutoEventWireup="true" CodeFile="WaterDeptDashboard.aspx.cs" Inherits="WaterDeptDashboard" %>

<!DOCTYPE html>
<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title>Water Department | Dashboard</title>
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

        .stat-card { background: white; border: 1px solid #e2e8f0; border-radius: 12px; box-shadow: 0 1px 3px 0 rgba(0, 0, 0, 0.1); transition: transform 0.2s ease, box-shadow 0.2s ease; }
        .stat-card:hover { transform: translateY(-2px); box-shadow: 0 4px 6px -1px rgba(0, 0, 0, 0.1); }

        .task-card { background: white; border: 1px solid #e2e8f0; border-radius: 12px; overflow: hidden; transition: box-shadow 0.2s; margin-bottom: 1.25rem; }
        .task-card:hover { box-shadow: 0 10px 15px -3px rgba(0, 0, 0, 0.05); border-color: #bfdbfe; }

        .btn-action { font-weight: 600; transition: all 0.2s; border-radius: 8px; }
        .btn-action:active { transform: scale(0.98); }
        .btn-action:disabled { opacity: 0.5; cursor: not-allowed; transform: none; }

        @keyframes slideInRight { from { transform: translateX(100%); opacity: 0; } to { transform: translateX(0); opacity: 1; } }
        @keyframes fadeOutUp { from { opacity: 1; transform: translateY(0); } to { opacity: 0; transform: translateY(-20px); } }
        .toast-enter { animation: slideInRight 0.4s cubic-bezier(0.16, 1, 0.3, 1) forwards; }
        .toast-exit { animation: fadeOutUp 0.4s ease forwards; }

        @keyframes popIn { from { opacity: 0; transform: scale(0.95); } to { opacity: 1; transform: scale(1); } }
        .modal-pop { animation: popIn 0.2s ease-out forwards; }

        #mobileSidebar { transition: transform 0.3s ease-in-out; }
    </style>
</head>
<body class="text-slate-600 antialiased">
    
    <div id="toast-container" class="fixed top-5 right-5 z-[99999] flex flex-col gap-3 pointer-events-none"></div>

    <form id="form1" runat="server">
        <asp:ScriptManager runat="server" />
        
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
                    <a href="WaterDeptDashboard.aspx" class="nav-link active flex items-center px-4 py-3 text-sm">
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
                    <a href="TankerDispatch.aspx" class="nav-link flex items-center px-4 py-3 text-sm">
                        <i class="fa-solid fa-truck-droplet w-6 opacity-75"></i> Tanker Dispatch
                    </a>
                    <a href="FieldStaff.aspx" class="nav-link flex items-center px-4 py-3 text-sm">
                        <i class="fa-solid fa-users-gear w-6 opacity-75"></i> Field Staff
                    </a>
                   <%-- <p class="px-4 text-xs font-bold text-slate-400 uppercase tracking-widest mt-8 mb-3">Account</p>
                    <a href="/UserProfile.aspx" class="nav-link flex items-center px-4 py-3 text-sm">
                        <i class="fa-solid fa-user-gear w-6 text-center opacity-80"></i> My Profile
                    </a>--%>
                    <a href="/SystemLogin.aspx?action=logout" class="nav-link flex items-center px-4 py-3 text-sm text-red-500 hover:bg-red-50 hover:text-red-600 mt-2">
                        <i class="fa-solid fa-right-from-bracket w-6 opacity-75"></i> Logout
                    </a>
                </nav>

                <div class="p-4 border-t border-slate-100">
                    <div class="bg-gradient-to-br from-blue-50 to-cyan-50 border border-blue-100 rounded-xl p-4">
                        <div class="flex items-center gap-3 mb-2">
                            <div class="p-2 bg-white rounded-lg shadow-sm text-blue-600"><i class="fa-solid fa-satellite-dish"></i></div>
                            <span class="font-bold text-slate-800 text-sm">AI Sensor Active</span>
                        </div>
                        <p class="text-xs text-slate-500 mb-3">Monitoring pipeline pressure automatically.</p>
                        <button type="button" class="w-full py-1.5 bg-white border border-blue-200 text-blue-600 text-xs font-bold rounded-lg hover:bg-blue-50 transition">System Status</button>
                    </div>
                </div>
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
                    <a href="WaterDeptDashboard.aspx" class="nav-link active flex items-center px-4 py-3 text-sm">
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
                    <a href="TankerDispatch.aspx" class="nav-link flex items-center px-4 py-3 text-sm">
                        <i class="fa-solid fa-truck-droplet w-6 opacity-75"></i> Tanker Dispatch
                    </a>
                    <a href="FieldStaff.aspx" class="nav-link flex items-center px-4 py-3 text-sm">
                        <i class="fa-solid fa-users-gear w-6 opacity-75"></i> Field Staff
                    </a>
                    <p class="px-4 text-xs font-bold text-slate-400 uppercase tracking-widest mt-8 mb-3">Account</p>
                    <a href="Profile.aspx" class="nav-link flex items-center px-4 py-3 text-sm">
                        <i class="fa-solid fa-user-gear w-6 text-center opacity-80"></i> My Profile
                    </a>
                    <a href="/Default.aspx" class="nav-link flex items-center px-4 py-3 text-sm text-red-500 hover:bg-red-50 hover:text-red-600 mt-2">
                        <i class="fa-solid fa-right-from-bracket w-6 opacity-75"></i> Logout
                    </a>
                </nav>

                <div class="p-4 border-t border-slate-100">
                    <div class="bg-gradient-to-br from-blue-50 to-cyan-50 border border-blue-100 rounded-xl p-4">
                        <div class="flex items-center gap-3 mb-2">
                            <div class="p-2 bg-white rounded-lg shadow-sm text-blue-600"><i class="fa-solid fa-satellite-dish"></i></div>
                            <span class="font-bold text-slate-800 text-sm">AI Sensor Active</span>
                        </div>
                        <p class="text-xs text-slate-500 mb-3">Monitoring pipeline pressure automatically.</p>
                        <button type="button" class="w-full py-1.5 bg-white border border-blue-200 text-blue-600 text-xs font-bold rounded-lg hover:bg-blue-50 transition">System Status</button>
                    </div>
                </div>
            </div>

            <div class="flex-1 flex flex-col overflow-hidden bg-slate-50">
                
                <header class="h-20 bg-white border-b border-slate-200 flex items-center justify-between px-4 md:px-8 shadow-sm z-10">
                    <div class="flex items-center gap-4">
                        <button type="button" class="md:hidden text-slate-500 hover:text-slate-700" onclick="toggleSidebar()">
                            <i class="fa-solid fa-bars text-xl"></i>
                        </button>
                        <h2 class="text-xl font-bold text-slate-800 hidden md:block">Water Operations Dashboard</h2>
                    </div>

                    <div class="flex items-center gap-6">
                        <button type="button" class="relative text-slate-400 hover:text-blue-600 transition">
                            <i class="fa-regular fa-bell text-xl"></i>
                            <span class="absolute top-0 right-0 flex h-2.5 w-2.5">
                              <span class="animate-ping absolute inline-flex h-full w-full rounded-full bg-red-400 opacity-75"></span>
                              <span class="relative inline-flex rounded-full h-2.5 w-2.5 bg-red-500 border-2 border-white"></span>
                            </span>
                        </button>
                        
                        <div class="flex items-center gap-3 pl-6 border-l border-slate-200">
                            <div class="text-right hidden sm:block">
                                <div class="text-sm font-bold text-slate-700"><asp:Literal ID="litAdminName" runat="server"></asp:Literal></div>
                                <div class="text-xs text-slate-400">Dept Head</div>
                            </div>
                            <div class="w-10 h-10 rounded-full bg-blue-100 border border-blue-200 flex items-center justify-center text-blue-600 font-bold shadow-sm">
                                <i class="fa-solid fa-user-tie"></i>
                            </div>
                        </div>
                    </div>
                </header>

                <main class="flex-1 overflow-y-auto p-4 md:p-8">
                    
                    <asp:UpdatePanel runat="server" UpdateMode="Conditional" ChildrenAsTriggers="true">
                        <ContentTemplate>
                            
                            <div class="grid grid-cols-1 sm:grid-cols-2 md:grid-cols-3 gap-6 mb-8">
                                <div class="stat-card p-5 flex items-center justify-between border-l-4 border-l-red-500">
                                    <div>
                                        <p class="text-slate-500 text-xs font-semibold uppercase tracking-wider">Unassigned</p>
                                        <h3 class="text-3xl font-bold text-slate-800 mt-1"><asp:Literal ID="litPendingCount" runat="server">0</asp:Literal></h3>
                                    </div>
                                    <div class="w-12 h-12 rounded-xl bg-red-50 text-red-500 flex items-center justify-center text-xl">
                                        <i class="fa-solid fa-triangle-exclamation"></i>
                                    </div>
                                </div>
                                <div class="stat-card p-5 flex items-center justify-between border-l-4 border-l-blue-500">
                                    <div>
                                        <p class="text-slate-500 text-xs font-semibold uppercase tracking-wider">In Progress</p>
                                        <h3 class="text-3xl font-bold text-slate-800 mt-1"><asp:Literal ID="litInProgressCount" runat="server">0</asp:Literal></h3>
                                    </div>
                                    <div class="w-12 h-12 rounded-xl bg-blue-50 text-blue-600 flex items-center justify-center text-xl">
                                        <i class="fa-solid fa-truck-fast"></i>
                                    </div>
                                </div>
                                <div class="stat-card p-5 flex items-center justify-between border-l-4 border-l-green-500">
                                    <div>
                                        <p class="text-slate-500 text-xs font-semibold uppercase tracking-wider">Resolved Today</p>
                                        <h3 class="text-3xl font-bold text-slate-800 mt-1"><asp:Literal ID="litResolvedCount" runat="server">0</asp:Literal></h3>
                                    </div>
                                    <div class="w-12 h-12 rounded-xl bg-green-50 text-green-600 flex items-center justify-center text-xl">
                                        <i class="fa-solid fa-check-double"></i>
                                    </div>
                                </div>
                            </div>

                            <div class="space-y-3">
                                <h3 class="font-bold text-slate-800 text-lg mb-3">Action Board</h3>
                                
                                <asp:Repeater ID="rptComplaints" runat="server">
                                    <ItemTemplate>
                                        <div class="task-card">
                                            
                                            <div class='<%# GetPriorityHeaderCss(Eval("PriorityLevel").ToString()) %> px-5 py-2.5 border-b flex justify-between items-center'>
                                                <div class="flex items-center gap-2">
                                                    <%# GetPriorityIcon(Eval("PriorityLevel").ToString()) %>
                                                    <span class="text-xs font-bold uppercase tracking-wide"><%# Eval("PriorityLevel") %> Priority</span>
                                                </div>
                                                <span class="text-xs font-mono font-bold opacity-80">ID: #WTR-<%# Eval("ComplaintID") %></span>
                                            </div>
                                            
                                            <div class="p-4 flex flex-col md:flex-row gap-5">
                                                
                                                <div class="w-full md:w-40 h-28 bg-slate-100 rounded-lg relative group overflow-hidden flex-shrink-0 border border-slate-200 cursor-pointer" onclick="openImageModal('<%# Eval("ImagePath") %>')">
                                                    <img src='<%# Eval("ImagePath") %>' class="w-full h-full object-cover transition duration-300 group-hover:scale-105" alt="Proof" onerror="this.src='/IMG/placeholder.jpg'" />
                                                    <div class="absolute inset-0 bg-slate-900/60 flex items-center justify-center opacity-0 group-hover:opacity-100 transition backdrop-blur-sm">
                                                        <div class="text-white text-xs font-bold flex items-center gap-1.5"><i class="fa-solid fa-expand"></i> View</div>
                                                    </div>
                                                </div>

                                                <div class="flex-1 flex flex-col lg:flex-row gap-4 justify-between">
                                                    
                                                    <div class="flex-1">
                                                        <div class="flex items-center justify-between mb-1">
                                                            <h3 class="font-bold text-slate-800 text-base truncate"><%# Eval("UserDepartment") %> Issue</h3>
                                                            <span class='text-[10px] font-bold px-2 py-0.5 rounded uppercase tracking-wider <%# GetStatusColor(Eval("Status").ToString()) %>'><%# Eval("Status") %></span>
                                                        </div>
                                                        <p class="text-slate-600 text-xs mb-3 leading-relaxed line-clamp-2"><%# Eval("Description") %></p>
                                                        
                                                        <div class="flex flex-wrap gap-4 mt-auto">
                                                            <div class="flex items-center gap-1.5 text-xs font-medium text-slate-500">
                                                                <i class="fa-regular fa-clock text-slate-400"></i> <%# Convert.ToDateTime(Eval("CreatedAt")).ToString("dd MMM, hh:mm tt") %>
                                                            </div>
                                                            <a href='<%# "https://www.google.com/maps/search/?api=1&query=" + Eval("Latitude") + "," + Eval("Longitude") %>' target="_blank" class="flex items-center gap-1.5 text-xs font-medium text-blue-600 hover:text-blue-800 hover:underline w-fit truncate max-w-[200px]">
                                                                <i class="fa-solid fa-location-dot"></i> <%# Eval("LocationName") %>
                                                            </a>
                                                        </div>
                                                        <%# GetProximityBadge(Eval("ProximityAlert")) %>
                                                    </div>
                                                    
                                                    <div class="bg-slate-50 rounded-lg p-3 border border-slate-200 text-xs w-full lg:w-56 shrink-0 h-fit self-start">
                                                        <div class="flex justify-between mb-1.5"><span class="text-slate-500">Citizen:</span><span class="font-bold text-slate-800 truncate ml-2"><%# Eval("CitizenName") %></span></div>
                                                        <div class="flex justify-between mb-2"><span class="text-slate-500">Phone:</span><span class="font-bold text-slate-800"><%# Eval("CitizenMobile") %></span></div>
                                                        
                                                        <div class="pt-2 border-t border-slate-200" style='<%# string.IsNullOrEmpty(Eval("StaffName").ToString()) ? "display:none;" : "" %>'>
                                                            <div class="flex justify-between items-center text-blue-700">
                                                                <span class="text-slate-500"><i class="fa-solid fa-user-check"></i> Team:</span>
                                                                <span class="font-bold truncate ml-1"><%# Eval("StaffName") %></span>
                                                            </div>
                                                        </div>
                                                    </div>
                                                </div>
                                            </div>
                                            
                                            <div class="bg-slate-50 px-5 py-3 border-t border-slate-100 flex flex-wrap justify-end gap-3">
                                                
                                                <button type="button" class="btn-action px-4 py-2 bg-blue-600 text-white hover:bg-blue-700 text-xs shadow-sm" 
                                                        onclick="openAssignModal('<%# Eval("ComplaintID") %>')">
                                                    <i class="fa-solid fa-user-plus mr-1"></i> <%# Eval("Status").ToString() == "Assigned" ? "Re-assign" : "Assign Team" %>
                                                </button>

                                                <button type="button" class="btn-action px-4 py-2 bg-green-600 text-white hover:bg-green-700 text-xs shadow-sm" 
                                                        onclick="openResolveModal('<%# Eval("ComplaintID") %>')">
                                                    <i class="fa-solid fa-check-double mr-1"></i> Mark Resolved
                                                </button>

                                            </div>
                                        </div>
                                    </ItemTemplate>
                                </asp:Repeater>

                                <div id="noDataPanel" runat="server" visible="false" class="text-center py-16 bg-white border border-slate-200 rounded-xl shadow-sm">
                                    <div class="w-16 h-16 bg-blue-50 text-blue-500 rounded-full flex items-center justify-center mx-auto mb-4 text-2xl">
                                        <i class="fa-solid fa-clipboard-check"></i>
                                    </div>
                                    <h3 class="text-lg font-bold text-slate-800">All caught up!</h3>
                                    <p class="text-slate-500 text-sm mt-1">There are no active water complaints pending.</p>
                                </div>
                            </div>

                        </ContentTemplate>
                    </asp:UpdatePanel>

                </main>
            </div>
        </div>

        <div id="imageModal" class="fixed inset-0 z-[100] hidden items-center justify-center bg-slate-900/80 backdrop-blur-sm px-4">
            <div class="relative max-w-4xl w-full">
                <button type="button" onclick="closeImageModal()" class="absolute -top-12 right-0 text-white hover:text-slate-300 text-3xl"><i class="fa-solid fa-xmark"></i></button>
                <img id="modalPreviewImg" src="" class="w-full h-auto max-h-[80vh] rounded-lg shadow-2xl object-contain bg-black" />
            </div>
        </div>

        <div id="assignModal" class="fixed inset-0 z-[100] hidden items-center justify-center bg-slate-900/60 backdrop-blur-sm px-4">
            <div class="bg-white rounded-2xl shadow-2xl border border-slate-200 p-6 w-full max-w-md modal-pop">
                <div class="flex justify-between items-center mb-5 border-b border-slate-100 pb-3">
                    <h3 class="font-bold text-lg text-slate-800">Dispatch Team</h3>
                    <button type="button" onclick="closeAssignModal()" class="text-slate-400 hover:text-red-500 transition text-lg"><i class="fa-solid fa-xmark"></i></button>
                </div>
                
                <asp:UpdatePanel runat="server">
                    <ContentTemplate>
                        <asp:HiddenField ID="hfSelectedComplaintId" runat="server" />
                        <div class="space-y-4">
                            <div>
                                <label class="block text-xs font-bold text-slate-700 mb-1.5 uppercase">Select Field Staff</label>
                                <asp:DropDownList ID="ddlStaff" runat="server" CssClass="w-full p-2.5 border border-slate-300 rounded-lg outline-none focus:border-blue-500 text-sm bg-slate-50"></asp:DropDownList>
                            </div>
                            <div>
                                <label class="block text-xs font-bold text-slate-700 mb-1.5 uppercase">Instructions / Comment (Optional)</label>
                                <asp:TextBox ID="txtAdminComment" runat="server" TextMode="MultiLine" Rows="3" CssClass="w-full p-2.5 border border-slate-300 rounded-lg outline-none focus:border-blue-500 text-sm" placeholder="E.g., Take heavy duty pipes..."></asp:TextBox>
                            </div>
                            <asp:Button ID="btnConfirmAssign" runat="server" Text="Confirm Dispatch" OnClick="btnConfirmAssign_Click" CssClass="w-full bg-blue-600 hover:bg-blue-700 text-white font-bold py-2.5 rounded-lg shadow-sm transition cursor-pointer mt-2" />
                        </div>
                    </ContentTemplate>
                </asp:UpdatePanel>
            </div>
        </div>

        <div id="resolveModal" class="fixed inset-0 z-[100] hidden items-center justify-center bg-slate-900/60 backdrop-blur-sm px-4">
            <div class="bg-white rounded-2xl shadow-2xl border border-slate-200 p-6 w-full max-w-md modal-pop">
                <div class="flex justify-between items-center mb-5 border-b border-slate-100 pb-3">
                    <h3 class="font-bold text-lg text-slate-800">Resolve Complaint</h3>
                    <button type="button" onclick="closeResolveModal()" class="text-slate-400 hover:text-red-500 transition text-lg"><i class="fa-solid fa-xmark"></i></button>
                </div>
                
                <asp:UpdatePanel runat="server">
                    <ContentTemplate>
                        <asp:HiddenField ID="hfResolveComplaintId" runat="server" />
                        <div class="space-y-4">
                            <div>
                                <label class="block text-xs font-bold text-slate-700 mb-1.5 uppercase">Action Taken Remark <span class="text-red-500">*</span></label>
                                <asp:TextBox ID="txtResolveRemark" runat="server" TextMode="MultiLine" Rows="3" CssClass="w-full p-2.5 border border-slate-300 rounded-lg outline-none focus:border-green-500 text-sm" placeholder="E.g., Pipeline repaired and supply restored."></asp:TextBox>
                            </div>
                            <asp:Button ID="btnConfirmResolve" runat="server" Text="Complete Task" OnClick="btnConfirmResolve_Click" CssClass="w-full bg-green-600 hover:bg-green-700 text-white font-bold py-2.5 rounded-lg shadow-sm transition cursor-pointer mt-2" />
                        </div>
                    </ContentTemplate>
                </asp:UpdatePanel>
            </div>
        </div>

        <script>
            function toggleSidebar() {
                const sidebar = document.getElementById('mobileSidebar');
                sidebar.classList.toggle('-translate-x-full');
            }
            function openImageModal(imgSrc) {
                document.getElementById('modalPreviewImg').src = imgSrc;
                document.getElementById('imageModal').classList.remove('hidden');
                document.getElementById('imageModal').classList.add('flex');
            }
            function closeImageModal() {
                document.getElementById('imageModal').classList.add('hidden');
                document.getElementById('imageModal').classList.remove('flex');
                document.getElementById('modalPreviewImg').src = '';
            }
            function openAssignModal(complaintId) {
                document.getElementById('<%= hfSelectedComplaintId.ClientID %>').value = complaintId;
                document.getElementById('assignModal').classList.remove('hidden');
                document.getElementById('assignModal').classList.add('flex');
            }
            function closeAssignModal() {
                document.getElementById('assignModal').classList.add('hidden');
                document.getElementById('assignModal').classList.remove('flex');
            }
            function openResolveModal(complaintId) {
                document.getElementById('<%= hfResolveComplaintId.ClientID %>').value = complaintId;
                document.getElementById('resolveModal').classList.remove('hidden');
                document.getElementById('resolveModal').classList.add('flex');
            }
            function closeResolveModal() {
                document.getElementById('resolveModal').classList.add('hidden');
                document.getElementById('resolveModal').classList.remove('flex');
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