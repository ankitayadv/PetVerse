import 'dart:async';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';

import '../routes/app_routes.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String location = "Fetching...";
  String userName = "Ankita";

  final PageController _infoController = PageController();
  int _infoIndex = 0;

  @override
  void initState() {
    super.initState();
    _getLocation();

    Timer.periodic(const Duration(seconds: 5), (timer) {
      if (_infoController.hasClients) {
        _infoIndex = (_infoIndex + 1) % infoCards.length;
        _infoController.animateToPage(
          _infoIndex,
          duration: const Duration(milliseconds: 400),
          curve: Curves.easeInOut,
        );
      }
    });
  }

  Future<void> _getLocation() async {
    try {
      LocationPermission permission = await Geolocator.requestPermission();
      Position pos = await Geolocator.getCurrentPosition();

      List<Placemark> placemarks =
          await placemarkFromCoordinates(pos.latitude, pos.longitude);

      setState(() {
        location = placemarks.first.locality ?? "Your City";
      });
    } catch (e) {
      location = "Location";
    }
  }

  String getGreeting() {
    final hour = DateTime.now().hour;
    if (hour >= 5 && hour < 12) return "Good Morning";
    if (hour >= 12 && hour < 17) return "Good Afternoon";
    return "Good Evening";
  }

  final List<Map<String, String>> infoCards = [
    {
      "text": "Stay on top of your pet’s health 🐾",
      "image": "assets/images/onboarding_page2.png"
    },
    {
      "text": "Never miss vaccines & routines 💉",
      "image": "assets/images/onboarding_page2.png"
    },
    {
      "text": "Keep your pet happy & active 🐶",
      "image": "assets/images/onboarding_page2.png"
    },
  ];

  List<Map<String, dynamic>> notifications = [
    {
      "title": "Morning Feeding",
      "time": DateTime.now(),
      "done": false,
      "type": "routine"
    },
    {
      "title": "Rabies Vaccine",
      "time": DateTime.now().add(const Duration(days: 2)),
      "done": false,
      "type": "vaccine"
    },
    {
      "title": "Vet Appointment",
      "time": DateTime.now().add(const Duration(hours: 5)),
      "done": false,
      "type": "vet"
    },
  ];

  // ✅ ONLY CHANGE HERE
  String formatTime(DateTime t, String type) {
    if (type == "vaccine" || type == "vet") {
      return DateFormat('dd MMM').format(t); // show date
    }
    return DateFormat('hh:mm a').format(t); // keep time
  }

  Color getColor(String type) {
    switch (type) {
      case "routine":
        return Colors.blueAccent.withOpacity(0.15);
      case "vaccine":
        return Colors.purpleAccent.withOpacity(0.15);
      case "vet":
        return Colors.orangeAccent.withOpacity(0.15);
      default:
        return Colors.grey.withOpacity(0.1);
    }
  }

  String getImage(String type) {
    switch (type) {
      case "routine":
        return "assets/images/routine_logo.png";
      case "vaccine":
        return "assets/images/vaccine_logo.png";
      case "vet":
        return "assets/images/booking_logo.png";
      default:
        return "assets/images/routine_logo.png";
    }
  }

  @override
  Widget build(BuildContext context) {
    final active = notifications.where((e) => e["done"] == false).toList();

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [

              // 🔥 HEADER
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("Welcome back, $userName"),
                      const SizedBox(height: 4),
                      Text(
                        getGreeting(),
                        style: const TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  const Icon(Icons.home, color: Colors.orange),
                ],
              ),

              const SizedBox(height: 6),

              Row(
                children: [
                  const Icon(Icons.location_on,
                      size: 16, color: Colors.orange),
                  const SizedBox(width: 4),
                  Text(location),
                ],
              ),

              const SizedBox(height: 20),

              // 🔥 PROFILE CARD
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: const Color(0xFFFFF2E6),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(
                    color: Colors.orange.withOpacity(0.25),
                    width: 1.2,
                  ),
                ),
                child: Row(
                  children: [
                    Container(
                      height: 60,
                      width: 60,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(
                            color: Colors.orange.withOpacity(0.4)),
                        image: const DecorationImage(
                          image: AssetImage(
                              "assets/images/pet_profile.png"),
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                    const SizedBox(width: 10),
                    const Expanded(
                      child: Text(
                        "Bruno • Labrador",
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 12, vertical: 6),
                      decoration: BoxDecoration(
                        color: Colors.orange.withOpacity(0.2),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: const Text("Switch",
                          style: TextStyle(color: Colors.orange)),
                    )
                  ],
                ),
              ),

              const SizedBox(height: 20),

              // 🔥 INFO CARDS
              SizedBox(
                height: 110,
                child: PageView.builder(
                  controller: _infoController,
                  itemCount: infoCards.length,
                  itemBuilder: (_, i) {
                    return Container(
                      margin: const EdgeInsets.symmetric(horizontal: 2),
                      padding: const EdgeInsets.all(14),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(18),
                        gradient: const LinearGradient(
                          colors: [Color(0xFFFFF8F2), Color(0xFFFFEAD7)],
                        ),
                        border: Border.all(
                          color: Colors.orange.withOpacity(0.2),
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.orange.withOpacity(0.15),
                            blurRadius: 12,
                            offset: const Offset(0, 6),
                          )
                        ],
                      ),
                      child: Row(
                        children: [
                          Image.asset(infoCards[i]["image"]!, height: 65),
                          const SizedBox(width: 10),
                          Expanded(child: Text(infoCards[i]["text"]!)),
                        ],
                      ),
                    );
                  },
                ),
              ),

              const SizedBox(height: 20),

              // 🔥 GRID + NOTIFICATIONS UNCHANGED
              GridView.count(
                shrinkWrap: true,
                crossAxisCount: 3,
                crossAxisSpacing: 12,
                mainAxisSpacing: 12,
                physics: const NeverScrollableScrollPhysics(),
                children: [
                  _card("Emergency", "assets/images/emergency_logo.png", AppRoutes.emergency, Colors.orange),
                  _card("Nearby Lost", "assets/images/nearby_lost_and_found_logo.png", AppRoutes.lost, Colors.yellow),
                  _card("Bookings", "assets/images/booking_logo.png", AppRoutes.booking, Colors.teal),
                  _card("Routine", "assets/images/routine_logo.png", AppRoutes.routine, Colors.blue),
                  _card("Vaccine", "assets/images/vaccine_logo.png", AppRoutes.vaccine, Colors.green),
                  _card("Pet Care", "assets/images/petcare_logo.png", AppRoutes.petCare, Colors.purple),
                ],
              ),

              const SizedBox(height: 20),

              const Text("Today’s Upcoming Tasks",
                  style: TextStyle(fontWeight: FontWeight.bold)),

              const SizedBox(height: 10),

              Column(
                children: active.map((item) {
                  return Container(
                    margin: const EdgeInsets.only(bottom: 12),
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: getColor(item["type"]),
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: const [
                        BoxShadow(
                          color: Colors.black12,
                          blurRadius: 6,
                          offset: Offset(0, 3),
                        )
                      ],
                    ),
                    child: Row(
                      children: [
                        Image.asset(getImage(item["type"]), height: 30),
                        const SizedBox(width: 10),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(item["title"]),
                              Text(formatTime(item["time"], item["type"])),
                            ],
                          ),
                        ),
                        GestureDetector(
                          onTap: () {
                            setState(() {
                              item["done"] = !item["done"];
                            });
                          },
                          child: AnimatedContainer(
                            duration: const Duration(milliseconds: 200),
                            height: 24,
                            width: 24,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(8),
                              border: Border.all(
                                  color: Colors.orange, width: 2),
                              color: item["done"]
                                  ? Colors.orange
                                  : Colors.transparent,
                            ),
                            child: item["done"]
                                ? const Icon(Icons.check,
                                    size: 16, color: Colors.white)
                                : null,
                          ),
                        )
                      ],
                    ),
                  );
                }).toList(),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _card(String title, String image, String route, Color color) {
    return GestureDetector(
      onTap: () => Navigator.pushNamed(context, route),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: color.withOpacity(0.25),
              blurRadius: 12,
              offset: const Offset(0, 6),
            )
          ],
        ),
        child: Column(
          children: [
            Expanded(
              flex: 3,
              child: Container(
                decoration: BoxDecoration(
                  color: color.withOpacity(0.6),
                  borderRadius: const BorderRadius.vertical(
                    top: Radius.circular(20),
                  ),
                ),
                child: Center(
                  child: Image.asset(image, height: 55),
                ),
              ),
            ),
            Expanded(
              flex: 2,
              child: Container(
                width: double.infinity,
                decoration: const BoxDecoration(
                  color: Color(0xFFF5F5F5),
                  borderRadius: BorderRadius.vertical(
                    bottom: Radius.circular(20),
                  ),
                ),
                child: Center(
                  child: Text(title, textAlign: TextAlign.center),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}