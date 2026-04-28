<%@ Page Language="C#" AutoEventWireup="true" CodeFile="ElectricFieldStaff.aspx.cs" Inherits="ElectricFieldStaff" %>

<!DOCTYPE html>
<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title>Manage Field Staff | Electric Dept</title>
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
        .nav-link.active { background-color: #fff7ed; color: #ea580c; font-weight: 600; }

        .content-card { background: white; border: 1px solid #e2e8f0; border-radius: 12px; box-shadow: 0 1px 3px 0 rgba(0, 0, 0, 0.1); }
        
        .form-label { font-size: 0.75rem; font-weight: 700; text-transform: uppercase; letter-spacing: 0.05em; color: #64748b; margin-bottom: 0.5rem; display: block; }
        .form-input { width: 100%; padding: 0.75rem 1rem 0.75rem 2.5rem; border: 1px solid #cbd5e1; border-radius: 8px; font-size: 0.875rem; color: #334155; transition: all 0.2s; background-color: #fff; }
        .form-input:focus { outline: none; border-color: #ea580c; box-shadow: 0 0 0 3px rgba(234, 88, 12, 0.1); }
        .input-icon { position: absolute; left: 1rem; top: 50%; transform: translateY(-50%); color: #94a3b8; font-size: 0.9rem; }

        .bordered-table th, .bordered-table td { border: 1px solid #f1f5f9; }

        @keyframes slideInRight { from { transform: translateX(100%); opacity: 0; } to { transform: translateX(0); opacity: 1; } }
        @keyframes fadeOutUp { from { opacity: 1; transform: translateY(0); } to { opacity: 0; transform: translateY(-20px); } }
        .toast-enter { animation: slideInRight 0.4s cubic-bezier(0.16, 1, 0.3, 1) forwards; }
        .toast-exit { animation: fadeOutUp 0.4s ease forwards; }
        
        @keyframes popIn { from { opacity: 0; transform: scale(0.95); } to { opacity: 1; transform: scale(1); } }
        .modal-pop { animation: popIn 0.2s ease-out forwards; }
        .val-error { color: #ef4444; font-size: 0.75rem; font-weight: 500; display: block; margin-top: 0.25rem; }

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
                   <%-- <a href="PowerGridStatus.aspx" class="nav-link flex items-center px-4 py-3 text-sm">
                        <i class="fa-solid fa-tower-observation w-6 opacity-75"></i> Power Grid Status
                    </a>--%>
                    <a href="MaintenanceSchedule.aspx" class="nav-link flex items-center px-4 py-3 text-sm">
                        <i class="fa-solid fa-screwdriver-wrench w-6 opacity-75"></i> Maintenance Schedule
                    </a>
                    <a href="ElectricResolvedHistory.aspx" class="nav-link flex items-center px-4 py-3 text-sm">
                        <i class="fa-solid fa-check-double w-6 opacity-75"></i> Resolved History
                    </a>
                    
                    <p class="px-4 text-xs font-bold text-slate-400 uppercase tracking-widest mt-8 mb-3">Management</p>
                  <%--  <a href="DispatchUnits.aspx" class="nav-link flex items-center px-4 py-3 text-sm">
                        <i class="fa-solid fa-truck-fast w-6 opacity-75"></i> Dispatch Units
                    </a>--%>
                    <a href="ElectricFieldStaff.aspx" class="nav-link active flex items-center px-4 py-3 text-sm">
                        <i class="fa-solid fa-users-gear w-6 opacity-75"></i> Field Staff
                    </a>
                    <a href="/SystemLogin.aspx?action=logout" class="nav-link flex items-center px-4 py-3 text-sm text-red-500 hover:bg-red-50 hover:text-red-600 mt-2">
                        <i class="fa-solid fa-right-from-bracket w-6 opacity-75"></i> Logout
                    </a>
                </nav>

                <div class="p-4 border-t border-slate-100 hidden">
                    <div class="bg-gradient-to-br from-orange-50 to-amber-50 border border-orange-100 rounded-xl p-4">
                        <div class="flex items-center gap-3 mb-2">
                            <div class="p-2 bg-white rounded-lg shadow-sm text-orange-500"><i class="fa-solid fa-bolt-lightning"></i></div>
                            <span class="font-bold text-slate-800 text-sm">AI Grid Monitor</span>
                        </div>
                        <p class="text-xs text-slate-500 mb-3">System is monitoring power load actively.</p>
                        <button class="w-full py-1.5 bg-white border border-orange-200 text-orange-600 text-xs font-bold rounded-lg hover:bg-orange-50 transition">View Logs</button>
                    </div>
                </div>
            </aside>

            <div id="mobileSidebar" class="fixed inset-y-0 left-0 w-72 bg-white shadow-2xl z-50 transform -translate-x-full md:hidden flex flex-col border-r border-slate-200">
                <div class="h-20 flex items-center justify-between px-6 border-b border-slate-100">
                    <div class="flex items-center gap-3">
                        <div class="w-9 h-9 bg-orange-500 rounded-lg flex items-center justify-center text-white text-xl shadow-lg shadow-orange-200">
                            <i class="fa-solid fa-bolt"></i>
                        </div>
                        <span class="text-xl font-bold tracking-tight text-slate-800">Electric<span class="text-orange-500">Dept</span></span>
                    </div>
                    <button type="button" onclick="toggleSidebar()" class="text-slate-500 hover:text-red-500 transition text-2xl"><i class="fa-solid fa-xmark"></i></button>
                </div>
                <nav class="flex-1 py-6 px-4 space-y-1.5 overflow-y-auto no-scrollbar">
                    <p class="px-4 text-xs font-bold text-slate-400 uppercase tracking-widest mb-3">Operations</p>
                    <a href="ElectricDeptDashboard.aspx" class="nav-link flex items-center px-4 py-3 text-sm">
                        <i class="fa-solid fa-clipboard-list w-6 opacity-75"></i> Active Tasks
                    </a>
                   <%-- <a href="PowerGridStatus.aspx" class="nav-link flex items-center px-4 py-3 text-sm">
                        <i class="fa-solid fa-tower-observation w-6 opacity-75"></i> Power Grid Status
                    </a>--%>
                    <a href="MaintenanceSchedule.aspx" class="nav-link flex items-center px-4 py-3 text-sm">
                        <i class="fa-solid fa-screwdriver-wrench w-6 opacity-75"></i> Maintenance Schedule
                    </a>
                    <a href="ElectricResolvedHistory.aspx" class="nav-link flex items-center px-4 py-3 text-sm">
                        <i class="fa-solid fa-check-double w-6 opacity-75"></i> Resolved History
                    </a>
                    <p class="px-4 text-xs font-bold text-slate-400 uppercase tracking-widest mt-8 mb-3">Management</p>
                   <%-- <a href="DispatchUnits.aspx" class="nav-link flex items-center px-4 py-3 text-sm">
                        <i class="fa-solid fa-truck-fast w-6 opacity-75"></i> Dispatch Units
                    </a>--%>
                    <a href="ElectricFieldStaff.aspx" class="nav-link active flex items-center px-4 py-3 text-sm">
                        <i class="fa-solid fa-users-gear w-6 opacity-75"></i> Field Staff
                    </a>
                    <a href="/SystemLogin.aspx?action=logout" class="nav-link flex items-center px-4 py-3 text-sm text-red-500 hover:bg-red-50 hover:text-red-600 mt-2">
                        <i class="fa-solid fa-right-from-bracket w-6 opacity-75"></i> Logout
                    </a>
                </nav>
            </div>

            <div class="flex-1 flex flex-col overflow-hidden bg-slate-50">
                <header class="h-20 bg-white border-b border-slate-200 flex items-center justify-between px-4 md:px-8 shadow-sm z-10">
                    <div class="flex items-center gap-4">
                        <button type="button" class="md:hidden text-slate-500" onclick="toggleSidebar()"><i class="fa-solid fa-bars text-xl"></i></button>
                        <h2 class="text-xl font-bold text-slate-800 hidden md:block">Manage Field Staff</h2>
                    </div>
                    <div class="flex items-center gap-6">
                        <div class="flex items-center gap-3 pl-6 border-l border-slate-200">
                            <div class="text-right hidden sm:block">
                                <div class="text-sm font-bold text-slate-700"><asp:Literal ID="litAdminName" runat="server"></asp:Literal></div>
                                <div class="text-xs text-slate-400">Dept Head</div>
                            </div>
                            <div class="w-10 h-10 rounded-full bg-orange-50 border border-orange-100 flex items-center justify-center text-orange-600 font-bold shadow-sm">
                                <i class="fa-solid fa-user-tie"></i>
                            </div>
                        </div>
                    </div>
                </header>

                <main class="flex-1 overflow-y-auto p-4 md:p-8">
                    
                    <asp:UpdatePanel runat="server" UpdateMode="Conditional" ChildrenAsTriggers="true">
                        <ContentTemplate>
                            
                            <div class="content-card mb-8 overflow-hidden bg-white">
                                <div class="bg-gradient-to-r from-orange-500 to-orange-600 px-6 py-5 flex items-center gap-4 border-b border-orange-700">
                                    <div class="w-10 h-10 rounded-full bg-white/20 flex items-center justify-center text-white shadow-inner"><i class="fa-solid fa-user-plus"></i></div>
                                    <div>
                                        <h3 class="font-bold text-white text-lg">Add New Field Worker</h3>
                                        <p class="text-xs text-orange-100 mt-0.5">Register new staff to assign them complaints.</p>
                                    </div>
                                </div>
                                
                                <div class="p-6 md:p-8">
                                    <div class="grid grid-cols-1 md:grid-cols-3 gap-6">
                                        <div>
                                            <label class="form-label">Full Name <span class="text-red-500">*</span></label>
                                            <div class="relative">
                                                <i class="fa-solid fa-user input-icon"></i>
                                                <asp:TextBox ID="txtName" runat="server" CssClass="form-input" placeholder="e.g. Ramesh Kumar"></asp:TextBox>
                                            </div>
                                            <asp:RequiredFieldValidator ID="rfvName" runat="server" ControlToValidate="txtName" ErrorMessage="Required" ValidationGroup="AddStaff" CssClass="val-error" Display="Dynamic" />
                                        </div>
                                        
                                        <div>
                                            <label class="form-label">Mobile Number <span class="text-red-500">*</span></label>
                                            <div class="relative">
                                                <i class="fa-solid fa-phone input-icon"></i>
                                                <asp:TextBox ID="txtMobile" runat="server" MaxLength="10" CssClass="form-input" placeholder="10-digit mobile number"></asp:TextBox>
                                            </div>
                                            <asp:RequiredFieldValidator ID="rfvMobile" runat="server" ControlToValidate="txtMobile" ErrorMessage="Required" ValidationGroup="AddStaff" CssClass="val-error" Display="Dynamic" />
                                            <asp:RegularExpressionValidator ID="revMobile" runat="server" ControlToValidate="txtMobile" ValidationExpression="^\d{10}$" ErrorMessage="Invalid format" ValidationGroup="AddStaff" CssClass="val-error" Display="Dynamic" />
                                        </div>

                                        <div>
                                            <label class="form-label">Staff Email <span class="text-red-500">*</span></label>
                                            <div class="relative">
                                                <i class="fa-solid fa-envelope input-icon"></i>
                                                <asp:TextBox ID="txtEmail" runat="server" CssClass="form-input" placeholder="For task notifications"></asp:TextBox>
                                            </div>
                                            <asp:RequiredFieldValidator ID="rfvEmail" runat="server" ControlToValidate="txtEmail" ErrorMessage="Required" ValidationGroup="AddStaff" CssClass="val-error" Display="Dynamic" />
                                            <asp:RegularExpressionValidator ID="revEmail" runat="server" ControlToValidate="txtEmail" ValidationExpression="^\w+([-+.']\w+)*@\w+([-.]\w+)*\.\w+([-.]\w+)*$" ErrorMessage="Invalid email" ValidationGroup="AddStaff" CssClass="val-error" Display="Dynamic" />
                                        </div>
                                    </div>

                                    <div class="mt-8 pt-6 border-t border-slate-100 flex justify-end gap-3">
                                        <asp:Button ID="btnCancel" runat="server" Text="Clear" OnClick="btnCancel_Click" CausesValidation="false" CssClass="px-6 py-2.5 rounded-lg border border-slate-300 text-slate-600 font-bold text-sm hover:bg-slate-50 transition cursor-pointer" />
                                        <asp:Button ID="btnAddStaff" runat="server" Text="Register Staff" OnClick="btnAddStaff_Click" ValidationGroup="AddStaff" CssClass="px-6 py-2.5 bg-orange-600 hover:bg-orange-700 text-white font-bold rounded-lg shadow-md transition cursor-pointer text-sm" />
                                    </div>
                                </div>
                            </div>

                            <div class="content-card overflow-hidden">
                                <div class="px-6 py-5 border-b border-slate-100 bg-white flex justify-between items-center">
                                    <h3 class="font-bold text-slate-800 text-lg flex items-center gap-2">
                                        <i class="fa-solid fa-users-gear text-orange-500"></i> Electric Dept Staff Directory
                                    </h3>
                                </div>
                                
                                <div class="overflow-x-auto w-full">
                                    <table class="w-full text-left text-sm text-slate-600 min-w-[700px] bordered-table border-collapse">
                                        <thead class="bg-slate-50 text-slate-500 font-bold uppercase text-xs">
                                            <tr>
                                                <th class="p-4 pl-6 tracking-wide bg-slate-100/50">Staff Info</th>
                                                <th class="p-4 tracking-wide bg-slate-100/50">Contact</th>
                                                <th class="p-4 tracking-wide bg-slate-100/50 text-center">Status</th>
                                                <th class="p-4 text-center pr-6 tracking-wide bg-slate-100/50">Actions</th>
                                            </tr>
                                        </thead>
                                        <tbody class="divide-y divide-slate-100 bg-white">
                                            <asp:Repeater ID="rptStaff" runat="server" OnItemCommand="rptStaff_ItemCommand">
                                                <ItemTemplate>
                                                    <tr class="hover:bg-orange-50/30 transition duration-150">
                                                        <td class="p-4 pl-6">
                                                            <div class="flex items-center gap-3">
                                                                <div class="w-10 h-10 rounded-full flex items-center justify-center text-xs font-bold bg-orange-100 text-orange-600 border border-orange-200 shadow-sm">
                                                                    <%# GetInitials(Eval("FullName").ToString()) %>
                                                                </div>
                                                                <div>
                                                                    <span class="font-bold text-slate-800 block text-sm"><%# Eval("FullName") %></span>
                                                                    <span class="text-[10px] font-mono text-slate-400">ID: STF-<%# Eval("StaffID") %></span>
                                                                </div>
                                                            </div>
                                                        </td>
                                                        <td class="p-4">
                                                            <div class="font-mono text-xs text-slate-600 font-medium mb-1"><i class="fa-solid fa-envelope text-slate-400 mr-1.5"></i> <%# Eval("Email") %></div>
                                                            <div class="font-mono text-xs text-slate-500 font-medium"><i class="fa-solid fa-phone text-slate-400 mr-1.5"></i> <%# Eval("ContactNo") %></div>
                                                        </td>
                                                        <td class="p-4 text-center">
                                                            <span class='<%# Convert.ToBoolean(Eval("IsActive")) ? "text-green-700 bg-green-50 border border-green-200" : "text-red-700 bg-red-50 border border-red-200" %> px-3 py-1 rounded-full font-bold text-[10px] uppercase tracking-wider inline-flex items-center gap-1.5 shadow-sm'>
                                                                <span class='w-1.5 h-1.5 rounded-full <%# Convert.ToBoolean(Eval("IsActive")) ? "bg-green-500" : "bg-red-500 animate-pulse" %>'></span> 
                                                                <%# Convert.ToBoolean(Eval("IsActive")) ? "Active" : "Blocked" %>
                                                            </span>
                                                        </td>
                                                        <td class="p-4 text-center pr-6">
                                                            <div class="flex justify-center items-center gap-3">
                                                                <asp:LinkButton ID="btnToggle" runat="server" CommandName="ToggleStatus" CommandArgument='<%# Eval("StaffID") + "|" + Eval("IsActive") + "|" + Eval("FullName") %>' 
                                                                    ToolTip='<%# Convert.ToBoolean(Eval("IsActive")) ? "Block Staff" : "Unblock Staff" %>'
                                                                    CssClass='<%# Convert.ToBoolean(Eval("IsActive")) ? "text-orange-500 hover:text-orange-700 transition text-lg bg-orange-50 w-8 h-8 rounded flex items-center justify-center border border-orange-100" : "text-green-600 hover:text-green-800 transition text-lg bg-green-50 w-8 h-8 rounded flex items-center justify-center border border-green-100" %>'>
                                                                    <i class='fa-solid <%# Convert.ToBoolean(Eval("IsActive")) ? "fa-ban" : "fa-unlock" %>'></i>
                                                                </asp:LinkButton>

                                                                <asp:LinkButton ID="btnDelete" runat="server" CommandName="DeleteStaff" CommandArgument='<%# Eval("StaffID") + "|" + Eval("FullName") %>' 
                                                                    ToolTip="Delete Permanently"
                                                                    CssClass="text-red-500 hover:text-red-700 transition text-lg bg-red-50 w-8 h-8 rounded flex items-center justify-center border border-red-100">
                                                                    <i class="fa-solid fa-trash-can"></i>
                                                                </asp:LinkButton>
                                                            </div>
                                                        </td>
                                                    </tr>
                                                </ItemTemplate>
                                            </asp:Repeater>

                                            <tr runat="server" id="trNoData" visible="false">
                                                <td colspan="4" class="p-10 text-center text-slate-500 border-none">
                                                    <i class="fa-solid fa-users-slash text-4xl mb-4 text-slate-300 block"></i>
                                                    <span class="font-bold text-lg text-slate-700">No Staff Found</span>
                                                    <p class="text-sm mt-1">Add new staff from the form above.</p>
                                                </td>
                                            </tr>
                                        </tbody>
                                    </table>
                                </div>
                            </div>

                            <asp:Panel ID="pnlActionModal" runat="server" Visible="false" CssClass="fixed inset-0 z-[100] flex items-center justify-center bg-slate-900/60 backdrop-blur-sm px-4">
                                <div class="bg-white rounded-2xl shadow-2xl border border-slate-200 w-full max-w-sm modal-pop p-6 text-center relative">
                                    <asp:LinkButton ID="btnCloseAction" runat="server" OnClick="btnCloseAction_Click" CssClass="absolute top-4 right-4 text-slate-400 hover:text-slate-600 transition text-xl"><i class="fa-solid fa-xmark"></i></asp:LinkButton>
                                    
                                    <div class="w-16 h-16 rounded-full mx-auto flex items-center justify-center text-3xl mb-4 shadow-inner">
                                        <asp:Literal ID="litModalIcon" runat="server"></asp:Literal>
                                    </div>
                                    
                                    <h3 class="font-bold text-xl text-slate-800 mb-2"><asp:Literal ID="litModalTitle" runat="server"></asp:Literal></h3>
                                    <p class="text-sm text-slate-500 mb-6 leading-relaxed"><asp:Literal ID="litModalMessage" runat="server"></asp:Literal></p>
                                    
                                    <asp:HiddenField ID="hfActionType" runat="server" />
                                    <asp:HiddenField ID="hfActionStaffId" runat="server" />
                                    <asp:HiddenField ID="hfActionCurrentStatus" runat="server" />

                                    <div class="flex gap-3 justify-center">
                                        <asp:Button ID="btnModalCancel" runat="server" Text="Cancel" OnClick="btnCloseAction_Click" CssClass="flex-1 bg-white border border-slate-300 text-slate-600 hover:bg-slate-50 font-bold py-2.5 rounded-lg text-sm transition cursor-pointer" />
                                        <asp:Button ID="btnModalConfirm" runat="server" Text="Yes, Proceed" OnClick="btnModalConfirm_Click" CssClass="flex-1 text-white font-bold py-2.5 rounded-lg shadow-md transition cursor-pointer text-sm" />
                                    </div>
                                </div>
                            </asp:Panel>

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

            function showToast(message, type) {
                const container = document.getElementById('toast-container');
                const toast = document.createElement('div');
                const isSuccess = type === 'success';
                const bgColor = isSuccess ? 'bg-emerald-600' : 'bg-red-600';
                const icon = isSuccess ? 'fa-circle-check' : 'fa-circle-exclamation';

                toast.className = `flex items-center gap-3 px-5 py-3.5 rounded-lg shadow-2xl text-white text-sm font-bold toast-enter pointer-events-auto ${bgColor}`;
                toast.innerHTML = `<i class="fa-solid ${icon} text-xl"></i><span>${message}</span>`;
                
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