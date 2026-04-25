import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:greenlens/main.dart';

Color getStatusColor(String status) {
  switch (status) {
    case 'In Progress':
      statusColor = inProgressColor;
      return statusColor;
    case 'Awaiting Approval':
      statusColor = awaitingApprovalColor;
      return statusColor;
    case 'Draft':
      statusColor = draftColor;
      return statusColor;
    case 'Denied':
      statusColor = deniedColor;
      return statusColor;
    case 'Ready':
      statusColor = readyColor;
      return statusColor;
    default:
      return draftColor;
  }
}

class Project extends StatelessWidget {
  final String title;
  final String status;

  const Project({super.key, required this.title, required this.status});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 70,
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.2),
              spreadRadius: 0,
              blurRadius: 7.2,
              offset: Offset(0, 0),
            ),
          ],
        ),
        child: ElevatedButton(
          style: ElevatedButton.styleFrom(
            padding: EdgeInsets.zero,
            backgroundColor: Colors.white,
            elevation: 0,
            shadowColor: Colors.transparent,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
          onPressed: () {
            // TODO: Handle button pres
          },
          child: Padding(
            padding: const EdgeInsets.fromLTRB(8, 0, 8, 0),
            child: Row(
              children: [
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 26,
                    color: Colors.black,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                Spacer(),

                Container(
                  padding: EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: getStatusColor(status),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    status,
                    style: TextStyle(
                      fontSize: 18,
                      color: Colors.white,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),

                SvgPicture.asset(
                  'assets/images/arrowright.svg',
                  height: 40,
                  width: 40,
                  colorFilter: ColorFilter.mode(primaryColor, BlendMode.srcIn),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
