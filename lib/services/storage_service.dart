import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';

import 'voice_service.dart';

class StorageService {
  final FirebaseStorage _storage = FirebaseStorage.instance;

  //=========================================
  // Upload Student Image
  //=========================================
  Future<String> uploadStudentImage(File imageFile) async {
    try {
      String fileName =
          DateTime.now().millisecondsSinceEpoch.toString();

      Reference ref = _storage
          .ref()
          .child("students")
          .child("$fileName.jpg");

      UploadTask uploadTask = ref.putFile(imageFile);

      TaskSnapshot snapshot = await uploadTask;

      final downloadUrl = await snapshot.ref.getDownloadURL();
      await VoiceService.instance.speak('Upload complete.');
      return downloadUrl;
    } catch (e) {
      await VoiceService.instance.speakError(e);
      throw Exception("Image Upload Failed: $e");
    }
  }

  //=========================================
  // Upload Student Photo
  // (Compatible with EditStudentScreen)
  //=========================================
  Future<String?> uploadStudentPhoto({
    required String studentId,
    required File imageFile,
  }) async {
    try {
      Reference ref = _storage
          .ref()
          .child("students")
          .child("$studentId.jpg");

      UploadTask uploadTask = ref.putFile(imageFile);

      TaskSnapshot snapshot = await uploadTask;

      final downloadUrl = await snapshot.ref.getDownloadURL();
      await VoiceService.instance.speak('Upload complete.');
      return downloadUrl;
    } catch (e) {
      await VoiceService.instance.speakError(e);
      return null;
    }
  }

  //=========================================
  // Delete Student Image using URL
  //=========================================
  Future<void> deleteStudentImage(String imageUrl) async {
    try {
      await FirebaseStorage.instance
          .refFromURL(imageUrl)
          .delete();
    } catch (e) {
      throw Exception("Image Delete Failed: $e");
    }
  }

  //=========================================
  // Delete Student Photo using Student ID
  //=========================================
  Future<void> deleteStudentPhoto(String studentId) async {
    try {
      await _storage
          .ref()
          .child("students")
          .child("$studentId.jpg")
          .delete();
    } catch (_) {}
  }

  //=========================================
  // Update Student Image
  //=========================================
  Future<String> updateStudentImage({
    required String? oldImageUrl,
    required File newImage,
  }) async {
    try {
      if (oldImageUrl != null && oldImageUrl.isNotEmpty) {
        try {
          await FirebaseStorage.instance
              .refFromURL(oldImageUrl)
              .delete();
        } catch (_) {}
      }

      return await uploadStudentImage(newImage);
    } catch (e) {
      throw Exception("Image Update Failed: $e");
    }
  }
}
