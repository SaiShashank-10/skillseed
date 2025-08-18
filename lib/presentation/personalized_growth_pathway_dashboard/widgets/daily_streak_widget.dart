import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class DailyStreakWidget extends StatefulWidget {
  final int currentStreak;
  final int longestStreak;
  final bool todayCompleted;
  final Function() onStreakTap;

  const DailyStreakWidget({
    Key? key,
    required this.currentStreak,
    required this.longestStreak,
    required this.todayCompleted,
    required this.onStreakTap,
  }) : super(key: key);

  @override
  State<DailyStreakWidget> createState() => _DailyStreakWidgetState();
}

class _DailyStreakWidgetState extends State<DailyStreakWidget>
    with TickerProviderStateMixin {
  late AnimationController _flameAnimationController;
  late AnimationController _celebrationController;
  late Animation<double> _flameScaleAnimation;
  late Animation<double> _celebrationAnimation;

  @override
  void initState() {
    super.initState();
    _initializeAnimations();
  }

  void _initializeAnimations() {
    _flameAnimationController = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    );

    _celebrationController = AnimationController(
      duration: const Duration(milliseconds: 2000),
      vsync: this,
    );

    _flameScaleAnimation = Tween<double>(
      begin: 0.8,
      end: 1.2,
    ).animate(CurvedAnimation(
      parent: _flameAnimationController,
      curve: Curves.easeInOut,
    ));

    _celebrationAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _celebrationController,
      curve: Curves.elasticOut,
    ));

    _flameAnimationController.repeat(reverse: true);

    // Trigger celebration for milestones
    if (_isMilestone(widget.currentStreak)) {
      Future.delayed(const Duration(milliseconds: 500), () {
        if (mounted) _celebrationController.forward();
      });
    }
  }

  @override
  void dispose() {
    _flameAnimationController.dispose();
    _celebrationController.dispose();
    super.dispose();
  }

  bool _isMilestone(int streak) {
    return streak > 0 &&
        (streak % 7 == 0 || streak % 30 == 0 || streak % 100 == 0);
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: widget.onStreakTap,
      child: Container(
        width: 90.w,
        padding: EdgeInsets.all(4.w),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: widget.todayCompleted
                ? [
                    AppTheme.lightTheme.colorScheme.secondary
                        .withValues(alpha: 0.2),
                    AppTheme.lightTheme.colorScheme.secondary
                        .withValues(alpha: 0.1),
                  ]
                : [
                    AppTheme.lightTheme.colorScheme.surface,
                    AppTheme.lightTheme.colorScheme.surface
                        .withValues(alpha: 0.8),
                  ],
          ),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: widget.todayCompleted
                ? AppTheme.lightTheme.colorScheme.secondary
                    .withValues(alpha: 0.3)
                : AppTheme.lightTheme.colorScheme.outline
                    .withValues(alpha: 0.2),
            width: 1,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.05),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Stack(
          children: [
            Row(
              children: [
                _buildFlameIcon(),
                SizedBox(width: 4.w),
                Expanded(child: _buildStreakInfo()),
                _buildStreakStats(),
              ],
            ),
            if (_isMilestone(widget.currentStreak))
              AnimatedBuilder(
                animation: _celebrationAnimation,
                builder: (context, child) => _buildCelebrationOverlay(),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildFlameIcon() {
    return AnimatedBuilder(
      animation: _flameScaleAnimation,
      builder: (context, child) {
        return Transform.scale(
          scale: widget.todayCompleted ? _flameScaleAnimation.value : 1.0,
          child: Container(
            width: 12.w,
            height: 12.w,
            decoration: BoxDecoration(
              gradient: RadialGradient(
                colors: widget.todayCompleted
                    ? [
                        AppTheme.lightTheme.colorScheme.secondary,
                        AppTheme.lightTheme.colorScheme.secondary
                            .withValues(alpha: 0.7),
                      ]
                    : [
                        Colors.grey.withValues(alpha: 0.6),
                        Colors.grey.withValues(alpha: 0.4),
                      ],
              ),
              shape: BoxShape.circle,
              boxShadow: widget.todayCompleted
                  ? [
                      BoxShadow(
                        color: AppTheme.lightTheme.colorScheme.secondary
                            .withValues(alpha: 0.4),
                        blurRadius: 12,
                        spreadRadius: 2,
                      ),
                    ]
                  : null,
            ),
            child: Center(
              child: CustomIconWidget(
                iconName: 'local_fire_department',
                color: Colors.white,
                size: 24,
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildStreakInfo() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Daily Streak',
          style: AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.w600,
          ),
        ),
        SizedBox(height: 0.5.h),
        Text(
          widget.todayCompleted
              ? 'Great job! Keep it up!'
              : 'Complete today\'s quest to continue',
          style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
            color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
          ),
        ),
        SizedBox(height: 1.h),
        _buildStreakProgress(),
      ],
    );
  }

  Widget _buildStreakProgress() {
    final nextMilestone = _getNextMilestone(widget.currentStreak);
    final progress = widget.currentStreak / nextMilestone;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Next milestone: $nextMilestone days',
              style: AppTheme.lightTheme.textTheme.labelSmall,
            ),
            Text(
              '${widget.currentStreak}/$nextMilestone',
              style: AppTheme.lightTheme.textTheme.labelSmall?.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
        SizedBox(height: 0.5.h),
        Container(
          width: double.infinity,
          height: 0.6.h,
          decoration: BoxDecoration(
            color:
                AppTheme.lightTheme.colorScheme.outline.withValues(alpha: 0.2),
            borderRadius: BorderRadius.circular(3),
          ),
          child: FractionallySizedBox(
            alignment: Alignment.centerLeft,
            widthFactor: progress.clamp(0.0, 1.0),
            child: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    AppTheme.lightTheme.colorScheme.secondary,
                    AppTheme.lightTheme.colorScheme.secondary
                        .withValues(alpha: 0.8),
                  ],
                ),
                borderRadius: BorderRadius.circular(3),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildStreakStats() {
    return Column(
      children: [
        Container(
          padding: EdgeInsets.symmetric(horizontal: 3.w, vertical: 1.h),
          decoration: BoxDecoration(
            color:
                AppTheme.lightTheme.colorScheme.primary.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Column(
            children: [
              Text(
                '${widget.currentStreak}',
                style: AppTheme.lightTheme.textTheme.headlineSmall?.copyWith(
                  color: AppTheme.lightTheme.colorScheme.primary,
                  fontWeight: FontWeight.w700,
                ),
              ),
              Text(
                'Current',
                style: AppTheme.lightTheme.textTheme.labelSmall?.copyWith(
                  color: AppTheme.lightTheme.colorScheme.primary,
                ),
              ),
            ],
          ),
        ),
        SizedBox(height: 1.h),
        Container(
          padding: EdgeInsets.symmetric(horizontal: 3.w, vertical: 1.h),
          decoration: BoxDecoration(
            color:
                AppTheme.lightTheme.colorScheme.tertiary.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Column(
            children: [
              Text(
                '${widget.longestStreak}',
                style: AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
                  color: AppTheme.lightTheme.colorScheme.tertiary,
                  fontWeight: FontWeight.w600,
                ),
              ),
              Text(
                'Best',
                style: AppTheme.lightTheme.textTheme.labelSmall?.copyWith(
                  color: AppTheme.lightTheme.colorScheme.tertiary,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildCelebrationOverlay() {
    return Positioned.fill(
      child: Container(
        decoration: BoxDecoration(
          gradient: RadialGradient(
            colors: [
              AppTheme.lightTheme.colorScheme.secondary
                  .withValues(alpha: 0.3 * _celebrationAnimation.value),
              Colors.transparent,
            ],
          ),
          borderRadius: BorderRadius.circular(16),
        ),
        child: Center(
          child: Transform.scale(
            scale: _celebrationAnimation.value,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                CustomIconWidget(
                  iconName: 'celebration',
                  color: AppTheme.lightTheme.colorScheme.secondary,
                  size: 32,
                ),
                SizedBox(height: 1.h),
                Text(
                  'Milestone Reached!',
                  style: AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
                    color: AppTheme.lightTheme.colorScheme.secondary,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  int _getNextMilestone(int currentStreak) {
    if (currentStreak < 7) return 7;
    if (currentStreak < 30) return 30;
    if (currentStreak < 100) return 100;
    return ((currentStreak ~/ 100) + 1) * 100;
  }
}
