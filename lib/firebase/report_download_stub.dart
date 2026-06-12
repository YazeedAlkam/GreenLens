/// Stub implementation of [saveAndOpenPdf] for unsupported platforms.
///
/// This file is the default import target. The conditional imports in
/// report_service.dart replace it at compile time with the web or mobile
/// implementation based on the target platform:
///
///   import 'report_download_stub.dart'
///     if (dart.library.html) 'report_download_web.dart'
///     if (dart.library.io)   'report_download_mobile.dart';
Future<void> saveAndOpenPdf(List<int> bytes, String filename) {
  throw UnsupportedError('saveAndOpenPdf not supported on this platform');
}
