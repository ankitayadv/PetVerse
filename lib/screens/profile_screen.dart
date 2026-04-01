import 'package:flutter/material.dart';
import '../routes/app_routes.dart'; // ✅ ADDED

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> with SingleTickerProviderStateMixin {
  // PetVerse Design System
  static const Color brandOrange = Color(0xFFFF8A3D);
  static const Color softCream = Color(0xFFFEF9F5);
  static const Color surfaceWhite = Colors.white;
  static const Color textMain = Color(0xFF2D2D2D);
  static const Color softBorder = Color(0xFFFFEBD2);

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
          style: TextStyle(color: textMain, fontWeight: FontWeight.bold, fontSize: 20),
        ),
        actions: [
          _buildCircleBtn(Icons.settings_outlined, () {
            Navigator.pushNamed(context, AppRoutes.settingsPage); // ✅ FIXED
          }),
          const SizedBox(width: 16),
        ],
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

            const SizedBox(height: 25),

            _buildSectionLabel("Pet Profile"),
            _buildDetailedPetCard(),

            const SizedBox(height: 25),

            _buildSectionLabel("Account & Security"),
            _buildSettingsGroup(),

            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }

  // --- UI SAME ---

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
                radius: 55,
                backgroundColor: Colors.white,
                backgroundImage: NetworkImage('https://api.dicebear.com/7.x/avataaars/png?seed=Ankita'),
              ),
            ),
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: brandOrange,
                shape: BoxShape.circle,
                border: Border.all(color: Colors.white, width: 3),
              ),
              child: const Icon(Icons.camera_alt_rounded, size: 16, color: Colors.white),
            ),
          ],
        ),
        const SizedBox(height: 16),
        const Text("Ankita Mehta",
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: textMain)),
        const SizedBox(height: 6),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
          decoration: BoxDecoration(
            color: brandOrange.withOpacity(0.1),
            borderRadius: BorderRadius.circular(20),
          ),
          child: const Text("Premium Pet Parent 🐾",
              style: TextStyle(color: brandOrange, fontSize: 12, fontWeight: FontWeight.bold)),
        ),
      ],
    );
  }

  Widget _buildStreakCard() {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [brandOrange, Color(0xFFFFAC71)],
        ),
        borderRadius: BorderRadius.circular(32),
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: const [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("Activity Streak", style: TextStyle(color: Colors.white70)),
                  Text("05 Days 🔥", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                ],
              ),
              Icon(Icons.auto_graph_rounded, color: Colors.white),
            ],
          ),
          const SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: List.generate(7, (index) {
              bool isDone = weeklyStreak[index];
              return Column(
                children: [
                  Text(days[index], style: const TextStyle(color: Colors.white70)),
                  const SizedBox(height: 6),
                  Icon(isDone ? Icons.check_circle : Icons.circle_outlined, color: Colors.white),
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
        borderRadius: BorderRadius.circular(28),
        border: Border.all(color: softBorder),
      ),
      child: Row(
        children: [
          const CircleAvatar(radius: 30),
          const SizedBox(width: 10),
          const Expanded(child: Text("Bruno")),
          _buildCircleBtn(Icons.edit_note_rounded, () {
            Navigator.pushNamed(context, AppRoutes.editPet); // ✅ CONNECTED
          }),
        ],
      ),
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
          _buildActionTile("Edit Owner Profile", Icons.person_outline_rounded, () {
            Navigator.pushNamed(context, AppRoutes.editOwner);
          }),
          _buildActionTile("Edit Pet Profile", Icons.pets_rounded, () {
            Navigator.pushNamed(context, AppRoutes.editPet);
          }),
          _buildActionTile("Privacy & Security", Icons.security_rounded, () {
            Navigator.pushNamed(context, AppRoutes.privacy);
          }),
          _buildActionTile("Reminders & Alerts", Icons.notifications_active_rounded, () {
            Navigator.pushNamed(context, AppRoutes.reminders);
          }),
          _buildActionTile("Sign Out", Icons.logout_rounded, _showLogoutDialog, isDestructive: true),
        ],
      ),
    );
  }

  Widget _buildActionTile(String title, IconData icon, VoidCallback tap, {bool isDestructive = false}) {
    return ListTile(
      onTap: tap,
      leading: Icon(icon, color: isDestructive ? Colors.red : brandOrange),
      title: Text(title),
      trailing: const Icon(Icons.chevron_right),
    );
  }

  Widget _buildCircleBtn(IconData icon, VoidCallback tap) {
    return IconButton(onPressed: tap, icon: Icon(icon));
  }

  Widget _buildSectionLabel(String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16, top: 10),
      child: Text(title, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
    );
  }

  void _showLogoutDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Logout"),
        content: const Text("Ready to leave PetVerse?"),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text("Stay")),
          ElevatedButton(
            onPressed: () {
              Navigator.pushNamedAndRemoveUntil(
                context,
                AppRoutes.login, // ✅ FIXED
                (route) => false,
              );
            },
            child: const Text("Logout"),
          ),
        ],
      ),
    );
  }
}