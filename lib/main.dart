import 'package:flutter/material.dart';

// 🔥 Import your screens
import 'screens/home_screen.dart';
import 'screens/lost_screen.dart';
import 'screens/health_screen.dart';
import 'screens/vet_screen.dart';
import 'screens/profile_screen.dart';

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
        primarySwatch: Colors.orange,
      ),
      home: const MainNavigation(),
    );
  }
}

class MainNavigation extends StatefulWidget {
  const MainNavigation({super.key});

  @override
  State<MainNavigation> createState() => _MainNavigationState();
}

class _MainNavigationState extends State<MainNavigation> {
  int currentIndex = 0;

  final List<Widget> screens = const [
    HomeScreen(),
    LostScreen(),
    HealthScreen(),
    VetScreen(),
    ProfileScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: screens[currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: currentIndex,
        onTap: (index) {
          setState(() {
            currentIndex = index;
          });
        },
        type: BottomNavigationBarType.fixed,
        selectedItemColor: Colors.orange,
        unselectedItemColor: Colors.grey,
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
    );
  }
}