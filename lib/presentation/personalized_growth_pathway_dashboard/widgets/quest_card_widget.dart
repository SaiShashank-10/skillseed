import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class QuestCardWidget extends StatefulWidget {
  final Map<String, dynamic> quest;
  final Function(String) onQuestTap;
  final Function(String, String) onQuickAction;

  const QuestCardWidget({
    Key? key,
    required this.quest,
    required this.onQuestTap,
    required this.onQuickAction,
  }) : super(key: key);

  @override
  State<QuestCardWidget> createState() => _QuestCardWidgetState();
}

class _QuestCardWidgetState extends State<QuestCardWidget>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _scaleAnimation;
  bool _showQuickActions = false;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 200),
      vsync: this,
    );
    _scaleAnimation = Tween<double>(begin: 1.0, end: 0.95).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final questId = widget.quest['id'] as String? ?? '';
    final title = widget.quest['title'] as String? ?? '';
    final description = widget.quest['description'] as String? ?? '';
    final progress = (widget.quest['progress'] as num? ?? 0).toDouble();
    final timeRemaining = widget.quest['timeRemaining'] as String? ?? '';
    final difficulty = widget.quest['difficulty'] as String? ?? 'Easy';
    final xpReward = (widget.quest['xpReward'] as num? ?? 0).toInt();
    final category = widget.quest['category'] as String? ?? '';
    final isCompleted = widget.quest['isCompleted'] as bool? ?? false;

    return AnimatedBuilder(
      animation: _scaleAnimation,
      builder: (context, child) {
        return Transform.scale(
          scale: _scaleAnimation.value,
          child: GestureDetector(
            onTap: () => widget.onQuestTap(questId),
            onLongPress: _handleLongPress,
            onTapDown: (_) => _animationController.forward(),
            onTapUp: (_) => _animationController.reverse(),
            onTapCancel: () => _animationController.reverse(),
            child: Container(
              width: 70.w,
              margin: EdgeInsets.only(right: 4.w),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: isCompleted
                      ? [
                          AppTheme.lightTheme.colorScheme.secondary
                              .withValues(alpha: 0.8),
                          AppTheme.lightTheme.colorScheme.secondary
                              .withValues(alpha: 0.6),
                        ]
                      : [
                          AppTheme.lightTheme.colorScheme.surface,
                          AppTheme.lightTheme.colorScheme.surface
                              .withValues(alpha: 0.9),
                        ],
                ),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(
                  color: isCompleted
                      ? AppTheme.lightTheme.colorScheme.secondary
                      : AppTheme.lightTheme.colorScheme.outline
                          .withValues(alpha: 0.2),
                  width: 1,
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.08),
                    blurRadius: 8,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Stack(
                children: [
                  Padding(
                    padding: EdgeInsets.all(4.w),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildQuestHeader(
                            category, difficulty, xpReward, isCompleted),
                        SizedBox(height: 2.h),
                        _buildQuestContent(title, description),
                        SizedBox(height: 2.h),
                        _buildProgressSection(
                            progress, timeRemaining, isCompleted),
                      ],
                    ),
                  ),
                  if (_showQuickActions) _buildQuickActionsOverlay(questId),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildQuestHeader(
      String category, String difficulty, int xpReward, bool isCompleted) {
    return Row(
      children: [
        Container(
          padding: EdgeInsets.symmetric(horizontal: 2.w, vertical: 0.5.h),
          decoration: BoxDecoration(
            color: _getCategoryColor(category).withValues(alpha: 0.2),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Text(
            category,
            style: AppTheme.lightTheme.textTheme.labelSmall?.copyWith(
              color: _getCategoryColor(category),
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
        const Spacer(),
        if (isCompleted)
          CustomIconWidget(
            iconName: 'check_circle',
            color: AppTheme.lightTheme.colorScheme.secondary,
            size: 20,
          )
        else
          Row(
            children: [
              CustomIconWidget(
                iconName: 'star',
                color: AppTheme.lightTheme.colorScheme.secondary,
                size: 16,
              ),
              SizedBox(width: 1.w),
              Text(
                '$xpReward XP',
                style: AppTheme.lightTheme.textTheme.labelSmall?.copyWith(
                  color: AppTheme.lightTheme.colorScheme.secondary,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
      ],
    );
  }

  Widget _buildQuestContent(String title, String description) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.w600,
          ),
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
        ),
        SizedBox(height: 1.h),
        Text(
          description,
          style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
            color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
          ),
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
        ),
      ],
    );
  }

  Widget _buildProgressSection(
      double progress, String timeRemaining, bool isCompleted) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              isCompleted ? 'Completed!' : 'Progress',
              style: AppTheme.lightTheme.textTheme.labelSmall?.copyWith(
                fontWeight: FontWeight.w500,
              ),
            ),
            if (!isCompleted && timeRemaining.isNotEmpty)
              Row(
                children: [
                  CustomIconWidget(
                    iconName: 'access_time',
                    color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                    size: 14,
                  ),
                  SizedBox(width: 1.w),
                  Text(
                    timeRemaining,
                    style: AppTheme.lightTheme.textTheme.labelSmall?.copyWith(
                      color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                    ),
                  ),
                ],
              ),
          ],
        ),
        SizedBox(height: 1.h),
        Container(
          width: double.infinity,
          height: 0.8.h,
          decoration: BoxDecoration(
            color:
                AppTheme.lightTheme.colorScheme.outline.withValues(alpha: 0.2),
            borderRadius: BorderRadius.circular(4),
          ),
          child: FractionallySizedBox(
            alignment: Alignment.centerLeft,
            widthFactor: isCompleted ? 1.0 : progress / 100,
            child: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: isCompleted
                      ? [
                          AppTheme.lightTheme.colorScheme.secondary,
                          AppTheme.lightTheme.colorScheme.secondary
                              .withValues(alpha: 0.8),
                        ]
                      : [
                          AppTheme.lightTheme.colorScheme.primary,
                          AppTheme.lightTheme.colorScheme.primary
                              .withValues(alpha: 0.8),
                        ],
                ),
                borderRadius: BorderRadius.circular(4),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildQuickActionsOverlay(String questId) {
    return Positioned.fill(
      child: Container(
        decoration: BoxDecoration(
          color: Colors.black.withValues(alpha: 0.7),
          borderRadius: BorderRadius.circular(16),
        ),
        child: Center(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _buildQuickActionButton('bookmark', 'Bookmark', questId),
              _buildQuickActionButton('share', 'Share', questId),
              _buildQuickActionButton('skip_next', 'Skip', questId),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildQuickActionButton(
      String iconName, String label, String questId) {
    return GestureDetector(
      onTap: () {
        widget.onQuickAction(questId, label.toLowerCase());
        setState(() => _showQuickActions = false);
      },
      child: Container(
        padding: EdgeInsets.all(3.w),
        decoration: BoxDecoration(
          color: AppTheme.lightTheme.colorScheme.surface,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            CustomIconWidget(
              iconName: iconName,
              color: AppTheme.lightTheme.colorScheme.primary,
              size: 24,
            ),
            SizedBox(height: 1.h),
            Text(
              label,
              style: AppTheme.lightTheme.textTheme.labelSmall,
            ),
          ],
        ),
      ),
    );
  }

  Color _getCategoryColor(String category) {
    switch (category.toLowerCase()) {
      case 'communication':
        return AppTheme.lightTheme.colorScheme.primary;
      case 'creativity':
        return AppTheme.lightTheme.colorScheme.secondary;
      case 'critical thinking':
        return AppTheme.lightTheme.colorScheme.tertiary;
      case 'leadership':
        return const Color(0xFF9C27B0);
      case 'teamwork':
        return const Color(0xFF4CAF50);
      default:
        return AppTheme.lightTheme.colorScheme.onSurfaceVariant;
    }
  }

  void _handleLongPress() {
    setState(() => _showQuickActions = !_showQuickActions);
  }
}
