import 'package:flutter/material.dart';


class OnboardingModel {

  final String title;

  final String description;

  final IconData icon;


  OnboardingModel({

    required this.title,

    required this.description,

    required this.icon,

  });

}



final List<OnboardingModel> onboardingPages = [


  OnboardingModel(

    title: "Smart Campus ERP",

    description:
        "Manage students, teachers and campus activities easily",

    icon: Icons.school,

  ),



  OnboardingModel(

    title: "Student Management",

    description:
        "Add students, view profiles and manage records",

    icon: Icons.people,

  ),



  OnboardingModel(

    title: "Digital Campus",

    description:
        "Attendance, assignments, fees and notifications",

    icon: Icons.dashboard,

  ),


];