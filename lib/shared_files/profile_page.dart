// ignore_for_file: deprecated_member_use

import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:greenlens/authentication/user_model.dart';
import 'package:greenlens/firebase/auth_service.dart';
import 'package:greenlens/shared_files/custom_app_bar.dart';
import 'package:image_picker/image_picker.dart';

/// Shared profile screen used by every role (Engineer, Section Head, CEO).
///
/// Same design as the original: avatar picker, info cards, "Change
/// Password" action, and a back button. The data — name, email, and
/// project count — is now loaded per logged-in user from Firestore instead
/// of being hardcoded, so this one screen works correctly for all roles.
class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  Uint8List? _imageBytes;

  late Future<_ProfileData> _profileFuture;

  @override
  void initState() {
    super.initState();
    _profileFuture = _loadProfileData();
  }

  Future<_ProfileData> _loadProfileData() async {
    final user = await UserModel.fetchCurrent();
    final projectCount = await _getProjectCount(user?.role);
    return _ProfileData(user: user, projectCount: projectCount);
  }

  /// Engineers see how many projects they're assigned to; Section Head and
  /// CEO see the total number of projects in the system.
  Future<int> _getProjectCount(String? role) async {
    final firestore = FirebaseFirestore.instance;
    if (role == 'Engineer') {
      final uid = FirebaseAuth.instance.currentUser?.uid;
      if (uid == null) return 0;
      final snap = await firestore
          .collection('projects')
          .where('assignedEngineers', arrayContains: uid)
          .get();
      return snap.docs.length;
    }
    final snap = await firestore.collection('projects').get();
    return snap.docs.length;
  }

  Future<void> _pickImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      final bytes = await pickedFile.readAsBytes();
      setState(() {
        _imageBytes = bytes;
      });
    }
  }

  Future<void> _changePassword(String email) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        title: const Text('Change Password'),
        content: Text(
          'Are you sure you want to change your password? '
          'A reset link will be sent to $email.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(true),
            child: const Text('Yes'),
          ),
        ],
      ),
    );

    if (confirmed != true) return;

    try {
      await AuthService().sendPasswordResetEmail(email);
      if (!mounted) return;
      await showDialog<void>(
        context: context,
        builder: (context) => AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          title: const Text('Email Sent'),
          content: Text('A password reset link has been sent to $email.'),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('OK'),
            ),
          ],
        ),
      );
    } catch (e) {
      if (!mounted) return;
      await showDialog<void>(
        context: context,
        builder: (context) => AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          title: const Text('Something Went Wrong'),
          content: Text(e.toString()),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('OK'),
            ),
          ],
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<_ProfileData>(
      future: _profileFuture,
      builder: (context, snapshot) {
        final role = snapshot.data?.user?.role;
        return Scaffold(
          backgroundColor: Colors.white,
          appBar: CustomAppBar.build(
            title: role != null ? 'Profile|$role' : 'Profile',
            subtitle: '',
          ),
          body: SafeArea(
            child: Builder(
              builder: (context) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }
                if (snapshot.hasError || snapshot.data?.user == null) {
                  return const Center(child: Text('Could not load profile.'));
                }

                final data = snapshot.data!;
                final user = data.user!;

                return SingleChildScrollView(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 24,
                    vertical: 32,
                  ),
                  child: Column(
                    children: [
                      GestureDetector(
                        onTap: _pickImage,
                        child: CircleAvatar(
                          radius: 100,
                          backgroundColor: const Color(0xFFDCDCDC),
                          backgroundImage: _imageBytes != null
                              ? MemoryImage(_imageBytes!)
                              : null,
                          child: _imageBytes == null
                              ? const Icon(
                                  Icons.person,
                                  size: 70,
                                  color: Color(0xFF16123F),
                                )
                              : null,
                        ),
                      ),
                      const SizedBox(height: 32),

                      Container(
                        padding: const EdgeInsets.all(20),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(color: const Color(0xFFEDEDED)),
                        ),
                        child: Column(
                          children: [
                            _InfoBox(text: user.name),
                            const SizedBox(height: 16),
                            _InfoBox(text: user.email),
                            const SizedBox(height: 16),
                            _InfoBox(
                              text:
                                  'Number of Projects : ${data.projectCount}',
                            ),
                            const SizedBox(height: 16),
                            _ActionRow(
                              label: 'Change Password',
                              onTap: () => _changePassword(user.email),
                            ),
                          ],
                        ),
                      ),

                      const SizedBox(height: 40),

                      Align(
                        alignment: Alignment.centerLeft,
                        child: SizedBox(
                          width: 200,
                          height: 35,
                          child: OutlinedButton.icon(
                            onPressed: () => Navigator.of(context).pop(),
                            style: OutlinedButton.styleFrom(
                              foregroundColor: const Color(0xFF16123F),
                              side: const BorderSide(
                                color: Color(0xFF16123F),
                              ),
                              padding: const EdgeInsets.symmetric(
                                horizontal: 24,
                                vertical: 14,
                              ),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(18),
                              ),
                            ),
                            icon: const Icon(Icons.arrow_back),
                            label: const Text(
                              'Back',
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 32),
                    ],
                  ),
                );
              },
            ),
          ),
        );
      },
    );
  }
}

class _ProfileData {
  final UserModel? user;
  final int projectCount;

  const _ProfileData({required this.user, required this.projectCount});
}

class _InfoBox extends StatelessWidget {
  final String text;

  const _InfoBox({required this.text});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: const Color(0xFFEDEDED)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      alignment: Alignment.center,
      child: Text(
        text,
        style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 15),
      ),
    );
  }
}

class _ActionRow extends StatelessWidget {
  final String label;
  final VoidCallback onTap;

  const _ActionRow({required this.label, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(14),
      onTap: onTap,
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(vertical: 16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: const Color(0xFFEDEDED)),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.08),
              blurRadius: 12,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        alignment: Alignment.center,
        child: Text(
          label,
          style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 15),
        ),
      ),
    );
  }
}