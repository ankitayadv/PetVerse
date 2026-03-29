import 'package:flutter/material.dart';

class StepOneScreen extends StatefulWidget {
  const StepOneScreen({super.key});

  @override
  State<StepOneScreen> createState() => _StepOneScreenState();
}

class _StepOneScreenState extends State<StepOneScreen> {
  int dogCount = 0;
  int catCount = 0;

  // ✅ VALIDATION: Ensure at least one pet is selected before proceeding
  void _handleContinue() {
    if (dogCount + catCount > 0) {
      Navigator.pushNamed(context, '/steptwo');
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text("Please add at least one pet to continue!"),
          backgroundColor: Colors.orange.shade700,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Container(
            decoration: BoxDecoration(
              color: Colors.orange.withOpacity(0.1),
              shape: BoxShape.circle,
            ),
            child: IconButton(
              icon: const Icon(Icons.chevron_left, color: Colors.orange, size: 24),
              onPressed: () => Navigator.pop(context),
            ),
          ),
        ),
        title: Column(
          children: [
            const Text(
              'Step 1 of 5',
              style: TextStyle(
                color: Colors.grey, 
                fontSize: 14, 
                fontWeight: FontWeight.w600,
                fontFamily: 'Poppins'
              ),
            ),
            const SizedBox(height: 4),
            Row(
              mainAxisSize: MainAxisSize.min,
              children: List.generate(5, (index) => Container(
                margin: const EdgeInsets.symmetric(horizontal: 2),
                width: index == 0 ? 20 : 6,
                height: 6,
                decoration: BoxDecoration(
                  color: index == 0 ? Colors.orange : Colors.grey.shade300,
                  borderRadius: BorderRadius.circular(10),
                ),
              )),
            )
          ],
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          child: Column(
            children: [
              const SizedBox(height: 30),
              const Text(
                'How Many Pets Do\nYou Have?',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 30,
                  fontWeight: FontWeight.w900,
                  letterSpacing: -0.5,
                  height: 1.1,
                  color: Color(0xFF2D2D2D),
                  fontFamily: 'Poppins'
                ),
              ),
              
              const SizedBox(height: 40),
              
              Row(
                children: [
                  Expanded(
                    child: _buildInteractivePetCard(
                      'Dogs', 
                      'assets/images/dog_illustration.png', 
                      dogCount, 
                      (val) => setState(() => dogCount = val),
                      const Color(0xFFFFEEDD),
                    ),
                  ),
                  const SizedBox(width: 20),
                  Expanded(
                    child: _buildInteractivePetCard(
                      'Cats', 
                      'assets/images/cat_illustration.png', 
                      catCount, 
                      (val) => setState(() => catCount = val),
                      const Color(0xFFE8F5E9),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 50),

              // Total Counter
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                decoration: BoxDecoration(
                  color: Colors.orange.withOpacity(0.05),
                  borderRadius: BorderRadius.circular(30),
                  border: Border.all(color: Colors.orange.withOpacity(0.1)),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(Icons.pets, color: Colors.orange, size: 20),
                    const SizedBox(width: 12),
                    Text(
                      'Total Pets: ',
                      style: TextStyle(
                        fontSize: 18, 
                        color: Colors.grey.shade700, 
                        fontWeight: FontWeight.w500,
                        fontFamily: 'Poppins'
                      ),
                    ),
                    Text(
                      '${dogCount + catCount}',
                      style: const TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        color: Colors.orange,
                        fontFamily: 'Poppins'
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 40),

              // ✅ Correctly placed Continue Button
              Container(
                margin: const EdgeInsets.only(bottom: 20),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(18),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.orange.withOpacity(0.3),
                      blurRadius: 12,
                      offset: const Offset(0, 6),
                    ),
                  ],
                ),
                child: SizedBox(
                  width: double.infinity,
                  height: 60,
                  child: ElevatedButton(
                    onPressed: _handleContinue, // ✅ Added validation check
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.orange,
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
                      elevation: 0,
                    ),
                    child: const Text(
                      'Continue',
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, fontFamily: 'Poppins'),
                    ),
                  ),
                ),
              ),
              
              TextButton(
                onPressed: () {
                  // Skip logic can lead to Home if user has no pets to add
                  Navigator.pushNamedAndRemoveUntil(context, '/home', (route) => false);
                },
                style: TextButton.styleFrom(foregroundColor: Colors.grey),
                child: const Text('Skip for Now', style: TextStyle(fontSize: 16, fontFamily: 'Poppins')),
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildInteractivePetCard(String title, String imagePath, int count, Function(int) onUpdate, Color glowColor) {
    bool isActivated = count > 0;

    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isActivated ? glowColor : Colors.white,
        borderRadius: BorderRadius.circular(32),
        border: Border.all(
          color: isActivated ? Colors.orange.withOpacity(0.5) : Colors.grey.shade200,
          width: isActivated ? 2 : 1.5,
        ),
        boxShadow: [
          if (isActivated)
            BoxShadow(
              color: Colors.orange.withOpacity(0.15),
              blurRadius: 20,
              offset: const Offset(0, 8),
            ),
        ],
      ),
      child: Column(
        children: [
          GestureDetector(
            onTap: () {
              if (count == 0) onUpdate(1);
            },
            child: Opacity(
              opacity: isActivated ? 1.0 : 0.6,
              child: Image.asset(imagePath, height: 100, fit: BoxFit.contain),
            ),
          ),
          const SizedBox(height: 12),
          Text(
            title,
            style: TextStyle(
              fontSize: 20, 
              fontWeight: FontWeight.w800,
              fontFamily: 'Poppins',
              color: isActivated ? Colors.black87 : Colors.grey.shade400,
            ),
          ),
          const SizedBox(height: 16),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 4),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(15),
              border: Border.all(color: Colors.grey.shade100),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _counterBtn(Icons.remove, () => onUpdate(count > 0 ? count - 1 : 0), count > 0),
                Text(
                  '$count',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.grey.shade700, fontFamily: 'Poppins'),
                ),
                _counterBtn(Icons.add, () => onUpdate(count + 1), true),
              ],
            ),
          )
        ],
      ),
    );
  }

  Widget _counterBtn(IconData icon, VoidCallback action, bool active) {
    return IconButton(
      visualDensity: VisualDensity.compact,
      icon: Icon(icon, size: 18, color: active ? Colors.orange : Colors.grey.shade300),
      onPressed: active ? action : null,
    );
  }
}