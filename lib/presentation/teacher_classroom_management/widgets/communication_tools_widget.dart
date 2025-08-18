import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class CommunicationToolsWidget extends StatefulWidget {
  final Function(String, String) onSendAnnouncement;
  final Function(String, String) onSendMessage;

  const CommunicationToolsWidget({
    Key? key,
    required this.onSendAnnouncement,
    required this.onSendMessage,
  }) : super(key: key);

  @override
  State<CommunicationToolsWidget> createState() =>
      _CommunicationToolsWidgetState();
}

class _CommunicationToolsWidgetState extends State<CommunicationToolsWidget>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final TextEditingController _announcementController = TextEditingController();
  final TextEditingController _messageController = TextEditingController();
  String _selectedRecipient = 'All Students';

  final List<String> _recipients = [
    'All Students',
    'Active Students',
    'Low Engagement Students',
    'High Performers',
    'Individual Student',
  ];

  final List<Map<String, dynamic>> _recentMessages = [
    {
      'recipient': 'Aarav Sharma',
      'message': 'Great progress on the critical thinking module!',
      'timestamp': '2 hours ago',
      'status': 'read',
    },
    {
      'recipient': 'Priya Patel',
      'message': 'Please complete the pending assignment by tomorrow.',
      'timestamp': '1 day ago',
      'status': 'delivered',
    },
    {
      'recipient': 'All Students - Class 8A',
      'message': 'Tomorrow\'s session will focus on team collaboration skills.',
      'timestamp': '2 days ago',
      'status': 'read',
    },
  ];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    _announcementController.dispose();
    _messageController.dispose();
    super.dispose();
  }

  void _sendAnnouncement() {
    if (_announcementController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter announcement message')),
      );
      return;
    }

    widget.onSendAnnouncement(
        _selectedRecipient, _announcementController.text.trim());
    _announcementController.clear();

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Announcement sent successfully!')),
    );
  }

  void _sendMessage() {
    if (_messageController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter message')),
      );
      return;
    }

    widget.onSendMessage(_selectedRecipient, _messageController.text.trim());
    _messageController.clear();

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Message sent successfully!')),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(4.w),
      decoration: BoxDecoration(
        color: AppTheme.lightTheme.colorScheme.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: AppTheme.lightTheme.colorScheme.outline.withValues(alpha: 0.3),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              CustomIconWidget(
                iconName: 'chat',
                color: AppTheme.lightTheme.colorScheme.primary,
                size: 24,
              ),
              SizedBox(width: 2.w),
              Text(
                'Communication Tools',
                style: AppTheme.lightTheme.textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
          SizedBox(height: 3.h),
          TabBar(
            controller: _tabController,
            tabs: const [
              Tab(text: 'Send Message'),
              Tab(text: 'Recent Messages'),
            ],
          ),
          SizedBox(height: 2.h),
          SizedBox(
            height: 35.h,
            child: TabBarView(
              controller: _tabController,
              children: [
                _buildSendMessageTab(),
                _buildRecentMessagesTab(),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSendMessageTab() {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Recipient',
            style: AppTheme.lightTheme.textTheme.labelLarge,
          ),
          SizedBox(height: 1.h),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 3.w),
            decoration: BoxDecoration(
              border: Border.all(
                color: AppTheme.lightTheme.colorScheme.outline,
              ),
              borderRadius: BorderRadius.circular(8),
            ),
            child: DropdownButtonHideUnderline(
              child: DropdownButton<String>(
                value: _selectedRecipient,
                isExpanded: true,
                items: _recipients.map((String recipient) {
                  return DropdownMenuItem<String>(
                    value: recipient,
                    child: Text(
                      recipient,
                      style: AppTheme.lightTheme.textTheme.bodyMedium,
                    ),
                  );
                }).toList(),
                onChanged: (String? newValue) {
                  if (newValue != null) {
                    setState(() {
                      _selectedRecipient = newValue;
                    });
                  }
                },
              ),
            ),
          ),
          SizedBox(height: 2.h),
          TextField(
            controller: _tabController.index == 0
                ? _announcementController
                : _messageController,
            decoration: InputDecoration(
              labelText: _tabController.index == 0 ? 'Announcement' : 'Message',
              hintText: _tabController.index == 0
                  ? 'Enter announcement for the class...'
                  : 'Enter your message...',
              alignLabelWithHint: true,
            ),
            maxLines: 4,
          ),
          SizedBox(height: 2.h),
          Row(
            children: [
              Expanded(
                child: OutlinedButton.icon(
                  onPressed: () {
                    if (_tabController.index == 0) {
                      _announcementController.clear();
                    } else {
                      _messageController.clear();
                    }
                  },
                  icon: CustomIconWidget(
                    iconName: 'clear',
                    color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                    size: 18,
                  ),
                  label: const Text('Clear'),
                ),
              ),
              SizedBox(width: 3.w),
              Expanded(
                child: ElevatedButton.icon(
                  onPressed: _tabController.index == 0
                      ? _sendAnnouncement
                      : _sendMessage,
                  icon: CustomIconWidget(
                    iconName: 'send',
                    color: Colors.white,
                    size: 18,
                  ),
                  label: const Text('Send'),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildRecentMessagesTab() {
    return ListView.separated(
      itemCount: _recentMessages.length,
      separatorBuilder: (context, index) => Divider(
        color: AppTheme.lightTheme.colorScheme.outline.withValues(alpha: 0.2),
      ),
      itemBuilder: (context, index) {
        final message = _recentMessages[index];
        final recipient = message['recipient'] as String? ?? '';
        final messageText = message['message'] as String? ?? '';
        final timestamp = message['timestamp'] as String? ?? '';
        final status = message['status'] as String? ?? 'sent';

        return ListTile(
          contentPadding: EdgeInsets.zero,
          leading: Container(
            width: 10.w,
            height: 10.w,
            decoration: BoxDecoration(
              color: AppTheme.lightTheme.colorScheme.primaryContainer,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Center(
              child: Text(
                recipient.isNotEmpty ? recipient[0].toUpperCase() : 'M',
                style: AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
                  color: AppTheme.lightTheme.colorScheme.onPrimaryContainer,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),
          title: Text(
            recipient,
            style: AppTheme.lightTheme.textTheme.titleSmall?.copyWith(
              fontWeight: FontWeight.w600,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          subtitle: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 0.5.h),
              Text(
                messageText,
                style: AppTheme.lightTheme.textTheme.bodySmall,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
              SizedBox(height: 0.5.h),
              Row(
                children: [
                  Text(
                    timestamp,
                    style: AppTheme.lightTheme.textTheme.labelSmall?.copyWith(
                      color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                    ),
                  ),
                  SizedBox(width: 2.w),
                  CustomIconWidget(
                    iconName: status == 'read'
                        ? 'done_all'
                        : status == 'delivered'
                            ? 'done'
                            : 'schedule',
                    color: status == 'read'
                        ? AppTheme.lightTheme.colorScheme.primary
                        : AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                    size: 14,
                  ),
                ],
              ),
            ],
          ),
          trailing: PopupMenuButton<String>(
            icon: CustomIconWidget(
              iconName: 'more_vert',
              color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
              size: 20,
            ),
            onSelected: (String value) {
              // Handle menu actions
            },
            itemBuilder: (BuildContext context) => [
              const PopupMenuItem<String>(
                value: 'reply',
                child: Text('Reply'),
              ),
              const PopupMenuItem<String>(
                value: 'forward',
                child: Text('Forward'),
              ),
              const PopupMenuItem<String>(
                value: 'delete',
                child: Text('Delete'),
              ),
            ],
          ),
        );
      },
    );
  }
}
