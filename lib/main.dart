import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';

import 'firebase_options.dart';

import 'screens/dashboard/dashboard_screen.dart';
import 'screens/students/student_screen.dart';
import 'screens/teachers/teacher_screen.dart';
import 'screens/attendance/attendance_screen.dart';
import 'screens/fees/fees_screen.dart';
import 'screens/courses/course_screen.dart';

import 'screens/auth/login_screen.dart';
import 'screens/auth/register_screen.dart';
import 'screens/onboarding/onboarding_screen.dart';
import 'screens/notifications/notifications_screen.dart';
import 'screens/profile/profile_screen.dart';
import 'screens/settings/settings_screen.dart';
import 'screens/reports/reports_screen.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  runApp(const SmartCampusApp());
}

class SmartCampusApp extends StatelessWidget {
  const SmartCampusApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: "PACE Smart Campus ERP",

      theme: ThemeData(
        useMaterial3: true,
        colorSchemeSeed: Colors.indigo,
      ),

      initialRoute: "/",

      routes: {
        "/": (context) => const OnboardingScreen(),
        "/dashboard": (context) => const DashboardScreen(),
        "/login": (context) => const LoginScreen(),
        "/register": (context) => const RegisterScreen(),
        "/students": (context) => const StudentScreen(),
        "/teachers": (context) => const TeacherScreen(),
        "/attendance": (context) => const AttendanceScreen(),
        "/fees": (context) => const FeesScreen(),
        "/courses": (context) => const CourseScreen(),
        
        
        "/reports": (context) => const ReportsScreen(),
        "/notifications": (context) => const NotificationsScreen(),
        "/profile": (context) => const ProfileScreen(),
        "/settings": (context) => const SettingsScreen(),
      },
    );
  }
}