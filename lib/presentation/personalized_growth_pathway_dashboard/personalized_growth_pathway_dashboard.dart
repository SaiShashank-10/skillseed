import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../core/app_export.dart';
import './widgets/daily_streak_widget.dart';
import './widgets/growth_tree_widget.dart';
import './widgets/quest_card_widget.dart';
import './widgets/recent_badges_widget.dart';

class PersonalizedGrowthPathwayDashboard extends StatefulWidget {
  const PersonalizedGrowthPathwayDashboard({Key? key}) : super(key: key);

  @override
  State<PersonalizedGrowthPathwayDashboard> createState() =>
      _PersonalizedGrowthPathwayDashboardState();
}

class _PersonalizedGrowthPathwayDashboardState
    extends State<PersonalizedGrowthPathwayDashboard>
    with TickerProviderStateMixin {
  late TabController _tabController;
  late AnimationController _fabAnimationController;
  late Animation<double> _fabScaleAnimation;

  int _currentTabIndex = 0;
  bool _isRefreshing = false;

  // Mock data for the dashboard
  final Map<String, dynamic> _studentData = {
    'name': 'Arjun Sharma',
    'currentXP': 2450,
    'level': 8,
    'nextLevelXP': 3000,
    'skillAreas': [
      {
        'name': 'Communication',
        'progress': 75,
        'unlocked': true,
      },
      {
        'name': 'Critical Thinking',
        'progress': 60,
        'unlocked': true,
      },
      {
        'name': 'Creativity',
        'progress': 45,
        'unlocked': true,
      },
      {
        'name': 'Leadership',
        'progress': 30,
        'unlocked': false,
      },
      {
        'name': 'Teamwork',
        'progress': 85,
        'unlocked': true,
      },
    ],
  };

  final List<Map<String, dynamic>> _activeQuests = [
    {
      'id': 'quest_1',
      'title': 'Master Public Speaking',
      'description':
          'Practice presenting ideas clearly and confidently to build communication skills.',
      'progress': 65,
      'timeRemaining': '2 days left',
      'difficulty': 'Medium',
      'xpReward': 150,
      'category': 'Communication',
      'isCompleted': false,
    },
    {
      'id': 'quest_2',
      'title': 'Creative Problem Solving',
      'description':
          'Use innovative thinking to solve real-world challenges in your community.',
      'progress': 40,
      'timeRemaining': '5 days left',
      'difficulty': 'Hard',
      'xpReward': 200,
      'category': 'Creativity',
      'isCompleted': false,
    },
    {
      'id': 'quest_3',
      'title': 'Team Collaboration Challenge',
      'description':
          'Work with classmates to complete a group project successfully.',
      'progress': 100,
      'timeRemaining': '',
      'difficulty': 'Easy',
      'xpReward': 100,
      'category': 'Teamwork',
      'isCompleted': true,
    },
    {
      'id': 'quest_4',
      'title': 'Critical Analysis Workshop',
      'description':
          'Analyze different perspectives on current events and form your own opinions.',
      'progress': 20,
      'timeRemaining': '1 week left',
      'difficulty': 'Medium',
      'xpReward': 175,
      'category': 'Critical Thinking',
      'isCompleted': false,
    },
  ];

  final List<Map<String, dynamic>> _recentBadges = [
    {
      'name': 'Team Player',
      'icon': 'group',
      'category': 'Team Player',
      'earnedDate': 'Today',
      'isNew': true,
      'description': 'Successfully completed 5 team collaboration quests',
    },
    {
      'name': 'Creative Mind',
      'icon': 'lightbulb',
      'category': 'Creative Mind',
      'earnedDate': '2 days ago',
      'isNew': false,
      'description':
          'Demonstrated innovative thinking in problem-solving challenges',
    },
    {
      'name': 'Communicator',
      'icon': 'record_voice_over',
      'category': 'Communicator',
      'earnedDate': '1 week ago',
      'isNew': false,
      'description': 'Mastered the art of clear and effective communication',
    },
    {
      'name': 'Critical Thinker',
      'icon': 'psychology',
      'category': 'Critical Thinker',
      'earnedDate': '2 weeks ago',
      'isNew': false,
      'description': 'Analyzed complex problems with logical reasoning',
    },
  ];

  final Map<String, dynamic> _streakData = {
    'currentStreak': 12,
    'longestStreak': 25,
    'todayCompleted': true,
  };

  @override
  void initState() {
    super.initState();
    _initializeControllers();
  }

  void _initializeControllers() {
    _tabController = TabController(length: 4, vsync: this);
    _tabController.addListener(() {
      setState(() {
        _currentTabIndex = _tabController.index;
      });
    });

    _fabAnimationController = AnimationController(
      duration: const Duration(milliseconds: 200),
      vsync: this,
    );

    _fabScaleAnimation = Tween<double>(
      begin: 1.0,
      end: 0.9,
    ).animate(CurvedAnimation(
      parent: _fabAnimationController,
      curve: Curves.easeInOut,
    ));
  }

  @override
  void dispose() {
    _tabController.dispose();
    _fabAnimationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.lightTheme.scaffoldBackgroundColor,
      body: SafeArea(
        child: Column(
          children: [
            _buildHeader(),
            Expanded(
              child: TabBarView(
                controller: _tabController,
                children: [
                  _buildDashboardTab(),
                  _buildQuestsTab(),
                  _buildCareersTab(),
                  _buildProfileTab(),
                ],
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: _buildBottomNavigation(),
      floatingActionButton:
          _currentTabIndex == 0 ? _buildFloatingActionButton() : null,
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
    );
  }

  Widget _buildHeader() {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(4.w),
      decoration: BoxDecoration(
        color: AppTheme.lightTheme.colorScheme.surface,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
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
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Hello, ${_studentData['name']}! 👋',
                      style:
                          AppTheme.lightTheme.textTheme.headlineSmall?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                    SizedBox(height: 0.5.h),
                    Text(
                      'Ready to grow today?',
                      style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
                        color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                      ),
                    ),
                  ],
                ),
              ),
              GestureDetector(
                onTap: _showNotificationCenter,
                child: Container(
                  padding: EdgeInsets.all(2.w),
                  decoration: BoxDecoration(
                    color: AppTheme.lightTheme.colorScheme.primary
                        .withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: CustomIconWidget(
                    iconName: 'notifications',
                    color: AppTheme.lightTheme.colorScheme.primary,
                    size: 24,
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 2.h),
          _buildXPProgress(),
        ],
      ),
    );
  }

  Widget _buildXPProgress() {
    final currentXP = _studentData['currentXP'] as int;
    final nextLevelXP = _studentData['nextLevelXP'] as int;
    final level = _studentData['level'] as int;
    final progress = currentXP / nextLevelXP;

    return Row(
      children: [
        Container(
          padding: EdgeInsets.symmetric(horizontal: 3.w, vertical: 1.h),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                AppTheme.lightTheme.colorScheme.primary,
                AppTheme.lightTheme.colorScheme.primary.withValues(alpha: 0.8),
              ],
            ),
            borderRadius: BorderRadius.circular(20),
          ),
          child: Text(
            'Level $level',
            style: AppTheme.lightTheme.textTheme.labelMedium?.copyWith(
              color: Colors.white,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
        SizedBox(width: 3.w),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    '$currentXP XP',
                    style: AppTheme.lightTheme.textTheme.labelMedium?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  Text(
                    '$nextLevelXP XP',
                    style: AppTheme.lightTheme.textTheme.labelSmall?.copyWith(
                      color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                    ),
                  ),
                ],
              ),
              SizedBox(height: 0.5.h),
              Container(
                width: double.infinity,
                height: 0.8.h,
                decoration: BoxDecoration(
                  color: AppTheme.lightTheme.colorScheme.outline
                      .withValues(alpha: 0.2),
                  borderRadius: BorderRadius.circular(4),
                ),
                child: FractionallySizedBox(
                  alignment: Alignment.centerLeft,
                  widthFactor: progress.clamp(0.0, 1.0),
                  child: Container(
                    decoration: BoxDecoration(
                      gradient: AppTheme.getProgressGradient(),
                      borderRadius: BorderRadius.circular(4),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildDashboardTab() {
    return RefreshIndicator(
      onRefresh: _handleRefresh,
      color: AppTheme.lightTheme.colorScheme.primary,
      child: SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 2.h),
            // Growth Tree Section
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 4.w),
              child: Text(
                'Your Growth Journey',
                style: AppTheme.lightTheme.textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            SizedBox(height: 2.h),
            Center(
              child: GrowthTreeWidget(
                studentData: _studentData,
                onBranchTap: _handleBranchTap,
              ),
            ),
            SizedBox(height: 3.h),
            // Daily Streak Section
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 4.w),
              child: DailyStreakWidget(
                currentStreak: _streakData['currentStreak'],
                longestStreak: _streakData['longestStreak'],
                todayCompleted: _streakData['todayCompleted'],
                onStreakTap: _handleStreakTap,
              ),
            ),
            SizedBox(height: 3.h),
            // Active Quests Section
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 4.w),
              child: Text(
                'Active Quests',
                style: AppTheme.lightTheme.textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            SizedBox(height: 2.h),
            SizedBox(
              height: 25.h,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                padding: EdgeInsets.symmetric(horizontal: 4.w),
                itemCount: _activeQuests.length,
                itemBuilder: (context, index) {
                  final quest = _activeQuests[index];
                  return QuestCardWidget(
                    quest: quest,
                    onQuestTap: _handleQuestTap,
                    onQuickAction: _handleQuickAction,
                  );
                },
              ),
            ),
            SizedBox(height: 3.h),
            // Recent Badges Section
            RecentBadgesWidget(
              recentBadges: _recentBadges,
              onBadgeTap: _handleBadgeTap,
            ),
            SizedBox(height: 10.h), // Extra space for FAB
          ],
        ),
      ),
    );
  }

  Widget _buildQuestsTab() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CustomIconWidget(
            iconName: 'assignment',
            color: AppTheme.lightTheme.colorScheme.primary,
            size: 64,
          ),
          SizedBox(height: 2.h),
          Text(
            'Quests Tab',
            style: AppTheme.lightTheme.textTheme.headlineSmall,
          ),
          SizedBox(height: 1.h),
          Text(
            'Explore all available quests and challenges',
            style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
              color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildCareersTab() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CustomIconWidget(
            iconName: 'work',
            color: AppTheme.lightTheme.colorScheme.primary,
            size: 64,
          ),
          SizedBox(height: 2.h),
          Text(
            'Careers Tab',
            style: AppTheme.lightTheme.textTheme.headlineSmall,
          ),
          SizedBox(height: 1.h),
          Text(
            'Discover exciting career paths and opportunities',
            style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
              color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildProfileTab() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CustomIconWidget(
            iconName: 'person',
            color: AppTheme.lightTheme.colorScheme.primary,
            size: 64,
          ),
          SizedBox(height: 2.h),
          Text(
            'Profile Tab',
            style: AppTheme.lightTheme.textTheme.headlineSmall,
          ),
          SizedBox(height: 1.h),
          Text(
            'Manage your profile and settings',
            style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
              color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildBottomNavigation() {
    return Container(
      decoration: BoxDecoration(
        color: AppTheme.lightTheme.colorScheme.surface,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.1),
            blurRadius: 8,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: TabBar(
        controller: _tabController,
        tabs: [
          Tab(
            icon: CustomIconWidget(
              iconName: 'dashboard',
              color: _currentTabIndex == 0
                  ? AppTheme.lightTheme.colorScheme.primary
                  : AppTheme.lightTheme.colorScheme.onSurfaceVariant,
              size: 24,
            ),
            text: 'Dashboard',
          ),
          Tab(
            icon: CustomIconWidget(
              iconName: 'assignment',
              color: _currentTabIndex == 1
                  ? AppTheme.lightTheme.colorScheme.primary
                  : AppTheme.lightTheme.colorScheme.onSurfaceVariant,
              size: 24,
            ),
            text: 'Quests',
          ),
          Tab(
            icon: CustomIconWidget(
              iconName: 'work',
              color: _currentTabIndex == 2
                  ? AppTheme.lightTheme.colorScheme.primary
                  : AppTheme.lightTheme.colorScheme.onSurfaceVariant,
              size: 24,
            ),
            text: 'Careers',
          ),
          Tab(
            icon: CustomIconWidget(
              iconName: 'person',
              color: _currentTabIndex == 3
                  ? AppTheme.lightTheme.colorScheme.primary
                  : AppTheme.lightTheme.colorScheme.onSurfaceVariant,
              size: 24,
            ),
            text: 'Profile',
          ),
        ],
        labelColor: AppTheme.lightTheme.colorScheme.primary,
        unselectedLabelColor: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
        indicatorColor: AppTheme.lightTheme.colorScheme.primary,
        labelStyle: AppTheme.lightTheme.textTheme.labelSmall?.copyWith(
          fontWeight: FontWeight.w600,
        ),
        unselectedLabelStyle: AppTheme.lightTheme.textTheme.labelSmall,
      ),
    );
  }

  Widget _buildFloatingActionButton() {
    return AnimatedBuilder(
      animation: _fabScaleAnimation,
      builder: (context, child) {
        return Transform.scale(
          scale: _fabScaleAnimation.value,
          child: FloatingActionButton.extended(
            onPressed: _handleStartLearning,
            backgroundColor: AppTheme.lightTheme.colorScheme.secondary,
            foregroundColor: Colors.white,
            elevation: 4,
            icon: CustomIconWidget(
              iconName: 'play_arrow',
              color: Colors.white,
              size: 24,
            ),
            label: Text(
              'Start Learning',
              style: AppTheme.lightTheme.textTheme.labelLarge?.copyWith(
                color: Colors.white,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        );
      },
    );
  }

  // Event handlers
  Future<void> _handleRefresh() async {
    setState(() => _isRefreshing = true);

    // Simulate API call
    await Future.delayed(const Duration(seconds: 2));

    setState(() => _isRefreshing = false);

    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text('Dashboard refreshed successfully!'),
          backgroundColor: AppTheme.lightTheme.colorScheme.primary,
          behavior: SnackBarBehavior.floating,
        ),
      );
    }
  }

  void _handleBranchTap(String skillName) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('$skillName Skills'),
        content: Text(
            'Explore detailed progress and activities for $skillName development.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Close'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              // Navigate to skill details
            },
            child: const Text('Explore'),
          ),
        ],
      ),
    );
  }

  void _handleQuestTap(String questId) {
    final quest = _activeQuests.firstWhere((q) => q['id'] == questId);
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(quest['title']),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(quest['description']),
            SizedBox(height: 2.h),
            Text('Progress: ${quest['progress']}%'),
            Text('XP Reward: ${quest['xpReward']}'),
            if (quest['timeRemaining'].isNotEmpty)
              Text('Time: ${quest['timeRemaining']}'),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Close'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              // Navigate to quest details
            },
            child: const Text('Continue'),
          ),
        ],
      ),
    );
  }

  void _handleQuickAction(String questId, String action) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Quest ${action}ed successfully!'),
        backgroundColor: AppTheme.lightTheme.colorScheme.primary,
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  void _handleBadgeTap(Map<String, dynamic> badge) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Row(
          children: [
            CustomIconWidget(
              iconName: badge['icon'],
              color: AppTheme.lightTheme.colorScheme.primary,
              size: 24,
            ),
            SizedBox(width: 2.w),
            Text(badge['name']),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(badge['description']),
            SizedBox(height: 2.h),
            Text('Earned: ${badge['earnedDate']}'),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Close'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              // Share badge functionality
            },
            child: const Text('Share'),
          ),
        ],
      ),
    );
  }

  void _handleStreakTap() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Daily Streak'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text('Current Streak: ${_streakData['currentStreak']} days'),
            Text('Longest Streak: ${_streakData['longestStreak']} days'),
            SizedBox(height: 2.h),
            Text(
              _streakData['todayCompleted']
                  ? 'Great job! You\'ve completed today\'s activities.'
                  : 'Complete a quest today to continue your streak!',
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }

  void _handleStartLearning() {
    _fabAnimationController.forward().then((_) {
      _fabAnimationController.reverse();
    });

    // Find the next recommended quest
    final nextQuest = _activeQuests.firstWhere(
      (quest) => !(quest['isCompleted'] as bool),
      orElse: () => _activeQuests.first,
    );

    _handleQuestTap(nextQuest['id']);
  }

  void _showNotificationCenter() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        height: 60.h,
        decoration: BoxDecoration(
          color: AppTheme.lightTheme.colorScheme.surface,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
        ),
        child: Column(
          children: [
            Container(
              width: 10.w,
              height: 0.5.h,
              margin: EdgeInsets.symmetric(vertical: 2.h),
              decoration: BoxDecoration(
                color: AppTheme.lightTheme.colorScheme.outline
                    .withValues(alpha: 0.3),
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 4.w),
              child: Text(
                'Notifications',
                style: AppTheme.lightTheme.textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            SizedBox(height: 2.h),
            Expanded(
              child: ListView(
                padding: EdgeInsets.symmetric(horizontal: 4.w),
                children: [
                  _buildNotificationItem(
                    'New badge earned!',
                    'You\'ve earned the Team Player badge',
                    'notifications',
                    true,
                  ),
                  _buildNotificationItem(
                    'Quest reminder',
                    'Don\'t forget to complete your daily quest',
                    'assignment',
                    false,
                  ),
                  _buildNotificationItem(
                    'Parent message',
                    'Great progress this week! Keep it up.',
                    'message',
                    false,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildNotificationItem(
      String title, String message, String icon, bool isNew) {
    return Container(
      margin: EdgeInsets.only(bottom: 2.h),
      padding: EdgeInsets.all(3.w),
      decoration: BoxDecoration(
        color: isNew
            ? AppTheme.lightTheme.colorScheme.primary.withValues(alpha: 0.1)
            : AppTheme.lightTheme.colorScheme.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: AppTheme.lightTheme.colorScheme.outline.withValues(alpha: 0.2),
          width: 1,
        ),
      ),
      child: Row(
        children: [
          Container(
            padding: EdgeInsets.all(2.w),
            decoration: BoxDecoration(
              color: AppTheme.lightTheme.colorScheme.primary
                  .withValues(alpha: 0.2),
              borderRadius: BorderRadius.circular(8),
            ),
            child: CustomIconWidget(
              iconName: icon,
              color: AppTheme.lightTheme.colorScheme.primary,
              size: 20,
            ),
          ),
          SizedBox(width: 3.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: AppTheme.lightTheme.textTheme.titleSmall?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
                SizedBox(height: 0.5.h),
                Text(
                  message,
                  style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                    color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                  ),
                ),
              ],
            ),
          ),
          if (isNew)
            Container(
              width: 2.w,
              height: 2.w,
              decoration: BoxDecoration(
                color: AppTheme.lightTheme.colorScheme.secondary,
                shape: BoxShape.circle,
              ),
            ),
        ],
      ),
    );
  }
}
