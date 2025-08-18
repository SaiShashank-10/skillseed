import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class CompletionCelebrationWidget extends StatefulWidget {
  final Map<String, dynamic> userProfile;
  final VoidCallback onStartJourney;

  const CompletionCelebrationWidget({
    Key? key,
    required this.userProfile,
    required this.onStartJourney,
  }) : super(key: key);

  @override
  State<CompletionCelebrationWidget> createState() =>
      _CompletionCelebrationWidgetState();
}

class _CompletionCelebrationWidgetState
    extends State<CompletionCelebrationWidget> with TickerProviderStateMixin {
  late AnimationController _badgeController;
  late AnimationController _confettiController;
  late AnimationController _plantController;
  late Animation<double> _badgeScale;
  late Animation<double> _plantGrowth;
  late Animation<double> _confettiAnimation;

  @override
  void initState() {
    super.initState();

    _badgeController = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    );

    _confettiController = AnimationController(
      duration: const Duration(seconds: 3),
      vsync: this,
    );

    _plantController = AnimationController(
      duration: const Duration(seconds: 4),
      vsync: this,
    );

    _badgeScale = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _badgeController,
      curve: Curves.elasticOut,
    ));

    _plantGrowth = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _plantController,
      curve: Curves.easeInOut,
    ));

    _confettiAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _confettiController,
      curve: Curves.easeOut,
    ));

    // Start animations in sequence
    _startCelebrationSequence();
  }

  void _startCelebrationSequence() async {
    await Future.delayed(const Duration(milliseconds: 500));
    _plantController.forward();

    await Future.delayed(const Duration(milliseconds: 1000));
    _confettiController.forward();

    await Future.delayed(const Duration(milliseconds: 500));
    _badgeController.forward();
  }

  @override
  void dispose() {
    _badgeController.dispose();
    _confettiController.dispose();
    _plantController.dispose();
    super.dispose();
  }

  String _generatePersonalizedMessage() {
    final skills = widget.userProfile['skills'] as List<String>? ?? [];
    final interests = widget.userProfile['interests'] as List<String>? ?? [];

    if (skills.isNotEmpty && interests.isNotEmpty) {
      return 'Based on your love for ${interests.first} and your ${skills.first} skills, we\'ve created a special learning path just for you!';
    } else if (skills.isNotEmpty) {
      return 'Your ${skills.first} skills are amazing! We\'ve prepared exciting challenges to help you grow even more.';
    } else if (interests.isNotEmpty) {
      return 'Your passion for ${interests.first} is wonderful! Let\'s explore how it can shape your future.';
    } else {
      return 'Every great journey begins with a single step. Let\'s discover your amazing potential together!';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 100.w,
      height: 100.h,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            AppTheme.lightTheme.colorScheme.primary.withValues(alpha: 0.1),
            AppTheme.lightTheme.colorScheme.secondary.withValues(alpha: 0.1),
            AppTheme.lightTheme.colorScheme.surface,
          ],
        ),
      ),
      child: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 6.w, vertical: 4.h),
          child: Column(
            children: [
              // Confetti animation overlay
              AnimatedBuilder(
                animation: _confettiAnimation,
                builder: (context, child) {
                  return Stack(
                    children: [
                      // Confetti particles
                      ...List.generate(20, (index) {
                        final random = (index * 17) % 100;
                        return Positioned(
                          left: (random % 90).toDouble() + 5.w,
                          top: (_confettiAnimation.value * 30.h) +
                              (random % 10).toDouble(),
                          child: Transform.rotate(
                            angle:
                                _confettiAnimation.value * 6.28 * (index % 3),
                            child: Container(
                              width: 2.w,
                              height: 2.w,
                              decoration: BoxDecoration(
                                color: [
                                  AppTheme.lightTheme.colorScheme.primary,
                                  AppTheme.lightTheme.colorScheme.secondary,
                                  AppTheme.lightTheme.colorScheme.tertiary,
                                ][index % 3],
                                shape: BoxShape.circle,
                              ),
                            ),
                          ),
                        );
                      }),
                    ],
                  );
                },
              ),

              // Header
              Container(
                width: 100.w,
                padding: EdgeInsets.symmetric(vertical: 2.h),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    CustomIconWidget(
                      iconName: 'eco',
                      color: AppTheme.lightTheme.colorScheme.primary,
                      size: 8.w,
                    ),
                    SizedBox(width: 2.w),
                    Text(
                      'SkillSeed',
                      style: AppTheme.lightTheme.textTheme.headlineMedium
                          ?.copyWith(
                        color: AppTheme.lightTheme.colorScheme.primary,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),

              // Growing plant animation
              Expanded(
                flex: 2,
                child: AnimatedBuilder(
                  animation: _plantGrowth,
                  builder: (context, child) {
                    return Container(
                      width: 60.w,
                      height: 30.h,
                      child: Stack(
                        alignment: Alignment.bottomCenter,
                        children: [
                          // Soil base
                          Container(
                            width: 60.w,
                            height: 8.h,
                            decoration: BoxDecoration(
                              color: const Color(0xFF8D6E63),
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),

                          // Plant growth
                          Positioned(
                            bottom: 8.h,
                            child: Container(
                              width: 4.w,
                              height: 22.h * _plantGrowth.value,
                              decoration: BoxDecoration(
                                color: AppTheme.lightTheme.colorScheme.primary,
                                borderRadius: BorderRadius.circular(2),
                              ),
                            ),
                          ),

                          // Leaves
                          if (_plantGrowth.value > 0.5)
                            Positioned(
                              bottom: 20.h,
                              left: 25.w,
                              child: Transform.scale(
                                scale: (_plantGrowth.value - 0.5) * 2,
                                child: Container(
                                  width: 8.w,
                                  height: 6.h,
                                  decoration: BoxDecoration(
                                    color:
                                        AppTheme.lightTheme.colorScheme.primary,
                                    borderRadius: BorderRadius.circular(20),
                                  ),
                                ),
                              ),
                            ),

                          if (_plantGrowth.value > 0.7)
                            Positioned(
                              bottom: 18.h,
                              right: 25.w,
                              child: Transform.scale(
                                scale: (_plantGrowth.value - 0.7) * 3.33,
                                child: Container(
                                  width: 8.w,
                                  height: 6.h,
                                  decoration: BoxDecoration(
                                    color:
                                        AppTheme.lightTheme.colorScheme.primary,
                                    borderRadius: BorderRadius.circular(20),
                                  ),
                                ),
                              ),
                            ),

                          // Flower/fruit
                          if (_plantGrowth.value > 0.9)
                            Positioned(
                              bottom: 25.h,
                              child: Transform.scale(
                                scale: (_plantGrowth.value - 0.9) * 10,
                                child: Text(
                                  '🌸',
                                  style: TextStyle(fontSize: 8.w),
                                ),
                              ),
                            ),
                        ],
                      ),
                    );
                  },
                ),
              ),

              // Celebration content
              Expanded(
                flex: 2,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // Badge animation
                    AnimatedBuilder(
                      animation: _badgeScale,
                      builder: (context, child) {
                        return Transform.scale(
                          scale: _badgeScale.value,
                          child: Container(
                            padding: EdgeInsets.all(4.w),
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                colors: [
                                  AppTheme.lightTheme.colorScheme.secondary,
                                  AppTheme.lightTheme.colorScheme.secondary
                                      .withValues(alpha: 0.8),
                                ],
                                begin: Alignment.topLeft,
                                end: Alignment.bottomRight,
                              ),
                              shape: BoxShape.circle,
                              boxShadow: [
                                BoxShadow(
                                  color: AppTheme
                                      .lightTheme.colorScheme.secondary
                                      .withValues(alpha: 0.4),
                                  blurRadius: 20,
                                  offset: const Offset(0, 8),
                                ),
                              ],
                            ),
                            child: CustomIconWidget(
                              iconName: 'emoji_events',
                              color: Colors.white,
                              size: 12.w,
                            ),
                          ),
                        );
                      },
                    ),

                    SizedBox(height: 3.h),

                    Text(
                      'Congratulations! 🎉',
                      textAlign: TextAlign.center,
                      style:
                          AppTheme.lightTheme.textTheme.headlineSmall?.copyWith(
                        color: AppTheme.lightTheme.colorScheme.onSurface,
                        fontWeight: FontWeight.bold,
                      ),
                    ),

                    SizedBox(height: 1.h),

                    Text(
                      'You\'ve earned your first badge:',
                      textAlign: TextAlign.center,
                      style:
                          AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
                        color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                      ),
                    ),

                    SizedBox(height: 1.h),

                    Container(
                      padding:
                          EdgeInsets.symmetric(horizontal: 4.w, vertical: 1.h),
                      decoration: BoxDecoration(
                        color: AppTheme.lightTheme.colorScheme.secondary
                            .withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(
                        '🌱 Journey Starter',
                        style:
                            AppTheme.lightTheme.textTheme.titleSmall?.copyWith(
                          color: AppTheme.lightTheme.colorScheme.secondary,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),

                    SizedBox(height: 3.h),

                    // Personalized message
                    Container(
                      padding: EdgeInsets.all(4.w),
                      decoration: BoxDecoration(
                        color: AppTheme.lightTheme.colorScheme.surface,
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(
                          color: AppTheme.lightTheme.colorScheme.outline
                              .withValues(alpha: 0.3),
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: AppTheme.lightTheme.colorScheme.shadow
                                .withValues(alpha: 0.1),
                            blurRadius: 8,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: Text(
                        _generatePersonalizedMessage(),
                        textAlign: TextAlign.center,
                        style:
                            AppTheme.lightTheme.textTheme.bodyLarge?.copyWith(
                          color: AppTheme.lightTheme.colorScheme.onSurface,
                          height: 1.5,
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              // Profile summary
              Container(
                width: 100.w,
                padding: EdgeInsets.all(4.w),
                decoration: BoxDecoration(
                  color: AppTheme.lightTheme.colorScheme.primary
                      .withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Column(
                  children: [
                    Text(
                      'Your Learning Profile',
                      style:
                          AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
                        color: AppTheme.lightTheme.colorScheme.primary,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 2.h),
                    Row(
                      children: [
                        // Skills
                        if ((widget.userProfile['skills'] as List<String>?)
                                ?.isNotEmpty ??
                            false)
                          Expanded(
                            child: Column(
                              children: [
                                CustomIconWidget(
                                  iconName: 'psychology',
                                  color:
                                      AppTheme.lightTheme.colorScheme.primary,
                                  size: 6.w,
                                ),
                                SizedBox(height: 1.h),
                                Text(
                                  '${(widget.userProfile['skills'] as List<String>).length} Skills',
                                  style: AppTheme.lightTheme.textTheme.bodySmall
                                      ?.copyWith(
                                    color:
                                        AppTheme.lightTheme.colorScheme.primary,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ],
                            ),
                          ),

                        // Interests
                        if ((widget.userProfile['interests'] as List<String>?)
                                ?.isNotEmpty ??
                            false)
                          Expanded(
                            child: Column(
                              children: [
                                Text(
                                  '❤️',
                                  style: TextStyle(fontSize: 6.w),
                                ),
                                SizedBox(height: 1.h),
                                Text(
                                  '${(widget.userProfile['interests'] as List<String>).length} Interests',
                                  style: AppTheme.lightTheme.textTheme.bodySmall
                                      ?.copyWith(
                                    color:
                                        AppTheme.lightTheme.colorScheme.primary,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ],
                            ),
                          ),

                        // Problem solving score
                        if (widget.userProfile['problemSolvingScore'] != null)
                          Expanded(
                            child: Column(
                              children: [
                                CustomIconWidget(
                                  iconName: 'star',
                                  color:
                                      AppTheme.lightTheme.colorScheme.secondary,
                                  size: 6.w,
                                ),
                                SizedBox(height: 1.h),
                                Text(
                                  '${widget.userProfile['problemSolvingScore']} Points',
                                  style: AppTheme.lightTheme.textTheme.bodySmall
                                      ?.copyWith(
                                    color:
                                        AppTheme.lightTheme.colorScheme.primary,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ],
                            ),
                          ),
                      ],
                    ),
                  ],
                ),
              ),

              SizedBox(height: 4.h),

              // Start journey button
              SizedBox(
                width: 80.w,
                height: 7.h,
                child: ElevatedButton(
                  onPressed: widget.onStartJourney,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppTheme.lightTheme.colorScheme.primary,
                    foregroundColor: Colors.white,
                    elevation: 8,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                    shadowColor: AppTheme.lightTheme.colorScheme.primary
                        .withValues(alpha: 0.4),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'Start My Learning Journey',
                        style:
                            AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(width: 2.w),
                      CustomIconWidget(
                        iconName: 'rocket_launch',
                        color: Colors.white,
                        size: 6.w,
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
