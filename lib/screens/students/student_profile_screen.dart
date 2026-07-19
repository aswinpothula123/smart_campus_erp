import 'package:flutter/material.dart';

import '../../models/student.dart';
import '../../services/student_service.dart';
import '../../services/voice_service.dart';
import 'edit_student_screen.dart';
import 'student_id_card_screen.dart';

class StudentProfileScreen extends StatelessWidget {
  const StudentProfileScreen({super.key, required this.student});

  final Student student;

  @override
  Widget build(BuildContext context) {
    final service = StudentService();
    final id = student.id;
    WidgetsBinding.instance.addPostFrameCallback((_) => VoiceService.instance.speak('Student profile opened.'));
    if (id == null) return const Scaffold(body: Center(child: Text('Student record is unavailable.')));
    return StreamBuilder<Student?>(
      stream: service.getStudentStream(id),
      builder: (context, snapshot) {
        final current = snapshot.data ?? student;
        return Scaffold(
          backgroundColor: Colors.grey.shade50,
          appBar: AppBar(title: const Text('Student Profile'), backgroundColor: Colors.indigo, foregroundColor: Colors.white),
          body: SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(children: [
              CircleAvatar(radius: 60, backgroundColor: Colors.indigo.shade100, backgroundImage: current.photoUrl.isNotEmpty ? NetworkImage(current.photoUrl) : null, child: current.photoUrl.isEmpty ? Text(current.name.isEmpty ? '?' : current.name[0].toUpperCase(), style: const TextStyle(fontSize: 40, color: Colors.indigo, fontWeight: FontWeight.bold)) : null),
              const SizedBox(height: 12), Text(current.name, style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold)), Text('Roll No: ${current.rollNo}'), const SizedBox(height: 18),
              _section('Basic Details', [
                _row('Department', current.department, Icons.school), _row('Semester', current.semester, Icons.menu_book), _row('Email', current.email, Icons.email), _row('Phone', current.phone, Icons.phone),
              ]),
              _section('Personal Details', [
                _row('Father Name', current.fatherName, Icons.man), _row('Mother Name', current.motherName, Icons.woman), _row('Date of Birth', current.dateOfBirth, Icons.cake), _row('Gender', current.gender, Icons.people), _row('Blood Group', current.bloodGroup, Icons.bloodtype), _row('Address', current.address, Icons.home), _row('CGPA', current.cgpa, Icons.star),
              ]),
              const SizedBox(height: 16), Wrap(spacing: 10, runSpacing: 10, alignment: WrapAlignment.center, children: [
                ElevatedButton.icon(onPressed: () { VoiceService.instance.speak('Opening editor.'); Navigator.push(context, MaterialPageRoute(builder: (_) => EditStudentScreen(student: current))); }, icon: const Icon(Icons.edit), label: const Text('Edit')),
                ElevatedButton.icon(onPressed: () async { VoiceService.instance.speak('Deleting record.'); final confirm = await showDialog<bool>(context: context, builder: (dialogContext) => AlertDialog(title: const Text('Delete Student'), content: Text('Delete ${current.name} permanently?'), actions: [TextButton(onPressed: () => Navigator.pop(dialogContext, false), child: const Text('Cancel')), ElevatedButton(onPressed: () => Navigator.pop(dialogContext, true), child: const Text('Delete'))])); if (confirm == true) { await service.deleteStudent(current.id!); if (context.mounted) Navigator.pop(context); } }, icon: const Icon(Icons.delete), label: const Text('Delete'), style: ElevatedButton.styleFrom(backgroundColor: Colors.red, foregroundColor: Colors.white)),
                ElevatedButton.icon(onPressed: () { VoiceService.instance.speak('Student ID card generated.'); Navigator.push(context, MaterialPageRoute(builder: (_) => StudentIdCardScreen(student: current))); }, icon: const Icon(Icons.badge), label: const Text('ID Card')),
                ElevatedButton.icon(onPressed: () { VoiceService.instance.speak('QR code generated.'); Navigator.push(context, MaterialPageRoute(builder: (_) => StudentIdCardScreen(student: current))); }, icon: const Icon(Icons.qr_code), label: const Text('QR Code')),
              ]),
            ]),
          ),
        );
      },
    );
  }

  static Widget _section(String title, List<Widget> children) => Card(child: Padding(padding: const EdgeInsets.all(14), child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [Text(title, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.indigo)), const Divider(), ...children])));
  static Widget _row(String label, String value, IconData icon) => ListTile(contentPadding: EdgeInsets.zero, leading: Icon(icon, color: Colors.indigo), title: Text(label), subtitle: Text(value.isEmpty ? '-' : value));
}
