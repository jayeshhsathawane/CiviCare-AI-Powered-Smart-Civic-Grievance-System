<%@ Page Language="C#" AutoEventWireup="true" CodeFile="SystemLogin.aspx.cs" Inherits="SystemLogin" %>

<!DOCTYPE html>
<html xmlns="http://www.w3.org/1999/xhtml" lang="en">
<head runat="server">
    <meta charset="UTF-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1.0, maximum-scale=1.0, user-scalable=no" />
    <title>Authorized Access</title>
    
    <script src="https://cdn.tailwindcss.com"></script>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css" />
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@300;400;500;600;700&display=swap" rel="stylesheet" />

    <style>
        body { font-family: 'Inter', sans-serif; background-color: #f1f5f9; overflow-x: hidden; }
        
        .glass-panel {
            background: #ffffff;
            border-top: 4px solid #1e3a8a; /* Government Blue Deep */
            border-radius: 12px;
            box-shadow: 0 10px 25px -5px rgba(0, 0, 0, 0.1), 0 8px 10px -6px rgba(0, 0, 0, 0.1);
        }

        .input-field { width: 100%; padding: 0.75rem 2.5rem 0.75rem 2.5rem; border: 1px solid #cbd5e1; border-radius: 8px; outline: none; transition: all 0.2s; color: #334155; font-size: 0.875rem; background-color:#f8fafc; }
        .input-field:focus { border-color: #1e40af; box-shadow: 0 0 0 3px rgba(30, 64, 175, 0.15); background-color:#ffffff; }
        
        .input-icon { position: absolute; left: 1rem; top: 50%; transform: translateY(-50%); color: #64748b; font-size: 0.9rem; }
        .eye-icon { position: absolute; right: 1rem; top: 50%; transform: translateY(-50%); color: #64748b; cursor: pointer; transition: color 0.2s; font-size: 1rem;}
        .eye-icon:hover { color: #1e40af; }

        /* Toast Animations */
        @keyframes slideInRight { from { transform: translateX(100%); opacity: 0; } to { transform: translateX(0); opacity: 1; } }
        @keyframes fadeOutUp { from { opacity: 1; transform: translateY(0); } to { opacity: 0; transform: translateY(-20px); } }
        .toast-enter { animation: slideInRight 0.4s cubic-bezier(0.16, 1, 0.3, 1) forwards; }
        .toast-exit { animation: fadeOutUp 0.4s ease forwards; }
        
        @keyframes popIn { from { opacity: 0; transform: scale(0.95); } to { opacity: 1; transform: scale(1); } }
        .modal-pop { animation: popIn 0.2s ease-out forwards; }
        
        .val-error { color: #ef4444; font-size: 0.75rem; font-weight: 500; display: block; margin-top: 0.25rem; }
    </style>
</head>
<body class="min-h-screen flex flex-col items-center justify-center relative px-4 py-8">
    
    <div class="absolute inset-0 z-0 opacity-10 pointer-events-none" style="background-image: radial-gradient(#1e3a8a 1px, transparent 1px); background-size: 20px 20px;"></div>
    <div class="absolute top-0 left-0 w-full h-[35vh] md:h-72 bg-gradient-to-b from-blue-900 to-transparent z-0 pointer-events-none"></div>

    <div id="toast-container" class="fixed top-5 right-5 z-[99999] flex flex-col gap-3 pointer-events-none"></div>

    <form id="form1" runat="server" class="w-full max-w-md relative z-10 flex flex-col items-center">
        <asp:ScriptManager runat="server" />
        
        <div class="text-center w-full mb-4">
            <div class="w-24 h-24 mx-auto bg-white rounded-full flex items-center justify-center shadow-xl border-4 border-white mb-2 overflow-hidden">
                <img src="/IMG/civiclogo.png" alt="CiviCare Logo" class="w-full h-full object-cover" onerror="this.style.display='none'; this.nextElementSibling.style.display='block';" />
                <i class="fa-solid fa-building-columns text-4xl text-blue-800 hidden" style="display:none;"></i>
            </div>
            <h1 class="text-2xl font-extrabold text-slate-800 md:text-white tracking-tight drop-shadow-sm md:drop-shadow-md mt-2">CiviCare System</h1>
           
        </div>

        <asp:UpdatePanel runat="server" UpdateMode="Conditional" class="w-full">
            <ContentTemplate>
                
                <div class="glass-panel p-6 md:p-8 w-full">
                    
                    <div class="flex items-center gap-2 mb-5 pb-3 border-b border-slate-100">
                        <i class="fa-solid fa-shield-halved text-blue-800 text-lg"></i>
                        <h2 class="text-base font-bold text-slate-800">Secure Gateway</h2>
                    </div>

                    <div class="space-y-4">
                        
                        <div>
                            <label class="block text-[11px] font-bold text-slate-600 mb-1 uppercase tracking-wide">Designation / Role <span class="text-red-500">*</span></label>
                            <div class="relative">
                                <i class="fa-solid fa-id-badge input-icon"></i>
                                <asp:DropDownList ID="ddlRole" runat="server" CssClass="input-field appearance-none cursor-pointer pr-10 text-sm">
                                    <asp:ListItem Text="Select Designation" Value=""></asp:ListItem>
                                    <asp:ListItem Text="System Administrator" Value="Admin"></asp:ListItem>
                                    <asp:ListItem Text="Electricity Dept Head" Value="Electric"></asp:ListItem>
                                    <asp:ListItem Text="Water Dept Head" Value="Water"></asp:ListItem>
                                    <asp:ListItem Text="Sanitation Dept Head" Value="Sanitation"></asp:ListItem>
                                </asp:DropDownList>
                                <i class="fa-solid fa-chevron-down absolute right-4 top-1/2 -translate-y-1/2 text-slate-400 text-xs pointer-events-none"></i>
                            </div>
                            <asp:RequiredFieldValidator ID="rfvRole" runat="server" ControlToValidate="ddlRole" InitialValue="" ErrorMessage="Please select your role" ValidationGroup="SystemLogin" CssClass="val-error" Display="Dynamic" />
                        </div>

                        <div>
                            <label class="block text-[11px] font-bold text-slate-600 mb-1 uppercase tracking-wide">Official ID (Email/Mobile) <span class="text-red-500">*</span></label>
                            <div class="relative">
                                <i class="fa-solid fa-envelope input-icon"></i>
                                <asp:TextBox ID="txtLoginId" runat="server" CssClass="input-field text-sm" placeholder="Enter official credential" ValidationGroup="SystemLogin"></asp:TextBox>
                            </div>
                            <asp:RequiredFieldValidator ID="rfvId" runat="server" ControlToValidate="txtLoginId" ErrorMessage="Login ID is required" ValidationGroup="SystemLogin" CssClass="val-error" Display="Dynamic" />
                        </div>

                        <div>
                            <div class="flex justify-between items-center mb-1">
                                <label class="block text-[11px] font-bold text-slate-600 uppercase tracking-wide">Security Key (Password) <span class="text-red-500">*</span></label>
                            </div>
                            <div class="relative">
                                <i class="fa-solid fa-lock input-icon"></i>
                                <asp:TextBox ID="txtPassword" runat="server" TextMode="Password" CssClass="input-field text-sm" placeholder="••••••••" ValidationGroup="SystemLogin"></asp:TextBox>
                                <i class="fa-solid fa-eye-slash eye-icon" onclick="togglePasswordVisibility('<%= txtPassword.ClientID %>', this)"></i>
                            </div>
                            <asp:RequiredFieldValidator ID="rfvPass" runat="server" ControlToValidate="txtPassword" ErrorMessage="Password is required" ValidationGroup="SystemLogin" CssClass="val-error" Display="Dynamic" />
                        </div>

                        <div class="pt-2">
                            <asp:Button ID="btnLogin" runat="server" Text="Authenticate & Proceed" OnClick="btnLogin_Click" ValidationGroup="SystemLogin" UseSubmitBehavior="false"
                                CssClass="w-full bg-blue-800 hover:bg-blue-900 text-white font-bold py-3 rounded-lg shadow-md transition text-sm cursor-pointer hover:-translate-y-0.5 tracking-wide" />
                        </div>

                    </div>
                </div>

            </ContentTemplate>
        </asp:UpdatePanel>

       

    </form>

    <script>
        // Toggle Password Visibility Logic
        function togglePasswordVisibility(inputId, iconElement) {
            var passwordInput = document.getElementById(inputId);
            if (passwordInput.type === "password") {
                passwordInput.type = "text";
                iconElement.classList.remove("fa-eye-slash");
                iconElement.classList.add("fa-eye");
                iconElement.classList.add("text-blue-800"); 
            } else {
                passwordInput.type = "password";
                iconElement.classList.remove("fa-eye");
                iconElement.classList.add("fa-eye-slash");
                iconElement.classList.remove("text-blue-800");
            }
        }

        // Professional Toast Notification Logic
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
</body>
</html>