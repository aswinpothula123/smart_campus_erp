import 'package:cloud_firestore/cloud_firestore.dart';
import 'voice_service.dart';

class AttendanceService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // ===============================
  // SAVE ATTENDANCE
  // ===============================
  Future<void> recordAttendance(
    String studentId,
    String date,
    String status,
  ) async {
    try {
      final DocumentSnapshot studentDoc = await _firestore
          .collection("students")
          .doc(studentId)
          .get();

      if (!studentDoc.exists) {
        throw Exception("Student not found");
      }

      final Map<String, dynamic> student =
          studentDoc.data() as Map<String, dynamic>;

      await _firestore.collection("attendance").add({
        "studentId": studentId,
        "studentName": student["name"] ?? "",
        "rollNo": student["rollNo"] ?? "",
        "department": student["department"] ?? "",
        "semester": student["semester"] ?? "",
        "date": date,
        "status": status,
        "timestamp": FieldValue.serverTimestamp(),
      });
      await VoiceService.instance.speak('Attendance marked successfully.');
    } catch (e) {
      await VoiceService.instance.speakError(e);
      throw Exception("Attendance Error: $e");
    }
  }

  // ===============================
  // GET ATTENDANCE
  // ===============================
  Stream<QuerySnapshot> getAttendanceStream() {
    return _firestore
        .collection("attendance")
        .orderBy("timestamp", descending: true)
        .snapshots();
  }

  // ===============================
  // DELETE ATTENDANCE
  // ===============================
  Future<void> deleteAttendance(String id) async {
    try {
      await _firestore.collection("attendance").doc(id).delete();
      await VoiceService.instance.speak('Attendance deleted.');
    } catch (error) {
      await VoiceService.instance.speakError(error);
      rethrow;
    }
  }
}
