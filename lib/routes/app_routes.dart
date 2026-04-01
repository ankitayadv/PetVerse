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

// 🔥 FEATURE SCREENS
import '../screens/emergency_screen.dart';
import '../screens/nearby_lost_found_screen.dart';
import '../screens/booking_screen.dart';
import '../screens/routine_screen.dart';
import '../screens/vaccine_screen.dart';
import '../screens/pet_care_screen.dart';

// 🔥 LOST MODULE
import '../screens/report_lost_screen.dart';
import '../screens/report_found_screen.dart';
import '../screens/map_view_screen.dart';

// 🔥 PET CARE MODULE
import '../screens/petcare_feeding_screen.dart';
import '../screens/petcare_feeding_bestfood_page.dart';
import '../screens/petcare_training_screen.dart';
import '../screens/petcare_training_article_screen.dart';
import '../screens/petcare_training_final_screen.dart';

// 🔥 PROFILE + SETTINGS
import '../screens/settings_screen.dart';
import '../screens/edit_pet_profile_screen.dart';
import '../screens/edit_owner_profile_screen.dart';
import '../screens/privacy_security_screen.dart';
import '../screens/reminders_alerts_screen.dart';

// 🔥 EXTRA FEATURES
import '../screens/vets_book_appointments_screen.dart';
import '../screens/behavioral_assessment_screen.dart';
import '../screens/vocal_mood_analysis_screen.dart';
import '../screens/dermatological_scan_screen.dart';

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

  // 🔥 HOME FEATURES
  static const String emergency = '/emergency';
  static const String lost = '/lost';
  static const String booking = '/booking';
  static const String routine = '/routine';
  static const String petCare = '/petcare';
  static const String vaccine = '/vaccine';

  // 🔥 LOST MODULE
  static const String nearbyPets = '/nearbyPets';
  static const String reportLost = '/reportLost';
  static const String reportFound = '/reportFound';
  static const String mapView = '/mapView';

  // 🔥 PET CARE MODULE
  static const String feeding = '/feeding';
  static const String bestFood = '/bestFood';
  static const String training = '/training';
  static const String trainingArticle = '/trainingArticle';
  static const String trainingFinal = '/trainingFinal';

  // 🔥 PROFILE / SETTINGS
  static const String settingsPage = '/settings';
  static const String editPet = '/editPet';
  static const String editOwner = '/editOwner';
  static const String privacy = '/privacy';
  static const String reminders = '/reminders';

  // 🔥 EXTRA FEATURES
  static const String vetBooking = '/vetBooking';
  static const String behavior = '/behavior';
  static const String vocal = '/vocal';
  static const String skin = '/skin';

  // 🔥 ROUTE GENERATOR
  static Route<dynamic> generateRoute(RouteSettings routeSettings) {
    switch (routeSettings.name) {

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
        final args = routeSettings.arguments as List<Map<String, String>>?;
        return MaterialPageRoute(
          builder: (_) => const StepFiveScreen(),
          settings: RouteSettings(arguments: args),
        );

      // 🔹 MAIN APP ENTRY
      case home:
        return MaterialPageRoute(
          builder: (_) => const MainNavigation(),
        );

      // 🔹 CORE FEATURES
      case emergency:
        return MaterialPageRoute(builder: (_) => const EmergencyScreen());

      case lost:
      case nearbyPets:
        return MaterialPageRoute(builder: (_) => const NearbyLostFoundScreen());

      case booking:
        return MaterialPageRoute(builder: (_) => const BookingScreen());

      case routine:
        return MaterialPageRoute(builder: (_) => const RoutineScreen());

      case petCare:
        return MaterialPageRoute(builder: (_) => const PetCareScreen());

      case vaccine:
        return MaterialPageRoute(builder: (_) => const VaccineScreen());

      // 🔹 LOST FLOW
      case reportLost:
        return MaterialPageRoute(builder: (_) => const ReportLostScreen());

      case reportFound:
        return MaterialPageRoute(builder: (_) => const ReportFoundScreen());

      case mapView:
        return MaterialPageRoute(builder: (_) => const MapViewScreen());

      // 🔹 PET CARE FLOW
      case feeding:
        return MaterialPageRoute(builder: (_) => const PetcareFeedingScreen());

      case bestFood:
        return MaterialPageRoute(builder: (_) => const PetcareFeedingBestfoodPage());

      case training:
        return MaterialPageRoute(builder: (_) => const PetcareTrainingScreen());

      case trainingArticle:
        return MaterialPageRoute(builder: (_) => const PetcareTrainingArticleScreen());

      case trainingFinal:
        return MaterialPageRoute(builder: (_) => const PetcareTrainingFinalScreen());

      // 🔹 SETTINGS
      case settingsPage:
        return MaterialPageRoute(builder: (_) => const SettingsScreen());

      case editPet:
        return MaterialPageRoute(builder: (_) => const EditPetProfileScreen());

      case editOwner:
        return MaterialPageRoute(builder: (_) => const EditOwnerProfileScreen());

      case privacy:
        return MaterialPageRoute(builder: (_) => const PrivacySecurityScreen());

      case reminders:
        return MaterialPageRoute(builder: (_) => const RemindersAlertsScreen());

      // 🔹 EXTRA FEATURES
      case vetBooking:
        return MaterialPageRoute(builder: (_) => const VetsBookAppointmentsScreen());

      case behavior:
        return MaterialPageRoute(builder: (_) => const BehavioralAssessmentScreen());

      case vocal:
        return MaterialPageRoute(builder: (_) => const VocalMoodAnalysisScreen());

      case skin:
        return MaterialPageRoute(builder: (_) => const DermatologicalScanScreen());

      // ✅ FIXED DEFAULT (IMPORTANT)
      default:
        return MaterialPageRoute(
          builder: (_) => const OnboardingScreen(),
        );
    }
  }
}