import 'dart:async';
import 'dart:io';
import 'dart:convert';
import 'dart:typed_data';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../routes/app_routes.dart';

class HomeScreen extends StatefulWidget {
  final Map<String, dynamic> selectedPet;
  final List<Map<String, dynamic>> allPets;
  final Function(Map<String, dynamic>) onPetSwitched;
  final String ownerName;
  final dynamic ownerImage;
  final String ownerLocation;

  const HomeScreen({
    super.key,
    required this.selectedPet,
    required this.allPets,
    required this.onPetSwitched,
    required this.ownerName,
    this.ownerImage,
    required this.ownerLocation,
  });

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String location = "Fetching...";
  final PageController _infoController = PageController();
  int _infoIndex = 0;
  Timer? _timer;
  StreamSubscription<Position>? _positionStream;

  // Firebase Real-time Data
  Map<String, dynamic>? _liveUserData;
  StreamSubscription<DocumentSnapshot>? _userSubscription;

  @override
  void initState() {
    super.initState();
    location = widget.ownerLocation.isNotEmpty ? widget.ownerLocation : "Fetching...";
    _initLocationService();
    _initFirebaseListener();

    _timer = Timer.periodic(const Duration(seconds: 5), (timer) {
      if (_infoController.hasClients && infoCards.isNotEmpty) {
        _infoIndex = (_infoIndex + 1) % infoCards.length;
        _infoController.animateToPage(
          _infoIndex,
          duration: const Duration(milliseconds: 400),
          curve: Curves.easeInOut,
        );
      }
    });
  }

  // --- FIREBASE LISTENER ---
  void _initFirebaseListener() {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      _userSubscription = FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .snapshots()
          .listen((snapshot) {
        if (snapshot.exists && mounted) {
          setState(() {
            _liveUserData = snapshot.data();
          });
        }
      });
    }
  }

  @override
  void dispose() {
    _timer?.cancel();
    _positionStream?.cancel();
    _userSubscription?.cancel();
    _infoController.dispose();
    super.dispose();
  }

  double _responsiveSize(double mobileSize) {
    double width = MediaQuery.of(context).size.width;
    if (width > 600) {
      return (mobileSize * 1.15).clamp(mobileSize, mobileSize * 1.3);
    }
    return mobileSize;
  }

  // --- LOCATION LOGIC ---
  Future<void> _initLocationService() async {
    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      if (mounted) setState(() => location = widget.ownerLocation);
      return;
    }

    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        if (mounted) setState(() => location = widget.ownerLocation);
        return;
      }
    }

    try {
      Position position = await Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.high,
          timeLimit: const Duration(seconds: 5));
      _updateAddress(position);
    } catch (e) {
      if (mounted) setState(() => location = widget.ownerLocation);
    }
  }

  Future<void> _updateAddress(Position pos) async {
    try {
      List<Placemark> placemarks = await placemarkFromCoordinates(pos.latitude, pos.longitude);
      if (mounted && placemarks.isNotEmpty) {
        setState(() {
          Placemark place = placemarks.first;
          location = "${place.subLocality ?? place.locality ?? 'Nearby'}, ${place.administrativeArea ?? ''}";
        });
      }
    } catch (e) {}
  }

  // --- IMAGE HELPERS ---
  ImageProvider _getProfileImage(dynamic imageSource) {
    const defaultImg = NetworkImage("https://cdn-icons-png.flaticon.com/512/149/149071.png");
    
    // Check Firestore for 'ownerImageBase64' (from Step 2)
    final liveBase64 = _liveUserData?['ownerImageBase64'];
    if (liveBase64 != null && liveBase64.toString().isNotEmpty) {
      return MemoryImage(base64Decode(liveBase64));
    }

    if (imageSource == null) return defaultImg;

    try {
      if (imageSource is String) {
        if (imageSource.startsWith('http')) return NetworkImage(imageSource);
        if (imageSource.length > 100) return MemoryImage(base64Decode(imageSource));
        return FileImage(File(imageSource));
      }
      if (imageSource is Uint8List) return MemoryImage(imageSource);
      if (imageSource is File) return FileImage(imageSource);
    } catch (e) {
      return defaultImg;
    }
    return defaultImg;
  }

  Widget _buildPetImage(Map<String, dynamic> pet) {
    final String? base64Str = pet['imageBase64'];
    if (base64Str != null && base64Str.isNotEmpty) {
      return Image.memory(base64Decode(base64Str), fit: BoxFit.cover, 
          errorBuilder: (_, __, ___) => const Icon(Icons.pets, color: Colors.orange));
    }
    return Image.asset("assets/images/pet_profile.png", fit: BoxFit.cover);
  }

  void _showPetSwitcher() {
    final List<dynamic> allPets = _liveUserData?['allPets'] ?? widget.allPets;

    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (context) => Container(
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(30)),
        ),
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(width: 40, height: 4, decoration: BoxDecoration(color: Colors.grey[300], borderRadius: BorderRadius.circular(10))),
            const SizedBox(height: 20),
            Text("Switch Pet Profile", style: TextStyle(fontFamily: 'Poppins', fontSize: _responsiveSize(18), fontWeight: FontWeight.bold)),
            const SizedBox(height: 15),
            Flexible(
              child: ListView.builder(
                shrinkWrap: true,
                itemCount: allPets.length,
                itemBuilder: (context, index) {
                  final pet = Map<String, dynamic>.from(allPets[index]);
                  return ListTile(
                    leading: CircleAvatar(
                      backgroundColor: Colors.orange.shade100,
                      backgroundImage: pet['imageBase64'] != null ? MemoryImage(base64Decode(pet['imageBase64'])) : null,
                      child: pet['imageBase64'] == null ? const Icon(Icons.pets, color: Colors.orange) : null,
                    ),
                    title: Text(pet['name'] ?? "Pet"),
                    onTap: () async {
                      final user = FirebaseAuth.instance.currentUser;
                      if (user != null) {
                        await FirebaseFirestore.instance.collection('users').doc(user.uid).update({'selectedPet': pet});
                      }
                      widget.onPetSwitched(pet);
                      Navigator.pop(context);
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  // --- DATA ---
  final List<Map<String, String>> infoCards = [
    {"text": "Stay on top of your pet’s health 🐾", "image": "assets/images/onboarding_page2.png"},
    {"text": "Never miss vaccines & routines 💉", "image": "assets/images/onboarding_page2.png"},
    {"text": "Keep your pet happy & active 🐶", "image": "assets/images/onboarding_page2.png"},
  ];

  List<Map<String, dynamic>> notifications = [
    {"title": "Morning Feeding", "time": DateTime.now(), "done": false, "type": "routine"},
    {"title": "Rabies Vaccine", "time": DateTime.now().add(const Duration(days: 2)), "done": false, "type": "vaccine"},
    {"title": "Vet Appointment", "time": DateTime.now().add(const Duration(hours: 5)), "done": false, "type": "vet"},
  ];

  String formatTime(DateTime t, String type) {
    if (type == "vaccine" || type == "vet") return DateFormat('dd MMM').format(t);
    return DateFormat('hh:mm a').format(t);
  }

  Color getColor(String type) {
    switch (type) {
      case "routine": return Colors.blueAccent.withOpacity(0.15);
      case "vaccine": return Colors.purpleAccent.withOpacity(0.15);
      case "vet": return Colors.orangeAccent.withOpacity(0.15);
      default: return Colors.grey.withOpacity(0.1);
    }
  }

  String getImage(String type) {
    switch (type) {
      case "routine": return "assets/images/routine_logo.png";
      case "vaccine": return "assets/images/vaccine_logo.png";
      case "vet": return "assets/images/booking_logo.png";
      default: return "assets/images/routine_logo.png";
    }
  }

  String getGreeting() {
    final hour = DateTime.now().hour;
    if (hour < 12) return 'Good Morning';
    if (hour < 17) return 'Good Afternoon';
    return 'Good Evening';
  }

  @override
  Widget build(BuildContext context) {
    final active = notifications.where((e) => e["done"] == false).toList();
    
    // Priority: Firestore 'ownerName' -> Firestore 'fullName' -> widget prop
    final String currentOwnerName = _liveUserData?['ownerName'] ?? 
                                   (_liveUserData?['fullName'] ?? widget.ownerName);
    
    final Map<String, dynamic> pet = _liveUserData?['selectedPet'] != null 
        ? Map<String, dynamic>.from(_liveUserData!['selectedPet']) 
        : widget.selectedPet;

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // --- HEADER ---
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Container(
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(color: Colors.orange.shade200, width: 2),
                        ),
                        child: CircleAvatar(
                          radius: 28,
                          backgroundColor: Colors.orange.shade50,
                          backgroundImage: _getProfileImage(widget.ownerImage),
                        ),
                      ),
                      const SizedBox(width: 14),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text("Welcome back, $currentOwnerName", 
                              style: TextStyle(fontFamily: 'Poppins', color: Colors.grey.shade600, fontSize: _responsiveSize(14))),
                          Text(getGreeting(), 
                              style: TextStyle(fontFamily: 'Poppins', fontSize: _responsiveSize(26), fontWeight: FontWeight.bold)),
                        ],
                      ),
                    ],
                  ),
                  _headerActionButton(Icons.notifications_none_rounded, () {}),
                ],
              ),
              const SizedBox(height: 10),
              Row(children: [
                const Icon(Icons.location_on, size: 16, color: Colors.orange), 
                const SizedBox(width: 6), 
                Text(location, style: TextStyle(fontFamily: 'Poppins', fontSize: _responsiveSize(14), color: Colors.grey.shade700))
              ]),

              const SizedBox(height: 30),

              // --- PET CARD ---
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: const Color(0xFFFFF2E6),
                  borderRadius: BorderRadius.circular(24),
                  border: Border.all(color: Colors.orange.withOpacity(0.25), width: 1.5),
                ),
                child: Row(
                  children: [
                    ClipRRect(borderRadius: BorderRadius.circular(20), 
                        child: SizedBox(height: 70, width: 70, child: _buildPetImage(pet))),
                    const SizedBox(width: 14),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(pet['name'] ?? 'My Pet', style: TextStyle(fontFamily: 'Poppins', fontWeight: FontWeight.bold, fontSize: _responsiveSize(18))),
                          Text("${pet['type'] ?? 'Pet'} • ${pet['breed'] ?? 'Mixed'}", 
                              style: TextStyle(fontFamily: 'Poppins', color: Colors.orange.shade800, fontSize: _responsiveSize(13), fontWeight: FontWeight.w500)),
                        ],
                      ),
                    ),
                    GestureDetector(
                      onTap: _showPetSwitcher,
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                        decoration: BoxDecoration(color: Colors.orange, borderRadius: BorderRadius.circular(25)),
                        child: Text("Switch", style: TextStyle(fontFamily: 'Poppins', color: Colors.white, fontSize: _responsiveSize(13), fontWeight: FontWeight.bold)),
                      ),
                    )
                  ],
                ),
              ),

              const SizedBox(height: 25),

              // --- INFO CARDS ---
              SizedBox(
                height: 120,
                child: PageView.builder(
                  controller: _infoController,
                  itemCount: infoCards.length,
                  itemBuilder: (_, i) {
                    return Container(
                      margin: const EdgeInsets.symmetric(horizontal: 4),
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(22),
                        gradient: const LinearGradient(colors: [Color(0xFFFFF8F2), Color(0xFFFFEAD7)]),
                        border: Border.all(color: Colors.orange.withOpacity(0.2)),
                      ),
                      child: Row(
                        children: [
                          Image.asset(infoCards[i]["image"]!, height: 75),
                          const SizedBox(width: 14),
                          Expanded(child: Text(infoCards[i]["text"]!, style: TextStyle(fontFamily: 'Poppins', fontSize: _responsiveSize(15), fontWeight: FontWeight.w500))),
                        ],
                      ),
                    );
                  },
                ),
              ),

              const SizedBox(height: 25),

              // --- GRID ---
              GridView.count(
                shrinkWrap: true,
                crossAxisCount: 3,
                crossAxisSpacing: 16,
                mainAxisSpacing: 16,
                physics: const NeverScrollableScrollPhysics(),
                children: [
                  _card("Emergency", "assets/images/emergency_logo.png", AppRoutes.emergency, Colors.orange),
                  _card("Nearby Lost", "assets/images/nearby_lost_and_found_logo.png", AppRoutes.lost, Colors.amber),
                  _card("Bookings", "assets/images/booking_logo.png", AppRoutes.booking, Colors.teal),
                  _card("Routine", "assets/images/routine_logo.png", AppRoutes.routine, Colors.blue),
                  _card("Vaccine", "assets/images/vaccine_logo.png", AppRoutes.vaccine, Colors.green),
                  _card("Pet Care", "assets/images/petcare_logo.png", AppRoutes.petCare, Colors.purple),
                ],
              ),

              const SizedBox(height: 30),
              Text("Today’s Upcoming Tasks", style: TextStyle(fontFamily: 'Poppins', fontWeight: FontWeight.bold, fontSize: _responsiveSize(18))),
              const SizedBox(height: 16),

              // --- TASKS ---
              Column(
                children: active.map((item) {
                  return Container(
                    margin: const EdgeInsets.only(bottom: 14),
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(color: getColor(item["type"]), borderRadius: BorderRadius.circular(20)),
                    child: Row(
                      children: [
                        Image.asset(getImage(item["type"]), height: 35),
                        const SizedBox(width: 14),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(item["title"], style: TextStyle(fontFamily: 'Poppins', fontWeight: FontWeight.bold, fontSize: _responsiveSize(15))),
                              Text(formatTime(item["time"], item["type"]), style: TextStyle(fontFamily: 'Poppins', fontSize: _responsiveSize(13), color: Colors.black54)),
                            ],
                          ),
                        ),
                        GestureDetector(
                          onTap: () { setState(() { item["done"] = !item["done"]; }); },
                          child: Container(
                            height: 28, width: 28,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              border: Border.all(color: Colors.orange, width: 2.5),
                              color: item["done"] ? Colors.orange : Colors.transparent,
                            ),
                            child: item["done"] ? const Icon(Icons.check, size: 18, color: Colors.white) : null,
                          ),
                        )
                      ],
                    ),
                  );
                }).toList(),
              ),
              const SizedBox(height: 30),
            ],
          ),
        ),
      ),
    );
  }

  Widget _headerActionButton(IconData icon, VoidCallback onTap) {
    return Container(
      decoration: BoxDecoration(color: Colors.grey.shade100, shape: BoxShape.circle),
      child: IconButton(icon: Icon(icon, color: Colors.black87), onPressed: onTap),
    );
  }

  Widget _card(String title, String image, String route, Color color) {
    return GestureDetector(
      onTap: () => Navigator.pushNamed(context, route),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(24),
          boxShadow: [BoxShadow(color: color.withOpacity(0.2), blurRadius: 10)]
        ),
        child: Column(
          children: [
            Expanded(
              flex: 3,
              child: Container(
                decoration: BoxDecoration(
                  color: color.withOpacity(0.6),
                  borderRadius: const BorderRadius.vertical(top: Radius.circular(24))
                ),
                child: Center(child: Image.asset(image, height: 45))
              )
            ),
            Expanded(
              flex: 2,
              child: Container(
                width: double.infinity,
                decoration: const BoxDecoration(color: Color(0xFFF9F9F9), borderRadius: BorderRadius.vertical(bottom: Radius.circular(24))),
                child: Center(child: Text(title, textAlign: TextAlign.center, style: TextStyle(fontFamily: 'Poppins', fontSize: _responsiveSize(10), fontWeight: FontWeight.bold)))
              ),
            ),
          ],
        ),
      ),
    );
  }
}