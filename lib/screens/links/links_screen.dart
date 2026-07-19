import 'package:flutter/material.dart';

class LinksScreen extends StatelessWidget {
  const LinksScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Useful Links"),
        backgroundColor: Colors.indigo,
        foregroundColor: Colors.white,
      ),
      body: const Center(
        child: Text(
          "Useful Links Coming Soon",
          style: TextStyle(fontSize: 24),
        ),
      ),
    );
  }
}
