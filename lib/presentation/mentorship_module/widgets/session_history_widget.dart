import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class SessionHistoryWidget extends StatelessWidget {
  final List<Map<String, dynamic>> sessionHistory;
  final Function(Map<String, dynamic>) onSessionTap;

  const SessionHistoryWidget({
    Key? key,
    required this.sessionHistory,
    required this.onSessionTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (sessionHistory.isEmpty) {
      return _buildEmptyState();
    }

    return ListView.separated(
      padding: EdgeInsets.all(4.w),
      itemCount: sessionHistory.length,
      separatorBuilder: (context, index) => SizedBox(height: 2.h),
      itemBuilder: (context, index) {
        final session = sessionHistory[index];
        return _buildSessionCard(session);
      },
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CustomIconWidget(
            iconName: 'history',
            color: AppTheme.lightTheme.colorScheme.onSurfaceVariant
                .withValues(alpha: 0.5),
            size: 64,
          ),
          SizedBox(height: 2.h),
          Text(
            "No Sessions Yet",
            style: AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
              color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
              fontWeight: FontWeight.w600,
            ),
          ),
          SizedBox(height: 1.h),
          Text(
            "Your completed mentorship sessions\nwill appear here",
            textAlign: TextAlign.center,
            style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
              color: AppTheme.lightTheme.colorScheme.onSurfaceVariant
                  .withValues(alpha: 0.7),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSessionCard(Map<String, dynamic> session) {
    final status = session["status"] as String;
    final isCompleted = status == "completed";
    final isUpcoming = status == "upcoming";
    final isCancelled = status == "cancelled";

    Color statusColor;
    Color statusBgColor;
    IconData statusIcon;

    if (isCompleted) {
      statusColor = AppTheme.lightTheme.colorScheme.primary;
      statusBgColor =
          AppTheme.lightTheme.colorScheme.primary.withValues(alpha: 0.1);
      statusIcon = Icons.check_circle;
    } else if (isUpcoming) {
      statusColor = Colors.orange;
      statusBgColor = Colors.orange.withValues(alpha: 0.1);
      statusIcon = Icons.schedule;
    } else {
      statusColor = AppTheme.lightTheme.colorScheme.onSurfaceVariant;
      statusBgColor = AppTheme.lightTheme.colorScheme.onSurfaceVariant
          .withValues(alpha: 0.1);
      statusIcon = Icons.cancel;
    }

    return GestureDetector(
      onTap: () => onSessionTap(session),
      child: Container(
        padding: EdgeInsets.all(4.w),
        decoration: BoxDecoration(
          color: AppTheme.lightTheme.colorScheme.surface,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color:
                AppTheme.lightTheme.colorScheme.outline.withValues(alpha: 0.3),
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.05),
              blurRadius: 4,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header with mentor info and status
            Row(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(25),
                  child: CustomImageWidget(
                    imageUrl: session["mentorImage"] as String,
                    width: 12.w,
                    height: 12.w,
                    fit: BoxFit.cover,
                  ),
                ),
                SizedBox(width: 3.w),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        session["mentorName"] as String,
                        style:
                            AppTheme.lightTheme.textTheme.titleSmall?.copyWith(
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      SizedBox(height: 0.5.h),
                      Text(
                        session["mentorExpertise"] as String,
                        style:
                            AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                          color: AppTheme.lightTheme.colorScheme.primary,
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  padding:
                      EdgeInsets.symmetric(horizontal: 2.w, vertical: 0.5.h),
                  decoration: BoxDecoration(
                    color: statusBgColor,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        statusIcon,
                        color: statusColor,
                        size: 16,
                      ),
                      SizedBox(width: 1.w),
                      Text(
                        status.toUpperCase(),
                        style:
                            AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                          color: statusColor,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),

            SizedBox(height: 2.h),

            // Session details
            Row(
              children: [
                Expanded(
                  child: _buildDetailItem(
                    icon: 'calendar_today',
                    label: "Date",
                    value: session["date"] as String,
                  ),
                ),
                Expanded(
                  child: _buildDetailItem(
                    icon: 'access_time',
                    label: "Time",
                    value: session["time"] as String,
                  ),
                ),
              ],
            ),

            SizedBox(height: 1.h),

            Row(
              children: [
                Expanded(
                  child: _buildDetailItem(
                    icon: 'category',
                    label: "Type",
                    value: session["sessionType"] as String,
                  ),
                ),
                Expanded(
                  child: _buildDetailItem(
                    icon: 'timer',
                    label: "Duration",
                    value: "${session["duration"]} min",
                  ),
                ),
              ],
            ),

            if (session["notes"] != null &&
                (session["notes"] as String).isNotEmpty) ...[
              SizedBox(height: 2.h),
              Container(
                width: double.infinity,
                padding: EdgeInsets.all(3.w),
                decoration: BoxDecoration(
                  color: AppTheme.lightTheme.colorScheme.surface,
                  border: Border.all(
                    color: AppTheme.lightTheme.colorScheme.outline
                        .withValues(alpha: 0.3),
                  ),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Session Notes",
                      style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                        fontWeight: FontWeight.w600,
                        color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                      ),
                    ),
                    SizedBox(height: 0.5.h),
                    Text(
                      session["notes"] as String,
                      style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                        height: 1.4,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
            ],

            if (isCompleted && session["rating"] != null) ...[
              SizedBox(height: 1.5.h),
              Row(
                children: [
                  Text(
                    "Your Rating: ",
                    style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                      color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                    ),
                  ),
                  Row(
                    children: List.generate(5, (index) {
                      return CustomIconWidget(
                        iconName: 'star',
                        color: index < (session["rating"] as int)
                            ? Colors.amber
                            : AppTheme.lightTheme.colorScheme.outline,
                        size: 16,
                      );
                    }),
                  ),
                ],
              ),
            ],

            if (isUpcoming) ...[
              SizedBox(height: 2.h),
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () {
                        // Handle reschedule
                      },
                      style: OutlinedButton.styleFrom(
                        padding: EdgeInsets.symmetric(vertical: 1.h),
                        side: BorderSide(
                          color: AppTheme.lightTheme.colorScheme.outline,
                        ),
                      ),
                      child: Text(
                        "Reschedule",
                        style:
                            AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(width: 2.w),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () {
                        // Handle join session
                      },
                      style: ElevatedButton.styleFrom(
                        padding: EdgeInsets.symmetric(vertical: 1.h),
                      ),
                      child: Text(
                        "Join Session",
                        style:
                            AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                          color: Colors.white,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildDetailItem({
    required String icon,
    required String label,
    required String value,
  }) {
    return Row(
      children: [
        CustomIconWidget(
          iconName: icon,
          color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
          size: 16,
        ),
        SizedBox(width: 2.w),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                  color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                ),
              ),
              Text(
                value,
                style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
