import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'services/reward_service.dart';
import 'services/session_service.dart';

import 'screens/home_screen.dart';
import 'models/project_history.dart';
import 'models/project_history_adapter.dart';
import 'models/project_session_adapter.dart';

Future<void> main() async {
  try {
    print('🚀 App Starting...');
    WidgetsFlutterBinding.ensureInitialized();
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
    
    print('📦 Loading .env...');
    await dotenv.load(fileName: ".env");
    
    print('🐝 Initializing Hive...');
    await Hive.initFlutter();

    print('🖇️ Registering Adapters...');
    Hive.registerAdapter(ProjectHistoryAdapter());
    Hive.registerAdapter(ProjectSessionAdapter());

    print('🎁 Initializing Services...');
    await RewardService.init();
    await SessionService.init();
    
    print('📂 Opening History Box...');
    try {
      await Hive.openBox<ProjectHistory>('historyBox');
    } catch (e) {
      print('⚠️ Error opening historyBox: $e. Attempting reset...');
      try {
        await Hive.deleteBoxFromDisk('historyBox');
      } catch (deleteError) {
        print('ℹ️ Note: Could not delete historyBox files: $deleteError');
      }
      await Hive.openBox<ProjectHistory>('historyBox');
    }

    print('🎬 Starting App...');
    runApp(const MyApp());
  } catch (e, stack) {
    print('❌ FATAL STARTUP ERROR: $e');
    print(stack);
    // Optionally run a simple error app to show the user
    runApp(MaterialApp(
      home: Scaffold(
        body: Center(
          child: SelectableText('Fatal Startup Error:\n$e'),
        ),
      ),
    ));
  }
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

      // ✅ ONLY HomeScreen is a named route
      routes: {
        '/': (context) => const HomeScreen(),
      },

      initialRoute: '/',
    );
  }
}
