import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:greenlens/firebase/project_service.dart';
import 'package:greenlens/firebase/report_service.dart';
import 'package:greenlens/main.dart';
import 'package:greenlens/shared_files/custom_app_bar.dart';
import 'package:greenlens/engineer_pages/audit_data_entery_flow.dart';
import 'package:greenlens/engineer_pages/project_summary_page.dart';
import 'package:greenlens/shared_files/charts/project_charts_grid.dart';
import 'package:greenlens/shared_files/footer.dart';

class ProjectPage extends StatefulWidget {
  final String projectName;
  final String projectId;
  final String status;
  const ProjectPage({
    super.key,
    required this.projectName,
    required this.projectId,
    this.status = '',
  });

  @override
  State<ProjectPage> createState() => _ProjectPageState();
}

class _ProjectPageState extends State<ProjectPage> {
  Future<List<Uint8List?>> Function()? _captureCharts;
  Future<Uint8List?> Function()? _captureCostChart;

  bool _isCompleting = false;
  bool _isGeneratingReport = false;
  bool _isGeneratingCostReport = false;
  bool _isGeneratingTechCostReport = false;

  bool get _isReady => widget.status == 'Ready';

  Future<void> _markAsCompleted() async {
    setState(() => _isCompleting = true);
    try {
      await ProjectService().updateFields(widget.projectId, {
        'status': 'Completed',
      });
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Project marked as completed')),
        );
        Navigator.pop(context, true);
      }
    } catch (e) {
      if (mounted) {
        setState(() => _isCompleting = false);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to mark as completed: $e')),
        );
      }
    }
  }

  Future<void> _generateCostReport() async {
    // Capture the cost chart BEFORE setState so the render tree is still stable.
    debugPrint('[Report] _captureCostChart is ${_captureCostChart == null ? "NULL – callback never wired" : "set"}');
    final costChart = await _captureCostChart?.call();
    debugPrint('[Report] cost chart: ${costChart == null ? "null" : "${costChart.length} bytes"}');

    setState(() => _isGeneratingCostReport = true);
    String? errorMsg;
    try {
      await ReportService().generateCostReport(widget.projectId, costChart: costChart);
    } catch (e) {
      errorMsg = 'Failed to generate cost report: $e';
    } finally {
      if (mounted) setState(() => _isGeneratingCostReport = false);
    }
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(errorMsg ?? 'Cost report generated successfully'),
        ),
      );
    }
  }

  Future<void> _generateTechCostReport() async {
    debugPrint('[Report] _captureCharts is ${_captureCharts == null ? "NULL – callback never wired" : "set"}');
    final chartImages = await _captureCharts?.call() ?? [];
    debugPrint('[Report] captured ${chartImages.where((b) => b != null).length}/${chartImages.length} charts');

    setState(() => _isGeneratingTechCostReport = true);
    String? errorMsg;
    try {
      await ReportService()
          .generateTechCostReport(widget.projectId, chartImages: chartImages);
    } catch (e) {
      errorMsg = 'Failed to generate report: $e';
    } finally {
      if (mounted) setState(() => _isGeneratingTechCostReport = false);
    }
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(errorMsg ?? 'Technical & Cost report generated successfully'),
        ),
      );
    }
  }

  Future<void> _generateTechnicalReport() async {
    // Capture charts BEFORE setState so the render tree is still stable.
    debugPrint('[Report] _captureCharts is ${_captureCharts == null ? "NULL – callback never wired" : "set"}');
    final chartImages = await _captureCharts?.call() ?? [];
    debugPrint('[Report] captured ${chartImages.where((b) => b != null).length}/${chartImages.length} charts');

    setState(() => _isGeneratingReport = true);
    String? errorMsg;
    try {
      await ReportService()
          .generateTechnicalReport(widget.projectId, chartImages: chartImages);
    } catch (e) {
      errorMsg = 'Failed to generate report: $e';
    } finally {
      if (mounted) setState(() => _isGeneratingReport = false);
    }
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(errorMsg ?? 'Technical report generated successfully'),
        ),
      );
    }
  }

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
                // Only visible when Ready
                if (_isReady) ...[
                  // Generate Technical Report
                  SizedBox(
                    width: double.infinity,
                    height: 64,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.fromLTRB(16, 8, 16, 8),
                        backgroundColor: dashButtonColor,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      onPressed: _isGeneratingReport
                          ? null
                          : _generateTechnicalReport,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              if (_isGeneratingReport)
                                const SizedBox(
                                  width: 40,
                                  height: 40,
                                  child: Center(
                                    child: SizedBox(
                                      width: 24,
                                      height: 24,
                                      child: CircularProgressIndicator(
                                        color: Colors.white,
                                        strokeWidth: 2.5,
                                      ),
                                    ),
                                  ),
                                )
                              else
                                SvgPicture.asset(
                                  'assets/images/GenrateChart.svg',
                                  height: 40,
                                  width: 40,
                                  colorFilter: const ColorFilter.mode(
                                    Colors.white,
                                    BlendMode.srcIn,
                                  ),
                                ),
                              const SizedBox(width: 10),
                              const Text(
                                'Generate Technical Report',
                                style: TextStyle(
                                  fontSize: 16,
                                  color: Colors.white,
                                  fontWeight: FontWeight.normal,
                                ),
                              ),
                            ],
                          ),
                          const Spacer(),
                          SvgPicture.asset(
                            'assets/images/arrowright.svg',
                            height: 40,
                            width: 40,
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  // Generate Cost Report
                  SizedBox(
                    width: double.infinity,
                    height: 64,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.fromLTRB(16, 8, 16, 8),
                        backgroundColor: dashButtonColor,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      onPressed: _isGeneratingCostReport
                          ? null
                          : _generateCostReport,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              if (_isGeneratingCostReport)
                                const SizedBox(
                                  width: 40,
                                  height: 40,
                                  child: Center(
                                    child: SizedBox(
                                      width: 24,
                                      height: 24,
                                      child: CircularProgressIndicator(
                                        color: Colors.white,
                                        strokeWidth: 2,
                                      ),
                                    ),
                                  ),
                                )
                              else
                                SvgPicture.asset(
                                  'assets/images/Dollar Square.svg',
                                  height: 40,
                                  width: 40,
                                  colorFilter: const ColorFilter.mode(
                                    Colors.white,
                                    BlendMode.srcIn,
                                  ),
                                ),
                              const SizedBox(width: 10),
                              const Text(
                                'Generate Cost Report',
                                style: TextStyle(
                                  fontSize: 16,
                                  color: Colors.white,
                                  fontWeight: FontWeight.normal,
                                ),
                              ),
                            ],
                          ),
                          const Spacer(),
                          SvgPicture.asset(
                            'assets/images/arrowright.svg',
                            height: 40,
                            width: 40,
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  // Generate Technical & Cost Report
                  SizedBox(
                    width: double.infinity,
                    height: 64,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.fromLTRB(16, 8, 16, 8),
                        backgroundColor: dashButtonColor,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      onPressed: _isGeneratingTechCostReport
                          ? null
                          : _generateTechCostReport,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              if (_isGeneratingTechCostReport)
                                const SizedBox(
                                  width: 40,
                                  height: 40,
                                  child: Center(
                                    child: SizedBox(
                                      width: 24,
                                      height: 24,
                                      child: CircularProgressIndicator(
                                        color: Colors.white,
                                        strokeWidth: 2.5,
                                      ),
                                    ),
                                  ),
                                )
                              else
                                SvgPicture.asset(
                                  'assets/images/Document Justify Center 1.svg',
                                  height: 40,
                                  width: 40,
                                  colorFilter: const ColorFilter.mode(
                                    Colors.white,
                                    BlendMode.srcIn,
                                  ),
                                ),
                              const SizedBox(width: 10),
                              const Text(
                                'Generate Technical & Cost Report',
                                style: TextStyle(
                                  fontSize: 16,
                                  color: Colors.white,
                                  fontWeight: FontWeight.normal,
                                ),
                              ),
                            ],
                          ),
                          const Spacer(),
                          SvgPicture.asset(
                            'assets/images/arrowright.svg',
                            height: 40,
                            width: 40,
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                ],

                // Operational Audit Data — hidden when project is Ready
                if (!_isReady) ...[
                  SizedBox(
                    width: double.infinity,
                    height: 64,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.fromLTRB(16, 8, 16, 8),
                        backgroundColor: dashButtonColor,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) =>
                                AuditEntryFlow(projectId: widget.projectId),
                          ),
                        ).then((result) {
                          if (result == true && mounted) Navigator.pop(context);
                        });
                      },
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              SvgPicture.asset(
                                'assets/images/Opertaional.svg',
                                height: 40,
                                width: 40,
                                colorFilter: const ColorFilter.mode(
                                  Colors.white,
                                  BlendMode.srcIn,
                                ),
                              ),
                              const SizedBox(width: 10),
                              const Text(
                                'Operational Audit Data',
                                style: TextStyle(
                                  fontSize: 16,
                                  color: Colors.white,
                                  fontWeight: FontWeight.normal,
                                ),
                              ),
                            ],
                          ),
                          const Spacer(),
                          SvgPicture.asset(
                            'assets/images/arrowright.svg',
                            height: 40,
                            width: 40,
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                ],

                // Project Summary card
                Container(
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
                  width: double.infinity,
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
                        const SizedBox(height: 12),
                        ProjectChartsGrid(
                          projectId: widget.projectId,
                          onCaptureReady: (fn) => _captureCharts = fn,
                          onCaptureCostChart: (fn) => _captureCostChart = fn,
                        ),
                        Padding(
                          padding: const EdgeInsets.all(12.0),
                          child: TextButton(
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (_) => ProjectSummaryPage(
                                    projectId: widget.projectId,
                                    projectName: widget.projectName,
                                  ),
                                ),
                              );
                            },
                            child: Center(
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
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
                  ),
                ),
                const SizedBox(height: 16),

                // Footer
                if (_isCompleting)
                  const Center(child: CircularProgressIndicator())
                else if (_isReady)
                  Footer(
                    currentStep: 0,
                    mode: FooterMode.markComplete,
                    onBack: () => Navigator.pop(context),
                    onNext: () {},
                    onMarkComplete: _markAsCompleted,
                  )
                else
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
