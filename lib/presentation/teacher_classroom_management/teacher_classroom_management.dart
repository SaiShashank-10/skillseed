import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../core/app_export.dart';
import './widgets/analytics_section_widget.dart';
import './widgets/assignment_creation_widget.dart';
import './widgets/class_section_drawer.dart';
import './widgets/communication_tools_widget.dart';
import './widgets/quest_recommendation_widget.dart';
import './widgets/student_card_widget.dart';

class TeacherClassroomManagement extends StatefulWidget {
  const TeacherClassroomManagement({Key? key}) : super(key: key);

  @override
  State<TeacherClassroomManagement> createState() =>
      _TeacherClassroomManagementState();
}

class _TeacherClassroomManagementState extends State<TeacherClassroomManagement>
    with TickerProviderStateMixin {
  late TabController _mainTabController;
  String _selectedSection = 'Class 8A';
  String _selectedFilter = 'All Students';
  bool _isLoading = false;
  final Set<String> _selectedStudents = {};

  final List<String> _filterOptions = [
    'All Students',
    'Active Students',
    'High Performers',
    'Low Engagement',
    'Completed Tasks',
    'Pending Tasks',
  ];

  final List<Map<String, dynamic>> _classSections = [
    {'name': 'Class 8A', 'studentCount': 32},
    {'name': 'Class 8B', 'studentCount': 28},
    {'name': 'Class 9A', 'studentCount': 30},
    {'name': 'Class 9B', 'studentCount': 25},
    {'name': 'Class 10A', 'studentCount': 27},
  ];

  final List<Map<String, dynamic>> _studentsData = [
    {
      'id': 'student_001',
      'name': 'Aarav Sharma',
      'avatar':
          'https://cdn.pixabay.com/photo/2015/03/04/22/35/avatar-659652_640.png',
      'xp': 1250,
      'status': 'active',
      'lastActivity': 'Completed Critical Thinking module - 2 hours ago',
      'engagementLevel': 'high',
      'completedQuests': 12,
      'currentStreak': 7,
      'skillProgress': {
        'Critical Thinking': 85,
        'Communication': 72,
        'Problem Solving': 90,
        'Team Collaboration': 68,
      },
    },
    {
      'id': 'student_002',
      'name': 'Priya Patel',
      'avatar':
          'https://cdn.pixabay.com/photo/2015/03/04/22/35/avatar-659652_640.png',
      'xp': 980,
      'status': 'learning',
      'lastActivity': 'Working on Team Collaboration quest - 30 minutes ago',
      'engagementLevel': 'medium',
      'completedQuests': 8,
      'currentStreak': 4,
      'skillProgress': {
        'Critical Thinking': 65,
        'Communication': 88,
        'Problem Solving': 70,
        'Team Collaboration': 92,
      },
    },
    {
      'id': 'student_003',
      'name': 'Arjun Singh',
      'avatar':
          'https://cdn.pixabay.com/photo/2015/03/04/22/35/avatar-659652_640.png',
      'xp': 1450,
      'status': 'completed',
      'lastActivity': 'Earned Digital Citizen badge - 1 day ago',
      'engagementLevel': 'high',
      'completedQuests': 15,
      'currentStreak': 12,
      'skillProgress': {
        'Critical Thinking': 95,
        'Communication': 80,
        'Problem Solving': 88,
        'Team Collaboration': 85,
      },
    },
    {
      'id': 'student_004',
      'name': 'Ananya Gupta',
      'avatar':
          'https://cdn.pixabay.com/photo/2015/03/04/22/35/avatar-659652_640.png',
      'xp': 750,
      'status': 'inactive',
      'lastActivity': 'Last seen 3 days ago',
      'engagementLevel': 'low',
      'completedQuests': 5,
      'currentStreak': 0,
      'skillProgress': {
        'Critical Thinking': 45,
        'Communication': 60,
        'Problem Solving': 40,
        'Team Collaboration': 55,
      },
    },
    {
      'id': 'student_005',
      'name': 'Rohan Kumar',
      'avatar':
          'https://cdn.pixabay.com/photo/2015/03/04/22/35/avatar-659652_640.png',
      'xp': 1100,
      'status': 'active',
      'lastActivity': 'Started Creative Expression workshop - 1 hour ago',
      'engagementLevel': 'medium',
      'completedQuests': 10,
      'currentStreak': 5,
      'skillProgress': {
        'Critical Thinking': 78,
        'Communication': 75,
        'Problem Solving': 82,
        'Team Collaboration': 70,
      },
    },
    {
      'id': 'student_006',
      'name': 'Kavya Reddy',
      'avatar':
          'https://cdn.pixabay.com/photo/2015/03/04/22/35/avatar-659652_640.png',
      'xp': 1320,
      'status': 'learning',
      'lastActivity': 'Participating in group discussion - 15 minutes ago',
      'engagementLevel': 'high',
      'completedQuests': 13,
      'currentStreak': 8,
      'skillProgress': {
        'Critical Thinking': 88,
        'Communication': 95,
        'Problem Solving': 75,
        'Team Collaboration': 90,
      },
    },
  ];

  final Map<String, dynamic> _analyticsData = {
    'classAverage': 78.5,
    'totalStudents': 32,
    'activeStudents': 24,
    'completionRate': 85.2,
    'weeklyProgress': [65, 72, 78, 82, 85, 88, 90],
  };

  @override
  void initState() {
    super.initState();
    _mainTabController = TabController(length: 4, vsync: this);
  }

  @override
  void dispose() {
    _mainTabController.dispose();
    super.dispose();
  }

  List<Map<String, dynamic>> get _filteredStudents {
    switch (_selectedFilter) {
      case 'Active Students':
        return _studentsData
            .where((student) =>
                student['status'] == 'active' ||
                student['status'] == 'learning')
            .toList();
      case 'High Performers':
        return _studentsData
            .where((student) => (student['xp'] as int) > 1200)
            .toList();
      case 'Low Engagement':
        return _studentsData
            .where((student) => student['engagementLevel'] == 'low')
            .toList();
      case 'Completed Tasks':
        return _studentsData
            .where((student) => student['status'] == 'completed')
            .toList();
      case 'Pending Tasks':
        return _studentsData
            .where((student) => student['status'] != 'completed')
            .toList();
      default:
        return _studentsData;
    }
  }

  Future<void> _refreshData() async {
    setState(() {
      _isLoading = true;
    });

    // Simulate API call
    await Future.delayed(const Duration(seconds: 2));

    setState(() {
      _isLoading = false;
    });
  }

  void _onSectionSelected(String section) {
    setState(() {
      _selectedSection = section;
      _selectedStudents.clear();
    });
  }

  void _onStudentTap(Map<String, dynamic> student) {
    _showStudentDetailModal(student);
  }

  void _onStudentLongPress(Map<String, dynamic> student) {
    _showQuickActionsModal(student);
  }

  void _showStudentDetailModal(Map<String, dynamic> student) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => _buildStudentDetailModal(student),
    );
  }

  void _showQuickActionsModal(Map<String, dynamic> student) {
    showModalBottomSheet(
      context: context,
      builder: (context) => _buildQuickActionsModal(student),
    );
  }

  void _toggleStudentSelection(String studentId) {
    setState(() {
      if (_selectedStudents.contains(studentId)) {
        _selectedStudents.remove(studentId);
      } else {
        _selectedStudents.add(studentId);
      }
    });
  }

  void _onAssignmentCreated(Map<String, dynamic> assignment) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content:
            Text('Assignment "${assignment['title']}" created successfully!'),
        backgroundColor: AppTheme.lightTheme.colorScheme.primary,
      ),
    );
  }

  void _onQuestAssigned(Map<String, dynamic> quest) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Quest "${quest['title']}" assigned to class!'),
        backgroundColor: AppTheme.lightTheme.colorScheme.secondary,
      ),
    );
  }

  void _onSendAnnouncement(String recipient, String message) {
    // Handle announcement sending logic
  }

  void _onSendMessage(String recipient, String message) {
    // Handle message sending logic
  }

  void _exportAnalyticsReport() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Analytics report exported successfully!'),
      ),
    );
  }

  void _navigateToOtherScreens() {
    Navigator.pop(context); // Close drawer
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Navigation'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: CustomIconWidget(
                iconName: 'home',
                color: AppTheme.lightTheme.colorScheme.primary,
                size: 24,
              ),
              title: const Text('Splash Screen'),
              onTap: () {
                Navigator.pop(context);
                Navigator.pushNamed(context, '/splash-screen');
              },
            ),
            ListTile(
              leading: CustomIconWidget(
                iconName: 'person_add',
                color: AppTheme.lightTheme.colorScheme.primary,
                size: 24,
              ),
              title: const Text('Student Onboarding'),
              onTap: () {
                Navigator.pop(context);
                Navigator.pushNamed(context, '/student-onboarding-flow');
              },
            ),
            ListTile(
              leading: CustomIconWidget(
                iconName: 'dashboard',
                color: AppTheme.lightTheme.colorScheme.primary,
                size: 24,
              ),
              title: const Text('Student Dashboard'),
              onTap: () {
                Navigator.pop(context);
                Navigator.pushNamed(
                    context, '/personalized-growth-pathway-dashboard');
              },
            ),
            ListTile(
              leading: CustomIconWidget(
                iconName: 'school',
                color: AppTheme.lightTheme.colorScheme.primary,
                size: 24,
              ),
              title: const Text('Mentorship Module'),
              onTap: () {
                Navigator.pop(context);
                Navigator.pushNamed(context, '/mentorship-module');
              },
            ),
            ListTile(
              leading: CustomIconWidget(
                iconName: 'family_restroom',
                color: AppTheme.lightTheme.colorScheme.primary,
                size: 24,
              ),
              title: const Text('Parent Dashboard'),
              onTap: () {
                Navigator.pop(context);
                Navigator.pushNamed(context, '/parent-dashboard');
              },
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.lightTheme.scaffoldBackgroundColor,
      appBar: AppBar(
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Classroom Management',
              style: AppTheme.lightTheme.textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
            Text(
              _selectedSection,
              style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
              ),
            ),
          ],
        ),
        actions: [
          if (_selectedStudents.isNotEmpty)
            Container(
              margin: EdgeInsets.only(right: 2.w),
              padding: EdgeInsets.symmetric(horizontal: 2.w, vertical: 0.5.h),
              decoration: BoxDecoration(
                color: AppTheme.lightTheme.colorScheme.primary,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text(
                '${_selectedStudents.length} selected',
                style: AppTheme.lightTheme.textTheme.labelSmall?.copyWith(
                  color: Colors.white,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          PopupMenuButton<String>(
            icon: CustomIconWidget(
              iconName: 'more_vert',
              color: AppTheme.lightTheme.colorScheme.onSurface,
              size: 24,
            ),
            onSelected: (String value) {
              switch (value) {
                case 'bulk_assign':
                  if (_selectedStudents.isNotEmpty) {
                    _showBulkAssignmentDialog();
                  }
                  break;
                case 'export_data':
                  _exportAnalyticsReport();
                  break;
                case 'settings':
                  // Handle settings
                  break;
              }
            },
            itemBuilder: (BuildContext context) => [
              PopupMenuItem<String>(
                value: 'bulk_assign',
                enabled: _selectedStudents.isNotEmpty,
                child: Row(
                  children: [
                    CustomIconWidget(
                      iconName: 'assignment_ind',
                      color: _selectedStudents.isNotEmpty
                          ? AppTheme.lightTheme.colorScheme.primary
                          : AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                      size: 20,
                    ),
                    SizedBox(width: 2.w),
                    const Text('Bulk Assign'),
                  ],
                ),
              ),
              PopupMenuItem<String>(
                value: 'export_data',
                child: Row(
                  children: [
                    CustomIconWidget(
                      iconName: 'download',
                      color: AppTheme.lightTheme.colorScheme.primary,
                      size: 20,
                    ),
                    SizedBox(width: 2.w),
                    const Text('Export Data'),
                  ],
                ),
              ),
              PopupMenuItem<String>(
                value: 'settings',
                child: Row(
                  children: [
                    CustomIconWidget(
                      iconName: 'settings',
                      color: AppTheme.lightTheme.colorScheme.primary,
                      size: 20,
                    ),
                    SizedBox(width: 2.w),
                    const Text('Settings'),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
      drawer: ClassSectionDrawer(
        classSections: _classSections,
        selectedSection: _selectedSection,
        onSectionSelected: _onSectionSelected,
        onNavigateToOtherScreens: _navigateToOtherScreens,
      ),
      body: Column(
        children: [
          Container(
            padding: EdgeInsets.all(4.w),
            child: TabBar(
              controller: _mainTabController,
              tabs: const [
                Tab(text: 'Students'),
                Tab(text: 'Assignments'),
                Tab(text: 'Analytics'),
                Tab(text: 'Communication'),
              ],
            ),
          ),
          Expanded(
            child: TabBarView(
              controller: _mainTabController,
              children: [
                _buildStudentsTab(),
                _buildAssignmentsTab(),
                _buildAnalyticsTab(),
                _buildCommunicationTab(),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStudentsTab() {
    return RefreshIndicator(
      onRefresh: _refreshData,
      child: Column(
        children: [
          Container(
            padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 2.h),
            child: Row(
              children: [
                Expanded(
                  child: Container(
                    padding: EdgeInsets.symmetric(horizontal: 3.w),
                    decoration: BoxDecoration(
                      border: Border.all(
                        color: AppTheme.lightTheme.colorScheme.outline,
                      ),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: DropdownButtonHideUnderline(
                      child: DropdownButton<String>(
                        value: _selectedFilter,
                        isExpanded: true,
                        items: _filterOptions.map((String filter) {
                          return DropdownMenuItem<String>(
                            value: filter,
                            child: Text(
                              filter,
                              style: AppTheme.lightTheme.textTheme.bodyMedium,
                            ),
                          );
                        }).toList(),
                        onChanged: (String? newValue) {
                          if (newValue != null) {
                            setState(() {
                              _selectedFilter = newValue;
                              _selectedStudents.clear();
                            });
                          }
                        },
                      ),
                    ),
                  ),
                ),
                SizedBox(width: 3.w),
                Container(
                  padding: EdgeInsets.all(2.w),
                  decoration: BoxDecoration(
                    color: AppTheme.lightTheme.colorScheme.primaryContainer
                        .withValues(alpha: 0.3),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    '${_filteredStudents.length} students',
                    style: AppTheme.lightTheme.textTheme.labelMedium?.copyWith(
                      color: AppTheme.lightTheme.colorScheme.primary,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: _isLoading
                ? const Center(child: CircularProgressIndicator())
                : _filteredStudents.isEmpty
                    ? Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            CustomIconWidget(
                              iconName: 'school',
                              color: AppTheme
                                  .lightTheme.colorScheme.onSurfaceVariant,
                              size: 48,
                            ),
                            SizedBox(height: 2.h),
                            Text(
                              'No students found',
                              style: AppTheme.lightTheme.textTheme.titleMedium
                                  ?.copyWith(
                                color: AppTheme
                                    .lightTheme.colorScheme.onSurfaceVariant,
                              ),
                            ),
                            SizedBox(height: 1.h),
                            Text(
                              'Try adjusting your filter settings',
                              style: AppTheme.lightTheme.textTheme.bodySmall,
                            ),
                          ],
                        ),
                      )
                    : ListView.builder(
                        itemCount: _filteredStudents.length,
                        itemBuilder: (context, index) {
                          final student = _filteredStudents[index];
                          final studentId = student['id'] as String;
                          final isSelected =
                              _selectedStudents.contains(studentId);

                          return Container(
                            decoration: BoxDecoration(
                              color: isSelected
                                  ? AppTheme
                                      .lightTheme.colorScheme.primaryContainer
                                      .withValues(alpha: 0.2)
                                  : Colors.transparent,
                            ),
                            child: Row(
                              children: [
                                if (_selectedStudents.isNotEmpty || isSelected)
                                  Checkbox(
                                    value: isSelected,
                                    onChanged: (bool? value) {
                                      _toggleStudentSelection(studentId);
                                    },
                                  ),
                                Expanded(
                                  child: StudentCardWidget(
                                    student: student,
                                    onTap: () => _onStudentTap(student),
                                    onLongPress: () {
                                      if (_selectedStudents.isEmpty) {
                                        _onStudentLongPress(student);
                                      } else {
                                        _toggleStudentSelection(studentId);
                                      }
                                    },
                                  ),
                                ),
                              ],
                            ),
                          );
                        },
                      ),
          ),
        ],
      ),
    );
  }

  Widget _buildAssignmentsTab() {
    return SingleChildScrollView(
      padding: EdgeInsets.all(4.w),
      child: Column(
        children: [
          AssignmentCreationWidget(
            onAssignmentCreated: _onAssignmentCreated,
          ),
          SizedBox(height: 3.h),
          QuestRecommendationWidget(
            onQuestAssigned: _onQuestAssigned,
          ),
        ],
      ),
    );
  }

  Widget _buildAnalyticsTab() {
    return SingleChildScrollView(
      padding: EdgeInsets.all(4.w),
      child: AnalyticsSectionWidget(
        analyticsData: _analyticsData,
        onExportReport: _exportAnalyticsReport,
      ),
    );
  }

  Widget _buildCommunicationTab() {
    return SingleChildScrollView(
      padding: EdgeInsets.all(4.w),
      child: CommunicationToolsWidget(
        onSendAnnouncement: _onSendAnnouncement,
        onSendMessage: _onSendMessage,
      ),
    );
  }

  Widget _buildStudentDetailModal(Map<String, dynamic> student) {
    final name = student['name'] as String? ?? '';
    final xp = student['xp'] as int? ?? 0;
    final completedQuests = student['completedQuests'] as int? ?? 0;
    final currentStreak = student['currentStreak'] as int? ?? 0;
    final skillProgress =
        student['skillProgress'] as Map<String, dynamic>? ?? {};

    return Container(
      height: 80.h,
      decoration: BoxDecoration(
        color: AppTheme.lightTheme.colorScheme.surface,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: Column(
        children: [
          Container(
            width: 12.w,
            height: 0.5.h,
            margin: EdgeInsets.only(top: 2.h),
            decoration: BoxDecoration(
              color: AppTheme.lightTheme.colorScheme.outline,
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          Expanded(
            child: SingleChildScrollView(
              padding: EdgeInsets.all(4.w),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Container(
                        width: 16.w,
                        height: 16.w,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: AppTheme.lightTheme.colorScheme.primary,
                            width: 3,
                          ),
                        ),
                        child: ClipOval(
                          child: CustomImageWidget(
                            imageUrl: student['avatar'] as String? ?? '',
                            width: 16.w,
                            height: 16.w,
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                      SizedBox(width: 4.w),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              name,
                              style: AppTheme.lightTheme.textTheme.headlineSmall
                                  ?.copyWith(
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                            SizedBox(height: 1.h),
                            Row(
                              children: [
                                CustomIconWidget(
                                  iconName: 'star',
                                  color:
                                      AppTheme.lightTheme.colorScheme.secondary,
                                  size: 20,
                                ),
                                SizedBox(width: 1.w),
                                Text(
                                  '$xp XP',
                                  style: AppTheme
                                      .lightTheme.textTheme.titleMedium
                                      ?.copyWith(
                                    color: AppTheme
                                        .lightTheme.colorScheme.secondary,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 3.h),
                  Row(
                    children: [
                      Expanded(
                        child: _buildStatContainer(
                          'Completed Quests',
                          completedQuests.toString(),
                          'task_alt',
                          AppTheme.lightTheme.colorScheme.primary,
                        ),
                      ),
                      SizedBox(width: 3.w),
                      Expanded(
                        child: _buildStatContainer(
                          'Current Streak',
                          '$currentStreak days',
                          'local_fire_department',
                          AppTheme.lightTheme.colorScheme.secondary,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 3.h),
                  Text(
                    'Skill Progress',
                    style: AppTheme.lightTheme.textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  SizedBox(height: 2.h),
                  ...skillProgress.entries.map((entry) {
                    final skillName = entry.key;
                    final progress = (entry.value as num).toDouble();

                    return Container(
                      margin: EdgeInsets.only(bottom: 2.h),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                skillName,
                                style:
                                    AppTheme.lightTheme.textTheme.titleMedium,
                              ),
                              Text(
                                '${progress.toInt()}%',
                                style: AppTheme.lightTheme.textTheme.titleMedium
                                    ?.copyWith(
                                  fontWeight: FontWeight.w600,
                                  color:
                                      AppTheme.lightTheme.colorScheme.primary,
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: 1.h),
                          LinearProgressIndicator(
                            value: progress / 100,
                            backgroundColor: AppTheme
                                .lightTheme.colorScheme.outline
                                .withValues(alpha: 0.3),
                            valueColor: AlwaysStoppedAnimation<Color>(
                              AppTheme.lightTheme.colorScheme.primary,
                            ),
                          ),
                        ],
                      ),
                    );
                  }).toList(),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildQuickActionsModal(Map<String, dynamic> student) {
    final name = student['name'] as String? ?? '';

    return Container(
      padding: EdgeInsets.all(4.w),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            'Quick Actions - $name',
            style: AppTheme.lightTheme.textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.w600,
            ),
          ),
          SizedBox(height: 3.h),
          ListTile(
            leading: CustomIconWidget(
              iconName: 'message',
              color: AppTheme.lightTheme.colorScheme.primary,
              size: 24,
            ),
            title: const Text('Message Parent'),
            onTap: () {
              Navigator.pop(context);
              // Handle message parent action
            },
          ),
          ListTile(
            leading: CustomIconWidget(
              iconName: 'assignment_ind',
              color: AppTheme.lightTheme.colorScheme.secondary,
              size: 24,
            ),
            title: const Text('Assign Individual Quest'),
            onTap: () {
              Navigator.pop(context);
              // Handle assign quest action
            },
          ),
          ListTile(
            leading: CustomIconWidget(
              iconName: 'event',
              color: AppTheme.lightTheme.colorScheme.tertiary,
              size: 24,
            ),
            title: const Text('Schedule Conference'),
            onTap: () {
              Navigator.pop(context);
              // Handle schedule conference action
            },
          ),
        ],
      ),
    );
  }

  Widget _buildStatContainer(
      String title, String value, String iconName, Color color) {
    return Container(
      padding: EdgeInsets.all(3.w),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: color.withValues(alpha: 0.3),
        ),
      ),
      child: Column(
        children: [
          CustomIconWidget(
            iconName: iconName,
            color: color,
            size: 24,
          ),
          SizedBox(height: 1.h),
          Text(
            value,
            style: AppTheme.lightTheme.textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.w700,
              color: color,
            ),
          ),
          SizedBox(height: 0.5.h),
          Text(
            title,
            style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
              color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  void _showBulkAssignmentDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Bulk Assignment'),
        content: Text(
            'Assign quest to ${_selectedStudents.length} selected students?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              setState(() {
                _selectedStudents.clear();
              });
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Quest assigned to selected students!'),
                ),
              );
            },
            child: const Text('Assign'),
          ),
        ],
      ),
    );
  }
}
