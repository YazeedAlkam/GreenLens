import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

/// Wraps Firebase Auth and Firestore operations for authentication.
///
/// On sign-up, it does two things atomically in a Firestore transaction:
///   1. Increments a `meta/userCounter` document to generate a sequential custom ID.
///   2. Creates a document in `users/{uid}` with name, email, role, and that ID.
///
/// On sign-in, it only calls Firebase Auth — the role is then fetched via
/// UserModel.fetchCurrent() to decide which dashboard to navigate to.
class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  /// Stream that emits a [User] whenever the auth state changes (sign-in / sign-out).
  Stream<User?> get authStateChanges => _auth.authStateChanges();

  /// Returns the currently signed-in [User], or null when not authenticated.
  User? get currentUser => _auth.currentUser;

  /// Creates a Firebase Auth account and writes the user document to Firestore.
  ///
  /// Uses a transaction to atomically increment a `meta/userCounter` document
  /// and assign a sequential custom numeric ID to the new user.
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

  /// Authenticates with Firebase Auth using email and password.
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

  /// Sends a Firebase password-reset email to the given address.
  Future<void> sendPasswordResetEmail(String email) async {
    try {
      await _auth.sendPasswordResetEmail(email: email);
    } on FirebaseAuthException catch (e) {
      throw _handleAuthException(e);
    }
  }

  /// Signs the current user out of Firebase Auth.
  Future<void> signOut() async {
    await _auth.signOut();
  }

  /// Maps a [FirebaseAuthException] error code to a user-readable English message.
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
