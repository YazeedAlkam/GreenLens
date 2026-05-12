import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:greenlens/firebase/project_service.dart';
import 'package:greenlens/main.dart';
import 'package:greenlens/section_head_pages/create_new_project/create_new_project_flow.dart';
import 'package:greenlens/shared_files/custom_app_bar.dart';
import 'package:greenlens/shared_files/fotter.dart';

String _formatDate(dynamic timestamp) {
  if (timestamp == null) return 'N/A';
  if (timestamp is! Timestamp) return 'N/A';
  final date = timestamp.toDate();
  final day = date.day;
  final String suffix;
  if (day >= 11 && day <= 13) {
    suffix = 'th';
  } else {
    switch (day % 10) {
      case 1:
        suffix = 'st';
      case 2:
        suffix = 'nd';
      case 3:
        suffix = 'rd';
      default:
        suffix = 'th';
    }
  }
  const months = [
    'January', 'February', 'March', 'April', 'May', 'June',
    'July', 'August', 'September', 'October', 'November', 'December',
  ];
  return '$day$suffix of ${months[date.month - 1]} ${date.year}';
}

class EngineerPreviousProjectsPage extends StatefulWidget {
  const EngineerPreviousProjectsPage({super.key});

  @override
  State<EngineerPreviousProjectsPage> createState() =>
      _EngineerPreviousProjectsPageState();
}

class _EngineerPreviousProjectsPageState
    extends State<EngineerPreviousProjectsPage> {
  late Future<List<Map<String, dynamic>>> _projectsFuture;

  @override
  void initState() {
    super.initState();
    _projectsFuture = ProjectService().getEngineerPreviousProjects();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar.build(
        title: 'Previous Projects',
        subtitle: 'View your previous projects',
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
                          'Dashboard',
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
                        child: Column(
                          children: [
                            Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 8),
                              child: Row(
                                children: [
                                  Text(
                                    "Project's Name",
                                    style: GoogleFonts.firaSans(
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.black,
                                    ),
                                  ),
                                  const Spacer(),
                                  Text(
                                    'Finishing Date',
                                    style: GoogleFonts.firaSans(
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.black,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            const Divider(height: 24, thickness: 1),
                            FutureBuilder<List<Map<String, dynamic>>>(
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
                                      'No previous projects.',
                                      style: GoogleFonts.firaSans(
                                        fontSize: 14,
                                        color: Colors.grey,
                                      ),
                                    ),
                                  );
                                }
                                return Column(
                                  children: [
                                    for (int i = 0;
                                        i < projects.length;
                                        i++) ...[
                                      _PreviousProjectRow(
                                        project: projects[i],
                                      ),
                                      if (i < projects.length - 1)
                                        const SizedBox(height: 16),
                                    ],
                                  ],
                                );
                              },
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
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

class _PreviousProjectRow extends StatelessWidget {
  final Map<String, dynamic> project;

  const _PreviousProjectRow({required this.project});

  @override
  Widget build(BuildContext context) {
    final title =
        (project['projectInfo'] as Map<String, dynamic>?)?['projectName'] ??
        project['customId'] ??
        'Untitled';
    final finishingDate = _formatDate(project['updatedAt']);

    return SizedBox(
      width: double.infinity,
      height: 70,
      child: Container(
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
        child: ElevatedButton(
          style: ElevatedButton.styleFrom(
            padding: EdgeInsets.zero,
            backgroundColor: Colors.white,
            elevation: 0,
            shadowColor: Colors.transparent,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => CreateProjectFlow(
                  existingProjectId: project['id'] as String,
                  readOnly: true,
                ),
              ),
            );
          },
          child: Padding(
            padding: const EdgeInsets.fromLTRB(8, 0, 8, 0),
            child: Row(
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 26,
                    color: Colors.black,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const Spacer(),
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: readyColor,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    finishingDate,
                    style: const TextStyle(
                      fontSize: 18,
                      color: Colors.white,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                SvgPicture.asset(
                  'assets/images/arrowright.svg',
                  height: 40,
                  width: 40,
                  colorFilter: ColorFilter.mode(primaryColor, BlendMode.srcIn),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
