import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class GrowthChartWidget extends StatefulWidget {
  final List<Map<String, dynamic>> skillData;
  final Function(String) onSkillTap;

  const GrowthChartWidget({
    super.key,
    required this.skillData,
    required this.onSkillTap,
  });

  @override
  State<GrowthChartWidget> createState() => _GrowthChartWidgetState();
}

class _GrowthChartWidgetState extends State<GrowthChartWidget> {
  String selectedPeriod = '1M';
  final List<String> periods = ['1W', '1M', '3M', '6M'];

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
                  offset: const Offset(0, 2)),
            ]),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
            Row(children: [
              CustomIconWidget(
                  iconName: 'trending_up',
                  color: AppTheme.lightTheme.colorScheme.primary,
                  size: 24),
              SizedBox(width: 3.w),
              Text('Skill Development',
                  style: AppTheme.lightTheme.textTheme.titleLarge
                      ?.copyWith(fontWeight: FontWeight.w600)),
            ]),
            Container(
                decoration: BoxDecoration(
                    color: AppTheme.lightTheme.colorScheme.primary
                        .withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(20)),
                child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: periods.map((period) {
                      final isSelected = period == selectedPeriod;
                      return GestureDetector(
                          onTap: () => setState(() => selectedPeriod = period),
                          child: Container(
                              padding: EdgeInsets.symmetric(
                                  horizontal: 3.w, vertical: 1.h),
                              decoration: BoxDecoration(
                                  color: isSelected
                                      ? AppTheme.lightTheme.colorScheme.primary
                                      : Colors.transparent,
                                  borderRadius: BorderRadius.circular(16)),
                              child: Text(period,
                                  style: AppTheme.lightTheme.textTheme.bodySmall
                                      ?.copyWith(
                                          color: isSelected
                                              ? Colors.white
                                              : AppTheme.lightTheme.colorScheme
                                                  .primary,
                                          fontWeight: FontWeight.w500))));
                    }).toList())),
          ]),
          SizedBox(height: 3.h),
          SizedBox(
              height: 30.h,
              child: LineChart(LineChartData(
                  gridData: FlGridData(
                      show: true,
                      drawVerticalLine: false,
                      horizontalInterval: 20,
                      getDrawingHorizontalLine: (value) {
                        return FlLine(
                            color: AppTheme.lightTheme.colorScheme.outline
                                .withValues(alpha: 0.2),
                            strokeWidth: 1);
                      }),
                  titlesData: FlTitlesData(
                      show: true,
                      rightTitles: const AxisTitles(
                          sideTitles: SideTitles(showTitles: false)),
                      topTitles: const AxisTitles(
                          sideTitles: SideTitles(showTitles: false)),
                      bottomTitles: AxisTitles(
                          sideTitles: SideTitles(
                              showTitles: true,
                              reservedSize: 30,
                              interval: 1,
                              getTitlesWidget: (double value, TitleMeta meta) {
                                const style = TextStyle(
                                    fontSize: 10, fontWeight: FontWeight.w400);
                                Widget text;
                                switch (value.toInt()) {
                                  case 0:
                                    text = const Text('Week 1', style: style);
                                    break;
                                  case 1:
                                    text = const Text('Week 2', style: style);
                                    break;
                                  case 2:
                                    text = const Text('Week 3', style: style);
                                    break;
                                  case 3:
                                    text = const Text('Week 4', style: style);
                                    break;
                                  default:
                                    text = const Text('', style: style);
                                    break;
                                }
                                return SideTitleWidget(
                                    axisSide: meta.axisSide, child: text);
                              })),
                      leftTitles: AxisTitles(
                          sideTitles: SideTitles(
                              showTitles: true,
                              interval: 20,
                              getTitlesWidget: (double value, TitleMeta meta) {
                                return Text(value.toInt().toString(),
                                    style: const TextStyle(
                                        fontSize: 10,
                                        fontWeight: FontWeight.w400));
                              },
                              reservedSize: 32))),
                  borderData: FlBorderData(
                      show: true,
                      border: Border.all(
                          color: AppTheme.lightTheme.colorScheme.outline
                              .withValues(alpha: 0.2))),
                  minX: 0,
                  maxX: 3,
                  minY: 0,
                  maxY: 100,
                  lineBarsData: _buildLineChartData(),
                  lineTouchData: LineTouchData(
                      enabled: true,
                      touchCallback: (FlTouchEvent event,
                          LineTouchResponse? touchResponse) {
                        if (touchResponse != null &&
                            touchResponse.lineBarSpots != null) {
                          final spot = touchResponse.lineBarSpots!.first;
                          final skillIndex = spot.barIndex;
                          if (skillIndex < widget.skillData.length) {
                            widget.onSkillTap(
                                widget.skillData[skillIndex]['name'] as String);
                          }
                        }
                      },
                      touchTooltipData: LineTouchTooltipData(
                          getTooltipItems: (List<LineBarSpot> touchedBarSpots) {
                        return touchedBarSpots.map((barSpot) {
                          final skillIndex = barSpot.barIndex;
                          final skillName = skillIndex < widget.skillData.length
                              ? widget.skillData[skillIndex]['name'] as String
                              : 'Skill';
                          return LineTooltipItem(
                              '$skillName\n${barSpot.y.toInt()}%',
                              AppTheme.lightTheme.textTheme.bodySmall!);
                        }).toList();
                      }))))),
          SizedBox(height: 2.h),
          _buildSkillLegend(),
        ]));
  }

  List<LineChartBarData> _buildLineChartData() {
    final colors = [
      AppTheme.lightTheme.colorScheme.primary,
      AppTheme.lightTheme.colorScheme.secondary,
      AppTheme.lightTheme.colorScheme.tertiary,
      Colors.green,
      Colors.orange,
    ];

    return widget.skillData.asMap().entries.map((entry) {
      final index = entry.key;
      final skill = entry.value;
      final progressData = skill['progressData'] as List<dynamic>;

      return LineChartBarData(
          spots: progressData.asMap().entries.map((dataEntry) {
            return FlSpot(
                dataEntry.key.toDouble(), (dataEntry.value as num).toDouble());
          }).toList(),
          isCurved: true,
          color: colors[index % colors.length],
          barWidth: 3,
          isStrokeCapRound: true,
          dotData: FlDotData(
              show: true,
              getDotPainter: (spot, percent, barData, index) {
                return FlDotCirclePainter(
                    radius: 4,
                    color: colors[index % colors.length],
                    strokeWidth: 2,
                    strokeColor: Colors.white);
              }),
          belowBarData: BarAreaData(
              show: true,
              color: colors[index % colors.length].withValues(alpha: 0.1)));
    }).toList();
  }

  Widget _buildSkillLegend() {
    final colors = [
      AppTheme.lightTheme.colorScheme.primary,
      AppTheme.lightTheme.colorScheme.secondary,
      AppTheme.lightTheme.colorScheme.tertiary,
      Colors.green,
      Colors.orange,
    ];

    return Wrap(
        spacing: 4.w,
        runSpacing: 1.h,
        children: widget.skillData.asMap().entries.map((entry) {
          final index = entry.key;
          final skill = entry.value;
          final color = colors[index % colors.length];

          return GestureDetector(
              onTap: () => widget.onSkillTap(skill['name'] as String),
              child: Row(mainAxisSize: MainAxisSize.min, children: [
                Container(
                    width: 12,
                    height: 12,
                    decoration:
                        BoxDecoration(color: color, shape: BoxShape.circle)),
                SizedBox(width: 2.w),
                Text(skill['name'] as String,
                    style: AppTheme.lightTheme.textTheme.bodySmall
                        ?.copyWith(fontWeight: FontWeight.w500)),
              ]));
        }).toList());
  }
}
