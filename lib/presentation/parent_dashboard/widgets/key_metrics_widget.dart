import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class KeyMetricsWidget extends StatelessWidget {
  final Map<String, dynamic> metricsData;

  const KeyMetricsWidget({
    super.key,
    required this.metricsData,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(4.w),
      decoration: BoxDecoration(
        color: AppTheme.lightTheme.colorScheme.surface,
        borderRadius: BorderRadius.circular(16),
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
              CustomIconWidget(
                iconName: 'analytics',
                color: AppTheme.lightTheme.colorScheme.primary,
                size: 24,
              ),
              SizedBox(width: 3.w),
              Text(
                'Weekly Overview',
                style: AppTheme.lightTheme.textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
          SizedBox(height: 3.h),
          Row(
            children: [
              Expanded(
                child: _buildMetricCard(
                  context,
                  'Learning Time',
                  '${metricsData['weeklyLearningTime']} hrs',
                  metricsData['learningTimeProgress'] as double,
                  'schedule',
                  AppTheme.lightTheme.colorScheme.primary,
                  '${metricsData['learningTimeTrend']}% vs last week',
                  metricsData['learningTimeTrend'] > 0,
                ),
              ),
              SizedBox(width: 3.w),
              Expanded(
                child: _buildMetricCard(
                  context,
                  'XP Gained',
                  '${metricsData['xpGained']}',
                  metricsData['xpProgress'] as double,
                  'stars',
                  AppTheme.lightTheme.colorScheme.secondary,
                  '${metricsData['xpTrend']}% vs last week',
                  metricsData['xpTrend'] > 0,
                ),
              ),
            ],
          ),
          SizedBox(height: 2.h),
          _buildMetricCard(
            context,
            'Completed Activities',
            '${metricsData['completedActivities']}/${metricsData['totalActivities']}',
            metricsData['activitiesProgress'] as double,
            'task_alt',
            AppTheme.lightTheme.colorScheme.tertiary,
            '${metricsData['activitiesTrend']}% completion rate',
            metricsData['activitiesTrend'] > 75,
          ),
        ],
      ),
    );
  }

  Widget _buildMetricCard(
    BuildContext context,
    String title,
    String value,
    double progress,
    String iconName,
    Color color,
    String trend,
    bool isPositive,
  ) {
    return Container(
      padding: EdgeInsets.all(3.w),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: color.withValues(alpha: 0.2),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              CustomIconWidget(
                iconName: iconName,
                color: color,
                size: 20,
              ),
              SizedBox(width: 2.w),
              Expanded(
                child: Text(
                  title,
                  style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
                    color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
          SizedBox(height: 1.h),
          Text(
            value,
            style: AppTheme.lightTheme.textTheme.headlineSmall?.copyWith(
              color: color,
              fontWeight: FontWeight.w700,
            ),
          ),
          SizedBox(height: 1.h),
          LinearProgressIndicator(
            value: progress,
            backgroundColor: color.withValues(alpha: 0.2),
            valueColor: AlwaysStoppedAnimation<Color>(color),
            minHeight: 4,
          ),
          SizedBox(height: 1.h),
          Row(
            children: [
              CustomIconWidget(
                iconName: isPositive ? 'trending_up' : 'trending_down',
                color: isPositive ? Colors.green : Colors.orange,
                size: 16,
              ),
              SizedBox(width: 1.w),
              Expanded(
                child: Text(
                  trend,
                  style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                    color: isPositive ? Colors.green : Colors.orange,
                    fontWeight: FontWeight.w500,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
