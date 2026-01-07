import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';


class GeminiVisionService {
  static String get apiKey => dotenv.env['API_KEY']!;

  static Future<Map<String, dynamic>> analyzeImage(File imageFile) async {
    Uint8List bytes = await imageFile.readAsBytes();
    
    // 🔥 Compression logic: If > 2MB, compress it.
    if (bytes.length > 2 * 1024 * 1024) {
      final compressedBytes = await FlutterImageCompress.compressWithList(
        bytes,
        minWidth: 1600,
        minHeight: 1600,
        quality: 80,
      );
      
      bytes = Uint8List.fromList(compressedBytes);
      
      // Still too large? Error out (safety check)
      if (bytes.length > 2 * 1024 * 1024) {
        return {'error': 'Image too large (>2MB) even after compression'};
      }
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
    // Handle markdown code blocks if present
    if (text.contains('```')) {
      final startIndex = text.indexOf('{');
      final endIndex = text.lastIndexOf('}');
      if (startIndex != -1 && endIndex != -1) {
        text = text.substring(startIndex, endIndex + 1);
      }
    }
    
    // Fallback search for first { and last } if still looks complex
    if (!text.trim().startsWith('{')) {
      final startIndex = text.indexOf('{');
      final endIndex = text.lastIndexOf('}');
      if (startIndex != -1 && endIndex != -1) {
        text = text.substring(startIndex, endIndex + 1);
      }
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
