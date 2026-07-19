import 'package:cloud_firestore/cloud_firestore.dart';

import 'voice_service.dart';

class FeeService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final String collectionName = 'fees';

  Future<void> recordFeePayment(Map<String, dynamic> feeData) async {
    try {
      await _firestore.collection(collectionName).add({
        ...feeData,
        'createdAt': FieldValue.serverTimestamp(),
      });
      await VoiceService.instance.speak('Fee record created.');
    } catch (error) {
      await VoiceService.instance.speakError(error);
      rethrow;
    }
  }

  Stream<QuerySnapshot> getFees() => _firestore
      .collection(collectionName)
      .orderBy('createdAt', descending: true)
      .snapshots();

  Stream<QuerySnapshot> getFeesByDepartment(String department) {
    if (department == 'All') return getFees();
    return _firestore
        .collection(collectionName)
        .where('department', isEqualTo: department)
        .snapshots();
  }

  Future<void> updateFeePayment(String id, Map<String, dynamic> data) async {
    try {
      await _firestore.collection(collectionName).doc(id).update({
        ...data,
        'updatedAt': FieldValue.serverTimestamp(),
      });
      await VoiceService.instance.speak('Fee updated successfully.');
    } catch (error) {
      await VoiceService.instance.speakError(error);
      rethrow;
    }
  }

  Future<void> deleteFeePayment(String id) async {
    try {
      await _firestore.collection(collectionName).doc(id).delete();
      await VoiceService.instance.speak('Fee payment recorded.');
    } catch (error) {
      await VoiceService.instance.speakError(error);
      rethrow;
    }
  }

  Future<DocumentSnapshot> getFeeById(String id) =>
      _firestore.collection(collectionName).doc(id).get();
}
