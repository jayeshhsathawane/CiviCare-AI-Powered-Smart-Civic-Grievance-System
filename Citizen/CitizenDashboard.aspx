<%@ Page Language="C#" AutoEventWireup="true" CodeFile="CitizenDashboard.aspx.cs" Inherits="CitizenDashboard" %>

<!DOCTYPE html>
<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title>Citizen Dashboard | CiviCare</title>
    <meta name="viewport" content="width=device-width, initial-scale=1.0" />
    
    <script src="https://cdn.tailwindcss.com"></script>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css" />
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@300;400;500;600;700;800&display=swap" rel="stylesheet" />

    <style>
        body { font-family: 'Inter', sans-serif; background-color: #f8fafc; }
        
        .no-scrollbar::-webkit-scrollbar { display: none; }
        .no-scrollbar { -ms-overflow-style: none; }

        .nav-link {
            border-radius: 8px;
            transition: all 0.2s ease-in-out;
            color: #64748b;
            font-weight: 500;
        }
        .nav-link:hover {
            background-color: #f1f5f9;
            color: #1e293b;
        }
        .nav-link.active {
            background-color: #eff6ff;
            color: #2563eb;
            font-weight: 600;
        }

        .glass-card {
            background: white;
            border: 1px solid #e2e8f0;
            border-radius: 12px;
            box-shadow: 0 2px 4px rgba(0, 0, 0, 0.02);
            transition: all 0.3s ease;
        }
        .glass-card:hover {
            box-shadow: 0 10px 15px -3px rgba(37, 99, 235, 0.08);
            transform: translateY(-2px);
        }

        /* Professional Stepper CSS */
        .step-text-active { color: #1e293b; font-weight: 700; }
        .step-text-current { color: #2563eb; font-weight: 800; }
        .step-text-inactive { color: #94a3b8; font-weight: 500; }

        .step-circle-completed { background-color: #2563eb; color: white; border: 3px solid #fff; box-shadow: 0 4px 6px -1px rgba(37, 99, 235, 0.3); }
        .step-circle-current { background-color: #4f46e5; color: white; border: 3px solid #fff; box-shadow: 0 0 0 4px rgba(79, 70, 229, 0.2); animation: pulse 2s infinite; }
        .step-circle-inactive { background-color: #f1f5f9; color: #94a3b8; border: 3px solid #fff; }

        /* Stepper Text Adjustments for Mobile Responsiveness */
        .step-label { font-size: 0.875rem; text-align: center; margin-top: 0.5rem; }
        @media (max-width: 640px) {
            .step-label { font-size: 0.6rem; margin-top: 0.25rem; white-space: normal; line-height: 1.1; max-width: 60px; }
            .step-circle-wrapper { width: 2rem; height: 2rem; font-size: 0.8rem; }
            .progress-bar-bg { top: 1rem !important; }
        }
        @media (min-width: 641px) {
            .step-circle-wrapper { width: 2.5rem; height: 2.5rem; font-size: 1rem; }
            .progress-bar-bg { top: 1.25rem !important; }
        }

        /* Mobile Sidebar */
        #mobileSidebar { transition: transform 0.3s ease-in-out; }
    </style>
</head>
<body class="text-slate-700 antialiased">
    <form id="form1" runat="server">

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
                    <a href="CitizenDashboard.aspx" class="nav-link active flex items-center px-4 py-3 text-sm">
                        <i class="fa-solid fa-house w-6 text-center opacity-80"></i> Home Dashboard
                    </a>
                    <a href="ReportIssue.aspx" class="nav-link flex items-center px-4 py-3 text-sm">
                        <i class="fa-solid fa-camera w-6 text-center opacity-80"></i> Report New Issue
                    </a>
                    <a href="MyComplaints.aspx" class="nav-link flex items-center px-4 py-3 text-sm">
                        <i class="fa-solid fa-magnifying-glass-location w-6 text-center opacity-80"></i> Track Complaints
                    </a>
                    <a href="CityAlerts.aspx" class="nav-link flex items-center px-4 py-3 text-sm">
                        <i class="fa-solid fa-bullhorn w-6 text-center opacity-80"></i> City Alerts
                    </a>
                    
                 <p class="px-4 text-xs font-bold text-slate-400 uppercase tracking-widest mt-8 mb-3">Account</p>
                     <%--  <a href="/UserProfile.aspx" class="nav-link flex items-center px-4 py-3 text-sm">
                        <i class="fa-solid fa-user-gear w-6 text-center opacity-80"></i> My Profile
                    </a>--%>
                    <a href="/logout.aspx" class="nav-link flex items-center px-4 py-3 text-sm text-red-500 hover:bg-red-50 hover:text-red-600 mt-2">
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
                    <button type="button" onclick="toggleSidebar()" class="text-slate-500 hover:text-red-500 transition text-2xl"><i class="fa-solid fa-xmark"></i></button>
                </div>
                
                <nav class="flex-1 py-6 px-4 space-y-2 overflow-y-auto no-scrollbar">
                    <p class="px-4 text-xs font-bold text-slate-400 uppercase tracking-widest mb-3">Main Menu</p>
                    <a href="CitizenDashboard.aspx" class="nav-link active flex items-center px-4 py-3 text-sm">
                        <i class="fa-solid fa-house w-6 text-center opacity-80"></i> Home Dashboard
                    </a>
                    <a href="ReportIssue.aspx" class="nav-link flex items-center px-4 py-3 text-sm">
                        <i class="fa-solid fa-camera w-6 text-center opacity-80"></i> Report New Issue
                    </a>
                    <a href="MyComplaints.aspx" class="nav-link flex items-center px-4 py-3 text-sm">
                        <i class="fa-solid fa-magnifying-glass-location w-6 text-center opacity-80"></i> Track Complaints
                    </a>
                    <a href="CityAlerts.aspx" class="nav-link flex items-center px-4 py-3 text-sm">
                        <i class="fa-solid fa-bullhorn w-6 text-center opacity-80"></i> City Alerts
                    </a>
                    
               <p class="px-4 text-xs font-bold text-slate-400 uppercase tracking-widest mt-8 mb-3">Account</p>
                        <%-- <a href="Profile.aspx" class="nav-link flex items-center px-4 py-3 text-sm">
                        <i class="fa-solid fa-user-gear w-6 text-center opacity-80"></i> My Profile
                    </a>--%>
                    <a href="/logout.aspx" class="nav-link flex items-center px-4 py-3 text-sm text-red-500 hover:bg-red-50 hover:text-red-600 mt-2">
                        <i class="fa-solid fa-right-from-bracket w-6 text-center opacity-80"></i> Secure Logout
                    </a>
                </nav>

                <div class="p-5 border-t border-slate-100">
                    <div class="bg-slate-50 border border-slate-200 rounded-xl p-4 text-center">
                        <div class="w-10 h-10 bg-white rounded-full flex items-center justify-center text-blue-600 shadow-sm mx-auto mb-2">
                            <i class="fa-solid fa-headset"></i>
                        </div>
                        <h4 class="font-bold text-slate-800 text-sm">Need Help?</h4>
                        <p class="text-xs text-slate-500 mt-1 mb-3">Toll-Free Helpline 1800-XYZ</p>
                        <button type="button" class="w-full bg-white border border-slate-300 text-slate-700 text-xs font-bold py-1.5 rounded-lg hover:bg-slate-100 transition">Contact Support</button>
                    </div>
                </div>
            </div>

            <div class="flex-1 flex flex-col overflow-hidden bg-slate-50 relative">
                
                <div class="absolute inset-0 z-0 opacity-[0.02]" style="background-image: radial-gradient(#000 1px, transparent 1px); background-size: 24px 24px;"></div>

                <header class="h-20 bg-white/80 backdrop-blur-md border-b border-slate-200 flex items-center justify-between px-6 md:px-10 shadow-sm z-10 sticky top-0">
                    <div class="flex items-center gap-4">
                        <button type="button" class="md:hidden text-slate-600 hover:text-blue-600" onclick="toggleSidebar()">
                            <i class="fa-solid fa-bars text-2xl"></i>
                        </button>
                        <h2 class="text-xl md:text-2xl font-bold text-slate-800">My Dashboard</h2>
                    </div>

                    <div class="flex items-center gap-5">
                        <button type="button" class="relative text-slate-400 hover:text-blue-600 transition">
                            <i class="fa-regular fa-bell text-xl"></i>
                            <span class="absolute top-0 right-0 h-2.5 w-2.5 bg-red-500 rounded-full border-2 border-white"></span>
                        </button>
                        
                        <div class="flex items-center gap-3 pl-5 border-l border-slate-200 cursor-pointer hover:opacity-80 transition">
                            <div class="text-right hidden sm:block">
                                <div class="text-sm font-bold text-slate-800"><asp:Literal ID="litUserName" runat="server"></asp:Literal></div>
                                <div class="text-xs text-slate-500">Verified Citizen</div>
                            </div>
                            <div class="w-10 h-10 rounded-full bg-gradient-to-tr from-blue-500 to-blue-600 text-white flex items-center justify-center font-bold shadow-md">
                                <i class="fa-solid fa-user"></i>
                            </div>
                        </div>
                    </div>
                </header>

                <main class="flex-1 overflow-y-auto p-4 md:p-8 z-10 relative">

                    <div class="bg-gradient-to-r from-blue-600 to-indigo-700 rounded-2xl p-6 md:p-8 shadow-lg mb-8 text-white flex flex-col md:flex-row items-center justify-between gap-6 relative overflow-hidden">
                        <div class="absolute -right-10 -top-10 w-40 h-40 bg-white/10 rounded-full blur-2xl"></div>
                        <div class="absolute right-20 -bottom-10 w-32 h-32 bg-blue-400/20 rounded-full blur-xl"></div>
                        
                        <div class="relative z-10 text-center md:text-left">
                            <span class="bg-white/20 text-blue-50 text-[10px] font-bold px-3 py-1 rounded-full uppercase tracking-widest backdrop-blur-sm border border-white/20 mb-3 inline-block">Citizen Services</span>
                            <h2 class="text-2xl md:text-3xl font-extrabold mb-2">Spot an issue in your area?</h2>
                            <p class="text-blue-100 text-sm md:text-base max-w-lg">Take a photo, upload it with location, and our AI will automatically route it to the correct department for rapid action.</p>
                        </div>
                        <div class="relative z-10 w-full md:w-auto">
                            <a href="ReportIssue.aspx" class="w-full md:w-auto bg-white text-blue-700 hover:bg-slate-50 px-8 py-3.5 rounded-xl font-extrabold shadow-xl transition transform hover:-translate-y-1 flex items-center justify-center gap-3">
                                <i class="fa-solid fa-camera text-xl"></i> File New Complaint
                            </a>
                        </div>
                    </div>

                    <div class="grid grid-cols-3 gap-4 md:gap-6 mb-8">
                        <div class="glass-card p-5 text-center md:text-left md:flex justify-between items-center border-b-4 border-b-blue-500">
                            <div>
                                <p class="text-slate-500 text-xs font-bold uppercase tracking-wider mb-1">Total Reported</p>
                                <h3 class="text-2xl md:text-3xl font-extrabold text-slate-800"><asp:Literal ID="litTotal" runat="server">0</asp:Literal></h3>
                            </div>
                            <div class="hidden md:flex w-12 h-12 rounded-full bg-blue-50 text-blue-600 items-center justify-center text-xl">
                                <i class="fa-solid fa-folder-open"></i>
                            </div>
                        </div>
                        <div class="glass-card p-5 text-center md:text-left md:flex justify-between items-center border-b-4 border-b-orange-400">
                            <div>
                                <p class="text-slate-500 text-xs font-bold uppercase tracking-wider mb-1">In Progress</p>
                                <h3 class="text-2xl md:text-3xl font-extrabold text-orange-500"><asp:Literal ID="litProgress" runat="server">0</asp:Literal></h3>
                            </div>
                            <div class="hidden md:flex w-12 h-12 rounded-full bg-orange-50 text-orange-500 items-center justify-center text-xl">
                                <i class="fa-solid fa-spinner"></i>
                            </div>
                        </div>
                        <div class="glass-card p-5 text-center md:text-left md:flex justify-between items-center border-b-4 border-b-green-500">
                            <div>
                                <p class="text-slate-500 text-xs font-bold uppercase tracking-wider mb-1">Resolved</p>
                                <h3 class="text-2xl md:text-3xl font-extrabold text-green-600"><asp:Literal ID="litResolved" runat="server">0</asp:Literal></h3>
                            </div>
                            <div class="hidden md:flex w-12 h-12 rounded-full bg-green-50 text-green-600 items-center justify-center text-xl">
                                <i class="fa-solid fa-check-double"></i>
                            </div>
                        </div>
                    </div>

                    <h3 class="text-lg font-bold text-slate-800 mb-4 flex items-center gap-2">
                        <i class="fa-solid fa-list-check text-blue-600"></i> Track Active Complaints
                    </h3>

                    <div class="space-y-6">
                        
                        <asp:Repeater ID="rptActiveComplaints" runat="server">
                            <ItemTemplate>
                                <div class="glass-card overflow-hidden">
                                    <div class="bg-slate-50 px-4 md:px-6 py-4 border-b border-slate-100 flex flex-wrap justify-between items-center gap-2">
                                        <div>
                                            <span class='px-2.5 py-1 rounded text-xs font-bold mr-2 border <%# GetDeptBadgeCss(Eval("AssignedDepartment").ToString()) %>'>
                                                <i class='fa-solid <%# GetDeptIcon(Eval("AssignedDepartment").ToString()) %> mr-1'></i> <%# Eval("AssignedDepartment") %>
                                            </span>
                                            <span class="text-sm font-bold text-slate-800"><%# Eval("UserDepartment") %> Issue</span>
                                        </div>
                                        <div class="text-right">
                                            <span class="text-xs font-mono text-slate-500 block">ID: #CMP-<%# Eval("ComplaintID") %></span>
                                            <span class="text-[10px] md:text-xs text-slate-400">Filed: <%# Convert.ToDateTime(Eval("CreatedAt")).ToString("dd MMM yyyy, hh:mm tt") %></span>
                                        </div>
                                    </div>

                                    <div class="p-4 md:p-6 pb-8">
                                        <p class="text-xs md:text-sm font-medium text-slate-600 mb-6 md:mb-8 line-clamp-2"><i class="fa-solid fa-location-dot text-slate-400 mr-2"></i> <%# Eval("LocationName") %></p>

                                        <div class="relative flex justify-between items-start w-full max-w-2xl mx-auto mt-6">
                                            <div class="absolute left-0 progress-bar-bg transform -translate-y-1/2 w-full h-1 bg-slate-200 rounded-full z-0"></div>
                                            <div class="absolute left-0 progress-bar-bg transform -translate-y-1/2 h-1 bg-gradient-to-r from-blue-500 to-indigo-600 rounded-full z-0 transition-all duration-700 ease-in-out" style='width: <%# GetProgressBarWidth(Eval("Status").ToString()) %>;'></div>

                                            <div class="relative z-10 flex flex-col items-center gap-1.5 md:gap-3 bg-white px-1">
                                                <div class='step-circle-wrapper rounded-full flex items-center justify-center <%# GetStepCircleClass(Eval("Status").ToString(), 1) %>'>
                                                    <%# GetStepIcon(Eval("Status").ToString(), 1) %>
                                                </div>
                                                <span class='step-label <%# GetStepTextClass(Eval("Status").ToString(), 1) %>'>Reported</span>
                                            </div>
                                            
                                            <div class="relative z-10 flex flex-col items-center gap-1.5 md:gap-3 bg-white px-1">
                                                <div class='step-circle-wrapper rounded-full flex items-center justify-center <%# GetStepCircleClass(Eval("Status").ToString(), 2) %>'>
                                                    <%# GetStepIcon(Eval("Status").ToString(), 2) %>
                                                </div>
                                                <span class='step-label <%# GetStepTextClass(Eval("Status").ToString(), 2) %>'>AI Verified</span>
                                            </div>
                                            
                                            <div class="relative z-10 flex flex-col items-center gap-1.5 md:gap-3 bg-white px-1">
                                                <div class='step-circle-wrapper rounded-full flex items-center justify-center <%# GetStepCircleClass(Eval("Status").ToString(), 3) %>'>
                                                    <%# GetStepIcon(Eval("Status").ToString(), 3) %>
                                                </div>
                                                <span class='step-label <%# GetStepTextClass(Eval("Status").ToString(), 3) %>'>Assigned</span>
                                            </div>
                                            
                                            <div class="relative z-10 flex flex-col items-center gap-1.5 md:gap-3 bg-white px-1">
                                                <div class='step-circle-wrapper rounded-full flex items-center justify-center <%# GetStepCircleClass(Eval("Status").ToString(), 4) %>'>
                                                    <%# GetStepIcon(Eval("Status").ToString(), 4) %>
                                                </div>
                                                <span class='step-label <%# GetStepTextClass(Eval("Status").ToString(), 4) %>'>Resolved</span>
                                            </div>
                                        </div>
                                        <div class="mt-8 md:mt-10 bg-blue-50/50 border border-blue-100 rounded-xl p-3 md:p-4 flex items-start gap-3 shadow-sm">
                                            <div class="w-8 h-8 rounded-full bg-blue-100 text-blue-600 flex items-center justify-center shrink-0 mt-0.5">
                                                <i class="fa-solid fa-bell text-sm"></i>
                                            </div>
                                            <div>
                                                <p class="text-[10px] md:text-xs text-blue-800 font-bold uppercase tracking-wider mb-1">Latest Status Update</p>
                                                <p class="text-xs md:text-sm font-medium text-slate-700 leading-relaxed"><%# GetLatestUpdate(Eval("Status").ToString(), Eval("Description").ToString()) %></p>
                                            </div>
                                        </div>
                                    </div>
                                </div>
                            </ItemTemplate>
                        </asp:Repeater>

                        <div id="noDataPanel" runat="server" visible="false" class="glass-card text-center py-16 px-4">
                            <div class="w-20 h-20 bg-green-50 text-green-500 rounded-full flex items-center justify-center mx-auto mb-4 text-4xl shadow-sm border border-green-100">
                                <i class="fa-solid fa-leaf"></i>
                            </div>
                            <h3 class="text-xl font-bold text-slate-800">Your neighborhood is clean & green!</h3>
                            <p class="text-slate-500 text-sm mt-2 max-w-md mx-auto">You have no active pending complaints. If you spot any civic issue, click the button above to report it.</p>
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
        </script>
    </form>
</body>
</html>