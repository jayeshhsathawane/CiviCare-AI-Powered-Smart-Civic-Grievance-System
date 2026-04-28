<%@ Page Language="C#" AutoEventWireup="true" CodeFile="ReportIssue.aspx.cs" Inherits="ReportIssue" %>

<!DOCTYPE html>
<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title>Report Issue | Citizen Portal</title>
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

        .input-field {
            width: 100%; padding: 0.75rem 1rem;
            border: 1px solid #cbd5e1; border-radius: 8px;
            outline: none; transition: all 0.2s; color: #334155; font-size: 0.875rem;
        }
        .input-field:focus { border-color: #3b82f6; box-shadow: 0 0 0 3px rgba(59, 130, 246, 0.1); }

        /* Toast Animations */
        @keyframes slideInRight { from { transform: translateX(100%); opacity: 0; } to { transform: translateX(0); opacity: 1; } }
        @keyframes fadeOutUp { from { opacity: 1; transform: translateY(0); } to { opacity: 0; transform: translateY(-20px); } }
        .toast-enter { animation: slideInRight 0.4s cubic-bezier(0.16, 1, 0.3, 1) forwards; }
        .toast-exit { animation: fadeOutUp 0.4s ease forwards; }

        #mobileSidebar { transition: transform 0.3s ease-in-out; }
    </style>
</head>
<body class="text-slate-700 antialiased">
    
    <div id="toast-container" class="fixed top-5 right-5 z-[99999] flex flex-col gap-3 pointer-events-none"></div>

    <form id="form1" runat="server" enctype="multipart/form-data">
        <asp:ScriptManager runat="server" />

        <asp:HiddenField ID="hfLat" runat="server" Value="0" />
        <asp:HiddenField ID="hfLng" runat="server" Value="0" />

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
                    <a href="ReportIssue.aspx" class="nav-link active flex items-center px-4 py-3 text-sm">
                        <i class="fa-solid fa-camera w-6 text-center opacity-80"></i> Report New Issue
                    </a>
                    <a href="MyComplaints.aspx" class="nav-link flex items-center px-4 py-3 text-sm">
                        <i class="fa-solid fa-magnifying-glass-location w-6 text-center opacity-80"></i> Track Complaints
                    </a>
                    <%--<a href="CityAlerts.aspx" class="nav-link flex items-center px-4 py-3 text-sm">
                        <i class="fa-solid fa-bullhorn w-6 text-center opacity-80"></i> City Alerts
                    </a>--%>
                    
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
                    <button type="button" onclick="toggleSidebar()" class="text-slate-500 hover:text-slate-800"><i class="fa-solid fa-xmark text-2xl"></i></button>
                </div>
                
                <nav class="flex-1 py-6 px-4 space-y-2 overflow-y-auto no-scrollbar">
                    <p class="px-4 text-xs font-bold text-slate-400 uppercase tracking-widest mb-3">Main Menu</p>
                    <a href="CitizenDashboard.aspx" class="nav-link flex items-center px-4 py-3 text-sm">
                        <i class="fa-solid fa-house w-6 text-center opacity-80"></i> Home Dashboard
                    </a>
                    <a href="ReportIssue.aspx" class="nav-link active flex items-center px-4 py-3 text-sm">
                        <i class="fa-solid fa-camera w-6 text-center opacity-80"></i> Report New Issue
                    </a>
                    <a href="MyComplaints.aspx" class="nav-link flex items-center px-4 py-3 text-sm">
                        <i class="fa-solid fa-magnifying-glass-location w-6 text-center opacity-80"></i> Track Complaints
                    </a>
                   <%-- <a href="CityAlerts.aspx" class="nav-link flex items-center px-4 py-3 text-sm">
                        <i class="fa-solid fa-bullhorn w-6 text-center opacity-80"></i> City Alerts
                    </a>
                    --%>
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
                <header class="h-20 bg-white/80 backdrop-blur-md border-b border-slate-200 flex items-center justify-between px-6 md:px-10 shadow-sm z-10 sticky top-0">
                    <div class="flex items-center gap-4">
                        <button type="button" class="md:hidden text-slate-600 hover:text-blue-600" onclick="toggleSidebar()"><i class="fa-solid fa-bars text-2xl"></i></button>
                        <h2 class="text-xl md:text-2xl font-bold text-slate-800">Report a Civic Issue</h2>
                    </div>
                    <div class="w-10 h-10 rounded-full bg-gradient-to-tr from-blue-500 to-blue-600 text-white flex items-center justify-center font-bold shadow-md cursor-pointer">
                        <i class="fa-solid fa-user"></i>
                    </div>
                </header>

                <main class="flex-1 overflow-y-auto p-4 md:p-8 z-10 relative">
                    
                    <div class="max-w-3xl mx-auto bg-white rounded-2xl shadow-sm border border-slate-200 overflow-hidden">
                        
                        <div class="bg-blue-50 p-6 border-b border-blue-100 flex items-start gap-4">
                            <i class="fa-solid fa-robot text-3xl text-blue-600 mt-1"></i>
                            <div>
                                <h3 class="font-bold text-slate-800 text-lg">AI-Assisted Reporting (Anti-Fake)</h3>
                                <p class="text-sm text-slate-600 mt-1">Capture a live photo. Our system will automatically stamp your live Location (GPS) and Time on the photo to prevent fake complaints.</p>
                            </div>
                        </div>

                        <div class="p-6 md:p-8 space-y-6">
                            
                            <div>
                                <label class="block text-sm font-bold text-slate-700 mb-2">1. Capture Evidence (Live Photo Only) <span class="text-red-500">*</span></label>
                                
                                <input type="file" id="fuCameraHtml" name="fuCameraHtml" accept="image/*" capture="environment" class="hidden" onchange="previewImage(event)" />
                                
                                <div id="cameraBox" class="border-2 border-dashed border-slate-300 rounded-xl p-8 text-center cursor-pointer hover:bg-slate-50 transition hover:border-blue-400 group" onclick="document.getElementById('fuCameraHtml').click();">
                                    <div id="cameraPlaceholder">
                                        <div class="w-16 h-16 bg-blue-100 text-blue-600 rounded-full flex items-center justify-center mx-auto mb-3 text-2xl group-hover:scale-110 transition">
                                            <i class="fa-solid fa-camera"></i>
                                        </div>
                                        <p class="font-bold text-slate-700">Tap to Open Camera</p>
                                        <p class="text-xs text-slate-500 mt-1">Ensure the issue is clearly visible in the frame.</p>
                                    </div>
                                    <img id="imagePreview" class="hidden max-h-64 mx-auto rounded-lg shadow-md object-cover" alt="Captured Issue" />
                                </div>
                                <button type="button" id="btnRetake" class="hidden mt-3 text-sm text-red-500 font-bold hover:underline" onclick="retakePhoto()"><i class="fa-solid fa-rotate-right"></i> Retake Photo</button>
                            </div>

                            <div>
                                <label class="block text-sm font-bold text-slate-700 mb-2">2. Exact Area / Location Name <span class="text-red-500">*</span></label>
                                <div class="flex flex-col sm:flex-row gap-3">
                                    <div class="relative flex-1">
                                        <i class="fa-solid fa-location-dot absolute left-3 top-1/2 transform -translate-y-1/2 text-slate-400"></i>
                                        <asp:TextBox ID="txtLocation" runat="server" CssClass="input-field pl-9" placeholder="Press 'Detect Live Location'..." ReadOnly="false"></asp:TextBox>
                                    </div>
                                    <button type="button" onclick="getGPSLocation()" class="bg-slate-800 hover:bg-slate-900 text-white px-5 py-3 rounded-lg text-sm font-bold shadow-sm transition whitespace-nowrap flex items-center justify-center gap-2">
                                        <i class="fa-solid fa-location-crosshairs"></i> Detect Live Location
                                    </button>
                                </div>
                                <p id="gpsStatus" class="text-xs text-blue-600 font-bold mt-2 hidden"><i class="fa-solid fa-spinner animate-spin"></i> Locating your device accurately...</p>
                            </div>

                            <div class="grid grid-cols-1 md:grid-cols-2 gap-6">
                                <div>
                                    <label class="block text-sm font-bold text-slate-700 mb-2">3. Related Department</label>
                                    <asp:DropDownList ID="ddlDept" runat="server" CssClass="input-field appearance-none bg-white cursor-pointer">
                                        <asp:ListItem Text="Let AI Decide (Auto-Detect)" Value="AI" Selected="True"></asp:ListItem>
                                        <asp:ListItem Text="Electricity (Streetlights, Wiring)" Value="Electric"></asp:ListItem>
                                        <asp:ListItem Text="Water Supply (Leaks, Drain)" Value="Water"></asp:ListItem>
                                        <asp:ListItem Text="Sanitation (Garbage, Dead Animal)" Value="Sanitation"></asp:ListItem>
                                    </asp:DropDownList>
                                </div>
                                <div>
                                    <label class="block text-sm font-bold text-slate-700 mb-2">4. Brief Description <span class="text-slate-400 font-normal"></span></label>
                                    <asp:TextBox ID="txtDescription" runat="server" TextMode="MultiLine" Rows="2" CssClass="input-field"></asp:TextBox>
                                </div>
                            </div>

                            <div class="pt-6 border-t border-slate-100">
                                <asp:Button ID="btnSubmitIssue" runat="server" Text="Submit Complaint Securely" OnClick="btnSubmitIssue_Click" CssClass="w-full bg-blue-600 hover:bg-blue-700 text-white font-extrabold py-4 rounded-xl shadow-lg shadow-blue-200 transition transform hover:-translate-y-1 cursor-pointer text-lg" />
                            </div>

                        </div>
                    </div>
                </main>
            </div>
        </div>

        <script>
            function toggleSidebar() {
                document.getElementById('mobileSidebar').classList.toggle('-translate-x-full');
            }

            function previewImage(event) {
                var input = event.target;
                if (input.files && input.files[0]) {
                    var reader = new FileReader();
                    reader.onload = function(e) {
                        document.getElementById('cameraPlaceholder').classList.add('hidden');
                        var imgPreview = document.getElementById('imagePreview');
                        imgPreview.src = e.target.result;
                        imgPreview.classList.remove('hidden');
                        document.getElementById('btnRetake').classList.remove('hidden');
                    }
                    reader.readAsDataURL(input.files[0]);
                }
            }

            function retakePhoto() {
                document.getElementById('fuCameraHtml').value = '';
                document.getElementById('imagePreview').classList.add('hidden');
                document.getElementById('btnRetake').classList.add('hidden');
                document.getElementById('cameraPlaceholder').classList.remove('hidden');
                document.getElementById('fuCameraHtml').click();
            }

            // ==========================================
            // FULL ADDRESS PARSER (Detailed Full Address)
            // ==========================================
            function getGPSLocation() {
                const statusTxt = document.getElementById('gpsStatus');
                const locInput = document.getElementById('<%= txtLocation.ClientID %>');
                const hfLat = document.getElementById('<%= hfLat.ClientID %>');
                const hfLng = document.getElementById('<%= hfLng.ClientID %>');
                
                statusTxt.classList.remove('hidden');
                statusTxt.innerHTML = "<i class='fa-solid fa-spinner animate-spin text-blue-600'></i> Requesting precise GPS connection...";
                statusTxt.className = "text-xs font-bold mt-2 text-blue-600";
                
                if (navigator.geolocation) {
                    
                    const options = {
                        enableHighAccuracy: true,
                        timeout: 15000,
                        maximumAge: 0
                    };

                    navigator.geolocation.getCurrentPosition(function(position) {
                        
                        const lat = position.coords.latitude;
                        const lng = position.coords.longitude;
                        
                        hfLat.value = lat;
                        hfLng.value = lng;

                        statusTxt.innerHTML = "<i class='fa-solid fa-spinner animate-spin text-blue-600'></i> Fetching Full Address Name...";

                        // Using OSM Nominatim to fetch the exact FULL Address String
                        const url = `https://nominatim.openstreetmap.org/reverse?format=jsonv2&lat=${lat}&lon=${lng}`;

                        fetch(url)
                            .then(response => response.json())
                            .then(data => {
                                if (data && data.display_name) {
                                    // REVERTED to use the full `display_name` directly (e.g. GH Raisoni, CRPF, Nagpur, MH, India, 440001)
                                    locInput.value = data.display_name; 
                                    statusTxt.innerHTML = "<i class='fa-solid fa-check text-green-600'></i> Exact location detected successfully.";
                                    statusTxt.className = "text-xs font-bold mt-2 text-green-600";
                                } else {
                                    locInput.value = "Lat: " + lat.toFixed(5) + ", Lng: " + lng.toFixed(5);
                                    statusTxt.innerHTML = "<i class='fa-solid fa-check text-green-600'></i> GPS Pinned (Address name unavailable).";
                                    statusTxt.className = "text-xs font-bold mt-2 text-green-600";
                                }
                            })
                            .catch(err => {
                                locInput.value = "Lat: " + lat.toFixed(5) + ", Lng: " + lng.toFixed(5);
                                statusTxt.innerHTML = "<i class='fa-solid fa-check text-green-600'></i> GPS Pinned (Offline Mode).";
                                statusTxt.className = "text-xs font-bold mt-2 text-green-600";
                            });

                    }, function(error) {
                        let errorMsg = "Please 'Allow' location access when prompted.";
                        if (error.code === 1) errorMsg = "You denied the location permission.";
                        else if (error.code === 2) errorMsg = "Location unavailable. Please turn ON your device GPS.";
                        else if (error.code === 3) errorMsg = "GPS connection timed out. Try outside under a clear sky.";
                        
                        statusTxt.innerHTML = "<i class='fa-solid fa-triangle-exclamation text-red-500'></i> " + errorMsg;
                        statusTxt.className = "text-xs font-bold mt-2 text-red-500";
                    }, options);
                } else {
                    statusTxt.innerHTML = "GPS is not supported by your device/browser.";
                }
            }

            function showToast(message, type) {
                const container = document.getElementById('toast-container');
                const toast = document.createElement('div');
                
                const isSuccess = type === 'success';
                const bgColor = isSuccess ? 'bg-emerald-600' : 'bg-red-600';
                const icon = isSuccess ? 'fa-circle-check' : 'fa-circle-exclamation';

                toast.className = "flex items-center gap-3 px-5 py-4 rounded-xl shadow-2xl text-white text-sm font-bold toast-enter pointer-events-auto " + bgColor;
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