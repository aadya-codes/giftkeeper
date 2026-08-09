import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';

import 'models/person.dart';
import 'models/gift_idea.dart';
import 'screens/home_screen.dart';
import 'services/notification_service.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Hive.initFlutter();

  Hive.registerAdapter(PersonAdapter());
  Hive.registerAdapter(GiftIdeaAdapter());

  await Hive.openBox<Person>("people");

  runApp(const GiftKeeperApp());

  // Run this AFTER runApp so a failure here (missing permission, no
  // timezone data, etc.) can never leave the user stuck on a black
  // screen — the UI is already up regardless of what happens here.
  try {
    await NotificationService.initialize();
  } catch (e) {
    debugPrint("Notification setup failed: $e");
  }
}

class GiftKeeperApp extends StatelessWidget {
  const GiftKeeperApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "GiftKeeper",
      debugShowCheckedModeBanner: false,

      themeMode: ThemeMode.light,

      theme: ThemeData(
        useMaterial3: true,

        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF7C6AE6),
          brightness: Brightness.light,
        ),

        scaffoldBackgroundColor: const Color(0xFFF7F8FC),

        appBarTheme: const AppBarTheme(
          centerTitle: true,
          elevation: 0,
          backgroundColor: Colors.transparent,
          foregroundColor: Color(0xFF2D3142),
          titleTextStyle: TextStyle(
            fontSize: 28,
            fontWeight: FontWeight.bold,
            color: Color(0xFF2D3142),
          ),
        ),

        cardTheme: CardThemeData(
          elevation: 0,
          color: Colors.white,
          margin: const EdgeInsets.symmetric(
            horizontal: 2,
            vertical: 6,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(22),
          ),
        ),

        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            elevation: 0,
            padding: const EdgeInsets.symmetric(
              vertical: 16,
              horizontal: 20,
            ),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(18),
            ),
          ),
        ),

        floatingActionButtonTheme: const FloatingActionButtonThemeData(
          elevation: 1,
          shape: StadiumBorder(),
        ),

        snackBarTheme: SnackBarThemeData(
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
        ),

        inputDecorationTheme: InputDecorationTheme(
          filled: true,
          fillColor: Colors.white,
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 18,
            vertical: 16,
          ),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(18),
            borderSide: BorderSide.none,
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(18),
            borderSide: BorderSide.none,
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(18),
            borderSide: const BorderSide(
              color: Color(0xFF7C6AE6),
              width: 2,
            ),
          ),
        ),

        dividerTheme: const DividerThemeData(
          space: 32,
        ),
      ),

      home: const HomeScreen(),
    );
  }
}