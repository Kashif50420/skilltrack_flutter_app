// lib/services/auth_service.dart

import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:silk_track/services/api_service.dart';

class AuthService {
  static final FlutterSecureStorage _secureStorage = FlutterSecureStorage();
  static final AuthService _instance = AuthService._internal();
  factory AuthService() => _instance;
  AuthService._internal();

  static const String _tokenKey = 'auth_token';
  static const String _userRoleKey = 'user_role';
  static const String _userIdKey = 'user_id';
  static const String _userEmailKey = 'user_email';
  static const String _userNameKey = 'user_name';

  // Current user info
  String? _currentToken;
  String? _currentRole;
  String? _currentUserId;
  String? _currentUserEmail;
  String? _currentUserName;

  // Initialize from storage
  Future<void> initialize() async {
    _currentToken = await _secureStorage.read(key: _tokenKey);
    final prefs = await SharedPreferences.getInstance();
    _currentRole = prefs.getString(_userRoleKey);
    _currentUserId = prefs.getString(_userIdKey);
    _currentUserEmail = prefs.getString(_userEmailKey);
    _currentUserName = prefs.getString(_userNameKey);

    if (_currentToken != null) {
      ApiService.authToken = _currentToken;
    }
  }

  // ============ LOGIN ============
  Future<Map<String, dynamic>> login(String email, String password, {bool isAdminLogin = false}) async {
    try {
      // Trim and normalize inputs
      final normalizedEmail = email.trim();
      final normalizedPassword = password.trim();
      
      if (normalizedEmail.isEmpty || normalizedPassword.isEmpty) {
        return {
          'success': false,
          'message': 'Please enter both email and password',
        };
      }
      
      final response = await ApiService.login(normalizedEmail, normalizedPassword, isAdminLogin: isAdminLogin);

      // Extract data
      final token = response['token']?.toString();
      final user = response['user'] as Map<String, dynamic>;
      final role = user['role']?.toString() ?? user['userType']?.toString() ?? 'learner';
      final userId = user['id']?.toString() ?? '';
      final userName = user['name']?.toString() ?? 'User';

      // Save to storage
      await _saveAuthData(
        token: token,
        role: role,
        userId: userId,
        userEmail: normalizedEmail,
        userName: userName,
      );

      return {
        'success': true,
        'message': 'Login successful',
        'user': user,
        'role': role,
      };
    } catch (e) {
      // Clean up error message
      String errorMessage = e.toString();
      if (errorMessage.startsWith('Exception: ')) {
        errorMessage = errorMessage.substring(11);
      }
      
      return {
        'success': false,
        'message': errorMessage,
      };
    }
  }

  // ============ SIGNUP ============
  Future<Map<String, dynamic>> signup({
    required String name,
    required String email,
    required String password,
    required String role, // 'learner' or 'admin'
  }) async {
    try {
      final response = await ApiService.signup(name, email, password, role);

      final token = response['token']?.toString();
      final user = response['user'] as Map<String, dynamic>;

      await _saveAuthData(
        token: token,
        role: role,
        userId: user['id']?.toString() ?? '',
        userEmail: email,
        userName: name,
      );

      return {
        'success': true,
        'message': 'Account created successfully',
        'user': user,
        'role': role,
      };
    } catch (e) {
      return {
        'success': false,
        'message': e.toString(),
      };
    }
  }

  // ============ SAVE AUTH DATA ============
  Future<void> _saveAuthData({
    required String? token,
    required String role,
    required String userId,
    required String userEmail,
    required String userName,
  }) async {
    // Save token securely
    if (token != null) {
      await _secureStorage.write(key: _tokenKey, value: token);
      _currentToken = token;
      ApiService.authToken = token;
    }

    // Save other data in SharedPreferences
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_userRoleKey, role);
    await prefs.setString(_userIdKey, userId);
    await prefs.setString(_userEmailKey, userEmail);
    await prefs.setString(_userNameKey, userName);

    // Update current values
    _currentRole = role;
    _currentUserId = userId;
    _currentUserEmail = userEmail;
    _currentUserName = userName;
  }

  // ============ LOGOUT ============
  Future<void> logout() async {
    // Clear secure storage
    await _secureStorage.delete(key: _tokenKey);

    // Clear shared preferences
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_userRoleKey);
    await prefs.remove(_userIdKey);
    await prefs.remove(_userEmailKey);
    await prefs.remove(_userNameKey);

    // Clear memory
    _currentToken = null;
    _currentRole = null;
    _currentUserId = null;
    _currentUserEmail = null;
    _currentUserName = null;
    ApiService.authToken = null;
  }

  // ============ CHECK AUTH STATUS ============
  bool get isLoggedIn => _currentToken != null;

  String? get token => _currentToken;
  String? get userRole => _currentRole;
  String? get userId => _currentUserId;
  String? get userEmail => _currentUserEmail;
  String? get userName => _currentUserName;

  bool get isAdmin => _currentRole == 'admin';
  bool get isLearner => _currentRole == 'learner';

  // ============ GET USER PROFILE ============
  Future<Map<String, dynamic>> getUserProfile() async {
    if (!isLoggedIn) {
      throw Exception('User not logged in');
    }
    return await ApiService.getUserProfile();
  }

  // ============ UPDATE PROFILE ============
  Future<Map<String, dynamic>> updateProfile(Map<String, dynamic> data) async {
    if (!isLoggedIn) {
      throw Exception('User not logged in');
    }

    final response = await ApiService.updateUserProfile(data);

    // Update local name if changed
    if (data.containsKey('name')) {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString(_userNameKey, data['name'].toString());
      _currentUserName = data['name'].toString();
    }

    return response;
  }
}
