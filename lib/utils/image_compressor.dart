import 'dart:io';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as path;

Future<File> compressImage(File file) async {
  final dir = await getTemporaryDirectory();
  final targetPath = path.join(
    dir.path,
    '${DateTime.now().millisecondsSinceEpoch}.jpg',
  );

  final compressedFile = await FlutterImageCompress.compressAndGetFile(
    file.absolute.path,
    targetPath,
    quality: 70, // 🔥 key
    minWidth: 1024,
    minHeight: 1024,
    format: CompressFormat.jpeg,
  );

  if (compressedFile == null) {
    return file; // fallback
  }

  return File(compressedFile.path);
}
