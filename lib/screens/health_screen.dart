import 'package:flutter/material.dart';
// Ensure you import your home screen file here
// import 'package:petverse/screens/home_screen.dart'; 

class HealthScreen extends StatelessWidget {
  const HealthScreen({super.key});

  // PetVerse Theme Constants
  static const Color brandOrange = Color(0xFFFF8A3D);
  static const Color softCream = Color(0xFFFEF9F5);
  static const Color surfaceWhite = Colors.white;
  static const Color textMain = Color(0xFF2D2D2D);
  static const Color softBorder = Color(0xFFFFEBD2);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: softCream,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        // BACK BUTTON: Navigates specifically to Home Screen
        leading: _buildCircleBtn(Icons.arrow_back_ios_new, () {
          // Option 1: Using pushReplacement if HomeScreen is a widget
          // Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const HomeScreen()));
          
          // Option 2: Using pop if you came from Home, or pushNamed if routes are set
          Navigator.of(context).pop(); 
        }),
        title: const Text(
          "Health",
          style: TextStyle(color: textMain, fontWeight: FontWeight.bold, fontSize: 18),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 10),
            const Text(
              "Smart Health Analysis",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: textMain),
            ),
            const SizedBox(height: 15),

            // --- BEHAVIOR ANALYSIS CARD ---
            _buildHealthCard(
              title: "Behavior Check",
              subtitle: "Answer a few questions about your pet's behavior.",
              icon: Icons.assignment_outlined,
              color: const Color(0xFFF3E5F5), // Soft Purple
              iconColor: Colors.purple,
              onTap: () {
                // Future: Navigate to Behavior Question Screen
              },
            ),
            const SizedBox(height: 16),

            // --- IMAGE / SKIN ANALYSIS CARD ---
            _buildHealthCard(
              title: "Upload Image",
              subtitle: "Upload a photo to detect possible skin issues.",
              icon: Icons.camera_alt_outlined,
              color: const Color(0xFFE3F2FD), // Soft Blue
              iconColor: Colors.blue,
              onTap: () {
                // Future: Navigate to Camera/Gallery upload
              },
            ),
            const SizedBox(height: 16),

            // --- SOUND / STRESS ANALYSIS CARD ---
            _buildHealthCard(
              title: "Record Sound",
              subtitle: "Record your pet's sound to analyze stress levels.",
              icon: Icons.mic_none_outlined,
              color: const Color(0xFFE8F5E9), // Soft Green
              iconColor: Colors.green,
              onTap: () {
                // Future: Navigate to Voice Recorder
              },
            ),
            
            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }

  // Card Builder for the Health Modules
  Widget _buildHealthCard({
    required String title,
    required String subtitle,
    required IconData icon,
    required Color color,
    required Color iconColor,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(24),
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: surfaceWhite,
          borderRadius: BorderRadius.circular(24),
          border: Border.all(color: softBorder),
          boxShadow: [
            BoxShadow(
              color: brandOrange.withOpacity(0.03),
              blurRadius: 12,
              offset: const Offset(0, 4),
            )
          ],
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: color,
                borderRadius: BorderRadius.circular(15),
              ),
              child: Icon(icon, color: iconColor, size: 28),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: textMain),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    subtitle,
                    style: const TextStyle(color: Colors.grey, fontSize: 12, height: 1.4),
                  ),
                ],
              ),
            ),
            const Icon(Icons.arrow_forward_ios, size: 14, color: Colors.grey),
          ],
        ),
      ),
    );
  }

  // Circular Button Helper for AppBar
  Widget _buildCircleBtn(IconData icon, VoidCallback tap) {
    return IconButton(
      onPressed: tap,
      icon: Container(
        padding: const EdgeInsets.all(8),
        decoration: const BoxDecoration(
          color: Color(0xFFFFF3E9), 
          shape: BoxShape.circle,
        ),
        child: Icon(icon, color: brandOrange, size: 18),
      ),
    );
  }
}