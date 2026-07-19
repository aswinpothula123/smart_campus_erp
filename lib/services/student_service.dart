import 'package:cloud_firestore/cloud_firestore.dart';

import '../models/student.dart';
import 'voice_service.dart';

class StudentService {
  StudentService({FirebaseFirestore? firestore}) : _db = firestore ?? FirebaseFirestore.instance;

  final FirebaseFirestore _db;
  static const String collection = 'students';

  CollectionReference<Map<String, dynamic>> get _students => _db.collection(collection);

  Future<void> addStudent(Student student) async {
    try {
      await _ensureRollNumberIsAvailable(student.rollNo);
      final doc = _students.doc();
      await doc.set(student.copyWith(id: doc.id).toMap());
      await VoiceService.instance.speak('Student added successfully.');
    } catch (error) {
      await VoiceService.instance.speakError(error);
      rethrow;
    }
  }

  Stream<List<Student>> getStudentsStream() => _students.snapshots().map(
        (snapshot) => snapshot.docs
            .map((doc) => Student.fromMap(doc.data(), doc.id))
            .toList(),
      );

  Stream<QuerySnapshot<Map<String, dynamic>>> getStudents() => _students.snapshots();

  Stream<Student?> getStudentStream(String id) => _students.doc(id).snapshots().map(
        (doc) => doc.exists ? Student.fromMap(doc.data()!, doc.id) : null,
      );

  Future<Student?> getStudent(String id) async {
    final doc = await _students.doc(id).get();
    return doc.exists ? Student.fromMap(doc.data()!, doc.id) : null;
  }

  Future<void> updateStudent(String id, Student student) async {
    try {
      await _ensureRollNumberIsAvailable(student.rollNo, excludingId: id);
      await _students.doc(id).update(student.copyWith(id: id).toMap());
      await VoiceService.instance.speak('Student updated successfully.');
    } catch (error) {
      await VoiceService.instance.speakError(error);
      rethrow;
    }
  }

  Future<void> deleteStudent(String id) async {
    try {
      await _students.doc(id).delete();
      await VoiceService.instance.speak('Student deleted successfully.');
    } catch (error) {
      await VoiceService.instance.speakError(error);
      rethrow;
    }
  }

  Future<List<Student>> searchStudents(String text) async {
    final query = text.trim().toLowerCase();
    final snapshot = await _students.get();
    return snapshot.docs
        .map((doc) => Student.fromMap(doc.data(), doc.id))
        .where((student) => student.name.toLowerCase().contains(query) || student.rollNo.toLowerCase().contains(query))
        .toList();
  }

  Future<void> _ensureRollNumberIsAvailable(String rollNo, {String? excludingId}) async {
    final matches = await _students.where('rollNo', isEqualTo: rollNo.trim()).limit(2).get();
    if (matches.docs.any((doc) => doc.id != excludingId)) {
      throw StateError('A student with this roll number already exists.');
    }
  }
}
