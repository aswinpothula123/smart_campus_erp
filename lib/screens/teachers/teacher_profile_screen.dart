import 'package:flutter/material.dart';

import '../../models/teacher.dart';
import 'teacher_id_card_screen.dart';

class TeacherProfileScreen extends StatelessWidget {
  final Teacher teacher;

  const TeacherProfileScreen({
    super.key,
    required this.teacher,
  });

  Widget buildTile(
    IconData icon,
    String title,
    String value,
  ) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: Colors.indigo.shade100,
          child: Icon(
            icon,
            color: Colors.indigo,
          ),
        ),
        title: Text(title),
        subtitle: Text(
          value.isEmpty ? "Not Available" : value,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(

      backgroundColor: Colors.grey.shade100,

      appBar: AppBar(
        title: const Text("Teacher Profile"),
        backgroundColor: Colors.indigo,
        foregroundColor: Colors.white,
      ),

      body: SingleChildScrollView(

        padding: const EdgeInsets.all(20),

        child: Column(

          children: [

            Card(

              elevation: 5,

              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),

              child: Padding(

                padding: const EdgeInsets.all(20),

                child: Column(

                  children: [

                    CircleAvatar(
                      radius: 60,
                      backgroundColor: Colors.indigo,
                      child: Text(
                        teacher.name.isEmpty
                            ? "?"
                            : teacher.name[0].toUpperCase(),
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 40,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),

                    const SizedBox(height: 15),

                    Text(
                      teacher.name,
                      style: const TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),

                    const SizedBox(height: 8),

                    Chip(
                      backgroundColor: Colors.indigo,
                      label: Text(
                        teacher.department,
                        style: const TextStyle(
                          color: Colors.white,
                        ),
                      ),
                    ),

                  ],
                ),
              ),
            ),

            const SizedBox(height: 25),

            buildTile(
              Icons.school,
              "Department",
              teacher.department,
            ),

            buildTile(
              Icons.menu_book,
              "Subject",
              teacher.subject,
            ),

            buildTile(
              Icons.email,
              "Email",
              teacher.email,
            ),

            buildTile(
              Icons.phone,
              "Phone",
              teacher.phone,
            ),

            const SizedBox(height: 25),

            SizedBox(

              width: double.infinity,
              height: 55,

              child: ElevatedButton.icon(

                icon: const Icon(Icons.badge),

                label: const Text(
                  "Teacher ID Card",
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),

                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.indigo,
                  foregroundColor: Colors.white,
                ),

                onPressed: () {

                  Navigator.push(

                    context,

                    MaterialPageRoute(

                      builder: (_) => TeacherIdCardScreen(
                        teacher: teacher,
                      ),

                    ),

                  );

                },

              ),

            ),

          ],

        ),

      ),

    );

  }

}