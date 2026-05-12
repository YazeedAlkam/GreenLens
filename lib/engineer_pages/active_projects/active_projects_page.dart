import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:greenlens/engineer_pages/project_page.dart';
import 'package:greenlens/firebase/project_service.dart';
import 'package:greenlens/main.dart';
import 'package:greenlens/shared_files/custom_app_bar.dart';
import 'package:greenlens/shared_files/fotter.dart';
import 'package:greenlens/shared_files/projects_template.dart';

class EngineerActiveProjectsPage extends StatefulWidget {
  const EngineerActiveProjectsPage({super.key});

  @override
  State<EngineerActiveProjectsPage> createState() =>
      _EngineerActiveProjectsPageState();
}

class _EngineerActiveProjectsPageState
    extends State<EngineerActiveProjectsPage> {
  late Future<List<Map<String, dynamic>>> _projectsFuture;

  @override
  void initState() {
    super.initState();
    _projectsFuture = ProjectService().getEngineerActiveProjects();
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
                          'Assigned Projects',
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
                                  'No active projects assigned.',
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
                                  Builder(builder: (context) {
                                    final name = (projects[i]['projectInfo']
                                            as Map<String, dynamic>?)?[
                                        'projectName'] as String? ??
                                        'Unnamed Project';
                                    final status = projects[i]['status'] as String? ?? 'Draft';
                                    final id = projects[i]['id'] as String? ?? '';
                                    final isNavigable = status == 'Ready' || status == 'In Progress';
                                    return Project(
                                      title: name,
                                      status: status,
                                      onTap: isNavigable
                                          ? () => Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                  builder: (_) => ProjectPage(projectName: name, projectId: id),
                                                ),
                                              )
                                          : null,
                                    );
                                  }),
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
            child: CreateNewProjectFooter(
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
