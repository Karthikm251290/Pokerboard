// lib/services/auth_service.dart
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/user_model.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Create User Object from Firebase User
  UserModel? _userFromFirebaseUser(User user) {
    return UserModel(
      uid: user.uid,
      email: user.email ?? '',
      name: user.displayName ?? '',
      photoUrl: user.photoURL ?? '',
      role: 'user',
      isOnline: true,
    );
  }

  // Auth Change User Stream
  Stream<UserModel?> get user {
    return _auth.authStateChanges().map((User? user) {
      return user != null ? _userFromFirebaseUser(user) : null;
    });
  }

  // Sign Up
  Future<UserModel?> signUp(String email, String password, String name) async {
    try {
      UserCredential result = await _auth.createUserWithEmailAndPassword(
          email: email, password: password);
      User user = result.user!;

      // Create a new document for the user
      await _firestore.collection('users').doc(user.uid).set({
        'uid': user.uid,
        'email': email,
        'name': name,
        'photoUrl': '',
        'role': 'user',
        'isOnline': true,
      });

      return _userFromFirebaseUser(user);
    } catch (e) {
      print(e.toString());
      return null;
    }
  }

  // Sign In
  Future<UserModel?> signIn(String email, String password) async {
    try {
      UserCredential result = await _auth.signInWithEmailAndPassword(
          email: email, password: password);
      User user = result.user!;

      // Update user's online status
      await _firestore.collection('users').doc(user.uid).update({
        'isOnline': true,
      });

      return _userFromFirebaseUser(user);
    } catch (e) {
      print(e.toString());
      return null;
    }
  }

  // Password Recovery
  Future<void> sendPasswordResetEmail(String email) async {
    await _auth.sendPasswordResetEmail(email: email);
  }

  // Sign Out
  Future<void> signOut() async {
    User user = _auth.currentUser!;
    await _firestore.collection('users').doc(user.uid).update({
      'isOnline': false,
    });
    await _auth.signOut();
  }
}
