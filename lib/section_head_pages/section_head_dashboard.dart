import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:greenlens/shared_files/custom_app_bar.dart';
import 'package:greenlens/projects_template.dart';
import 'package:greenlens/main.dart';
import 'package:flutter_svg/flutter_svg.dart';

class SectionHeadPage extends StatefulWidget {
  const SectionHeadPage({super.key});

  @override
  State<SectionHeadPage> createState() => _SectionHeadPageState();
}

class _SectionHeadPageState extends State<SectionHeadPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar.build(
        title: 'Dashboard|Section Head',
        subtitle: 'Manage and monitor your audit projects',
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(32, 30, 32, 16),
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                //First Button --------------->
                SizedBox(
                  width: double.infinity,
                  height: 64,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      padding: EdgeInsets.fromLTRB(16, 8, 16, 8),
                      backgroundColor: dashButtonColor,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    onPressed: () {
                      // TODO: Handle button press, navigate to create project page
                      Navigator.pushNamed(context, "/create_new_project");
                    },
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        SizedBox(
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              SvgPicture.asset(
                                'assets/images/Add.svg',
                                height: 40,
                                width: 40,
                                colorFilter: ColorFilter.mode(
                                  Colors.white,
                                  BlendMode.srcIn,
                                ),
                              ),
                              SizedBox(width: 10),
                              Text(
                                'Create New Project',
                                style: GoogleFonts.firaSans(
                                  fontSize: 16,
                                  color: Colors.white,
                                  fontWeight: FontWeight.normal,
                                ), //w500 meduim weight
                              ),
                            ],
                          ),
                        ),
                        Spacer(),
                        SvgPicture.asset(
                          'assets/images/arrowright.svg',
                          height: 40,
                          width: 40,
                        ),
                      ],
                    ),
                  ),
                ),

                //2nd button --------------->
                SizedBox(height: 16),
                SizedBox(
                  width: double.infinity,
                  height: 64,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      padding: EdgeInsets.fromLTRB(16, 8, 16, 8),
                      backgroundColor: dashButtonColor,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    onPressed: () {
                      // TODO: Handle button press, navigate to assign engineer page
                    },
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        SizedBox(
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              SvgPicture.asset(
                                'assets/images/Profile Add 1.svg',
                                height: 40,
                                width: 40,
                                colorFilter: ColorFilter.mode(
                                  Colors.white,
                                  BlendMode.srcIn,
                                ),
                              ),
                              SizedBox(width: 10),
                              Text(
                                'Assign Engineer to Project',
                                style: GoogleFonts.firaSans(
                                  fontSize: 16,
                                  color: Colors.white,
                                  fontWeight: FontWeight.normal,
                                ),
                              ),
                            ],
                          ),
                        ),
                        Spacer(),
                        SvgPicture.asset(
                          'assets/images/arrowright.svg',
                          height: 40,
                          width: 40,
                        ),
                      ],
                    ),
                  ),
                ),

                //Third button   --------------->
                SizedBox(height: 16),
                SizedBox(
                  width: double.infinity,
                  height: 64,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      padding: EdgeInsets.fromLTRB(16, 8, 16, 8),
                      backgroundColor: dashButtonColor,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    onPressed: () {
                      // TODO: Handle button press, navigate to previous projects page
                    },
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        SizedBox(
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              SvgPicture.asset(
                                'assets/images/Rotate Left.svg',
                                height: 40,
                                width: 40,
                                colorFilter: ColorFilter.mode(
                                  Colors.white,
                                  BlendMode.srcIn,
                                ),
                              ),
                              SizedBox(width: 10),
                              Text(
                                'Previous Projects',
                                style: GoogleFonts.firaSans(
                                  fontSize: 16,
                                  color: Colors.white,
                                  fontWeight: FontWeight.normal,
                                ),
                              ),
                            ],
                          ),
                        ),
                        Spacer(),
                        SvgPicture.asset(
                          'assets/images/arrowright.svg',
                          height: 40,
                          width: 40,
                        ),
                      ],
                    ),
                  ),
                ),

                //Active Projects Section --------------->
                SizedBox(height: 32),
                Container(
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.2),
                        spreadRadius: 0,
                        blurRadius: 7.2,
                        offset: Offset(0, 0), // changes position of shadow
                      ),
                    ],
                  ),
                  alignment: Alignment.centerLeft,
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      children: [
                        Center(
                          child: Text(
                            'Active Projects',
                            style: GoogleFonts.firaSans(
                              fontSize: 26,
                              color: Colors.black,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                        SizedBox(height: 16),
                        //Projects List --------------->
                        Project(title: "Al-Quds Mall", status: "In Progress"),
                        SizedBox(height: 16),
                        Project(
                          title: "Royal Hotel",
                          status: "Awaiting Approval",
                        ),
                        SizedBox(height: 16),
                        Project(title: "Zaid Bakery", status: "Draft"),
                        SizedBox(height: 16),
                        TextButton(
                          style: TextButton.styleFrom(
                            padding: EdgeInsets.zero,
                            minimumSize: Size.zero,
                            tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                            overlayColor: Colors.transparent,
                          ),
                          onPressed: () {
                            // TODO: Handle button press, navigate to all projects page
                          },
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Text(
                                "View All",
                                style: GoogleFonts.firaSans(
                                  fontSize: 22,
                                  color: Colors.black,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              SvgPicture.asset(
                                'assets/images/arrowright.svg',
                                height: 40,
                                width: 40,
                                colorFilter: ColorFilter.mode(
                                  Colors.black,
                                  BlendMode.srcIn,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                SizedBox(height: 60),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
