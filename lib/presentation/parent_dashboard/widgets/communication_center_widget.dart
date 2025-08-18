import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class CommunicationCenterWidget extends StatelessWidget {
  final List<Map<String, dynamic>> messages;
  final Function(String) onMessageTap;

  const CommunicationCenterWidget({
    super.key,
    required this.messages,
    required this.onMessageTap,
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
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  CustomIconWidget(
                    iconName: 'forum',
                    color: AppTheme.lightTheme.colorScheme.tertiary,
                    size: 24,
                  ),
                  SizedBox(width: 3.w),
                  Text(
                    'Communication Center',
                    style: AppTheme.lightTheme.textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
              if (_getUnreadCount() > 0)
                Container(
                  padding:
                      EdgeInsets.symmetric(horizontal: 2.w, vertical: 0.5.h),
                  decoration: BoxDecoration(
                    color: Colors.red,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    '${_getUnreadCount()}',
                    style: AppTheme.lightTheme.textTheme.labelSmall?.copyWith(
                      color: Colors.white,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
            ],
          ),
          SizedBox(height: 3.h),
          if (messages.isEmpty)
            _buildEmptyState()
          else
            ...messages
                .take(3)
                .map((message) => _buildMessageCard(message))
                .toList(),
          if (messages.length > 3) ...[
            SizedBox(height: 2.h),
            Center(
              child: TextButton(
                onPressed: () => onMessageTap('view_all'),
                child: Text(
                  'View All Messages (${messages.length})',
                  style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
                    color: AppTheme.lightTheme.colorScheme.primary,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildMessageCard(Map<String, dynamic> message) {
    final isUnread = message['isUnread'] == true;

    return GestureDetector(
      onTap: () => onMessageTap(message['id'] as String),
      child: Container(
        width: double.infinity,
        margin: EdgeInsets.only(bottom: 2.h),
        padding: EdgeInsets.all(3.w),
        decoration: BoxDecoration(
          color: isUnread
              ? AppTheme.lightTheme.colorScheme.primary.withValues(alpha: 0.05)
              : AppTheme.lightTheme.colorScheme.surface,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isUnread
                ? AppTheme.lightTheme.colorScheme.primary.withValues(alpha: 0.2)
                : AppTheme.lightTheme.colorScheme.outline
                    .withValues(alpha: 0.2),
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                CircleAvatar(
                  radius: 16,
                  backgroundColor:
                      _getMessageTypeColor(message['type'] as String)
                          .withValues(alpha: 0.1),
                  child: CustomIconWidget(
                    iconName: _getMessageTypeIcon(message['type'] as String),
                    color: _getMessageTypeColor(message['type'] as String),
                    size: 16,
                  ),
                ),
                SizedBox(width: 3.w),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: Text(
                              message['sender'] as String,
                              style: AppTheme.lightTheme.textTheme.titleSmall
                                  ?.copyWith(
                                fontWeight: isUnread
                                    ? FontWeight.w600
                                    : FontWeight.w500,
                              ),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          if (isUnread)
                            Container(
                              width: 8,
                              height: 8,
                              decoration: const BoxDecoration(
                                color: Colors.red,
                                shape: BoxShape.circle,
                              ),
                            ),
                        ],
                      ),
                      Text(
                        _getMessageTypeLabel(message['type'] as String),
                        style:
                            AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                          color:
                              _getMessageTypeColor(message['type'] as String),
                        ),
                      ),
                    ],
                  ),
                ),
                Text(
                  message['timestamp'] as String,
                  style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                    color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                  ),
                ),
              ],
            ),
            SizedBox(height: 2.h),
            Text(
              message['subject'] as String,
              style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
                fontWeight: isUnread ? FontWeight.w600 : FontWeight.w500,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
            SizedBox(height: 1.h),
            Text(
              message['preview'] as String,
              style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
              ),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
            if (message['hasAttachment'] == true) ...[
              SizedBox(height: 1.h),
              Row(
                children: [
                  CustomIconWidget(
                    iconName: 'attach_file',
                    color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                    size: 14,
                  ),
                  SizedBox(width: 1.w),
                  Text(
                    'Has attachment',
                    style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                      color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
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

  Widget _buildEmptyState() {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(6.w),
      child: Column(
        children: [
          CustomIconWidget(
            iconName: 'forum',
            color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
            size: 48,
          ),
          SizedBox(height: 2.h),
          Text(
            'No messages yet',
            style: AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
              color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
            ),
          ),
          SizedBox(height: 1.h),
          Text(
            'Messages from teachers and mentors will appear here',
            style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
              color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  int _getUnreadCount() {
    return messages.where((message) => message['isUnread'] == true).length;
  }

  Color _getMessageTypeColor(String type) {
    switch (type.toLowerCase()) {
      case 'teacher':
        return AppTheme.lightTheme.colorScheme.primary;
      case 'mentor':
        return AppTheme.lightTheme.colorScheme.tertiary;
      case 'announcement':
        return AppTheme.lightTheme.colorScheme.secondary;
      case 'system':
        return Colors.grey;
      default:
        return AppTheme.lightTheme.colorScheme.primary;
    }
  }

  String _getMessageTypeIcon(String type) {
    switch (type.toLowerCase()) {
      case 'teacher':
        return 'school';
      case 'mentor':
        return 'person';
      case 'announcement':
        return 'campaign';
      case 'system':
        return 'settings';
      default:
        return 'mail';
    }
  }

  String _getMessageTypeLabel(String type) {
    switch (type.toLowerCase()) {
      case 'teacher':
        return 'Teacher Message';
      case 'mentor':
        return 'Mentor Update';
      case 'announcement':
        return 'Announcement';
      case 'system':
        return 'System Notification';
      default:
        return 'Message';
    }
  }
}
