import 'package:flutter/material.dart';

import '../../services/voice_service.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      VoiceService.instance.speak('Profile.');
    });
    return Scaffold(
      appBar: AppBar(
        title: const Text("My Profile"),
        backgroundColor: Colors.indigo,
        foregroundColor: Colors.white,
      ),
      body: const Center(
        child: CircleAvatar(
          radius: 70,
          child: Icon(
            Icons.person,
            size: 70,
          ),
        ),
      ),
    );
  }
}
