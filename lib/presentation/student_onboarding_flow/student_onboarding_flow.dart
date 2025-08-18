import 'package:flutter/material.dart';

import '../../core/app_export.dart';
import '../../theme/app_theme.dart';
import './widgets/completion_celebration_widget.dart';
import './widgets/interest_assessment_widget.dart';
import './widgets/language_selector_widget.dart';
import './widgets/problem_solving_game_widget.dart';
import './widgets/progress_indicator_widget.dart';
import './widgets/skill_assessment_widget.dart';
import './widgets/welcome_screen_widget.dart';

class StudentOnboardingFlow extends StatefulWidget {
  const StudentOnboardingFlow({Key? key}) : super(key: key);

  @override
  State<StudentOnboardingFlow> createState() => _StudentOnboardingFlowState();
}

class _StudentOnboardingFlowState extends State<StudentOnboardingFlow>
    with TickerProviderStateMixin {
  int currentStep = 0;
  late PageController _pageController;
  late AnimationController _transitionController;

  // User profile data
  Map<String, dynamic> userProfile = {
    'language': 'English',
    'skills': <String>[],
    'interests': <String>[],
    'problemSolvingScore': 0,
  };

  final List<String> stepTitles = [
    'Welcome',
    'Choose Language',
    'Your Skills',
    'Your Interests',
    'Brain Challenge',
    'Celebration',
  ];

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
    _transitionController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
  }

  @override
  void dispose() {
    _pageController.dispose();
    _transitionController.dispose();
    super.dispose();
  }

  void _nextStep() {
    if (currentStep < stepTitles.length - 1) {
      setState(() {
        currentStep++;
      });
      _pageController.nextPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
      _transitionController
          .forward()
          .then((_) => _transitionController.reverse());
    }
  }

  void _skipStep() {
    _nextStep();
  }

  void _onLanguageSelected(String languageCode) {
    setState(() {
      userProfile['language'] = languageCode;
    });
  }

  void _onSkillsSelected(List<String> skills) {
    setState(() {
      userProfile['skills'] = skills;
    });
  }

  void _onInterestsSelected(List<String> interests) {
    setState(() {
      userProfile['interests'] = interests;
    });
  }

  void _onScoreCalculated(int score) {
    setState(() {
      userProfile['problemSolvingScore'] = score;
    });
  }

  void _startJourney() {
    // Navigate to personalized growth pathway dashboard
    Navigator.pushReplacementNamed(
        context, '/personalized-growth-pathway-dashboard');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.lightTheme.colorScheme.surface,
      body: Column(
        children: [
          // Progress indicator (hidden on welcome and celebration screens)
          if (currentStep > 0 && currentStep < stepTitles.length - 1)
            ProgressIndicatorWidget(
              currentStep: currentStep,
              totalSteps:
                  stepTitles.length - 2, // Exclude welcome and celebration
              stepTitles: stepTitles.sublist(1, stepTitles.length - 1),
            ),

          // Main content
          Expanded(
            child: PageView(
              controller: _pageController,
              physics: const NeverScrollableScrollPhysics(),
              children: [
                // Step 0: Welcome Screen
                WelcomeScreenWidget(
                  onNext: _nextStep,
                ),

                // Step 1: Language Selection
                LanguageSelectorWidget(
                  onLanguageSelected: _onLanguageSelected,
                  onNext: _nextStep,
                ),

                // Step 2: Skill Assessment
                SkillAssessmentWidget(
                  onSkillsSelected: _onSkillsSelected,
                  onNext: _nextStep,
                  onSkip: _skipStep,
                ),

                // Step 3: Interest Assessment
                InterestAssessmentWidget(
                  onInterestsSelected: _onInterestsSelected,
                  onNext: _nextStep,
                  onSkip: _skipStep,
                ),

                // Step 4: Problem Solving Game
                ProblemSolvingGameWidget(
                  onScoreCalculated: _onScoreCalculated,
                  onNext: _nextStep,
                  onSkip: _skipStep,
                ),

                // Step 5: Completion Celebration
                CompletionCelebrationWidget(
                  userProfile: userProfile,
                  onStartJourney: _startJourney,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
