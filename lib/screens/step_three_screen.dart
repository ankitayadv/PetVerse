import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'dart:io';
import 'dart:convert'; // Added for base64Decode
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'step_four_screen.dart';
import 'step_five_screen.dart';

class StepThreeScreen extends StatefulWidget {
  const StepThreeScreen({super.key});

  @override
  State<StepThreeScreen> createState() => _StepThreeScreenState();
}

class _StepThreeScreenState extends State<StepThreeScreen> {
  final List<Map<String, dynamic>> _petFamily = [];
  int maxDogs = 0;
  int maxCats = 0;
  bool _initialized = false;
  bool _isSyncing = false;

  Map<String, dynamic> _allData = {};

  @override
  Widget build(BuildContext context) {
    if (!_initialized) {
      final args = ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>?;
      _allData = args ?? {};

      maxDogs = int.tryParse(_allData['maxDogs']?.toString() ?? '0') ?? 0;
      maxCats = int.tryParse(_allData['maxCats']?.toString() ?? '0') ?? 0;

      _initialized = true;
    }

    return Scaffold(
      backgroundColor: const Color(0xFFF9F9F9),
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Colors.orange, size: 20),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text("Step 3 of 5", style: TextStyle(color: Colors.grey, fontSize: 14, letterSpacing: 1.1)),
        centerTitle: true,
        backgroundColor: Colors.transparent,
        elevation: 0,
        actions: [
          if (_isSyncing)
            const Padding(
              padding: EdgeInsets.only(right: 16.0),
              child: Center(child: SizedBox(width: 15, height: 15, child: CircularProgressIndicator(strokeWidth: 2, color: Colors.orange))),
            )
        ],
      ),
      body: Column(
        children: [
          const SizedBox(height: 10),
          const Text(
            "Your Pet Family",
            style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold, fontFamily: 'Poppins', color: Color(0xFF2D2D2D)),
          ),
          Text(
            "Added ${_petFamily.length} ${_petFamily.length == 1 ? 'Pet' : 'Pets'} "
            "(${_countByType('Dog')} Dogs, ${_countByType('Cat')} Cats)",
            style: const TextStyle(color: Colors.orange, fontWeight: FontWeight.w600, fontSize: 13),
          ),
          const SizedBox(height: 24),
          _buildPremiumCard(),
          Expanded(
            child: _petFamily.isEmpty
                ? _buildEmptyState()
                : ListView.builder(
                    padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
                    itemCount: _petFamily.length,
                    itemBuilder: (context, index) => _buildPetCard(_petFamily[index], index),
                  ),
          ),
          _buildProfessionalBottomActions(),
        ],
      ),
    );
  }

  // --- Firestore Sync Logic ---
  Future<void> _syncPetFamilyToFirebase() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return;

    setState(() => _isSyncing = true);

    try {
      await FirebaseFirestore.instance.collection('users').doc(user.uid).set({
        'pets': _petFamily,
        'petCount': _petFamily.length,
        'onboardingStep': 3,
        'lastUpdated': FieldValue.serverTimestamp(),
      }, SetOptions(merge: true));
    } catch (e) {
      debugPrint("Firestore Sync Error: $e");
    } finally {
      if (mounted) setState(() => _isSyncing = false);
    }
  }

  int _countByType(String type) => _petFamily.where((p) => p['type'] == type).length;

  Future<void> _navigateToAddPet({bool isEditing = false, int? index}) async {
    final result = await Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => StepFourScreen(
            isEditing: isEditing,
            existingPet: isEditing ? _petFamily[index!] : null,
            currentDogCount: _countByType('Dog'),
            currentCatCount: _countByType('Cat'),
            maxDogs: maxDogs,
            maxCats: maxCats,
          ),
          settings: RouteSettings(
            arguments: {
              'maxDogs': maxDogs,
              'maxCats': maxCats,
              'totalExpected': maxDogs + maxCats,
            },
          ),
        ));

    if (result != null && result is Map<String, dynamic>) {
      setState(() {
        if (isEditing) {
          _petFamily[index!] = result;
        } else {
          _petFamily.add(result);
        }
      });
      await _syncPetFamilyToFirebase();
    }
  }

  void _navigateToStepFive() {
    final Map<String, dynamic> dataToSend = Map.from(_allData);
    dataToSend['pets'] = List<Map<String, dynamic>>.from(_petFamily);

    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => const StepFiveScreen(),
            settings: RouteSettings(arguments: dataToSend)));
  }

  // --- UI Components ---

  Widget _buildPremiumCard() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 24),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: const Color(0xFFF0F8F7),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: Colors.teal.withOpacity(0.1)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Row(
            children: [
              Icon(Icons.auto_awesome, color: Colors.orange, size: 20),
              SizedBox(width: 8),
              Text("PetVerse Premium Perks", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
            ],
          ),
          const SizedBox(height: 12),
          _premiumItem(Icons.favorite_border, "Real-time health tracking"),
          _premiumItem(Icons.location_on_outlined, "Lost & Found network access"),
          _premiumItem(Icons.menu_book_outlined, "Pet care guides"),
          _premiumItem(Icons.medical_services_outlined, "Emergency support"),
          _premiumItem(Icons.analytics_outlined, "Wellness diagnostics"),
        ],
      ),
    );
  }

  Widget _premiumItem(IconData icon, String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 6),
      child: Row(
        children: [
          Icon(icon, size: 18, color: Colors.teal.shade700),
          const SizedBox(width: 12),
          Text(text, style: TextStyle(color: Colors.teal.shade900, fontSize: 13, fontWeight: FontWeight.w500)),
        ],
      ),
    );
  }

  Widget _buildPetCard(Map<String, dynamic> pet, int index) {
    return GestureDetector(
      onTap: () => _navigateToAddPet(isEditing: true, index: index),
      child: Container(
        margin: const EdgeInsets.only(bottom: 16),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(22),
          boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.02), blurRadius: 15, offset: const Offset(0, 4))],
        ),
        child: Row(
          children: [
            // Updated Avatar to use the correct helper
            _buildAvatar(pet['imageBase64']), 
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Text(pet['name'] ?? "Unnamed", style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
                      const SizedBox(width: 4),
                      const Icon(Icons.check_circle_rounded, color: Colors.blue, size: 16),
                    ],
                  ),
                  Text("${pet['type']} • ${pet['breed']} • ${pet['gender']}", style: TextStyle(color: Colors.grey.shade500, fontSize: 12)),
                  if (pet['features'] != null && pet['features'].toString().isNotEmpty)
                    Padding(
                      padding: const EdgeInsets.only(top: 4.0),
                      child: Text("Note: ${pet['features']}", style: const TextStyle(color: Colors.orange, fontSize: 11, fontWeight: FontWeight.w600)),
                    ),
                ],
              ),
            ),
            Column(
              children: [
                Icon(Icons.edit_note_rounded, color: Colors.grey.shade300),
                const SizedBox(height: 8),
                IconButton(
                  icon: Icon(Icons.delete_sweep_outlined, color: Colors.red.shade300),
                  onPressed: () async {
                    setState(() => _petFamily.removeAt(index));
                    await _syncPetFamilyToFirebase();
                  },
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  // UPDATED: Now correctly handles the Base64 String sent from Step 4
  Widget _buildAvatar(String? imageBase64) {
    return Container(
      width: 64,
      height: 64,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(18), 
        color: Colors.orange.shade50,
        border: Border.all(color: Colors.orange.withOpacity(0.1))
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(18),
        child: imageBase64 != null && imageBase64.isNotEmpty
            ? Image.memory(
                base64Decode(imageBase64),
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) => const Icon(Icons.pets, color: Colors.orange),
              )
            : const Icon(Icons.pets, color: Colors.orange, size: 28),
      ),
    );
  }

  Widget _buildProfessionalBottomActions() {
    bool hasPets = _petFamily.isNotEmpty;
    int totalLimit = maxDogs + maxCats;
    bool isFullyComplete = _petFamily.length >= totalLimit && totalLimit > 0;

    return Container(
      padding: const EdgeInsets.fromLTRB(24, 20, 24, 34),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.04), blurRadius: 20, offset: const Offset(0, -8))],
        borderRadius: const BorderRadius.vertical(top: Radius.circular(32)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          SizedBox(
            width: double.infinity,
            height: 58,
            child: ElevatedButton.icon(
              onPressed: isFullyComplete
                  ? () => _showSnackBar("Family goal reached! You can proceed now.")
                  : () => _navigateToAddPet(),
              icon: Icon(isFullyComplete ? Icons.task_alt : Icons.add_rounded, color: Colors.white),
              label: Text(isFullyComplete ? "Family Goals Met" : "Add Another Pet",
                  style: const TextStyle(fontSize: 17, fontWeight: FontWeight.bold, color: Colors.white)),
              style: ElevatedButton.styleFrom(
                backgroundColor: isFullyComplete ? Colors.teal : Colors.orange,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
                elevation: 0,
              ),
            ),
          ),
          if (hasPets) ...[
            const SizedBox(height: 12),
            SizedBox(
              width: double.infinity,
              height: 58,
              child: OutlinedButton(
                onPressed: _showProfessionalDialog,
                style: OutlinedButton.styleFrom(
                  side: const BorderSide(color: Colors.orange, width: 1.5),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
                ),
                child: const Text("Confirm & Proceed", style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold, color: Colors.orange)),
              ),
            ),
          ],
          const SizedBox(height: 10),
          GestureDetector(
            onTap: () => _navigateToStepFive(),
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 8.0),
              child: Text("Skip for now", style: TextStyle(color: Colors.grey.shade500, fontSize: 14, fontWeight: FontWeight.w500)),
            ),
          ),
        ],
      ),
    );
  }

  void _showSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message, style: const TextStyle(fontFamily: 'Poppins')),
        backgroundColor: Colors.teal,
        behavior: SnackBarBehavior.floating,
        margin: const EdgeInsets.all(20),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
    );
  }

  void _showProfessionalDialog() {
    showDialog(
      context: context,
      builder: (context) => Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(28)),
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(color: Colors.orange.withOpacity(0.1), shape: BoxShape.circle),
                child: const Icon(Icons.pets_rounded, color: Colors.orange, size: 32),
              ),
              const SizedBox(height: 20),
              const Text("Are you sure?", style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
              const SizedBox(height: 12),
              const Text(
                "Great! You've added your furry friends to the PetVerse family. Ready to finalize their profiles?",
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 14, color: Colors.grey, height: 1.5),
              ),
              const SizedBox(height: 32),
              Row(
                children: [
                  Expanded(
                    child: TextButton(
                      onPressed: () => Navigator.pop(context),
                      child: Text("Go Back", style: TextStyle(color: Colors.grey.shade500, fontWeight: FontWeight.w700)),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () async {
                        Navigator.pop(context);
                        await _syncPetFamilyToFirebase();
                        _navigateToStepFive();
                      },
                      style: ElevatedButton.styleFrom(backgroundColor: Colors.orange, elevation: 0),
                      child: const Text("Continue", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.pets_rounded, size: 60, color: Colors.grey.shade200),
          const SizedBox(height: 16),
          Text("No pets added yet", style: TextStyle(color: Colors.grey.shade400, fontWeight: FontWeight.w500)),
        ],
      ),
    );
  }
}