import 'dart:convert';
import 'dart:typed_data';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:greenlens/firebase/project_service.dart';
import 'package:greenlens/firebase/report_download_stub.dart'
    if (dart.library.html) 'package:greenlens/firebase/report_download_web.dart'
    if (dart.library.io) 'package:greenlens/firebase/report_download_mobile.dart';
import 'package:http/http.dart' as http;

class ReportService {
  static const _serverUrl =
      'https://greenlens-report-server-production.up.railway.app';

  Future<void> generateTechnicalReport(
    String projectId, {
    List<Uint8List?> chartImages = const [],
  }) async {
    final data = await ProjectService().getProjectById(projectId);
    if (data == null) throw Exception('Project not found');

    final user = FirebaseAuth.instance.currentUser;
    if (user == null) throw Exception('Not authenticated');
    final token = await user.getIdToken();

    final uri = Uri.parse('$_serverUrl/generate-report');
    final request = http.MultipartRequest('POST', uri)
      ..headers['authorization'] = 'Bearer $token'
      ..fields['data'] = jsonEncode(_sanitize(data));

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

    final streamed =
        await request.send().timeout(const Duration(seconds: 120));
    final bytes = await streamed.stream.toBytes();

    if (streamed.statusCode != 200) {
      throw Exception(
          'Server error ${streamed.statusCode}: ${String.fromCharCodes(bytes)}');
    }

    final projectName = (data['projectInfo'] as Map?)?['projectName'] as String? ?? projectId;
    final safeName = projectName.replaceAll(RegExp(r'[^\w\s-]'), '').trim().replaceAll(RegExp(r'\s+'), '_');
    await saveAndOpenPdf(bytes, 'Technical_Report_For_$safeName.pdf');
  }

  Future<void> generateCostReport(
    String projectId, {
    Uint8List? costChart,
  }) async {
    final data = await ProjectService().getProjectById(projectId);
    if (data == null) throw Exception('Project not found');

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

    final streamed =
        await request.send().timeout(const Duration(seconds: 120));
    final bytes = await streamed.stream.toBytes();

    if (streamed.statusCode != 200) {
      throw Exception(
          'Server error ${streamed.statusCode}: ${String.fromCharCodes(bytes)}');
    }

    final projectName = (data['projectInfo'] as Map?)?['projectName'] as String? ?? projectId;
    final safeName = projectName.replaceAll(RegExp(r'[^\w\s-]'), '').trim().replaceAll(RegExp(r'\s+'), '_');
    await saveAndOpenPdf(bytes, 'Cost_Report_For_$safeName.pdf');
  }

  Future<void> generateTechCostReport(
    String projectId, {
    List<Uint8List?> chartImages = const [],
  }) async {
    final data = await ProjectService().getProjectById(projectId);
    if (data == null) throw Exception('Project not found');

    final user = FirebaseAuth.instance.currentUser;
    if (user == null) throw Exception('Not authenticated');
    final token = await user.getIdToken();

    final uri = Uri.parse('$_serverUrl/generate-tech-cost-report');
    final request = http.MultipartRequest('POST', uri)
      ..headers['authorization'] = 'Bearer $token'
      ..fields['data'] = jsonEncode(_sanitize(data));

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

    final streamed =
        await request.send().timeout(const Duration(seconds: 120));
    final bytes = await streamed.stream.toBytes();

    if (streamed.statusCode != 200) {
      throw Exception(
          'Server error ${streamed.statusCode}: ${String.fromCharCodes(bytes)}');
    }

    final projectName = (data['projectInfo'] as Map?)?['projectName'] as String? ?? projectId;
    final safeName = projectName.replaceAll(RegExp(r'[^\w\s-]'), '').trim().replaceAll(RegExp(r'\s+'), '_');
    await saveAndOpenPdf(bytes, 'Technical_and_Cost_Report_For_$safeName.pdf');
  }

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
