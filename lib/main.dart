import 'package:flutter/material.dart';
import 'routes/app_routes.dart';
import 'package:firebase_core/firebase_core.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // 🔥 SAFE FIREBASE INIT
  try {
    await Firebase.initializeApp();
  } catch (e) {
    debugPrint("Firebase init error: $e");
  }

  runApp(const PetVerseApp());
}

class PetVerseApp extends StatelessWidget {
  const PetVerseApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'PetVerse',

      // 🔥 GLOBAL THEME
      theme: ThemeData(
        useMaterial3: true,

        fontFamily: 'Poppins',

        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.orange,
        ),

        scaffoldBackgroundColor: Colors.white,
      ),

      // 🔥 START ROUTE
      initialRoute: AppRoutes.splash,

      // 🔥 CENTRAL ROUTING SYSTEM
      onGenerateRoute: AppRoutes.generateRoute,

      // 🔥 OPTIONAL (for debugging layouts)
      debugShowMaterialGrid: false,
    );
  }
}