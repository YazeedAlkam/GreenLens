import 'package:flutter/material.dart';
import 'package:greenlens/shared_files/CustomAppBar.dart';
import 'package:greenlens/main.dart';
import 'package:flutter_svg/flutter_svg.dart';

class SectionHeadPage extends StatelessWidget {
  const SectionHeadPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar.build(
        title: 'Dashboard|Section Head',
        subtitle: 'Manage and monitor your audit projects',
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: DashsButtonColor,
                padding: EdgeInsets.symmetric(horizontal: 20, vertical: 12),
              ),
              onPressed: () {},
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  SvgPicture.asset('assets/images/Add.svg', height: 27),
                  Text(
                    'Create New Project',
                    style: TextStyle(fontSize: 16, color: Colors.white),
                  ),
                ],
              ),
              
            ),
            SizedBox(height: 20),
            Text(
              'Here you can manage your audit projects and monitor progress.',
              style: TextStyle(fontSize: 18, color: textcolor),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
