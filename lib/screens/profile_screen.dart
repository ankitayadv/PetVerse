import 'package:flutter/material.dart';
import 'dart:io';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'dart:typed_data';

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

  // Activity Streak Data
  final List<bool> weeklyStreak = [true, true, true, true, true, false, false];
  final List<String> days = ["M", "T", "W", "T", "F", "S", "S"];
  bool _isAnimated = false;

  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(milliseconds: 150), () {
      if (mounted) setState(() => _isAnimated = true);
    });
  }

  int _calculateStreak() {
    int streak = 0;
    for (bool done in weeklyStreak) {
      if (done) streak++; else break;
    }
    return streak;
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
          style: TextStyle(color: textMain, fontWeight: FontWeight.bold, fontSize: 20)
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
            
            // Activity Streak Section
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
                backgroundImage: widget.ownerImage != null 
                    ? (widget.ownerImage is Uint8List 
                        ? MemoryImage(widget.ownerImage) 
                        : FileImage(File(widget.ownerImage.path)) as ImageProvider)
                    : null,
                child: widget.ownerImage == null 
                    ? const Icon(Icons.person, size: 50, color: brandOrange) 
                    : null,
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
        Text(widget.ownerName, 
          style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: textMain)),
        const SizedBox(height: 6),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.location_on_rounded, size: 14, color: brandOrange),
            const SizedBox(width: 4),
            Text(widget.ownerLocation, style: const TextStyle(color: Colors.grey, fontSize: 13)),
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
            style: TextStyle(color: brandOrange, fontSize: 12, fontWeight: FontWeight.bold)),
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
          BoxShadow(
            color: brandOrange.withOpacity(0.3),
            blurRadius: 20,
            offset: const Offset(0, 10),
          )
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
                  const Text("Activity Streak", style: TextStyle(color: Colors.white70, fontSize: 14)),
                  Text("${streak.toString().padLeft(2, '0')} Days 🔥", 
                    style: const TextStyle(color: Colors.white, fontSize: 22, fontWeight: FontWeight.bold)),
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
                  Text(days[index], style: const TextStyle(color: Colors.white70, fontSize: 12)),
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
    final pet = widget.selectedPet;
    final dynamic petImg = pet['image'];

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
                  child: petImg != null
                    ? (kIsWeb ? Image.network(petImg.path, fit: BoxFit.cover) : Image.file(File(petImg.path), fit: BoxFit.cover))
                    : const Icon(Icons.pets, color: brandOrange, size: 30),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(pet['name'] ?? "My Pet", 
                      style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 22, color: textMain)),
                    Row(
                      children: [
                        const Icon(Icons.verified_rounded, color: Colors.green, size: 14),
                        const SizedBox(width: 4),
                        Text("Fully Vaccinated", style: TextStyle(color: Colors.green.shade700, fontSize: 13, fontWeight: FontWeight.w600)),
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
              Text("Health Progress", style: TextStyle(color: Colors.grey, fontSize: 12, fontWeight: FontWeight.w600)),
              Text("85%", style: TextStyle(color: brandOrange, fontSize: 12, fontWeight: FontWeight.bold)),
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
        Text(value, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15, color: textMain)),
        Text(label, style: const TextStyle(color: Colors.grey, fontSize: 11)),
      ],
    );
  }

  // UPDATED: Settings Group with new options
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
          _buildActionTile("Sign Out", Icons.logout_rounded, _showLogoutDialog, isDestructive: true),
        ],
      ),
    );
  }

  // UPDATED: Action Tile to match the visual style
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
      title: Text(
        title, 
        style: TextStyle(
          color: isDestructive ? Colors.redAccent : textMain, 
          fontWeight: FontWeight.w600,
          fontSize: 15
        )
      ),
      trailing: const Icon(Icons.chevron_right_rounded, size: 22, color: Colors.grey),
    );
  }

  Widget _buildSectionLabel(String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16, left: 4), 
      child: Row(children: [Text(title, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: textMain))])
    );
  }

  void _showLogoutDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: surfaceWhite,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(28)),
        title: const Text("Sign Out", style: TextStyle(fontWeight: FontWeight.bold)),
        content: const Text("Ready to leave PetVerse for a while?"),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text("Stay", style: TextStyle(color: Colors.grey))),
          Padding(
            padding: const EdgeInsets.only(right: 8, bottom: 8),
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(backgroundColor: Colors.redAccent, elevation: 0, shape: const StadiumBorder()),
              onPressed: () => Navigator.of(context).popUntil((route) => route.isFirst),
              child: const Text("Sign Out", style: TextStyle(color: Colors.white)),
            ),
          ),
        ],
      ),
    );
  }
}