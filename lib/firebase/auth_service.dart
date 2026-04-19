import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart'; // <-- added

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance; // <-- added

  // Stream to listen to auth state changes
  Stream<User?> get authStateChanges => _auth.authStateChanges();

  // Current user
  User? get currentUser => _auth.currentUser;

  // Sign Up -- now accepts name & role, saves them to Firestore
  Future<UserCredential?> signUp(
      String email,
      String password,
      String name,  // <-- added
      String role,  // <-- added
      ) async {
    try {
      // 1. Create the auth account
      final credential = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      // 2. Save extra info to Firestore under /users/{uid}
      await _firestore.collection('users').doc(credential.user!.uid).set({
        'name':      name,
        'email':     email,
        'role':      role,
        'createdAt': FieldValue.serverTimestamp(),
      });

      return credential;
    } on FirebaseAuthException catch (e) {
      throw _handleAuthException(e);
    }
  }

  // Sign In (unchanged)
  Future<UserCredential?> signIn(String email, String password) async {
    try {
      return await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
    } on FirebaseAuthException catch (e) {
      throw _handleAuthException(e);
    }
  }

  // Sign Out (unchanged)
  Future<void> signOut() async {
    await _auth.signOut();
  }

  // Error handler (unchanged)
  String _handleAuthException(FirebaseAuthException e) {
    switch (e.code) {
      case 'email-already-in-use': return 'This email is already registered.';
      case 'invalid-email':        return 'Invalid email address.';
      case 'weak-password':        return 'Password is too weak.';
      case 'user-not-found':       return 'No user found with this email.';
      case 'wrong-password':       return 'Incorrect password.';
      default:                     return e.message ?? 'An error occurred.';
    }
  }
}