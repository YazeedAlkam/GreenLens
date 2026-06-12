import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:greenlens/ceo_pages/ceo_audit_review_page.dart';
import 'package:greenlens/engineer_pages/audit_data_entery_flow.dart';
import 'package:greenlens/engineer_pages/project_summary_page.dart';
import 'package:greenlens/firebase/project_service.dart';
import 'package:greenlens/main.dart';
import 'package:greenlens/section_head_pages/create_new_project/create_new_project_flow.dart';
import 'package:greenlens/shared_files/custom_app_bar.dart';
import 'package:greenlens/shared_files/footer.dart';
import 'package:greenlens/shared_files/projects_template.dart';

/// Full-page list of all active projects (Section Head view).
///
/// Navigates to [CreateProjectFlow] for draft projects, [CeoAuditReviewPage]
/// for projects awaiting audit approval, and [ProjectSummaryPage] for others.
class ActiveProjectsPage extends StatefulWidget {
  const ActiveProjectsPage({super.key});

  @override
  State<ActiveProjectsPage> createState() => _ActiveProjectsPageState();
}

/// State for [ActiveProjectsPage]. Loads projects on init.
class _ActiveProjectsPageState extends State<ActiveProjectsPage> {
  late Future<List<Map<String, dynamic>>> _projectsFuture;

  @override
  void initState() {
    super.initState();
    _projectsFuture = ProjectService().getActiveProjects();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar.build(
        title: 'Active Projects',
        subtitle: 'Manage and monitor your audit projects',
      ),
      body: Column(
        children: [
          Expanded(
            child: ShaderMask(
              shaderCallback: (Rect bounds) {
                return const LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [Colors.white, Colors.white, Colors.transparent],
                  stops: [0.0, 0.93, 1.0],
                ).createShader(bounds);
              },
              blendMode: BlendMode.dstIn,
              child: SingleChildScrollView(
                padding: const EdgeInsets.fromLTRB(32, 30, 32, 16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        GestureDetector(
                          onTap: () => Navigator.pop(context),
                          child: SvgPicture.asset(
                            'assets/images/Left Arrow.svg',
                            height: 40,
                            width: 40,
                            colorFilter: const ColorFilter.mode(
                              Colors.black,
                              BlendMode.srcIn,
                            ),
                          ),
                        ),
                        const SizedBox(width: 8),
                        Text(
                          'Select Project',
                          style: GoogleFonts.firaSans(
                            fontSize: 32,
                            fontWeight: FontWeight.bold,
                            color: primaryColor,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),
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
                            offset: const Offset(0, 0),
                          ),
                        ],
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(16),
                        child: FutureBuilder<List<Map<String, dynamic>>>(
                          future: _projectsFuture,
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
                            final projects = (snapshot.data ?? []).where((p) {
                              final s = (p['status'] as String? ?? '').toLowerCase();
                              if (s == 'awaiting approval') {
                                // Hide if section head already approved — waiting on CEO
                                final sectionHeadApproved =
                                    p['sectionhead_approved'] as bool? ?? false;
                                if (sectionHeadApproved) return false;
                              }
                              return true;
                            }).toList();
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
                                                      _projectsFuture =
                                                          ProjectService()
                                                              .getActiveProjects();
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
                                                        _projectsFuture =
                                                            ProjectService()
                                                                .getActiveProjects();
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
                                                      projectId: project['id']
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
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(32, 0, 32, 32),
            child: Footer(
              currentStep: 0,
              onNext: () {},
              onBack: () => Navigator.pop(context),
              mode: FooterMode.backOnly,
            ),
          ),
        ],
      ),
    );
  }
}
