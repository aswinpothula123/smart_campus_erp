import 'package:flutter/material.dart';

import '../../models/student.dart';
import '../../widgets/student_form.dart';

class EditStudentScreen extends StatelessWidget {
  final Student student;

  const EditStudentScreen({
    super.key,
    required this.student,
  });

  @override
  Widget build(BuildContext context) {
    return StudentForm(student: student);
  }
}
