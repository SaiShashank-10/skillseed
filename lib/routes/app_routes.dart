import 'package:flutter/material.dart';
import '../presentation/student_onboarding_flow/student_onboarding_flow.dart';
import '../presentation/splash_screen/splash_screen.dart';
import '../presentation/mentorship_module/mentorship_module.dart';
import '../presentation/personalized_growth_pathway_dashboard/personalized_growth_pathway_dashboard.dart';
import '../presentation/teacher_classroom_management/teacher_classroom_management.dart';
import '../presentation/parent_dashboard/parent_dashboard.dart';

class AppRoutes {
  // TODO: Add your routes here
  static const String initial = '/';
  static const String studentOnboardingFlow = '/student-onboarding-flow';
  static const String splash = '/splash-screen';
  static const String mentorshipModule = '/mentorship-module';
  static const String personalizedGrowthPathwayDashboard =
      '/personalized-growth-pathway-dashboard';
  static const String teacherClassroomManagement =
      '/teacher-classroom-management';
  static const String parentDashboard = '/parent-dashboard';

  static Map<String, WidgetBuilder> routes = {
    initial: (context) => const SplashScreen(),
    studentOnboardingFlow: (context) => const StudentOnboardingFlow(),
    splash: (context) => const SplashScreen(),
    mentorshipModule: (context) => const MentorshipModule(),
    personalizedGrowthPathwayDashboard: (context) =>
        const PersonalizedGrowthPathwayDashboard(),
    teacherClassroomManagement: (context) => const TeacherClassroomManagement(),
    parentDashboard: (context) => const ParentDashboard(),
    // TODO: Add your other routes here
  };
}
