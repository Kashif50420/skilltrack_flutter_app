# 📱 Skill Track – Learning & Internship Management App

A comprehensive **Flutter mobile application** designed to help learners discover, enroll in, and track skill‑based programs or internships, while allowing admins to manage programs, users, and progress efficiently.

---

## 🚀 Project Overview

**Skill Track** bridges the gap between learners and structured learning opportunities by providing a centralized platform for:

* Discovering skill‑based programs
* Enrolling in internships or courses
* Tracking learning progress
* Managing programs and users (Admin side)

This project is developed as part of an academic / internship requirement and currently works with **mock data** for demonstration.

---

## 👥 User Roles

### 👤 Learner

* Browse available programs
* Enroll in courses
* Track progress
* Edit profile
* Submit feedback

### 🛠️ Admin

* Manage programs (Add / Edit / Delete)
* View enrolled learners
* Monitor progress & analytics
* Access admin dashboard

🔐 **Admin Login (Demo Credentials)**
For evaluation and demo purposes, use the following admin credentials:

* **Email:** `admin@skilltrack.com`
* **Password:** `admin123`

> ⚠️ Note: The app currently runs in **mock mode**, so these credentials are for demonstration only.)

---

## ✨ Features

### Learner Features

* Secure login & signup with validation
* Browse 28+ programs across multiple categories
* Program enrollment with form validation
* Progress tracking
* Profile management
* Feedback & suggestions form

### Admin Features

* Admin dashboard with statistics
* Program management
* Learner management
* Analytics & reports
* App settings

---

## 🛠️ Technical Stack

* **Framework:** Flutter (3.0+)
* **Language:** Dart
* **State Management:** Provider
* **HTTP Client:** http
* **Local Storage:** shared_preferences, flutter_secure_storage
* **Architecture:** MVVM + Service Layer

---

## 📂 Project Structure

```
lib/
├── screens/
│   ├── auth/              # Login & Signup
│   ├── learner/           # Learner screens
│   ├── admin/             # Admin screens
│   └── shared/            # Common UI screens
├── models/                # Data models
├── services/              # API / mock services
├── providers/             # State management
├── data/                  # Sample JSON data
├── constants/             # App constants
└── main.dart
```

---

## 📸 Screenshots

All application screenshots are stored in the following folder:

```
skilltrack_flutter_app_screenshots/
```

---

## 🎥 Demo Video

A complete working demo video has been recorded as part of the **Excelerate Internship – Final Deliverable**.

▶️ **Demo Video Link:**
[https://youtu.be/FqRnyNcFAJw](https://youtu.be/FqRnyNcFAJw)

The video demonstrates:

* Learner login & dashboard
* Program listing & details
* Enrollment & feedback form submission
* Admin dashboard & management features

**Platform:** Excelerate Internship Program

---

## 🚀 Getting Started

### Prerequisites

* Flutter SDK (>= 3.0.0)
* Dart SDK
* Android Studio / VS Code
* Android or iOS Emulator (or physical device)

### Installation

1. Clone the repository:

```bash
git clone <repository-url>
cd skilltrack_flutter_app
```

2. Install dependencies:

```bash
flutter pub get
```

3. Run the application:

```bash
flutter run
```

---

## 📝 Recent Updates

### ✔ API Integration & Forms

* Program listing using mock API
* Program details from JSON data
* Signup & login with validation
* Enrollment form with validation
* Feedback form with success/error handling
* Profile edit for learner & admin

### ✔ Data Management

* Mock API (offline mode)
* Local caching with SharedPreferences
* 28+ sample programs across multiple categories

### ✔ UI / UX Improvements

* Navigation drawers
* Logout buttons (Admin & Learner)
* Clickable welcome messages
* Admin dashboard quick actions

---

## 📊 Program Categories

* Mobile Development
* Web Development
* Data Science
* Design
* Cloud & DevOps
* Marketing
* Business
* Security
* Backend Development
* And more...

---

## 🔐 Authentication

* Mock authentication (any email/password)
* Role‑based access (Admin / Learner)
* Session handling
* Secure local storage

---

## 👨‍💻 Author

* **Kashif Ali** – Initial development & implementation

---

## 📄 License

This project is licensed under the **MIT License**.

---

## 🙏 Acknowledgments

* Flutter Team
* Open‑source community
* Teachers & mentors

---

> **Note:** This application currently uses mock data. For production use, integrate a real backend API.
