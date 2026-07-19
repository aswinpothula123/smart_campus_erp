import 'package:flutter/material.dart';
import 'package:qr_flutter/qr_flutter.dart';

import '../../models/teacher.dart';

class TeacherIdCardScreen extends StatelessWidget {
  final Teacher teacher;

  const TeacherIdCardScreen({
    super.key,
    required this.teacher,
  });

  @override
  Widget build(BuildContext context) {
    final String qrData = '''
PACE Institute of Technology and Sciences
Teacher Name : ${teacher.name}
Department : ${teacher.department}
Subject : ${teacher.subject}
Email : ${teacher.email}
Phone : ${teacher.phone}
''';

    return Scaffold(
      backgroundColor: Colors.grey.shade100,

      appBar: AppBar(
        title: const Text("Teacher ID Card"),
        centerTitle: true,
        backgroundColor: Colors.indigo,
        foregroundColor: Colors.white,
      ),

      body: Center(
        child: SingleChildScrollView(
          child: Card(
            elevation: 10,
            margin: const EdgeInsets.all(20),

            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(25),
            ),

            child: Container(
              width: 350,
              padding: const EdgeInsets.all(20),

              child: Column(
                mainAxisSize: MainAxisSize.min,

                children: [

                  const CircleAvatar(
                    radius: 35,
                    backgroundColor: Colors.indigo,
                    child: Icon(
                      Icons.school,
                      size: 40,
                      color: Colors.white,
                    ),
                  ),

                  const SizedBox(height: 12),

                  const Text(
                    "PACE INSTITUTE OF TECHNOLOGY AND SCIENCES",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                      color: Colors.indigo,
                    ),
                  ),

                  const Text(
                    "Autonomous | Ongole",
                    style: TextStyle(
                      color: Colors.grey,
                    ),
                  ),

                  const Divider(
                    height: 30,
                  ),

                  CircleAvatar(
                    radius: 50,
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
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 22,
                    ),
                  ),

                  const SizedBox(height: 5),

                  Chip(
                    backgroundColor: Colors.indigo,
                    label: Text(
                      teacher.department,
                      style: const TextStyle(
                        color: Colors.white,
                      ),
                    ),
                  ),

                  const SizedBox(height: 20),

                  buildRow(
                    Icons.menu_book,
                    "Subject",
                    teacher.subject,
                  ),

                  buildRow(
                    Icons.email,
                    "Email",
                    teacher.email,
                  ),

                  buildRow(
                    Icons.phone,
                    "Phone",
                    teacher.phone,
                  ),

                  const SizedBox(height: 20),

                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      border: Border.all(
                        color: Colors.indigo,
                      ),
                      borderRadius: BorderRadius.circular(15),
                    ),
                    child: QrImageView(
                      data: qrData,
                      size: 180,
                    ),
                  ),

                  const SizedBox(height: 15),

                  const Text(
                    "SMART CAMPUS ERP",
                    style: TextStyle(
                      color: Colors.indigo,
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  const SizedBox(height: 5),

                  const Text(
                    "Scan QR to verify teacher details",
                    style: TextStyle(
                      color: Colors.grey,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget buildRow(
    IconData icon,
    String title,
    String value,
  ) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        children: [

          Icon(
            icon,
            color: Colors.indigo,
          ),

          const SizedBox(width: 12),

          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [

                Text(
                  title,
                  style: const TextStyle(
                    color: Colors.grey,
                    fontSize: 12,
                  ),
                ),

                Text(
                  value.isEmpty
                      ? "Not Available"
                      : value,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                  ),
                ),

              ],
            ),
          ),
        ],
      ),
    );
  }
}