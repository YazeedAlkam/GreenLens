import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:greenlens/firebase/project_service.dart';
import 'package:greenlens/main.dart';
import 'package:greenlens/shared_files/footer.dart';
import 'package:greenlens/shared_files/projects_template.dart';

class SelectProjectBody extends StatefulWidget {
  final void Function(Map<String, dynamic> project) onProjectSelected;
  final VoidCallback onBack;

  const SelectProjectBody({
    super.key,
    required this.onProjectSelected,
    required this.onBack,
  });

  @override
  State<SelectProjectBody> createState() => _SelectProjectBodyState();
}

class _SelectProjectBodyState extends State<SelectProjectBody> {
  late Future<List<Map<String, dynamic>>> _projectsFuture;

  @override
  void initState() {
    super.initState();
    _projectsFuture = ProjectService().getAllProjects();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          child: ShaderMask(
            shaderCallback: (Rect bounds) {
              return const LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [Colors.white, Colors.white, Colors.transparent],
                stops: [0.0, 0.93, 1],
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
                      onTap: widget.onBack,
                      child: SvgPicture.asset(
                        'assets/images/Left Arrow.svg',
                        height: 40,
                        width: 40,
                        colorFilter: ColorFilter.mode(
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
                        const SizedBox(height: 16),
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
                            final projects = (snapshot.data ?? [])
                                .where((p) =>
                                    (p['status'] as String? ?? '').toLowerCase() !=
                                    'completed')
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
                                  Project(
                                    title:
                                        (projects[i]['projectInfo']
                                            as Map<
                                              String,
                                              dynamic
                                            >?)?['projectName'] ??
                                        projects[i]['customId'] ??
                                        'Untitled',
                                    status:
                                        projects[i]['status'] as String? ??
                                        'Draft',
                                    onTap: () =>
                                        widget.onProjectSelected(projects[i]),
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
            onBack: widget.onBack,
            mode: FooterMode.backOnly,
          ),
        ),
      ],
    );
  }
}
