<%@ Page Language="C#" AutoEventWireup="true" CodeFile="ManageUsers.aspx.cs" Inherits="ManageUsers" %>

<!DOCTYPE html>
<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title>User Management | CiviCare Admin</title>
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

        /* Professional Form Styling */
        .form-label { font-size: 0.75rem; font-weight: 700; text-transform: uppercase; letter-spacing: 0.05em; color: #64748b; margin-bottom: 0.5rem; display: block; }
        .form-input { width: 100%; padding: 0.75rem 1rem 0.75rem 2.75rem; border: 1px solid #cbd5e1; border-radius: 8px; font-size: 0.875rem; color: #334155; transition: all 0.2s; background-color: #fff; }
        .form-input:focus { outline: none; border-color: #3b82f6; box-shadow: 0 0 0 3px rgba(59, 130, 246, 0.1); }
        .input-icon { position: absolute; left: 1rem; top: 50%; transform: translateY(-50%); color: #94a3b8; font-size: 1rem; }

        .content-card { background: white; border: 1px solid #e2e8f0; border-radius: 12px; box-shadow: 0 4px 6px -1px rgba(0, 0, 0, 0.05); }
        .bordered-table th, .bordered-table td { border: 1px solid #f1f5f9; }

        /* Animations */
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
            
            <aside class="hidden md:flex w-72 flex-col bg-white border-r border-slate-200 z-20 shadow-sm">
                <div class="h-20 flex items-center px-8 border-b border-slate-100">
                    <div class="flex items-center gap-3">
                        <div class="w-9 h-9 bg-blue-600 rounded-lg flex items-center justify-center text-white text-xl shadow-lg shadow-blue-200">
                            <i class="fa-solid fa-city"></i>
                        </div>
                        <span class="text-xl font-bold tracking-tight text-slate-800">Civi<span class="text-blue-600">Care</span></span>
                    </div>
                </div>

                <nav class="flex-1 py-6 px-4 space-y-1.5 overflow-y-auto no-scrollbar">
                    <p class="px-4 text-xs font-bold text-slate-400 uppercase tracking-widest mb-3">Overview</p>
                    <a href="AdminDashboard.aspx" class="nav-link flex items-center px-4 py-3 text-sm">
                        <i class="fa-solid fa-chart-pie w-6 opacity-75"></i> Dashboard
                    </a>
                    <a href="ManageUsers.aspx" class="nav-link active flex items-center px-4 py-3 text-sm">
                        <i class="fa-solid fa-users w-6 opacity-75"></i> User Management
                    </a>
                    <a href="Departments.aspx" class="nav-link flex items-center px-4 py-3 text-sm">
                        <i class="fa-solid fa-building w-6 opacity-75"></i> Departments
                    </a>
                    <a href="Reports.aspx" class="nav-link flex items-center px-4 py-3 text-sm">
                        <i class="fa-solid fa-file-invoice w-6 opacity-75"></i> Reports & Data
                    </a>
                    
                    <p class="px-4 text-xs font-bold text-slate-400 uppercase tracking-widest mt-8 mb-3">System</p>
                    <a href="#" class="nav-link flex items-center px-4 py-3 text-sm">
                        <i class="fa-solid fa-gear w-6 opacity-75"></i> Configuration
                    </a>
                    <a href="/SystemLogin.aspx?action=logout" class="nav-link flex items-center px-4 py-3 text-sm text-red-500 hover:bg-red-50 hover:text-red-600 transition">
                        <i class="fa-solid fa-right-from-bracket w-6 opacity-75"></i> Logout
                    </a>
                </nav>

                <div class="p-4 border-t border-slate-100">
                    <div class="bg-gradient-to-br from-blue-50 to-indigo-50 border border-blue-100 rounded-xl p-4">
                        <div class="flex items-center gap-3 mb-2">
                            <div class="p-2 bg-white rounded-lg shadow-sm text-blue-600"><i class="fa-solid fa-robot"></i></div>
                            <span class="font-bold text-slate-800 text-sm">AI System Active</span>
                        </div>
                        <p class="text-xs text-slate-500 mb-3">Monitoring all 3 departments live.</p>
                        <button type="button" class="w-full py-1.5 bg-white border border-blue-200 text-blue-600 text-xs font-bold rounded-lg hover:bg-blue-50 transition">View Logs</button>
                    </div>
                </div>
            </aside>

            <div id="mobileSidebar" class="fixed inset-y-0 left-0 w-72 bg-white shadow-2xl z-50 transform -translate-x-full md:hidden flex flex-col border-r border-slate-200">
                <div class="h-20 flex items-center justify-between px-6 border-b border-slate-100">
                    <div class="flex items-center gap-3">
                        <div class="w-9 h-9 bg-blue-600 rounded-lg flex items-center justify-center text-white text-xl shadow-lg shadow-blue-200">
                            <i class="fa-solid fa-city"></i>
                        </div>
                        <span class="text-xl font-bold tracking-tight text-slate-800">Civi<span class="text-blue-600">Care</span></span>
                    </div>
                    <button type="button" onclick="toggleSidebar()" class="text-slate-400 hover:text-red-500 transition text-2xl"><i class="fa-solid fa-xmark"></i></button>
                </div>
                <nav class="flex-1 py-6 px-4 space-y-1.5 overflow-y-auto no-scrollbar">
                    <p class="px-4 text-xs font-bold text-slate-400 uppercase tracking-widest mb-3">Overview</p>
                    <a href="AdminDashboard.aspx" class="nav-link flex items-center px-4 py-3 text-sm">
                        <i class="fa-solid fa-chart-pie w-6 opacity-75"></i> Dashboard
                    </a>
                    <a href="ManageUsers.aspx" class="nav-link active flex items-center px-4 py-3 text-sm">
                        <i class="fa-solid fa-users w-6 opacity-75"></i> User Management
                    </a>
                    <a href="Departments.aspx" class="nav-link flex items-center px-4 py-3 text-sm">
                        <i class="fa-solid fa-building w-6 opacity-75"></i> Departments
                    </a>
                    <a href="Reports.aspx" class="nav-link flex items-center px-4 py-3 text-sm">
                        <i class="fa-solid fa-file-invoice w-6 opacity-75"></i> Reports & Data
                    </a>
                    <p class="px-4 text-xs font-bold text-slate-400 uppercase tracking-widest mt-8 mb-3">System</p>
                    <a href="/SystemLogin.aspx?action=logout" class="nav-link flex items-center px-4 py-3 text-sm text-red-500 hover:bg-red-50 hover:text-red-600 transition mt-2">
                        <i class="fa-solid fa-right-from-bracket w-6 opacity-75"></i> Logout
                    </a>
                </nav>
            </div>

            <div class="flex-1 flex flex-col overflow-hidden bg-slate-50 relative">
                
                <header class="h-20 bg-white border-b border-slate-200 flex items-center justify-between px-4 md:px-8 shadow-sm z-10 sticky top-0">
                    <div class="flex items-center gap-4">
                        <button type="button" class="md:hidden text-slate-500" onclick="toggleSidebar()"><i class="fa-solid fa-bars text-xl"></i></button>
                        <h2 class="text-xl md:text-2xl font-bold text-slate-800">User Management</h2>
                    </div>

                    <div class="flex items-center gap-6">
                        <button type="button" class="relative text-slate-400 hover:text-blue-600 transition">
                            <i class="fa-regular fa-bell text-xl"></i>
                        </button>
                        <div class="flex items-center gap-3 pl-6 border-l border-slate-200">
                            <div class="text-right hidden sm:block">
                                <div class="text-sm font-bold text-slate-700"><asp:Literal ID="litAdminName" runat="server"></asp:Literal></div>
                                <div class="text-xs text-slate-400">Super Admin</div>
                            </div>
                            <div class="w-10 h-10 rounded-full bg-slate-100 border border-slate-200 flex items-center justify-center text-slate-600 font-bold shadow-sm">A</div>
                        </div>
                    </div>
                </header>

                <main class="flex-1 overflow-y-auto p-4 md:p-8">
                    
                    <asp:UpdatePanel runat="server" UpdateMode="Conditional" ChildrenAsTriggers="true">
                        <ContentTemplate>
                            
                            <div class="content-card mb-8 overflow-hidden bg-white">
                                <div class="bg-gradient-to-r from-slate-800 to-slate-900 px-6 py-5 flex items-center gap-4 border-b border-slate-700">
                                    <div class="w-10 h-10 rounded-full bg-white/10 flex items-center justify-center text-white shadow-inner"><i class="fa-solid fa-user-plus"></i></div>
                                    <div>
                                        <h3 class="font-bold text-white text-lg">Onboard New Employee</h3>
                                        <p class="text-xs text-slate-300 mt-0.5">Generate access credentials for department staff.</p>
                                    </div>
                                </div>
                                
                                <div class="p-6 md:p-8">
                                    <div class="grid grid-cols-1 md:grid-cols-2 gap-x-10 gap-y-6">
                                        
                                        <div class="space-y-6">
                                            <div>
                                                <label class="form-label">Full Name <span class="text-red-500">*</span></label>
                                                <div class="relative">
                                                    <i class="fa-solid fa-user input-icon"></i>
                                                    <asp:TextBox ID="txtName" runat="server" CssClass="form-input" placeholder="e.g. Ramesh Kumar"></asp:TextBox>
                                                </div>
                                                <asp:RequiredFieldValidator ID="rfvName" runat="server" ControlToValidate="txtName" ErrorMessage="Full Name is required" ValidationGroup="AddUser" CssClass="val-error" Display="Dynamic" />
                                            </div>
                                            
                                            <div>
                                                <label class="form-label">Mobile Number <span class="text-red-500">*</span></label>
                                                <div class="relative">
                                                    <i class="fa-solid fa-phone input-icon"></i>
                                                    <asp:TextBox ID="txtMobile" runat="server" MaxLength="10" CssClass="form-input" placeholder="10-digit mobile number"></asp:TextBox>
                                                </div>
                                                <asp:RequiredFieldValidator ID="rfvMobile" runat="server" ControlToValidate="txtMobile" ErrorMessage="Mobile No. is required" ValidationGroup="AddUser" CssClass="val-error" Display="Dynamic" />
                                                <asp:RegularExpressionValidator ID="revMobile" runat="server" ControlToValidate="txtMobile" ValidationExpression="^\d{10}$" ErrorMessage="Enter a valid 10-digit number" ValidationGroup="AddUser" CssClass="val-error" Display="Dynamic" />
                                            </div>
                                        </div>

                                        <div class="space-y-6">
                                            <div>
                                                <label class="form-label">Official Email <span class="text-red-500">*</span></label>
                                                <div class="relative">
                                                    <i class="fa-solid fa-envelope input-icon"></i>
                                                    <asp:TextBox ID="txtEmail" runat="server" CssClass="form-input" placeholder="e.g. ramesh@civicare.com"></asp:TextBox>
                                                </div>
                                                <asp:RequiredFieldValidator ID="rfvEmail" runat="server" ControlToValidate="txtEmail" ErrorMessage="Email is required" ValidationGroup="AddUser" CssClass="val-error" Display="Dynamic" />
                                                <asp:RegularExpressionValidator ID="revEmail" runat="server" ControlToValidate="txtEmail" ValidationExpression="^\w+([-+.']\w+)*@\w+([-.]\w+)*\.\w+([-.]\w+)*$" ErrorMessage="Enter a valid Email ID" ValidationGroup="AddUser" CssClass="val-error" Display="Dynamic" />
                                            </div>

                                            <div class="grid grid-cols-1 sm:grid-cols-2 gap-4">
                                                <div>
                                                    <label class="form-label">Department <span class="text-red-500">*</span></label>
                                                    <div class="relative">
                                                        <i class="fa-solid fa-briefcase input-icon"></i>
                                                        <asp:DropDownList ID="ddlRole" runat="server" CssClass="form-input appearance-none cursor-pointer pr-10">
                                                            <asp:ListItem Text="Select Dept" Value=""></asp:ListItem>
                                                            <asp:ListItem Text="Electricity" Value="Electric"></asp:ListItem>
                                                            <asp:ListItem Text="Water Supply" Value="Water"></asp:ListItem>
                                                            <asp:ListItem Text="Sanitation" Value="Sanitation"></asp:ListItem>
                                                        </asp:DropDownList>
                                                        <i class="fa-solid fa-chevron-down absolute right-4 top-1/2 -translate-y-1/2 text-slate-400 text-xs pointer-events-none"></i>
                                                    </div>
                                                    <asp:RequiredFieldValidator ID="rfvRole" runat="server" ControlToValidate="ddlRole" InitialValue="" ErrorMessage="Required" ValidationGroup="AddUser" CssClass="val-error" Display="Dynamic" />
                                                </div>

                                                <div>
                                                    <label class="form-label">Assign Password <span class="text-red-500">*</span></label>
                                                    <div class="relative">
                                                        <i class="fa-solid fa-lock input-icon"></i>
                                                        <asp:TextBox ID="txtPass" runat="server" TextMode="Password" CssClass="form-input" placeholder="Min 6 chars"></asp:TextBox>
                                                    </div>
                                                    <asp:RequiredFieldValidator ID="rfvPass" runat="server" ControlToValidate="txtPass" ErrorMessage="Required" ValidationGroup="AddUser" CssClass="val-error" Display="Dynamic" />
                                                </div>
                                            </div>
                                        </div>
                                    </div>

                                    <div class="mt-8 pt-6 border-t border-slate-100 flex flex-wrap justify-end gap-3">
                                        <asp:Button ID="btnCancel" runat="server" Text="Clear Form" OnClick="btnCancel_Click" CausesValidation="false" CssClass="px-6 py-2.5 rounded-lg border border-slate-300 text-slate-600 font-bold text-sm hover:bg-slate-50 hover:text-slate-800 transition cursor-pointer" />
                                        <asp:Button ID="btnCreateUser" runat="server" Text="Create Employee Account" OnClick="btnCreateUser_Click" ValidationGroup="AddUser" UseSubmitBehavior="false" CssClass="px-6 py-2.5 bg-blue-600 hover:bg-blue-700 text-white font-bold rounded-lg shadow-md transition cursor-pointer text-sm flex items-center gap-2" />
                                    </div>
                                </div>
                            </div>

                            <div class="content-card overflow-hidden">
                                <div class="px-6 py-5 border-b border-slate-100 bg-white flex justify-between items-center">
                                    <div>
                                        <h3 class="font-bold text-slate-800 text-lg flex items-center gap-2">
                                            <i class="fa-solid fa-address-book text-blue-500"></i> Active Staff Directory
                                        </h3>
                                    </div>
                                </div>
                                
                                <div class="overflow-x-auto w-full">
                                    <table class="w-full text-left text-sm text-slate-600 min-w-[800px] bordered-table border-collapse">
                                        <thead class="bg-slate-50 text-slate-500 font-bold uppercase text-xs">
                                            <tr>
                                                <th class="p-4 pl-6 tracking-wide bg-slate-100/50">Employee Name</th>
                                                <th class="p-4 tracking-wide bg-slate-100/50">Department</th>
                                                <th class="p-4 tracking-wide bg-slate-100/50">Contact Info</th>
                                                <th class="p-4 tracking-wide bg-slate-100/50 text-center">Status</th>
                                                <th class="p-4 text-center pr-6 tracking-wide bg-slate-100/50">Actions</th>
                                            </tr>
                                        </thead>
                                        <tbody class="divide-y divide-slate-100 bg-white">
                                            <asp:Repeater ID="rptUsers" runat="server" OnItemCommand="rptUsers_ItemCommand">
                                                <ItemTemplate>
                                                    <tr class="hover:bg-slate-50/50 transition duration-150">
                                                        <td class="p-4 pl-6">
                                                            <div class="flex items-center gap-3">
                                                                <div class="w-10 h-10 rounded-full flex items-center justify-center text-xs font-bold border shadow-sm <%# GetAvatarCssClass(Eval("UserRole").ToString()) %>">
                                                                    <%# GetInitials(Eval("FullName").ToString()) %>
                                                                </div>
                                                                <div>
                                                                    <span class="font-bold text-slate-800 block text-sm"><%# Eval("FullName") %></span>
                                                                    <span class="text-[10px] font-mono text-slate-400">EMP-<%# Eval("UserID") %></span>
                                                                </div>
                                                            </div>
                                                        </td>
                                                        <td class="p-4">
                                                            <span class="px-2.5 py-1 rounded-md text-[10px] font-bold uppercase tracking-wider border shadow-sm flex w-max items-center gap-1.5 <%# GetBadgeCssClass(Eval("UserRole").ToString()) %>">
                                                                <i class="fa-solid <%# GetDeptIcon(Eval("UserRole").ToString()) %>"></i> <%# Eval("UserRole") %>
                                                            </span>
                                                        </td>
                                                        <td class="p-4">
                                                            <div class="font-mono text-xs text-slate-600 mb-1 font-medium"><i class="fa-solid fa-envelope text-slate-400 mr-1.5"></i> <%# Eval("Email") %></div>
                                                            <div class="font-mono text-xs text-slate-500 font-medium"><i class="fa-solid fa-phone text-slate-400 mr-1.5"></i> <%# Eval("MobileNo") %></div>
                                                        </td>
                                                        <td class="p-4 text-center">
                                                            <span class='<%# Convert.ToBoolean(Eval("IsActive")) ? "text-green-700 bg-green-50 border border-green-200" : "text-red-700 bg-red-50 border border-red-200" %> px-2.5 py-1 rounded-full font-bold text-[10px] uppercase tracking-wider inline-flex items-center gap-1.5 shadow-sm'>
                                                                <span class='w-1.5 h-1.5 rounded-full <%# Convert.ToBoolean(Eval("IsActive")) ? "bg-green-500" : "bg-red-500 animate-pulse" %>'></span> 
                                                                <%# Convert.ToBoolean(Eval("IsActive")) ? "Active" : "Blocked" %>
                                                            </span>
                                                        </td>
                                                        <td class="p-4 text-center pr-6">
                                                            <div class="flex justify-center items-center gap-3">
                                                                <asp:LinkButton ID="btnToggleStatus" runat="server" 
                                                                    CommandName="ToggleStatus" 
                                                                    CommandArgument='<%# Eval("UserID") + "|" + Eval("IsActive") + "|" + Eval("FullName") %>' 
                                                                    ToolTip='<%# Convert.ToBoolean(Eval("IsActive")) ? "Block User" : "Unblock User" %>'
                                                                    CssClass='<%# Convert.ToBoolean(Eval("IsActive")) ? "text-orange-500 hover:text-orange-700 transition text-lg bg-orange-50 w-8 h-8 rounded flex items-center justify-center border border-orange-100" : "text-green-600 hover:text-green-800 transition text-lg bg-green-50 w-8 h-8 rounded flex items-center justify-center border border-green-100" %>'>
                                                                    <i class='fa-solid <%# Convert.ToBoolean(Eval("IsActive")) ? "fa-ban" : "fa-unlock" %>'></i>
                                                                </asp:LinkButton>

                                                                <asp:LinkButton ID="btnDelete" runat="server" 
                                                                    CommandName="DeleteUser" 
                                                                    CommandArgument='<%# Eval("UserID") + "|" + Eval("FullName") %>' 
                                                                    ToolTip="Delete User Permanently"
                                                                    CssClass="text-red-500 hover:text-red-700 transition text-lg bg-red-50 w-8 h-8 rounded flex items-center justify-center border border-red-100">
                                                                    <i class="fa-solid fa-trash-can"></i>
                                                                </asp:LinkButton>
                                                            </div>
                                                        </td>
                                                    </tr>
                                                </ItemTemplate>
                                            </asp:Repeater>

                                            <tr runat="server" id="trNoData" visible="false">
                                                <td colspan="5" class="p-10 text-center text-slate-500 border-none">
                                                    <i class="fa-solid fa-users-slash text-4xl mb-4 text-slate-300 block"></i>
                                                    <span class="font-bold text-lg text-slate-700">No Staff Members Found</span>
                                                    <p class="text-sm mt-1">Use the form above to onboard new employees.</p>
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
                                    <asp:HiddenField ID="hfActionUserId" runat="server" />
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

                toast.className = "flex items-center gap-3 px-5 py-3.5 rounded-xl shadow-2xl text-white text-sm font-bold toast-enter pointer-events-auto " + bgColor;
                toast.innerHTML = "<i class='fa-solid " + icon + " text-xl'></i> <span>" + message + "</span>";
                
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