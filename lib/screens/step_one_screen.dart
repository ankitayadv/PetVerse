import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart'; // ✅ Added Firestore
import 'package:firebase_auth/firebase_auth.dart';    // ✅ Added Auth to get UID

class StepOneScreen extends StatefulWidget {
  const StepOneScreen({super.key});

  @override
  State<StepOneScreen> createState() => _StepOneScreenState();
}

class _StepOneScreenState extends State<StepOneScreen> {
  int dogCount = 0;
  int catCount = 0;
  bool _isSyncing = false; // To show loading state during DB write

  // 🔥 NEW: Firestore Sync Logic
  Future<void> _savePetSelectionToFirestore() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      _showWarningSnackBar("User not authenticated!");
      return;
    }

    setState(() => _isSyncing = true);

    try {
      // We save the basic counts to the user's profile document
      // This helps initialize the dashboard later
      await FirebaseFirestore.instance.collection('users').doc(user.uid).set({
        'onboardingCompleted': false,
        'petStats': {
          'dogCount': dogCount,
          'catCount': catCount,
          'totalPets': dogCount + catCount,
        },
        'updatedAt': FieldValue.serverTimestamp(),
      }, SetOptions(merge: true));

      if (mounted) {
        Navigator.pushNamed(
          context,
          '/steptwo',
          arguments: {
            'maxDogs': dogCount,
            'maxCats': catCount,
            'totalExpected': dogCount + catCount,
          },
        );
      }
    } catch (e) {
      _showWarningSnackBar("Database error: Please try again.");
    } finally {
      if (mounted) setState(() => _isSyncing = false);
    }
  }

  void _handleContinue() {
    if (dogCount + catCount > 0) {
      _savePetSelectionToFirestore(); // ✅ Now calls Firestore before navigating
    } else {
      _showWarningSnackBar("Please add at least one pet to continue!");
    }
  }

  void _showWarningSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          message,
          style: const TextStyle(fontFamily: 'Poppins', fontWeight: FontWeight.w500),
        ),
        backgroundColor: Colors.orange.shade800,
        behavior: SnackBarBehavior.floating,
        margin: const EdgeInsets.all(20),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        duration: const Duration(seconds: 2),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: _buildAppBar(context),
      body: SafeArea(
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          child: Column(
            children: [
              const SizedBox(height: 20),
              _buildHeader(),
              const SizedBox(height: 40),
              _buildPetSelectionGrid(),
              const SizedBox(height: 50),
              _buildTotalBadge(),
              const SizedBox(height: 40),
              _buildPrimaryButton(),
              _buildSkipButton(context),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }

  // --- UI Components (Unchanged except for Loading Indicator in Button) ---

  PreferredSizeWidget _buildAppBar(BuildContext context) {
    return AppBar(
      backgroundColor: Colors.white,
      elevation: 0,
      leadingWidth: 70,
      leading: Center(
        child: Container(
          margin: const EdgeInsets.only(left: 16),
          decoration: BoxDecoration(
            color: Colors.orange.withOpacity(0.1),
            shape: BoxShape.circle,
          ),
          child: IconButton(
            icon: const Icon(Icons.chevron_left, color: Colors.orange, size: 28),
            onPressed: () => Navigator.maybePop(context),
          ),
        ),
      ),
      title: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Text(
            'Step 1 of 5',
            style: TextStyle(
              color: Colors.grey,
              fontSize: 13,
              fontWeight: FontWeight.w600,
              fontFamily: 'Poppins',
            ),
          ),
          const SizedBox(height: 6),
          _buildProgressBar(0), 
        ],
      ),
      centerTitle: true,
    );
  }

  Widget _buildProgressBar(int activeIndex) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: List.generate(5, (index) {
        bool isActive = index == activeIndex;
        return AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          margin: const EdgeInsets.symmetric(horizontal: 2),
          width: isActive ? 22 : 6,
          height: 6,
          decoration: BoxDecoration(
            color: isActive ? Colors.orange : Colors.grey.shade200,
            borderRadius: BorderRadius.circular(10),
          ),
        );
      }),
    );
  }

  Widget _buildHeader() {
    return const Text(
      'How Many Pets Do\nYou Have?',
      textAlign: TextAlign.center,
      style: TextStyle(
        fontSize: 32,
        fontWeight: FontWeight.w900,
        letterSpacing: -0.8,
        height: 1.1,
        color: Color(0xFF2D2D2D),
        fontFamily: 'Poppins',
      ),
    );
  }

  Widget _buildPetSelectionGrid() {
    return Row(
      children: [
        Expanded(
          child: _buildInteractivePetCard(
            'Dog',
            'assets/images/dog_illustration.png',
            dogCount,
            (val) => setState(() => dogCount = val),
            const Color(0xFFFFEEDD),
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: _buildInteractivePetCard(
            'Cat',
            'assets/images/cat_illustration.png',
            catCount,
            (val) => setState(() => catCount = val),
            const Color(0xFFE8F5E9),
          ),
        ),
      ],
    );
  }

  Widget _buildTotalBadge() {
    int total = dogCount + catCount;
    return AnimatedScale(
      scale: total > 0 ? 1.0 : 0.9,
      duration: const Duration(milliseconds: 200),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
        decoration: BoxDecoration(
          color: Colors.orange.withOpacity(0.08),
          borderRadius: BorderRadius.circular(30),
          border: Border.all(color: Colors.orange.withOpacity(0.2)),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.pets_rounded, color: Colors.orange, size: 22),
            const SizedBox(width: 12),
            Text(
              'Total Pets: ',
              style: TextStyle(
                fontSize: 18,
                color: Colors.grey.shade800,
                fontWeight: FontWeight.w500,
                fontFamily: 'Poppins',
              ),
            ),
            Text(
              '$total',
              style: const TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: Colors.orange,
                fontFamily: 'Poppins',
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPrimaryButton() {
    return SizedBox(
      width: double.infinity,
      height: 60,
      child: ElevatedButton(
        onPressed: _isSyncing ? null : _handleContinue, // ✅ Disable while syncing
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.orange,
          foregroundColor: Colors.white,
          elevation: 0,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        ),
        child: _isSyncing 
          ? const CircularProgressIndicator(color: Colors.white) // ✅ Added Loader
          : const Text(
              'Continue',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, fontFamily: 'Poppins'),
            ),
      ),
    );
  }

  Widget _buildSkipButton(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 12),
      child: TextButton(
        onPressed: () => Navigator.pushNamedAndRemoveUntil(context, '/home', (r) => false),
        style: TextButton.styleFrom(foregroundColor: Colors.grey.shade500),
        child: const Text(
          'Skip for Now',
          style: TextStyle(fontSize: 15, fontWeight: FontWeight.w500, fontFamily: 'Poppins'),
        ),
      ),
    );
  }

  Widget _buildInteractivePetCard(String baseTitle, String imagePath, int count, Function(int) onUpdate, Color glowColor) {
    bool isActivated = count > 0;
    String displayTitle = count > 1 ? "${baseTitle}s" : baseTitle;

    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeOutCubic,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isActivated ? glowColor : Colors.white,
        borderRadius: BorderRadius.circular(32),
        border: Border.all(
          color: isActivated ? Colors.orange.withOpacity(0.4) : Colors.grey.shade200,
          width: isActivated ? 2 : 1.5,
        ),
      ),
      child: Column(
        children: [
          GestureDetector(
            onTap: () => count == 0 ? onUpdate(1) : null,
            child: AnimatedOpacity(
              duration: const Duration(milliseconds: 200),
              opacity: isActivated ? 1.0 : 0.5,
              child: Image.asset(imagePath, height: 90, fit: BoxFit.contain, errorBuilder: (context, error, stackTrace) => const Icon(Icons.pets, size: 90, color: Colors.grey)),
            ),
          ),
          const SizedBox(height: 12),
          Text(
            displayTitle,
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w800,
              fontFamily: 'Poppins',
              color: isActivated ? Colors.black87 : Colors.grey.shade400,
            ),
          ),
          const SizedBox(height: 16),
          _buildCounterRow(count, onUpdate, isActivated),
        ],
      ),
    );
  }

  Widget _buildCounterRow(int count, Function(int) onUpdate, bool isActivated) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.03),
            blurRadius: 10,
          )
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          _counterBtn(Icons.remove, () => onUpdate(count - 1), count > 0),
          Text(
            '$count',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: isActivated ? Colors.black87 : Colors.grey,
              fontFamily: 'Poppins',
            ),
          ),
          _counterBtn(Icons.add, () => onUpdate(count + 1), true),
        ],
      ),
    );
  }

  Widget _counterBtn(IconData icon, VoidCallback action, bool active) {
    return IconButton(
      visualDensity: VisualDensity.compact,
      icon: Icon(icon, size: 20, color: active ? Colors.orange : Colors.grey.shade300),
      onPressed: active ? action : null,
    );
  }
}