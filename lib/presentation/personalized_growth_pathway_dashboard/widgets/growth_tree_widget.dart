import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';
import '../../../theme/app_theme.dart';

class GrowthTreeWidget extends StatefulWidget {
  final Map<String, dynamic> studentData;
  final Function(String) onBranchTap;

  const GrowthTreeWidget({
    Key? key,
    required this.studentData,
    required this.onBranchTap,
  }) : super(key: key);

  @override
  State<GrowthTreeWidget> createState() => _GrowthTreeWidgetState();
}

class _GrowthTreeWidgetState extends State<GrowthTreeWidget>
    with TickerProviderStateMixin {
  late AnimationController _treeAnimationController;
  late AnimationController _leafAnimationController;
  late Animation<double> _treeGrowthAnimation;
  late Animation<double> _leafScaleAnimation;

  @override
  void initState() {
    super.initState();
    _initializeAnimations();
  }

  void _initializeAnimations() {
    _treeAnimationController = AnimationController(
      duration: const Duration(milliseconds: 2000),
      vsync: this,
    );

    _leafAnimationController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );

    _treeGrowthAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _treeAnimationController,
      curve: Curves.easeOutCubic,
    ));

    _leafScaleAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _leafAnimationController,
      curve: Curves.elasticOut,
    ));

    _treeAnimationController.forward();
    Future.delayed(const Duration(milliseconds: 1500), () {
      if (mounted) _leafAnimationController.forward();
    });
  }

  @override
  void dispose() {
    _treeAnimationController.dispose();
    _leafAnimationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final skillAreas = (widget.studentData['skillAreas'] as List? ?? []);

    return Container(
      width: 90.w,
      height: 35.h,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            AppTheme.lightTheme.colorScheme.surface,
            AppTheme.lightTheme.colorScheme.surface.withValues(alpha: 0.8),
          ],
        ),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.1),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(16),
        child: Stack(
          children: [
            // Background gradient
            Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.bottomCenter,
                  end: Alignment.topCenter,
                  colors: [
                    AppTheme.lightTheme.colorScheme.primary
                        .withValues(alpha: 0.1),
                    Colors.transparent,
                  ],
                ),
              ),
            ),
            // Tree trunk and branches
            AnimatedBuilder(
              animation: _treeGrowthAnimation,
              builder: (context, child) {
                return CustomPaint(
                  size: Size(90.w, 35.h),
                  painter: TreePainter(
                    progress: _treeGrowthAnimation.value,
                    skillAreas: skillAreas,
                  ),
                );
              },
            ),
            // Interactive skill branches
            ...skillAreas.asMap().entries.map((entry) {
              final index = entry.key;
              final skill = entry.value as Map<String, dynamic>;
              return _buildSkillBranch(skill, index);
            }).toList(),
            // Floating leaves animation
            AnimatedBuilder(
              animation: _leafAnimationController,
              builder: (context, child) {
                return _buildFloatingLeaves();
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSkillBranch(Map<String, dynamic> skill, int index) {
    final skillName = skill['name'] as String? ?? '';
    final progress = (skill['progress'] as num? ?? 0).toDouble();
    final isUnlocked = skill['unlocked'] as bool? ?? false;

    // Position branches around the tree
    final positions = [
      {'left': 15.w, 'top': 20.h},
      {'left': 65.w, 'top': 18.h},
      {'left': 25.w, 'top': 12.h},
      {'left': 55.w, 'top': 10.h},
      {'left': 35.w, 'top': 8.h},
    ];

    final position = positions[index % positions.length];

    return AnimatedPositioned(
      duration: const Duration(milliseconds: 500),
      left: position['left'] as double,
      top: position['top'] as double,
      child: GestureDetector(
        onTap: isUnlocked ? () => widget.onBranchTap(skillName) : null,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          padding: EdgeInsets.symmetric(horizontal: 3.w, vertical: 1.h),
          decoration: BoxDecoration(
            color: isUnlocked
                ? AppTheme.lightTheme.colorScheme.primary.withValues(alpha: 0.9)
                : Colors.grey.withValues(alpha: 0.6),
            borderRadius: BorderRadius.circular(20),
            boxShadow: isUnlocked
                ? [
                    BoxShadow(
                      color: AppTheme.lightTheme.colorScheme.primary
                          .withValues(alpha: 0.3),
                      blurRadius: 8,
                      spreadRadius: 2,
                    ),
                  ]
                : null,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                skillName,
                style: AppTheme.lightTheme.textTheme.labelSmall?.copyWith(
                  color: Colors.white,
                  fontWeight: FontWeight.w600,
                ),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 0.5.h),
              Container(
                width: 8.w,
                height: 0.5.h,
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.3),
                  borderRadius: BorderRadius.circular(2),
                ),
                child: FractionallySizedBox(
                  alignment: Alignment.centerLeft,
                  widthFactor: progress / 100,
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildFloatingLeaves() {
    return Stack(
      children: List.generate(6, (index) {
        final positions = [
          {'left': 20.w, 'top': 8.h},
          {'left': 70.w, 'top': 12.h},
          {'left': 45.w, 'top': 6.h},
          {'left': 30.w, 'top': 15.h},
          {'left': 60.w, 'top': 9.h},
          {'left': 40.w, 'top': 18.h},
        ];

        final position = positions[index];

        return AnimatedPositioned(
          duration: Duration(milliseconds: 800 + (index * 100)),
          left: position['left'] as double,
          top: position['top'] as double,
          child: Transform.scale(
            scale: _leafScaleAnimation.value,
            child: Container(
              width: 3.w,
              height: 3.w,
              decoration: BoxDecoration(
                color: AppTheme.lightTheme.colorScheme.secondary,
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: AppTheme.lightTheme.colorScheme.secondary
                        .withValues(alpha: 0.4),
                    blurRadius: 4,
                    spreadRadius: 1,
                  ),
                ],
              ),
            ),
          ),
        );
      }),
    );
  }
}

class TreePainter extends CustomPainter {
  final double progress;
  final List skillAreas;

  TreePainter({required this.progress, required this.skillAreas});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = AppTheme.lightTheme.colorScheme.primary.withValues(alpha: 0.8)
      ..strokeWidth = 4
      ..strokeCap = StrokeCap.round;

    final trunkHeight = size.height * 0.4 * progress;
    final trunkStart = Offset(size.width * 0.5, size.height * 0.9);
    final trunkEnd = Offset(size.width * 0.5, size.height * 0.9 - trunkHeight);

    // Draw trunk
    canvas.drawLine(trunkStart, trunkEnd, paint);

    if (progress > 0.3) {
      // Draw main branches
      final branchPaint = Paint()
        ..color = AppTheme.lightTheme.colorScheme.primary.withValues(alpha: 0.7)
        ..strokeWidth = 3
        ..strokeCap = StrokeCap.round;

      final branchProgress = (progress - 0.3) / 0.7;

      // Left main branch
      final leftBranchEnd = Offset(
        size.width * 0.3,
        size.height * 0.6 - (size.height * 0.1 * branchProgress),
      );
      canvas.drawLine(trunkEnd, leftBranchEnd, branchPaint);

      // Right main branch
      final rightBranchEnd = Offset(
        size.width * 0.7,
        size.height * 0.6 - (size.height * 0.1 * branchProgress),
      );
      canvas.drawLine(trunkEnd, rightBranchEnd, branchPaint);

      if (progress > 0.6) {
        // Draw smaller branches
        final smallBranchPaint = Paint()
          ..color =
              AppTheme.lightTheme.colorScheme.primary.withValues(alpha: 0.6)
          ..strokeWidth = 2
          ..strokeCap = StrokeCap.round;

        final smallBranchProgress = (progress - 0.6) / 0.4;

        // Small branches from left main branch
        canvas.drawLine(
          leftBranchEnd,
          Offset(size.width * 0.2,
              size.height * 0.4 - (size.height * 0.05 * smallBranchProgress)),
          smallBranchPaint,
        );

        // Small branches from right main branch
        canvas.drawLine(
          rightBranchEnd,
          Offset(size.width * 0.8,
              size.height * 0.4 - (size.height * 0.05 * smallBranchProgress)),
          smallBranchPaint,
        );
      }
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
