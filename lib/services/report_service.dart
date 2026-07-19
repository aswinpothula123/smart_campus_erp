import 'package:cloud_firestore/cloud_firestore.dart';
import 'voice_service.dart';

class ReportService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<Map<String, int>> getSummary() async {
    try {
      final students = await _firestore.collection('students').get();
      final teachers = await _firestore.collection('teachers').get();
      final courses = await _firestore.collection('courses').get();
      final fees = await _firestore.collection('fees').get();
      await VoiceService.instance.speak('Report generated successfully.');
      return {
        'students': students.docs.length,
        'teachers': teachers.docs.length,
        'courses': courses.docs.length,
        'fees': fees.docs.length,
      };
    } catch (error) {
      await VoiceService.instance.speakError(error);
      rethrow;
    }
  }
}
