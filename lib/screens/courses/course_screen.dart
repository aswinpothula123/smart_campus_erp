import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../services/course_service.dart';
import '../../services/voice_service.dart';

class CourseScreen extends StatefulWidget {
  const CourseScreen({super.key});

  @override
  State<CourseScreen> createState() => _CourseScreenState();
}

class _CourseScreenState extends State<CourseScreen> {
  final CourseService _courseService = CourseService();
  String _activeDept = "CSE";

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      VoiceService.instance.speak('Courses.');
    });
  }

  void _showAddCourseDialog() {
    final nameCtrl = TextEditingController();
    final codeCtrl = TextEditingController();

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Text("Add Course to $_activeDept", style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.indigo)),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(controller: nameCtrl, decoration: const InputDecoration(labelText: "Course Name", prefixIcon: Icon(Icons.book))),
            const SizedBox(height: 12),
            TextField(controller: codeCtrl, decoration: const InputDecoration(labelText: "Course Code", prefixIcon: Icon(Icons.code))),
          ],
        ),
        actions: [
          TextButton(onPressed: () {
            VoiceService.instance.speak('Cancel.');
            Navigator.pop(context);
          }, child: const Text("Cancel")),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: Colors.indigo, foregroundColor: Colors.white),
            onPressed: () async {
              VoiceService.instance.speak('Saving data.');
              if (nameCtrl.text.isNotEmpty && codeCtrl.text.isNotEmpty) {
                // Save as uppercase to keep Firestore clean going forward
                await _courseService.addCourse(nameCtrl.text.trim(), codeCtrl.text.trim(), _activeDept.toUpperCase());
                if (context.mounted) Navigator.pop(context);
              }
            },
            child: const Text("Save"),
          )
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade50,
      appBar: AppBar(
        title: const Text("Departmental Syllabus Mapping", style: TextStyle(fontWeight: FontWeight.bold)), 
        backgroundColor: Colors.indigo, 
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.indigo, 
        foregroundColor: Colors.white, 
        onPressed: () {
          VoiceService.instance.speak('Add course.');
          _showAddCourseDialog();
        }, 
        child: const Icon(Icons.add)
      ),
      body: Column(
        children: [
          Container(
            color: Colors.indigo,
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
              child: Row(
                children: ["CSE", "ECE", "EEE", "CIVIL", "MECH"].map((dept) {
                  bool isSelected = _activeDept == dept;
                  return Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 4.0),
                    child: ChoiceChip(
                      label: Text(dept, style: TextStyle(color: isSelected ? Colors.indigo : Colors.white, fontWeight: FontWeight.bold)),
                      selected: isSelected,
                      selectedColor: Colors.white,
                      backgroundColor: Colors.indigo.shade400,
                      onSelected: (val) => setState(() => _activeDept = dept),
                    ),
                  );
                }).toList(),
              ),
            ),
          ),
          Expanded(
            child: StreamBuilder<QuerySnapshot>(
              stream: _courseService.getCoursesStream(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) return const Center(child: CircularProgressIndicator());
                if (snapshot.hasError) return Center(child: Text("Error loading courses: ${snapshot.error}"));
                
                // Case-insensitive filtering mapping loop
                final docs = (snapshot.data?.docs ?? []).where((doc) {
                  final data = doc.data() as Map<String, dynamic>;
                  final String docDept = (data['department'] ?? '').toString().toUpperCase();
                  return docDept == _activeDept.toUpperCase();
                }).toList();

                if (docs.isEmpty) {
                  return Center(child: Text("No courses mapped for Department: $_activeDept", style: const TextStyle(fontSize: 16, color: Colors.grey)));
                }

                return ListView.builder(
                  padding: const EdgeInsets.all(12),
                  itemCount: docs.length,
                  itemBuilder: (context, index) {
                    final data = docs[index].data() as Map<String, dynamic>;
                    return Card(
                      elevation: 2,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      margin: const EdgeInsets.only(bottom: 10),
                      child: ListTile(
                        leading: const CircleAvatar(backgroundColor: Colors.indigo, child: Icon(Icons.menu_book, color: Colors.white)),
                        title: Text(data['courseName']?.toString().toUpperCase() ?? 'UNNAMED COURSE', style: const TextStyle(fontWeight: FontWeight.bold)),
                        subtitle: Text("Code Reference: ${data['courseCode'] ?? 'N/A'}", style: const TextStyle(color: Colors.grey)),
                      ),
                    );
                  },
                );
              },
            ),
          )
        ],
      ),
    );
  }
}
