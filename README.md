# 🏥 KioskCare Desktop Check-In App

## Project Overview
KioskCare Desktop Check-In App is designed to streamline and secure patient check-ins at hospital front desks. Traditional check-in processes are slow, error-prone, and can compromise patient privacy. This application leverages touchscreen kiosks, real-time WebSocket communication, and AI-powered features to accelerate identity verification, improve workflow efficiency, and enhance patient experience.

## Key Features
- **Patient Check-In:** Quickly verify patient identity at the front desk using kiosk devices.
- **Real-Time Updates:** Updates from kiosks are pushed to the desktop app in real-time using WebSockets.
- **Appointment Management:** View, filter, and update appointment statuses.
- **AI Integration:** Ask natural language questions about appointments and patients.
- **Notifications:** Receive dynamic notifications about appointment status changes.
- **Multi-Kiosk Management:** Start verification processes across multiple kiosks simultaneously.
- **Secure Communication:** All communication with kiosks and the backend is securely handled.

## Architecture / Project Structure
KioskCare is built using Delphi 11, following a modular architecture for easy maintenance and integration:

**Forms / UI Units:**
- `MainFormUnit`: Main dashboard with toolbar for modules.
- `CheckInFormUnit`: Displays appointments by status, DateTime filter, and kiosk panel.
- `StartVerificationFormUnit`: Handles kiosk selection and verification initiation.
- `NotificationFormUnit`: Shows real-time notifications.
- `AIChatFormUnit`: Chat interface for AI-powered queries.

**Data / Model Units:**
- `PatientUnit`: Defines `TPatient` class.
- `DoctorUnit`: Defines `TDoctor` class.
- `AppointmentUnit`: Defines `TAppointment` class.
- `AppointmentTabUnit`: Handles tabbed appointment views and grids.

**API / Communication Units:**
- `AppointmentsAPIUnit`: Handles REST API CRUD operations with the backend.
- `WebSocketClientUnit`: Manages WebSocket communication.
- `EventManagerUnit`: Handles events such as verification completion and table updates.

**Utilities:**
- `AppointmentsUtils`: Helper functions for appointment status conversion and validation.
- `ValidationUtils`: Email and phone number validation functions.

## Screenshots / Demo
![Main Dashboard](screenshots/main_dashboard.png)
![Check-In Form](screenshots/checkin_form.png)
![Start Verification](screenshots/start_verification.png)
![Notification Example](screenshots/notification.png)

## Installation / Setup
1. Clone the repository:
```bash
git clone https://github.com/yourusername/kioskcare-desktop.git
```
2. Open the Delphi project file `KioskCare.dproj` using Delphi 11.
3. Ensure required packages are installed:
   - `sgcWebSocket`
   - `DBGridEh`
4. Ensure your **database** (PostgreSQL) is running.
5. Set up `config.ini` with API endpoint and key:
   ```ini
   [API]
   BaseURL=http://localhost:5000
   APIKey=YOUR_API_KEY
   ```
6. Compile and run `KioskCare`.

**Important:** Before running the desktop app, ensure all backend services are active:
- Database server
- WebSocket Server (Node.js)
- RESTful API (.NET Core)
- AI Natural Language Service
- Kiosk Client App (React.js)

## Usage / How it Works
1. Open the **Main Dashboard** to view today's appointments.
2. Click **Check-In** to open the Check-In form.
3. Select a patient appointment and start verification using available kiosks.
4. Monitor real-time notifications and updates.
5. Use the AI Chat to ask queries like:
```text
"Show me all confirmed appointments for Dr. Smith today"
```

## Technical Details / Implementation Highlights
- **Object-Oriented Delphi:** `TPatient`, `TDoctor`, `TAppointment` classes with constructors, destructors, and validation.
- **Memory Safety:** Proper use of `FreeAndNil` and exception handling in API and UI units.
- **Singleton Pattern:** Used for `TEventManager` and `TNotificationForm` for global event handling.
- **REST API Integration:** `TAppointmentsAPI` handles HTTP requests using `THTTPClient`.
- **WebSocket Communication:** Real-time updates via `sgcWebSocket` library.
- **Advanced Grids:** `DBGridEh` used for displaying appointment lists with sorting and search.
- **AI Queries:** AI chat converts natural language queries into SQL or API calls.

## Dependencies
- [sgcWebSocket](https://www.skbkontur.ru/sgcwebsocket) – WebSocket communication.
- [DBGridEh](https://github.com/TwoSummers/DBGridEh) – Advanced grid component for Delphi.
- Delphi 11 IDE.

## Future Improvements
- Add multi-language support.
- Integrate facial recognition for faster verification.
- Expand AI capabilities for predictive appointment management.
- Include offline mode with local caching for kiosk operations.
- Implement logging and analytics dashboard for administrative staff.
- Improve accessibility features for better patient experience.

---

