import 'package:flutter/material.dart';

import '../../services/voice_service.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      VoiceService.instance.speak('Settings.');
    });
    return Scaffold(
      backgroundColor: Colors.grey.shade100,

      appBar: AppBar(
        title: const Text("Settings"),
        backgroundColor: Colors.indigo,
        foregroundColor: Colors.white,
        centerTitle: true,
      ),

      body: ListView(
        children: [

          const SizedBox(height: 10),

          ListTile(
            leading: const Icon(Icons.dark_mode),
            title: const Text("Dark Mode"),
            trailing: Switch(
              value: false,
              onChanged: (value) {},
            ),
          ),

          const Divider(),

          ListTile(
            leading: const Icon(Icons.language),
            title: const Text("Language"),
            subtitle: const Text("English"),
            trailing: const Icon(Icons.arrow_forward_ios),
            onTap: () {},
          ),

          const Divider(),

          ListTile(
            leading: const Icon(Icons.notifications),
            title: const Text("Notifications"),
            trailing: const Icon(Icons.arrow_forward_ios),
            onTap: () {},
          ),

          const Divider(),

          ListTile(
            leading: const Icon(Icons.security),
            title: const Text("Privacy & Security"),
            trailing: const Icon(Icons.arrow_forward_ios),
            onTap: () {},
          ),

          const Divider(),

          ListTile(
            leading: const Icon(Icons.info),
            title: const Text("About App"),
            trailing: const Icon(Icons.arrow_forward_ios),
            onTap: () {},
          ),

          const Divider(),

          ListTile(
            leading: const Icon(Icons.help),
            title: const Text("Help & Support"),
            trailing: const Icon(Icons.arrow_forward_ios),
            onTap: () {},
          ),

          const Divider(),

          ListTile(
            leading: const Icon(
              Icons.logout,
              color: Colors.red,
            ),
            title: const Text(
              "Logout",
              style: TextStyle(color: Colors.red),
            ),
            onTap: () {},
          ),

        ],
      ),
    );
  }
}
