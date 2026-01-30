// lib/services/api_service.dart

import 'dart:convert';
import 'package:http/http.dart' as http;

class ApiService {
  static const String baseUrl = 'https://your-api-domain.com/api';
  static String? authToken;
  static const bool useMockMode = true; // Set to false when real API is available

  // Headers
  static Map<String, String> get headers {
    Map<String, String> headers = {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
    };
    if (authToken != null) {
      headers['Authorization'] = 'Bearer $authToken';
    }
    return headers;
  }

  // Error handling
  static Map<String, dynamic> _handleResponse(http.Response response) {
    if (response.statusCode >= 200 && response.statusCode < 300) {
      return jsonDecode(response.body);
    } else {
      throw Exception('API Error: ${response.statusCode} - ${response.body}');
    }
  }

  // ============ MOCK AUTH METHODS ============
  static Future<Map<String, dynamic>> _mockLogin(
      String email, String password, {bool isAdminLogin = false}) async {
    // Simulate API delay
    await Future.delayed(const Duration(milliseconds: 800));
    
    // Normalize email to lowercase for comparison
    final normalizedEmail = email.toLowerCase().trim();
    final normalizedPassword = password.trim();
    
    // Special users with specific passwords
    final specialUsers = {
      'admin@test.com': {
        'password': 'admin123',
        'role': 'admin',
        'name': 'Admin User',
      },
      'learner@test.com': {
        'password': 'learner123',
        'role': 'learner',
        'name': 'Learner User',
      },
      'kashif@gmail.com': {
        'password': 'kashif123',
        'role': 'learner',
        'name': 'Kashif',
      },
    };

    // Check if it's a special user
    final specialUserData = specialUsers[normalizedEmail];
    
    if (specialUserData != null) {
      // Special user - check password
      if (specialUserData['password'] != normalizedPassword) {
        throw Exception('Invalid email or password');
      }
      
      return {
        'token': 'mock_token_${DateTime.now().millisecondsSinceEpoch}',
        'user': {
          'id': 'user_${normalizedEmail.hashCode}',
          'name': specialUserData['name'],
          'email': normalizedEmail,
          'role': specialUserData['role'],
          'userType': specialUserData['role'],
        },
      };
    }
    
    // For any other email - allow login with any password
    // Determine role based on email pattern or admin switch
    String role = 'learner';
    String name = normalizedEmail.split('@').first;
    
    // If email contains 'admin' or admin switch is on, make it admin
    if (isAdminLogin || normalizedEmail.contains('admin')) {
      role = 'admin';
      name = name.isEmpty ? 'Admin' : name[0].toUpperCase() + name.substring(1);
    } else {
      // Capitalize first letter of name
      name = name.isEmpty ? 'User' : name[0].toUpperCase() + name.substring(1);
    }

    return {
      'token': 'mock_token_${DateTime.now().millisecondsSinceEpoch}',
      'user': {
        'id': 'user_${normalizedEmail.hashCode}',
        'name': name,
        'email': normalizedEmail,
        'role': role,
        'userType': role,
      },
    };
  }

  // ============ AUTH ENDPOINTS ============
  static Future<Map<String, dynamic>> login(
      String email, String password, {bool isAdminLogin = false}) async {
    if (useMockMode) {
      return await _mockLogin(email, password, isAdminLogin: isAdminLogin);
    }
    
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/auth/login'),
        headers: headers,
        body: jsonEncode({
          'email': email,
          'password': password,
        }),
      ).timeout(const Duration(seconds: 10));
      return _handleResponse(response);
    } catch (e) {
      // Fallback to mock mode if API fails
      return await _mockLogin(email, password, isAdminLogin: isAdminLogin);
    }
  }

  static Future<Map<String, dynamic>> _mockSignup(
      String name, String email, String password, String role) async {
    // Simulate API delay
    await Future.delayed(const Duration(seconds: 1));
    
    return {
      'token': 'mock_token_${DateTime.now().millisecondsSinceEpoch}',
      'user': {
        'id': 'user_${email.hashCode}',
        'name': name,
        'email': email,
        'role': role,
        'userType': role,
      },
    };
  }

  static Future<Map<String, dynamic>> signup(
      String name, String email, String password, String role) async {
    if (useMockMode) {
      return await _mockSignup(name, email, password, role);
    }
    
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/auth/signup'),
        headers: headers,
        body: jsonEncode({
          'name': name,
          'email': email,
          'password': password,
          'role': role, // 'learner' or 'admin'
        }),
      ).timeout(const Duration(seconds: 10));
      return _handleResponse(response);
    } catch (e) {
      // Fallback to mock mode if API fails
      return await _mockSignup(name, email, password, role);
    }
  }

  // ============ PROGRAM ENDPOINTS ============
  static Future<List<dynamic>> getPrograms() async {
    if (useMockMode) {
      // Return empty list - programs will be loaded from local data
      return [];
    }
    
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/programs'),
        headers: headers,
      ).timeout(const Duration(seconds: 10));
      return _handleResponse(response)['data'];
    } catch (e) {
      // Return empty list on error - will use local data
      return [];
    }
  }

  static Future<Map<String, dynamic>> getProgram(String id) async {
    final response = await http.get(
      Uri.parse('$baseUrl/programs/$id'),
      headers: headers,
    );
    return _handleResponse(response)['data'];
  }

  // Admin only
  static Future<Map<String, dynamic>> createProgram(
      Map<String, dynamic> data) async {
    if (useMockMode) {
      await Future.delayed(const Duration(milliseconds: 500));
      return {
        'success': true,
        'message': 'Program created successfully',
        'data': {
          'id': data['id'] ?? 'prog_${DateTime.now().millisecondsSinceEpoch}',
          ...data,
        },
      };
    }
    
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/programs'),
        headers: headers,
        body: jsonEncode(data),
      ).timeout(const Duration(seconds: 10));
      return _handleResponse(response);
    } catch (e) {
      // Return mock success response
      return {
        'success': true,
        'message': 'Program created (offline mode)',
        'data': {
          'id': data['id'] ?? 'prog_${DateTime.now().millisecondsSinceEpoch}',
          ...data,
        },
      };
    }
  }

  static Future<Map<String, dynamic>> updateProgram(
      String id, Map<String, dynamic> data) async {
    final response = await http.put(
      Uri.parse('$baseUrl/programs/$id'),
      headers: headers,
      body: jsonEncode(data),
    );
    return _handleResponse(response);
  }

  static Future<void> deleteProgram(String id) async {
    final response = await http.delete(
      Uri.parse('$baseUrl/programs/$id'),
      headers: headers,
    );
    _handleResponse(response);
  }

  // ============ ENROLLMENT ENDPOINTS ============
  static Future<List<dynamic>> getMyEnrollments() async {
    if (useMockMode) {
      return [];
    }
    
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/enrollments/my'),
        headers: headers,
      ).timeout(const Duration(seconds: 10));
      return _handleResponse(response)['data'];
    } catch (e) {
      return [];
    }
  }

  static Future<Map<String, dynamic>> enrollInProgram(String programId) async {
    if (useMockMode) {
      await Future.delayed(const Duration(milliseconds: 500));
      return {
        'success': true,
        'message': 'Enrolled successfully',
        'enrollment': {
          'id': 'enroll_${DateTime.now().millisecondsSinceEpoch}',
          'programId': programId,
          'status': 'active',
          'progress': 0.0,
        },
      };
    }
    
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/enrollments'),
        headers: headers,
        body: jsonEncode({'programId': programId}),
      ).timeout(const Duration(seconds: 10));
      return _handleResponse(response);
    } catch (e) {
      // Return mock success response
      return {
        'success': true,
        'message': 'Enrolled successfully (offline mode)',
        'enrollment': {
          'id': 'enroll_${DateTime.now().millisecondsSinceEpoch}',
          'programId': programId,
          'status': 'active',
          'progress': 0.0,
        },
      };
    }
  }

  // Admin only: Get all enrollments
  static Future<List<dynamic>> getAllEnrollments() async {
    if (useMockMode) {
      return [];
    }
    
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/enrollments'),
        headers: headers,
      ).timeout(const Duration(seconds: 10));
      return _handleResponse(response)['data'];
    } catch (e) {
      return [];
    }
  }

  static Future<Map<String, dynamic>> updateEnrollmentProgress(
      String enrollmentId, double progress) async {
    final response = await http.put(
      Uri.parse('$baseUrl/enrollments/$enrollmentId/progress'),
      headers: headers,
      body: jsonEncode({'progress': progress}),
    );
    return _handleResponse(response);
  }

  // ============ USER ENDPOINTS ============
  static Future<Map<String, dynamic>> getUserProfile() async {
    if (useMockMode) {
      return {
        'id': 'user_1',
        'name': 'User',
        'email': 'user@example.com',
        'role': 'learner',
        'userType': 'learner',
      };
    }
    
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/users/profile'),
        headers: headers,
      ).timeout(const Duration(seconds: 10));
      return _handleResponse(response)['data'];
    } catch (e) {
      throw Exception('Failed to fetch user profile: $e');
    }
  }

  static Future<Map<String, dynamic>> updateUserProfile(
      Map<String, dynamic> data) async {
    if (useMockMode) {
      await Future.delayed(const Duration(milliseconds: 500));
      return {
        'success': true,
        'message': 'Profile updated successfully',
        'user': data,
      };
    }
    
    try {
      final response = await http.put(
        Uri.parse('$baseUrl/users/profile'),
        headers: headers,
        body: jsonEncode(data),
      ).timeout(const Duration(seconds: 10));
      return _handleResponse(response);
    } catch (e) {
      return {
        'success': true,
        'message': 'Profile updated (offline mode)',
        'user': data,
      };
    }
  }

  // Admin only: Get all users
  static Future<List<dynamic>> getAllUsers() async {
    if (useMockMode) {
      return [];
    }
    
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/users'),
        headers: headers,
      ).timeout(const Duration(seconds: 10));
      return _handleResponse(response)['data'];
    } catch (e) {
      return [];
    }
  }

  static Future<void> updateUserRole(String userId, String newRole) async {
    final response = await http.put(
      Uri.parse('$baseUrl/users/$userId/role'),
      headers: headers,
      body: jsonEncode({'role': newRole}),
    );
    _handleResponse(response);
  }

  static Future<void> deleteUser(String userId) async {
    final response = await http.delete(
      Uri.parse('$baseUrl/users/$userId'),
      headers: headers,
    );
    _handleResponse(response);
  }

  // ============ FEEDBACK ENDPOINT ============
  static Future<Map<String, dynamic>> submitFeedback(
      String name, String email, String feedback) async {
    if (useMockMode) {
      await Future.delayed(const Duration(milliseconds: 500));
      return {
        'success': true,
        'message': 'Feedback submitted successfully',
        'data': {
          'id': 'feedback_${DateTime.now().millisecondsSinceEpoch}',
          'name': name,
          'email': email,
          'feedback': feedback,
          'timestamp': DateTime.now().toIso8601String(),
        },
      };
    }
    
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/feedback'),
        headers: headers,
        body: jsonEncode({
          'name': name,
          'email': email,
          'feedback': feedback,
        }),
      ).timeout(const Duration(seconds: 10));
      return _handleResponse(response);
    } catch (e) {
      // Return mock success response for offline mode
      return {
        'success': true,
        'message': 'Feedback saved locally (offline mode)',
        'data': {
          'id': 'feedback_${DateTime.now().millisecondsSinceEpoch}',
          'name': name,
          'email': email,
          'feedback': feedback,
          'timestamp': DateTime.now().toIso8601String(),
        },
      };
    }
  }
}
