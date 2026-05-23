import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:greenlens/shared_files/custom_app_bar.dart';
import 'package:greenlens/shared_files/projects_template.dart';
import 'package:greenlens/main.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:greenlens/firebase/project_service.dart';
import 'package:greenlens/ceo_pages/ceo_audit_review_page.dart';
import 'package:greenlens/engineer_pages/audit_data_entery_flow.dart';
import 'package:greenlens/engineer_pages/project_summary_page.dart';
import 'package:greenlens/section_head_pages/create_new_project/create_new_project_flow.dart';
import 'package:greenlens/section_head_pages/active_projects/active_projects_page.dart';
import 'package:greenlens/section_head_pages/previous_projects/previous_projects_page.dart';

class SectionHeadPage extends StatefulWidget {
  const SectionHeadPage({super.key});

  @override
  State<SectionHeadPage> createState() => _SectionHeadPageState();
}

class _SectionHeadPageState extends State<SectionHeadPage> {
  final ProjectService _projectService = ProjectService();
  late Future<List<Map<String, dynamic>>> _latestProjectsFuture;

  @override
  void initState() {
    super.initState();
    _latestProjectsFuture = _projectService.getLatestProjects();
  }

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
                      Navigator.pushNamed(context, "/create_new_project").then((
                        _,
                      ) {
                        if (mounted) {
                          setState(() {
                            _latestProjectsFuture = _projectService
                                .getLatestProjects();
                          });
                        }
                      });
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
                      Navigator.pushNamed(context, '/assign_engineers');
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
                        FutureBuilder<List<Map<String, dynamic>>>(
                          future: _latestProjectsFuture,
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
                                .where((p) {
                                  final s = (p['status'] as String? ?? '').toLowerCase();
                                  if (s == 'completed') return false;
                                  if (s == 'denied') {
                                    final auditData = p['auditData'];
                                    final hasAuditData = auditData != null &&
                                        (auditData as Map).isNotEmpty;
                                    return !hasAuditData;
                                  }
                                  if (s == 'awaiting approval') {
                                    // Hide if section head already approved — waiting on CEO
                                    final sectionHeadApproved =
                                        p['sectionhead_approved'] as bool? ?? false;
                                    if (sectionHeadApproved) return false;
                                  }
                                  return true;
                                })
                                .take(4)
                                .toList();
                            if (projects.isEmpty) {
                              return Padding(
                                padding: const EdgeInsets.symmetric(
                                  vertical: 16,
                                ),
                                child: Text(
                                  'No projects yet.',
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
                                  Builder(
                                    builder: (context) {
                                      final project = projects[i];
                                      final status =
                                          project['status'] as String? ??
                                          'Draft';
                                      final isDraftOrDenied =
                                          status == 'Draft' ||
                                          status == 'Denied';
                                      final isAwaitingApproval =
                                          status == 'Awaiting Approval';
                                      final isInProgress =
                                          status == 'In Progress';
                                      final isReady = status == 'Ready';
                                      final projectName =
                                          (project['projectInfo']
                                              as Map<String, dynamic>?)?[
                                          'projectName'] as String? ??
                                          project['customId'] as String? ??
                                          'Untitled';
                                      final hasAuditData = () {
                                        final a = project['auditData'];
                                        return a != null && (a as Map).isNotEmpty;
                                      }();
                                      return Project(
                                        title: projectName,
                                        status: status,
                                        onTap: isDraftOrDenied
                                            ? () {
                                                Navigator.push(
                                                  context,
                                                  MaterialPageRoute(
                                                    builder: (_) =>
                                                        CreateProjectFlow(
                                                          existingProjectId:
                                                              project['id']
                                                                  as String,
                                                        ),
                                                  ),
                                                ).then((_) {
                                                  if (mounted) {
                                                    setState(() {
                                                      _latestProjectsFuture =
                                                          _projectService
                                                              .getLatestProjects();
                                                    });
                                                  }
                                                });
                                              }
                                            : isAwaitingApproval
                                            ? () {
                                                if (hasAuditData) {
                                                  Navigator.push(
                                                    context,
                                                    MaterialPageRoute(
                                                      builder: (_) =>
                                                          CeoAuditReviewPage(
                                                        project: project,
                                                        isSectionHead: true,
                                                      ),
                                                    ),
                                                  ).then((_) {
                                                    if (mounted) {
                                                      setState(() {
                                                        _latestProjectsFuture =
                                                            _projectService
                                                                .getLatestProjects();
                                                      });
                                                    }
                                                  });
                                                } else {
                                                  Navigator.push(
                                                    context,
                                                    MaterialPageRoute(
                                                      builder: (_) =>
                                                          CreateProjectFlow(
                                                        existingProjectId:
                                                            project['id']
                                                                as String,
                                                        readOnly: true,
                                                      ),
                                                    ),
                                                  );
                                                }
                                              }
                                            : isInProgress
                                            ? () {
                                                Navigator.push(
                                                  context,
                                                  MaterialPageRoute(
                                                    builder: (_) =>
                                                        AuditEntryFlow(
                                                          projectId:
                                                              project['id']
                                                                  as String,
                                                          readOnly: true,
                                                        ),
                                                  ),
                                                );
                                              }
                                            : isReady
                                            ? () {
                                                Navigator.push(
                                                  context,
                                                  MaterialPageRoute(
                                                    builder: (_) =>
                                                        ProjectSummaryPage(
                                                      projectId: project['id']
                                                          as String,
                                                      projectName: projectName,
                                                    ),
                                                  ),
                                                );
                                              }
                                            : null,
                                      );
                                    },
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
                                builder: (_) => const ActiveProjectsPage(),
                              ),
                            ).then((_) {
                              if (mounted) {
                                setState(() {
                                  _latestProjectsFuture =
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
                SizedBox(height: 60),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
