import 'package:flutter/material.dart';

class StepTwoScreen extends StatefulWidget {
  const StepTwoScreen({super.key});

  @override
  State<StepTwoScreen> createState() => _StepTwoScreenState();
}

class _StepTwoScreenState extends State<StepTwoScreen> {
  // Demo Data
  final List<String> _ageOptions = List.generate(83, (index) => "${index + 18} Years");
  final List<String> _cities = ["New York, NY", "Los Angeles, CA", "Chicago, IL", "Houston, TX", "Phoenix, AZ"];

  // Selected Values
  String? _selectedAge = "28 Years";
  String? _selectedCity = "New York, NY";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Colors.orange),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text("Step 2 of 5", style: TextStyle(color: Colors.black, fontSize: 16, fontWeight: FontWeight.bold)),
        centerTitle: true,
        backgroundColor: Colors.white,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Center(
              child: Column(
                children: [
                  Text(
                    "Tell Us About You (Owner)",
                    style: TextStyle(fontSize: 24, fontWeight: FontWeight.w900, color: Color(0xFF2D2D2D)),
                  ),
                  SizedBox(height: 8),
                  Text(
                    "This helps us personalize your experience.",
                    style: TextStyle(color: Colors.grey, fontSize: 15),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 35),

            // Full Name - Regular Input
            _buildSectionLabel("Full Name"),
            _buildTextFormField(hint: "Enter your name"),

            // Phone Number - With Verified Badge
            _buildSectionLabel("Phone Number"),
            _buildTextFormField(
              hint: "+1 (123) 456-7890",
              suffix: _buildVerifiedBadge(),
            ),

            // Age Dropdown
            _buildSectionLabel("Your Age"),
            _buildDropdown(
              value: _selectedAge,
              items: _ageOptions,
              onChanged: (val) => setState(() => _selectedAge = val),
            ),

            // City/Location Dropdown
            _buildSectionLabel("City / Location"),
            _buildDropdown(
              value: _selectedCity,
              items: _cities,
              icon: Icons.location_on_outlined,
              onChanged: (val) => setState(() => _selectedCity = val),
            ),

            const SizedBox(height: 25),

            // Security Note
            _buildSecurityNote(),

            const SizedBox(height: 40),

            // Continue Button
            _buildContinueButton(context),

            Center(
              child: TextButton(
                onPressed: () {},
                child: const Text("Skip for Now", style: TextStyle(color: Colors.grey, fontSize: 16)),
              ),
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  // --- Helper UI Builders ---

  Widget _buildSectionLabel(String label) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8, top: 16),
      child: Text(label, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14, color: Colors.black87)),
    );
  }

  Widget _buildTextFormField({required String hint, Widget? suffix}) {
    return TextFormField(
      decoration: InputDecoration(
        hintText: hint,
        filled: true,
        fillColor: const Color(0xFFF8F8F8),
        suffixIcon: suffix,
        contentPadding: const EdgeInsets.all(18),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(15), borderSide: BorderSide.none),
        enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(15), borderSide: const BorderSide(color: Color(0xFFEEEEEE))),
      ),
    );
  }

  Widget _buildDropdown({
    required String? value,
    required List<String> items,
    required ValueChanged<String?> onChanged,
    IconData? icon,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        color: const Color(0xFFF8F8F8),
        borderRadius: BorderRadius.circular(15),
        border: Border.all(color: const Color(0xFFEEEEEE)),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          value: value,
          isExpanded: true,
          icon: Icon(icon ?? Icons.keyboard_arrow_down, color: Colors.grey),
          items: items.map((String item) {
            return DropdownMenuItem(value: item, child: Text(item));
          }).toList(),
          onChanged: onChanged,
        ),
      ),
    );
  }

  Widget _buildVerifiedBadge() {
    return Container(
      margin: const EdgeInsets.all(10),
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(color: const Color(0xFFE8F5E9), borderRadius: BorderRadius.circular(20)),
      child: const Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.check_circle, color: Colors.green, size: 14),
          SizedBox(width: 4),
          Text("Verified", style: TextStyle(color: Colors.green, fontSize: 12, fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }

  Widget _buildSecurityNote() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(color: Colors.orange.withOpacity(0.05), borderRadius: BorderRadius.circular(15)),
      child: const Row(
        children: [
          Icon(Icons.lock_outline, color: Colors.orange, size: 22),
          SizedBox(width: 15),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text("Your info is secure & private", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
                Text("We'll use your location for lost pet alerts.", style: TextStyle(fontSize: 12, color: Colors.grey)),
              ],
            ),
          )
        ],
      ),
    );
  }

  Widget _buildContinueButton(BuildContext context) {
    return Container(
      width: double.infinity,
      height: 60,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(18),
        boxShadow: [
          BoxShadow(color: Colors.orange.withOpacity(0.3), blurRadius: 10, offset: const Offset(0, 5)),
        ],
      ),
      child: ElevatedButton(
        onPressed: () => Navigator.pushNamed(context, '/stepthree'),
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.orange,
          foregroundColor: Colors.white,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
          elevation: 0,
        ),
        child: const Text("Continue", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
      ),
    );
  }
}