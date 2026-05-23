import 'package:flutter/material.dart';
import 'package:greenlens/engineer_pages/active_projects/active_projects_page.dart';
import 'package:greenlens/engineer_pages/previous_projects/previous_projects_page.dart';
import 'package:greenlens/engineer_pages/project_page.dart';
import 'package:greenlens/engineer_pages/project_summary_page.dart';
import 'package:greenlens/firebase/project_service.dart';
import 'package:greenlens/shared_files/custom_app_bar.dart';
import 'package:greenlens/shared_files/projects_template.dart';
import 'package:greenlens/main.dart';
import 'package:flutter_svg/flutter_svg.dart';

class EngineerPage extends StatefulWidget {
  const EngineerPage({super.key});

  @override
  State<EngineerPage> createState() => _EngineerPageState();
}

class _EngineerPageState extends State<EngineerPage> {
  final _projectService = ProjectService();
  late Future<List<Map<String, dynamic>>> _activeProjectsFuture;

  @override
  void initState() {
    super.initState();
    _activeProjectsFuture = _projectService.getEngineerActiveProjects();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar.build(
        title: 'Dashboard|Engineer',
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
                        builder: (_) => const EngineerPreviousProjectsPage(),
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
                      offset: Offset(0, 0),
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
                          'Assigned Projects',
                          style: TextStyle(
                            fontSize: 26,
                            color: Colors.black,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                      SizedBox(height: 16),
                      FutureBuilder<List<Map<String, dynamic>>>(
                        future: _activeProjectsFuture,
                        builder: (context, snapshot) {
                          if (snapshot.connectionState == ConnectionState.waiting) {
                            return const CircularProgressIndicator();
                          }
                          if (snapshot.hasError) {
                            return Text(
                              'Failed to load projects',
                              style: TextStyle(color: Colors.red),
                            );
                          }
                          final projects = snapshot.data ?? [];
                          if (projects.isEmpty) {
                            return Text(
                              'No active projects assigned.',
                              style: TextStyle(fontSize: 16, color: Colors.grey),
                            );
                          }
                          return Column(
                            children: [
                              for (int i = 0; i < projects.length; i++) ...[
                                if (i > 0) SizedBox(height: 16),
                                Builder(builder: (context) {
                                  final name = (projects[i]['projectInfo']
                                          as Map<String, dynamic>?)?['projectName'] as String? ??
                                      'Unnamed Project';
                                  final status = projects[i]['status'] as String? ?? 'Draft';
                                  final id = projects[i]['id'] as String? ?? '';
                                  VoidCallback? onTap;
                                  if (status == 'Ready' || status == 'In Progress' || status == 'Denied') {
                                    onTap = () => Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (_) => ProjectPage(projectName: name, projectId: id, status: status),
                                          ),
                                        ).then((_) {
                                          if (mounted) {
                                            setState(() {
                                              _activeProjectsFuture =
                                                  _projectService.getEngineerActiveProjects();
                                            });
                                          }
                                        });
                                  } else if (status == 'Awaiting Approval') {
                                    onTap = () => Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (_) => ProjectSummaryPage(projectId: id, projectName: name),
                                          ),
                                        );
                                  }
                                  return Project(
                                    title: name,
                                    status: status,
                                    onTap: onTap,
                                  );
                                }),
                              ],
                            ],
                          );
                        },
                      ),
                      SizedBox(height: 16),
                      TextButton(
                        style: TextButton.styleFrom(
                          padding: EdgeInsets.zero,
                          minimumSize: Size.zero,
                          tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                          overlayColor: Colors.transparent,
                        ),
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) =>
                                  const EngineerActiveProjectsPage(),
                            ),
                          ).then((_) {
                            if (mounted) {
                              setState(() {
                                _activeProjectsFuture =
                                    _projectService.getEngineerActiveProjects();
                              });
                            }
                          });
                        },
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Text(
                              "View All",
                              style: TextStyle(
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
            ],
          ),
        ),
      ),
    );
  }
}
