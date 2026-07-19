import 'package:cloud_firestore/cloud_firestore.dart';
import 'voice_service.dart';

class CourseService {
  final CollectionReference coursesCollection =
      FirebaseFirestore.instance.collection("courses");

  Future<void> addCourse(String name, String code, String department) async {
    try {
      await coursesCollection.add({
        'courseName': name,
        'courseCode': code,
        'department': department,
      });
      await VoiceService.instance.speak('Course added successfully.');
    } catch (error) {
      await VoiceService.instance.speakError(error);
      rethrow;
    }
  }

  Stream<QuerySnapshot> getCoursesStream() {
    return coursesCollection
        .orderBy("courseName", descending: false)
        .snapshots();
  }

  Future<void> updateCourse(
    String id,
    Map<String, dynamic> courseData,
  ) async {
    try {
      await coursesCollection.doc(id).update(courseData);
      await VoiceService.instance.speak('Course updated.');
    } catch (error) {
      await VoiceService.instance.speakError(error);
      rethrow;
    }
  }

  Future<void> deleteCourse(String id) async {
    try {
      await coursesCollection.doc(id).delete();
      await VoiceService.instance.speak('Course deleted.');
    } catch (error) {
      await VoiceService.instance.speakError(error);
      rethrow;
    }
  }
}
