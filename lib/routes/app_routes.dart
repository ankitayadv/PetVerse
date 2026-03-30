import 'package:flutter/material.dart';

// 🔥 AUTH + ONBOARDING
import '../screens/splash_screen.dart';
import '../screens/onboarding_screen.dart';
import '../screens/login_screen.dart';
import '../screens/signup_screen.dart';
import '../screens/step_one_screen.dart';
import '../screens/step_two_screen.dart';
import '../screens/step_three_screen.dart';
import '../screens/step_four_screen.dart';
import '../screens/step_five_screen.dart';

// 🔥 MAIN NAVIGATION
import '../screens/main_navigation.dart';

// 🔥 NEW FEATURE SCREENS
import '../screens/emergency_screen.dart';
import '../screens/nearby_lost_found_screen.dart';
import '../screens/booking_screen.dart';
import '../screens/routine_screen.dart';
import '../screens/vaccine_screen.dart';
import '../screens/pet_care_screen.dart';

class AppRoutes {
  // 🔥 AUTH FLOW
  static const String splash = '/splash';
  static const String onboarding = '/onboarding';
  static const String login = '/login';
  static const String signup = '/signup';

  // 🔥 ONBOARDING STEPS
  static const String stepOne = '/stepone';
  static const String stepTwo = '/steptwo';
  static const String stepThree = '/stepthree';
  static const String stepFour = '/stepfour';
  static const String stepFive = '/stepfive';

  // 🔥 MAIN APP
  static const String home = '/home';

  // 🔥 HOME FEATURE ROUTES
  static const String emergency = '/emergency';
  static const String lost = '/lost';
  static const String booking = '/booking';
  static const String routine = '/routine';
  static const String petCare = '/petcare';
  static const String vaccine = '/vaccine';

  // 🔥 ROUTE GENERATOR
  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {

      // 🔹 AUTH FLOW
      case splash:
        return MaterialPageRoute(builder: (_) => const SplashScreen());

      case onboarding:
        return MaterialPageRoute(builder: (_) => const OnboardingScreen());

      case login:
        return MaterialPageRoute(builder: (_) => const LoginScreen());

      case signup:
        return MaterialPageRoute(builder: (_) => const SignUpScreen());

      // 🔹 ONBOARDING STEPS
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

      // 🔹 MAIN APP ENTRY
      case home:
        final selectedPet = settings.arguments as Map<String, String>?;
        return MaterialPageRoute(
          builder: (_) => const MainNavigation(),
          settings: RouteSettings(arguments: selectedPet),
        );

      // 🔹 FEATURE SCREENS (REAL ONES 🔥)

      case emergency:
        return MaterialPageRoute(
          builder: (_) => const EmergencyScreen(),
        );

      case lost:
        return MaterialPageRoute(
          builder: (_) => const NearbyLostFoundScreen(),
        );

      case booking:
        return MaterialPageRoute(
          builder: (_) => const BookingScreen(),
        );

      case routine:
        return MaterialPageRoute(
          builder: (_) => const RoutineScreen(),
        );

      case petCare:
        return MaterialPageRoute(
          builder: (_) => const PetCareScreen(),
        );

      case vaccine:
        return MaterialPageRoute(
          builder: (_) => const VaccineScreen(),
        );

      // ❌ DEFAULT
      default:
        return MaterialPageRoute(
          builder: (_) => const Scaffold(
            body: Center(child: Text("Route not found")),
          ),
        );
    }
  }
}