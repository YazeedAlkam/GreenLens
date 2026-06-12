import 'package:flutter/material.dart';

/// Large title displayed in the Create Project / Edit Project wizard AppBar.
///
/// Defaults to "Create New Project" but accepts a custom [title] for edit mode.
class NavBarTitle extends StatelessWidget {
  final String title;
  const NavBarTitle({super.key, this.title = 'Create New Project'});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 70, bottom: 30),
      child: Center(
        child: Text(
          title,
          overflow: TextOverflow.visible,
          softWrap: false,
          style: const TextStyle(
            fontSize: 65,
            color: Colors.white,
            fontFamily: 'TimesNewRoman',
            height: 3,
          ),
          textAlign: TextAlign.center,
        ),
      ),
    );
  }
}
