import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';


class GeminiVisionService {
  static String get apiKey => dotenv.env['API_KEY']!;

  static Future<Map<String, dynamic>> analyzeImage(File imageFile) async {
    final bytes = await imageFile.readAsBytes();
    if (bytes.length > 2 * 1024 * 1024) {
      return {'error': 'Image too large (>2MB)'};
    }

    final base64Image = base64Encode(bytes);

    final response = await http.post(
      Uri.parse("https://generativelanguage.googleapis.com/v1/models/gemini-2.5-flash:generateContent?key=$apiKey"),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({
        "contents": [{
          "parts": [
            {"text": "Identify objects in the image. Suggest 3 DIY projects (Easy, Medium, Hard) using them. Provide Title, Difficulty, Description (10 tokens max), and 5 short steps (10 words max each). Output JSON only, no markdown. JSON schema: {\\\"objects\\\": [], \\\"projects\\\": [{\\\"title\\\": \\\"\\\", \\\"difficulty\\\": \\\"\\\", \\\"description\\\": \\\"\\\", \\\"steps\\\": []}]}"},
            {"inlineData": {"mimeType": "image/jpeg", "data": base64Image}}
          ]
        }],
        "generationConfig": {
          "maxOutputTokens": 2048,
          "temperature": 0.5
        }
      }),
    );

    if (response.statusCode != 200) {
      return {'error': 'API Error ${response.statusCode}'};
    }

    final decoded = jsonDecode(response.body);
    if (decoded["candidates"] == null || decoded["candidates"].isEmpty) {
      return {'error': 'No candidates'};
    }

    String text = decoded["candidates"][0]["content"]["parts"][0]["text"];

    // ✅ ROBUST JSON CLEANER
    // Finds the first '{' and the last '}' to extract the valid JSON object
    final int startIndex = text.indexOf('{');
    final int endIndex = text.lastIndexOf('}');
    
    if (startIndex != -1 && endIndex != -1) {
      text = text.substring(startIndex, endIndex + 1);
    }

    try {
      final result = jsonDecode(text);
      //print('✅ SUCCESS: $result');
      return result;
    } catch (e) {
      //print('❌ PARSE FAILED: $text');
      return {'error': 'Parse failed', 'raw': text};
    }
  }
}
