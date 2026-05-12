import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class ProjectService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  /// Saves or updates a project. Returns the document ID.
  /// [status] is either 'Draft' or 'active'
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

    final newRef = _firestore
        .collection('projects')
        .doc(); // auto-generate doc ID

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
        'rate': data['rate'],
        'isAssigned': false,
      };
    }).toList();
  }

  /// Returns the next project ID that will be assigned (e.g. "P-0003").
  /// Does NOT consume the counter — only reads it.
  Future<String> getNextProjectId() async {
    final counterSnap = await _firestore
        .collection('meta')
        .doc('projectCounter')
        .get();
    final lastId = counterSnap.exists
        ? (counterSnap.data()!['lastId'] as int)
        : 0;
    return 'P-${(lastId + 1).toString().padLeft(4, '0')}';
  }

  /// Returns a single project document by its Firestore doc ID.
  Future<Map<String, dynamic>?> getProjectById(String projectId) async {
    final doc = await _firestore.collection('projects').doc(projectId).get();
    if (!doc.exists) return null;
    return {'id': doc.id, ...doc.data()!};
  }

  /// Returns recently created projects, ordered by createdAt desc.
  Future<List<Map<String, dynamic>>> getLatestProjects() async {
    final snap = await _firestore
        .collection('projects')
        .orderBy('updatedAt', descending: true)
        .limit(10)
        .get();
    return snap.docs.map((doc) => {'id': doc.id, ...doc.data()}).toList();
  }

  /// Returns all projects ordered by createdAt desc.
  Future<List<Map<String, dynamic>>> getAllProjects() async {
    final snap = await _firestore
        .collection('projects')
        .orderBy('createdAt', descending: true)
        .get();
    return snap.docs.map((doc) => {'id': doc.id, ...doc.data()}).toList();
  }

  /// Returns all non-completed projects ordered by updatedAt desc.
  Future<List<Map<String, dynamic>>> getActiveProjects() async {
    final snap = await _firestore
        .collection('projects')
        .orderBy('updatedAt', descending: true)
        .get();
    final docs = snap.docs.map((doc) => {'id': doc.id, ...doc.data()}).toList();
    return docs
        .where((p) => (p['status'] as String? ?? '').toLowerCase() != 'completed')
        .toList();
  }

  /// Returns all completed projects ordered by updatedAt desc.
  Future<List<Map<String, dynamic>>> getPreviousProjects() async {
    final snap = await _firestore
        .collection('projects')
        .where('status', isEqualTo: 'Completed')
        .get();
    final docs = snap.docs.map((doc) => {'id': doc.id, ...doc.data()}).toList();
    docs.sort((a, b) {
      final aTime = (a['updatedAt'] as Timestamp?)?.millisecondsSinceEpoch ?? 0;
      final bTime = (b['updatedAt'] as Timestamp?)?.millisecondsSinceEpoch ?? 0;
      return bTime.compareTo(aTime);
    });
    return docs;
  }

  /// Returns up to 4 active (non-completed) projects where the signed-in engineer is assigned.
  Future<List<Map<String, dynamic>>> getEngineerActiveProjects() async {
    final uid = FirebaseAuth.instance.currentUser!.uid;
    final snap = await _firestore
        .collection('projects')
        .where('assignedEngineers', arrayContains: uid)
        .get();
    final docs = snap.docs.map((doc) => {'id': doc.id, ...doc.data()}).toList();
    docs.sort((a, b) {
      final aTime = (a['updatedAt'] as Timestamp?)?.millisecondsSinceEpoch ?? 0;
      final bTime = (b['updatedAt'] as Timestamp?)?.millisecondsSinceEpoch ?? 0;
      return bTime.compareTo(aTime);
    });
    return docs
        .where((p) {
          final s = p['status'] as String? ?? '';
          return s == 'In Progress' || s == 'Ready';
        })
        .take(4)
        .toList();
  }

  /// Returns all completed projects where the signed-in engineer is assigned.
  Future<List<Map<String, dynamic>>> getEngineerPreviousProjects() async {
    final uid = FirebaseAuth.instance.currentUser!.uid;
    final snap = await _firestore
        .collection('projects')
        .where('status', isEqualTo: 'Completed')
        .where('assignedEngineers', arrayContains: uid)
        .get();
    final docs = snap.docs.map((doc) => {'id': doc.id, ...doc.data()}).toList();
    docs.sort((a, b) {
      final aTime = (a['updatedAt'] as Timestamp?)?.millisecondsSinceEpoch ?? 0;
      final bTime = (b['updatedAt'] as Timestamp?)?.millisecondsSinceEpoch ?? 0;
      return bTime.compareTo(aTime);
    });
    return docs;
  }

  /// Saves audit data for a specific section (building, lighting, ac, etc.).
  Future<void> saveAuditSection(
    String projectId,
    String section,
    dynamic data,
  ) async {
    await _firestore.collection('projects').doc(projectId).update({
      'auditData.$section': data,
      'updatedAt': FieldValue.serverTimestamp(),
    });
  }

  /// Updates arbitrary dot-notation fields on a project in one write.
  Future<void> updateFields(
    String projectId,
    Map<String, dynamic> fields,
  ) async {
    await _firestore.collection('projects').doc(projectId).update({
      ...fields,
      'updatedAt': FieldValue.serverTimestamp(),
    });
  }

  /// Updates only the assignedEngineers field of an existing project.
  Future<void> updateAssignedEngineers(
    String projectId,
    List<String> engineerIds,
  ) async {
    await _firestore.collection('projects').doc(projectId).update({
      'assignedEngineers': engineerIds,
      'updatedAt': FieldValue.serverTimestamp(),
    });
  }
}
