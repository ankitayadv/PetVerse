import 'package:flutter/material.dart';
import '../routes/app_routes.dart';

class StepThreeScreen extends StatefulWidget {
  const StepThreeScreen({super.key});

  @override
  State<StepThreeScreen> createState() => _StepThreeScreenState();
}

class _StepThreeScreenState extends State<StepThreeScreen> {

  List<Map<String, String>> addedPets = [];

  // ✅ FIXED NAVIGATION (SAFE TYPE)
  Future<void> _navigateAndAddPet() async {
    final result = await Navigator.pushNamed(context, AppRoutes.stepFour);

    if (result != null && result is Map) {
      setState(() {
        addedPets.add(Map<String, String>.from(result));
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,

      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Colors.orange, size: 20),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          "Step 3 of 5",
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 16),
        ),
        centerTitle: true,
        backgroundColor: Colors.white,
        elevation: 0,
      ),

      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [

            const SizedBox(height: 10),

            const Text(
              "Let's Add Your Pets!",
              style: TextStyle(
                fontSize: 26,
                fontWeight: FontWeight.w900,
                color: Color(0xFF2D2D2D),
              ),
            ),

            const SizedBox(height: 8),

            const Text(
              "Add details for each pet individually.",
              style: TextStyle(color: Colors.grey, fontSize: 15),
            ),

            const SizedBox(height: 25),

            _buildBenefitCard(),

            const SizedBox(height: 25),

            // ✅ EMPTY STATE IMPROVED
            if (addedPets.isEmpty)
              Center(
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 60),
                  child: Column(
                    children: [
                      Icon(Icons.pets_outlined,
                          size: 60, color: Colors.grey.withOpacity(0.3)),
                      const SizedBox(height: 10),
                      const Text(
                        "No pets added yet",
                        style: TextStyle(color: Colors.grey),
                      ),
                    ],
                  ),
                ),
              )
            else
              ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: addedPets.length,
                itemBuilder: (context, index) {
                  final pet = addedPets[index];

                  return _buildPetItem(
                    pet['name'] ?? 'Buddy',
                    "${pet['breed']} • ${pet['age']} • ${pet['gender']}",
                  );
                },
              ),

            const SizedBox(height: 25),

            // ✅ BUTTON IMPROVED
            SizedBox(
              width: double.infinity,
              height: 60,
              child: ElevatedButton(
                onPressed: _navigateAndAddPet,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.orange,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(18)),
                  elevation: 0,
                ),
                child: Text(
                  addedPets.isEmpty ? "Add First Pet" : "Add Another Pet",
                  style: const TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.bold),
                ),
              ),
            ),

            const SizedBox(height: 10),

            TextButton(
              onPressed: () =>
                  Navigator.pushNamed(context, AppRoutes.stepFive),
              child: Text(
                addedPets.isEmpty ? "Skip for Now" : "Confirm & Continue",
                style: TextStyle(
                  color: addedPets.isEmpty ? Colors.grey : Colors.orange,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),

            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  // ✅ CLEAN BENEFIT CARD
  Widget _buildBenefitCard() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: const Color(0xFFF4FBF9),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildBenefitRow(Icons.lightbulb_outline,
              "Adding each pet helps us provide:"),
          const SizedBox(height: 15),
          _buildBenefitRow(Icons.campaign_outlined, "Lost pet alerts",
              isSubItem: true),
          _buildBenefitRow(Icons.auto_awesome_outlined,
              "Smart recommendations",
              isSubItem: true),
          _buildBenefitRow(Icons.favorite_border, "Health reminders",
              isSubItem: true),
        ],
      ),
    );
  }

  Widget _buildBenefitRow(IconData icon, String text,
      {bool isSubItem = false}) {
    return Padding(
      padding: EdgeInsets.only(bottom: isSubItem ? 8.0 : 0),
      child: Row(
        children: [
          Icon(icon,
              color: isSubItem ? Colors.teal : Colors.orange,
              size: isSubItem ? 18 : 22),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              text,
              style: TextStyle(
                fontSize: isSubItem ? 13 : 14,
                fontWeight:
                    isSubItem ? FontWeight.w500 : FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ✅ BEAUTIFUL PET CARD (LIKE YOUR DESIGN)
  Widget _buildPetItem(String name, String details) {
    return Container(
      margin: const EdgeInsets.only(bottom: 14),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: const Color(0xFFF2F2F2)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [

          // 🔥 IMPROVED AVATAR
          Container(
            height: 55,
            width: 55,
            decoration: const BoxDecoration(
              shape: BoxShape.circle,
              color: Color(0xFFFDF7F0),
            ),
            child: const Icon(Icons.pets, color: Colors.orange, size: 30),
          ),

          const SizedBox(width: 14),

          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  name,
                  style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                      color: Color(0xFF2D2D2D)),
                ),
                const SizedBox(height: 3),
                Text(
                  details,
                  style: const TextStyle(
                      color: Colors.grey, fontSize: 13),
                ),
              ],
            ),
          ),

          // 🔥 STATUS CHIP
          Container(
            padding:
                const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
            decoration: BoxDecoration(
              color: const Color(0xFFE8F5E9),
              borderRadius: BorderRadius.circular(8),
            ),
            child: const Text(
              "Added",
              style: TextStyle(
                  color: Colors.green,
                  fontSize: 11,
                  fontWeight: FontWeight.bold),
            ),
          ),
        ],
      ),
    );
  }
}