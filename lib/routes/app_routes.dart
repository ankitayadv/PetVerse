import 'package:flutter/material.dart';

// 🔥 Import all screens
import '../screens/splash_screen.dart';
import '../screens/onboarding_screen.dart';
import '../screens/login_screen.dart';
import '../screens/signup_screen.dart';
import '../screens/step_one_screen.dart';
import '../screens/step_two_screen.dart';
import '../screens/step_three_screen.dart';
import '../screens/step_four_screen.dart';
import '../screens/step_five_screen.dart';

// ✅ IMPORTANT: import MainNavigation (NOT HomeScreen)
import '../screens/main_navigation.dart';

class AppRoutes {
  // 🔥 Route names
  static const String splash = '/splash';
  static const String onboarding = '/onboarding';
  static const String login = '/login';
  static const String signup = '/signup';
  static const String stepOne = '/stepone';
  static const String stepTwo = '/steptwo';
  static const String stepThree = '/stepthree';
  static const String stepFour = '/stepfour';
  static const String stepFive = '/stepfive';
  static const String home = '/home';

  // 🔥 Route generator
  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {

      case splash:
        return MaterialPageRoute(builder: (_) => const SplashScreen());

      case onboarding:
        return MaterialPageRoute(builder: (_) => const OnboardingScreen());

      case login:
        return MaterialPageRoute(builder: (_) => const LoginScreen());

      case signup:
        return MaterialPageRoute(builder: (_) => const SignUpScreen());

      case stepOne:
        return MaterialPageRoute(builder: (_) => const StepOneScreen());

      case stepTwo:
        return MaterialPageRoute(builder: (_) => const StepTwoScreen());

      case stepThree:
        return MaterialPageRoute(builder: (_) => const StepThreeScreen());

      case stepFour:
        return MaterialPageRoute(builder: (_) => const StepFourScreen());

      case stepFive:
        final args = settings.arguments as List<Map<String, String>>?;
        return MaterialPageRoute(
          builder: (_) => const StepFiveScreen(),
          settings: RouteSettings(arguments: args),
        );

      // ✅ FIXED: Home should open MainNavigation
      case home:
        final selectedPet = settings.arguments as Map<String, String>?;
        return MaterialPageRoute(
          builder: (_) => const MainNavigation(),
          settings: RouteSettings(arguments: selectedPet),
        );

      default:
        return MaterialPageRoute(
          builder: (_) => const Scaffold(
            body: Center(child: Text("Route not found")),
          ),
        );
    }
  }
}