import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;

class GeminiVisionService {
  static const String _apiKey = "AIzaSyB8HJpKMIrsOI4r0f1S-URPzE7m9IrN1Qs";

  static Future<Map<String, dynamic>> analyzeImage(File imageFile) async {
    final bytes = await imageFile.readAsBytes();
    final base64Image = base64Encode(bytes);

    final response = await http.post(
      Uri.parse(
        "https://generativelanguage.googleapis.com/v1/models/gemini-pro-vision:generateContent?key=$_apiKey",
      ),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({
        "contents": [
          {
            "parts": [
              {
                "text": """
Analyze the image.

Identify the main objects.
Create THREE practical tasks using the objects:
- Easy
- Medium
- Hard

Return STRICT JSON ONLY:

{
  "objects": [],
  "tasks": {
    "easy": "",
    "medium": "",
    "hard": ""
  }
}
"""
              },
              {
                "inlineData": {
                  "mimeType": "image/jpeg",
                  "data": base64Image
                }
              }
            ]
          }
        ]
      }),
    );

    final decoded = jsonDecode(response.body);
    final text =
    decoded["candidates"][0]["content"]["parts"][0]["text"];

    return jsonDecode(text);
  }
}
