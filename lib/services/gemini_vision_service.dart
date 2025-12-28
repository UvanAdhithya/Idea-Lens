import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;

class GeminiVisionService {
  static const String _apiKey = "AIzaSyCSSq42-HP4XqQuVgl06OXEi0jxnWE_4Iw";

  static Future<Map<String, dynamic>> analyzeImage(File imageFile) async {
    final bytes = await imageFile.readAsBytes();
    if (bytes.length > 2 * 1024 * 1024) {
      return {'error': 'Image too large (>2MB)'};
    }

    final base64Image = base64Encode(bytes);

    final response = await http.post(
      Uri.parse("https://generativelanguage.googleapis.com/v1/models/gemini-2.5-flash:generateContent?key=$_apiKey"),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({
        "contents": [{"parts": [{"text": "Analyze image. List objects. 3 projects with 5 steps and each step must use 20 token only . JSON ONLY:\n{\"objects\":[],\"Projects\":{\"easy\":[],\"medium\":[],\"hard\":[]}}"}, {"inlineData": {"mimeType": "image/jpeg", "data": base64Image}}]}],
        "generationConfig": {"maxOutputTokens": 1500}
      }),
    );

    if (response.statusCode != 200) {
      return {'error': 'API Error ${response.statusCode}'};
    }

    final decoded = jsonDecode(response.body);
    if (decoded["candidates"] == null) {
      return {'error': 'No candidates'};
    }

    String text = decoded["candidates"][0]["content"]["parts"][0]["text"];

    // ✅ SINGLE LINE PARSER
    String cleanJson = text.replaceAll(RegExp(r'``````'), '').replaceAll('`', '').trim();

    try {
      final result = jsonDecode(cleanJson);
      print('✅ SUCCESS: $result');
      return result;
    } catch (e) {
      return {'error': 'Parse failed', 'raw': cleanJson};
    }
  }
}
