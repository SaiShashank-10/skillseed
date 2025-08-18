import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sizer/sizer.dart';

import '../../core/app_export.dart';
import './widgets/animated_logo_widget.dart';
import './widgets/nature_background_widget.dart';
import './widgets/seedling_progress_widget.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with TickerProviderStateMixin {
  double _initializationProgress = 0.0;
  String _loadingMessage = 'Initializing SkillSeed...';
  bool _isInitialized = false;

  // Mock user data for demonstration
  final Map<String, dynamic> mockUserData = {
    "isAuthenticated": false,
    "userType": "student", // student, parent, teacher
    "isFirstTime": true,
    "hasCompletedOnboarding": false,
    "studentData": {
      "name": "Arjun Sharma",
      "grade": 7,
      "school": "Delhi Public School",
      "interests": ["science", "technology", "sports"],
      "completedQuests": 15,
      "totalXP": 1250,
      "badges": ["Critical Thinker", "Team Player"],
    },
    "parentData": {
      "name": "Priya Sharma",
      "email": "priya.sharma@email.com",
      "children": ["Arjun Sharma"],
    },
    "teacherData": {
      "name": "Dr. Rajesh Kumar",
      "email": "rajesh.kumar@school.edu",
      "subjects": ["Mathematics", "Science"],
      "classes": ["7A", "7B", "8A"],
    }
  };

  @override
  void initState() {
    super.initState();
    _hideSystemUI();
    _initializeApp();
  }

  void _hideSystemUI() {
    SystemChrome.setEnabledSystemUIMode(
      SystemUiMode.immersiveSticky,
      overlays: [],
    );
  }

  void _restoreSystemUI() {
    SystemChrome.setEnabledSystemUIMode(
      SystemUiMode.edgeToEdge,
      overlays: SystemUiOverlay.values,
    );
  }

  Future<void> _initializeApp() async {
    try {
      // Step 1: Check authentication status
      await _updateProgress(0.2, 'Checking authentication...');
      await Future.delayed(const Duration(milliseconds: 500));

      // Step 2: Load AI recommendations
      await _updateProgress(0.4, 'Loading AI recommendations...');
      await Future.delayed(const Duration(milliseconds: 600));

      // Step 3: Fetch quest data
      await _updateProgress(0.6, 'Fetching quest data...');
      await Future.delayed(const Duration(milliseconds: 500));

      // Step 4: Prepare cached content
      await _updateProgress(0.8, 'Preparing educational content...');
      await Future.delayed(const Duration(milliseconds: 600));

      // Step 5: Finalize initialization
      await _updateProgress(1.0, 'Ready to grow!');
      await Future.delayed(const Duration(milliseconds: 500));

      setState(() {
        _isInitialized = true;
      });

      // Navigate based on user state
      await Future.delayed(const Duration(milliseconds: 800));
      _navigateToNextScreen();
    } catch (error) {
      // Handle initialization errors
      await _handleInitializationError();
    }
  }

  Future<void> _updateProgress(double progress, String message) async {
    if (mounted) {
      setState(() {
        _initializationProgress = progress;
        _loadingMessage = message;
      });
    }
  }

  Future<void> _handleInitializationError() async {
    await _updateProgress(0.0, 'Connection timeout. Retrying...');
    await Future.delayed(const Duration(seconds: 2));

    if (mounted) {
      // Show retry option after 5 seconds
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) => AlertDialog(
          title: Text(
            'Connection Issue',
            style: AppTheme.lightTheme.textTheme.titleLarge,
          ),
          content: Text(
            'Unable to connect to SkillSeed services. Please check your internet connection and try again.',
            style: AppTheme.lightTheme.textTheme.bodyMedium,
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                _initializeApp();
              },
              child: const Text('Retry'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                _navigateToNextScreen();
              },
              child: const Text('Continue Offline'),
            ),
          ],
        ),
      );
    }
  }

  void _navigateToNextScreen() {
    _restoreSystemUI();

    // Navigation logic based on user state
    final bool isAuthenticated = mockUserData["isAuthenticated"] as bool;
    final String userType = mockUserData["userType"] as String;
    final bool isFirstTime = mockUserData["isFirstTime"] as bool;

    if (!isAuthenticated || isFirstTime) {
      // New users go to onboarding
      Navigator.pushReplacementNamed(context, '/student-onboarding-flow');
    } else {
      // Navigate based on user type
      switch (userType) {
        case 'student':
          Navigator.pushReplacementNamed(
              context, '/personalized-growth-pathway-dashboard');
          break;
        case 'parent':
          Navigator.pushReplacementNamed(context, '/parent-dashboard');
          break;
        case 'teacher':
          Navigator.pushReplacementNamed(
              context, '/teacher-classroom-management');
          break;
        default:
          Navigator.pushReplacementNamed(context, '/student-onboarding-flow');
      }
    }
  }

  @override
  void dispose() {
    _restoreSystemUI();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Stack(
          children: [
            // Nature-themed gradient background
            const NatureBackgroundWidget(),

            // Main content
            Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Spacer to push content up slightly
                  SizedBox(height: 5.h),

                  // Animated logo with brain and seed iconography
                  const AnimatedLogoWidget(),

                  // Spacer between logo and progress
                  SizedBox(height: 8.h),

                  // Seedling progress indicator
                  SeedlingProgressWidget(
                    progress: _initializationProgress,
                  ),

                  SizedBox(height: 3.h),

                  // Loading message
                  AnimatedSwitcher(
                    duration: const Duration(milliseconds: 300),
                    child: Text(
                      _loadingMessage,
                      key: ValueKey(_loadingMessage),
                      style: AppTheme.lightTheme.textTheme.bodyLarge?.copyWith(
                        color: Colors.white.withValues(alpha: 0.9),
                        fontWeight: FontWeight.w500,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),

                  SizedBox(height: 2.h),

                  // Progress bar
                  Container(
                    width: 60.w,
                    height: 0.5.h,
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.3),
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 300),
                      width: 60.w * _initializationProgress,
                      height: 0.5.h,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(4),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.white.withValues(alpha: 0.5),
                            blurRadius: 8,
                            spreadRadius: 1,
                          ),
                        ],
                      ),
                    ),
                  ),

                  // Bottom spacer
                  SizedBox(height: 10.h),

                  // NEP 2020 compliance badge
                  Container(
                    padding: EdgeInsets.symmetric(
                      horizontal: 4.w,
                      vertical: 1.h,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.2),
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(
                        color: Colors.white.withValues(alpha: 0.3),
                        width: 1,
                      ),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        CustomIconWidget(
                          iconName: 'verified',
                          color: Colors.white,
                          size: 4.w,
                        ),
                        SizedBox(width: 2.w),
                        Text(
                          'NEP 2020 Aligned',
                          style:
                              AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                            color: Colors.white,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            // Success celebration overlay
            if (_isInitialized)
              AnimatedOpacity(
                opacity: 1.0,
                duration: const Duration(milliseconds: 500),
                child: Container(
                  color: AppTheme.lightTheme.colorScheme.primary
                      .withValues(alpha: 0.1),
                  child: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        CustomIconWidget(
                          iconName: 'check_circle',
                          color: Colors.white,
                          size: 15.w,
                        ),
                        SizedBox(height: 2.h),
                        Text(
                          'Welcome to SkillSeed!',
                          style: AppTheme.lightTheme.textTheme.headlineMedium
                              ?.copyWith(
                            color: Colors.white,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
