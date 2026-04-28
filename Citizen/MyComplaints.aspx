<%@ Page Language="C#" AutoEventWireup="true" CodeFile="MyComplaints.aspx.cs" Inherits="MyComplaints" %>

<!DOCTYPE html>
<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title>Track Complaints | Citizen Portal</title>
    <meta name="viewport" content="width=device-width, initial-scale=1.0" />
    
    <script src="https://cdn.tailwindcss.com"></script>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css" />
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@300;400;500;600;700;800&display=swap" rel="stylesheet" />

    <style>
        body { font-family: 'Inter', sans-serif; background-color: #f8fafc; }
        .no-scrollbar::-webkit-scrollbar { display: none; }
        .no-scrollbar { -ms-overflow-style: none;  }
        
        .nav-link { border-radius: 8px; transition: all 0.2s ease-in-out; color: #64748b; font-weight: 500; }
        .nav-link:hover { background-color: #f1f5f9; color: #1e293b; }
        .nav-link.active { background-color: #eff6ff; color: #2563eb; font-weight: 600; }
        
        .complaint-card { background: white; border: 1px solid #e2e8f0; border-radius: 12px; transition: all 0.3s ease; box-shadow: 0 2px 4px rgba(0, 0, 0, 0.02); }
        .complaint-card:hover { box-shadow: 0 10px 15px -3px rgba(37, 99, 235, 0.08); transform: translateY(-2px); border-color: #bfdbfe; }

        /* Modal Animation */
        @keyframes popIn { from { opacity: 0; transform: scale(0.95); } to { opacity: 1; transform: scale(1); } }
        .modal-pop { animation: popIn 0.2s ease-out forwards; }

        /* Mobile Sidebar */
        #mobileSidebar { transition: transform 0.3s ease-in-out; }
    </style>
</head>
<body class="text-slate-700 antialiased">
    <form id="form1" runat="server">
        <asp:ScriptManager runat="server" />

        <div class="flex h-screen overflow-hidden">
            
            <aside class="hidden md:flex w-72 flex-col bg-white border-r border-slate-200 z-20 shadow-sm">
                <div class="h-20 flex items-center px-8 border-b border-slate-100">
                    <div class="flex items-center gap-3">
                        <div class="w-10 h-10 bg-blue-600 rounded-lg flex items-center justify-center text-white text-xl shadow-lg shadow-blue-200">
                            <i class="fa-solid fa-city"></i>
                        </div>
                        <span class="text-2xl font-extrabold tracking-tight text-slate-800">Civi<span class="text-blue-600">Care</span></span>
                    </div>
                </div>

                <nav class="flex-1 py-6 px-4 space-y-2 overflow-y-auto no-scrollbar">
                    <p class="px-4 text-xs font-bold text-slate-400 uppercase tracking-widest mb-3">Main Menu</p>
                    <a href="CitizenDashboard.aspx" class="nav-link flex items-center px-4 py-3 text-sm">
                        <i class="fa-solid fa-house w-6 text-center opacity-80"></i> Home Dashboard
                    </a>
                    <a href="ReportIssue.aspx" class="nav-link flex items-center px-4 py-3 text-sm">
                        <i class="fa-solid fa-camera w-6 text-center opacity-80"></i> Report New Issue
                    </a>
                    <a href="MyComplaints.aspx" class="nav-link active flex items-center px-4 py-3 text-sm">
                        <i class="fa-solid fa-magnifying-glass-location w-6 text-center opacity-80"></i> Track Complaints
                    </a>
                    <a href="CityAlerts.aspx" class="nav-link flex items-center px-4 py-3 text-sm">
                        <i class="fa-solid fa-bullhorn w-6 text-center opacity-80"></i> City Alerts
                    </a>
                    
                    <p class="px-4 text-xs font-bold text-slate-400 uppercase tracking-widest mt-8 mb-3">Account</p>
                   <%-- <a href="Profile.aspx" class="nav-link flex items-center px-4 py-3 text-sm">
                        <i class="fa-solid fa-user-gear w-6 text-center opacity-80"></i> My Profile
                    </a>--%>
                    <a href="/Default.aspx" class="nav-link flex items-center px-4 py-3 text-sm text-red-500 hover:bg-red-50 hover:text-red-600 mt-2">
                        <i class="fa-solid fa-right-from-bracket w-6 text-center opacity-80"></i> Secure Logout
                    </a>
                </nav>

                <div class="p-5 border-t border-slate-100">
                    <div class="bg-slate-50 border border-slate-200 rounded-xl p-4 text-center">
                        <div class="w-10 h-10 bg-white rounded-full flex items-center justify-center text-blue-600 shadow-sm mx-auto mb-2">
                            <i class="fa-solid fa-headset"></i>
                        </div>
                        <h4 class="font-bold text-slate-800 text-sm">Need Help?</h4>
                        <p class="text-xs text-slate-500 mt-1 mb-3">Toll-Free Helpline 07122561548</p>
                        <button type="button" class="w-full bg-white border border-slate-300 text-slate-700 text-xs font-bold py-1.5 rounded-lg hover:bg-slate-100 transition">Contact Support</button>
                    </div>
                </div>
            </aside>

            <div id="mobileSidebar" class="fixed inset-y-0 left-0 w-72 bg-white shadow-2xl z-50 transform -translate-x-full md:hidden flex flex-col border-r border-slate-200">
                <div class="h-20 flex items-center justify-between px-6 border-b border-slate-100">
                    <div class="flex items-center gap-3">
                        <div class="w-10 h-10 bg-blue-600 rounded-lg flex items-center justify-center text-white text-xl shadow-lg shadow-blue-200">
                            <i class="fa-solid fa-city"></i>
                        </div>
                        <span class="text-2xl font-extrabold tracking-tight text-slate-800">Civi<span class="text-blue-600">Care</span></span>
                    </div>
                    <button type="button" onclick="toggleSidebar()" class="text-slate-400 hover:text-red-500 transition text-2xl"><i class="fa-solid fa-xmark"></i></button>
                </div>
                <nav class="p-4 space-y-2 overflow-y-auto no-scrollbar">
                    <p class="px-4 text-xs font-bold text-slate-400 uppercase tracking-widest mb-3">Main Menu</p>
                    <a href="CitizenDashboard.aspx" class="block px-4 py-3 text-slate-600 hover:bg-slate-50 rounded-lg font-medium"><i class="fa-solid fa-house mr-2"></i> Dashboard</a>
                    <a href="ReportIssue.aspx" class="block px-4 py-3 text-slate-600 hover:bg-slate-50 rounded-lg font-medium"><i class="fa-solid fa-camera mr-2"></i> Report Issue</a>
                    <a href="MyComplaints.aspx" class="block px-4 py-3 bg-blue-50 text-blue-600 rounded-lg font-bold"><i class="fa-solid fa-magnifying-glass-location mr-2"></i> Track Complaints</a>
                    <a href="CityAlerts.aspx" class="block px-4 py-3 text-slate-600 hover:bg-slate-50 rounded-lg font-medium"><i class="fa-solid fa-bullhorn mr-2"></i> City Alerts</a>
                    
                    <p class="px-4 text-xs font-bold text-slate-400 uppercase tracking-widest mt-8 mb-3">Account</p>
                    <%--<a href="Profile.aspx" class="block px-4 py-3 text-slate-600 hover:bg-slate-50 rounded-lg font-medium"><i class="fa-solid fa-user-gear mr-2"></i> My Profile</a>--%>
                    <a href="/Default.aspx" class="block px-4 py-3 text-red-500 hover:bg-red-50 rounded-lg font-bold mt-2"><i class="fa-solid fa-right-from-bracket mr-2"></i> Logout</a>
                </nav>
            </div>

            <div class="flex-1 flex flex-col overflow-hidden bg-slate-50 relative">
                
                <header class="h-20 bg-white/80 backdrop-blur-md border-b border-slate-200 flex items-center justify-between px-6 md:px-10 shadow-sm z-10 sticky top-0">
                    <div class="flex items-center gap-4">
                        <button type="button" class="md:hidden text-slate-600 hover:text-blue-600" onclick="toggleSidebar()">
                            <i class="fa-solid fa-bars text-2xl"></i>
                        </button>
                        <h2 class="text-xl md:text-2xl font-bold text-slate-800">Complaint History</h2>
                    </div>
                    <div class="flex items-center gap-3 pl-5 border-l border-slate-200 cursor-pointer">
                        <div class="text-right hidden sm:block">
                            <div class="text-sm font-bold text-slate-800"><asp:Literal ID="litUserName" runat="server"></asp:Literal></div>
                            <div class="text-xs text-slate-500">Citizen</div>
                        </div>
                        <div class="w-10 h-10 rounded-full bg-gradient-to-tr from-blue-500 to-blue-600 text-white flex items-center justify-center font-bold shadow-md"><i class="fa-solid fa-user"></i></div>
                    </div>
                </header>

                <main class="flex-1 overflow-y-auto p-4 md:p-8 z-10 relative">
                    
                    <asp:UpdatePanel runat="server" UpdateMode="Conditional">
                        <ContentTemplate>
                            
                            <div class="flex flex-wrap gap-3 mb-8 bg-white p-3 rounded-xl border border-slate-200 shadow-sm w-fit">
                                <asp:Button ID="btnFilterAll" runat="server" Text="All Complaints" OnClick="btnFilterAll_Click" CssClass="px-5 py-2.5 rounded-lg text-sm font-bold transition cursor-pointer" />
                                <asp:Button ID="btnFilterPending" runat="server" Text="Pending / In Progress" OnClick="btnFilterPending_Click" CssClass="px-5 py-2.5 rounded-lg text-sm font-bold transition cursor-pointer" />
                                <asp:Button ID="btnFilterResolved" runat="server" Text="Resolved" OnClick="btnFilterResolved_Click" CssClass="px-5 py-2.5 rounded-lg text-sm font-bold transition cursor-pointer" />
                            </div>

                            <div class="grid grid-cols-1 md:grid-cols-2 xl:grid-cols-3 gap-6">
                                
                                <asp:Repeater ID="rptComplaints" runat="server" OnItemCommand="rptComplaints_ItemCommand">
                                    <ItemTemplate>
                                        <div class="complaint-card overflow-hidden flex flex-col h-full <%# GetOpacityClass(Eval("Status").ToString()) %>">
                                            
                                            <div class="bg-slate-50 border-b border-slate-100 p-4 flex justify-between items-center">
                                                <div class="flex items-center gap-2">
                                                    <span class="text-[10px] font-mono font-bold text-slate-500 bg-white px-2 py-1 rounded border border-slate-200">ID: #<%# Eval("ComplaintID") %></span>
                                                </div>
                                                <span class="<%# GetBadgeCssClass(Eval("Status").ToString()) %> border px-2.5 py-1 rounded-md text-[10px] font-bold uppercase tracking-wider flex items-center gap-1.5">
                                                    <%# GetStatusIcon(Eval("Status").ToString()) %> <%# Eval("Status") %>
                                                </span>
                                            </div>
                                            
                                            <div class="p-5 flex-1 flex flex-col">
                                                <h3 class="font-bold text-slate-800 text-lg mb-2 flex items-center gap-2 line-clamp-1">
                                                    <i class="fa-solid <%# GetDeptIcon(Eval("AssignedDepartment").ToString()) %> text-slate-400"></i>
                                                    <%# Eval("AssignedDepartment") %> Issue
                                                </h3>
                                                
                                                <p class="text-xs text-slate-500 mb-4 line-clamp-1" title='<%# Eval("LocationName") %>'>
                                                    <i class="fa-solid fa-location-dot text-blue-500 mr-1"></i> <%# Eval("LocationName") %>
                                                </p>
                                                
                                                <div class="bg-slate-50 rounded-lg p-3 border border-slate-100 mb-4 flex-1">
                                                    <p class="text-xs text-slate-600 line-clamp-2 italic">
                                                        "<%# Eval("Description") %>"
                                                    </p>
                                                </div>
                                                
                                                <%# GetStatusBoxHtml(Eval("Status").ToString(), Convert.ToDateTime(Eval("CreatedAt")), Eval("ResolvedAt")) %>
                                                
                                                <asp:Button ID="btnViewDetails" runat="server" Text="View Full Details" CommandName="ViewDetails" CommandArgument='<%# Eval("ComplaintID") %>' CssClass="w-full mt-auto bg-white border border-blue-200 text-blue-600 hover:bg-blue-50 hover:border-blue-300 font-bold py-2.5 rounded-lg text-sm transition cursor-pointer shadow-sm" />
                                            </div>
                                        </div>
                                    </ItemTemplate>
                                </asp:Repeater>

                            </div>

                            <div id="divNoData" runat="server" visible="false" class="text-center py-20 bg-white border border-slate-200 rounded-2xl shadow-sm max-w-2xl mx-auto mt-8">
                                <div class="w-20 h-20 bg-slate-50 text-slate-400 rounded-full flex items-center justify-center mx-auto mb-4 text-3xl">
                                    <i class="fa-solid fa-box-open"></i>
                                </div>
                                <h3 class="text-xl font-bold text-slate-800">No Complaints Found</h3>
                                <p class="text-sm text-slate-500 mt-2 mb-6">There are no complaints matching this filter.</p>
                                <a href="ReportIssue.aspx" class="inline-flex items-center gap-2 bg-blue-600 text-white px-6 py-3 rounded-lg text-sm font-bold shadow-md hover:bg-blue-700 transition transform hover:-translate-y-0.5">
                                    <i class="fa-solid fa-plus"></i> Report a New Issue
                                </a>
                            </div>

                            <asp:Panel ID="pnlModal" runat="server" Visible="false" CssClass="fixed inset-0 z-[100] flex items-center justify-center bg-slate-900/60 backdrop-blur-sm px-4">
                                <div class="bg-white rounded-2xl shadow-2xl border border-slate-200 w-full max-w-3xl modal-pop flex flex-col max-h-[90vh]">
                                    
                                    <div class="px-6 py-4 border-b border-slate-100 flex justify-between items-center bg-slate-50 rounded-t-2xl">
                                        <div class="flex items-center gap-3">
                                            <div class="w-10 h-10 bg-blue-100 text-blue-600 rounded-lg flex items-center justify-center text-lg"><i class="fa-solid fa-file-lines"></i></div>
                                            <div>
                                                <h3 class="font-bold text-lg text-slate-800 leading-tight">Complaint Details</h3>
                                                <p class="text-xs text-slate-500 font-mono">ID: #<asp:Literal ID="litModalID" runat="server"></asp:Literal></p>
                                            </div>
                                        </div>
                                        <asp:LinkButton ID="btnCloseModal" runat="server" OnClick="btnCloseModal_Click" CssClass="text-slate-400 hover:text-red-500 transition text-2xl"><i class="fa-solid fa-xmark"></i></asp:LinkButton>
                                    </div>

                                    <div class="p-6 overflow-y-auto no-scrollbar">
                                        <div class="grid grid-cols-1 md:grid-cols-2 gap-8">
                                            
                                            <div>
                                                <p class="text-xs font-bold text-slate-400 uppercase tracking-widest mb-2">Uploaded Proof</p>
                                                <div class="w-full h-48 md:h-64 bg-slate-100 rounded-xl border border-slate-200 overflow-hidden">
                                                    <asp:Image ID="imgModalProof" runat="server" CssClass="w-full h-full object-cover" />
                                                </div>
                                                
                                                <div class="mt-6 flex items-center justify-between p-4 bg-slate-50 rounded-xl border border-slate-100">
                                                    <div>
                                                        <p class="text-xs text-slate-500 mb-1 font-medium">Current Status</p>
                                                        <asp:Literal ID="litModalStatus" runat="server"></asp:Literal>
                                                    </div>
                                                    <div class="text-right">
                                                        <p class="text-xs text-slate-500 mb-1 font-medium">Priority Level</p>
                                                        <asp:Literal ID="litModalPriority" runat="server"></asp:Literal>
                                                    </div>
                                                </div>
                                            </div>

                                            <div class="space-y-6">
                                                <div>
                                                    <p class="text-xs font-bold text-slate-400 uppercase tracking-widest mb-2">Location</p>
                                                    <p class="text-sm font-semibold text-slate-800 flex items-start gap-2">
                                                        <i class="fa-solid fa-location-dot text-blue-500 mt-1"></i> <asp:Literal ID="litModalLocation" runat="server"></asp:Literal>
                                                    </p>
                                                </div>

                                                <div>
                                                    <p class="text-xs font-bold text-slate-400 uppercase tracking-widest mb-2">Department Assigned</p>
                                                    <p class="text-sm font-bold text-slate-800 bg-slate-100 px-3 py-1.5 rounded-md inline-block border border-slate-200">
                                                        <asp:Literal ID="litModalDept" runat="server"></asp:Literal> Department
                                                    </p>
                                                </div>

                                                <div>
                                                    <p class="text-xs font-bold text-slate-400 uppercase tracking-widest mb-2">Your Description & AI Remarks</p>
                                                    <div class="bg-blue-50 border border-blue-100 rounded-xl p-4 text-sm text-slate-700 whitespace-pre-wrap leading-relaxed">
                                                        <asp:Literal ID="litModalDesc" runat="server"></asp:Literal>
                                                    </div>
                                                </div>

                                                <div class="grid grid-cols-2 gap-4 pt-4 border-t border-slate-100">
                                                    <div>
                                                        <p class="text-xs text-slate-400 font-medium mb-1">Filed On</p>
                                                        <p class="text-xs font-bold text-slate-700"><asp:Literal ID="litModalDate" runat="server"></asp:Literal></p>
                                                    </div>
                                                    <div id="divModalResolved" runat="server" visible="false">
                                                        <p class="text-xs text-slate-400 font-medium mb-1">Resolved On</p>
                                                        <p class="text-xs font-bold text-green-600"><asp:Literal ID="litModalResolvedDate" runat="server"></asp:Literal></p>
                                                    </div>
                                                </div>
                                            </div>
                                        </div>
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
        </script>
    </form>
</body>
</html>