import 'package:flutter/material.dart';

class AppConstants {
  // ============ APP INFO ============
  static const String appName = 'Skill Track';
  static const String appVersion = '1.0.0';
  static const String appDescription = 'Learn. Track. Grow.';

  // ============ API CONSTANTS ============
  static const String baseUrl = 'https://api.silktrack.com';
  static const String apiVersion = '/api/v1';
  static const int apiTimeout = 30000; // 30 seconds

  // API Endpoints
  static const String loginEndpoint = '/auth/login';
  static const String signupEndpoint = '/auth/signup';
  static const String logoutEndpoint = '/auth/logout';
  static const String refreshTokenEndpoint = '/auth/refresh';

  static const String programsEndpoint = '/programs';
  static const String enrollmentsEndpoint = '/enrollments';
  static const String usersEndpoint = '/users';
  static const String feedbackEndpoint = '/feedback';
  static const String dashboardEndpoint = '/dashboard';

  // ============ STORAGE KEYS ============
  static const String authTokenKey = 'auth_token';
  static const String refreshTokenKey = 'refresh_token';
  static const String userIdKey = 'user_id';
  static const String userEmailKey = 'user_email';
  static const String userNameKey = 'user_name';
  static const String userRoleKey = 'user_role';
  static const String isLoggedInKey = 'is_logged_in';

  static const String cachedProgramsKey = 'cached_programs';
  static const String cachedEnrollmentsKey = 'cached_enrollments';
  static const String cachedUserProfileKey = 'cached_user_profile';
  static const String lastSyncTimeKey = 'last_sync_time';

  // ============ USER ROLES ============
  static const String roleLearner = 'learner';
  static const String roleAdmin = 'admin';
  static const String roleInstructor = 'instructor';

  // ============ PROGRAM CATEGORIES ============
  static const List<String> programCategories = [
    'Mobile Development',
    'Web Development',
    'Data Science',
    'Cloud Computing',
    'DevOps',
    'Design',
    'Security',
    'Computer Science',
    'Blockchain',
    'Marketing',
    'Business',
    'Artificial Intelligence',
    'Machine Learning',
    'Internet of Things',
    'Game Development',
    'Digital Marketing',
  ];

  static final Map<String, Color> categoryColors = {
    'Mobile Development': Colors.blue,
    'Web Development': Colors.green,
    'Data Science': Colors.purple,
    'Cloud Computing': Colors.orange,
    'DevOps': Colors.red,
    'Design': Colors.pink,
    'Security': Colors.deepOrange,
    'Computer Science': Colors.indigo,
    'Blockchain': Colors.teal,
    'Marketing': Colors.cyan,
    'Business': Colors.brown,
    'Artificial Intelligence': Colors.deepPurple,
    'Machine Learning': Colors.purpleAccent,
    'Internet of Things': Colors.lightBlue,
    'Game Development': Colors.amber,
    'Digital Marketing': Colors.lightGreen,
  };

  static final Map<String, IconData> categoryIcons = {
    'Mobile Development': Icons.phone_android,
    'Web Development': Icons.code,
    'Data Science': Icons.analytics,
    'Cloud Computing': Icons.cloud,
    'DevOps': Icons.settings,
    'Design': Icons.design_services,
    'Security': Icons.security,
    'Computer Science': Icons.computer,
    'Blockchain': Icons.account_balance_wallet,
    'Marketing': Icons.trending_up,
    'Business': Icons.business,
    'Artificial Intelligence': Icons.smart_toy,
    'Machine Learning': Icons.model_training,
    'Internet of Things': Icons.sensors,
    'Game Development': Icons.videogame_asset,
    'Digital Marketing': Icons.campaign,
  };

  // ============ PROGRAM LEVELS ============
  static const List<String> programLevels = [
    'Beginner',
    'Intermediate',
    'Advanced',
    'Expert',
  ];

  // ============ DURATION OPTIONS ============
  static const List<String> durationOptions = [
    '2 Weeks',
    '4 Weeks',
    '6 Weeks',
    '8 Weeks',
    '10 Weeks',
    '12 Weeks',
    '16 Weeks',
    '24 Weeks',
  ];

  // ============ ENROLLMENT STATUS ============
  static const String enrollmentActive = 'active';
  static const String enrollmentCompleted = 'completed';
  static const String enrollmentDropped = 'dropped';
  static const String enrollmentPending = 'pending';

  static final Map<String, Color> enrollmentStatusColors = {
    'active': Colors.blue,
    'completed': Colors.green,
    'dropped': Colors.red,
    'pending': Colors.orange,
  };

  // ============ ASSET PATHS ============
  static const String logoPath = 'assets/images/logo.png';
  static const String defaultProfileImage = 'assets/images/default_profile.png';
  static const String placeholderImage = 'assets/images/placeholder.jpg';
  static const String programsJsonPath = 'assets/data/programs.json';

  // ============ FONTS ============
  static const String primaryFont = 'Roboto';
  static const String secondaryFont = 'Poppins';

  // ============ COLORS ============
  static const Color primaryColor = Color(0xFF4361EE); // Primary Blue
  static const Color secondaryColor = Color(0xFF4361EE);
  static const Color accentColor = Color(0xFF4361EE);
  static const Color backgroundColor = Color(0xFFF5F5F5);
  static const Color surfaceColor = Color(0xFFFFFFFF);
  static const Color errorColor = Color(0xFFF44336); // Error Red
  static const Color successColor = Color(0xFF4CAF50); // Success Green
  static const Color warningColor = Color(0xFFFFC107); // Warning Yellow
  static const Color infoColor = Color(0xFF4361EE);
  static const Color textPrimary = Color(0xFF212121); // Text Dark
  static const Color textSecondary = Color(0xFF757575);
  static const Color textDisabled = Color(0xFFBDBDBD);
  static const Color dividerColor = Color(0xFFE0E0E0);

  // ============ PADDING & SIZING ============
  static const double defaultPadding = 16.0;
  static const double smallPadding = 8.0;
  static const double largePadding = 24.0;
  static const double extraLargePadding = 32.0;

  static const double defaultBorderRadius = 12.0;
  static const double smallBorderRadius = 6.0;
  static const double largeBorderRadius = 20.0;

  static const double buttonHeight = 48.0;
  static const double inputFieldHeight = 56.0;
  static const double appBarHeight = 64.0;

  // ============ ANIMATION DURATIONS ============
  static const Duration shortAnimationDuration = Duration(milliseconds: 200);
  static const Duration mediumAnimationDuration = Duration(milliseconds: 300);
  static const Duration longAnimationDuration = Duration(milliseconds: 500);

  // ============ VALIDATION CONSTANTS ============
  static const int minPasswordLength = 6;
  static const int maxPasswordLength = 32;
  static const int minNameLength = 2;
  static const int maxNameLength = 50;
  static const int minFeedbackLength = 10;
  static const int maxFeedbackLength = 1000;

  // ============ PAGINATION ============
  static const int itemsPerPage = 10;
  static const int initialPage = 1;

  // ============ CACHE DURATIONS ============
  static const Duration programsCacheDuration = Duration(hours: 1);
  static const Duration userCacheDuration = Duration(minutes: 30);
  static const Duration enrollmentsCacheDuration = Duration(minutes: 15);

  // ============ LOCALIZATION ============
  static const List<String> supportedLocales = ['en', 'ur'];
  static const String defaultLocale = 'en';

  // ============ FEATURE FLAGS ============
  static const bool enableOfflineMode = true;
  static const bool enablePushNotifications = true;
  static const bool enableSocialLogin = false;
  static const bool enableDarkMode = true;
  static const bool enableBiometricAuth = false;

  // ============ URLS ============
  static const String privacyPolicyUrl = 'https://silktrack.com/privacy';
  static const String termsOfServiceUrl = 'https://silktrack.com/terms';
  static const String helpCenterUrl = 'https://help.silktrack.com';
  static const String contactEmail = 'support@silktrack.com';
  static const String websiteUrl = 'https://silktrack.com';

  // ============ SOCIAL MEDIA ============
  static const String facebookUrl = 'https://facebook.com/silktrack';
  static const String twitterUrl = 'https://twitter.com/silktrack';
  static const String linkedinUrl = 'https://linkedin.com/company/silktrack';
  static const String instagramUrl = 'https://instagram.com/silktrack';

  // ============ IN-APP MESSAGES ============
  static const String noInternetMessage =
      'No internet connection. Please check your network.';
  static const String serverErrorMessage =
      'Server error. Please try again later.';
  static const String unauthorizedMessage =
      'Session expired. Please login again.';
  static const String genericErrorMessage =
      'Something went wrong. Please try again.';
  static const String successMessage = 'Operation completed successfully.';

  // ============ TEST CREDENTIALS (FOR DEVELOPMENT ONLY) ============
  static const Map<String, String> testCredentials = {
    'learner': 'learner@test.com:password123',
    'admin': 'admin@test.com:admin123',
  };

  // ============ DEBUG SETTINGS ============
  static const bool showDebugBanner = false;
  static const bool logNetworkRequests = true;
  static const bool mockApiResponses = false;
}

// ============ ENUMS ============
enum UserRole { learner, admin, instructor }

enum ProgramStatus { active, inactive, upcoming }

enum EnrollmentStatus { active, completed, dropped, pending }

enum FilterType { category, level, duration, price }

enum SortOrder { ascending, descending }

enum ViewMode { grid, list }

// ============ EXTENSIONS ============
extension UserRoleExtension on UserRole {
  String get value {
    switch (this) {
      case UserRole.learner:
        return 'learner';
      case UserRole.admin:
        return 'admin';
      case UserRole.instructor:
        return 'instructor';
    }
  }
}

extension ProgramStatusExtension on ProgramStatus {
  String get value {
    switch (this) {
      case ProgramStatus.active:
        return 'active';
      case ProgramStatus.inactive:
        return 'inactive';
      case ProgramStatus.upcoming:
        return 'upcoming';
    }
  }
}

extension EnrollmentStatusExtension on EnrollmentStatus {
  String get value {
    switch (this) {
      case EnrollmentStatus.active:
        return 'active';
      case EnrollmentStatus.completed:
        return 'completed';
      case EnrollmentStatus.dropped:
        return 'dropped';
      case EnrollmentStatus.pending:
        return 'pending';
    }
  }

  Color get color {
    switch (this) {
      case EnrollmentStatus.active:
        return const Color(0xFF2196F3); // Blue
      case EnrollmentStatus.completed:
        return const Color(0xFF4CAF50); // Green
      case EnrollmentStatus.dropped:
        return const Color(0xFFF44336); // Red
      case EnrollmentStatus.pending:
        return const Color(0xFFFF9800); // Orange
    }
  }
}
