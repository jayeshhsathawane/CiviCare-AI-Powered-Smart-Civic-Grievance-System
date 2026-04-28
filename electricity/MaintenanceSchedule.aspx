<%@ Page Language="C#" AutoEventWireup="true" CodeFile="MaintenanceSchedule.aspx.cs" Inherits="MaintenanceSchedule" %>
<!DOCTYPE html>
<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title>Maintenance | Electric Dept</title>
    <meta name="viewport" content="width=device-width, initial-scale=1.0" />
    <script src="https://cdn.tailwindcss.com"></script>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css" />
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@300;400;500;600;700&display=swap" rel="stylesheet"/>
    <style>
        body { font-family: 'Inter', sans-serif; background-color: #f8fafc; }
        .no-scrollbar::-webkit-scrollbar { display: none; }
        .no-scrollbar { -ms-overflow-style: none;  }
        .nav-link { border-radius: 8px; transition: all 0.2s ease-in-out; color: #64748b; font-weight:500; }
        .nav-link:hover { background-color: #f1f5f9; color: #1e293b; }
        .nav-link.active { background-color: #fff7ed; color: #ea580c; font-weight: 600; }
        .stat-card { background: white; border: 1px solid #e2e8f0; border-radius: 12px; box-shadow: 0 1px 3px 0 rgba(0,0,0,0.1); }
        
        .form-label { font-size: 0.75rem; font-weight: 700; text-transform: uppercase; letter-spacing: 0.05em; color: #64748b; margin-bottom: 0.5rem; display: block; }
        .form-input { width: 100%; padding: 0.75rem 1rem; border: 1px solid #cbd5e1; border-radius: 8px; font-size: 0.875rem; color: #334155; transition: all 0.2s; background-color: #fff; }
        .form-input:focus { outline: none; border-color: #ea580c; box-shadow: 0 0 0 3px rgba(234, 88, 12, 0.1); }

        @keyframes popIn { from { opacity: 0; transform: scale(0.95); } to { opacity: 1; transform: scale(1); } }
        .modal-pop { animation: popIn 0.2s ease-out forwards; }
        
        @keyframes slideInRight { from { transform: translateX(100%); opacity: 0; } to { transform: translateX(0); opacity: 1; } }
        @keyframes fadeOutUp { from { opacity: 1; transform: translateY(0); } to { opacity: 0; transform: translateY(-20px); } }
        .toast-enter { animation: slideInRight 0.4s cubic-bezier(0.16, 1, 0.3, 1) forwards; }
        .toast-exit { animation: fadeOutUp 0.4s ease forwards; }

        #mobileSidebar { transition: transform 0.3s ease-in-out; }
    </style>
</head>
<body class="text-slate-600 antialiased">
    <div id="toast-container" class="fixed top-5 right-5 z-[99999] flex flex-col gap-3 pointer-events-none"></div>

    <form id="form1" runat="server">
        <asp:ScriptManager runat="server" />
        
        <div class="flex h-screen overflow-hidden">
            
            <aside class="hidden md:flex w-72 flex-col bg-white border-r border-slate-200 z-20 shadow-sm">
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
                    <%--<a href="PowerGridStatus.aspx" class="nav-link flex items-center px-4 py-3 text-sm">
                        <i class="fa-solid fa-tower-observation w-6 opacity-75"></i> Power Grid Status
                    </a>--%>
                    <a href="MaintenanceSchedule.aspx" class="nav-link active flex items-center px-4 py-3 text-sm">
                        <i class="fa-solid fa-screwdriver-wrench w-6 opacity-75"></i> Maintenance Schedule
                    </a>
                    <a href="ElectricResolvedHistory.aspx" class="nav-link flex items-center px-4 py-3 text-sm">
                        <i class="fa-solid fa-check-double w-6 opacity-75"></i> Resolved History
                    </a>
                   <p class="px-4 text-xs font-bold text-slate-400 uppercase tracking-widest mt-8 mb-3">Management</p>
                   <%-- <a href="DispatchUnits.aspx" class="nav-link flex items-center px-4 py-3 text-sm">
                        <i class="fa-solid fa-truck-fast w-6 opacity-75"></i> Dispatch Units
                    </a>--%>
                    <a href="ElectricFieldStaff.aspx" class="nav-link flex items-center px-4 py-3 text-sm">
                        <i class="fa-solid fa-users-gear w-6 opacity-75"></i> Field Staff
                    </a>
                   <p class="px-4 text-xs font-bold text-slate-400 uppercase tracking-widest mt-8 mb-3">Account</p>
                    <%-- <a href="Profile.aspx" class="nav-link flex items-center px-4 py-3 text-sm">
                        <i class="fa-solid fa-user-gear w-6 opacity-75"></i> My Profile
                    </a>--%>
                    <a href="/SystemLogin.aspx?action=logout" class="nav-link flex items-center px-4 py-3 text-sm text-red-500 hover:bg-red-50 hover:text-red-600 mt-2 transition">
                        <i class="fa-solid fa-right-from-bracket w-6 opacity-75"></i> Secure Logout
                    </a>
                </nav>
            </aside>

            <div id="mobileSidebar" class="fixed inset-y-0 left-0 w-72 bg-white shadow-2xl z-50 transform -translate-x-full md:hidden flex flex-col border-r border-slate-200">
                <div class="h-20 flex items-center justify-between px-6 border-b border-slate-100">
                    <div class="flex items-center gap-3">
                        <div class="w-9 h-9 bg-orange-500 rounded-lg flex items-center justify-center text-white text-xl shadow-lg shadow-orange-200">
                            <i class="fa-solid fa-bolt"></i>
                        </div>
                        <span class="text-xl font-bold tracking-tight text-slate-800">Electric<span class="text-orange-500">Dept</span></span>
                    </div>
                    <button type="button" onclick="toggleSidebar()" class="text-slate-400 hover:text-red-500 transition text-2xl"><i class="fa-solid fa-xmark"></i></button>
                </div>
                <nav class="flex-1 py-6 px-4 space-y-1.5 overflow-y-auto no-scrollbar">
                    <p class="px-4 text-xs font-bold text-slate-400 uppercase tracking-widest mb-3">Operations</p>
                    <a href="ElectricDeptDashboard.aspx" class="nav-link flex items-center px-4 py-3 text-sm">
                        <i class="fa-solid fa-clipboard-list w-6 opacity-75"></i> Active Tasks
                    </a>
                   <%-- <a href="PowerGridStatus.aspx" class="nav-link flex items-center px-4 py-3 text-sm">
                        <i class="fa-solid fa-tower-observation w-6 opacity-75"></i> Power Grid Status
                    </a>--%>
                    <a href="MaintenanceSchedule.aspx" class="nav-link active flex items-center px-4 py-3 text-sm">
                        <i class="fa-solid fa-screwdriver-wrench w-6 opacity-75"></i> Maintenance Schedule
                    </a>
                    <a href="ElectricResolvedHistory.aspx" class="nav-link flex items-center px-4 py-3 text-sm">
                        <i class="fa-solid fa-check-double w-6 opacity-75"></i> Resolved History
                    </a>
                    <p class="px-4 text-xs font-bold text-slate-400 uppercase tracking-widest mt-8 mb-3">Management</p>
                    <%--<a href="DispatchUnits.aspx" class="nav-link flex items-center px-4 py-3 text-sm">
                        <i class="fa-solid fa-truck-fast w-6 opacity-75"></i> Dispatch Units
                    </a>--%>
                    <a href="ElectricFieldStaff.aspx" class="nav-link flex items-center px-4 py-3 text-sm">
                        <i class="fa-solid fa-users-gear w-6 opacity-75"></i> Field Staff
                    </a>
                    <p class="px-4 text-xs font-bold text-slate-400 uppercase tracking-widest mt-8 mb-3">Account</p>
                <%--    <a href="Profile.aspx" class="nav-link flex items-center px-4 py-3 text-sm">
                        <i class="fa-solid fa-user-gear w-6 opacity-75"></i> My Profile
                    </a>--%>
                    <a href="/SystemLogin.aspx?action=logout" class="nav-link flex items-center px-4 py-3 text-sm text-red-500 hover:bg-red-50 hover:text-red-600 mt-2 transition">
                        <i class="fa-solid fa-right-from-bracket w-6 opacity-75"></i> Secure Logout
                    </a>
                </nav>
            </div>

            <div class="flex-1 flex flex-col overflow-hidden bg-slate-50">
                <header class="h-20 bg-white border-b border-slate-200 flex items-center justify-between px-4 md:px-8 shadow-sm z-10">
                    <div class="flex items-center gap-4">
                        <button type="button" class="md:hidden text-slate-500 hover:text-slate-700" onclick="toggleSidebar()"><i class="fa-solid fa-bars text-xl"></i></button>
                        <h2 class="text-xl font-bold text-slate-800">Planned Outages & Maintenance</h2>
                    </div>
                    <button type="button" onclick="openScheduleModal()" class="bg-orange-500 hover:bg-orange-600 text-white px-4 py-2.5 rounded-lg text-sm font-bold shadow-md transition flex items-center gap-2">
                        <i class="fa-solid fa-calendar-plus"></i><span class="hidden sm:inline">Schedule Outage</span>
                    </button>
                </header>

                <main class="flex-1 overflow-y-auto p-4 md:p-8">
                    
                    <asp:UpdatePanel runat="server" UpdateMode="Conditional" ChildrenAsTriggers="true">
                        <ContentTemplate>
                            
                            <div class="stat-card overflow-hidden">
                                <div class="px-6 py-5 border-b border-slate-100 flex justify-between items-center bg-white">
                                    <h3 class="font-bold text-slate-800 uppercase text-sm tracking-wide flex items-center gap-2">
                                        <i class="fa-solid fa-clock-rotate-left text-orange-500"></i> Upcoming & Active Schedules
                                    </h3>
                                </div>
                                <div class="overflow-x-auto w-full">
                                    <table class="w-full text-left text-sm text-slate-600 min-w-[800px]">
                                        <thead class="bg-slate-50 text-slate-500 font-semibold uppercase text-[10px] tracking-wider border-b border-slate-200">
                                            <tr>
                                                <th class="p-4 pl-6">Date & Time</th>
                                                <th class="p-4">Affected Area</th>
                                                <th class="p-4">Purpose</th>
                                                <th class="p-4">Assigned Team</th>
                                                <th class="p-4 text-center">Status</th>
                                                <th class="p-4 text-right pr-6">Action</th>
                                            </tr>
                                        </thead>
                                        <tbody class="divide-y divide-slate-100 bg-white">
                                            <asp:Repeater ID="rptSchedules" runat="server" OnItemCommand="rptSchedules_ItemCommand">
                                                <ItemTemplate>
                                                    <tr class="hover:bg-slate-50/50 transition duration-150">
                                                        <td class="p-4 pl-6 font-mono text-xs text-slate-800">
                                                            <span class="font-bold block text-sm"><%# Convert.ToDateTime(Eval("MaintenanceDate")).ToString("dd MMM, yyyy") %></span>
                                                            <span class="text-orange-600 font-bold"><i class="fa-regular fa-clock"></i> <%# Eval("StartTime") %> to <%# Eval("EndTime") %></span>
                                                        </td>
                                                        <td class="p-4 font-semibold text-slate-800"><%# Eval("AffectedArea") %></td>
                                                        <td class="p-4"><%# Eval("Purpose") %></td>
                                                        <td class="p-4 font-medium text-slate-700">
                                                            <i class="fa-solid fa-helmet-safety text-orange-400 mr-1.5"></i> <%# Eval("AssignedTeam") %>
                                                        </td>
                                                        <td class="p-4 text-center">
                                                            <span class='<%# Eval("Status").ToString() == "Completed" ? "bg-green-100 text-green-700 border-green-200" : "bg-blue-100 text-blue-700 border-blue-200" %> px-2.5 py-1 rounded-md text-[10px] font-bold uppercase tracking-wider border shadow-sm'>
                                                                <%# Eval("Status") %>
                                                            </span>
                                                        </td>
                                                        <td class="p-4 text-right pr-6">
                                                            <asp:Button ID="btnComplete" runat="server" CommandName="MarkComplete" CommandArgument='<%# Eval("ScheduleID") %>' 
                                                                Text="Mark Done" 
                                                                Visible='<%# Eval("Status").ToString() != "Completed" %>'
                                                                CssClass="bg-green-600 hover:bg-green-700 text-white px-3 py-1.5 rounded text-xs font-bold shadow-sm transition cursor-pointer" />
                                                            <span runat="server" visible='<%# Eval("Status").ToString() == "Completed" %>' class="text-green-600 font-bold text-xs"><i class="fa-solid fa-check"></i> Done</span>
                                                        </td>
                                                    </tr>
                                                </ItemTemplate>
                                            </asp:Repeater>

                                            <tr runat="server" id="trNoData" visible="false">
                                                <td colspan="6" class="p-10 text-center text-slate-500 border-none">
                                                    <i class="fa-solid fa-calendar-check text-4xl mb-4 text-slate-300 block"></i>
                                                    <span class="font-bold text-lg text-slate-700">No active maintenance scheduled.</span>
                                                </td>
                                            </tr>
                                        </tbody>
                                    </table>
                                </div>
                            </div>

                            <div id="scheduleModal" class="fixed inset-0 z-[100] hidden items-center justify-center bg-slate-900/60 backdrop-blur-sm px-4 py-6 overflow-y-auto">
                                <div class="bg-white rounded-2xl shadow-2xl border border-slate-200 w-full max-w-lg modal-pop m-auto">
                                    <div class="px-6 py-4 border-b border-slate-100 flex justify-between items-center bg-slate-50 rounded-t-2xl">
                                        <h3 class="font-bold text-lg text-slate-800"><i class="fa-solid fa-calendar-plus text-orange-500 mr-2"></i> Create Maintenance Schedule</h3>
                                        <button type="button" onclick="closeScheduleModal()" class="text-slate-400 hover:text-red-500 transition text-lg"><i class="fa-solid fa-xmark"></i></button>
                                    </div>
                                    
                                    <div class="p-6 space-y-4">
                                        <div class="bg-blue-50 border-l-4 border-blue-500 p-3 rounded text-xs text-blue-800 shadow-sm leading-relaxed">
                                            <i class="fa-solid fa-circle-info mr-1"></i> As soon as you save this, an <strong>email alert will be broadcasted</strong> to all citizens and the selected field team.
                                        </div>

                                        <div class="grid grid-cols-1 sm:grid-cols-2 gap-4">
                                            <div>
                                                <label class="form-label">Date <span class="text-red-500">*</span></label>
                                                <asp:TextBox ID="txtDate" runat="server" TextMode="Date" CssClass="form-input"></asp:TextBox>
                                                <asp:RequiredFieldValidator ID="rfvDate" runat="server" ControlToValidate="txtDate" ErrorMessage="Required" ValidationGroup="AddSchedule" CssClass="val-error" Display="Dynamic" />
                                            </div>
                                            <div>
                                                <label class="form-label">Assigned Team <span class="text-red-500">*</span></label>
                                                <asp:DropDownList ID="ddlStaff" runat="server" CssClass="form-input appearance-none bg-white cursor-pointer"></asp:DropDownList>
                                                <asp:RequiredFieldValidator ID="rfvStaff" runat="server" ControlToValidate="ddlStaff" InitialValue="" ErrorMessage="Required" ValidationGroup="AddSchedule" CssClass="val-error" Display="Dynamic" />
                                            </div>
                                        </div>

                                        <div class="grid grid-cols-1 sm:grid-cols-2 gap-4">
                                            <div>
                                                <label class="form-label">Start Time <span class="text-red-500">*</span></label>
                                                <asp:TextBox ID="txtStart" runat="server" TextMode="Time" CssClass="form-input"></asp:TextBox>
                                                <asp:RequiredFieldValidator ID="rfvStart" runat="server" ControlToValidate="txtStart" ErrorMessage="Required" ValidationGroup="AddSchedule" CssClass="val-error" Display="Dynamic" />
                                            </div>
                                            <div>
                                                <label class="form-label">End Time <span class="text-red-500">*</span></label>
                                                <asp:TextBox ID="txtEnd" runat="server" TextMode="Time" CssClass="form-input"></asp:TextBox>
                                                <asp:RequiredFieldValidator ID="rfvEnd" runat="server" ControlToValidate="txtEnd" ErrorMessage="Required" ValidationGroup="AddSchedule" CssClass="val-error" Display="Dynamic" />
                                            </div>
                                        </div>

                                        <div>
                                            <label class="form-label">Affected Area / Location <span class="text-red-500">*</span></label>
                                            <asp:TextBox ID="txtArea" runat="server" CssClass="form-input" placeholder="e.g. Sector 12, Manewada"></asp:TextBox>
                                            <asp:RequiredFieldValidator ID="rfvArea" runat="server" ControlToValidate="txtArea" ErrorMessage="Required" ValidationGroup="AddSchedule" CssClass="val-error" Display="Dynamic" />
                                        </div>

                                        <div>
                                            <label class="form-label">Maintenance Purpose <span class="text-red-500">*</span></label>
                                            <asp:TextBox ID="txtPurpose" runat="server" CssClass="form-input" placeholder="e.g. Transformer repair and cabling"></asp:TextBox>
                                            <asp:RequiredFieldValidator ID="rfvPurpose" runat="server" ControlToValidate="txtPurpose" ErrorMessage="Required" ValidationGroup="AddSchedule" CssClass="val-error" Display="Dynamic" />
                                        </div>

                                        <div class="pt-4 border-t border-slate-100 flex justify-end gap-3 mt-2">
                                            <button type="button" onclick="closeScheduleModal()" class="px-5 py-2.5 rounded-lg border border-slate-300 text-slate-600 font-bold text-sm hover:bg-slate-50 transition">Cancel</button>
                                            <asp:Button ID="btnSaveSchedule" runat="server" Text="Broadcast & Save Schedule" OnClick="btnSaveSchedule_Click" ValidationGroup="AddSchedule" UseSubmitBehavior="false" CssClass="px-5 py-2.5 bg-orange-600 hover:bg-orange-700 text-white font-bold rounded-lg shadow-md transition cursor-pointer text-sm flex items-center gap-2" />
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
                const sidebar = document.getElementById('mobileSidebar');
                sidebar.classList.toggle('-translate-x-full');
            }

            function openScheduleModal() {
                const modal = document.getElementById('scheduleModal');
                modal.classList.remove('hidden');
                modal.classList.add('flex');
            }

            function closeScheduleModal() {
                const modal = document.getElementById('scheduleModal');
                modal.classList.add('hidden');
                modal.classList.remove('flex');
            }

            function showToast(message, type) {
                const container = document.getElementById('toast-container');
                const toast = document.createElement('div');
                const isSuccess = type === 'success';
                const bgColor = isSuccess ? 'bg-emerald-600' : 'bg-red-600';
                const icon = isSuccess ? 'fa-circle-check' : 'fa-circle-exclamation';

                toast.className = `flex items-center gap-3 px-5 py-4 rounded-xl shadow-2xl text-white text-sm font-bold toast-enter pointer-events-auto ${bgColor}`;
                toast.innerHTML = `<i class="fa-solid ${icon} text-lg"></i> <span>${message}</span>`;
                
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