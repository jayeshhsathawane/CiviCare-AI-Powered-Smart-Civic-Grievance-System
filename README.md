# 🏙️ CiviCare: AI-Powered Smart Civic Grievance System

![.NET](https://img.shields.io/badge/.NET-C%23-512BD4?style=for-the-badge&logo=dotnet)
![ASP.NET](https://img.shields.io/badge/ASP.NET-Web_Forms-blue?style=for-the-badge&logo=microsoft)
![SQL Server](https://img.shields.io/badge/MS_SQL-Server-red?style=for-the-badge&logo=microsoftsqlserver)
![TailwindCSS](https://img.shields.io/badge/Tailwind_CSS-38B2AC?style=for-the-badge&logo=tailwind-css)
![Gemini AI](https://img.shields.io/badge/Google_Gemini-1.5_Flash-orange?style=for-the-badge&logo=google)

CiviCare is an intelligent, end-to-end web portal designed to revolutionize smart city governance. It replaces traditional, manual grievance redressal mechanisms with a highly automated pipeline featuring strict AI-driven anti-spoofing, deterministic NLP routing, and real-time geospatial geofencing.

---

## 📜 Published Research
The methodology, architecture, and findings of this project have been published. 
**Read the full research paper here:** [![DOI](https://img.shields.io/badge/DOI-10.22214%2Fijraset.2026.79108-blue)](https://doi.org/10.22214/ijraset.2026.79108)

---

## ✨ Key Features

* **🛡️ AI Anti-Spoofing Gatekeeper:** Integrates Google Gemini 1.5 Flash to automatically detect and reject invalid images (selfies, indoor photos, screens) before they reach municipal servers.
* **🧠 Heuristic NLP Smart Routing:** A natively built C# Natural Language Processing module that analyzes citizen descriptions (English & Hinglish) to instantly route complaints to the correct department (Water, Electricity, Sanitation).
* **📸 Cryptographic Watermarking:** Utilizes GDI+ (`System.Drawing`) to permanently stamp live GPS coordinates and timestamps onto uploaded photos, ensuring tamper-proof evidence.
* **🚑 Geospatial Priority Escalation:** Queries the OpenStreetMap Overpass API to detect if a reported hazard is within 200 meters of critical infrastructure (schools, hospitals) and automatically escalates its priority to 'High'.
* **📧 Dual-Asynchronous Email Dispatcher:** Automated SMTP engine sends live tracking updates to citizens and Google Maps navigation links to field workers.
* **📊 Public Analytics Dashboard:** A transparent, live-updating dashboard showing city-wide performance metrics and resolved complaint counts.

---

## 🛠️ Technology Stack

* **Frontend:** HTML5, Tailwind CSS, JavaScript (ES6+), HTML5 Geolocation API
* **Backend:** ASP.NET (Web Forms), C# (.NET Framework), ADO.NET
* **Database:** Microsoft SQL Server
* **External APIs:** * Google Gemini Pro Vision API (AI Gatekeeper)
  * OpenStreetMap Nominatim API (Reverse Geocoding)
  * Overpass API (Geospatial Proximity)
  * Google OAuth 2.0 (SSO)

---

## 🚀 Installation & Setup

### Prerequisites
* Visual Studio 2022 (or later) with ASP.NET web development workload.
* Microsoft SQL Server Management Studio (SSMS).
* A valid Google Gemini API Key.
* A Gmail account with an "App Password" generated for the SMTP engine.

### Database Configuration
1. Open SSMS and execute the SQL scripts provided in the `/Database` folder to generate the `tbl_Users`, `tbl_Complaints`, and `tbl_OTP` tables.

### Application Setup
1. Clone the repository:
   ```bash
   git clone [https://github.com/jayeshhsathawane/CiviCare.git](https://github.com/jayeshhsathawane/CiviCare: AI-Powered Smart Civic Grievance System.git)
