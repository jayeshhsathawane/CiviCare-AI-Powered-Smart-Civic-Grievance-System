<%@ Page Language="C#" AutoEventWireup="true" CodeFile="CitizenRegister.aspx.cs" Inherits="CitizenRegister" %>

<!DOCTYPE html>
<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title>Citizen Registration | CiviCare</title>
    <meta name="viewport" content="width=device-width, initial-scale=1.0" />
    
    <script src="https://cdn.tailwindcss.com"></script>
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@300;400;500;600;700&display=swap" rel="stylesheet" />
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css" />

    <style>
        body { font-family: 'Inter', sans-serif; background-color: #f8fafc; }
        .input-field {
            width: 100%; padding: 0.65rem 1rem 0.65rem 2.5rem;
            border: 1px solid #cbd5e1; border-radius: 0.5rem;
            outline: none; transition: all 0.2s; color: #334155; font-size: 0.875rem;
        }
        .input-field:focus { border-color: #3b82f6; box-shadow: 0 0 0 3px rgba(59, 130, 246, 0.1); }
        .input-icon { position: absolute; left: 1rem; top: 50%; transform: translateY(-50%); color: #94a3b8; font-size: 0.875rem; }
    </style>
</head>
<body class="min-h-screen flex items-center justify-center p-4 py-10">
    <form id="form1" runat="server" class="w-full max-w-lg">
        
        <div class="bg-white rounded-2xl shadow-xl border border-slate-100 overflow-hidden">
            
            <div class="bg-blue-600 p-6 text-center text-white">
                <i class="fa-solid fa-city text-4xl mb-2"></i>
                <h2 class="text-2xl font-bold tracking-wide">Join CiviCare</h2>
                <p class="text-blue-100 text-sm mt-1">Register to report and track city issues.</p>
            </div>

            <div class="p-8">
                <asp:Label ID="lblMessage" runat="server" CssClass="block text-center text-sm font-bold mb-4"></asp:Label>

                <div class="space-y-4">
                    <div>
                        <label class="block text-xs font-bold text-slate-700 uppercase tracking-wide mb-1">Full Name</label>
                        <div class="relative">
                            <i class="fa-solid fa-id-card input-icon"></i>
                            <asp:TextBox ID="txtFullName" runat="server" CssClass="input-field" placeholder="John Doe" required="required"></asp:TextBox>
                        </div>
                    </div>

                    <div class="grid grid-cols-1 md:grid-cols-2 gap-4">
                        <div>
                            <label class="block text-xs font-bold text-slate-700 uppercase tracking-wide mb-1">Email Address</label>
                            <div class="relative">
                                <i class="fa-solid fa-envelope input-icon"></i>
                                <asp:TextBox ID="txtEmail" runat="server" CssClass="input-field" placeholder="john@example.com" required="required"></asp:TextBox>
                            </div>
                        </div>

                        <div>
                            <label class="block text-xs font-bold text-slate-700 uppercase tracking-wide mb-1">Mobile Number</label>
                            <div class="relative">
                                <i class="fa-solid fa-phone input-icon"></i>
                                <asp:TextBox ID="txtMobile" runat="server" CssClass="input-field" placeholder="10-digit number" required="required" MaxLength="10"></asp:TextBox>
                            </div>
                        </div>
                    </div>

                    <div>
                        <label class="block text-xs font-bold text-slate-700 uppercase tracking-wide mb-1">Create Password</label>
                        <div class="relative">
                            <i class="fa-solid fa-lock input-icon"></i>
                            <asp:TextBox ID="txtPassword" runat="server" TextMode="Password" CssClass="input-field" placeholder="Strong password" required="required"></asp:TextBox>
                        </div>
                    </div>

                    <div>
                        <label class="block text-xs font-bold text-slate-700 uppercase tracking-wide mb-1">Confirm Password</label>
                        <div class="relative">
                            <i class="fa-solid fa-check-double input-icon"></i>
                            <asp:TextBox ID="txtConfirmPassword" runat="server" TextMode="Password" CssClass="input-field" placeholder="Repeat password" required="required"></asp:TextBox>
                        </div>
                        <asp:CompareValidator ID="cmpPasswords" runat="server" ControlToValidate="txtConfirmPassword" ControlToCompare="txtPassword" 
                            ErrorMessage="Passwords do not match!" CssClass="text-xs text-red-500 font-semibold mt-1 block" Display="Dynamic"></asp:CompareValidator>
                    </div>

                    <div class="pt-4">
                        <asp:Button ID="btnRegister" runat="server" Text="Create Citizen Account" OnClick="btnRegister_Click"
                            CssClass="w-full bg-slate-800 hover:bg-slate-900 text-white font-bold py-3 px-4 rounded-lg shadow-md transition transform hover:-translate-y-0.5 cursor-pointer" />
                    </div>
                </div>

                <div class="mt-6 text-center border-t border-slate-100 pt-6">
                    <p class="text-sm text-slate-500 font-medium">
                        Already registered? 
                        <a href="CitizenLogin.aspx" class="text-blue-600 font-bold hover:underline">Log in here</a>
                    </p>
                </div>
            </div>
        </div>
    </form>
</body>
</html>