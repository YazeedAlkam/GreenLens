import 'package:flutter/material.dart';
import 'package:greenlens/shared_files/CustomAppBar.dart';
import 'package:greenlens/ActiveProjects.dart';
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
      body: Padding(
        padding: const EdgeInsets.fromLTRB(32, 30, 32, 16),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              //First Button --------------->
              SizedBox(
                width: 960,
                height: 65,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: DashsButtonColor,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  onPressed: () {},
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            SvgPicture.asset(
                              'assets/images/add.svg',
                              height: 26.6,
                              width: 26.6,
                              color: Colors.white,
                            ),
                            SizedBox(width: 10),
                            Text(
                              'Create New Project',
                              style: TextStyle(
                                fontSize: 16,
                                color: Colors.white,
                                fontWeight: FontWeight.w500,
                              ), //w500 meduim weight
                            ),
                          ],
                        ),
                      ),
                      Spacer(),
                      Padding(
                        padding: const EdgeInsets.only(top: 2),
                        child: SvgPicture.asset(
                          'assets/images/arrowright.svg',
                          height: 26.6,
                          width: 26.6,
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              //2nd button --------------->
              SizedBox(height: 16),
              SizedBox(
                width: 960,
                height: 65,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: DashsButtonColor,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  onPressed: () {},
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            SvgPicture.asset(
                              'assets/images/assign.svg',
                              height: 26.6,
                              width: 26.6,
                            ),
                            SizedBox(width: 10),
                            Text(
                              'Assign Engineer To Project',
                              style: TextStyle(
                                fontSize: 16,
                                color: Colors.white,
                                fontWeight: FontWeight.w500,
                              ), //w500 meduim weight
                            ),
                          ],
                        ),
                      ),
                      Spacer(),
                      Padding(
                        padding: const EdgeInsets.only(top: 2),
                        child: SvgPicture.asset(
                          'assets/images/arrowright.svg',
                          height: 26.6,
                          width: 26.6,
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              //Third button   --------------->
              SizedBox(height: 16),
              SizedBox(
                width: 960,
                height: 65,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: DashsButtonColor,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  onPressed: () {},
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            SvgPicture.asset(
                              'assets/images/reload.svg',
                              height: 26.6,
                              width: 26.6,
                            ),
                            SizedBox(width: 10),
                            Text(
                              'Previous Projects',
                              style: TextStyle(
                                fontSize: 16,
                                color: Colors.white,
                                fontWeight: FontWeight.w500,
                              ), //w500 meduim weight
                            ),
                          ],
                        ),
                      ),
                      Spacer(),
                      Padding(
                        padding: const EdgeInsets.only(top: 2),
                        child: SvgPicture.asset(
                          'assets/images/arrowright.svg',
                          height: 26.6,
                          width: 26.6,
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              //Active Projects Section --------------->
              SizedBox(height: 40),
              Container(
                width: 960,
                height: 420,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.5),
                      spreadRadius: 2,
                      blurRadius: 5,
                      offset: Offset(0, 3), // changes position of shadow
                    ),
                  ],
                ),
                alignment: Alignment.centerLeft,
                child: Padding(
                  padding: const EdgeInsets.only(left: 16, top: 16),
                  child: Column(
                    children: [
                      Row(
                        children: [
                          Text(
                            'Active Projects',
                            style: TextStyle(
                              fontSize: 26,
                              color: Colors.black,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 16),
                      //Projects List --------------->
                      ActiveProjects(
                        title: "Al-Quds Mall",
                        status: "In Progress",
                      ),
                      ActiveProjects(
                        title: "Royal Hotel",
                        status: "Awaiting Approval",
                      ),
                      ActiveProjects(title: "Zaid Bakery", status: "Draft"),
                      TextButton(
                        onPressed: () {},
                        child: SizedBox(
                          width: 150,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                "View All",
                                style: TextStyle(
                                  fontSize: 29.6,
                                  color: Colors.black,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
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
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
