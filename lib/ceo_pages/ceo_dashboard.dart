import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:greenlens/firebase/auth_service.dart';
import 'package:greenlens/authentication/sign_in.dart';
import 'package:greenlens/shared_files/custom_app_bar.dart';
import 'package:greenlens/shared_files/projects_template.dart';
import 'package:greenlens/main.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:greenlens/firebase/project_service.dart';
import 'package:greenlens/ceo_pages/ceo_active_projects_page.dart';
import 'package:greenlens/ceo_pages/ceo_audit_review_page.dart';
import 'package:greenlens/ceo_pages/ceo_project_review_page.dart';
import 'package:greenlens/engineer_pages/audit_data_entery_flow.dart';
import 'package:greenlens/engineer_pages/project_summary_page.dart';
import 'package:greenlens/ceo_pages/assign_engineer_costs_page.dart';
import 'package:greenlens/section_head_pages/previous_projects/previous_projects_page.dart';

class CEOPage extends StatefulWidget {
  const CEOPage({super.key});

  @override
  State<CEOPage> createState() => _CEOPageState();
}

class _CEOPageState extends State<CEOPage> {
  final ProjectService _projectService = ProjectService();
  late Future<List<Map<String, dynamic>>> _activeProjectsFuture;

  static const _activeStatuses = {'In Progress', 'Awaiting Approval', 'Ready'};

  @override
  void initState() {
    super.initState();
    _activeProjectsFuture = _projectService.getLatestProjects();
  }

  VoidCallback? _buildOnTap(
    BuildContext context,
    Map<String, dynamic> project,
  ) {
    final status = project['status'] as String? ?? '';
    final hasAuditData = project.containsKey('auditData') &&
        project['auditData'] != null;

    if (status == 'Awaiting Approval') {
      return () async {
        final changed = await Navigator.push<bool>(
          context,
          MaterialPageRoute(
            builder: (_) => hasAuditData
                ? CeoAuditReviewPage(project: project)
                : CeoProjectReviewPage(project: project),
          ),
        );
        if (changed == true && mounted) {
          setState(() {
            _activeProjectsFuture = _projectService.getLatestProjects();
          });
        }
      };
    }

    if (status == 'In Progress') {
      return () => Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => AuditEntryFlow(
                projectId: project['id'] as String,
                readOnly: true,
              ),
            ),
          );
    }

    if (status == 'Ready') {
      final projectName = (project['projectInfo']
              as Map<String, dynamic>?)?['projectName'] as String? ??
          project['customId'] as String? ??
          'Untitled';
      return () => Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => ProjectSummaryPage(
                projectId: project['id'] as String,
                projectName: projectName,
              ),
            ),
          );
    }

    return null;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar.build(
        title: 'Dashboard|CEO',
        subtitle: 'Manage and monitor your audit projects',
      ),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.fromLTRB(32, 30, 32, 16),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                //Previous Projects Button --------------->
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
                          builder: (_) => const PreviousProjectsPage(),
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
                SizedBox(height: 16),
                //Assign Engineer Costs Button --------------->
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
                          builder: (_) => const AssignEngineerCostsPage(),
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
                                'assets/images/Dollar Circle.svg',
                                height: 40,
                                width: 40,
                                colorFilter: ColorFilter.mode(
                                  Colors.white,
                                  BlendMode.srcIn,
                                ),
                              ),
                              SizedBox(width: 10),
                              Text(
                                'Assign Engineer Costs',
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
                        FutureBuilder<List<Map<String, dynamic>>>(
                          future: _activeProjectsFuture,
                          builder: (context, snapshot) {
                            if (snapshot.connectionState ==
                                ConnectionState.waiting) {
                              return const Padding(
                                padding: EdgeInsets.symmetric(vertical: 16),
                                child: Center(
                                  child: CircularProgressIndicator(),
                                ),
                              );
                            }
                            if (snapshot.hasError) {
                              return Padding(
                                padding: const EdgeInsets.symmetric(
                                  vertical: 16,
                                ),
                                child: Text(
                                  'Failed to load projects.',
                                  style: GoogleFonts.firaSans(
                                    color: Colors.red,
                                  ),
                                ),
                              );
                            }
                            final projects = (snapshot.data ?? [])
                                .where((p) => _activeStatuses.contains(
                                      p['status'] as String? ?? '',
                                    ))
                                .take(4)
                                .toList();
                            if (projects.isEmpty) {
                              return Padding(
                                padding: const EdgeInsets.symmetric(
                                  vertical: 16,
                                ),
                                child: Text(
                                  'No active projects.',
                                  style: GoogleFonts.firaSans(
                                    fontSize: 14,
                                    color: Colors.grey,
                                  ),
                                ),
                              );
                            }
                            return Column(
                              children: [
                                for (int i = 0; i < projects.length; i++) ...[
                                  Project(
                                    title: (projects[i]['projectInfo']
                                                as Map<String, dynamic>?)?[
                                            'projectName'] ??
                                        projects[i]['customId'] ??
                                        'Untitled',
                                    status: projects[i]['status'] as String? ??
                                        'In Progress',
                                    onTap: _buildOnTap(context, projects[i]),
                                  ),
                                  if (i < projects.length - 1)
                                    const SizedBox(height: 16),
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
                                builder: (_) => const CeoActiveProjectsPage(),
                              ),
                            ).then((_) {
                              if (mounted) {
                                setState(() {
                                  _activeProjectsFuture =
                                      _projectService.getLatestProjects();
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
                SizedBox(height: 16),
                ],
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(32, 0, 32, 32),
            child: SizedBox(
              width: double.infinity,
              height: 64,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.fromLTRB(16, 8, 16, 8),
                  backgroundColor: const Color(0xFFD32F2F),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                onPressed: () async {
                  await AuthService().signOut();
                  if (context.mounted) {
                    Navigator.pushAndRemoveUntil(
                      context,
                      MaterialPageRoute(builder: (_) => const SignInPage()),
                      (route) => false,
                    );
                  }
                },
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Icon(Icons.logout, color: Colors.white, size: 32),
                    const SizedBox(width: 10),
                    Text(
                      'Logout',
                      style: GoogleFonts.firaSans(
                        fontSize: 16,
                        color: Colors.white,
                        fontWeight: FontWeight.normal,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
