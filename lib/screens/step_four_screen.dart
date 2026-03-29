import 'package:flutter/material.dart';

class StepFourScreen extends StatefulWidget {
  const StepFourScreen({super.key});

  @override
  State<StepFourScreen> createState() => _StepFourScreenState();
}

class _StepFourScreenState extends State<StepFourScreen> {

  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _weightController = TextEditingController();

  String? _selectedBreed = "Golden Retriever";
  String? _selectedAge = "3 Years";
  String _selectedGender = "Male";

  final List<String> _breeds = [
    "Golden Retriever",
    "Beagle",
    "German Shepherd",
    "Domestic Shorthair"
  ];

  final List<String> _ages = [
    "1 Year",
    "2 Years",
    "3 Years",
    "4 Years",
    "5+ Years"
  ];

  @override
  void dispose() {
    _nameController.dispose();
    _weightController.dispose();
    super.dispose();
  }

  void _finishAndReturnData() {
    if (_nameController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Please enter a pet name")),
      );
      return;
    }

    Navigator.pop(context, {
      "name": _nameController.text,
      "breed": _selectedBreed ?? "Unknown",
      "age": _selectedAge ?? "Unknown",
      "gender": _selectedGender,
      "weight": _weightController.text.isEmpty ? "0" : _weightController.text,
    });
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
          "Step 4 of 5",
          style: TextStyle(
              color: Colors.black,
              fontSize: 16,
              fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        backgroundColor: Colors.white,
        elevation: 0,
      ),

      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [

              const SizedBox(height: 10),

              // TITLE
              Text(
                "Pet Profile: ${_nameController.text.isEmpty ? 'Buddy' : _nameController.text}",
                style: const TextStyle(
                  fontSize: 26,
                  fontWeight: FontWeight.w900,
                  color: Color(0xFF2D2D2D),
                ),
              ),

              const SizedBox(height: 5),

              const Text(
                "Tell us more about your pet.",
                style: TextStyle(color: Colors.grey, fontSize: 15),
              ),

              const SizedBox(height: 30),

              // ✅ FIXED AVATAR (NO IMAGE, CLEAN UI)
              Stack(
                children: [
                  Container(
                    height: 140,
                    width: 140,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: const Color(0xFFF8F8F8),
                      border: Border.all(
                        color: Colors.orange.withOpacity(0.2),
                        width: 6,
                      ),
                    ),
                    child: Center(
                      child: Text(
                        _nameController.text.isEmpty
                            ? "A"
                            : _nameController.text[0].toUpperCase(),
                        style: const TextStyle(
                          fontSize: 42,
                          fontWeight: FontWeight.bold,
                          color: Colors.orange,
                        ),
                      ),
                    ),
                  ),

                  Positioned(
                    bottom: 5,
                    right: 5,
                    child: Container(
                      decoration: const BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.orange,
                      ),
                      padding: const EdgeInsets.all(10),
                      child: const Icon(Icons.camera_alt,
                          color: Colors.white, size: 18),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 35),

              _buildStylizedField(
                controller: _nameController,
                hint: "Pet Name",
                icon: Icons.edit_outlined,
              ),

              const SizedBox(height: 16),

              _buildDropdownField(
                value: _selectedBreed,
                icon: Icons.pets,
                items: _breeds,
                onChanged: (val) => setState(() => _selectedBreed = val),
              ),

              const SizedBox(height: 16),

              _buildDropdownField(
                value: _selectedAge,
                icon: Icons.access_time,
                items: _ages,
                onChanged: (val) => setState(() => _selectedAge = val),
              ),

              const SizedBox(height: 16),

              _buildSegmentedGenderToggle(),

              const SizedBox(height: 16),

              _buildStylizedField(
                controller: _weightController,
                hint: "Weight (Optional)",
                icon: Icons.monitor_weight,
                suffix: "kg",
                isNumber: true,
              ),

              const SizedBox(height: 40),

              // ✅ FIXED BUTTON STYLE
              SizedBox(
                width: double.infinity,
                height: 60,
                child: ElevatedButton(
                  onPressed: _finishAndReturnData,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.orange,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(18)),
                    elevation: 0,
                  ),
                  child: const Text(
                    "Finish & Add Pet",
                    style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.white),
                  ),
                ),
              ),

              const SizedBox(height: 10),

              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text(
                  "Skip for Now",
                  style: TextStyle(color: Colors.grey),
                ),
              ),

              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }

  // --------------------

  Widget _buildStylizedField({
    required TextEditingController controller,
    required String hint,
    required IconData icon,
    String? suffix,
    bool isNumber = false,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFFF8F8F8),
        borderRadius: BorderRadius.circular(15),
      ),
      child: TextField(
        controller: controller,
        keyboardType:
            isNumber ? TextInputType.number : TextInputType.text,
        onChanged: (v) => setState(() {}),
        decoration: InputDecoration(
          prefixIcon: Icon(icon, color: Colors.teal[300]),
          hintText: hint,
          border: InputBorder.none,
          suffixText: suffix,
          contentPadding: const EdgeInsets.all(18),
        ),
      ),
    );
  }

  Widget _buildDropdownField({
    required String? value,
    required IconData icon,
    required List<String> items,
    required Function(String?) onChanged,
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
          icon: const Icon(Icons.expand_more, color: Colors.grey),
          items: items.map((item) {
            return DropdownMenuItem<String>(
              value: item,
              child: Row(
                children: [
                  Icon(icon, color: Colors.teal[300], size: 20),
                  const SizedBox(width: 10),
                  Text(item),
                ],
              ),
            );
          }).toList(),
          onChanged: onChanged,
        ),
      ),
    );
  }

  Widget _buildSegmentedGenderToggle() {
    return Container(
      height: 55,
      decoration: BoxDecoration(
        color: const Color(0xFFF8F8F8),
        borderRadius: BorderRadius.circular(15),
      ),
      child: Row(
        children: ["Male", "Female"].map((gender) {
          bool isSelected = _selectedGender == gender;

          return Expanded(
            child: GestureDetector(
              onTap: () => setState(() => _selectedGender = gender),
              child: Container(
                margin: const EdgeInsets.all(4),
                decoration: BoxDecoration(
                  color: isSelected ? Colors.white : Colors.transparent,
                  borderRadius: BorderRadius.circular(12),
                ),
                alignment: Alignment.center,
                child: Text(
                  gender,
                  style: TextStyle(
                    fontWeight:
                        isSelected ? FontWeight.bold : FontWeight.normal,
                    color:
                        isSelected ? Colors.orange : Colors.grey,
                  ),
                ),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }
}