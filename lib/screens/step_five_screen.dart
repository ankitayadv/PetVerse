import 'package:flutter/material.dart';

class StepFiveScreen extends StatelessWidget {
  const StepFiveScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // ✅ RECEIVE DATA FROM PREVIOUS STEPS
    final List<Map<String, String>> myPets =
        (ModalRoute.of(context)?.settings.arguments as List<Map<String, String>>?) ?? [];

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        leading: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Container(
            decoration: BoxDecoration(
              color: Colors.orange.withOpacity(0.1),
              shape: BoxShape.circle,
            ),
            child: IconButton(
              icon: const Icon(Icons.arrow_back_ios_new, color: Colors.orange, size: 18),
              onPressed: () => Navigator.pop(context),
            ),
          ),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 24.0),
        child: Column(
          children: [
            const SizedBox(height: 10),

            // ✅ HEADER SECTION
            const Text(
              "✨ All Pets Added! ✨",
              style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.w900,
                  color: Color(0xFF2D2D2D),
                  fontFamily: 'Poppins'),
            ),
            const SizedBox(height: 8),
            const Text(
              "Your pet family is all set up and ready.",
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.grey, fontSize: 16, fontFamily: 'Poppins'),
            ),

            const SizedBox(height: 40),

            // ✅ CELEBRATION AVATAR STACK
            SizedBox(
              height: 140,
              width: double.infinity,
              child: Stack(
                alignment: Alignment.center,
                children: [
                  // Left Pet
                  if (myPets.length > 1)
                    Positioned(
                      left: MediaQuery.of(context).size.width * 0.15,
                      child: _celebrationAvatar('assets/images/onboarding_page2.png', 38),
                    ),
                  // Right Pet
                  if (myPets.length > 2)
                    Positioned(
                      right: MediaQuery.of(context).size.width * 0.15,
                      child: _celebrationAvatar('assets/images/onboarding_page3.png', 38),
                    ),
                  // Main Center Pet
                  _celebrationAvatar('assets/images/onboarding_page1.png', 55, isMain: true),
                ],
              ),
            ),

            const SizedBox(height: 40),

            // ✅ SELECTION LIST HEADER
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "Select a profile (${myPets.length})",
                  style: const TextStyle(
                    fontWeight: FontWeight.bold, 
                    fontSize: 18, 
                    fontFamily: 'Poppins'
                  ),
                ),
                const Icon(Icons.info_outline, color: Colors.grey, size: 20),
              ],
            ),

            const SizedBox(height: 20),

            // ✅ INTERACTIVE PET LIST
            myPets.isEmpty 
              ? const Padding(
                  padding: EdgeInsets.symmetric(vertical: 20),
                  child: Text("No pets found. Try adding one!", style: TextStyle(fontFamily: 'Poppins')),
                )
              : ListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: myPets.length,
                  itemBuilder: (context, index) {
                    final pet = myPets[index];
                    return _buildInteractivePetCard(context, pet);
                  },
                ),

            const SizedBox(height: 30),

            // ✅ GLOBAL NAVIGATION BUTTON
            SizedBox(
              width: double.infinity,
              height: 60,
              child: ElevatedButton(
                onPressed: () {
                  // Standard redirect to the main dashboard
                  Navigator.pushNamedAndRemoveUntil(
                      context, '/home', (r) => false);
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.orange,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(18)),
                  elevation: 4,
                  shadowColor: Colors.orange.withOpacity(0.3),
                ),
                child: const Text(
                  "Continue to Home",
                  style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                      fontFamily: 'Poppins'),
                ),
              ),
            ),
            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }

  // ✅ HELPER: Stylized Avatars for the Stack
  Widget _celebrationAvatar(String assetPath, double radius, {bool isMain = false}) {
    return Container(
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(color: Colors.white, width: isMain ? 5 : 3),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 15,
            offset: const Offset(0, 8),
          )
        ],
      ),
      child: CircleAvatar(
        radius: radius,
        backgroundColor: const Color(0xFFFFF3E0),
        backgroundImage: AssetImage(assetPath),
      ),
    );
  }

  // ✅ HELPER: Pet Card with Individual Home Directing
  Widget _buildInteractivePetCard(BuildContext context, Map<String, String> pet) {
    bool isMale = pet['gender'] == "Male";
    
    return GestureDetector(
      onTap: () {
        // ✅ NAVIGATION: Passes the clicked pet's data to the Home Screen
        Navigator.pushNamedAndRemoveUntil(
          context, 
          '/home', 
          (route) => false, 
          arguments: pet 
        );
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 16),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: const Color(0xFFF2F2F2)),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.04),
              blurRadius: 10,
              offset: const Offset(0, 4),
            )
          ],
        ),
        child: Row(
          children: [
            CircleAvatar(
              radius: 28,
              backgroundColor: const Color(0xFFFDF7F0),
              backgroundImage: AssetImage(
                pet['breed']?.toLowerCase().contains('cat') == true 
                ? 'assets/images/onboarding_page2.png' 
                : 'assets/images/onboarding_page1.png'
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    pet['name'] ?? 'Pet',
                    style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 17, fontFamily: 'Poppins'),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    "${pet['breed']} • ${pet['age']}",
                    style: const TextStyle(color: Colors.grey, fontSize: 13, fontFamily: 'Poppins'),
                  ),
                ],
              ),
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: isMale ? Colors.blue.shade50 : Colors.pink.shade50,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text(
                pet['gender'] ?? '',
                style: TextStyle(
                  color: isMale ? Colors.blue : Colors.pink,
                  fontWeight: FontWeight.bold,
                  fontSize: 12,
                  fontFamily: 'Poppins'
                ),
              ),
            ),
            const SizedBox(width: 8),
            const Icon(Icons.arrow_forward_ios, color: Color(0xFFD0D0D0), size: 14),
          ],
        ),
      ),
    );
  }
}