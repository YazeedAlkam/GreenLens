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
    String name,
    String role,
  ) async {
    try {
      // 1. Create the auth account
      final credential = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      // 2. Atomically increment the counter and get the new custom ID
      final counterRef = _firestore.collection('meta').doc('userCounter');
      final userRef = _firestore.collection('users').doc(credential.user!.uid);

      await _firestore.runTransaction((transaction) async {
        final counterSnap = await transaction.get(counterRef);

        int newId;
        if (!counterSnap.exists) {
          // First ever user — initialize the counter
          newId = 1;
          transaction.set(counterRef, {'lastId': 1});
        } else {
          newId = (counterSnap.data()!['lastId'] as int) + 1;
          transaction.update(counterRef, {'lastId': newId});
        }

        // 3. Save user info with the new custom ID
        transaction.set(userRef, {
          'name': name,
          'email': email,
          'role': role,
          'createdAt': FieldValue.serverTimestamp(),
          'customId': newId,
        });
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
      case 'email-already-in-use':
        return 'This email is already registered.';
      case 'invalid-email':
        return 'Invalid email address.';
      case 'weak-password':
        return 'Password is too weak.';
      case 'user-not-found':
        return 'No user found with this email.';
      case 'wrong-password':
        return 'Incorrect password.';
      default:
        return e.message ?? 'An error occurred.';
    }
  }
}
