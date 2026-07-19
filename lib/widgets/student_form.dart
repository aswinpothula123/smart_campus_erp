import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

import '../models/student.dart';
import '../services/storage_service.dart';
import '../services/student_service.dart';
import '../services/voice_service.dart';

class StudentForm extends StatefulWidget {
  const StudentForm({super.key, this.student});

  final Student? student;

  @override
  State<StudentForm> createState() => _StudentFormState();
}

class _StudentFormState extends State<StudentForm> {
  final _formKey = GlobalKey<FormState>();
  final _studentService = StudentService();
  final _storageService = StorageService();
  final _picker = ImagePicker();

  late final TextEditingController _name;
  late final TextEditingController _rollNo;
  late final TextEditingController _department;
  late final TextEditingController _semester;
  late final TextEditingController _email;
  late final TextEditingController _phone;
  late final TextEditingController _fatherName;
  late final TextEditingController _motherName;
  late final TextEditingController _dateOfBirth;
  late final TextEditingController _bloodGroup;
  late final TextEditingController _address;
  late final TextEditingController _cgpa;
  late String _gender;
  File? _selectedPhoto;
  bool _saving = false;

  @override
  void initState() {
    super.initState();
    final student = widget.student;
    _name = TextEditingController(text: student?.name ?? '');
    _rollNo = TextEditingController(text: student?.rollNo ?? '');
    _department = TextEditingController(text: student?.department ?? '');
    _semester = TextEditingController(text: student?.semester ?? '');
    _email = TextEditingController(text: student?.email ?? '');
    _phone = TextEditingController(text: student?.phone ?? '');
    _fatherName = TextEditingController(text: student?.fatherName ?? '');
    _motherName = TextEditingController(text: student?.motherName ?? '');
    _dateOfBirth = TextEditingController(text: student?.dateOfBirth ?? '');
    _bloodGroup = TextEditingController(text: student?.bloodGroup ?? '');
    _address = TextEditingController(text: student?.address ?? '');
    _cgpa = TextEditingController(text: student?.cgpa ?? '');
    _gender = student?.gender.isNotEmpty == true ? student!.gender : 'Male';
  }

  @override
  void dispose() {
    for (final controller in [_name, _rollNo, _department, _semester, _email, _phone, _fatherName, _motherName, _dateOfBirth, _bloodGroup, _address, _cgpa]) {
      controller.dispose();
    }
    super.dispose();
  }

  Future<void> _pickPhoto() async {
    final file = await _picker.pickImage(source: ImageSource.gallery, imageQuality: 80);
    if (file != null && mounted) setState(() => _selectedPhoto = File(file.path));
  }

  Future<void> _save() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _saving = true);
    VoiceService.instance.speak(widget.student == null ? 'Saving data.' : 'Updating data.');
    try {
      var photoUrl = widget.student?.photoUrl ?? '';
      if (_selectedPhoto != null) {
        photoUrl = widget.student == null
            ? await _storageService.uploadStudentImage(_selectedPhoto!)
            : await _storageService.updateStudentImage(oldImageUrl: photoUrl, newImage: _selectedPhoto!);
      }
      final student = Student(
        id: widget.student?.id,
        name: _name.text.trim(),
        rollNo: _rollNo.text.trim(),
        department: _department.text.trim(),
        semester: _semester.text.trim(),
        email: _email.text.trim(),
        phone: _phone.text.trim(),
        photoUrl: photoUrl,
        fatherName: _fatherName.text.trim(),
        motherName: _motherName.text.trim(),
        dateOfBirth: _dateOfBirth.text.trim(),
        gender: _gender,
        bloodGroup: _bloodGroup.text.trim(),
        address: _address.text.trim(),
        cgpa: _cgpa.text.trim(),
      );
      if (widget.student == null) {
        await _studentService.addStudent(student);
      } else {
        await _studentService.updateStudent(widget.student!.id!, student);
      }
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        backgroundColor: Colors.green,
        content: Text(widget.student == null ? 'Student Added Successfully' : 'Student Updated Successfully'),
      ));
      Navigator.pop(context, true);
    } catch (error) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(backgroundColor: Colors.red, content: Text(error.toString())));
    } finally {
      if (mounted) setState(() => _saving = false);
    }
  }

  String? _required(String? value, String label) => value == null || value.trim().isEmpty ? 'Enter $label' : null;

  Widget _field(
    TextEditingController controller,
    String label,
    IconData icon, {
    int lines = 1,
    String? Function(String?)? validator,
    TextInputType? keyboardType,
  }) => Padding(
        padding: const EdgeInsets.only(bottom: 15),
        child: TextFormField(
          controller: controller,
          maxLines: lines,
          keyboardType: keyboardType,
          validator: validator ?? (value) => _required(value, label),
          decoration: InputDecoration(
            labelText: label,
            prefixIcon: Icon(icon, color: Colors.indigo),
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
          ),
        ),
      );

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(title: Text(widget.student == null ? 'Add Student' : 'Edit Student'), backgroundColor: Colors.indigo, foregroundColor: Colors.white),
        body: Form(
          key: _formKey,
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(20),
            child: Column(children: [
              InkWell(
                onTap: _pickPhoto,
                borderRadius: BorderRadius.circular(60),
                child: CircleAvatar(radius: 55, backgroundColor: Colors.indigo.shade100,
                  backgroundImage: _selectedPhoto != null ? FileImage(_selectedPhoto!) : (widget.student?.photoUrl.isNotEmpty == true ? NetworkImage(widget.student!.photoUrl) : null) as ImageProvider?,
                  child: _selectedPhoto == null && (widget.student?.photoUrl.isEmpty ?? true) ? const Icon(Icons.add_a_photo, color: Colors.indigo, size: 34) : null),
              ),
              const SizedBox(height: 20),
              _field(_name, 'Student Name', Icons.person, validator: (value) => _required(value, 'Student Name')),
              _field(_rollNo, 'Roll Number', Icons.badge, validator: (value) => _required(value, 'Roll Number')),
              _field(_department, 'Department', Icons.school, validator: (value) => _required(value, 'Department')),
              _field(_semester, 'Semester', Icons.menu_book, validator: (value) => _required(value, 'Semester')),
              _field(_email, 'Email', Icons.email, validator: (value) => value == null || !RegExp(r'^\S+@\S+\.\S+$').hasMatch(value.trim()) ? 'Enter a valid email address' : null, keyboardType: TextInputType.emailAddress),
              _field(_phone, 'Phone', Icons.phone, validator: (value) => value == null || value.trim().length < 10 ? 'Enter a valid phone number' : null, keyboardType: TextInputType.phone),
              const Align(alignment: Alignment.centerLeft, child: Text('Personal Details', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.indigo))),
              const SizedBox(height: 12),
              _field(_fatherName, 'Father Name', Icons.man, validator: (value) => _required(value, 'Father Name')),
              _field(_motherName, 'Mother Name', Icons.woman, validator: (value) => _required(value, 'Mother Name')),
              _field(_dateOfBirth, 'Date of Birth', Icons.cake, validator: (value) => _required(value, 'Date of Birth')),
              DropdownButtonFormField<String>(
                initialValue: _gender,
                decoration: const InputDecoration(labelText: 'Gender', prefixIcon: Icon(Icons.people), border: OutlineInputBorder()),
                items: const [DropdownMenuItem(value: 'Male', child: Text('Male')), DropdownMenuItem(value: 'Female', child: Text('Female')), DropdownMenuItem(value: 'Other', child: Text('Other'))],
                validator: (value) => value == null || value.isEmpty ? 'Select gender' : null,
                onChanged: (value) => setState(() => _gender = value ?? 'Male'),
              ),
              const SizedBox(height: 15), _field(_bloodGroup, 'Blood Group', Icons.bloodtype, validator: (value) => _required(value, 'Blood Group')), _field(_address, 'Address', Icons.home, lines: 3, validator: (value) => _required(value, 'Address')), _field(_cgpa, 'CGPA', Icons.star, validator: (value) => _required(value, 'CGPA')),
              const SizedBox(height: 15), SizedBox(width: double.infinity, height: 55, child: ElevatedButton.icon(onPressed: _saving ? null : _save, icon: _saving ? const SizedBox.square(dimension: 20, child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2)) : const Icon(Icons.save), label: Text(widget.student == null ? 'Save Student' : 'Update Student'), style: ElevatedButton.styleFrom(backgroundColor: Colors.indigo, foregroundColor: Colors.white))),
            ]),
          ),
        ),
      );
}
