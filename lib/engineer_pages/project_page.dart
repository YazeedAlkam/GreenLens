import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:greenlens/main.dart';
import 'package:greenlens/shared_files/custom_app_bar.dart';
import 'package:greenlens/engineer_pages/audit_data_entery_flow.dart';
import 'package:greenlens/shared_files/footer.dart';

class ProjectPage extends StatefulWidget {
  final String projectName;
  final String projectId;
  const ProjectPage({super.key, required this.projectName, required this.projectId});

  @override
  State<ProjectPage> createState() => _ProjectPageState();
}

class _ProjectPageState extends State<ProjectPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar.build(
        title: '${widget.projectName} Energy Audit',
        subtitle: 'Manage and audit your project',
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(32, 30, 32, 16),
          child: Center(
            child: Column(
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
                      // TODO: Handle button press, create and save a pdf to the downloads folder on the device
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
                                'assets/images/GenrateChart.svg',
                                height: 40,
                                width: 40,
                                colorFilter: ColorFilter.mode(
                                  Colors.white,
                                  BlendMode.srcIn,
                                ),
                              ),
                              SizedBox(width: 10),
                              Text(
                                'Generate Technical Report',
                                style: TextStyle(
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
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => Audit_Entery_Flow(projectId: widget.projectId),
                        ),
                      );
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
                                'assets/images/Opertaional.svg',
                                height: 40,
                                width: 40,
                                colorFilter: ColorFilter.mode(
                                  Colors.white,
                                  BlendMode.srcIn,
                                ),
                              ),
                              SizedBox(width: 10),
                              Text(
                                'Operational Audit Data',
                                style: TextStyle(
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
                SizedBox(height: 16),
                Container(
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
                  width: double.infinity, //
                  height: 818.8,
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(16, 10, 16, 10),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Project Summary",
                          style: GoogleFonts.firaSans(
                            fontSize: 25.92,
                            fontWeight: FontWeight.w500,
                            color: primaryColor,
                          ),
                        ),
                        Table(
                          children: [
                            TableRow(
                              children: [
                                Row(
                                  children: [
                                    Expanded(
                                      child: Image.asset(
                                        "assets/images/GraphOne.png",
                                      ),
                                    ),
                                    Expanded(
                                      child: Image.asset(
                                        "assets/images/GraphTwo.png",
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                            TableRow(
                              children: [
                                Row(
                                  children: [
                                    Expanded(
                                      child: Image.asset(
                                        "assets/images/GraphThree.png",
                                      ),
                                    ),
                                    Expanded(
                                      child: Image.asset(
                                        "assets/images/GraphFour.png",
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                            TableRow(
                              children: [
                                Padding(
                                  padding: const EdgeInsets.all(12.0),
                                  child: TextButton(
                                    onPressed: () {},
                                    child: Center(
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Text(
                                            "View All",
                                            style: TextStyle(
                                              color: primaryColor,
                                              fontSize: 22.68,
                                              fontWeight: FontWeight.w500,
                                            ),
                                          ),
                                          SvgPicture.asset(
                                            "assets/images/arrowright.svg",
                                            width: 40,
                                            height: 40,
                                            colorFilter: ColorFilter.mode(
                                              primaryColor,
                                              BlendMode.srcIn,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
                SizedBox(height: 16),
                Footer(
                  currentStep: 0,
                  mode: FooterMode.backOnly,
                  onBack: () => Navigator.pop(context),
                  onNext: () {},
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
