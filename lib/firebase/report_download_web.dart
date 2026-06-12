import 'dart:typed_data';
import 'dart:js_interop';
import 'package:web/web.dart' as web;

/// Web implementation of [saveAndOpenPdf].
///
/// Creates a Blob URL from the PDF bytes, programmatically clicks a hidden
/// anchor tag with the `download` attribute set, then revokes the object URL
/// to free memory. This triggers a browser "Save File" download dialog.
Future<void> saveAndOpenPdf(List<int> bytes, String filename) async {
  final uint8Array = Uint8List.fromList(bytes).toJS;
  final blob = web.Blob(
    [uint8Array].toJS,
    web.BlobPropertyBag(type: 'application/pdf'),
  );
  final url = web.URL.createObjectURL(blob);

  // Create a temporary <a> element to trigger the browser download.
  final anchor = web.document.createElement('a') as web.HTMLAnchorElement;
  anchor.href = url;
  anchor.download = filename;
  anchor.click();

  // Revoke the object URL immediately after click to release memory.
  web.URL.revokeObjectURL(url);
}
