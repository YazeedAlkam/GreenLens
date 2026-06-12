import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:greenlens/ceo_pages/ceo_audit_review_page.dart';
import 'package:greenlens/ceo_pages/ceo_project_review_page.dart';
import 'package:greenlens/engineer_pages/audit_data_entery_flow.dart';
import 'package:greenlens/engineer_pages/project_summary_page.dart';
import 'package:greenlens/firebase/project_service.dart';
import 'package:greenlens/main.dart';
import 'package:greenlens/shared_files/custom_app_bar.dart';
import 'package:greenlens/shared_files/footer.dart';
import 'package:greenlens/shared_files/projects_template.dart';

/// Full-page list of all active projects (CEO view).
///
/// Shows projects with statuses: In Progress, Awaiting Approval, and Ready.
/// Navigates to the appropriate review or summary page based on project state.
class CeoActiveProjectsPage extends StatefulWidget {
  const CeoActiveProjectsPage({super.key});

  @override
  State<CeoActiveProjectsPage> createState() => _CeoActiveProjectsPageState();
}

/// State for [CeoActiveProjectsPage]. Loads and filters active projects on init.
class _CeoActiveProjectsPageState extends State<CeoActiveProjectsPage> {
  static const _activeStatuses = {'In Progress', 'Awaiting Approval', 'Ready'};

  late Future<List<Map<String, dynamic>>> _projectsFuture;

  @override
  void initState() {
    super.initState();
    _projectsFuture = _loadProjects();
  }

  /// Fetches all active projects and filters to only the recognised active statuses.
  Future<List<Map<String, dynamic>>> _loadProjects() async {
    final all = await ProjectService().getActiveProjects();
    return all
        .where((p) => _activeStatuses.contains(p['status'] as String? ?? ''))
        .toList();
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
            _projectsFuture = _loadProjects();
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
                            final projects = snapshot.data ?? [];
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
