import 'package:flutter/material.dart';
import 'package:greenlens/authentication/sign_in.dart';
import 'package:greenlens/firebase/auth_service.dart';
import 'package:greenlens/main.dart';

/// Bottom action bar shown on every role dashboard (Engineer, Section Head,
/// CEO): a rounded white card with a "Logout" icon button and a "Profile"
/// icon button side by side.
///
/// The profile button is a placeholder for now — wire up [onProfileTap] once
/// a profile page exists.
class DashboardFooterActions extends StatelessWidget {
  const DashboardFooterActions({super.key, this.onProfileTap});

  final VoidCallback? onProfileTap;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(32, 0, 32, 32),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.2),
              spreadRadius: 0,
              blurRadius: 7.2,
              offset: const Offset(0, 0),
            ),
          ],
        ),
        child: Row(
          children: [
            Expanded(
              child: _FooterActionButton(
                icon: Icons.logout,
                onTap: () async {
                  await AuthService().signOut();
                  if (context.mounted) {
                    Navigator.pushAndRemoveUntil(
                      context,
                      MaterialPageRoute(builder: (_) => const SignInPage()),
                      (route) => false,
                    );
                  }
                },
              ),
            ),
            Container(height: 32, width: 1, color: const Color(0xFFE5E5EA)),
            Expanded(
              child: _FooterActionButton(
                icon: Icons.person_outline,
                onTap: onProfileTap ?? () {},
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _FooterActionButton extends StatelessWidget {
  const _FooterActionButton({required this.icon, required this.onTap});

  final IconData icon;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: SizedBox(
          height: 84,
          child: Center(
            child: Icon(icon, color: primaryColor, size: 32),
          ),
        ),
      ),
    );
  }
}