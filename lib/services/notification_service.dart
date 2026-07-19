import 'package:cloud_firestore/cloud_firestore.dart';

import 'voice_service.dart';

class NotificationService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Stream<QuerySnapshot> getNotifications() => _firestore
      .collection('notifications')
      .orderBy('createdAt', descending: true)
      .snapshots();

  Future<void> addNotification({
    required String title,
    required String message,
  }) async {
    try {
      await _firestore.collection('notifications').add({
        'title': title,
        'message': message,
        'date': DateTime.now().toString(),
        'createdAt': FieldValue.serverTimestamp(),
      });
      await VoiceService.instance.speak('Notification created.');
    } catch (error) {
      await VoiceService.instance.speakError(error);
      rethrow;
    }
  }

  Future<void> updateNotification(String id, Map<String, dynamic> data) async {
    try {
      await _firestore.collection('notifications').doc(id).update(data);
      await VoiceService.instance.speak('Notification updated.');
    } catch (error) {
      await VoiceService.instance.speakError(error);
      rethrow;
    }
  }

  Future<void> deleteNotification(String id) async {
    try {
      await _firestore.collection('notifications').doc(id).delete();
      await VoiceService.instance.speak('Notification deleted.');
    } catch (error) {
      await VoiceService.instance.speakError(error);
      rethrow;
    }
  }
}
