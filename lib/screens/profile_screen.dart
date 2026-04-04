import 'dart:convert';
import 'dart:io';
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'dart:typed_data';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';

class ProfileScreen extends StatefulWidget {
  final String ownerName;
  final String ownerLocation;
  final dynamic ownerImage;
  final Map<String, dynamic> selectedPet;

  const ProfileScreen({
    super.key,
    required this.ownerName,
    required this.ownerLocation,
    required this.selectedPet,
    this.ownerImage,
  });

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> with SingleTickerProviderStateMixin {
  // Brand Theme Colors
  static const Color brandOrange = Color(0xFFFF8A3D);
  static const Color softCream = Color(0xFFFEF9F5);
  static const Color surfaceWhite = Colors.white;
  static const Color textMain = Color(0xFF2D2D2D);
  static const Color softBorder = Color(0xFFFFEBD2);

  // Data State
  Map<String, dynamic>? _liveUserData;
  StreamSubscription<DocumentSnapshot>? _userSubscription;
  String _currentLocation = "Fetching...";
  bool _isAnimated = false;

  // Activity Streak Data
  final List<bool> weeklyStreak = [true, true, true, true, true, false, false];
  final List<String> days = ["M", "T", "W", "T", "F", "S", "S"];

  @override
  void initState() {
    super.initState();
    _currentLocation = widget.ownerLocation.isNotEmpty ? widget.ownerLocation : "Fetching...";
    _initFirebaseListener();
    _initLocationService();
    Future.delayed(const Duration(milliseconds: 150), () {
      if (mounted) setState(() => _isAnimated = true);
    });
  }

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

  Future<void> _initLocationService() async {
    try {
      Position position = await Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.high);
      List<Placemark> placemarks = await placemarkFromCoordinates(position.latitude, position.longitude);
      if (mounted && placemarks.isNotEmpty) {
        setState(() {
          Placemark place = placemarks.first;
          _currentLocation = "${place.locality ?? 'Nearby'}, ${place.administrativeArea ?? ''}";
        });
      }
    } catch (e) {
      if (mounted) setState(() => _currentLocation = widget.ownerLocation);
    }
  }

  @override
  void dispose() {
    _userSubscription?.cancel();
    super.dispose();
  }

  int _calculateStreak() {
    return weeklyStreak.where((done) => done).length;
  }

  ImageProvider _getOwnerImage() {
    final liveBase64 = _liveUserData?['ownerImageBase64'];
    if (liveBase64 != null && liveBase64.toString().isNotEmpty) {
      return MemoryImage(base64Decode(liveBase64));
    }
    if (widget.ownerImage != null) {
      if (widget.ownerImage is Uint8List) return MemoryImage(widget.ownerImage);
      if (widget.ownerImage is File) return FileImage(widget.ownerImage);
      if (widget.ownerImage is String && widget.ownerImage.startsWith('http')) return NetworkImage(widget.ownerImage);
    }
    return const NetworkImage("https://cdn-icons-png.flaticon.com/512/149/149071.png");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: softCream,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        automaticallyImplyLeading: false,
        title: const Text(
          "My Profile",
          style: TextStyle(color: textMain, fontWeight: FontWeight.bold, fontSize: 20, fontFamily: 'Poppins')
        ),
      ),
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          children: [
            const SizedBox(height: 10),
            _buildProfileHeader(),
            const SizedBox(height: 25),
            
            AnimatedPadding(
              duration: const Duration(milliseconds: 600),
              padding: EdgeInsets.only(top: _isAnimated ? 0 : 20),
              child: AnimatedOpacity(
                duration: const Duration(milliseconds: 600),
                opacity: _isAnimated ? 1 : 0,
                child: _buildStreakCard(),
              ),
            ),
            
            const SizedBox(height: 30),
            _buildSectionLabel("Pet Profile"),
            _buildDetailedPetCard(),
            
            const SizedBox(height: 30),
            _buildSectionLabel("Account & Security"),
            _buildSettingsGroup(),
            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }

  Widget _buildProfileHeader() {
    final String name = _liveUserData?['ownerName'] ?? (_liveUserData?['fullName'] ?? widget.ownerName);
    
    return Column(
      children: [
        Stack(
          alignment: Alignment.bottomRight,
          children: [
            Container(
              padding: const EdgeInsets.all(4),
              decoration: const BoxDecoration(color: brandOrange, shape: BoxShape.circle),
              child: CircleAvatar(
                radius: 55,
                backgroundColor: Colors.white,
                backgroundImage: _getOwnerImage(),
              ),
            ),
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: brandOrange, 
                shape: BoxShape.circle, 
                border: Border.all(color: Colors.white, width: 3)
              ),
              child: const Icon(Icons.camera_alt_rounded, size: 16, color: Colors.white),
            ),
          ],
        ),
        const SizedBox(height: 16),
        Text(name, 
          style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: textMain, fontFamily: 'Poppins')),
        const SizedBox(height: 6),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.location_on_rounded, size: 14, color: brandOrange),
            const SizedBox(width: 4),
            Text(_currentLocation, style: const TextStyle(color: Colors.grey, fontSize: 13, fontFamily: 'Poppins')),
          ],
        ),
        const SizedBox(height: 12),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
          decoration: BoxDecoration(
            color: brandOrange.withOpacity(0.1),
            borderRadius: BorderRadius.circular(20)
          ),
          child: const Text("Premium Pet Parent 🐾", 
            style: TextStyle(color: brandOrange, fontSize: 12, fontWeight: FontWeight.bold, fontFamily: 'Poppins')),
        ),
      ],
    );
  }

  Widget _buildStreakCard() {
    final int streak = _calculateStreak();
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [brandOrange, Color(0xFFFFAC71)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(32),
        boxShadow: [
          BoxShadow(color: brandOrange.withOpacity(0.3), blurRadius: 20, offset: const Offset(0, 10))
        ],
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text("Activity Streak", style: TextStyle(color: Colors.white70, fontSize: 14, fontFamily: 'Poppins')),
                  Text("${streak.toString().padLeft(2, '0')} Days 🔥", 
                    style: const TextStyle(color: Colors.white, fontSize: 22, fontWeight: FontWeight.bold, fontFamily: 'Poppins')),
                ],
              ),
              const Icon(Icons.auto_graph_rounded, color: Colors.white, size: 32),
            ],
          ),
          const SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: List.generate(7, (index) {
              bool isDone = weeklyStreak[index];
              return Column(
                children: [
                  Text(days[index], style: const TextStyle(color: Colors.white70, fontSize: 12, fontFamily: 'Poppins')),
                  const SizedBox(height: 8),
                  Icon(isDone ? Icons.check_circle : Icons.circle_outlined, color: Colors.white, size: 22),
                ],
              );
            }),
          )
        ],
      ),
    );
  }

  Widget _buildDetailedPetCard() {
    final pet = _liveUserData?['selectedPet'] ?? widget.selectedPet;
    final String? petBase64 = pet['imageBase64'];

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: surfaceWhite,
        borderRadius: BorderRadius.circular(28),
        border: Border.all(color: softBorder),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                height: 70, width: 70,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(22),
                  color: brandOrange.withOpacity(0.1),
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(22),
                  child: petBase64 != null && petBase64.isNotEmpty
                    ? Image.memory(base64Decode(petBase64), fit: BoxFit.cover)
                    : const Icon(Icons.pets, color: brandOrange, size: 30),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(pet['name'] ?? "My Pet", 
                      style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 22, color: textMain, fontFamily: 'Poppins')),
                    Row(
                      children: [
                        const Icon(Icons.verified_rounded, color: Colors.green, size: 14),
                        const SizedBox(width: 4),
                        Text("Fully Vaccinated", style: TextStyle(color: Colors.green.shade700, fontSize: 13, fontWeight: FontWeight.w600, fontFamily: 'Poppins')),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          const Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text("Health Progress", style: TextStyle(color: Colors.grey, fontSize: 12, fontWeight: FontWeight.w600, fontFamily: 'Poppins')),
              Text("85%", style: TextStyle(color: brandOrange, fontSize: 12, fontWeight: FontWeight.bold, fontFamily: 'Poppins')),
            ],
          ),
          const SizedBox(height: 8),
          ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: LinearProgressIndicator(
              value: 0.85,
              backgroundColor: brandOrange.withOpacity(0.1),
              color: brandOrange,
              minHeight: 8,
            ),
          ),
          const SizedBox(height: 25),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildPetStat("Gender", pet['gender'] ?? "N/A", Icons.male_rounded),
              _buildPetStat("Weight", "${pet['weight'] ?? '0'} kg", Icons.fitness_center_rounded),
              _buildPetStat("Age", "${pet['age'] ?? '0'} Yrs", Icons.cake_rounded),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildPetStat(String label, String value, IconData icon) {
    return Column(
      children: [
        Icon(icon, color: brandOrange.withOpacity(0.5), size: 20),
        const SizedBox(height: 6),
        Text(value, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15, color: textMain, fontFamily: 'Poppins')),
        Text(label, style: const TextStyle(color: Colors.grey, fontSize: 11, fontFamily: 'Poppins')),
      ],
    );
  }

  Widget _buildSettingsGroup() {
    return Container(
      decoration: BoxDecoration(
        color: surfaceWhite,
        borderRadius: BorderRadius.circular(28),
        border: Border.all(color: softBorder),
      ),
      child: Column(
        children: [
          _buildActionTile("Edit Owner Profile", Icons.person_outline_rounded, () {}),
          _buildActionTile("Edit Pet Profile", Icons.pets_outlined, () {}),
          _buildActionTile("Privacy & Security", Icons.shield_outlined, () {}),
          _buildActionTile("Reminders & Alerts", Icons.notifications_none_outlined, () {}),
          _buildActionTile("Sign Out", Icons.logout_rounded, _handleLogout, isDestructive: true),
        ],
      ),
    );
  }

  Widget _buildActionTile(String title, IconData icon, VoidCallback tap, {bool isDestructive = false}) {
    return ListTile(
      onTap: tap,
      contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 4),
      leading: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: isDestructive ? Colors.red.withOpacity(0.1) : brandOrange.withOpacity(0.1),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Icon(icon, color: isDestructive ? Colors.redAccent : brandOrange, size: 22),
      ),
      title: Text(title, style: TextStyle(color: isDestructive ? Colors.redAccent : textMain, fontWeight: FontWeight.w600, fontSize: 15, fontFamily: 'Poppins')),
      trailing: const Icon(Icons.chevron_right_rounded, size: 22, color: Colors.grey),
    );
  }

  Widget _buildSectionLabel(String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16, left: 4), 
      child: Row(children: [Text(title, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: textMain, fontFamily: 'Poppins'))])
    );
  }

  void _handleLogout() async {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: surfaceWhite,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(28)),
        title: const Text("Sign Out", style: TextStyle(fontWeight: FontWeight.bold, fontFamily: 'Poppins')),
        content: const Text("Ready to leave PetVerse for a while?", style: TextStyle(fontFamily: 'Poppins')),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text("Stay", style: TextStyle(color: Colors.grey))),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: Colors.redAccent, shape: const StadiumBorder()),
            onPressed: () async {
              await FirebaseAuth.instance.signOut();
              // Redirect to Login/Onboarding screen and clear stack
              if (mounted) {
                Navigator.of(context).pushNamedAndRemoveUntil('/login', (route) => false);
              }
            },
            child: const Text("Sign Out", style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }
}