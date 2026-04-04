import 'package:flutter/material.dart';
import 'dart:io';
import 'dart:convert'; // Added for base64Decode
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:cloud_firestore/cloud_firestore.dart'; // Added
import 'package:firebase_auth/firebase_auth.dart';    // Added

class StepFiveScreen extends StatefulWidget {
  const StepFiveScreen({super.key});

  @override
  State<StepFiveScreen> createState() => _StepFiveScreenState();
}

class _StepFiveScreenState extends State<StepFiveScreen> {
  int? _selectedPetIndex;
  bool _isSyncing = false; // Added to handle loading state

  final List<Color> _cardColors = [
    const Color(0xFFF0F9FF),
    const Color(0xFFFDF2F8),
    const Color(0xFFECFDF5),
    const Color(0xFFFFF7ED),
    const Color(0xFFF5F3FF),
  ];

  final List<Color> _accentColors = [
    Colors.blue,
    Colors.pink,
    Colors.teal,
    Colors.orange,
    Colors.deepPurple,
  ];

  // ✅ UPDATED: Stores selection in Firestore before navigating
  Future<void> _saveSelectionAndNavigate(Map<String, dynamic> args, List<Map<String, dynamic>> myPets, {int? index}) async {
    setState(() => _isSyncing = true);
    
    Map<String, dynamic> petToLoad = {};
    if (index != null) {
      petToLoad = myPets[index];
    } else if (myPets.isNotEmpty) {
      petToLoad = myPets[0];
    }

    try {
      final user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        // Update Firestore with the selected pet and mark onboarding as complete
        await FirebaseFirestore.instance.collection('users').doc(user.uid).set({
          'selectedPet': petToLoad,
          'allPets': myPets,
          'onboardingComplete': true,
          'lastSelectedAt': FieldValue.serverTimestamp(),
        }, SetOptions(merge: true));
      }
    } catch (e) {
      debugPrint("Error syncing selection: $e");
    }

    if (mounted) {
      Navigator.pushNamedAndRemoveUntil(
        context,
        '/home',
        (r) => false,
        arguments: {
          ...args,
          'selectedPet': petToLoad,
          'allPets': myPets,
        },
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final args = ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>? ?? {};
    final List<Map<String, dynamic>> myPets = (args['pets'] as List<dynamic>?)?.map((e) => Map<String, dynamic>.from(e)).toList() ?? [];

    return Scaffold(
      backgroundColor: const Color(0xFFFBFBFB),
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.close, color: Colors.black54),
          onPressed: () => Navigator.pop(context),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
        actions: [
          if (_isSyncing)
            const Padding(
              padding: EdgeInsets.only(right: 16.0),
              child: Center(child: SizedBox(width: 20, height: 20, child: CircularProgressIndicator(strokeWidth: 2, color: Colors.orange))),
            )
        ],
      ),
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        padding: const EdgeInsets.symmetric(horizontal: 24.0),
        child: Column(
          children: [
            const Icon(Icons.stars_rounded, color: Colors.orange, size: 60),
            const SizedBox(height: 16),
            const Text(
              "Registration Complete!",
              textAlign: TextAlign.center,
              style: TextStyle(
                  fontSize: 26,
                  fontWeight: FontWeight.w900,
                  color: Color(0xFF2D2D2D),
                  fontFamily: 'Poppins'),
            ),
            const SizedBox(height: 8),
            const Text(
              "Select a pet to view their personal dashboard.",
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.grey, fontSize: 15, fontFamily: 'Poppins'),
            ),
            const SizedBox(height: 35),

            myPets.isEmpty
                ? _buildEmptyState()
                : ListView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: myPets.length,
                    itemBuilder: (context, index) {
                      bool isSelected = _selectedPetIndex == index;
                      Color bgColor = _cardColors[index % _cardColors.length];
                      Color accentColor = _accentColors[index % _accentColors.length];

                      return GestureDetector(
                        onTap: () => setState(() => _selectedPetIndex = index),
                        child: _buildEnhancedPetCard(myPets[index], isSelected, bgColor, accentColor),
                      );
                    },
                  ),

            const SizedBox(height: 30),

            SizedBox(
              width: double.infinity,
              height: 62,
              child: ElevatedButton(
                onPressed: (_selectedPetIndex == null || _isSyncing)
                    ? null
                    : () => _saveSelectionAndNavigate(args, myPets, index: _selectedPetIndex),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.orange,
                  foregroundColor: Colors.white,
                  disabledBackgroundColor: Colors.grey.shade300,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                  elevation: 0,
                ),
                child: Text(
                  _selectedPetIndex == null
                      ? "Select a Pet"
                      : "Go to ${myPets[_selectedPetIndex!]['name']}'s Dashboard",
                  style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, fontFamily: 'Poppins'),
                ),
              ),
            ),

            const SizedBox(height: 16),

            GestureDetector(
              onTap: _isSyncing ? null : () => _saveSelectionAndNavigate(args, myPets),
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 8.0),
                child: Text(
                  "Skip for now",
                  style: TextStyle(
                    color: Colors.grey.shade500,
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                    fontFamily: 'Poppins',
                  ),
                ),
              ),
            ),
            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }

  // --- UI HELPERS ---

  Widget _buildEnhancedPetCard(Map<String, dynamic> pet, bool isSelected, Color bgColor, Color accentColor) {
    final bool isMale = pet['gender']?.toString().toLowerCase() == "male";
    // UPDATED: Look for imageBase64 instead of File path
    final String? imageBase64 = pet['imageBase64'];

    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      margin: const EdgeInsets.only(bottom: 24),
      decoration: BoxDecoration(
        color: isSelected ? bgColor : Colors.white,
        borderRadius: BorderRadius.circular(28),
        border: Border.all(
          color: isSelected ? Colors.orange : Colors.transparent,
          width: 2,
        ),
        boxShadow: [
          BoxShadow(
            color: isSelected ? Colors.orange.withOpacity(0.1) : Colors.black.withOpacity(0.04),
            blurRadius: 20,
            offset: const Offset(0, 8),
          )
        ],
      ),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(20),
            child: Row(
              children: [
                _buildAvatar(imageBase64, accentColor),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Text(
                            pet['name'] ?? 'Unnamed',
                            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 20, fontFamily: 'Poppins'),
                          ),
                          if (isSelected) ...[
                            const SizedBox(width: 8),
                            const Icon(Icons.check_circle, color: Colors.orange, size: 20),
                          ]
                        ],
                      ),
                      Text(
                        "${pet['type']} • ${pet['breed']}",
                        style: TextStyle(color: accentColor, fontWeight: FontWeight.w600, fontSize: 13, fontFamily: 'Poppins'),
                      ),
                    ],
                  ),
                ),
                _genderTag(isMale, pet['gender'] ?? "N/A"),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(vertical: 18, horizontal: 20),
            decoration: BoxDecoration(color: accentColor.withOpacity(0.05)),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    _dataPoint(Icons.cake_outlined, "${pet['age'] ?? '0'} Yrs", "Age", accentColor),
                    _dataPoint(Icons.monitor_weight_outlined, "${pet['weight'] ?? '0'} kg", "Weight", accentColor),
                    _dataPoint(Icons.height_outlined, "${pet['height'] ?? '0'} cm", "Height", accentColor),
                  ],
                ),
                const Padding(
                  padding: EdgeInsets.symmetric(vertical: 10),
                  child: Divider(height: 1, color: Colors.black12),
                ),
                _dataPoint(Icons.bloodtype_outlined, "Blood Group: ${pet['blood'] ?? 'Unknown'}", "Medical Info", accentColor),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              children: [
                _buildDetailRow(Icons.auto_awesome_outlined, "Distinguishing Features", pet['features']?.toString() ?? "None", accentColor),
                const SizedBox(height: 12),
                _buildDetailRow(Icons.history_edu_outlined, "Medical History", pet['disease']?.toString() ?? "None", accentColor),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDetailRow(IconData icon, String title, String value, Color accent) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, size: 20, color: accent.withOpacity(0.5)),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(title, style: const TextStyle(fontSize: 11, color: Colors.grey, fontWeight: FontWeight.bold)),
              Text(value, style: const TextStyle(fontSize: 14, color: Colors.black87, height: 1.3)),
            ],
          ),
        ),
      ],
    );
  }

  // UPDATED: Now renders Base64 string from Step 4
  Widget _buildAvatar(String? imageBase64, Color accent) {
    return Container(
      width: 75, height: 75,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(22), 
        color: accent.withOpacity(0.1),
        border: Border.all(color: accent.withOpacity(0.1)),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(22),
        child: imageBase64 != null && imageBase64.isNotEmpty
            ? Image.memory(
                base64Decode(imageBase64),
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) => Icon(Icons.pets, color: accent, size: 30),
              )
            : Icon(Icons.pets, color: accent, size: 30),
      ),
    );
  }

  Widget _genderTag(bool isMale, String gender) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: isMale ? Colors.blue.shade50 : Colors.pink.shade50,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(gender, style: TextStyle(color: isMale ? Colors.blue : Colors.pink, fontWeight: FontWeight.bold, fontSize: 12)),
    );
  }

  Widget _dataPoint(IconData icon, String value, String label, Color accent) {
    return Column(
      children: [
        Row(
          children: [
            Icon(icon, size: 16, color: accent),
            const SizedBox(width: 4),
            Text(value, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14, color: Colors.black87)),
          ],
        ),
        const SizedBox(height: 2),
        Text(label, style: const TextStyle(fontSize: 10, color: Colors.grey))
      ],
    );
  }

  Widget _buildEmptyState() {
    return const Padding(
      padding: EdgeInsets.symmetric(vertical: 50),
      child: Center(
        child: Text(
          "No pets added to your family yet.",
          style: TextStyle(color: Colors.grey, fontFamily: 'Poppins'),
        ),
      ),
    );
  }
}