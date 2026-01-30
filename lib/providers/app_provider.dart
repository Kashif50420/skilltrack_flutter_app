import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import '../services/auth_service.dart';
import '../services/data_service.dart';
import '../models/program_model.dart';
import '../models/user_model.dart';
import '../data/sample_programs.dart';

class AppProvider with ChangeNotifier {
  // ============ INSTANCE & INITIALIZATION ============
  static final AppProvider _instance = AppProvider._internal();
  factory AppProvider() => _instance;
  AppProvider._internal() {
    _initialize();
  }

  final AuthService _authService = AuthService();
  // DataService instance not needed since we use static methods

  // ============ STATE VARIABLES ============
  bool _isInitialized = false;
  bool _isLoading = false;
  String? _error;

  // User Data
  User? _currentUser;
  List<Program> _programs = [];
  List<dynamic> _enrollments = []; // Changed from List<Enrollment>
  List<Program> _featuredPrograms = [];
  List<Program> _myPrograms = [];

  // ============ GETTERS ============
  bool get isInitialized => _isInitialized;
  bool get isLoading => _isLoading;
  String? get error => _error;

  User? get currentUser => _currentUser;
  List<Program> get programs => _programs;
  List<dynamic> get enrollments =>
      _enrollments; // Changed from List<Enrollment>
  List<Program> get featuredPrograms => _featuredPrograms;
  List<Program> get myPrograms => _myPrograms;

  bool get isLoggedIn => _authService.isLoggedIn;
  bool get isAdmin => _authService.isAdmin;
  bool get isLearner => _authService.isLearner;
  String? get userName => _authService.userName;
  String? get userEmail => _authService.userEmail;
  String? get userId => _authService.userId;

  // ADDED: userRole getter for main.dart
  String get userRole => _authService.isAdmin ? 'admin' : 'learner';

  // ============ INITIALIZATION ============
  Future<void> _initialize() async {
    try {
      _setLoading(true);

      // Initialize auth service
      await _authService.initialize();

      // Always initialize programs first
      _initializePrograms();

      if (_authService.isLoggedIn) {
        // Load user data if logged in
        await _loadUserData();
      } else {
        // Load only programs for guest
        await _loadPrograms();
      }

      _isInitialized = true;
      _error = null;
    } catch (e) {
      // On error, still initialize programs
      _initializePrograms();
      _error = 'Initialization failed: ${e.toString()}';
    } finally {
      _setLoading(false);
      notifyListeners();
    }
  }

  // ============ AUTH METHODS ============
  Future<Map<String, dynamic>> login(String email, String password, {bool isAdminLogin = false}) async {
    try {
      _setLoading(true);

      final result = await _authService.login(email, password, isAdminLogin: isAdminLogin);

      if (result['success'] == true) {
        await _loadUserData();
        _error = null;
      } else {
        _error = result['message'];
      }

      notifyListeners();
      return result;
    } catch (e) {
      _error = e.toString();
      notifyListeners();
      return {'success': false, 'message': e.toString()};
    } finally {
      _setLoading(false);
    }
  }

  Future<Map<String, dynamic>> signup({
    required String name,
    required String email,
    required String password,
    required String role,
  }) async {
    try {
      _setLoading(true);

      final result = await _authService.signup(
        name: name,
        email: email,
        password: password,
        role: role,
      );

      if (result['success'] == true) {
        await _loadUserData();
        _error = null;
      } else {
        _error = result['message'];
      }

      notifyListeners();
      return result;
    } catch (e) {
      _error = e.toString();
      notifyListeners();
      return {'success': false, 'message': e.toString()};
    } finally {
      _setLoading(false);
    }
  }

  Future<void> logout() async {
    try {
      _setLoading(true);
      await _authService.logout();

      // Clear provider state
      _currentUser = null;
      _enrollments = [];
      _myPrograms = [];

      // Reload programs (without user data)
      await _loadPrograms();

      _error = null;
    } catch (e) {
      _error = e.toString();
    } finally {
      _setLoading(false);
      notifyListeners();
    }
  }

  // ============ DATA LOADING METHODS ============
  Future<void> _loadUserData() async {
    try {
      // Load user profile
      _currentUser = await DataService.getUserProfile(forceRefresh: true);

      // Load programs
      await _loadPrograms();

      // Load enrollments if learner
      if (isLearner) {
        await _loadEnrollments();
        _updateMyPrograms();
      }

      _error = null;
    } catch (e) {
      _error = 'Failed to load user data: ${e.toString()}';
    }
  }

  Future<void> _loadPrograms() async {
    try {
      _programs = await DataService.getPrograms();
      // If no programs loaded, use sample programs
      if (_programs.isEmpty) {
        _programs = getSamplePrograms();
      }
      _updateFeaturedPrograms();
      _error = null;
    } catch (e) {
      // On error, use sample programs
      _programs = getSamplePrograms();
      _updateFeaturedPrograms();
      _error = null;
    }
  }

  Future<void> _loadEnrollments() async {
    try {
      if (userId != null) {
        _enrollments = await DataService.getUserEnrollments(userId!);
        _error = null;
      }
    } catch (e) {
      _error = 'Failed to load enrollments: ${e.toString()}';
    }
  }

  void _updateFeaturedPrograms() {
    if (_programs.length >= 3) {
      _featuredPrograms = _programs.take(3).toList();
    } else {
      _featuredPrograms = _programs;
    }
  }

  void _updateMyPrograms() {
    _myPrograms = _programs.where((program) {
      return _enrollments.any((enrollment) {
        final programId = enrollment is Map
            ? enrollment['programId']?.toString()
            : enrollment.programId?.toString();
        final isActive = enrollment is Map
            ? enrollment['isActive'] ?? false
            : enrollment.isActive ?? false;
        return programId == program.id && isActive == true;
      });
    }).toList();
  }

  // ============ PROGRAM METHODS ============
  Future<Program?> getProgramById(String id) async {
    try {
      return await DataService.getProgramById(id);
    } catch (e) {
      _error = 'Program not found: ${e.toString()}';
      notifyListeners();
      return null;
    }
  }

  Future<List<Program>> searchPrograms(String query) async {
    try {
      return await DataService.searchPrograms(query);
    } catch (e) {
      _error = 'Search failed: ${e.toString()}';
      return [];
    }
  }

  Future<List<Program>> getProgramsByCategory(String category) async {
    try {
      return await DataService.getProgramsByCategory(category);
    } catch (e) {
      _error = 'Failed to filter programs: ${e.toString()}';
      return [];
    }
  }

  // ============ ENROLLMENT METHODS ============
  Future<bool> isEnrolled(String programId) async {
    if (userId == null) return false;
    return await DataService.isEnrolled(programId, userId!);
  }

  Future<Map<String, dynamic>> enrollInProgram(String programId) async {
    try {
      _setLoading(true);

      final result = await DataService.enrollInProgram(programId);

      if (result['success'] == true) {
        // Refresh enrollments and my programs
        await _loadEnrollments();
        _updateMyPrograms();
        _error = null;
      } else {
        _error = result['message'];
      }

      notifyListeners();
      return result;
    } catch (e) {
      _error = e.toString();
      notifyListeners();
      return {'success': false, 'message': e.toString()};
    } finally {
      _setLoading(false);
    }
  }

  Future<void> updateEnrollmentProgress(
      String enrollmentId, double progress) async {
    try {
      // This would typically update via API
      // For now, we'll just update locally (commented out for dynamic type)
      /*
      final index = _enrollments.indexWhere((e) => e.id == enrollmentId);
      if (index != -1) {
        // enrollment.progress = progress;
        if (progress >= 1.0) {
          // enrollment.status = 'completed';
        }
        _updateMyPrograms();
        notifyListeners();
      }
      */
    } catch (e) {
      _error = 'Failed to update progress: ${e.toString()}';
      notifyListeners();
    }
  }

  // ============ USER PROFILE METHODS ============
  Future<Map<String, dynamic>> updateProfile(Map<String, dynamic> data) async {
    try {
      _setLoading(true);

      final result = await DataService.updateUserProfile(data);

      if (result['success'] == true) {
        // Update local user data
        _currentUser = result['user'];
        _error = null;
      } else {
        _error = result['message'];
      }

      notifyListeners();
      return result;
    } catch (e) {
      _error = e.toString();
      notifyListeners();
      return {'success': false, 'message': e.toString()};
    } finally {
      _setLoading(false);
    }
  }

  Future<void> refreshData() async {
    try {
      _setLoading(true);

      if (isLoggedIn) {
        await _loadUserData();
      } else {
        await _loadPrograms();
      }

      // Simulate API call delay
      await Future.delayed(const Duration(seconds: 1));
      _initializePrograms();

      _error = null;
    } catch (e) {
      _error = 'Refresh failed: ${e.toString()}';
    } finally {
      _setLoading(false);
    }
  }

  // ============ ADMIN METHODS ============
  Future<List<dynamic>> getAllUsers() async {
    try {
      return await DataService.getAllUsersAdmin();
    } catch (e) {
      _error = 'Failed to load users: ${e.toString()}';
      return [];
    }
  }

  Future<List<dynamic>> getAllEnrollments() async {
    try {
      return await DataService.getAllEnrollmentsAdmin();
    } catch (e) {
      _error = 'Failed to load enrollments: ${e.toString()}';
      return [];
    }
  }

  Future<Map<String, dynamic>> createProgram(Map<String, dynamic> data) async {
    try {
      _setLoading(true);
      final result = await DataService.createProgramAdmin(data);

      if (result['success'] == true) {
        await _loadPrograms();
        _error = null;
      } else {
        _error = result['message'];
      }

      Future.microtask(() => notifyListeners());
      return result;
    } catch (e) {
      _error = e.toString();
      Future.microtask(() => notifyListeners());
      return {'success': false, 'message': e.toString()};
    } finally {
      _setLoading(false);
    }
  }

  // ============ HELPER METHODS ============
  void _setLoading(bool loading) {
    _isLoading = loading;
    if (loading) _error = null;
    // Avoid calling notifyListeners during build phase
    Future.microtask(() => notifyListeners());
  }

  void clearError() {
    _error = null;
    Future.microtask(() => notifyListeners());
  }

  // ============ STATS & ANALYTICS ============
  Map<String, dynamic> get learnerStats {
    if (!isLearner || _enrollments.isEmpty) {
      return {
        'totalCourses': 0,
        'completedCourses': 0,
        'inProgressCourses': 0,
        'averageProgress': 0.0,
        'totalHours': 0,
      };
    }

    int completed = 0;
    int inProgress = 0;
    double totalProgress = 0.0;

    for (var enrollment in _enrollments) {
      // Check if enrollment is a Map or Enrollment object
      final isCompleted = enrollment is Map
          ? enrollment['isCompleted'] ?? false
          : enrollment.isCompleted ?? false;

      final isActive = enrollment is Map
          ? enrollment['isActive'] ?? false
          : enrollment.isActive ?? false;

      final progress = enrollment is Map
          ? (enrollment['progress'] ?? 0.0).toDouble()
          : enrollment.progress ?? 0.0;

      if (isCompleted == true) {
        completed++;
      } else if (isActive == true) {
        inProgress++;
      }
      totalProgress += progress;
    }

    return {
      'totalCourses': _enrollments.length,
      'completedCourses': completed,
      'inProgressCourses': inProgress,
      'averageProgress':
          _enrollments.isNotEmpty ? (totalProgress / _enrollments.length) : 0.0,
      'totalHours': _enrollments.length * 10, // Estimated hours
    };
  }

  void _initializePrograms() {
    // Load sample programs
    _programs = getSamplePrograms();
    notifyListeners();
  }
}
