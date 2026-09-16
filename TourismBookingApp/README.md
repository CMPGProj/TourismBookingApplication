# Tourism Management and Booking System - ASP.NET Web Forms Front End

## Setup
1. Run `Database_Setup.sql` in SQL Server Management Studio (creates TourismBookingDB, all 8 tables, sample data, and every stored procedure the app calls).
2. In Visual Studio: **File > New > Project > ASP.NET Web Application (.NET Framework) > Web Forms**, name it `TourismBookingApp`.
3. Delete the default Site.Master/Home.aspx/Web.config VS generates, and copy every file from this folder into the new project (keep the `DataAccess/`, `Controls/`, `Scripts/`, `Content/` folder structure).
4. Right-click the project > Add Reference > ensure `System.Data.SqlClient` and `System.Web.UI` are referenced (included by default in Web Forms templates).
5. Update the connection string in `Web.config` to match your SQL Server instance.
6. Build the solution — Visual Studio auto-generates the `.aspx.designer.cs` partial files for each page the first time you open/save it; they're not included here to avoid stale designer references. If a page doesn't compile, open it once in the VS designer.
7. Set `Home.aspx` (or `Login.aspx`) as the start page and run (F5).

## What's wired up
- **Login.aspx** — validates against `Tourist` or `SystemUser` tables (SHA-256 hashed passwords via `PasswordHelper`).
- **MaintainAttraction.aspx / MaintainTourist.aspx** — full CRUD (grid + form), calling `usp_MaintainAttraction` / `usp_MaintainTourist`, with RequiredField/Range/RegularExpression validators.
- **MakeBooking.aspx / ManageBookings.aspx** — call `usp_MakeBooking`, `usp_ChangeBooking`, `usp_CancelBooking`, `usp_AttendBooking`.
- **Reports.aspx** — the two required reports (`usp_Report_RevenueByAttraction`, `usp_Report_BookingsByDateRange`).
- **Controls/Chatbot.ascx** — free, self-hosted rule-based help chatbot (pure client-side JS in `Scripts/chatbot.js`, no external API/cost), included on every page via `Site.Master`.
- **DataAccess/DbHelper.cs** — single reusable ADO.NET wrapper used by every page (no duplicated connection code).

## Still needed from your side (cannot be produced for you)
- Real screen prints of the running app, the SQL Server ER diagram, and the two reports, taken from your own machine after setup above.
- The signed plagiarism declaration and contribution-percentage form — needs your group members' actual names and signatures.
- The Zoom demonstration itself, and the GitHub commit history/diary entries reflecting your team's actual work sessions.
