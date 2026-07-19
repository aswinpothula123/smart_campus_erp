import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'voice_service.dart';


class AuthService {

  final FirebaseAuth _auth = FirebaseAuth.instance;

  final FirebaseFirestore _firestore =
      FirebaseFirestore.instance;


  // Check login state
  Stream<User?> get authStateChanges =>
      _auth.authStateChanges();


  // Current user
  User? get currentUser =>
      _auth.currentUser;



  // LOGIN

  Future<UserCredential> signInWithEmailAndPassword({

    required String email,

    required String password,

  }) async {


    try {

      final credential = await _auth.signInWithEmailAndPassword(

        email: email,

        password: password,

      );
      await VoiceService.instance.speak('Login successful.');
      return credential;


    } on FirebaseAuthException catch (e) {


      await VoiceService.instance.speak('Login failed. Invalid email or password.');
      throw Exception(
        _getAuthErrorMessage(e.code),
      );


    }

  }





  // REGISTER

  Future<UserCredential> registerWithEmailAndPassword({

    required String email,

    required String password,

    required String fullName,

    required String role,

  }) async {


    try {


      // Create Firebase Authentication User

      UserCredential credential =
          await _auth.createUserWithEmailAndPassword(

        email: email.trim(),

        password: password.trim(),

      );



      // Store user details in Firestore

      await _firestore
          .collection("users")
          .doc(credential.user!.uid)
          .set({

        "uid": credential.user!.uid,

        "email": email.trim(),

        "fullName": fullName.trim(),

        "role": role,

        "createdAt":
            FieldValue.serverTimestamp(),

      });



      await VoiceService.instance.speak('Registration successful.');
      return credential;



    } on FirebaseAuthException catch (e) {

      await VoiceService.instance.speakError(e);


      throw Exception(
        _getAuthErrorMessage(e.code),
      );



    } on FirebaseException catch (e) {

      await VoiceService.instance.speakError(e);


      throw Exception(
        "Firestore Error: ${e.message}",
      );



    } catch(e) {

      await VoiceService.instance.speakError(e);


      throw Exception(
        "Unknown Error: $e",
      );


    }

  }





  // LOGOUT

  Future<void> signOut() async {

    try {
      await _auth.signOut();
      await VoiceService.instance.speak('Logged out successfully.');
    } catch (error) {
      await VoiceService.instance.speakError(error);
      rethrow;
    }

  }





  // Firebase Error Messages

  String _getAuthErrorMessage(String code) {


    switch(code) {


      case "email-already-in-use":

        return "Email already registered";


      case "invalid-email":

        return "Invalid email address";


      case "weak-password":

        return "Password must contain minimum 6 characters";


      case "operation-not-allowed":

        return "Email login is not enabled in Firebase";


      case "user-not-found":

        return "User not found";


      case "wrong-password":

        return "Wrong password";


      default:

        return "Authentication Error: $code";

    }

  }


}
