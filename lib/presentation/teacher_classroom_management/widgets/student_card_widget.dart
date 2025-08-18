import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class StudentCardWidget extends StatelessWidget {
  final Map<String, dynamic> student;
  final VoidCallback onTap;
  final VoidCallback onLongPress;

  const StudentCardWidget({
    Key? key,
    required this.student,
    required this.onTap,
    required this.onLongPress,
  }) : super(key: key);

  Color _getStatusColor() {
    final status = student['status'] as String? ?? 'inactive';
    switch (status) {
      case 'active':
        return AppTheme.lightTheme.colorScheme.primary;
      case 'learning':
        return AppTheme.lightTheme.colorScheme.secondary;
      case 'completed':
        return AppTheme.lightTheme.colorScheme.tertiary;
      default:
        return AppTheme.lightTheme.colorScheme.onSurfaceVariant;
    }
  }

  String _getStatusText() {
    final status = student['status'] as String? ?? 'inactive';
    switch (status) {
      case 'active':
        return 'Active';
      case 'learning':
        return 'Learning';
      case 'completed':
        return 'Completed';
      default:
        return 'Inactive';
    }
  }

  @override
  Widget build(BuildContext context) {
    final name = student['name'] as String? ?? 'Unknown Student';
    final xp = student['xp'] as int? ?? 0;
    final avatar = student['avatar'] as String? ?? '';
    final lastActivity =
        student['lastActivity'] as String? ?? 'No recent activity';
    final engagementLevel = student['engagementLevel'] as String? ?? 'low';

    return GestureDetector(
      onTap: onTap,
      onLongPress: onLongPress,
      child: Container(
        margin: EdgeInsets.symmetric(horizontal: 4.w, vertical: 1.h),
        padding: EdgeInsets.all(4.w),
        decoration: BoxDecoration(
          color: AppTheme.lightTheme.colorScheme.surface,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: _getStatusColor().withValues(alpha: 0.3),
            width: 2,
          ),
          boxShadow: [
            BoxShadow(
              color: AppTheme.lightTheme.colorScheme.shadow,
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  width: 12.w,
                  height: 12.w,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: _getStatusColor(),
                      width: 2,
                    ),
                  ),
                  child: ClipOval(
                    child: avatar.isNotEmpty
                        ? CustomImageWidget(
                            imageUrl: avatar,
                            width: 12.w,
                            height: 12.w,
                            fit: BoxFit.cover,
                          )
                        : Container(
                            color: AppTheme
                                .lightTheme.colorScheme.primaryContainer,
                            child: Center(
                              child: Text(
                                name.isNotEmpty ? name[0].toUpperCase() : 'S',
                                style: AppTheme.lightTheme.textTheme.titleMedium
                                    ?.copyWith(
                                  color: AppTheme.lightTheme.colorScheme
                                      .onPrimaryContainer,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                          ),
                  ),
                ),
                SizedBox(width: 3.w),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        name,
                        style:
                            AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.w600,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      SizedBox(height: 0.5.h),
                      Row(
                        children: [
                          CustomIconWidget(
                            iconName: 'star',
                            color: AppTheme.lightTheme.colorScheme.secondary,
                            size: 16,
                          ),
                          SizedBox(width: 1.w),
                          Text(
                            '$xp XP',
                            style: AppTheme.lightTheme.textTheme.bodySmall
                                ?.copyWith(
                              color: AppTheme.lightTheme.colorScheme.secondary,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                Container(
                  padding:
                      EdgeInsets.symmetric(horizontal: 2.w, vertical: 0.5.h),
                  decoration: BoxDecoration(
                    color: _getStatusColor().withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    _getStatusText(),
                    style: AppTheme.lightTheme.textTheme.labelSmall?.copyWith(
                      color: _getStatusColor(),
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 2.h),
            Row(
              children: [
                CustomIconWidget(
                  iconName: 'access_time',
                  color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                  size: 14,
                ),
                SizedBox(width: 1.w),
                Expanded(
                  child: Text(
                    lastActivity,
                    style: AppTheme.lightTheme.textTheme.bodySmall,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
            SizedBox(height: 1.h),
            Row(
              children: [
                Expanded(
                  child: Container(
                    height: 0.5.h,
                    decoration: BoxDecoration(
                      color: AppTheme.lightTheme.colorScheme.outline
                          .withValues(alpha: 0.3),
                      borderRadius: BorderRadius.circular(2),
                    ),
                    child: FractionallySizedBox(
                      alignment: Alignment.centerLeft,
                      widthFactor: engagementLevel == 'high'
                          ? 0.8
                          : engagementLevel == 'medium'
                              ? 0.5
                              : 0.2,
                      child: Container(
                        decoration: BoxDecoration(
                          color: engagementLevel == 'high'
                              ? AppTheme.lightTheme.colorScheme.primary
                              : engagementLevel == 'medium'
                                  ? AppTheme.lightTheme.colorScheme.secondary
                                  : AppTheme
                                      .lightTheme.colorScheme.onSurfaceVariant,
                          borderRadius: BorderRadius.circular(2),
                        ),
                      ),
                    ),
                  ),
                ),
                SizedBox(width: 2.w),
                Text(
                  '${engagementLevel.toUpperCase()} ENGAGEMENT',
                  style: AppTheme.lightTheme.textTheme.labelSmall?.copyWith(
                    fontWeight: FontWeight.w500,
                    letterSpacing: 0.5,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
