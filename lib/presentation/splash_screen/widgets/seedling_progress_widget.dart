import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';
import '../../../theme/app_theme.dart';

class SeedlingProgressWidget extends StatefulWidget {
  final double progress;

  const SeedlingProgressWidget({
    Key? key,
    required this.progress,
  }) : super(key: key);

  @override
  State<SeedlingProgressWidget> createState() => _SeedlingProgressWidgetState();
}

class _SeedlingProgressWidgetState extends State<SeedlingProgressWidget>
    with TickerProviderStateMixin {
  late AnimationController _growthController;
  late AnimationController _leafController;
  late Animation<double> _stemHeight;
  late Animation<double> _leafScale;
  late Animation<double> _leafRotation;

  @override
  void initState() {
    super.initState();

    _growthController = AnimationController(
      duration: const Duration(milliseconds: 2000),
      vsync: this,
    );

    _leafController = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    );

    _stemHeight = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _growthController,
      curve: Curves.easeInOut,
    ));

    _leafScale = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _leafController,
      curve: Curves.elasticOut,
    ));

    _leafRotation = Tween<double>(
      begin: -0.2,
      end: 0.2,
    ).animate(CurvedAnimation(
      parent: _leafController,
      curve: Curves.easeInOut,
    ));

    _startGrowthAnimation();
  }

  void _startGrowthAnimation() async {
    await Future.delayed(const Duration(milliseconds: 800));
    _growthController.forward();
    await Future.delayed(const Duration(milliseconds: 1000));
    _leafController.repeat(reverse: true);
  }

  @override
  void didUpdateWidget(SeedlingProgressWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.progress != oldWidget.progress) {
      _growthController.animateTo(widget.progress);
    }
  }

  @override
  void dispose() {
    _growthController.dispose();
    _leafController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: Listenable.merge([_growthController, _leafController]),
      builder: (context, child) {
        return Container(
          width: 15.w,
          height: 8.h,
          child: Stack(
            alignment: Alignment.bottomCenter,
            children: [
              // Soil base
              Positioned(
                bottom: 0,
                child: Container(
                  width: 15.w,
                  height: 1.h,
                  decoration: BoxDecoration(
                    color: const Color(0xFF8D6E63),
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
              ),
              // Seedling stem
              Positioned(
                bottom: 1.h,
                child: Container(
                  width: 0.5.w,
                  height: 6.h * _stemHeight.value,
                  decoration: BoxDecoration(
                    color: AppTheme.lightTheme.colorScheme.primary,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),
              // Left leaf
              if (_stemHeight.value > 0.3)
                Positioned(
                  bottom: 1.h + (4.h * _stemHeight.value),
                  left: 6.w,
                  child: Transform.scale(
                    scale: _leafScale.value,
                    child: Transform.rotate(
                      angle: -0.5 + _leafRotation.value,
                      child: Container(
                        width: 3.w,
                        height: 2.h,
                        decoration: BoxDecoration(
                          color: AppTheme.lightTheme.colorScheme.primary,
                          borderRadius: const BorderRadius.only(
                            topLeft: Radius.circular(20),
                            topRight: Radius.circular(5),
                            bottomLeft: Radius.circular(5),
                            bottomRight: Radius.circular(20),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              // Right leaf
              if (_stemHeight.value > 0.5)
                Positioned(
                  bottom: 1.h + (3.h * _stemHeight.value),
                  right: 6.w,
                  child: Transform.scale(
                    scale: _leafScale.value,
                    child: Transform.rotate(
                      angle: 0.5 - _leafRotation.value,
                      child: Container(
                        width: 3.w,
                        height: 2.h,
                        decoration: BoxDecoration(
                          color: AppTheme.lightTheme.colorScheme.primary,
                          borderRadius: const BorderRadius.only(
                            topLeft: Radius.circular(5),
                            topRight: Radius.circular(20),
                            bottomLeft: Radius.circular(20),
                            bottomRight: Radius.circular(5),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              // Growth particles
              if (_stemHeight.value > 0.7)
                ...List.generate(3, (index) {
                  return Positioned(
                    bottom: 2.h + (index * 1.5.h),
                    left: 7.w + (index * 0.5.w),
                    child: AnimatedOpacity(
                      opacity: _leafScale.value * 0.6,
                      duration: const Duration(milliseconds: 300),
                      child: Container(
                        width: 0.8.w,
                        height: 0.8.w,
                        decoration: BoxDecoration(
                          color: AppTheme.lightTheme.colorScheme.secondary,
                          shape: BoxShape.circle,
                        ),
                      ),
                    ),
                  );
                }),
            ],
          ),
        );
      },
    );
  }
}
