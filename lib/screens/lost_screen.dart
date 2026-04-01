import 'dart:async';
import 'package:flutter/material.dart';
import '../routes/app_routes.dart';

class LostScreen extends StatefulWidget {
  final VoidCallback onBackToHome; // ✅ ADDED

  const LostScreen({super.key, required this.onBackToHome}); // ✅ UPDATED

  @override
  State<LostScreen> createState() => _LostScreenState();
}

class _LostScreenState extends State<LostScreen> {
  final PageController _pageController = PageController();
  int _currentPage = 0;
  late Timer _timer;

  final List<Map<String, String>> _helpSteps = [
    {"title": "Step 1: Report Pet 🐾", "desc": "Add pet details, photo & last seen location."},
    {"title": "Step 2: Alert Nearby 📍", "desc": "Nearby users are notified instantly."},
    {"title": "Step 3: Sightings 👀", "desc": "People report sightings of your pet."},
    {"title": "Step 4: Smart Match 🧠", "desc": "We match lost & found pets automatically."},
    {"title": "Step 5: Reunite ❤️", "desc": "Connect and bring your pet home safely."},
  ];

  @override
  void initState() {
    super.initState();

    _timer = Timer.periodic(const Duration(seconds: 5), (timer) {
      _currentPage = (_currentPage + 1) % _helpSteps.length;

      if (_pageController.hasClients) {
        _pageController.animateToPage(
          _currentPage,
          duration: const Duration(milliseconds: 700),
          curve: Curves.easeInOut,
        );
      }
    });
  }

  @override
  void dispose() {
    _timer.cancel();
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFFF9F5),

      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, color: Colors.orange),
          onPressed: widget.onBackToHome, // ✅ FIXED (ONLY CHANGE)
        ),
        centerTitle: true,
        title: const Text(
          "Lost & Found Center",
          style: TextStyle(
            color: Colors.brown,
            fontWeight: FontWeight.bold,
            fontSize: 18,
          ),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),

      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [

            const SizedBox(height: 10),

            SizedBox(
              height: 140,
              child: PageView.builder(
                controller: _pageController,
                itemCount: _helpSteps.length,
                onPageChanged: (index) => setState(() => _currentPage = index),
                itemBuilder: (context, index) {
                  return Container(
                    margin: const EdgeInsets.symmetric(horizontal: 5, vertical: 5),
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(color: Colors.orange.withOpacity(0.2)),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.orange.withOpacity(0.08),
                          blurRadius: 12,
                          offset: const Offset(0, 5),
                        ),
                      ],
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          _helpSteps[index]['title']!,
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.orange,
                            fontSize: 18,
                          ),
                        ),
                        const SizedBox(height: 10),
                        Text(
                          _helpSteps[index]['desc']!,
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                            color: Colors.brown,
                            fontSize: 14,
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),

            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(
                _helpSteps.length,
                (index) => Container(
                  margin: const EdgeInsets.only(top: 10, right: 5),
                  height: 6,
                  width: _currentPage == index ? 16 : 6,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(3),
                    color: _currentPage == index
                        ? Colors.orange
                        : Colors.orange.withOpacity(0.3),
                  ),
                ),
              ),
            ),

            const SizedBox(height: 30),

            const Text(
              "Report A New Case",
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 20),

            Row(
              children: [
                Expanded(
                  child: _reportButton(
                    label: "LOST\nMY PET",
                    icon: Icons.search_rounded,
                    color: Colors.red.shade400,
                    onTap: () {
                      Navigator.pushNamed(context, AppRoutes.reportLost);
                    },
                  ),
                ),
                const SizedBox(width: 15),
                Expanded(
                  child: _reportButton(
                    label: "FOUND\nA PET",
                    icon: Icons.handshake_outlined,
                    color: Colors.green.shade500,
                    onTap: () {
                      Navigator.pushNamed(context, AppRoutes.reportFound);
                    },
                  ),
                ),
              ],
            ),

            const SizedBox(height: 35),

            const Text(
              "Quick Actions",
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 15),

            _quickActionTile(
              icon: Icons.grid_view_rounded,
              title: "View Nearby Pets 📍",
              subtitle: "See lost & found pets near you",
              onTap: () {
                Navigator.pushNamed(context, AppRoutes.nearbyPets);
              },
            ),

            _quickActionTile(
              icon: Icons.map_rounded,
              title: "View on Map 🗺️",
              subtitle: "Locate pets visually on map",
              onTap: () {
                Navigator.pushNamed(context, AppRoutes.mapView);
              },
            ),

            _quickActionTile(
              icon: Icons.folder_open_rounded,
              title: "Your Reports",
              subtitle: "Manage pets you reported",
              onTap: () {},
            ),

            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  Widget _reportButton({
    required String label,
    required IconData icon,
    required Color color,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(20),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 25),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: color.withOpacity(0.5), width: 1.5),
          boxShadow: [
            BoxShadow(
              color: color.withOpacity(0.12),
              blurRadius: 10,
              offset: const Offset(0, 5),
            ),
          ],
        ),
        child: Column(
          children: [
            Icon(icon, size: 45, color: color),
            const SizedBox(height: 10),
            Text(
              label,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontWeight: FontWeight.w900,
                fontSize: 16,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _quickActionTile({
    required IconData icon,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(15),
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: const Color(0xFFFFEBD8),
            borderRadius: BorderRadius.circular(15),
          ),
          child: Row(
            children: [
              Icon(icon, color: Colors.orange.shade800, size: 30),
              const SizedBox(width: 15),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 15,
                      ),
                    ),
                    Text(
                      subtitle,
                      style: TextStyle(
                        color: Colors.brown.shade400,
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ),
              const Icon(
                Icons.arrow_forward_ios_rounded,
                size: 16,
                color: Colors.brown,
              ),
            ],
          ),
        ),
      ),
    );
  }
}