import 'package:flutter/material.dart';

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
    // Smooth entrance delay for animations
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
          style: TextStyle(color: textMain, fontWeight: FontWeight.bold, fontSize: 20)
        ),
        actions: [
          _buildCircleBtn(Icons.settings_outlined, () {}),
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
            
            // Streak Card with Slide-up Animation
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

  // --- UI COMPONENTS ---

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
                border: Border.all(color: Colors.white, width: 3)
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
            borderRadius: BorderRadius.circular(20)
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
                children: const [
                  Text("Activity Streak", style: TextStyle(color: Colors.white70, fontSize: 14)),
                  Text("05 Days 🔥", style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold)),
                ],
              ),
              const Icon(Icons.auto_graph_rounded, color: Colors.white, size: 30),
            ],
          ),
          const SizedBox(height: 25),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: List.generate(7, (index) {
              bool isDone = weeklyStreak[index];
              return Column(
                children: [
                  Text(days[index], style: const TextStyle(color: Colors.white70, fontSize: 12, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 8),
                  AnimatedScale(
                    scale: _isAnimated ? 1 : 0.5,
                    duration: Duration(milliseconds: 400 + (index * 100)),
                    child: Icon(isDone ? Icons.check_circle : Icons.circle_outlined, color: Colors.white, size: 22),
                  ),
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
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.02), blurRadius: 15, offset: const Offset(0, 5))],
      ),
      child: Column(
        children: [
          Row(
            children: [
              Container(
                height: 65, width: 65,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  image: const DecorationImage(
                    image: NetworkImage('https://images.unsplash.com/photo-1583511655857-d19b40a7a54e?q=80&w=200&auto=format&fit=crop'),
                    fit: BoxFit.cover
                  ),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text("Bruno", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20, color: textMain)),
                    const SizedBox(height: 4),
                    Row(
                      children: const [
                        Icon(Icons.verified_user_rounded, color: Colors.green, size: 16),
                        SizedBox(width: 4),
                        Text("Fully Vaccinated", style: TextStyle(color: Colors.green, fontSize: 13, fontWeight: FontWeight.w600)),
                      ],
                    ),
                  ],
                ),
              ),
              _buildCircleBtn(Icons.edit_note_rounded, () {}),
            ],
          ),
          const SizedBox(height: 20),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: const [
                  Text("Health Progress", style: TextStyle(fontSize: 12, color: Colors.grey)),
                  Text("85%", style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: brandOrange)),
                ],
              ),
              const SizedBox(height: 8),
              ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: const LinearProgressIndicator(
                  value: 0.85,
                  backgroundColor: softBorder,
                  color: brandOrange,
                  minHeight: 8,
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildPetStat("Gender", "Male", Icons.male_rounded),
              _buildPetStat("Weight", "25 kg", Icons.fitness_center_rounded),
              _buildPetStat("Age", "3 Yrs", Icons.cake_rounded),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildPetStat(String label, String value, IconData icon) {
    return Column(
      children: [
        Icon(icon, color: brandOrange.withOpacity(0.5), size: 18),
        const SizedBox(height: 6),
        Text(value, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15, color: textMain)),
        Text(label, style: const TextStyle(color: Colors.grey, fontSize: 11)),
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
          _buildActionTile("Edit Pet Profile", Icons.pets_rounded, () {}),
          _buildActionTile("Privacy & Security", Icons.security_rounded, () {}),
          _buildActionTile("Reminders & Alerts", Icons.notifications_active_rounded, () {}),
          _buildActionTile("Sign Out", Icons.logout_rounded, _showLogoutDialog, isDestructive: true),
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
          borderRadius: BorderRadius.circular(12)
        ),
        child: Icon(icon, color: isDestructive ? Colors.red : brandOrange, size: 20),
      ),
      title: Text(title, style: TextStyle(color: isDestructive ? Colors.red : textMain, fontWeight: FontWeight.w600, fontSize: 15)),
      trailing: const Icon(Icons.chevron_right_rounded, size: 18, color: Colors.grey),
    );
  }

  Widget _buildCircleBtn(IconData icon, VoidCallback tap) {
    return IconButton(
      onPressed: tap, 
      icon: Container(
        padding: const EdgeInsets.all(8), 
        decoration: const BoxDecoration(color: Colors.white, shape: BoxShape.circle), 
        child: Icon(icon, color: brandOrange, size: 18)
      )
    );
  }

  Widget _buildSectionLabel(String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16, top: 10, left: 4), 
      child: Row(children: [Text(title, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: textMain))])
    );
  }

  void _showLogoutDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: surfaceWhite,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(28)),
        title: const Text("Logout", style: TextStyle(fontWeight: FontWeight.bold)),
        content: const Text("Ready to leave PetVerse for a while?"),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text("Stay", style: TextStyle(color: Colors.grey))),
          Padding(
            padding: const EdgeInsets.only(right: 8, bottom: 8),
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(backgroundColor: Colors.redAccent, elevation: 0, shape: const StadiumBorder()),
              onPressed: () => Navigator.of(context).popUntil((route) => route.isFirst),
              child: const Text("Logout", style: TextStyle(color: Colors.white)),
            ),
          ),
        ],
      ),
    );
  }
}