<%@ Page Language="C#" AutoEventWireup="true" CodeFile="Default.aspx.cs" Inherits="_Default" %>

<!DOCTYPE html>
<html xmlns="http://www.w3.org/1999/xhtml" lang="en">
<head runat="server">
    <meta charset="UTF-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1.0" />
    <title>CiviCare | AI-Powered Grievance System</title>
    
    <script src="https://cdn.tailwindcss.com"></script>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css" />
    <link href="https://fonts.googleapis.com/css2?family=Outfit:wght@300;400;500;700;800&display=swap" rel="stylesheet" />

    <script src="https://accounts.google.com/gsi/client" async defer></script>

    <style>
        body { font-family: 'Outfit', sans-serif; scroll-behavior: smooth; }
        
        .glass-card { background: rgba(255, 255, 255, 1); border: 1px solid #e2e8f0; border-radius: 8px; box-shadow: 0 4px 6px -1px rgba(0, 0, 0, 0.05); transition: all 0.2s ease; }
        .glass-card:hover { transform: translateY(-3px); box-shadow: 0 10px 15px -3px rgba(37, 99, 235, 0.1); border-color: #bfdbfe; }

        .collage-grid { display: grid; grid-template-columns: repeat(2, 1fr); gap: 12px; }
        .collage-img { width: 100%; height: 180px; object-fit: cover; border-radius: 8px; transition: transform 0.4s ease; opacity: 1 !important; }
        .collage-img:hover { transform: scale(1.05); z-index: 10; position: relative; box-shadow: 0 20px 25px -5px rgba(0, 0, 0, 0.1); }

        @keyframes fadeUp { from { opacity: 0; transform: translateY(20px); } to { opacity: 1; transform: translateY(0); } }
        .animate-fade-up { animation: fadeUp 0.8s ease-out forwards; }
        @keyframes popIn { from { opacity: 0; transform: scale(0.98); } to { opacity: 1; transform: scale(1); } }
        .modal-pop { animation: popIn 0.2s ease-out forwards; }

        @keyframes slideInRight { from { transform: translateX(100%); opacity: 0; } to { transform: translateX(0); opacity: 1; } }
        @keyframes fadeOutUp { from { opacity: 1; transform: translateY(0); } to { opacity: 0; transform: translateY(-20px); } }
        .toast-enter { animation: slideInRight 0.4s cubic-bezier(0.16, 1, 0.3, 1) forwards; }
        .toast-exit { animation: fadeOutUp 0.4s ease forwards; }

        .input-field { width: 100%; padding: 0.65rem 2.5rem 0.65rem 2.5rem; border: 1px solid #cbd5e1; border-radius: 6px; outline: none; transition: all 0.2s; color: #334155; font-size: 0.875rem; }
        .input-field:focus { border-color: #3b82f6; box-shadow: 0 0 0 3px rgba(59, 130, 246, 0.15); }
        .input-field:invalid:not(:placeholder-shown) { border-color: #ef4444; }
        
        .input-icon { position: absolute; left: 0.85rem; top: 50%; transform: translateY(-50%); color: #94a3b8; font-size: 0.9rem; }
        .eye-icon { position: absolute; right: 0.85rem; top: 50%; transform: translateY(-50%); color: #94a3b8; cursor: pointer; transition: color 0.2s; }
        .eye-icon:hover { color: #3b82f6; }

        .view-hidden { display: none; }
        .no-scrollbar::-webkit-scrollbar { display: none; }
        .no-scrollbar { -ms-overflow-style: none; scrollbar-width: none; }
        
        .step-connector::after {
            content: ''; position: absolute; top: 2rem; right: -50%; width: 100%; height: 2px;
            background: dashed 2px #cbd5e1; z-index: -1;
        }
        @media (max-width: 1024px) { .step-connector::after { display: none; } }
    </style>
</head>
<body class="bg-gray-50 text-slate-800 antialiased">
    <div id="toast-container" class="fixed top-5 right-5 z-[99999] flex flex-col gap-3 pointer-events-none"></div>
    <form id="form1" runat="server">
         <asp:ScriptManager runat="server" />
        <asp:HiddenField ID="hfGoogleToken" runat="server" />
        <asp:Button ID="btnGoogleSubmit" runat="server" OnClick="btnGoogleSubmit_Click" Style="display: none;" CausesValidation="false" />

        <nav class="sticky top-0 z-50 bg-white/95 backdrop-blur-md border-b border-slate-200 shadow-sm transition-all duration-300">
            <div class="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8 flex justify-between items-center h-20 relative">
                <div class="flex items-center gap-3 cursor-pointer" onclick="window.scrollTo(0,0);">
                    <img src="/IMG/civiclogo.png" alt="CiviCare Logo" class="w-11 h-11 object-contain rounded-xl shadow-lg shadow-blue-200/50 bg-white" 
                         onerror="this.onerror=null; this.outerHTML='<div class=\'w-11 h-11 bg-gradient-to-br from-blue-600 to-indigo-700 rounded-xl flex items-center justify-center text-white text-xl shadow-lg shadow-blue-200/50\'><i class=\'fa-solid fa-city\'></i></div>';" />
                    <div class="flex flex-col justify-center">
                        <h1 class="text-2xl font-extrabold tracking-tight text-slate-900 leading-none">Civi<span class="text-blue-600">Care</span></h1>
                        <span class="text-[10px] font-bold text-slate-400 uppercase tracking-widest mt-0.5">Smart Portal</span>
                    </div>
                </div>

                <div class="hidden lg:flex items-center space-x-8 mt-1 absolute left-1/2 transform -translate-x-1/2">
                    <a href="#home" class="nav-item text-blue-600 border-blue-600 border-b-2 text-sm font-semibold hover:text-blue-600 transition py-2">Home</a>
                    <a href="#how-it-works" class="nav-item text-slate-600 border-transparent border-b-2 text-sm font-semibold hover:text-blue-600 transition py-2">How it Works</a>
                    <a href="#citizen-guide" class="nav-item text-slate-600 border-transparent border-b-2 text-sm font-semibold hover:text-blue-600 transition py-2">Guide</a>
                    <a href="#departments" class="nav-item text-slate-600 border-transparent border-b-2 text-sm font-semibold hover:text-blue-600 transition py-2">Departments</a>
                </div>

                <div class="hidden md:flex items-center gap-3">
                    <button type="button" onclick="openModal('Citizen')" class="bg-blue-600 hover:bg-blue-700 text-white px-5 py-2 rounded-lg text-sm font-bold shadow-md shadow-blue-200 transition transform hover:-translate-y-0.5 ml-1">Citizen Login</button>
                </div>

                <button type="button" class="md:hidden text-slate-600 hover:text-blue-600 text-2xl p-2 focus:outline-none" onclick="document.getElementById('mobileMenu').classList.toggle('hidden')">
                    <i class="fa-solid fa-bars-staggered"></i>
                </button>
            </div>

            <div id="mobileMenu" class="hidden md:hidden bg-white border-t border-slate-100 p-5 shadow-2xl absolute w-full left-0 top-20 z-50">
                <div class="space-y-1 mb-6 border-b border-slate-100 pb-4">
                    <a href="#home" class="block w-full text-left px-3 py-2 text-sm font-bold text-slate-700 hover:bg-blue-50 hover:text-blue-600 rounded" onclick="document.getElementById('mobileMenu').classList.add('hidden')">Home</a>
                    <a href="#how-it-works" class="block w-full text-left px-3 py-2 text-sm font-bold text-slate-700 hover:bg-blue-50 hover:text-blue-600 rounded" onclick="document.getElementById('mobileMenu').classList.add('hidden')">How it Works</a>
                    <a href="#citizen-guide" class="block w-full text-left px-3 py-2 text-sm font-bold text-slate-700 hover:bg-blue-50 hover:text-blue-600 rounded" onclick="document.getElementById('mobileMenu').classList.add('hidden')">Guide</a>
                    <a href="#departments" class="block w-full text-left px-3 py-2 text-sm font-bold text-slate-700 hover:bg-blue-50 hover:text-blue-600 rounded" onclick="document.getElementById('mobileMenu').classList.add('hidden')">Departments</a>
                </div>
                <p class="text-xs font-bold text-slate-400 uppercase tracking-widest mb-3">Access Portals</p>
                <div class="space-y-2">
                    <button type="button" onclick="openModal('Citizen')" class="w-full text-center bg-blue-600 text-white hover:bg-blue-700 font-bold py-3 px-4 rounded-lg text-sm flex justify-center items-center shadow-md transition"><i class="fa-solid fa-circle-user mr-2 text-lg"></i> Access Citizen Portal</button>
                </div>
            </div>
        </nav>

        <header id="home" class="relative bg-gradient-to-b from-blue-50 to-white pt-24 pb-48 overflow-hidden">
            <div class="absolute inset-0 z-0 pointer-events-none">
                <img src="/IMG/12.png" class="w-full h-full object-cover object-bottom" alt="Smart City Background" />
            </div>
            <div class="container mx-auto px-6 relative z-10 text-center animate-fade-up">
                <h2 class="text-4xl md:text-6xl font-extrabold text-slate-900 mb-4 tracking-tight">Welcome to <span class="text-transparent bg-clip-text bg-gradient-to-r from-blue-600 to-indigo-600">CiviCare</span></h2>
                <p class="text-xl md:text-2xl text-blue-600 font-bold mb-6">Smart Solutions for a Better City</p>
                <p class="text-slate-600 font-medium mb-3 max-w-2xl mx-auto md:text-lg leading-relaxed">
                    Report Issues. Track Progress. Improve Infrastructure. <br />
                    A transparent AI-driven system connecting citizens directly with the municipal corporation.
                </p>
            </div>
        </header>

        <section class="relative -mt-32 z-20 pb-12">
            <div class="container mx-auto px-6">
                <div class="grid grid-cols-1 md:grid-cols-3 gap-6 max-w-5xl mx-auto">
                    <button type="button" onclick="openModal('Citizen')" class="w-full text-left glass-card p-6 flex items-center gap-4 cursor-pointer group">
                        <div class="w-14 h-14 bg-orange-50 rounded-lg flex items-center justify-center text-orange-500 text-2xl group-hover:bg-orange-500 group-hover:text-white transition shadow-sm border border-orange-100">
                            <i class="fa-solid fa-mobile-screen-button"></i>
                        </div>
                        <div>
                            <h3 class="text-lg font-bold text-slate-800">Report an Issue</h3>
                            <p class="text-xs text-slate-500 mt-0.5">Upload photo & location</p>
                        </div>
                        <div class="ml-auto text-slate-300 group-hover:text-orange-500 transition"><i class="fa-solid fa-arrow-right text-lg"></i></div>
                    </button>

                    <button type="button" onclick="openModal('Citizen')" class="w-full text-left glass-card p-6 flex items-center gap-4 cursor-pointer group">
                        <div class="w-14 h-14 bg-blue-50 rounded-lg flex items-center justify-center text-blue-600 text-2xl group-hover:bg-blue-600 group-hover:text-white transition shadow-sm border border-blue-100">
                            <i class="fa-solid fa-magnifying-glass-location"></i>
                        </div>
                        <div>
                            <h3 class="text-lg font-bold text-slate-800">Track Complaint</h3>
                            <p class="text-xs text-slate-500 mt-0.5">Check live status</p>
                        </div>
                        <div class="ml-auto text-slate-300 group-hover:text-blue-600 transition"><i class="fa-solid fa-arrow-right text-lg"></i></div>
                    </button>

                    <button type="button" onclick="openAnalyticsModal()" class="w-full text-left glass-card p-6 flex items-center gap-4 cursor-pointer group">
                        <div class="w-14 h-14 bg-green-50 rounded-lg flex items-center justify-center text-green-600 text-2xl group-hover:bg-green-600 group-hover:text-white transition shadow-sm border border-green-100">
                            <i class="fa-solid fa-chart-simple"></i>
                        </div>
                        <div>
                            <h3 class="text-lg font-bold text-slate-800">View Analytics</h3>
                            <p class="text-xs text-slate-500 mt-0.5">City performance data</p>
                        </div>
                        <div class="ml-auto text-slate-300 group-hover:text-green-600 transition"><i class="fa-solid fa-arrow-right text-lg"></i></div>
                    </button>
                </div>
            </div>
        </section>

        <section id="how-it-works" class="py-20 bg-slate-50 border-t border-slate-200">
            <div class="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8">
                <div class="text-center mb-16">
                    <span class="bg-blue-100 text-blue-700 px-4 py-1.5 rounded-full text-xs font-extrabold uppercase tracking-widest mb-4 inline-block shadow-sm">Behind The Scenes</span>
                    <h2 class="text-3xl md:text-4xl font-extrabold text-slate-900 mt-2 mb-4">Our Tech-Driven Innovation</h2>
                    <p class="text-slate-600 max-w-2xl mx-auto font-medium">Replacing the manual grievance system with a fast, automated, and highly transparent AI-powered pipeline.</p>
                </div>
                <div class="grid grid-cols-1 md:grid-cols-3 gap-8">
                    <div class="bg-white p-8 rounded-xl border border-slate-200 shadow-sm hover:shadow-lg transition duration-300 text-center group">
                        <div class="w-16 h-16 bg-indigo-50 rounded-xl flex items-center justify-center text-indigo-600 text-3xl mx-auto mb-5 group-hover:scale-110 transition duration-300">
                            <i class="fa-solid fa-robot"></i>
                        </div>
                        <h3 class="text-xl font-bold text-slate-800 mb-2">AI Verification</h3>
                        <p class="text-sm text-slate-500 leading-relaxed font-medium">Our AI model instantly scans uploaded photos to verify the legitimacy of the issue before registering it.</p>
                    </div>
                    <div class="bg-white p-8 rounded-xl border border-slate-200 shadow-sm hover:shadow-lg transition duration-300 text-center group">
                        <div class="w-16 h-16 bg-blue-50 rounded-xl flex items-center justify-center text-blue-600 text-3xl mx-auto mb-5 group-hover:scale-110 transition duration-300">
                            <i class="fa-solid fa-network-wired"></i>
                        </div>
                        <h3 class="text-xl font-bold text-slate-800 mb-2">Smart Auto-Routing</h3>
                        <p class="text-sm text-slate-500 leading-relaxed font-medium">Issues are automatically categorized based on AI visual data and sent directly to the relevant officer's dashboard.</p>
                    </div>
                    <div class="bg-white p-8 rounded-xl border border-slate-200 shadow-sm hover:shadow-lg transition duration-300 text-center group">
                        <div class="w-16 h-16 bg-green-50 rounded-xl flex items-center justify-center text-green-600 text-3xl mx-auto mb-5 group-hover:scale-110 transition duration-300">
                            <i class="fa-solid fa-satellite-dish"></i>
                        </div>
                        <h3 class="text-xl font-bold text-slate-800 mb-2">Live Tracking</h3>
                        <p class="text-sm text-slate-500 leading-relaxed font-medium">Citizens get exact GPS mapping and step-by-step live status updates from 'Reported' to 'Resolved'.</p>
                    </div>
                </div>
            </div>
        </section>

        <section id="citizen-guide" class="py-20 bg-white border-t border-slate-200">
            <div class="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8">
                <div class="text-center mb-16">
                    <span class="bg-teal-100 text-teal-700 px-4 py-1.5 rounded-full text-xs font-extrabold uppercase tracking-widest mb-4 inline-block shadow-sm">Citizen Guide</span>
                    <h2 class="text-3xl md:text-4xl font-extrabold text-slate-900 mt-2 mb-4">How to Report an Issue?</h2>
                    <p class="text-slate-600 max-w-2xl mx-auto font-medium">Solving your city's problems is now easier than ever. Just follow these 4 simple steps.</p>
                </div>

                <div class="grid grid-cols-1 sm:grid-cols-2 lg:grid-cols-4 gap-8 relative z-10">
                    <div class="relative text-center step-connector">
                        <div class="w-16 h-16 mx-auto bg-white border-4 border-slate-100 rounded-full flex items-center justify-center shadow-lg relative z-10 mb-5">
                            <i class="fa-solid fa-user-plus text-2xl text-blue-600"></i>
                        </div>
                        <h3 class="text-lg font-bold text-slate-800 mb-2">1. Secure Login</h3>
                        <p class="text-sm text-slate-500 font-medium px-2">Create a free account using your Email (with OTP) or Google Login.</p>
                    </div>

                    <div class="relative text-center step-connector">
                        <div class="w-16 h-16 mx-auto bg-white border-4 border-slate-100 rounded-full flex items-center justify-center shadow-lg relative z-10 mb-5">
                            <i class="fa-solid fa-camera-retro text-2xl text-orange-500"></i>
                        </div>
                        <h3 class="text-lg font-bold text-slate-800 mb-2">2. Snap & Locate</h3>
                        <p class="text-sm text-slate-500 font-medium px-2">Capture a live photo of the civic issue. Our app auto-fetches your GPS location.</p>
                    </div>

                    <div class="relative text-center step-connector">
                        <div class="w-16 h-16 mx-auto bg-white border-4 border-slate-100 rounded-full flex items-center justify-center shadow-lg relative z-10 mb-5">
                            <i class="fa-solid fa-microchip text-2xl text-indigo-600"></i>
                        </div>
                        <h3 class="text-lg font-bold text-slate-800 mb-2">3. Auto AI Routing</h3>
                        <p class="text-sm text-slate-500 font-medium px-2">Our AI verifies the photo and instantly sends it to the correct department.</p>
                    </div>

                    <div class="relative text-center">
                        <div class="w-16 h-16 mx-auto bg-white border-4 border-slate-100 rounded-full flex items-center justify-center shadow-lg relative z-10 mb-5">
                            <i class="fa-solid fa-envelope-circle-check text-2xl text-green-600"></i>
                        </div>
                        <h3 class="text-lg font-bold text-slate-800 mb-2">4. Track & Resolve</h3>
                        <p class="text-sm text-slate-500 font-medium px-2">Get live Email notifications as the field team works to resolve your issue.</p>
                    </div>
                </div>
                
                <div class="text-center mt-12">
                    <button type="button" onclick="openModal('Citizen')" class="bg-slate-900 hover:bg-slate-800 text-white px-8 py-3.5 rounded-full text-sm font-bold shadow-lg transition transform hover:-translate-y-1">
                        Start Reporting Now <i class="fa-solid fa-arrow-right ml-2"></i>
                    </button>
                </div>
            </div>
        </section>

        <section id="departments" class="py-24 bg-slate-50 border-t border-slate-200">
            <div class="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8">
                <div class="grid lg:grid-cols-2 gap-16 items-center">
                    <div>
                        <span class="text-blue-600 font-bold uppercase text-sm tracking-wider">Integrated Departments</span>
                        <h2 class="text-4xl font-extrabold text-slate-900 mt-3 mb-6 leading-tight">Centralized Urban Maintenance.</h2>
                        <p class="text-slate-600 mb-10 text-base leading-relaxed">
                            CiviCare unifies the city's three most critical maintenance departments under one central digital roof for seamless coordination.
                        </p>
                        <div class="grid grid-cols-1 sm:grid-cols-2 gap-6">
                            <div class="flex items-start gap-4 p-5 rounded-xl bg-white border border-slate-200 hover:border-slate-300 transition shadow-sm">
                                <div class="w-12 h-12 bg-slate-50 rounded-lg flex items-center justify-center text-yellow-500 shadow-sm shrink-0 text-xl"><i class="fa-solid fa-bolt"></i></div>
                                <div><strong class="text-slate-800 text-base block mb-1">Electricity</strong><span class="text-xs text-slate-500 font-medium">Street lights, wires & transformers</span></div>
                            </div>
                            <div class="flex items-start gap-4 p-5 rounded-xl bg-white border border-slate-200 hover:border-slate-300 transition shadow-sm">
                                <div class="w-12 h-12 bg-slate-50 rounded-lg flex items-center justify-center text-blue-500 shadow-sm shrink-0 text-xl"><i class="fa-solid fa-faucet-drip"></i></div>
                                <div><strong class="text-slate-800 text-base block mb-1">Water Supply</strong><span class="text-xs text-slate-500 font-medium">Pipeline leakage & drainage</span></div>
                            </div>
                            <div class="flex items-start gap-4 p-5 rounded-xl bg-white border border-slate-200 hover:border-slate-300 transition shadow-sm">
                                <div class="w-12 h-12 bg-slate-50 rounded-lg flex items-center justify-center text-green-600 shadow-sm shrink-0 text-xl"><i class="fa-solid fa-trash-can"></i></div>
                                <div><strong class="text-slate-800 text-base block mb-1">Sanitation</strong><span class="text-xs text-slate-500 font-medium">Garbage collection & hygiene</span></div>
                            </div>
                        </div>
                    </div>
                    <div class="collage-grid">
                        <img src="/IMG/powerrcut.jpg" class="collage-img shadow-sm" alt="Electric" />
                        <img src="/IMG/water.jpg" class="collage-img shadow-sm" alt="Water" />
                        <img src="/IMG/Garbage.jpg" class="collage-img shadow-sm" alt="Garbage" />
                        <img src="/IMG/wt.jpg" class="collage-img shadow-sm" alt="Waste" />
                    </div>
                </div>
            </div>
        </section>

        <footer class="bg-slate-900 text-slate-300 pt-16 pb-8 border-t border-slate-800">
            <div class="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8">
                <div class="grid grid-cols-1 md:grid-cols-4 gap-12 mb-12">
                    <div class="md:col-span-2">
                        <div class="flex items-center gap-3 font-bold text-white text-2xl tracking-tight mb-4">
                            <div class="w-10 h-10 bg-blue-600 rounded-xl flex items-center justify-center text-white text-xl shadow-lg shadow-blue-600/30">
                                <i class="fa-solid fa-city"></i>
                            </div>
                            कार्यालय पत्ता
                        </div>
                        <p class="text-slate-400 text-sm leading-relaxed max-w-sm">
                           छत्रपती शिवाजी महाराज प्रशासकीय इमारत, नागपूर महानगरपालिका, <br/>  महानगर पालिका मार्ग, सिव्हिल लाईन्स,<br /> नागपूर, महाराष्ट्र, भारत, ४४० ००१
                        </p>
                    </div>
                    
                    <div>
                        <h4 class="text-white font-bold mb-4 uppercase text-sm tracking-wider">Quick Links</h4>
                        <ul class="space-y-2 text-sm">
                            <li><a href="#home" class="hover:text-blue-400 transition">Home</a></li>
                            <li><a href="#how-it-works" class="hover:text-blue-400 transition">How it Works</a></li>
                            <li><a href="#citizen-guide" class="hover:text-blue-400 transition">Citizen Guide</a></li>
                            <li><a href="#departments" class="hover:text-blue-400 transition">Departments</a></li>
                        </ul>
                    </div>

                    <div>
                        <h4 class="text-white font-bold mb-4 uppercase text-sm tracking-wider">Support</h4>
                        <ul class="space-y-2 text-sm">
                            <li class="flex items-center gap-2"><i class="fa-solid fa-phone text-slate-500 w-4"></i> ०७१२ २५६१५८४</li>
                            <li class="flex items-center gap-2"><i class="fa-solid fa-envelope text-slate-500 w-4"></i>mconagpur@gov.in</li>
                            <li class="flex items-center gap-3 mt-4 pt-4 border-t border-slate-800">
                                <a href="https://x.com/ngpnmc" class="w-8 h-8 rounded-full bg-slate-800 flex items-center justify-center hover:bg-blue-600 hover:text-white transition"><i class="fa-brands fa-twitter"></i></a>
                                <a href="https://www.facebook.com/nmcngp/" class="w-8 h-8 rounded-full bg-slate-800 flex items-center justify-center hover:bg-blue-600 hover:text-white transition"><i class="fa-brands fa-facebook-f"></i></a>
                                <a href="https://www.instagram.com/nmcngp/?igshid=YmMyMTA2M2Y%3D" class="w-8 h-8 rounded-full bg-slate-800 flex items-center justify-center hover:bg-blue-600 hover:text-white transition"><i class="fa-brands fa-instagram"></i></a>
                            </li>
                        </ul>
                    </div>
                </div>
                
                <div class="border-t border-slate-800 pt-8 flex flex-col md:flex-row justify-between items-center gap-4 text-xs font-medium">
                    <div class="text-slate-500">&copy; 2026 Smart City Initiative. All rights reserved.</div>
                    <div class="flex gap-6">
                        <a href="#" class="hover:text-white transition">Privacy Policy</a>
                        <a href="#" class="hover:text-white transition">Terms of Service</a>
                    </div>
                </div>
            </div>
        </footer>

        <div id="authModal" class="fixed inset-0 z-50 hidden items-center justify-center bg-slate-900/60 backdrop-blur-sm transition-opacity duration-300 px-4 py-6">
            <div class="bg-white rounded-2xl shadow-2xl border border-slate-200 p-8 w-full max-w-md relative modal-pop max-h-full overflow-y-auto no-scrollbar">
                
                <button type="button" onclick="closeModal('authModal')" class="absolute top-4 right-4 w-8 h-8 flex items-center justify-center rounded-full bg-slate-100 hover:bg-red-100 hover:text-red-600 text-slate-500 transition">
                    <i class="fa-solid fa-xmark"></i>
                </button>

                <div class="text-center mb-6">
                    <div id="modalIconContainer" class="inline-flex items-center justify-center w-14 h-14 bg-blue-50 rounded-xl text-blue-600 text-2xl mb-3 shadow-sm border border-blue-100">
                        <i id="modalIcon" class="fa-solid fa-user"></i>
                    </div>
                    <h2 id="modalTitle" class="text-2xl font-extrabold text-slate-900 tracking-tight">Login</h2>
                </div>

                <asp:HiddenField ID="hfRole" runat="server" />

                <asp:UpdatePanel runat="server" UpdateMode="Conditional" ChildrenAsTriggers="true" ID="upAuth">
                    <ContentTemplate>
                        
                        <div id="loginView">
                            <div class="space-y-4">
                                <div>
                                    <label class="block text-xs font-bold text-slate-700 mb-1 uppercase tracking-wide">Email / Mobile</label>
                                    <div class="relative">
                                        <i class="fa-solid fa-envelope input-icon"></i>
                                        <asp:TextBox ID="txtLoginId" runat="server" CssClass="input-field" ValidationGroup="Login"></asp:TextBox>
                                    </div>
                                </div>
                                <div>
                                    <div class="flex justify-between items-center mb-1">
                                        <label class="block text-xs font-bold text-slate-700 uppercase tracking-wide">Password</label>
                                        <a href="#" class="text-xs font-bold text-blue-600 hover:underline">Forgot?</a>
                                    </div>
                                    <div class="relative">
                                        <i class="fa-solid fa-lock input-icon"></i>
                                        <asp:TextBox ID="txtLoginPass" runat="server" TextMode="Password" CssClass="input-field" ValidationGroup="Login"></asp:TextBox>
                                        <i class="fa-solid fa-eye-slash eye-icon" onclick="togglePasswordVisibility('<%= txtLoginPass.ClientID %>', this)"></i>
                                    </div>
                                </div>
                                <div class="pt-2">
                                    <asp:Button ID="btnLogin" runat="server" Text="Log In Securely" OnClick="btnLogin_Click" ValidationGroup="Login" UseSubmitBehavior="false"
                                        CssClass="w-full bg-blue-600 hover:bg-blue-700 text-white font-bold py-3 rounded-lg shadow-md transition text-sm cursor-pointer hover:-translate-y-0.5" />
                                </div>
                            </div>

                            <div id="googleLoginSection" class="mt-5">
                                <div class="relative flex items-center py-2 mb-3">
                                    <div class="flex-grow border-t border-slate-200"></div>
                                    <span class="mx-3 text-slate-400 text-[10px] font-bold uppercase tracking-wider">OR</span>
                                    <div class="flex-grow border-t border-slate-200"></div>
                                </div>
                                <div id="googleBtnLogin" class="w-full flex justify-center"></div>
                            </div>

                            <div id="registerPrompt" class="mt-5 text-center border-t border-slate-100 pt-4 hidden">
                                <p class="text-xs text-slate-600 font-medium">New Citizen? <button type="button" onclick="toggleView('register'); return false;" class="text-blue-600 font-bold hover:underline ml-1">Create an account</button></p>
                            </div>
                        </div>

                        <div id="registerView" class="view-hidden">
                            <div class="space-y-3">
                                <div>
                                    <label class="block text-xs font-bold text-slate-700 mb-1 uppercase tracking-wide">Full Name</label>
                                    <div class="relative">
                                        <i class="fa-solid fa-id-card input-icon"></i>
                                        <asp:TextBox ID="txtRegName" runat="server" CssClass="input-field" ValidationGroup="Register"></asp:TextBox>
                                    </div>
                                </div>
                                <div class="grid grid-cols-1 sm:grid-cols-2 gap-3">
                                    <div>
                                        <label class="block text-xs font-bold text-slate-700 mb-1 uppercase tracking-wide">Email (For OTP)</label>
                                        <div class="relative">
                                            <i class="fa-solid fa-envelope input-icon"></i>
                                            <asp:TextBox ID="txtRegEmail" runat="server" CssClass="input-field" ValidationGroup="Register"></asp:TextBox>
                                        </div>
                                    </div>
                                    <div>
                                        <label class="block text-xs font-bold text-slate-700 mb-1 uppercase tracking-wide">Mobile</label>
                                        <div class="relative">
                                            <i class="fa-solid fa-phone input-icon"></i>
                                            <asp:TextBox ID="txtRegMobile" runat="server" MaxLength="10" CssClass="input-field" ValidationGroup="Register"></asp:TextBox>
                                        </div>
                                    </div>
                                </div>
                                <div>
                                    <label class="block text-xs font-bold text-slate-700 mb-1 uppercase tracking-wide">Create Password</label>
                                    <div class="relative">
                                        <i class="fa-solid fa-lock input-icon"></i>
                                        <asp:TextBox ID="txtRegPass" runat="server" TextMode="Password" CssClass="input-field" ValidationGroup="Register"></asp:TextBox>
                                        <i class="fa-solid fa-eye-slash eye-icon" onclick="togglePasswordVisibility('<%= txtRegPass.ClientID %>', this)"></i>
                                    </div>
                                    <p class="text-[10px] text-slate-500 mt-1.5 font-medium italic">* Minimum 6 chars, 1 Number, 1 Special Character.</p>
                                </div>
                                <div class="pt-3">
                                    <asp:Button ID="btnRegister" runat="server" Text="Send OTP to Email" OnClick="btnRegister_Click" ValidationGroup="Register" UseSubmitBehavior="false"
                                        CssClass="w-full bg-slate-900 hover:bg-slate-800 text-white font-bold py-3 rounded-lg shadow-md transition text-sm cursor-pointer hover:-translate-y-0.5" />
                                </div>
                            </div>

                            <div id="googleRegisterSection" class="mt-4">
                                <div class="relative flex items-center py-2 mb-3">
                                    <div class="flex-grow border-t border-slate-200"></div>
                                    <span class="mx-3 text-slate-400 text-[10px] font-bold uppercase tracking-wider">OR</span>
                                    <div class="flex-grow border-t border-slate-200"></div>
                                </div>
                                <div id="googleBtnRegister" class="w-full flex justify-center"></div>
                            </div>

                            <div class="mt-4 text-center border-t border-slate-100 pt-4">
                                <p class="text-xs text-slate-600 font-medium">Already registered? <button type="button" onclick="toggleView('login'); return false;" class="text-slate-900 font-bold hover:underline ml-1">Log in here</button></p>
                            </div>
                        </div>

                        <div id="otpView" class="view-hidden">
                            <div class="text-center mb-4">
                                <div class="w-16 h-16 bg-blue-50 text-blue-600 rounded-full flex items-center justify-center mx-auto mb-3 text-3xl"><i class="fa-solid fa-envelope-open-text"></i></div>
                                <h3 class="font-bold text-slate-800 text-lg">Verify Your Email</h3>
                                <p class="text-xs text-slate-500 mt-1">We've sent a 6-digit OTP to your email address.</p>
                            </div>
                            
                            <div class="space-y-4">
                                <div>
                                    <label class="block text-xs font-bold text-slate-700 mb-1 uppercase tracking-wide text-center">Enter OTP</label>
                                    <asp:TextBox ID="txtOTP" runat="server" MaxLength="6" CssClass="input-field text-center font-mono text-lg tracking-widest"></asp:TextBox>
                                </div>
                                <div class="pt-2">
                                    <asp:Button ID="btnVerifyOTP" runat="server" Text="Verify & Create Account" OnClick="btnVerifyOTP_Click" UseSubmitBehavior="false"
                                        CssClass="w-full bg-green-600 hover:bg-green-700 text-white font-bold py-3 rounded-lg shadow-md transition text-sm cursor-pointer hover:-translate-y-0.5" />
                                </div>
                                <div class="text-center pt-2">
                                    <button type="button" onclick="toggleView('register'); return false;" class="text-xs font-bold text-slate-500 hover:text-slate-800 hover:underline">Go Back</button>
                                </div>
                            </div>
                        </div>

                    </ContentTemplate>
                </asp:UpdatePanel>

            </div>
        </div>

        <div id="analyticsModal" class="fixed inset-0 z-[60] hidden items-center justify-center bg-slate-900/70 backdrop-blur-sm transition-opacity duration-300 px-4 py-6">
            <div class="bg-white rounded-2xl shadow-2xl border border-slate-200 w-full max-w-3xl relative modal-pop max-h-full overflow-y-auto no-scrollbar">
                
                <button type="button" onclick="closeModal('analyticsModal')" class="absolute top-5 right-5 w-8 h-8 flex items-center justify-center rounded-full bg-slate-100 hover:bg-red-100 hover:text-red-600 text-slate-500 transition shadow-sm">
                    <i class="fa-solid fa-xmark"></i>
                </button>

                <div class="bg-gradient-to-r from-slate-800 to-slate-900 p-8 text-center rounded-t-2xl">
                    <div class="w-14 h-14 bg-white/20 rounded-full flex items-center justify-center text-white text-2xl mx-auto mb-3 shadow-inner">
                        <i class="fa-solid fa-chart-pie"></i>
                    </div>
                    <h2 class="text-2xl font-extrabold text-white tracking-tight">City Performance Analytics</h2>
                    <p class="text-slate-300 text-sm mt-1">Live data fetched from the CiviCare civic tracking system.</p>
                </div>

                <div class="p-8">
                    <div class="grid grid-cols-1 md:grid-cols-3 gap-4 mb-8">
                        <div class="bg-slate-50 border border-slate-200 rounded-xl p-5 text-center shadow-sm">
                            <p class="text-[10px] font-bold text-slate-500 uppercase tracking-widest mb-1">Total Reported</p>
                            <h3 class="text-3xl font-extrabold text-slate-800"><asp:Literal ID="litTotalComplaints" runat="server">0</asp:Literal></h3>
                        </div>
                        <div class="bg-green-50 border border-green-100 rounded-xl p-5 text-center shadow-sm">
                            <p class="text-[10px] font-bold text-green-600 uppercase tracking-widest mb-1">Successfully Resolved</p>
                            <h3 class="text-3xl font-extrabold text-green-700"><asp:Literal ID="litResolvedComplaints" runat="server">0</asp:Literal></h3>
                        </div>
                        <div class="bg-orange-50 border border-orange-100 rounded-xl p-5 text-center shadow-sm">
                            <p class="text-[10px] font-bold text-orange-600 uppercase tracking-widest mb-1">Active / Pending</p>
                            <h3 class="text-3xl font-extrabold text-orange-700"><asp:Literal ID="litActiveComplaints" runat="server">0</asp:Literal></h3>
                        </div>
                    </div>

                    <h4 class="font-bold text-slate-700 text-sm uppercase tracking-wider mb-4 border-b border-slate-100 pb-2"><i class="fa-solid fa-building text-blue-500 mr-2"></i> Department-wise Breakdown</h4>
                    
                    <div class="grid grid-cols-1 sm:grid-cols-3 gap-6">
                        <div class="flex flex-col items-center p-4 rounded-xl border border-blue-100 bg-white shadow-sm hover:shadow-md transition">
                            <div class="w-12 h-12 rounded-full bg-blue-50 text-blue-600 flex items-center justify-center text-xl mb-3">
                                <i class="fa-solid fa-faucet-drip"></i>
                            </div>
                            <span class="text-xs font-bold text-slate-500 uppercase tracking-wider">Water Supply</span>
                            <span class="text-2xl font-extrabold text-slate-800 mt-1"><asp:Literal ID="litWaterCount" runat="server">0</asp:Literal></span>
                        </div>

                        <div class="flex flex-col items-center p-4 rounded-xl border border-yellow-100 bg-white shadow-sm hover:shadow-md transition">
                            <div class="w-12 h-12 rounded-full bg-yellow-50 text-yellow-500 flex items-center justify-center text-xl mb-3">
                                <i class="fa-solid fa-bolt"></i>
                            </div>
                            <span class="text-xs font-bold text-slate-500 uppercase tracking-wider">Electricity</span>
                            <span class="text-2xl font-extrabold text-slate-800 mt-1"><asp:Literal ID="litElectricCount" runat="server">0</asp:Literal></span>
                        </div>

                        <div class="flex flex-col items-center p-4 rounded-xl border border-green-100 bg-white shadow-sm hover:shadow-md transition">
                            <div class="w-12 h-12 rounded-full bg-green-50 text-green-600 flex items-center justify-center text-xl mb-3">
                                <i class="fa-solid fa-trash-can"></i>
                            </div>
                            <span class="text-xs font-bold text-slate-500 uppercase tracking-wider">Sanitation</span>
                            <span class="text-2xl font-extrabold text-slate-800 mt-1"><asp:Literal ID="litSanitationCount" runat="server">0</asp:Literal></span>
                        </div>
                    </div>
                    
                    <div class="mt-8 text-center">
                        <button type="button" onclick="closeModal('analyticsModal')" class="bg-slate-100 hover:bg-slate-200 text-slate-700 px-6 py-2.5 rounded-lg text-sm font-bold transition">Close Window</button>
                    </div>
                </div>

            </div>
        </div>

        <script>
            // Scroll Spy
            document.addEventListener("DOMContentLoaded", function () {
                const sections = document.querySelectorAll("header[id], section[id]");
                const navLinks = document.querySelectorAll(".nav-item");

                window.addEventListener("scroll", () => {
                    let current = "";
                    sections.forEach((section) => {
                        const sectionTop = section.offsetTop;
                        if (pageYOffset >= (sectionTop - 150)) {
                            current = section.getAttribute("id");
                        }
                    });

                    navLinks.forEach((link) => {
                        link.classList.remove("text-blue-600", "border-blue-600");
                        link.classList.add("text-slate-600", "border-transparent");
                        if (link.getAttribute("href").includes(current)) {
                            link.classList.remove("text-slate-600", "border-transparent");
                            link.classList.add("text-blue-600", "border-blue-600");
                        }
                    });
                });
            });

            // Password Toggle Logic
            function togglePasswordVisibility(inputId, iconElement) {
                var passwordInput = document.getElementById(inputId);
                if (passwordInput.type === "password") {
                    passwordInput.type = "text";
                    iconElement.classList.remove("fa-eye-slash");
                    iconElement.classList.add("fa-eye");
                } else {
                    passwordInput.type = "password";
                    iconElement.classList.remove("fa-eye");
                    iconElement.classList.add("fa-eye-slash");
                }
            }

            // 🔥 FIX: EXPLICITLY RENDER GOOGLE BUTTONS VIA JAVASCRIPT
            function renderGoogleButtons() {
                if (typeof google !== 'undefined' && google.accounts) {
                    google.accounts.id.initialize({
                        client_id: "4103357396-n5bpctsdplf6rf6dn9d4gc9mus74ttn7.apps.googleusercontent.com",
                        callback: handleGoogleLogin
                    });

                    const loginBtn = document.getElementById("googleBtnLogin");
                    if (loginBtn) {
                        google.accounts.id.renderButton(loginBtn, { theme: "outline", size: "large", width: 310, text: "continue_with" });
                    }

                    const regBtn = document.getElementById("googleBtnRegister");
                    if (regBtn) {
                        google.accounts.id.renderButton(regBtn, { theme: "outline", size: "large", width: 310, text: "signup_with" });
                    }
                }
            }

            // 🔥 FIX: Ensure Google buttons re-render after ASP.NET UpdatePanel postback
            if (typeof Sys !== 'undefined') {
                Sys.WebForms.PageRequestManager.getInstance().add_endRequest(function () {
                    renderGoogleButtons();
                });
            }

            function openModal(role) {
                const modal = document.getElementById('authModal');
                modal.classList.remove('hidden');
                modal.classList.add('flex');
                
                document.getElementById('<%= hfRole.ClientID %>').value = role;
                document.getElementById('mobileMenu').classList.add('hidden');
                toggleView('login'); // Default to login view when opening

                const title = document.getElementById('modalTitle');
                const iconContainer = document.getElementById('modalIconContainer');
                const icon = document.getElementById('modalIcon');
                const registerPrompt = document.getElementById('registerPrompt');
                const googleLoginSection = document.getElementById('googleLoginSection');
                const googleRegisterSection = document.getElementById('googleRegisterSection');

                // Reset Password fields
                document.getElementById('<%= txtLoginPass.ClientID %>').type = "password";
                document.getElementById('<%= txtRegPass.ClientID %>').type = "password";
                document.querySelectorAll('.eye-icon').forEach(el => {
                    el.classList.remove('fa-eye');
                    el.classList.add('fa-eye-slash');
                });

                if (role === 'Citizen') {
                    title.innerText = 'Citizen Portal';
                    icon.className = 'fa-solid fa-user';
                    iconContainer.className = 'inline-flex items-center justify-center w-14 h-14 bg-blue-50 rounded-xl text-blue-600 text-2xl mb-3 shadow-sm border border-blue-100';
                    registerPrompt.classList.remove('hidden'); 
                    googleLoginSection.style.display = 'block'; 
                    if(googleRegisterSection) googleRegisterSection.style.display = 'block'; 
                    
                    // Render Google buttons when modal opens
                    setTimeout(renderGoogleButtons, 100);
                } 
            }

            function openAnalyticsModal() {
                const modal = document.getElementById('analyticsModal');
                modal.classList.remove('hidden');
                modal.classList.add('flex');
            }

            function closeModal(modalId) {
                const modal = document.getElementById(modalId);
                if (modal) {
                    modal.classList.add('hidden');
                    modal.classList.remove('flex');
                }
            }

            function toggleView(view) {
                const loginView = document.getElementById('loginView');
                const registerView = document.getElementById('registerView');
                const otpView = document.getElementById('otpView');
                const title = document.getElementById('modalTitle');

                loginView.classList.add('view-hidden');
                registerView.classList.add('view-hidden');
                otpView.classList.add('view-hidden');

                if (view === 'register') {
                    registerView.classList.remove('view-hidden');
                    title.innerText = 'Create Account';
                    setTimeout(renderGoogleButtons, 50); // Re-render when switching views
                } else if (view === 'otp') {
                    otpView.classList.remove('view-hidden');
                    title.innerText = 'Verification';
                } else {
                    loginView.classList.remove('view-hidden');
                    const role = document.getElementById('<%= hfRole.ClientID %>').value;
                    title.innerText = role + ' Portal';
                    setTimeout(renderGoogleButtons, 50); // Re-render when switching views
                }
            }

            // Google Login Callback
            function handleGoogleLogin(response) {
                document.getElementById('<%= hfGoogleToken.ClientID %>').value = response.credential;
                document.getElementById('<%= btnGoogleSubmit.ClientID %>').click();
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