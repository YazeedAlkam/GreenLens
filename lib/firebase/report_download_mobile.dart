import 'dart:io';
import 'package:open_file/open_file.dart';
import 'package:path_provider/path_provider.dart';

/// Mobile (Android / iOS) implementation of [saveAndOpenPdf].
///
/// Writes the PDF bytes to the app's documents directory, then opens the file
/// with the device's default PDF viewer via the open_file package.
Future<void> saveAndOpenPdf(List<int> bytes, String filename) async {
  final dir = await getApplicationDocumentsDirectory();
  final file = File('${dir.path}/$filename');
  await file.writeAsBytes(bytes);
  await OpenFile.open(file.path);
}
