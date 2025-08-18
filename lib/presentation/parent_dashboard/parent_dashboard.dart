import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../core/app_export.dart';
import './widgets/achievements_carousel_widget.dart';
import './widgets/ai_insights_widget.dart';
import './widgets/child_selector_widget.dart';
import './widgets/communication_center_widget.dart';
import './widgets/growth_chart_widget.dart';
import './widgets/key_metrics_widget.dart';
import './widgets/quest_timeline_widget.dart';
import './widgets/screen_time_widget.dart';

class ParentDashboard extends StatefulWidget {
  const ParentDashboard({super.key});

  @override
  State<ParentDashboard> createState() => _ParentDashboardState();
}

class _ParentDashboardState extends State<ParentDashboard>
    with TickerProviderStateMixin {
  late TabController _tabController;
  String selectedChildId = 'child_1';
  final GlobalKey<RefreshIndicatorState> _refreshIndicatorKey =
      GlobalKey<RefreshIndicatorState>();

  // Mock data
  final List<Map<String, dynamic>> childrenData = [
    {
      "id": "child_1",
      "name": "Arjun Sharma",
      "grade": "7",
      "avatar":
          "https://images.pexels.com/photos/1239291/pexels-photo-1239291.jpeg?auto=compress&cs=tinysrgb&w=400",
    },
    {
      "id": "child_2",
      "name": "Priya Patel",
      "grade": "5",
      "avatar":
          "https://images.pexels.com/photos/1674752/pexels-photo-1674752.jpeg?auto=compress&cs=tinysrgb&w=400",
    },
  ];

  final Map<String, dynamic> metricsData = {
    "weeklyLearningTime": 12,
    "learningTimeProgress": 0.75,
    "learningTimeTrend": 15,
    "xpGained": 2450,
    "xpProgress": 0.82,
    "xpTrend": 23,
    "completedActivities": 18,
    "totalActivities": 25,
    "activitiesProgress": 0.72,
    "activitiesTrend": 78,
  };

  final List<Map<String, dynamic>> skillData = [
    {
      "name": "Communication",
      "progressData": [65, 72, 78, 85],
    },
    {
      "name": "Critical Thinking",
      "progressData": [58, 65, 71, 79],
    },
    {
      "name": "Creativity",
      "progressData": [70, 75, 82, 88],
    },
    {
      "name": "Collaboration",
      "progressData": [62, 68, 74, 81],
    },
  ];

  final List<Map<String, dynamic>> achievementsData = [
    {
      "id": "achievement_1",
      "title": "Critical Thinker",
      "category": "Critical Thinker",
      "description":
          "Completed 10 problem-solving challenges with excellent reasoning skills",
      "earnedDate": "2 days ago",
      "xpReward": 250,
      "isNew": true,
    },
    {
      "id": "achievement_2",
      "title": "Team Player",
      "category": "Team Player",
      "description":
          "Successfully collaborated on 5 group projects showing excellent teamwork",
      "earnedDate": "1 week ago",
      "xpReward": 200,
      "isNew": false,
    },
    {
      "id": "achievement_3",
      "title": "Creative Mind",
      "category": "Creative Mind",
      "description":
          "Demonstrated outstanding creativity in art and storytelling activities",
      "earnedDate": "2 weeks ago",
      "xpReward": 180,
      "isNew": false,
    },
  ];

  final List<Map<String, dynamic>> aiInsights = [
    {
      "id": "insight_1",
      "title": "Strengthen Mathematical Reasoning",
      "description":
          "Arjun shows excellent progress in creative tasks but could benefit from more structured math problem-solving activities. His visual learning style suggests using diagrams and real-world examples.",
      "priority": "High",
      "generatedTime": "2 hours ago",
      "actionItems": [
        "Try visual math puzzles and geometry games",
        "Connect math concepts to real-world scenarios",
        "Encourage daily 15-minute math practice sessions",
      ],
    },
    {
      "id": "insight_2",
      "title": "Excellent Communication Growth",
      "description":
          "Your child has shown remarkable improvement in communication skills over the past month. Continue encouraging storytelling and presentation activities.",
      "priority": "Medium",
      "generatedTime": "1 day ago",
      "actionItems": [
        "Encourage participation in school debates",
        "Practice storytelling during family time",
        "Join a public speaking club or workshop",
      ],
    },
  ];

  final List<Map<String, dynamic>> communicationData = [
    {
      "id": "msg_1",
      "sender": "Ms. Priya Gupta",
      "type": "teacher",
      "subject": "Excellent Progress in Science Project",
      "preview":
          "Arjun has shown outstanding creativity in his volcano project. His presentation skills have improved significantly...",
      "timestamp": "2 hours ago",
      "isUnread": true,
      "hasAttachment": false,
    },
    {
      "id": "msg_2",
      "sender": "Dr. Rajesh Kumar",
      "type": "mentor",
      "subject": "Career Exploration Session Summary",
      "preview":
          "Great session today! We discussed engineering careers and Arjun showed keen interest in robotics. Next session we'll explore...",
      "timestamp": "1 day ago",
      "isUnread": true,
      "hasAttachment": true,
    },
    {
      "id": "msg_3",
      "sender": "SkillSeed Team",
      "type": "announcement",
      "subject": "New STEM Challenges Available",
      "preview":
          "Exciting new robotics and coding challenges are now available in the Quest Hub. Perfect for students interested in technology...",
      "timestamp": "3 days ago",
      "isUnread": false,
      "hasAttachment": false,
    },
  ];

  final Map<String, dynamic> screenTimeData = {
    "todayUsage": 145, // minutes
    "dailyLimit": 120, // minutes
    "isLimitEnabled": true,
    "dailyUsage": [95, 110, 125, 145, 98, 160, 135], // Last 7 days in minutes
  };

  final List<Map<String, dynamic>> questHistoryData = [
    {
      "id": "quest_1",
      "title": "Environmental Detective",
      "description":
          "Investigate local environmental issues and propose solutions",
      "difficulty": "Medium",
      "subject": "Critical Thinking",
      "status": "completed",
      "completedDate": "Yesterday",
      "xpReward": 150,
    },
    {
      "id": "quest_2",
      "title": "Storytelling Master",
      "description": "Create and present an original story with moral lessons",
      "difficulty": "Easy",
      "subject": "Communication",
      "status": "completed",
      "completedDate": "3 days ago",
      "xpReward": 100,
    },
    {
      "id": "quest_3",
      "title": "Innovation Challenge",
      "description": "Design a solution for a common household problem",
      "difficulty": "Hard",
      "subject": "Creativity",
      "status": "completed",
      "completedDate": "1 week ago",
      "xpReward": 200,
    },
    {
      "id": "quest_4",
      "title": "Team Building Exercise",
      "description": "Lead a group activity that promotes collaboration",
      "difficulty": "Medium",
      "subject": "Collaboration",
      "status": "completed",
      "completedDate": "2 weeks ago",
      "xpReward": 175,
    },
  ];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.lightTheme.scaffoldBackgroundColor,
      appBar: _buildAppBar(),
      body: RefreshIndicator(
        key: _refreshIndicatorKey,
        onRefresh: _refreshData,
        color: AppTheme.lightTheme.colorScheme.primary,
        child: Column(
          children: [
            _buildChildSelector(),
            _buildTabBar(),
            Expanded(
              child: TabBarView(
                controller: _tabController,
                children: [
                  _buildOverviewTab(),
                  _buildProgressTab(),
                  _buildCommunicationTab(),
                  _buildSettingsTab(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  PreferredSizeWidget _buildAppBar() {
    return AppBar(
      title: Row(
        children: [
          Container(
            width: 8.w,
            height: 8.w,
            decoration: BoxDecoration(
              gradient: AppTheme.getProgressGradient(),
              borderRadius: BorderRadius.circular(8),
            ),
            child: CustomIconWidget(
              iconName: 'eco',
              color: Colors.white,
              size: 20,
            ),
          ),
          SizedBox(width: 3.w),
          Text(
            'SkillSeed Parent',
            style: AppTheme.lightTheme.textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ),
      actions: [
        IconButton(
          onPressed: () {
            // Handle notifications
          },
          icon: Stack(
            children: [
              CustomIconWidget(
                iconName: 'notifications',
                color: AppTheme.lightTheme.colorScheme.onSurface,
                size: 24,
              ),
              Positioned(
                right: 0,
                top: 0,
                child: Container(
                  width: 8,
                  height: 8,
                  decoration: const BoxDecoration(
                    color: Colors.red,
                    shape: BoxShape.circle,
                  ),
                ),
              ),
            ],
          ),
        ),
        IconButton(
          onPressed: () {
            // Handle profile/settings
          },
          icon: CircleAvatar(
            radius: 16,
            backgroundColor:
                AppTheme.lightTheme.colorScheme.primary.withValues(alpha: 0.1),
            child: CustomIconWidget(
              iconName: 'person',
              color: AppTheme.lightTheme.colorScheme.primary,
              size: 20,
            ),
          ),
        ),
        SizedBox(width: 2.w),
      ],
    );
  }

  Widget _buildChildSelector() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 2.h),
      child: ChildSelectorWidget(
        selectedChild: selectedChildId,
        children: childrenData,
        onChildChanged: (childId) {
          setState(() => selectedChildId = childId);
          _refreshData();
        },
      ),
    );
  }

  Widget _buildTabBar() {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 4.w),
      decoration: BoxDecoration(
        color: AppTheme.lightTheme.colorScheme.surface,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: AppTheme.lightTheme.colorScheme.shadow,
            blurRadius: 4,
            offset: const Offset(0, 1),
          ),
        ],
      ),
      child: TabBar(
        controller: _tabController,
        tabs: const [
          Tab(text: 'Overview'),
          Tab(text: 'Progress'),
          Tab(text: 'Messages'),
          Tab(text: 'Settings'),
        ],
        labelStyle: AppTheme.lightTheme.textTheme.titleSmall?.copyWith(
          fontWeight: FontWeight.w600,
        ),
        unselectedLabelStyle:
            AppTheme.lightTheme.textTheme.titleSmall?.copyWith(
          fontWeight: FontWeight.w400,
        ),
        indicator: BoxDecoration(
          color: AppTheme.lightTheme.colorScheme.primary,
          borderRadius: BorderRadius.circular(8),
        ),
        labelColor: Colors.white,
        unselectedLabelColor: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
        indicatorSize: TabBarIndicatorSize.tab,
        dividerColor: Colors.transparent,
      ),
    );
  }

  Widget _buildOverviewTab() {
    return SingleChildScrollView(
      padding: EdgeInsets.all(4.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          KeyMetricsWidget(metricsData: metricsData),
          SizedBox(height: 3.h),
          AchievementsCarouselWidget(achievements: achievementsData),
          SizedBox(height: 3.h),
          AiInsightsWidget(insights: aiInsights),
          SizedBox(height: 3.h),
          CommunicationCenterWidget(
            messages: communicationData,
            onMessageTap: _handleMessageTap,
          ),
        ],
      ),
    );
  }

  Widget _buildProgressTab() {
    return SingleChildScrollView(
      padding: EdgeInsets.all(4.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          GrowthChartWidget(
            skillData: skillData,
            onSkillTap: _handleSkillTap,
          ),
          SizedBox(height: 3.h),
          ScreenTimeWidget(
            screenTimeData: screenTimeData,
            onLimitToggle: _handleScreenTimeLimitToggle,
          ),
          SizedBox(height: 3.h),
          QuestTimelineWidget(
            questHistory: questHistoryData,
            onQuestTap: _handleQuestTap,
          ),
        ],
      ),
    );
  }

  Widget _buildCommunicationTab() {
    return SingleChildScrollView(
      padding: EdgeInsets.all(4.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'All Messages',
            style: AppTheme.lightTheme.textTheme.headlineSmall?.copyWith(
              fontWeight: FontWeight.w600,
            ),
          ),
          SizedBox(height: 2.h),
          ...communicationData
              .map((message) => Container(
                    margin: EdgeInsets.only(bottom: 2.h),
                    child: _buildDetailedMessageCard(message),
                  ))
              .toList(),
        ],
      ),
    );
  }

  Widget _buildSettingsTab() {
    return SingleChildScrollView(
      padding: EdgeInsets.all(4.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Settings',
            style: AppTheme.lightTheme.textTheme.headlineSmall?.copyWith(
              fontWeight: FontWeight.w600,
            ),
          ),
          SizedBox(height: 3.h),
          _buildSettingsSection('Account Settings', [
            _buildSettingItem('Profile Information', 'person', () {}),
            _buildSettingItem('Privacy Settings', 'privacy_tip', () {}),
            _buildSettingItem(
                'Notification Preferences', 'notifications', () {}),
          ]),
          SizedBox(height: 3.h),
          _buildSettingsSection('Child Management', [
            _buildSettingItem('Screen Time Controls', 'screen_time', () {}),
            _buildSettingItem('Content Filtering', 'filter_alt', () {}),
            _buildSettingItem('Progress Reports', 'assessment', () {}),
          ]),
          SizedBox(height: 3.h),
          _buildSettingsSection('Support', [
            _buildSettingItem('Help Center', 'help', () {}),
            _buildSettingItem('Contact Support', 'support_agent', () {}),
            _buildSettingItem('Feedback', 'feedback', () {}),
          ]),
        ],
      ),
    );
  }

  Widget _buildDetailedMessageCard(Map<String, dynamic> message) {
    final isUnread = message['isUnread'] == true;

    return Container(
      padding: EdgeInsets.all(4.w),
      decoration: BoxDecoration(
        color: AppTheme.lightTheme.colorScheme.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: isUnread
              ? AppTheme.lightTheme.colorScheme.primary.withValues(alpha: 0.3)
              : AppTheme.lightTheme.colorScheme.outline.withValues(alpha: 0.2),
        ),
        boxShadow: [
          BoxShadow(
            color: AppTheme.lightTheme.colorScheme.shadow,
            blurRadius: 4,
            offset: const Offset(0, 1),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              CircleAvatar(
                radius: 20,
                backgroundColor: _getMessageTypeColor(message['type'] as String)
                    .withValues(alpha: 0.1),
                child: CustomIconWidget(
                  iconName: _getMessageTypeIcon(message['type'] as String),
                  color: _getMessageTypeColor(message['type'] as String),
                  size: 20,
                ),
              ),
              SizedBox(width: 3.w),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      message['sender'] as String,
                      style:
                          AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    Text(
                      _getMessageTypeLabel(message['type'] as String),
                      style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                        color: _getMessageTypeColor(message['type'] as String),
                      ),
                    ),
                  ],
                ),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    message['timestamp'] as String,
                    style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                      color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                    ),
                  ),
                  if (isUnread)
                    Container(
                      width: 8,
                      height: 8,
                      margin: EdgeInsets.only(top: 0.5.h),
                      decoration: const BoxDecoration(
                        color: Colors.red,
                        shape: BoxShape.circle,
                      ),
                    ),
                ],
              ),
            ],
          ),
          SizedBox(height: 2.h),
          Text(
            message['subject'] as String,
            style: AppTheme.lightTheme.textTheme.titleSmall?.copyWith(
              fontWeight: FontWeight.w600,
            ),
          ),
          SizedBox(height: 1.h),
          Text(
            message['preview'] as String,
            style: AppTheme.lightTheme.textTheme.bodyMedium,
          ),
          if (message['hasAttachment'] == true) ...[
            SizedBox(height: 2.h),
            Row(
              children: [
                CustomIconWidget(
                  iconName: 'attach_file',
                  color: AppTheme.lightTheme.colorScheme.primary,
                  size: 16,
                ),
                SizedBox(width: 1.w),
                Text(
                  'Attachment included',
                  style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                    color: AppTheme.lightTheme.colorScheme.primary,
                  ),
                ),
              ],
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildSettingsSection(String title, List<Widget> items) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: AppTheme.lightTheme.colorScheme.surface,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: AppTheme.lightTheme.colorScheme.shadow,
            blurRadius: 4,
            offset: const Offset(0, 1),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: EdgeInsets.all(4.w),
            child: Text(
              title,
              style: AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          ...items,
        ],
      ),
    );
  }

  Widget _buildSettingItem(String title, String iconName, VoidCallback onTap) {
    return ListTile(
      leading: CustomIconWidget(
        iconName: iconName,
        color: AppTheme.lightTheme.colorScheme.primary,
        size: 24,
      ),
      title: Text(
        title,
        style: AppTheme.lightTheme.textTheme.bodyLarge,
      ),
      trailing: CustomIconWidget(
        iconName: 'chevron_right',
        color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
        size: 20,
      ),
      onTap: onTap,
    );
  }

  Future<void> _refreshData() async {
    // Simulate API call delay
    await Future.delayed(const Duration(seconds: 1));

    // In a real app, this would fetch fresh data from the API
    if (mounted) {
      setState(() {
        // Update data here
      });
    }
  }

  void _handleMessageTap(String messageId) {
    if (messageId == 'view_all') {
      _tabController.animateTo(2); // Switch to Communication tab
    } else {
      // Handle individual message tap
      // Navigate to message detail screen
    }
  }

  void _handleSkillTap(String skillName) {
    // Handle skill detail view
    // Navigate to detailed skill analytics
  }

  void _handleScreenTimeLimitToggle(bool enabled) {
    setState(() {
      screenTimeData['isLimitEnabled'] = enabled;
    });
  }

  void _handleQuestTap(String questId) {
    if (questId == 'view_all') {
      // Navigate to full quest history
    } else {
      // Navigate to quest detail
    }
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
