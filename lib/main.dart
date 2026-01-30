import 'package:flutter/material.dart';
import 'package:silk_track/screens/auth/login_screen.dart';
import 'package:silk_track/screens/learner/home_screen.dart';
import 'package:silk_track/screens/admin/admin_dashboard_screen.dart';
import 'package:provider/provider.dart';
import 'package:silk_track/providers/app_provider.dart';
import 'package:silk_track/services/auth_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Initialize auth service
  await AuthService().initialize();
  
  runApp(
    ChangeNotifierProvider(
      create: (_) => AppProvider(),
      child: const SkillTrackApp(),
    ),
  );
}

class SkillTrackApp extends StatelessWidget {
  const SkillTrackApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Skill Track',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        appBarTheme: const AppBarTheme(
          elevation: 0,
          backgroundColor: Colors.white,
          iconTheme: IconThemeData(color: Colors.black),
          titleTextStyle: TextStyle(
            color: Colors.black,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      debugShowCheckedModeBanner: false,
      home: Consumer<AppProvider>(
        builder: (context, provider, _) {
          // Check if user is already logged in
          if (provider.isLoggedIn) {
            // Route to appropriate screen based on user role
            if (provider.isAdmin) {
              return const AdminDashboard();
            } else {
              return const LearnerHomeScreen();
            }
          }
          return const LoginScreen();
        },
      ),
      routes: {
        '/login': (context) => const LoginScreen(),
        '/learner-home': (context) => const LearnerHomeScreen(),
        '/admin-dashboard': (context) => const AdminDashboard(),
      },
    );
  }
}
