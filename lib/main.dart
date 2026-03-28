import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart'; // ✅ ADD THIS

import 'screens/splash_screen.dart';
import 'screens/onboarding_screen.dart';
import 'screens/login_screen.dart';
import 'screens/signup_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized(); // 
  await Firebase.initializeApp(); // 

  runApp(const PetVerseApp());
}

class PetVerseApp extends StatelessWidget {
  const PetVerseApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'PetVerse',
      initialRoute: '/',
      theme: ThemeData(fontFamily: 'Poppins'),
      routes: {
        '/': (context) => const SplashScreen(),
        '/onboarding': (context) => const OnboardingScreen(),
        '/login': (context) => const LoginScreen(),
        '/signup': (context) => const SignUpScreen(),
      },
    );
  }
}