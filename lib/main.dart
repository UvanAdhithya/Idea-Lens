import 'package:flutter/material.dart';
import 'screens/home_screen.dart';
import 'screens/gemini_image_tasks_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'EduCraft',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.teal,
          brightness: Brightness.light,
        ),
      ),

      // ✅ Named routes (clean & scalable)
      routes: {
        '/': (context) => const HomeScreen(),
        '/gemini': (context) => const GeminiImageTasksScreen(),
      },

      initialRoute: '/',
    );
  }
}
