import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class ProjectService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  /// Saves or updates a project. Returns the document ID.
  /// [status] is either 'draft' or 'active'
  Future<String> saveProject({
    String? existingProjectId, // null = first save
    required String status,
    required Map<String, dynamic> clientInfo,
    required Map<String, dynamic> projectInfo,
    required List<String> assignedEngineers,
    required Map<String, dynamic> costs,
  }) async {
    final uid = FirebaseAuth.instance.currentUser!.uid;
    final counterRef = _firestore.collection('meta').doc('projectCounter');

    final data = {
      'status': status,
      'createdBy': uid,
      'updatedAt': FieldValue.serverTimestamp(),
      'clientInfo': clientInfo,
      'projectInfo': projectInfo,
      'assignedEngineers': assignedEngineers,
      'costs': costs,
    };

    // UPDATE — project already exists
    if (existingProjectId != null) {
      await _firestore
          .collection('projects')
          .doc(existingProjectId)
          .update(data);
      return existingProjectId;
    }

    // CREATE — first save, generate ID atomically
    late String newDocId;

    final newRef = _firestore.collection('projects').doc(); // auto-generate doc ID

    await _firestore.runTransaction((tx) async {
      final counterSnap = await tx.get(counterRef);

      int newId;
      if (!counterSnap.exists) {
        newId = 1;
        tx.set(counterRef, {'lastId': 1});
      } else {
        newId = (counterSnap.data()!['lastId'] as int) + 1;
        tx.update(counterRef, {'lastId': newId});
      }

      tx.set(newRef, {
        ...data,
        'createdAt': FieldValue.serverTimestamp(),
        'customId': 'P-${newId.toString().padLeft(4, '0')}', // e.g. P-0001
      });
    });

    newDocId = newRef.id;
    return newDocId;
  }

  /// Returns all users with role == "Engineer".
  Future<List<Map<String, dynamic>>> getEngineers() async {
    final snap = await _firestore
        .collection('users')
        .where('role', isEqualTo: 'Engineer')
        .get();
    return snap.docs.map((doc) {
      final data = doc.data();
      return {
        'id': doc.id,
        'customId': data['customId']?.toString() ?? '',
        'name': data['name'] ?? '',
        'email': data['email'] ?? '',
        'isAssigned': false,
      };
    }).toList();
  }

  /// Returns the next project ID that will be assigned (e.g. "P-0003").
  /// Does NOT consume the counter — only reads it.
  Future<String> getNextProjectId() async {
    final counterSnap =
        await _firestore.collection('meta').doc('projectCounter').get();
    final lastId =
        counterSnap.exists ? (counterSnap.data()!['lastId'] as int) : 0;
    return 'P-${(lastId + 1).toString().padLeft(4, '0')}';
  }

  /// Returns a single project document by its Firestore doc ID.
  Future<Map<String, dynamic>?> getProjectById(String projectId) async {
    final doc = await _firestore.collection('projects').doc(projectId).get();
    if (!doc.exists) return null;
    return {'id': doc.id, ...doc.data()!};
  }

  /// Returns the 4 most recently created projects, ordered by createdAt desc.
  Future<List<Map<String, dynamic>>> getLatestProjects() async {
    final snap = await _firestore
        .collection('projects')
        .orderBy('createdAt', descending: true)
        .limit(4)
        .get();
    return snap.docs.map((doc) => {'id': doc.id, ...doc.data()}).toList();
  }
}