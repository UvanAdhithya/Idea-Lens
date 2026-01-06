import 'package:flutter/material.dart';
import 'screens/home_screen.dart';
import 'screens/gemini_image_tasks_screen.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'screens/history_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';



Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await dotenv.load(fileName: ".env");



// 🔥 Initialize Firebase
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  await FirebaseAuth.instance.signInAnonymously();
  print("USER UID: ${FirebaseAuth.instance.currentUser?.uid}");

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
        '/history': (context) => const HistoryScreen(),
      },

      initialRoute: '/',
    );
  }
}
