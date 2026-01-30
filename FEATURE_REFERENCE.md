# Skill Track - Quick Feature Reference

## 🎯 App Purpose
Bridge the gap between learners and structured learning opportunities (programs & internships)

---

## 👥 User Types & Flows

### 🎓 LEARNER FLOW
**Who:** Students, Fresh Graduates, Skill Learners

**What They Can Do:**
1. ✅ **Sign Up** - Register with email & password
2. ✅ **Login** - Secure authentication
3. ✅ **Browse Programs** - See all available programs with filters
4. ✅ **View Details** - Check program info, duration, instructor, rating
5. ✅ **Enroll** - Register for programs
6. ✅ **Track Progress** - Monitor learning completion %
7. ✅ **View Profile** - See achievements and enrolled programs
8. ✅ **Manage Account** - Edit profile information

**Key Screens:**
- Splash Screen
- Login Screen
- Signup Screen
- Home Screen (Dashboard)
- Program List Screen
- Program Detail Screen
- Enrollment Form Screen
- Progress Tracking Screen
- My Programs Screen
- Profile Screen

---

### 🔧 ADMIN FLOW
**Who:** Program Managers, Internship Coordinators

**What They Can Do:**
1. ✅ **Admin Login** - Secure admin authentication
2. ✅ **Create Programs** - Add new programs/internships
3. ✅ **Edit Programs** - Update program details
4. ✅ **Delete Programs** - Remove programs
5. ✅ **View Enrollments** - See all learner enrollments
6. ✅ **Monitor Progress** - Track individual learner progress
7. ✅ **Manage Users** - View and manage learner accounts

**Key Screens:**
- Admin Home Screen (Dashboard)
- Admin Program Form Screen (Create/Edit)
- Enrollment List Screen (View Enrollments)
- User List Screen (Manage Users)
- Progress Tracking Screen

---

## 📊 Core Data Models

### User Model
```
- id: unique identifier
- name: user full name
- email: login email
- role: 'learner' or 'admin'
- profileImage: user photo
- bio, education, experience, skills
- enrolledPrograms: list of program IDs
```

### Program Model
```
- id: unique identifier
- title: program name
- description: short description
- category: program category
- duration: program length
- level: beginner/intermediate/advanced
- price: program cost
- instructor: instructor name
- totalStudents, enrolledStudents
- rating: program rating
- learningOutcomes: program goals
- modules: course modules/content
```

### Enrollment Model
```
- id: unique identifier
- programId: enrolled program
- learnerId: student ID
- status: 'active', 'completed', 'dropped'
- progress: completion percentage (0.0-1.0)
- enrolledAt: enrollment date
- completedAt: completion date
```

---

## 🔐 Authentication System
- Email-based login/signup
- Role-based access control (Learner/Admin)
- Secure token management
- Session persistence

---

## 📱 App State Management
- **Provider** package for state management
- **AppProvider** handles user, programs, enrollments
- Real-time data synchronization

---

## 🎨 UI/UX Features
- Clean, modern Material Design
- Responsive layouts
- Progress indicators
- Tab navigation
- Card-based layouts
- Intuitive forms

---

## ✅ ALL PROPOSAL REQUIREMENTS IMPLEMENTED

**Learner Features:** 100% ✅
**Admin Features:** 100% ✅
**User Journeys:** 100% ✅
**Authentication:** 100% ✅
**Data Management:** 100% ✅

---

**App Name:** Skill Track – Learning & Internship Management App
