import 'package:flutter/material.dart';

import '../../models/student.dart';
import '../../services/student_service.dart';
import '../../services/voice_service.dart';
import 'student_profile_screen.dart';
import 'add_student_screen.dart';

class StudentScreen extends StatefulWidget {
  const StudentScreen({super.key});

  @override
  State<StudentScreen> createState() => _StudentScreenState();
}

class _StudentScreenState extends State<StudentScreen> {
  final StudentService _studentService = StudentService();
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      VoiceService.instance.speak('Student Management.');
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade50,
      appBar: AppBar(
        title: const Text('Student Directory', style: TextStyle(fontWeight: FontWeight.bold)),
        backgroundColor: Colors.indigo,
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      body: Column(
        children: [
          Container(
            color: Colors.indigo,
            padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
            child: TextField(
              controller: _searchController,
              onChanged: (_) => setState(() {}),
              decoration: InputDecoration(
                hintText: 'Search by name or roll number',
                hintStyle: const TextStyle(color: Colors.white70),
                prefixIcon: const Icon(Icons.search, color: Colors.white),
                filled: true,
                fillColor: Colors.white.withValues(alpha: 0.16),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none,
                ),
              ),
              style: const TextStyle(color: Colors.white),
            ),
          ),
          Expanded(
            child: StreamBuilder<List<Student>>(
              stream: _studentService.getStudentsStream(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }

                if (snapshot.hasError) {
                  return Center(child: Text('Error loading students: ${snapshot.error}'));
                }

                final students = (snapshot.data ?? []).where((student) {
                  final query = _searchController.text.trim().toLowerCase();
                  if (query.isEmpty) return true;
                  return student.name.toLowerCase().contains(query) ||
                      student.rollNo.toLowerCase().contains(query);
                }).toList();

                if (students.isEmpty) {
                  return const Center(
                    child: Text('No students found for the current search.'),
                  );
                }

                return ListView.builder(
                  padding: const EdgeInsets.all(12),
                  itemCount: students.length,
                  itemBuilder: (context, index) {
                    final student = students[index];
                    return Card(
                      margin: const EdgeInsets.only(bottom: 10),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                      child: ListTile(
                        onTap: () {
                          VoiceService.instance.speak('Student profile opened.');
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => StudentProfileScreen(student: student),
                            ),
                          );
                        },
                        leading: CircleAvatar(
                          backgroundColor: Colors.indigo.shade100,
                          child: Text(
                            student.name.isNotEmpty ? student.name[0].toUpperCase() : '?',
                            style: const TextStyle(color: Colors.indigo, fontWeight: FontWeight.bold),
                          ),
                        ),
                        title: Text(student.name, style: const TextStyle(fontWeight: FontWeight.bold)),
                        subtitle: Text('${student.rollNo} • ${student.department} • Sem ${student.semester}'),
                        trailing: const Icon(Icons.chevron_right, color: Colors.indigo),
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.indigo,
        foregroundColor: Colors.white,
        onPressed: () {
          VoiceService.instance.speak('Add student.');
          Navigator.push(context, MaterialPageRoute(builder: (_) => const AddStudentScreen()));
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}

class SearchStudentScreen extends StatelessWidget {
  const SearchStudentScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const StudentScreen();
  }
}
