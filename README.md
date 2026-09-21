# TravelMate Pro

TravelMate Pro is a responsive travel planning web application designed to help users organize trips, track spending, manage checklists, and monitor travel progress in one place. The project combines a polished frontend dashboard with local browser persistence and a MySQL-ready database schema for future backend integration.

## Overview

This project is built for travelers who want a clear, modern dashboard to:

- Manage trip plans and itineraries
- Track travel budgets and actual expenses
- Maintain packing and preparation checklists
- View trip summaries and report metrics
- Switch between light and dark themes
- Keep personal travel information organized in one app

The application is implemented as a static web app using HTML, CSS, and vanilla JavaScript, with data stored in browser `localStorage` to simulate a working client-side experience.

## Project Goals

- Provide a simple but professional travel planning experience
- Keep the interface mobile-friendly and modern
- Support multi-page navigation across core travel features
- Offer a clear data model for future backend/database expansion
- Prepare a solid MySQL schema for production-ready data storage

## Tech Stack

### Frontend

- HTML5
- CSS3
- Vanilla JavaScript (ES6+)
- Responsive UI design

### Data Layer

- Browser localStorage for demo persistence
- MySQL schema included for relational database modeling

### Design System

- Travel-themed modern interface
- Dashboard cards and metric widgets
- Light/dark mode support
- Consistent color palette and reusable styling

## Features

### Authentication

- User registration
- User login
- Logout flow
- Form validation
- Persistent session state

### Trip Management

- Create trip
- Edit trip
- Delete trip
- Search trips
- View trip details and trip status
- Trip metadata including destination, dates, hotel, transportation, budget, and notes

### Expense Tracking

- Add expenses to a trip
- Edit and delete expenses
- Track budget usage against trip budget
- Categorize expenses
- View spending summaries

### Checklist Management

- Add checklist items
- Mark completed/incomplete
- Delete checklist entries

### Reports & Analytics

- Total trip count
- Total expenses
- Monthly spending summary
- Most visited destination
- Budget utilization tracking

### Theme Support

- Light mode and dark mode toggle
- Consistent global theme variables

## Project Structure

```text
Smart Travel Planner/
├── index.html
├── README.md
├── SmartTravelPlanner/
│   ├── index.html
│   ├── css/
│   │   ├── auth.css
│   │   ├── dashboard.css
│   │   ├── expenses.css
│   │   ├── reports.css
│   │   ├── style.css
│   │   └── trips.css
│   ├── js/
│   │   ├── app.js
│   │   ├── auth.js
│   │   ├── checklist.js
│   │   ├── dashboard.js
│   │   ├── expenses.js
│   │   ├── reports.js
│   │   └── trips.js
│   ├── pages/
│   │   ├── checklist.html
│   │   ├── dashboard.html
│   │   ├── expenses.html
│   │   ├── login.html
│   │   ├── profile.html
│   │   ├── register.html
│   │   ├── reports.html
│   │   └── trips.html
│   └── sql/
│       └── smart_travel_planner.sql
└── .github/
    └── instructions/
```

## Main Application Flow

1. User opens the landing page or login screen.
2. User logs in or registers an account.
3. Dashboard loads travel overview and summary cards.
4. User creates and manages trips.
5. User adds expenses associated with each trip.
6. User updates checklist items.
7. Reports calculate trip and spending activity.
8. Theme settings and session data are maintained in the browser.

## Color Theme

The central color system is defined in:

- `SmartTravelPlanner/css/style.css`

Key theme variables include:

- Primary: `#3498db`
- Secondary: `#2ecc71`
- Accent: `#f39c12`
- Background: `#f5f7fa`
- Text: `#2c3e50`

Dark mode overrides are also included in the same stylesheet to provide a modern theme toggle experience.

## Database Design

The project includes a MySQL schema file at:

- `SmartTravelPlanner/sql/smart_travel_planner.sql`

This schema defines core tables such as:

- `users`
- `destinations`
- `trips`
- `expenses`
- `checklist`
- `reports`

It also includes:

- Primary keys and foreign keys
- Constraints for valid dates and budgets
- Indexes for efficient querying
- Views for budget summaries and monthly reports
- Stored procedures for dashboard data and trip creation
- Triggers for checklist timestamps and expense validation

## Local Setup

### Option 1: Open directly in a browser

1. Navigate to the project root.
2. Open `index.html` in a browser, or open the app from the redirect page.
3. The app will start with demo data stored in browser storage.

### Option 2: Run via a local web server

From the project root, run:

```bash
python -m http.server 8000
```

Then open:

```text
http://localhost:8000/
```

This is useful if you want to avoid browser local file restrictions.

## MySQL Setup (Optional)

If you want to use the database schema:

1. Create the MySQL database.
2. Import the SQL script:

```bash
mysql -u your_user -p < SmartTravelPlanner/sql/smart_travel_planner.sql
```

3. Configure your backend/ORM connection if expanding the project beyond the frontend prototype.

## Notes on Implementation

This project is intentionally designed as a polished frontend prototype. The current JavaScript uses browser `localStorage` for persistence rather than a live backend API. That makes it easy to run locally and test UI flows quickly.

The included SQL file demonstrates the intended relational architecture for a real-world production version of the app.

## Future Enhancements

Potential improvements for the project include:

- Real backend API with Node.js or PHP
- User authentication with hashed passwords
- Database-backed trip, expense, and checklist storage
- Real-time analytics and charts
- PDF/CSV export for reports
- Admin dashboard for user and trip oversight
- RESTful endpoints and API validation

## Contributing

Contributions are welcome. If you want to extend the project:

1. Keep the UI consistent with the existing style system.
2. Follow the project’s responsive design principles.
3. Preserve accessibility and validation patterns.
4. Keep CSS organized and reusable.
5. Add a clean, readable structure for new features.

## License

This project is provided for educational and demonstration purposes. Add a license file if you plan to distribute it publicly.

## Contact / Project Identity

- Product Name: TravelMate Pro
- Type: Travel planning and budgeting dashboard
- Audience: Travelers and trip planners

---

TravelMate Pro is a practical, modern travel planner that balances usability, data tracking, and a clean design to support real-world trip organization.
