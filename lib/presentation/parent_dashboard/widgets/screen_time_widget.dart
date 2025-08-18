import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class ScreenTimeWidget extends StatefulWidget {
  final Map<String, dynamic> screenTimeData;
  final Function(bool) onLimitToggle;

  const ScreenTimeWidget({
    super.key,
    required this.screenTimeData,
    required this.onLimitToggle,
  });

  @override
  State<ScreenTimeWidget> createState() => _ScreenTimeWidgetState();
}

class _ScreenTimeWidgetState extends State<ScreenTimeWidget> {
  bool isLimitEnabled = true;

  @override
  void initState() {
    super.initState();
    isLimitEnabled = widget.screenTimeData['isLimitEnabled'] as bool? ?? true;
  }

  @override
  Widget build(BuildContext context) {
    final dailyUsage = widget.screenTimeData['dailyUsage'] as List<dynamic>;
    final todayUsage = widget.screenTimeData['todayUsage'] as int;
    final dailyLimit = widget.screenTimeData['dailyLimit'] as int;
    final usagePercentage = todayUsage / dailyLimit;

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
                  offset: const Offset(0, 2)),
            ]),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
            Row(children: [
              CustomIconWidget(
                  iconName: 'screen_time',
                  color: AppTheme.lightTheme.colorScheme.tertiary,
                  size: 24),
              SizedBox(width: 3.w),
              Text('Screen Time',
                  style: AppTheme.lightTheme.textTheme.titleLarge
                      ?.copyWith(fontWeight: FontWeight.w600)),
            ]),
            Switch(
                value: isLimitEnabled,
                onChanged: (value) {
                  setState(() => isLimitEnabled = value);
                  widget.onLimitToggle(value);
                },
                activeColor: AppTheme.lightTheme.colorScheme.primary),
          ]),
          SizedBox(height: 3.h),
          _buildTodayUsageCard(todayUsage, dailyLimit, usagePercentage),
          SizedBox(height: 3.h),
          Text('Weekly Pattern',
              style: AppTheme.lightTheme.textTheme.titleMedium
                  ?.copyWith(fontWeight: FontWeight.w600)),
          SizedBox(height: 2.h),
          SizedBox(
              height: 25.h,
              child: BarChart(BarChartData(
                  alignment: BarChartAlignment.spaceAround,
                  maxY: dailyLimit.toDouble() * 1.2,
                  barTouchData: BarTouchData(
                      enabled: true,
                      touchTooltipData: BarTouchTooltipData(
                          getTooltipItem: (group, groupIndex, rod, rodIndex) {
                        final day = _getDayName(group.x.toInt());
                        final minutes = rod.toY.toInt();
                        final hours = minutes ~/ 60;
                        final remainingMinutes = minutes % 60;
                        return BarTooltipItem(
                            '$day\n${hours}h ${remainingMinutes}m',
                            AppTheme.lightTheme.textTheme.bodySmall!);
                      })),
                  titlesData: FlTitlesData(
                      show: true,
                      rightTitles: const AxisTitles(
                          sideTitles: SideTitles(showTitles: false)),
                      topTitles: const AxisTitles(
                          sideTitles: SideTitles(showTitles: false)),
                      bottomTitles: AxisTitles(
                          sideTitles: SideTitles(
                              showTitles: true,
                              getTitlesWidget: (double value, TitleMeta meta) {
                                return SideTitleWidget(
                                    axisSide: meta.axisSide,
                                    child: Text(
                                        _getDayName(value.toInt())
                                            .substring(0, 3),
                                        style: AppTheme
                                            .lightTheme.textTheme.bodySmall));
                              },
                              reservedSize: 30)),
                      leftTitles: AxisTitles(
                          sideTitles: SideTitles(
                              showTitles: true,
                              interval: 60,
                              getTitlesWidget: (double value, TitleMeta meta) {
                                final hours = value ~/ 60;
                                return Text('${hours}h',
                                    style: AppTheme
                                        .lightTheme.textTheme.bodySmall);
                              },
                              reservedSize: 40))),
                  borderData: FlBorderData(
                      show: true,
                      border: Border.all(
                          color: AppTheme.lightTheme.colorScheme.outline
                              .withValues(alpha: 0.2))),
                  barGroups: dailyUsage.asMap().entries.map((entry) {
                    final index = entry.key;
                    final usage = entry.value as int;
                    final isOverLimit = usage > dailyLimit;

                    return BarChartGroupData(x: index, barRods: [
                      BarChartRodData(
                          toY: usage.toDouble(),
                          color: isOverLimit
                              ? Colors.red.withValues(alpha: 0.8)
                              : AppTheme.lightTheme.colorScheme.tertiary
                                  .withValues(alpha: 0.8),
                          width: 6.w,
                          borderRadius: BorderRadius.circular(4),
                          backDrawRodData: BackgroundBarChartRodData(
                              show: true,
                              toY: dailyLimit.toDouble(),
                              color: AppTheme.lightTheme.colorScheme.outline
                                  .withValues(alpha: 0.1))),
                    ]);
                  }).toList(),
                  gridData: FlGridData(
                      show: true,
                      drawVerticalLine: false,
                      horizontalInterval: 60,
                      getDrawingHorizontalLine: (value) {
                        return FlLine(
                            color: AppTheme.lightTheme.colorScheme.outline
                                .withValues(alpha: 0.2),
                            strokeWidth: 1);
                      })))),
          SizedBox(height: 2.h),
          _buildControlsSection(),
        ]));
  }

  Widget _buildTodayUsageCard(
      int todayUsage, int dailyLimit, double usagePercentage) {
    final hours = todayUsage ~/ 60;
    final minutes = todayUsage % 60;
    final limitHours = dailyLimit ~/ 60;
    final limitMinutes = dailyLimit % 60;
    final isOverLimit = usagePercentage > 1.0;

    return Container(
        width: double.infinity,
        padding: EdgeInsets.all(4.w),
        decoration: BoxDecoration(
            gradient: LinearGradient(colors: [
              isOverLimit
                  ? Colors.red.withValues(alpha: 0.1)
                  : AppTheme.lightTheme.colorScheme.tertiary
                      .withValues(alpha: 0.1),
              isOverLimit
                  ? Colors.red.withValues(alpha: 0.05)
                  : AppTheme.lightTheme.colorScheme.primary
                      .withValues(alpha: 0.05),
            ], begin: Alignment.topLeft, end: Alignment.bottomRight),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
                color: isOverLimit
                    ? Colors.red.withValues(alpha: 0.3)
                    : AppTheme.lightTheme.colorScheme.tertiary
                        .withValues(alpha: 0.3))),
        child: Column(children: [
          Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
            Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Text('Today\'s Usage',
                  style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
                      color: AppTheme.lightTheme.colorScheme.onSurfaceVariant)),
              Text('${hours}h ${minutes}m',
                  style: AppTheme.lightTheme.textTheme.headlineMedium?.copyWith(
                      color: isOverLimit
                          ? Colors.red
                          : AppTheme.lightTheme.colorScheme.tertiary,
                      fontWeight: FontWeight.w700)),
            ]),
            Column(crossAxisAlignment: CrossAxisAlignment.end, children: [
              Text('Daily Limit',
                  style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
                      color: AppTheme.lightTheme.colorScheme.onSurfaceVariant)),
              Text('${limitHours}h ${limitMinutes}m',
                  style: AppTheme.lightTheme.textTheme.titleLarge?.copyWith(
                      color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                      fontWeight: FontWeight.w600)),
            ]),
          ]),
          SizedBox(height: 2.h),
          LinearProgressIndicator(
              value: usagePercentage > 1.0 ? 1.0 : usagePercentage,
              backgroundColor: AppTheme.lightTheme.colorScheme.outline
                  .withValues(alpha: 0.2),
              valueColor: AlwaysStoppedAnimation<Color>(isOverLimit
                  ? Colors.red
                  : AppTheme.lightTheme.colorScheme.tertiary),
              minHeight: 8),
          SizedBox(height: 1.h),
          Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
            Text(
                isOverLimit
                    ? 'Limit exceeded by ${((usagePercentage - 1) * 100).toInt()}%'
                    : '${((1 - usagePercentage) * 100).toInt()}% remaining',
                style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                    color: isOverLimit
                        ? Colors.red
                        : AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                    fontWeight: FontWeight.w500)),
            if (isOverLimit)
              CustomIconWidget(
                  iconName: 'warning', color: Colors.red, size: 16),
          ]),
        ]));
  }

  Widget _buildControlsSection() {
    return Container(
        width: double.infinity,
        padding: EdgeInsets.all(3.w),
        decoration: BoxDecoration(
            color:
                AppTheme.lightTheme.colorScheme.primary.withValues(alpha: 0.05),
            borderRadius: BorderRadius.circular(12)),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text('Parental Controls',
              style: AppTheme.lightTheme.textTheme.titleSmall
                  ?.copyWith(fontWeight: FontWeight.w600)),
          SizedBox(height: 2.h),
          Row(children: [
            Expanded(
                child: ElevatedButton.icon(
                    onPressed: () {
                      // Handle adjust limits
                    },
                    icon: CustomIconWidget(
                        iconName: 'schedule', color: Colors.white, size: 16),
                    label: const Text('Adjust Limits'),
                    style: ElevatedButton.styleFrom(
                        backgroundColor:
                            AppTheme.lightTheme.colorScheme.primary,
                        foregroundColor: Colors.white,
                        padding: EdgeInsets.symmetric(vertical: 2.h)))),
            SizedBox(width: 3.w),
            Expanded(
                child: OutlinedButton.icon(
                    onPressed: () {
                      // Handle view detailed report
                    },
                    icon: CustomIconWidget(
                        iconName: 'analytics',
                        color: AppTheme.lightTheme.colorScheme.primary,
                        size: 16),
                    label: const Text('View Report'),
                    style: OutlinedButton.styleFrom(
                        padding: EdgeInsets.symmetric(vertical: 2.h)))),
          ]),
        ]));
  }

  String _getDayName(int index) {
    const days = [
      'Monday',
      'Tuesday',
      'Wednesday',
      'Thursday',
      'Friday',
      'Saturday',
      'Sunday'
    ];
    return days[index % days.length];
  }
}
