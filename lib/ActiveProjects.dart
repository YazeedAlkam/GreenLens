import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:greenlens/main.dart';

Color getStatusColor(String status) {
  switch (status) {
    case 'In Progress':
      StatusColor = InProgressColor;
      return StatusColor;
    case 'Awaiting Approval':
      StatusColor = AwaitingApprovalColor;
      return StatusColor;
    case 'Draft':
      StatusColor = DraftColor;
      return StatusColor;
    case 'Denied':
      StatusColor = DeniedColor;
      return StatusColor;
    case 'Ready':
      StatusColor = ReadyColor;
      return StatusColor;
    default:
      return DraftColor;
  }
}

class ActiveProjects extends StatelessWidget {
  final String title;
  final String status;

  const ActiveProjects({super.key, required this.title, required this.status});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 100,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.5),
                spreadRadius: 2,
                blurRadius: 5,
                offset: Offset(0, 3),
              ),
            ],
          ),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
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
                  padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
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

                SizedBox(width: 10),

                SvgPicture.asset(
                  'assets/images/arrowright.svg',
                  height: 26.6,
                  width: 26.6,
                  color: Colors.black,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
