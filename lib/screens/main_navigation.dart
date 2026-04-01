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

  late final List<Widget> screens;

  @override
  void initState() {
    super.initState();

    // 🔥 PASS FUNCTION TO SCREENS THAT NEED BACK CONTROL
    screens = [
      HomeScreen(),
      LostScreen(onBackToHome: () => changeTab(0)), // ✅ FIXED
      HealthScreen(),
      VetScreen(),
      ProfileScreen(),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      // 🔥 HANDLE PHONE BACK BUTTON
      onWillPop: () async {
        if (currentIndex != 0) {
          changeTab(0); // go to Home tab
          return false;
        }
        return false; // prevent app exit
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
              icon: Icon(Icons.home),
              label: "Home",
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.search),
              label: "Lost",
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.favorite),
              label: "Health",
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.local_hospital),
              label: "Vets",
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.person),
              label: "Profile",
            ),
          ],
        ),
      ),
    );
  }
}