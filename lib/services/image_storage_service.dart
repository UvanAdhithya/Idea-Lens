import 'dart:io';
import 'package:path_provider/path_provider.dart';

class ImageStorageService {
  Future<String> saveImageLocally(File image) async {
    final dir = await getApplicationDocumentsDirectory();
    final fileName =
        '${DateTime.now().millisecondsSinceEpoch}.jpg';
    final savedImage =
    await image.copy('${dir.path}/$fileName');
    return savedImage.path;
  }
}
