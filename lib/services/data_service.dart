import 'dart:convert';
import 'package:flutter/services.dart' show rootBundle;
import 'package:shared_preferences/shared_preferences.dart';
import 'api_service.dart';
import '../models/program_model.dart';
import '../models/user_model.dart';
import '../models/enrollment_model.dart';
import '../data/sample_programs.dart';

class DataService {
  // ============ LOCAL STORAGE KEYS ============
  static const String _programsKey = 'cached_programs';
  static const String _enrollmentsKey = 'cached_enrollments';
  static const String _userProfileKey = 'cached_user_profile';
  static const String _lastSyncKey = 'last_sync_timestamp';

  // ============ LOAD LOCAL DATA ============
  static Future<List<Program>> loadLocalPrograms() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final cachedData = prefs.getString(_programsKey);

      if (cachedData != null && cachedData.isNotEmpty) {
        final List<dynamic> jsonList = jsonDecode(cachedData);
        if (jsonList.isNotEmpty) {
          return jsonList.map((json) => Program.fromMap(json)).toList();
        }
      }

      // Fallback: Load from sample programs
      return getSamplePrograms();
    } catch (e) {
      // Fallback: Load from sample programs
      return getSamplePrograms();
    }
  }

  static Future<List<Program>> _loadProgramsFromAssets() async {
    try {
      final String data =
          await rootBundle.loadString('assets/data/programs.json');
      final List<dynamic> jsonList = jsonDecode(data);
      return jsonList.map((json) => Program.fromMap(json)).toList();
    } catch (e) {
      return [];
    }
  }

  static Future<List<Enrollment>> loadLocalEnrollments(String userId) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final cachedData = prefs.getString(_enrollmentsKey);

      if (cachedData != null) {
        final List<dynamic> jsonList = jsonDecode(cachedData);
        final userEnrollments = jsonList
            .where((json) => json['userId'] == userId)
            .map((json) => Enrollment.fromMap(json))
            .toList();
        return userEnrollments;
      }
    } catch (e) {
      // Ignore error
    }
    return [];
  }

  static Future<User?> loadLocalUserProfile() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final cachedData = prefs.getString(_userProfileKey);

      if (cachedData != null) {
        final Map<String, dynamic> json = jsonDecode(cachedData);
        return User(
          id: json['id'] ?? '',
          name: json['name'] ?? '',
          email: json['email'] ?? '',
          userType: json['userType'] ?? json['role'] ?? 'learner',
          phone: json['phone'],
          bio: json['bio'],
          education: json['education'],
          experience: json['experience'],
          skills: json['skills'] != null ? List<String>.from(json['skills']) : null,
          profileImage: json['profileImage'],
          createdAt: json['createdAt'] != null ? DateTime.parse(json['createdAt']) : DateTime.now(),
        );
      }
    } catch (e) {
      // Ignore error
    }
    return null;
  }

  // ============ SAVE LOCAL DATA ============
  static Future<void> saveProgramsLocally(List<Program> programs) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final jsonList = programs.map((program) => program.toMap()).toList();
      await prefs.setString(_programsKey, jsonEncode(jsonList));
      await _updateLastSyncTime();
    } catch (e) {
      // Ignore storage errors
    }
  }

  static Future<void> saveEnrollmentsLocally(
      List<Enrollment> enrollments) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final jsonList =
          enrollments.map((enrollment) => enrollment.toMap()).toList();
      await prefs.setString(_enrollmentsKey, jsonEncode(jsonList));
    } catch (e) {
      // Ignore storage errors
    }
  }

  static Future<void> saveUserProfileLocally(User user) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final jsonData = {
        'name': user.name,
        'email': user.email,
        'phone': user.phone,
        'bio': user.bio,
        'education': user.education,
        'experience': user.experience,
        'skills': user.skills,
        'profileImage': user.profileImage,
      };
      await prefs.setString(_userProfileKey, jsonEncode(jsonData));
    } catch (e) {
      // Ignore storage errors
    }
  }

  static Future<void> _updateLastSyncTime() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString(_lastSyncKey, DateTime.now().toIso8601String());
    } catch (e) {
      // Ignore storage errors
    }
  }

  // ============ SYNC WITH API ============
  static Future<bool> syncData() async {
    try {
      // Sync programs
      final apiPrograms = await ApiService.getPrograms();
      final programs =
          apiPrograms.map((json) => Program.fromMap(json)).toList();
      await saveProgramsLocally(programs);

      // Sync user enrollments if logged in
      try {
        final apiEnrollments = await ApiService.getMyEnrollments();
        final enrollments =
            apiEnrollments.map((json) => Enrollment.fromMap(json)).toList();
        await saveEnrollmentsLocally(enrollments);
      } catch (e) {
        // Ignore enrollment sync error
      }

      return true;
    } catch (e) {
      return false;
    }
  }

  static Future<bool> shouldSync() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final lastSync = prefs.getString(_lastSyncKey);

      if (lastSync == null) return true;

      final lastSyncTime = DateTime.parse(lastSync);
      final now = DateTime.now();
      final difference = now.difference(lastSyncTime);

      // Sync if more than 1 hour has passed
      return difference.inHours > 1;
    } catch (e) {
      return true;
    }
  }

  // ============ PROGRAM MANAGEMENT ============
  static Future<List<Program>> getPrograms({bool forceRefresh = false}) async {
    // Check if we should sync with API
    if (forceRefresh || await shouldSync()) {
      final syncSuccess = await syncData();
      if (!syncSuccess) {
        // If sync fails, use local data or sample programs
        final localPrograms = await loadLocalPrograms();
        if (localPrograms.isEmpty) {
          return getSamplePrograms();
        }
        return localPrograms;
      }
    }

    final localPrograms = await loadLocalPrograms();
    // If no local programs, return sample programs
    if (localPrograms.isEmpty) {
      return getSamplePrograms();
    }
    return localPrograms;
  }

  static Future<Program?> getProgramById(String id) async {
    final programs = await getPrograms();
    try {
      return programs.firstWhere((program) => program.id == id);
    } catch (e) {
      return null;
    }
  }

  static Future<List<Program>> searchPrograms(String query) async {
    final programs = await getPrograms();
    if (query.isEmpty) return programs;

    final lowerQuery = query.toLowerCase();
    return programs.where((program) {
      return program.title.toLowerCase().contains(lowerQuery) ||
          program.description.toLowerCase().contains(lowerQuery) ||
          program.category.toLowerCase().contains(lowerQuery);
    }).toList();
  }

  static Future<List<Program>> getProgramsByCategory(String category) async {
    final programs = await getPrograms();
    return programs
        .where((program) =>
            program.category.toLowerCase() == category.toLowerCase())
        .toList();
  }

  // ============ ENROLLMENT MANAGEMENT ============
  static Future<List<Enrollment>> getUserEnrollments(String userId) async {
    // Try API first
    try {
      final apiEnrollments = await ApiService.getMyEnrollments();
      final enrollments =
          apiEnrollments.map((json) => Enrollment.fromMap(json)).toList();
      await saveEnrollmentsLocally(enrollments);
      return enrollments;
    } catch (e) {
      // Fallback to local data
      return await loadLocalEnrollments(userId);
    }
  }

  static Future<Enrollment?> getEnrollment(
      String programId, String userId) async {
    final enrollments = await getUserEnrollments(userId);
    try {
      return enrollments.firstWhere(
        (enrollment) => enrollment.programId == programId,
      );
    } catch (e) {
      return null;
    }
  }

  static Future<bool> isEnrolled(String programId, String userId) async {
    final enrollment = await getEnrollment(programId, userId);
    return enrollment != null && (enrollment.isActive == true);
  }

  static Future<Map<String, dynamic>> enrollInProgram(String programId) async {
    try {
      final response = await ApiService.enrollInProgram(programId);

      // Update local cache
      final enrollment = Enrollment.fromMap(response['data']);
      final currentEnrollments =
          await loadLocalEnrollments(enrollment.userId ?? '');
      currentEnrollments.add(enrollment);
      await saveEnrollmentsLocally(currentEnrollments);

      return {
        'success': true,
        'message': 'Successfully enrolled in program',
        'enrollment': enrollment,
      };
    } catch (e) {
      return {
        'success': false,
        'message': 'Failed to enroll: ${e.toString()}',
      };
    }
  }

  // ============ USER PROFILE ============
  static Future<User> getUserProfile({bool forceRefresh = false}) async {
    if (forceRefresh) {
      try {
        final apiData = await ApiService.getUserProfile();
        final user = User(
          id: apiData['id'] ?? '',
          name: apiData['name'] ?? '',
          email: apiData['email'] ?? '',
          userType: apiData['userType'] ?? apiData['role'] ?? 'learner',
          phone: apiData['phone'],
          bio: apiData['bio'],
          education: apiData['education'],
          experience: apiData['experience'],
          skills: apiData['skills'] != null ? List<String>.from(apiData['skills']) : null,
          profileImage: apiData['profileImage'],
          createdAt: apiData['createdAt'] != null ? DateTime.parse(apiData['createdAt']) : DateTime.now(),
        );
        await saveUserProfileLocally(user);
        return user;
      } catch (e) {
        // Fallback to local
        return await loadLocalUserProfile() ?? User.defaultUser();
      }
    }

    final localUser = await loadLocalUserProfile();
    if (localUser != null) return localUser;

    // If no local data, try API
    return await getUserProfile(forceRefresh: true);
  }

  static Future<Map<String, dynamic>> updateUserProfile(
      Map<String, dynamic> data) async {
    try {
      await ApiService.updateUserProfile(data);

      // Update local cache
      final updatedUser = User(
        id: data['id'] ?? '',
        name: data['name'] ?? '',
        email: data['email'] ?? '',
        userType: data['userType'] ?? data['role'] ?? 'learner',
        phone: data['phone'],
        bio: data['bio'],
        education: data['education'],
        experience: data['experience'],
        skills: data['skills'] != null ? List<String>.from(data['skills']) : null,
        profileImage: data['profileImage'],
        createdAt: data['createdAt'] != null ? DateTime.parse(data['createdAt']) : DateTime.now(),
      );
      await saveUserProfileLocally(updatedUser);

      return {
        'success': true,
        'message': 'Profile updated successfully',
        'user': updatedUser,
      };
    } catch (e) {
      return {
        'success': false,
        'message': 'Failed to update profile: ${e.toString()}',
      };
    }
  }

  // ============ FEEDBACK ============
  static Future<bool> sendFeedback({
    required String name,
    required String email,
    required String feedback,
  }) async {
    try {
      final response = await ApiService.submitFeedback(name, email, feedback);
      return response['success'] == true;
    } catch (e) {
      // Even on error, return true for mock mode
      return true;
    }
  }

  // ============ ADMIN METHODS ============
  static Future<List<dynamic>> getAllUsersAdmin() async {
    return await ApiService.getAllUsers();
  }

  static Future<List<dynamic>> getAllEnrollmentsAdmin() async {
    return await ApiService.getAllEnrollments();
  }

  static Future<Map<String, dynamic>> createProgramAdmin(
      Map<String, dynamic> data) async {
    try {
      final response = await ApiService.createProgram(data);

      if (response['success'] == true) {
        // Get program data from response
        final programData = response['data'] ?? data;
        
        // Ensure program has an ID
        if (programData['id'] == null) {
          programData['id'] = 'prog_${DateTime.now().millisecondsSinceEpoch}';
        }

        // Update local cache
        final newProgram = Program.fromMap(programData);
        final currentPrograms = await loadLocalPrograms();
        currentPrograms.add(newProgram);
        await saveProgramsLocally(currentPrograms);

        return {
          'success': true,
          'message': response['message'] ?? 'Program created successfully',
          'program': newProgram,
        };
      } else {
        return {
          'success': false,
          'message': response['message'] ?? 'Failed to create program',
        };
      }
    } catch (e) {
      // Even on error, add to local cache for offline support
      try {
        final programData = Map<String, dynamic>.from(data);
        if (programData['id'] == null) {
          programData['id'] = 'prog_${DateTime.now().millisecondsSinceEpoch}';
        }
        final newProgram = Program.fromMap(programData);
        final currentPrograms = await loadLocalPrograms();
        currentPrograms.add(newProgram);
        await saveProgramsLocally(currentPrograms);
        
        return {
          'success': true,
          'message': 'Program saved locally (offline mode)',
          'program': newProgram,
        };
      } catch (e2) {
        return {
          'success': false,
          'message': 'Failed to create program: ${e.toString()}',
        };
      }
    }
  }

  static Future<Map<String, dynamic>> updateProgramAdmin(
      String id, Map<String, dynamic> data) async {
    try {
      final response = await ApiService.updateProgram(id, data);

      // Update local cache
      final updatedProgram = Program.fromMap(response['data']);
      final currentPrograms = await loadLocalPrograms();
      final index = currentPrograms.indexWhere((p) => p.id == id);
      if (index != -1) {
        currentPrograms[index] = updatedProgram;
        await saveProgramsLocally(currentPrograms);
      }

      return {
        'success': true,
        'message': 'Program updated successfully',
        'program': updatedProgram,
      };
    } catch (e) {
      return {
        'success': false,
        'message': 'Failed to update program: ${e.toString()}',
      };
    }
  }

  static Future<bool> deleteProgramAdmin(String id) async {
    try {
      await ApiService.deleteProgram(id);

      // Update local cache
      final currentPrograms = await loadLocalPrograms();
      currentPrograms.removeWhere((p) => p.id == id);
      await saveProgramsLocally(currentPrograms);

      return true;
    } catch (e) {
      return false;
    }
  }
}
