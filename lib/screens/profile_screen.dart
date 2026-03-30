import 'package:flutter/material.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  // PetVerse Design System
  static const Color brandOrange = Color(0xFFFF8A3D);
  static const Color softCream = Color(0xFFFEF9F5);
  static const Color surfaceWhite = Colors.white;
  static const Color textMain = Color(0xFF2D2D2D);
  static const Color softBorder = Color(0xFFFFEBD2);

  final List<bool> weeklyStreak = [true, true, true, true, true, false, false];
  final List<String> days = ["M", "T", "W", "T", "F", "S", "S"];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: softCream,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        leading: _buildCircleBtn(Icons.arrow_back_ios_new, () => Navigator.pop(context)),
        title: const Text("Profile", 
          style: TextStyle(color: textMain, fontWeight: FontWeight.bold, fontSize: 18)),
        actions: [
          _buildCircleBtn(Icons.share_outlined, () {}),
          const SizedBox(width: 16),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          children: [
            const SizedBox(height: 10),
            _buildProfileHeader(),
            const SizedBox(height: 25),
            
            _buildStreakCard(),
            const SizedBox(height: 25),

            // --- PET PROFILE SECTION (Name, Weight, Gender, Age) ---
            _buildSectionLabel("Pet Profile"),
            _buildDetailedPetCard(), 
            const SizedBox(height: 25),

            // --- ACCOUNT SETTINGS ---
            _buildSectionLabel("Settings"),
            _buildActionTile("Edit Owner Profile", Icons.edit_outlined, () {}),
            _buildActionTile("Notification Settings", Icons.notifications_none_outlined, () {}),
            _buildActionTile("Privacy & Settings", Icons.shield_outlined, () {}),
            _buildActionTile("Logout", Icons.logout_rounded, _showLogoutDialog, isDestructive: true),
            
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
              child: const CircleAvatar(
                radius: 50,
                backgroundColor: Colors.white,
                child: Icon(Icons.person, size: 50, color: Color(0xFFCBD5E1)),
              ),
            ),
            Container(
              padding: const EdgeInsets.all(6),
              decoration: BoxDecoration(
                color: brandOrange, 
                shape: BoxShape.circle, 
                border: Border.all(color: Colors.white, width: 2)
              ),
              child: const Icon(Icons.camera_alt, size: 14, color: Colors.white),
            ),
          ],
        ),
        const SizedBox(height: 12),
        const Text("Ankita Mehta", 
          style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: textMain)),
        const Text("Professional Pet Parent", style: TextStyle(color: Colors.grey, fontSize: 14)),
      ],
    );
  }

  Widget _buildStreakCard() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: brandOrange,
        borderRadius: BorderRadius.circular(28),
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: const [
              Text("Care Streak 🔥", 
                style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold)),
              Text("05 Days", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
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
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: surfaceWhite,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: softBorder),
      ),
      child: Column(
        children: [
          Row(
            children: [
              Container(
                height: 60, width: 60,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(15),
                  color: const Color(0xFFFFF3E9),
                ),
                child: const Icon(Icons.pets, color: brandOrange, size: 30),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text("Bruno", 
                      style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18, color: textMain)),
                    const SizedBox(height: 4),
                    Row(
                      children: const [
                        Icon(Icons.verified, color: Colors.green, size: 14),
                        SizedBox(width: 4),
                        Text("Vaccines Up-to-date", 
                          style: TextStyle(color: Colors.green, fontSize: 12, fontWeight: FontWeight.w600)),
                      ],
                    ),
                  ],
                ),
              ),
              // EDIT PET PROFILE BUTTON
              IconButton(
                onPressed: () {
                   // Navigate to your existing StepThreeScreen or an Edit Pet page
                },
                icon: const Icon(Icons.edit_note_rounded, color: brandOrange, size: 28),
              ),
            ],
          ),
          const Padding(
            padding: EdgeInsets.symmetric(vertical: 15),
            child: Divider(color: softBorder, thickness: 1),
          ),
          // PET DESCRIPTION (GENDER, WEIGHT, AGE)
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildPetStat("Gender", "Male"),
              _buildPetStat("Weight", "25 kg"),
              _buildPetStat("Age", "3 Yrs"),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildPetStat(String label, String value) {
    return Column(
      children: [
        Text(value, 
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15, color: textMain)),
        const SizedBox(height: 4),
        Text(label, style: const TextStyle(color: Colors.grey, fontSize: 12)),
      ],
    );
  }

  Widget _buildActionTile(String title, IconData icon, VoidCallback tap, {bool isDestructive = false}) {
    return ListTile(
      onTap: tap,
      leading: Icon(icon, color: isDestructive ? Colors.red : brandOrange),
      title: Text(title, 
        style: TextStyle(color: isDestructive ? Colors.red : textMain, fontWeight: FontWeight.w500)),
      trailing: const Icon(Icons.chevron_right, size: 18, color: Colors.grey),
    );
  }

  Widget _buildCircleBtn(IconData icon, VoidCallback tap) {
    return IconButton(
      onPressed: tap, 
      icon: Container(
        padding: const EdgeInsets.all(8), 
        decoration: const BoxDecoration(color: Color(0xFFFFF3E9), shape: BoxShape.circle), 
        child: Icon(icon, color: brandOrange, size: 18)
      )
    );
  }

  Widget _buildSectionLabel(String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12, top: 10, left: 5), 
      child: Row(children: [Text(title, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold))])
    );
  }

  void _showLogoutDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: const Text("Logout"),
        content: const Text("Are you sure you want to log out?"),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text("Cancel")),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: Colors.redAccent, shape: const StadiumBorder()),
            onPressed: () => Navigator.of(context).popUntil((route) => route.isFirst),
            child: const Text("Logout", style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }
}