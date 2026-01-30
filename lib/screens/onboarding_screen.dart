import 'package:flutter/material.dart';
import '../constants/constants.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final PageController _pageController = PageController();
  int _currentPage = 0;

  final List<Map<String, dynamic>> _onboardingPages = [
    {
      'title': 'Welcome to Silk Track',
      'description':
          'Your gateway to skill-based learning and internship opportunities.',
      'icon': Icons.school,
      'color': Colors.blue,
    },
    {
      'title': 'Discover Programs',
      'description':
          'Browse through curated programs and internships tailored for you.',
      'icon': Icons.search,
      'color': Colors.green,
    },
    {
      'title': 'Track Progress',
      'description':
          'Monitor your learning journey and achievements in real-time.',
      'icon': Icons.trending_up,
      'color': Colors.orange,
    },
    {
      'title': 'Get Certified',
      'description': 'Earn certificates upon completion to boost your career.',
      'icon': Icons.verified,
      'color': Colors.purple,
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            // Skip Button
            Align(
              alignment: Alignment.topRight,
              child: TextButton(
                onPressed: _skipOnboarding,
                child: const Text('Skip'),
              ),
            ),

            // Page View
            Expanded(
              child: PageView.builder(
                controller: _pageController,
                itemCount: _onboardingPages.length,
                onPageChanged: (index) {
                  setState(() => _currentPage = index);
                },
                itemBuilder: (context, index) {
                  final page = _onboardingPages[index];
                  return _buildOnboardingPage(page);
                },
              ),
            ),

            // Dots Indicator
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(
                _onboardingPages.length,
                (index) => _buildDot(index),
              ),
            ),

            // Navigation Buttons
            Padding(
              padding: const EdgeInsets.all(AppConstants.defaultPadding),
              child: Row(
                children: [
                  // Back Button
                  if (_currentPage > 0)
                    TextButton(
                      onPressed: _previousPage,
                      child: const Text('Back'),
                    ),

                  const Spacer(),

                  // Next/Get Started Button
                  ElevatedButton(
                    onPressed: _nextPage,
                    child: Text(
                      _currentPage == _onboardingPages.length - 1
                          ? 'Get Started'
                          : 'Next',
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildOnboardingPage(Map<String, dynamic> page) {
    return Padding(
      padding: const EdgeInsets.all(AppConstants.defaultPadding),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Icon
          Container(
            width: 150,
            height: 150,
            decoration: BoxDecoration(
              color: page['color'].withOpacity(0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(
              page['icon'],
              size: 80,
              color: page['color'],
            ),
          ),

          const SizedBox(height: 40),

          // Title
          Text(
            page['title'],
            style: const TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.bold,
            ),
            textAlign: TextAlign.center,
          ),

          const SizedBox(height: 20),

          // Description
          Text(
            page['description'],
            style: const TextStyle(
              fontSize: 16,
              color: Colors.grey,
              height: 1.5,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildDot(int index) {
    return Container(
      width: 8,
      height: 8,
      margin: const EdgeInsets.symmetric(horizontal: 4),
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: _currentPage == index
            ? AppConstants.primaryColor
            : Colors.grey.shade300,
      ),
    );
  }

  void _nextPage() {
    if (_currentPage < _onboardingPages.length - 1) {
      _pageController.nextPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    } else {
      _completeOnboarding();
    }
  }

  void _previousPage() {
    _pageController.previousPage(
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );
  }

  void _skipOnboarding() {
    _completeOnboarding();
  }

  void _completeOnboarding() {
    // Mark onboarding as completed
    // Navigate to login screen
    Navigator.pushReplacementNamed(context, '/login');
  }
}
