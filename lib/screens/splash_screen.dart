// lib/screens/splash_screen.dart

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/app_provider.dart';
import '../constants/constants.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    );

    _animation = CurvedAnimation(
      parent: _controller,
      curve: Curves.easeInOut,
    );

    _controller.forward();

    // Initialize app and navigate
    _initializeApp();
  }

  Future<void> _initializeApp() async {
    final provider = Provider.of<AppProvider>(context, listen: false);

    // Wait for provider initialization
    await Future.delayed(const Duration(seconds: 1));

    // Check if user is logged in
    if (provider.isLoggedIn) {
      // Navigate to home
      _navigateToHome();
    } else {
      // Navigate to login or onboarding
      _navigateToOnboarding();
    }
  }

  void _navigateToHome() {
    Navigator.pushReplacementNamed(context, '/home');
  }

  void _navigateToOnboarding() {
    Navigator.pushReplacementNamed(context, '/onboarding');
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppConstants.primaryColor,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Animated Logo
            ScaleTransition(
              scale: _animation,
              child: Container(
                width: 150,
                height: 150,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(30),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.2),
                      blurRadius: 20,
                      spreadRadius: 5,
                    ),
                  ],
                ),
                child: const Icon(
                  Icons.school,
                  size: 80,
                  color: AppConstants.primaryColor,
                ),
              ),
            ),

            const SizedBox(height: 40),

            // App Name with Animation
            FadeTransition(
              opacity: _animation,
              child: const Text(
                'SKILL TRACK',
                style: TextStyle(
                  fontSize: 36,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                  letterSpacing: 2,
                ),
              ),
            ),

            const SizedBox(height: 10),

            // Tagline
            FadeTransition(
              opacity: _animation,
              child: const Text(
                'Learn. Track. Grow.',
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.white70,
                  letterSpacing: 1,
                ),
              ),
            ),

            const SizedBox(height: 60),

            // Loading Indicator
            const CircularProgressIndicator(
              color: Colors.white,
              strokeWidth: 2,
            ),

            const SizedBox(height: 20),

            // Loading Text
            const Text(
              'Loading...',
              style: TextStyle(
                color: Colors.white70,
                fontSize: 14,
              ),
            ),

            // Version Info
            Positioned(
              bottom: 40,
              child: const Text(
                'Version ${AppConstants.appVersion}',
                style: TextStyle(
                  color: Colors.white54,
                  fontSize: 12,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
