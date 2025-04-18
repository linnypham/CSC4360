import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  
  Future<User?> signInWithEmail(String email, String password) async {
    try {
      final result = await _auth.signInWithEmailAndPassword(
        email: email.trim(),
        password: password.trim(),
      );
      return result.user;
    } catch (e) {
      rethrow;
    }
  }

 
  Future<User?> registerWithEmail({
    required String firstName,
    required String lastName,
    required String email,
    required String password,
    required String role,
  }) async {
    try {
      final result = await _auth.createUserWithEmailAndPassword(
        email: email.trim(),
        password: password.trim(),
      );

      final user = result.user;
      if (user != null) {
        await _firestore.collection('users').doc(user.uid).set({
          'firstName': firstName.trim(),
          'lastName': lastName.trim(),
          'email': email.trim(),
          'role': role.trim(),
          'registrationDate': Timestamp.now(),
        });
      }

      return user;
    } catch (e) {
      rethrow;
    }
  }

  
  Future<void> signOut() async {
    await _auth.signOut();
  }


  User? get currentUser => _auth.currentUser;

  
  Stream<User?> get authStateChanges => _auth.authStateChanges();
}
