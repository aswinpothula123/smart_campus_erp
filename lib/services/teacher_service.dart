import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/teacher.dart';
import 'voice_service.dart';

class TeacherService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  CollectionReference get teacherCollection =>
      _firestore.collection("teachers");

  // ==========================
  // ADD TEACHER
  // ==========================
  Future<void> insertTeacher(Teacher teacher) async {
    try {
      await teacherCollection.add(teacher.toMap());
      await VoiceService.instance.speak('Teacher added successfully.');
    } catch (error) {
      await VoiceService.instance.speakError(error);
      rethrow;
    }
  }

  // ==========================
  // GET ALL TEACHERS
  // ==========================
  Stream<List<Teacher>> getTeachersStream() {
    return teacherCollection.snapshots().map((snapshot) {
      return snapshot.docs.map((doc) {
        return Teacher.fromMap(
          doc.data() as Map<String, dynamic>,
          doc.id,
        );
      }).toList();
    });
  }

  // Optional alias
  Stream<List<Teacher>> getTeachers() {
    return getTeachersStream();
  }

  // ==========================
  // UPDATE TEACHER
  // ==========================
  Future<void> updateTeacher({
    required String id,
    required Teacher teacher,
  }) async {
    try {
      await teacherCollection.doc(id).update(teacher.toMap());
      await VoiceService.instance.speak('Teacher updated successfully.');
    } catch (error) {
      await VoiceService.instance.speakError(error);
      rethrow;
    }
  }

  // ==========================
  // DELETE TEACHER
  // ==========================
  Future<void> deleteTeacher(String id) async {
    try {
      await teacherCollection.doc(id).delete();
      await VoiceService.instance.speak('Teacher deleted successfully.');
    } catch (error) {
      await VoiceService.instance.speakError(error);
      rethrow;
    }
  }
}
