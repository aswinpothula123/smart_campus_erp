import 'package:flutter/material.dart';

import 'screens/attendance/attendance_screen.dart';
import 'screens/auth/login_screen.dart';
import 'screens/auth/register_screen.dart';
import 'screens/courses/course_screen.dart';
import 'screens/dashboard/dashboard_screen.dart';
import 'screens/fees/fees_screen.dart';
import 'screens/notifications/notifications_screen.dart';
import 'screens/onboarding/onboarding_screen.dart';
import 'screens/profile/profile_screen.dart';
import 'screens/reports/reports_screen.dart';
import 'screens/settings/settings_screen.dart';
import 'screens/students/student_screen.dart';
import 'screens/teachers/teacher_screen.dart';
import 'theme/app_theme.dart';

class SmartCampusApp extends StatelessWidget {
  const SmartCampusApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Smart Campus ERP',
      theme: AppTheme.lightTheme(),
      initialRoute: '/',
      routes: {
        '/': (context) => const OnboardingScreen(),
        '/dashboard': (context) => const DashboardScreen(),
        '/login': (context) => const LoginScreen(),
        '/register': (context) => const RegisterScreen(),
        '/students': (context) => const StudentScreen(),
        '/teachers': (context) => const TeacherScreen(),
        '/attendance': (context) => const AttendanceScreen(),
        '/fees': (context) => const FeesScreen(),
        '/courses': (context) => const CourseScreen(),
        '/reports': (context) => const ReportsScreen(),
        '/notifications': (context) => const NotificationsScreen(),
        '/profile': (context) => const ProfileScreen(),
        '/settings': (context) => const SettingsScreen(),
      },
    );
  }
}
