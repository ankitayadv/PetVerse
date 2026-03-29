import 'package:flutter/material.dart';
import 'routes/app_routes.dart';

void main() {
  runApp(const PetVerseApp());
}

class PetVerseApp extends StatelessWidget {
  const PetVerseApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'PetVerse',

      theme: ThemeData(
        useMaterial3: true,
        fontFamily: 'Poppins',
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.orange),
      ),

      // 🔥 Start from Splash
      initialRoute: AppRoutes.splash,

      // 🔥 All navigation handled here
      onGenerateRoute: AppRoutes.generateRoute,
    );
  }
}