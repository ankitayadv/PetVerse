import 'package:flutter/material.dart';

import 'home_screen.dart';
import 'lost_screen.dart';
import 'health_screen.dart';
import 'vet_screen.dart';
import 'profile_screen.dart';

class MainNavigation extends StatefulWidget {
  const MainNavigation({super.key});

  @override
  State<MainNavigation> createState() => _MainNavigationState();
}

class _MainNavigationState extends State<MainNavigation> {
  int currentIndex = 0;

  // 🔥 METHOD TO CHANGE TAB FROM CHILD SCREENS
  void changeTab(int index) {
    setState(() {
      currentIndex = index;
    });
  }

  // 🔥 GLOBAL STATE (from your friend's code)
  Map<String, dynamic>? selectedPet;
  List<Map<String, dynamic>> allPets = [];

  String? ownerName;
  dynamic ownerImage;
  String? ownerLocation;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    final args =
        ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>?;

    if (selectedPet == null) {
      if (args != null && args.containsKey('selectedPet')) {
        // ✅ FROM ONBOARDING / PROFILE
        selectedPet = args['selectedPet'];
        allPets = List<Map<String, dynamic>>.from(args['allPets'] ?? []);

        ownerName = args['ownerName'] ?? "User";
        ownerImage = args['ownerImage'];
        ownerLocation = args['ownerLocation'] ?? "Not Set";
      } else {
        // ✅ FALLBACK (NO CRASH)
        selectedPet = {
          "name": "Buddy",
          "breed": "Golden Retriever",
        };
        allPets = [selectedPet!];

        ownerName = "Pet Lover";
        ownerLocation = "Location not set";
      }
    }
  }

  // 🔥 PET SWITCH HANDLER
  void updatePet(Map<String, dynamic> newPet) {
    setState(() {
      selectedPet = newPet;
    });
  }

  @override
  Widget build(BuildContext context) {
    // 🔥 LOADING SAFE (NO BLANK SCREEN)
    if (selectedPet == null) {
      return const Scaffold(
        body: Center(
          child: CircularProgressIndicator(color: Colors.orange),
        ),
      );
    }

    final List<Widget> screens = [
      HomeScreen(
        selectedPet: selectedPet!,
        allPets: allPets,
        onPetSwitched: updatePet,
        ownerName: ownerName ?? "User",
        ownerImage: ownerImage,
        ownerLocation: ownerLocation ?? "Not Set",
      ),

      // ✅ YOUR BACK FIX PRESERVED
      LostScreen(onBackToHome: () => changeTab(0)),

      const HealthScreen(),
      const VetScreen(),

      ProfileScreen(
        ownerName: ownerName ?? "User",
        ownerImage: ownerImage,
        ownerLocation: ownerLocation ?? "Not Set",
        selectedPet: selectedPet!,
      ),
    ];

    return WillPopScope(
      // 🔥 YOUR BACK BUTTON LOGIC PRESERVED
      onWillPop: () async {
        if (currentIndex != 0) {
          changeTab(0);
          return false;
        }
        return false;
      },
      child: Scaffold(
        body: IndexedStack(
          index: currentIndex,
          children: screens,
        ),
        bottomNavigationBar: BottomNavigationBar(
          currentIndex: currentIndex,
          onTap: changeTab,
          type: BottomNavigationBarType.fixed,
          selectedItemColor: Colors.orange,
          unselectedItemColor: Colors.grey,
          showUnselectedLabels: true,
          items: const [
            BottomNavigationBarItem(
                icon: Icon(Icons.home), label: "Home"),
            BottomNavigationBarItem(
                icon: Icon(Icons.search), label: "Lost"),
            BottomNavigationBarItem(
                icon: Icon(Icons.favorite), label: "Health"),
            BottomNavigationBarItem(
                icon: Icon(Icons.local_hospital), label: "Vets"),
            BottomNavigationBarItem(
                icon: Icon(Icons.person), label: "Profile"),
          ],
        ),
      ),
    );
  }
}