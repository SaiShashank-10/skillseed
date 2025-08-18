import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class ProgressIndicatorWidget extends StatefulWidget {
  final int currentStep;
  final int totalSteps;
  final List<String> stepTitles;

  const ProgressIndicatorWidget({
    Key? key,
    required this.currentStep,
    required this.totalSteps,
    required this.stepTitles,
  }) : super(key: key);

  @override
  State<ProgressIndicatorWidget> createState() =>
      _ProgressIndicatorWidgetState();
}

class _ProgressIndicatorWidgetState extends State<ProgressIndicatorWidget>
    with TickerProviderStateMixin {
  late AnimationController _growthController;
  late Animation<double> _growthAnimation;

  @override
  void initState() {
    super.initState();
    _growthController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );

    _growthAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _growthController,
      curve: Curves.easeInOut,
    ));

    _growthController.forward();
  }

  @override
  void didUpdateWidget(ProgressIndicatorWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.currentStep != widget.currentStep) {
      _growthController.reset();
      _growthController.forward();
    }
  }

  @override
  void dispose() {
    _growthController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 100.w,
      padding: EdgeInsets.symmetric(horizontal: 6.w, vertical: 2.h),
      child: Column(
        children: [
          // Plant growth visualization
          Container(
            height: 12.h,
            child: Stack(
              alignment: Alignment.bottomCenter,
              children: [
                // Soil base
                Container(
                  width: 100.w,
                  height: 3.h,
                  decoration: BoxDecoration(
                    color: const Color(0xFF8D6E63),
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),

                // Plant stem
                AnimatedBuilder(
                  animation: _growthAnimation,
                  builder: (context, child) {
                    final progress = widget.currentStep / widget.totalSteps;
                    final animatedProgress = progress * _growthAnimation.value;

                    return Positioned(
                      bottom: 3.h,
                      child: Container(
                        width: 1.w,
                        height: 9.h * animatedProgress,
                        decoration: BoxDecoration(
                          color: AppTheme.lightTheme.colorScheme.primary,
                          borderRadius: BorderRadius.circular(2),
                        ),
                      ),
                    );
                  },
                ),

                // Growth stages (leaves/flowers)
                ...List.generate(widget.totalSteps, (index) {
                  final stepProgress = (index + 1) / widget.totalSteps;
                  final isCompleted = widget.currentStep > index;
                  final isCurrent = widget.currentStep == index + 1;

                  return AnimatedBuilder(
                    animation: _growthAnimation,
                    builder: (context, child) {
                      final shouldShow = widget.currentStep >= index + 1;
                      final animationValue =
                          shouldShow ? _growthAnimation.value : 0.0;

                      return Positioned(
                        bottom: 3.h + (9.h * stepProgress) - 2.h,
                        left: 50.w - 3.w + (index.isEven ? -6.w : 6.w),
                        child: Transform.scale(
                          scale: animationValue,
                          child: Container(
                            width: 6.w,
                            height: 4.h,
                            decoration: BoxDecoration(
                              color: isCompleted
                                  ? AppTheme.lightTheme.colorScheme.primary
                                  : isCurrent
                                      ? AppTheme
                                          .lightTheme.colorScheme.secondary
                                      : AppTheme.lightTheme.colorScheme.outline
                                          .withValues(alpha: 0.3),
                              borderRadius: BorderRadius.circular(12),
                              border: isCurrent
                                  ? Border.all(
                                      color: AppTheme
                                          .lightTheme.colorScheme.secondary,
                                      width: 2,
                                    )
                                  : null,
                            ),
                            child: Center(
                              child: isCompleted
                                  ? CustomIconWidget(
                                      iconName: 'check',
                                      color: Colors.white,
                                      size: 3.w,
                                    )
                                  : isCurrent
                                      ? Container(
                                          width: 2.w,
                                          height: 2.w,
                                          decoration: BoxDecoration(
                                            color: Colors.white,
                                            shape: BoxShape.circle,
                                          ),
                                        )
                                      : null,
                            ),
                          ),
                        ),
                      );
                    },
                  );
                }),

                // Final flower/fruit
                if (widget.currentStep == widget.totalSteps)
                  Positioned(
                    bottom: 12.h,
                    child: AnimatedBuilder(
                      animation: _growthAnimation,
                      builder: (context, child) {
                        return Transform.scale(
                          scale: _growthAnimation.value,
                          child: Container(
                            padding: EdgeInsets.all(2.w),
                            decoration: BoxDecoration(
                              color: AppTheme.lightTheme.colorScheme.secondary
                                  .withValues(alpha: 0.2),
                              shape: BoxShape.circle,
                            ),
                            child: Text(
                              '🌸',
                              style: TextStyle(fontSize: 6.w),
                            ),
                          ),
                        );
                      },
                    ),
                  ),
              ],
            ),
          ),

          SizedBox(height: 2.h),

          // Progress bar
          Container(
            width: 100.w,
            height: 1.h,
            decoration: BoxDecoration(
              color: AppTheme.lightTheme.colorScheme.outline
                  .withValues(alpha: 0.3),
              borderRadius: BorderRadius.circular(4),
            ),
            child: AnimatedBuilder(
              animation: _growthAnimation,
              builder: (context, child) {
                final progress = widget.currentStep / widget.totalSteps;
                final animatedProgress = progress * _growthAnimation.value;

                return FractionallySizedBox(
                  alignment: Alignment.centerLeft,
                  widthFactor: animatedProgress,
                  child: Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          AppTheme.lightTheme.colorScheme.primary,
                          AppTheme.lightTheme.colorScheme.secondary,
                        ],
                        begin: Alignment.centerLeft,
                        end: Alignment.centerRight,
                      ),
                      borderRadius: BorderRadius.circular(4),
                    ),
                  ),
                );
              },
            ),
          ),

          SizedBox(height: 1.h),

          // Step indicator text
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                widget.currentStep > 0 &&
                        widget.currentStep <= widget.stepTitles.length
                    ? widget.stepTitles[widget.currentStep - 1]
                    : 'Getting Started',
                style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
                  color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                  fontWeight: FontWeight.w500,
                ),
              ),
              Text(
                '${widget.currentStep}/${widget.totalSteps}',
                style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                  color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
