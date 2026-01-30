# Skill Track – Learning & Internship Management App

A comprehensive Flutter mobile application designed to help learners discover, enroll in, and track skill-based programs or internships, while allowing admins to manage programs, users, and progress efficiently.

## 📱 Features

### Learner Features
- **User Authentication**: Secure login and signup with email validation
- **Program Browsing**: Browse 28+ courses across multiple categories
- **Program Enrollment**: Easy enrollment process with form validation
- **Progress Tracking**: Track learning progress and view analytics
- **Profile Management**: Edit and update profile information
- **Feedback System**: Submit feedback and suggestions

### Admin Features
- **Admin Dashboard**: Comprehensive overview with statistics
- **Program Management**: Create, edit, view, and delete programs
- **Learner Management**: View and manage all enrolled learners
- **Analytics**: Track completion rates and learner progress
- **Settings**: Configure app settings and preferences

## 🛠️ Technical Stack

- **Framework**: Flutter 3.0+
- **State Management**: Provider
- **HTTP Client**: http package
- **Local Storage**: shared_preferences, flutter_secure_storage
- **Architecture**: MVVM pattern with service layer

## 📦 Project Structure

```
lib/
├── screens/
│   ├── auth/              # Authentication screens
│   ├── learner/           # Learner-specific screens
│   ├── admin/             # Admin-specific screens
│   └── ...                # Shared screens
├── models/                # Data models
├── services/              # API and data services
├── providers/             # State management
├── data/                  # Sample data and JSON
└── constants/             # App constants
```

## 🚀 Getting Started

### Prerequisites
- Flutter SDK (>=3.0.0)
- Dart SDK
- Android Studio / VS Code
- Android/iOS emulator or physical device

### Installation

1. Clone the repository:
```bash
git clone <repository-url>
cd silktrack_flutter_app
```

2. Install dependencies:
```bash
flutter pub get
```

3. Run the app:
```bash
flutter run
```

## 📝 Recent Updates

### Week Updates

#### API Integration & Forms
- ✅ **Program Listing**: Connected to mock API with 28+ sample programs
- ✅ **Program Details**: Real data display from JSON/sample data
- ✅ **Registration Form**: Complete signup form with validation
  - Email format validation
  - Password strength validation (min 6 characters)
  - Password confirmation matching
  - Name field validation
- ✅ **Feedback Form**: Added with full validation
  - Name validation (min 2 characters)
  - Email format validation
  - Feedback text validation (min 10 characters)
  - Success/error handling
- ✅ **Enrollment Form**: Working enrollment with validation
- ✅ **Login Form**: Email and password validation
- ✅ **Profile Edit**: Form validation for all fields

#### Data Management
- ✅ Mock API implementation for offline functionality
- ✅ Local caching with SharedPreferences
- ✅ Sample programs data (28 courses across multiple categories)
- ✅ Categories: Mobile Dev, Web Dev, Data Science, Design, Marketing, Business, etc.

#### UI/UX Improvements
- ✅ Clickable welcome messages (opens profile)
- ✅ Logout buttons on both admin and learner screens
- ✅ Navigation drawers with all working buttons
- ✅ Settings screen integration
- ✅ Quick actions on admin dashboard

#### Bug Fixes
- ✅ Fixed admin program add/edit functionality
- ✅ Fixed profile edit for both admin and learner
- ✅ Fixed enrollment form submission
- ✅ Removed duplicate/unused files
- ✅ Fixed navigation issues

## 🎯 Key Features Implementation

### Form Validation
All forms include comprehensive validation:
- **Email**: Format validation using regex
- **Password**: Minimum length validation (6+ characters)
- **Required Fields**: Non-empty validation
- **Text Length**: Minimum character requirements
- **Real-time Feedback**: Immediate validation feedback

### Mock API
- Offline-first approach with mock data
- Automatic fallback to sample programs
- Local caching for better performance
- Simulated API delays for realistic experience

### Sample Data
- 28 programs across 10+ categories
- Short courses (6-8 weeks)
- Diploma courses (10-16 weeks)
- Complete program details (instructor, price, duration, etc.)

## 📊 Program Categories

- Mobile Development
- Web Development
- Data Science
- Design
- Cloud & DevOps
- Marketing
- Business
- Security
- Backend Development
- And more...

## 🔐 Authentication

- Flexible login system (any email/password works in mock mode)
- Role-based access (Admin/Learner)
- Secure token storage
- Session management

## 📱 Screenshots

(Add screenshots of your app here)

## 🤝 Contributing

1. Fork the repository
2. Create your feature branch (`git checkout -b feature/AmazingFeature`)
3. Commit your changes (`git commit -m 'Add some AmazingFeature'`)
4. Push to the branch (`git push origin feature/AmazingFeature`)
5. Open a Pull Request

## 📄 License

This project is licensed under the MIT License.

## 👥 Authors

- Your Name - Initial work

## 🙏 Acknowledgments

- Flutter team for the amazing framework
- All contributors and testers

---

**Note**: This app currently uses mock data for demonstration purposes. In production, connect to a real backend API.
