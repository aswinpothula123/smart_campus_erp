import 'package:flutter/material.dart';
import '../../models/teacher.dart';
import '../../services/teacher_service.dart';
import '../../services/voice_service.dart';
import 'teacher_profile_screen.dart';

class TeacherScreen extends StatefulWidget {
  const TeacherScreen({super.key});

  @override
  State<TeacherScreen> createState() => _TeacherScreenState();
}

class _TeacherScreenState extends State<TeacherScreen> {
  final TeacherService _teacherService = TeacherService();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      VoiceService.instance.speak('Teacher Management.');
    });
  }

  void _showFormDialog({Teacher? teacher}) {
    final nameController =
        TextEditingController(text: teacher?.name ?? "");

    final employeeIdController =
        TextEditingController(text: teacher?.employeeId ?? "");

    final departmentController =
        TextEditingController(text: teacher?.department ?? "");

    final subjectController =
        TextEditingController(text: teacher?.subject ?? "");

    final emailController =
        TextEditingController(text: teacher?.email ?? "");

    final phoneController =
        TextEditingController(text: teacher?.phone ?? "");

    final qualificationController =
        TextEditingController(text: teacher?.qualification ?? "");

    final experienceController =
        TextEditingController(text: teacher?.experience ?? "");

    final photoController =
        TextEditingController(text: teacher?.photoUrl ?? "");

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(
            teacher == null
                ? "Add Teacher"
                : "Edit Teacher",
          ),
          content: SizedBox(
            width: 400,
            child: SingleChildScrollView(
              child: Column(
                children: [

                  TextField(
                    controller: nameController,
                    decoration: const InputDecoration(
                      labelText: "Teacher Name",
                    ),
                  ),

                  const SizedBox(height: 10),

                  TextField(
                    controller: employeeIdController,
                    decoration: const InputDecoration(
                      labelText: "Employee ID",
                    ),
                  ),

                  const SizedBox(height: 10),

                  TextField(
                    controller: departmentController,
                    decoration: const InputDecoration(
                      labelText: "Department",
                    ),
                  ),

                  const SizedBox(height: 10),

                  TextField(
                    controller: subjectController,
                    decoration: const InputDecoration(
                      labelText: "Subject",
                    ),
                  ),

                  const SizedBox(height: 10),

                  TextField(
                    controller: emailController,
                    decoration: const InputDecoration(
                      labelText: "Email",
                    ),
                  ),

                  const SizedBox(height: 10),

                  TextField(
                    controller: phoneController,
                    decoration: const InputDecoration(
                      labelText: "Phone",
                    ),
                  ),

                  const SizedBox(height: 10),

                  TextField(
                    controller: qualificationController,
                    decoration: const InputDecoration(
                      labelText: "Qualification",
                    ),
                  ),

                  const SizedBox(height: 10),

                  TextField(
                    controller: experienceController,
                    decoration: const InputDecoration(
                      labelText: "Experience",
                    ),
                  ),

                  const SizedBox(height: 10),

                  TextField(
                    controller: photoController,
                    decoration: const InputDecoration(
                      labelText: "Photo URL",
                    ),
                  ),
                ],
              ),
            ),
          ),
          actions: [

            TextButton(
            onPressed: () {
                VoiceService.instance.speak('Cancel.');
                Navigator.pop(context);
              },
              child: const Text("Cancel"),
            ),

            ElevatedButton(
              onPressed: () async {

                VoiceService.instance.speak(
                  teacher == null ? 'Saving data.' : 'Updating data.',
                );

                final newTeacher = Teacher(
                  id: teacher?.id,
                  name: nameController.text.trim(),
                  employeeId:
                      employeeIdController.text.trim(),
                  department:
                      departmentController.text.trim(),
                  subject:
                      subjectController.text.trim(),
                  email:
                      emailController.text.trim(),
                  phone:
                      phoneController.text.trim(),
                  qualification:
                      qualificationController.text.trim(),
                  experience:
                      experienceController.text.trim(),
                  photoUrl:
                      photoController.text.trim(),
                );

                final dialogContext = context;

                if (teacher == null) {
                  await _teacherService.insertTeacher(
                    newTeacher,
                  );
                } else {
                  await _teacherService.updateTeacher(
                    id: teacher.id!,
                    teacher: newTeacher,
                  );
                }

                if (!mounted) return;
                if (dialogContext.mounted) {
                  Navigator.of(dialogContext).pop();
                }
              },
              child: const Text("Save"),
            ),

          ],
        );
      },
    );
  }

    @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Teacher Management"),
        backgroundColor: Colors.indigo,
        foregroundColor: Colors.white,
      ),

      body: StreamBuilder<List<Teacher>>(
        stream: _teacherService.getTeachersStream(),
        builder: (context, snapshot) {

          if (snapshot.hasError) {
            return Center(
              child: Text(
                snapshot.error.toString(),
              ),
            );
          }

          if (snapshot.connectionState ==
              ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          final teachers = snapshot.data ?? [];

          if (teachers.isEmpty) {
            return const Center(
              child: Text(
                "No Teachers Found",
              ),
            );
          }

          return ListView.builder(
            padding: const EdgeInsets.all(10),
            itemCount: teachers.length,

            itemBuilder: (context, index) {

              final teacher = teachers[index];

              return Card(
                elevation: 4,
                margin:
                    const EdgeInsets.symmetric(vertical: 6),

                child: ListTile(

                  leading: CircleAvatar(
                    radius: 28,

                    backgroundImage:
                        teacher.photoUrl.isNotEmpty
                            ? NetworkImage(
                                teacher.photoUrl,
                              )
                            : null,

                    child: teacher.photoUrl.isEmpty
                        ? Text(
                            teacher.name.isNotEmpty
                                ? teacher.name[0]
                                    .toUpperCase()
                                : "T",
                          )
                        : null,
                  ),

                  title: Text(
                    teacher.name,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  subtitle: Column(
                    crossAxisAlignment:
                        CrossAxisAlignment.start,
                    children: [

                      Text(
                        "Employee ID : ${teacher.employeeId}",
                      ),

                      Text(
                        "Department : ${teacher.department}",
                      ),

                      Text(
                        "Subject : ${teacher.subject}",
                      ),

                    ],
                  ),

                  onTap: () {

                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) =>
                            TeacherProfileScreen(
                          teacher: teacher,
                        ),
                      ),
                    );

                  },

                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [

                                            IconButton(
                        icon: const Icon(
                          Icons.edit,
                          color: Colors.indigo,
                        ),
                        onPressed: () {
                          VoiceService.instance.speak('Opening editor.');
                          _showFormDialog(
                            teacher: teacher,
                          );
                        },
                      ),

                      IconButton(
                        icon: const Icon(
                          Icons.delete,
                          color: Colors.red,
                        ),
                        onPressed: () async {

                          VoiceService.instance.speak('Deleting record.');

                          final confirm =
                              await showDialog<bool>(
                            context: context,
                            builder: (context) {
                              return AlertDialog(
                                title: const Text(
                                  "Delete Teacher",
                                ),
                                content: Text(
                                  "Delete ${teacher.name} permanently?",
                                ),
                                actions: [

                                  TextButton(
                                    onPressed: () {
                                      Navigator.pop(
                                        context,
                                        false,
                                      );
                                    },
                                    child: const Text(
                                      "Cancel",
                                    ),
                                  ),

                                  ElevatedButton(
                                    style:
                                        ElevatedButton.styleFrom(
                                      backgroundColor:
                                          Colors.red,
                                    ),
                                    onPressed: () {
                                      Navigator.pop(
                                        context,
                                        true,
                                      );
                                    },
                                    child: const Text(
                                      "Delete",
                                    ),
                                  ),

                                ],
                              );
                            },
                          );

                          if (confirm == true &&
                              teacher.id != null) {
                            await _teacherService.deleteTeacher(teacher.id!);
                            if (!mounted) return;
                            if (!context.mounted) return;
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(content: Text('${teacher.name} deleted.')),
                            );
                          }
                        },
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),

      floatingActionButton:
          FloatingActionButton(
        backgroundColor: Colors.indigo,
        foregroundColor: Colors.white,
        onPressed: () {
          VoiceService.instance.speak('Add teacher.');
          _showFormDialog();
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
