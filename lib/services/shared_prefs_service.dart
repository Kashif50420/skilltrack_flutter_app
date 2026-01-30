// lib/services/shared_prefs_service.dart

import 'package:shared_preferences/shared_preferences.dart';

class SharedPrefsService {
  static SharedPrefsService? _instance;
  static SharedPreferences? _prefs;

  SharedPrefsService._internal();

  factory SharedPrefsService() {
    _instance ??= SharedPrefsService._internal();
    return _instance!;
  }

  static Future<void> initialize() async {
    _prefs = await SharedPreferences.getInstance();
  }

  // ============ AUTH RELATED ============
  static Future<void> saveAuthData({
    required String token,
    required String userId,
    required String userEmail,
    required String userName,
    required String userRole,
  }) async {
    await _prefs?.setString('auth_token', token);
    await _prefs?.setString('user_id', userId);
    await _prefs?.setString('user_email', userEmail);
    await _prefs?.setString('user_name', userName);
    await _prefs?.setString('user_role', userRole);
    await _prefs?.setBool('is_logged_in', true);
  }

  static Future<Map<String, String>?> getAuthData() async {
    final token = _prefs?.getString('auth_token');
    final userId = _prefs?.getString('user_id');
    final userEmail = _prefs?.getString('user_email');
    final userName = _prefs?.getString('user_name');
    final userRole = _prefs?.getString('user_role');

    if (token == null || userId == null) return null;

    return {
      'token': token,
      'userId': userId,
      'userEmail': userEmail ?? '',
      'userName': userName ?? '',
      'userRole': userRole ?? 'learner',
    };
  }

  static Future<void> clearAuthData() async {
    await _prefs?.remove('auth_token');
    await _prefs?.remove('user_id');
    await _prefs?.remove('user_email');
    await _prefs?.remove('user_name');
    await _prefs?.remove('user_role');
    await _prefs?.setBool('is_logged_in', false);
  }

  static bool get isLoggedIn => _prefs?.getBool('is_logged_in') ?? false;
  static String? get userRole => _prefs?.getString('user_role');
  static String? get userId => _prefs?.getString('user_id');
  static String? get userName => _prefs?.getString('user_name');
  static String? get userEmail => _prefs?.getString('user_email');

  // ============ APP SETTINGS ============
  static Future<void> setThemeMode(bool isDarkMode) async {
    await _prefs?.setBool('dark_mode', isDarkMode);
  }

  static bool get isDarkMode => _prefs?.getBool('dark_mode') ?? false;

  static Future<void> setNotificationEnabled(bool enabled) async {
    await _prefs?.setBool('notifications_enabled', enabled);
  }

  static bool get notificationsEnabled =>
      _prefs?.getBool('notifications_enabled') ?? true;

  static Future<void> setLanguage(String languageCode) async {
    await _prefs?.setString('language', languageCode);
  }

  static String get language => _prefs?.getString('language') ?? 'en';

  // ============ USER PREFERENCES ============
  static Future<void> setLastVisitedProgram(String programId) async {
    await _prefs?.setString('last_visited_program', programId);
  }

  static String? get lastVisitedProgram =>
      _prefs?.getString('last_visited_program');

  static Future<void> setCompletedOnboarding(bool completed) async {
    await _prefs?.setBool('onboarding_completed', completed);
  }

  static bool get onboardingCompleted =>
      _prefs?.getBool('onboarding_completed') ?? false;

  // ============ APP DATA CACHE ============
  static Future<void> cachePrograms(String programsJson) async {
    await _prefs?.setString('cached_programs', programsJson);
    await _prefs?.setString(
        'programs_last_updated', DateTime.now().toIso8601String());
  }

  static String? get cachedPrograms => _prefs?.getString('cached_programs');

  static DateTime? get programsLastUpdated {
    final dateString = _prefs?.getString('programs_last_updated');
    return dateString != null ? DateTime.parse(dateString) : null;
  }

  static Future<void> cacheEnrollments(String enrollmentsJson) async {
    await _prefs?.setString('cached_enrollments', enrollmentsJson);
  }

  static String? get cachedEnrollments =>
      _prefs?.getString('cached_enrollments');

  static Future<void> cacheUserProfile(String profileJson) async {
    await _prefs?.setString('cached_user_profile', profileJson);
  }

  static String? get cachedUserProfile =>
      _prefs?.getString('cached_user_profile');

  // ============ APP STATE ============
  static Future<void> setFirstLaunch(bool isFirstLaunch) async {
    await _prefs?.setBool('first_launch', isFirstLaunch);
  }

  static bool get isFirstLaunch => _prefs?.getBool('first_launch') ?? true;

  static Future<void> setAppVersion(String version) async {
    await _prefs?.setString('app_version', version);
  }

  static String get appVersion => _prefs?.getString('app_version') ?? '1.0.0';

  // ============ SEARCH HISTORY ============
  static Future<void> addToSearchHistory(String query) async {
    if (query.trim().isEmpty) return;

    final history = getSearchHistory();
    history.removeWhere((item) => item.toLowerCase() == query.toLowerCase());
    history.insert(0, query.trim());

    // Keep only last 10 searches
    if (history.length > 10) {
      history.removeLast();
    }

    await _prefs?.setStringList('search_history', history);
  }

  static List<String> getSearchHistory() {
    return _prefs?.getStringList('search_history') ?? [];
  }

  static Future<void> clearSearchHistory() async {
    await _prefs?.remove('search_history');
  }

  // ============ RATING PROMPT ============
  static Future<void> setAppRated() async {
    await _prefs?.setBool('app_rated', true);
  }

  static bool get appRated => _prefs?.getBool('app_rated') ?? false;

  static Future<void> setRatingPromptCount(int count) async {
    await _prefs?.setInt('rating_prompt_count', count);
  }

  static int get ratingPromptCount =>
      _prefs?.getInt('rating_prompt_count') ?? 0;

  static Future<void> setLastRatingPrompt(DateTime date) async {
    await _prefs?.setString('last_rating_prompt', date.toIso8601String());
  }

  static DateTime? get lastRatingPrompt {
    final dateString = _prefs?.getString('last_rating_prompt');
    return dateString != null ? DateTime.parse(dateString) : null;
  }

  // ============ CLEAR ALL DATA ============
  static Future<void> clearAllData() async {
    await _prefs?.clear();
  }

  // ============ DEBUG/DEVELOPMENT ============
  static Future<void> setDebugMode(bool enabled) async {
    await _prefs?.setBool('debug_mode', enabled);
  }

  static bool get debugMode => _prefs?.getBool('debug_mode') ?? false;

  static Future<void> setApiBaseUrl(String url) async {
    await _prefs?.setString('api_base_url', url);
  }

  static String get apiBaseUrl =>
      _prefs?.getString('api_base_url') ?? 'https://api.example.com';

  // ============ OFFLINE MODE ============
  static Future<void> setOfflineMode(bool enabled) async {
    await _prefs?.setBool('offline_mode', enabled);
  }

  static bool get offlineMode => _prefs?.getBool('offline_mode') ?? false;

  static Future<void> setLastSyncTime() async {
    await _prefs?.setString('last_sync_time', DateTime.now().toIso8601String());
  }

  static DateTime? get lastSyncTime {
    final dateString = _prefs?.getString('last_sync_time');
    return dateString != null ? DateTime.parse(dateString) : null;
  }

  // ============ BATCH OPERATIONS ============
  static Future<void> saveMultiple(Map<String, dynamic> data) async {
    for (final entry in data.entries) {
      final key = entry.key;
      final value = entry.value;

      if (value is String) {
        await _prefs?.setString(key, value);
      } else if (value is int) {
        await _prefs?.setInt(key, value);
      } else if (value is double) {
        await _prefs?.setDouble(key, value);
      } else if (value is bool) {
        await _prefs?.setBool(key, value);
      } else if (value is List<String>) {
        await _prefs?.setStringList(key, value);
      }
    }
  }

  static Map<String, dynamic> getAllData() {
    final keys = _prefs?.getKeys() ?? {};
    final data = <String, dynamic>{};

    for (final key in keys) {
      data[key] = _prefs?.get(key);
    }

    return data;
  }

  // ============ BACKUP & RESTORE ============
  static Map<String, dynamic> exportData() {
    return {
      'app_settings': {
        'dark_mode': isDarkMode,
        'language': language,
        'notifications_enabled': notificationsEnabled,
      },
      'user_data': {
        'user_id': userId,
        'user_name': userName,
        'user_email': userEmail,
        'user_role': userRole,
      },
      'app_state': {
        'first_launch': isFirstLaunch,
        'onboarding_completed': onboardingCompleted,
        'app_version': appVersion,
        'app_rated': appRated,
      },
      'last_updated': DateTime.now().toIso8601String(),
    };
  }

  static Future<void> importData(Map<String, dynamic> data) async {
    final appSettings = data['app_settings'] as Map<String, dynamic>?;
    if (appSettings != null) {
      await setThemeMode(appSettings['dark_mode'] ?? false);
      await setLanguage(appSettings['language'] ?? 'en');
      await setNotificationEnabled(
          appSettings['notifications_enabled'] ?? true);
    }
  }
}
