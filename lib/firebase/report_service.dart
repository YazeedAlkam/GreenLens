import 'dart:convert';
import 'dart:typed_data';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:greenlens/firebase/project_service.dart';
import 'package:greenlens/firebase/report_download_stub.dart'
    if (dart.library.html) 'package:greenlens/firebase/report_download_web.dart'
    if (dart.library.io) 'package:greenlens/firebase/report_download_mobile.dart';
import 'package:http/http.dart' as http;

/// Handles all communication with the GreenLens report generation server.
///
/// For each report type, this service:
///   1. Fetches the full project document from Firestore.
///   2. Gets a fresh Firebase ID token for the Authorization header.
///   3. Sends project data + chart images as multipart/form-data to the server.
///   4. Receives the generated PDF bytes and saves/opens the file on the device.
///
/// Chart images are passed as Uint8List (PNG bytes) captured from the Flutter
/// chart widgets using a RepaintBoundary before the request is made.
class ReportService {
  static const _serverUrl =
      'https://greenlens-report-server-production.up.railway.app';

  /// Generates a technical energy audit PDF report.
  ///
  /// [chartImages] — up to 4 PNG snapshots of the project's chart widgets:
  ///   index 0 = Savings Donut, 1 = Annual Consumption,
  ///   2 = Potential Savings, 3 = Estimated Cost.
  /// Null entries are skipped; the server falls back to placeholder images.
  Future<void> generateTechnicalReport(
    String projectId, {
    List<Uint8List?> chartImages = const [],
  }) async {
    // Load full project document from Firestore.
    final data = await ProjectService().getProjectById(projectId);
    if (data == null) throw Exception('Project not found');

    // Get a fresh Firebase ID token — the server verifies this on every request.
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) throw Exception('Not authenticated');
    final token = await user.getIdToken();

    final uri = Uri.parse('$_serverUrl/generate-report');
    final request = http.MultipartRequest('POST', uri)
      ..headers['authorization'] = 'Bearer $token'
      ..fields['data'] = jsonEncode(_sanitize(data));

    // Attach each non-null chart PNG as a named file part (chart1..chart4).
    for (int i = 0; i < 4; i++) {
      final bytes = i < chartImages.length ? chartImages[i] : null;
      if (bytes != null) {
        request.files.add(http.MultipartFile.fromBytes(
          'chart${i + 1}',
          bytes,
          filename: 'chart${i + 1}.png',
        ));
      }
    }

    // LibreOffice conversion on the server can take ~30–60 s; allow 120 s total.
    final streamed =
        await request.send().timeout(const Duration(seconds: 120));
    final bytes = await streamed.stream.toBytes();

    if (streamed.statusCode != 200) {
      throw Exception(
          'Server error ${streamed.statusCode}: ${String.fromCharCodes(bytes)}');
    }

    // Strip special characters from the project name so it is safe as a filename.
    final projectName = (data['projectInfo'] as Map?)?['projectName'] as String? ?? projectId;
    final safeName = projectName.replaceAll(RegExp(r'[^\w\s-]'), '').trim().replaceAll(RegExp(r'\s+'), '_');
    await saveAndOpenPdf(bytes, 'Technical_Report_For_$safeName.pdf');
  }

  /// Generates a cost breakdown PDF report.
  ///
  /// [costChart] — PNG snapshot of the Savings Donut / cost breakdown chart.
  /// The server fetches engineer hourly rates from Firestore and calculates
  /// the total study cost (rate × 8 hrs × working days).
  Future<void> generateCostReport(
    String projectId, {
    Uint8List? costChart,
  }) async {
    // Load full project document from Firestore.
    final data = await ProjectService().getProjectById(projectId);
    if (data == null) throw Exception('Project not found');

    // Get a fresh Firebase ID token — the server verifies this on every request.
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) throw Exception('Not authenticated');
    final token = await user.getIdToken();

    final uri = Uri.parse('$_serverUrl/generate-cost-report');
    final request = http.MultipartRequest('POST', uri)
      ..headers['authorization'] = 'Bearer $token'
      ..fields['data'] = jsonEncode(_sanitize(data));

    if (costChart != null) {
      request.files.add(http.MultipartFile.fromBytes(
        'chart1',
        costChart,
        filename: 'chart1.png',
      ));
    }

    // LibreOffice conversion on the server can take ~30–60 s; allow 120 s total.
    final streamed =
        await request.send().timeout(const Duration(seconds: 120));
    final bytes = await streamed.stream.toBytes();

    if (streamed.statusCode != 200) {
      throw Exception(
          'Server error ${streamed.statusCode}: ${String.fromCharCodes(bytes)}');
    }

    // Strip special characters from the project name so it is safe as a filename.
    final projectName = (data['projectInfo'] as Map?)?['projectName'] as String? ?? projectId;
    final safeName = projectName.replaceAll(RegExp(r'[^\w\s-]'), '').trim().replaceAll(RegExp(r'\s+'), '_');
    await saveAndOpenPdf(bytes, 'Cost_Report_For_$safeName.pdf');
  }

  /// Generates a combined technical + cost PDF report.
  ///
  /// Uses the same 4 chart images as the technical report. The server appends
  /// the study cost section (transportation, machinery, engineers, other)
  /// using the "Technical and Cost Report Template.docx".
  Future<void> generateTechCostReport(
    String projectId, {
    List<Uint8List?> chartImages = const [],
  }) async {
    // Load full project document from Firestore.
    final data = await ProjectService().getProjectById(projectId);
    if (data == null) throw Exception('Project not found');

    // Get a fresh Firebase ID token — the server verifies this on every request.
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) throw Exception('Not authenticated');
    final token = await user.getIdToken();

    final uri = Uri.parse('$_serverUrl/generate-tech-cost-report');
    final request = http.MultipartRequest('POST', uri)
      ..headers['authorization'] = 'Bearer $token'
      ..fields['data'] = jsonEncode(_sanitize(data));

    // Attach each non-null chart PNG as a named file part (chart1..chart4).
    for (int i = 0; i < 4; i++) {
      final bytes = i < chartImages.length ? chartImages[i] : null;
      if (bytes != null) {
        request.files.add(http.MultipartFile.fromBytes(
          'chart${i + 1}',
          bytes,
          filename: 'chart${i + 1}.png',
        ));
      }
    }

    // LibreOffice conversion on the server can take ~30–60 s; allow 120 s total.
    final streamed =
        await request.send().timeout(const Duration(seconds: 120));
    final bytes = await streamed.stream.toBytes();

    if (streamed.statusCode != 200) {
      throw Exception(
          'Server error ${streamed.statusCode}: ${String.fromCharCodes(bytes)}');
    }

    // Strip special characters from the project name so it is safe as a filename.
    final projectName = (data['projectInfo'] as Map?)?['projectName'] as String? ?? projectId;
    final safeName = projectName.replaceAll(RegExp(r'[^\w\s-]'), '').trim().replaceAll(RegExp(r'\s+'), '_');
    await saveAndOpenPdf(bytes, 'Technical_and_Cost_Report_For_$safeName.pdf');
  }

  /// Recursively converts Firestore-specific types (Timestamp, nested Maps/Lists)
  /// to JSON-safe values so the project data can be encoded with jsonEncode.
  dynamic _sanitize(dynamic value) {
    if (value is Timestamp) {
      return value.toDate().toIso8601String();
    } else if (value is Map) {
      return value.map((k, v) => MapEntry(k.toString(), _sanitize(v)));
    } else if (value is List) {
      return value.map(_sanitize).toList();
    }
    return value;
  }
}
