import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class UserModel {
  final String uid;
  final String name;
  final String email;
  final String? role;
  final DateTime? createdAt;

  const UserModel({
    required this.uid,
    required this.name,
    required this.email,
    this.role,
    this.createdAt,
  });

  /// Create from Firestore document
  factory UserModel.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return UserModel(
      uid: doc.id,
      name: data['name'] ?? '',
      email: data['email'] ?? '',
      role: data['role'] as String?,
      createdAt: (data['createdAt'] as Timestamp?)?.toDate(),
    );
  }

  /// Convert to Firestore map (for saving/updating)
  Map<String, dynamic> toFirestore() => {
    'name': name,
    'email': email,
    'role': role,
    'createdAt': createdAt != null ? Timestamp.fromDate(createdAt!) : null,
  };

  /// Fetch current logged-in user from Firestore
  static Future<UserModel?> fetchCurrent() async {
    final firebaseUser = FirebaseAuth.instance.currentUser;
    if (firebaseUser == null) return null;

    final doc = await FirebaseFirestore.instance
        .collection('users')
        .doc(firebaseUser.uid)
        .get();

    if (!doc.exists) return null;
    return UserModel.fromFirestore(doc);
  }
}