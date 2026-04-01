import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';

class MapViewScreen extends StatefulWidget {
  const MapViewScreen({super.key});

  @override
  State<MapViewScreen> createState() => _MapViewScreenState();
}

class _MapViewScreenState extends State<MapViewScreen> {
  String locationText = "Fetching location...";
  bool isLoading = true;

  // 🔥 Dummy data (Backend-ready structure)
  final List<Map<String, dynamic>> pets = [
    {
      "name": "Bruno",
      "type": "Lost",
      "distance": "0.5 km",
    },
    {
      "name": "Lucy",
      "type": "Found",
      "distance": "1.2 km",
    },
  ];

  @override
  void initState() {
    super.initState();
    _getLocation();
  }

  // 🔥 Get current location
  Future<void> _getLocation() async {
    try {
      bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        setState(() {
          locationText = "Location services disabled";
          isLoading = false;
        });
        return;
      }

      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
      }

      Position position = await Geolocator.getCurrentPosition();

      setState(() {
        locationText =
            "Lat: ${position.latitude.toStringAsFixed(4)}, Lng: ${position.longitude.toStringAsFixed(4)}";
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        locationText = "Unable to fetch location";
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,

      // 🔥 APP BAR
      appBar: AppBar(
        title: const Text("Pet Map"),
        centerTitle: true,
      ),

      body: Stack(
        children: [

          // 🔥 MAP PLACEHOLDER (Replace later with Google Map)
          Container(
            width: double.infinity,
            height: double.infinity,
            color: Colors.orange.shade50,
            child: const Center(
              child: Text(
                "Map View (Google Maps Coming Soon)",
                style: TextStyle(color: Colors.grey),
              ),
            ),
          ),

          // 🔥 TOP SEARCH BAR
          Positioned(
            top: 15,
            left: 16,
            right: 16,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 15),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(30),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.08),
                    blurRadius: 10,
                  )
                ],
              ),
              child: const TextField(
                decoration: InputDecoration(
                  icon: Icon(Icons.search),
                  hintText: "Search pets, locations...",
                  border: InputBorder.none,
                ),
              ),
            ),
          ),

          // 🔥 LOCATION CARD
          Positioned(
            top: 80,
            left: 16,
            right: 16,
            child: Container(
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(15),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.05),
                    blurRadius: 8,
                  )
                ],
              ),
              child: Row(
                children: [
                  const Icon(Icons.location_on, color: Colors.orange),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      isLoading ? "Fetching location..." : locationText,
                      style: const TextStyle(fontSize: 13),
                    ),
                  ),
                ],
              ),
            ),
          ),

          // 🔥 FLOATING BUTTONS
          Positioned(
            bottom: 120,
            right: 16,
            child: Column(
              children: [
                _floatingButton(Icons.my_location, "Locate", _getLocation),
                const SizedBox(height: 10),
                _floatingButton(Icons.filter_list, "Filter", () {}),
              ],
            ),
          ),

          // 🔥 BOTTOM PET LIST (Backend ready)
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Container(
              height: 130,
              padding: const EdgeInsets.all(12),
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.vertical(top: Radius.circular(25)),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black12,
                    blurRadius: 10,
                  )
                ],
              ),
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: pets.length,
                itemBuilder: (context, index) {
                  final pet = pets[index];
                  return _petCard(pet);
                },
              ),
            ),
          ),
        ],
      ),
    );
  }

  // 🔥 FLOAT BUTTON
  Widget _floatingButton(IconData icon, String label, VoidCallback onTap) {
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Colors.white,
          shape: BoxShape.circle,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 8,
            )
          ],
        ),
        child: Icon(icon, color: Colors.orange),
      ),
    );
  }

  // 🔥 PET CARD (Backend Ready)
  Widget _petCard(Map<String, dynamic> pet) {
    return Container(
      width: 160,
      margin: const EdgeInsets.only(right: 12),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.orange.shade50,
        borderRadius: BorderRadius.circular(15),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            pet['name'],
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
          Text(pet['type']),
          const Spacer(),
          Text(pet['distance'], style: const TextStyle(fontSize: 12)),
        ],
      ),
    );
  }
}
