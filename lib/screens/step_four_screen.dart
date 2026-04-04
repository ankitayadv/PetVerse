import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'dart:convert';
import 'package:flutter/services.dart';
import 'package:flutter/foundation.dart' show kIsWeb;

class StepFourScreen extends StatefulWidget {
  final Map<String, dynamic>? existingPet;
  final bool isEditing;
  final int currentDogCount;
  final int currentCatCount;
  final int maxDogs;
  final int maxCats;

  const StepFourScreen({
    super.key,
    this.existingPet,
    this.isEditing = false,
    this.currentDogCount = 0,
    this.currentCatCount = 0,
    this.maxDogs = 0,
    this.maxCats = 0,
  });

  @override
  State<StepFourScreen> createState() => _StepFourScreenState();
}

class _StepFourScreenState extends State<StepFourScreen> {
  // Logic Variables
  int dogLimit = 0;
  int catLimit = 0;
  int totalLimit = 0;

  // Controllers
  final _nameController = TextEditingController();
  final _weightController = TextEditingController();
  final _heightController = TextEditingController();
  final _featuresController = TextEditingController();
  final _diseaseController = TextEditingController();
  final _ageController = TextEditingController();

  XFile? _pickedFile;
  String? _imageBase64; // String version for Firestore storage
  String _petType = "Dog";
  String? _selectedBreed;
  String? _selectedBloodGroup;
  String _selectedGender = "Male";
  Map<String, dynamic> _masterDataset = {};
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadData().then((_) {
      if (widget.isEditing && widget.existingPet != null) {
        _preFillData();
      }
    });
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final args = ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>?;
    dogLimit = widget.maxDogs > 0 ? widget.maxDogs : (args?['maxDogs'] ?? 0);
    catLimit = widget.maxCats > 0 ? widget.maxCats : (args?['maxCats'] ?? 0);
    totalLimit = args?['totalExpected'] ?? (dogLimit + catLimit);
  }

  @override
  void dispose() {
    _nameController.dispose();
    _weightController.dispose();
    _heightController.dispose();
    _featuresController.dispose();
    _diseaseController.dispose();
    _ageController.dispose();
    super.dispose();
  }

  Future<void> _loadData() async {
    try {
      final String response = await rootBundle.loadString('assets/pet_data.json');
      setState(() {
        _masterDataset = json.decode(response);
        _isLoading = false;
      });
    } catch (e) {
      _masterDataset = {
        "breeds": {
          "Dog": ["Labrador", "German Shepherd", "Golden Retriever", "Beagle", "Indie", "Pug", "Other"],
          "Cat": ["Persian", "Maine Coon", "Siamese", "Bengal", "Indie", "Other"]
        },
        "blood_groups": {
          "Dog": ["DEA 1.1 +", "DEA 1.1 -", "DEA 1.2", "Unknown"],
          "Cat": ["Type A", "Type B", "Type AB", "Unknown"]
        }
      };
      setState(() => _isLoading = false);
    }
  }

  void _preFillData() {
    final pet = widget.existingPet!;
    setState(() {
      _nameController.text = pet['name'] ?? "";
      _petType = pet['type'] ?? "Dog";
      _selectedGender = pet['gender'] ?? "Male";
      _weightController.text = pet['weight'] ?? "";
      _heightController.text = pet['height'] ?? "";
      _ageController.text = pet['age'] ?? "";
      _featuresController.text = pet['features'] ?? "";
      _diseaseController.text = pet['disease'] ?? "";
      _selectedBreed = pet['breed'];
      _selectedBloodGroup = pet['blood'];
      _imageBase64 = pet['imageBase64'];
    });
  }

  // --- Image Handling (Camera + Gallery) ---
  Future<void> _pickImage(ImageSource source) async {
    final ImagePicker picker = ImagePicker();
    final XFile? image = await picker.pickImage(
      source: source,
      imageQuality: 50, // Compressed for Firestore efficiency
    );

    if (image != null) {
      final bytes = await image.readAsBytes();
      setState(() {
        _pickedFile = image;
        _imageBase64 = base64Encode(bytes);
      });
    }
  }

  void _showImageSourceSheet() {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(25))),
      builder: (context) => SafeArea(
        child: Wrap(
          children: [
            ListTile(
              leading: const Icon(Icons.camera_alt_rounded, color: Colors.orange),
              title: const Text('Take a Photo', style: TextStyle(fontFamily: 'Poppins')),
              onTap: () {
                Navigator.pop(context);
                _pickImage(ImageSource.camera);
              },
            ),
            ListTile(
              leading: const Icon(Icons.photo_library_rounded, color: Colors.orange),
              title: const Text('Choose from Gallery', style: TextStyle(fontFamily: 'Poppins')),
              onTap: () {
                Navigator.pop(context);
                _pickImage(ImageSource.gallery);
              },
            ),
          ],
        ),
      ),
    );
  }

  void _submit() {
    if (_nameController.text.trim().isEmpty) {
      _showSnackBar("Please enter a pet name.", isError: true);
      return;
    }

    // Return structured data for Step 3 to sync with Firestore
    Navigator.pop(context, {
      "name": _nameController.text.trim(),
      "type": _petType,
      "gender": _selectedGender,
      "weight": _weightController.text,
      "height": _heightController.text,
      "age": _ageController.text,
      "breed": _selectedBreed ?? "Indie",
      "blood": _selectedBloodGroup ?? "Unknown",
      "features": _featuresController.text,
      "disease": _diseaseController.text,
      "imageBase64": _imageBase64, // Home screen will use this string
      "updatedAt": DateTime.now().toIso8601String(),
    });
  }

  void _showSnackBar(String message, {bool isError = false}) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message, style: const TextStyle(fontFamily: 'Poppins')),
        backgroundColor: isError ? Colors.redAccent : Colors.orange,
        behavior: SnackBarBehavior.floating,
        margin: const EdgeInsets.all(20),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Scaffold(body: Center(child: CircularProgressIndicator(color: Colors.orange)));
    }

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: _buildAppBar(),
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        padding: const EdgeInsets.symmetric(horizontal: 24),
        child: Column(
          children: [
            const SizedBox(height: 10),
            Text(widget.isEditing ? "Update Details" : "Create Pet Profile",
                style: const TextStyle(fontSize: 28, fontWeight: FontWeight.w900, fontFamily: 'Poppins')),
            const Text("Tell us more about your furry friend.", style: TextStyle(color: Colors.grey, fontFamily: 'Poppins')),
            const SizedBox(height: 30),
            _buildProfilePhoto(),
            const SizedBox(height: 25),
            _buildSpeciesToggle(),
            const SizedBox(height: 25),
            _buildStylizedField(controller: _nameController, hint: "Pet Name", icon: Icons.edit_outlined),
            const SizedBox(height: 15),
            _buildPickerTrigger(
                label: _ageController.text.isEmpty ? "Select Age" : "${_ageController.text} Years Old",
                icon: Icons.calendar_today_outlined,
                onTap: _showAgePicker),
            const SizedBox(height: 15),
            _buildPickerTrigger(
                label: _selectedBreed ?? "Select $_petType Breed",
                icon: Icons.pets,
                onTap: () => _showSearchablePicker(
                    title: "Select Breed",
                    data: List<String>.from(_masterDataset['breeds'][_petType]),
                    onSelect: (val) => setState(() => _selectedBreed = val))),
            const SizedBox(height: 15),
            _buildPickerTrigger(
                label: _selectedBloodGroup ?? "Select $_petType Blood Group",
                icon: Icons.bloodtype_outlined,
                onTap: () => _showSearchablePicker(
                    title: "Select Blood Group",
                    data: List<String>.from(_masterDataset['blood_groups'][_petType]),
                    onSelect: (val) => setState(() => _selectedBloodGroup = val))),
            const SizedBox(height: 15),
            Row(children: [
              Expanded(child: _buildStylizedField(controller: _weightController, hint: "Weight", icon: Icons.monitor_weight_outlined, suffix: "kg", keyboardType: TextInputType.number)),
              const SizedBox(width: 12),
              Expanded(child: _buildStylizedField(controller: _heightController, hint: "Height", icon: Icons.height, suffix: "cm", keyboardType: TextInputType.number))
            ]),
            const SizedBox(height: 20),
            _buildGenderToggle(),
            const SizedBox(height: 15),
            _buildStylizedField(controller: _featuresController, hint: "Distinguishing Features (Optional)", icon: Icons.star_border),
            const SizedBox(height: 15),
            _buildStylizedField(controller: _diseaseController, hint: "Previous Diseases (Optional)", icon: Icons.medical_services_outlined),
            const SizedBox(height: 40),
            _buildActionButtons(),
            const SizedBox(height: 30),
          ],
        ),
      ),
    );
  }

  PreferredSizeWidget _buildAppBar() {
    return AppBar(
      leading: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Container(
          decoration: BoxDecoration(color: Colors.orange.withOpacity(0.1), shape: BoxShape.circle),
          child: IconButton(
            icon: const Icon(Icons.chevron_left, color: Colors.orange, size: 24),
            onPressed: () => Navigator.of(context).pop(),
          ),
        ),
      ),
      title: Text(widget.isEditing ? "Edit Profile" : "Step 4 of 5",
          style: const TextStyle(color: Colors.grey, fontWeight: FontWeight.w600, fontSize: 14, fontFamily: 'Poppins')),
      centerTitle: true,
      backgroundColor: Colors.white,
      elevation: 0,
    );
  }

  Widget _buildProfilePhoto() {
    return Center(
      child: Stack(
        alignment: Alignment.bottomRight,
        children: [
          Container(
            height: 120, width: 120,
            decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: const Color(0xFFF8F8F8),
                border: Border.all(color: Colors.orange.withOpacity(0.2), width: 2)),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(60),
              child: _imageBase64 != null
                  ? Image.memory(base64Decode(_imageBase64!), fit: BoxFit.cover)
                  : const Icon(Icons.pets, size: 50, color: Colors.orange),
            ),
          ),
          GestureDetector(
              onTap: _showImageSourceSheet, // Triggers Camera/Gallery selection
              child: Container(
                  padding: const EdgeInsets.all(10),
                  decoration: const BoxDecoration(color: Colors.orange, shape: BoxShape.circle),
                  child: const Icon(Icons.camera_alt, color: Colors.white, size: 20))),
        ],
      ),
    );
  }

  Widget _buildSpeciesToggle() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: ["Dog", "Cat"].map((type) {
        bool isSel = _petType == type;
        return GestureDetector(
          onTap: () => setState(() {
            _petType = type;
            _selectedBreed = null;
            _selectedBloodGroup = null;
          }),
          child: AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              margin: const EdgeInsets.symmetric(horizontal: 10),
              padding: const EdgeInsets.symmetric(horizontal: 45, vertical: 12),
              decoration: BoxDecoration(
                  color: isSel ? Colors.orange : const Color(0xFFF8F8F8),
                  borderRadius: BorderRadius.circular(25),
                  boxShadow: isSel ? [BoxShadow(color: Colors.orange.withOpacity(0.3), blurRadius: 8, offset: const Offset(0, 4))] : []),
              child: Text(type, style: TextStyle(color: isSel ? Colors.white : Colors.grey, fontWeight: FontWeight.bold, fontFamily: 'Poppins'))),
        );
      }).toList(),
    );
  }

  Widget _buildPickerTrigger({required String label, required IconData icon, required VoidCallback onTap}) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
          padding: const EdgeInsets.all(18),
          decoration: BoxDecoration(color: const Color(0xFFF8F8F8), borderRadius: BorderRadius.circular(15)),
          child: Row(children: [
            Icon(icon, color: Colors.orange.shade300, size: 22),
            const SizedBox(width: 12),
            Expanded(child: Text(label, style: TextStyle(color: label.contains("Select") ? Colors.grey : Colors.black, fontFamily: 'Poppins'))),
            const Icon(Icons.arrow_drop_down, color: Colors.grey)
          ])),
    );
  }

  Widget _buildStylizedField({required TextEditingController controller, required String hint, required IconData icon, String? suffix, TextInputType keyboardType = TextInputType.text}) {
    return Container(
        decoration: BoxDecoration(color: const Color(0xFFF8F8F8), borderRadius: BorderRadius.circular(15)),
        child: TextField(
            controller: controller,
            keyboardType: keyboardType,
            style: const TextStyle(fontFamily: 'Poppins'),
            decoration: InputDecoration(
                prefixIcon: Icon(icon, color: Colors.orange.shade300),
                hintText: hint,
                suffixText: suffix,
                border: InputBorder.none,
                contentPadding: const EdgeInsets.all(18),
                hintStyle: const TextStyle(color: Colors.grey, fontSize: 14))));
  }

  Widget _buildGenderToggle() {
    return Container(
      height: 60,
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(color: const Color(0xFFF8F8F8), borderRadius: BorderRadius.circular(15)),
      child: Row(
          children: ["Male", "Female"].map((g) {
        bool isSelected = _selectedGender == g;
        return Expanded(
            child: GestureDetector(
                onTap: () => setState(() => _selectedGender = g),
                child: AnimatedContainer(
                    duration: const Duration(milliseconds: 200),
                    decoration: BoxDecoration(
                        color: isSelected ? Colors.white : Colors.transparent,
                        borderRadius: BorderRadius.circular(12),
                        boxShadow: isSelected ? [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 5)] : []),
                    alignment: Alignment.center,
                    child: Text(g, style: TextStyle(color: isSelected ? Colors.orange : Colors.grey, fontWeight: FontWeight.bold, fontFamily: 'Poppins')))));
      }).toList()),
    );
  }

  Widget _buildActionButtons() {
    return SizedBox(
        width: double.infinity,
        height: 60,
        child: ElevatedButton(
            onPressed: _submit,
            style: ElevatedButton.styleFrom(
                backgroundColor: Colors.orange,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
                elevation: 0),
            child: Text(widget.isEditing ? "Save Changes" : "Continue",
                style: const TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold, fontFamily: 'Poppins'))));
  }

  void _showAgePicker() {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(25))),
      builder: (context) => Container(
        padding: const EdgeInsets.all(20),
        height: 350,
        child: Column(
          children: [
            const Text("Select Age", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, fontFamily: 'Poppins')),
            const SizedBox(height: 10),
            Expanded(
              child: ListWheelScrollView.useDelegate(
                itemExtent: 50,
                physics: const FixedExtentScrollPhysics(),
                onSelectedItemChanged: (i) => setState(() => _ageController.text = i.toString()),
                childDelegate: ListWheelChildBuilderDelegate(
                  childCount: 25,
                  builder: (c, i) => Center(child: Text("$i Years", style: const TextStyle(fontSize: 18, fontFamily: 'Poppins'))),
                ),
              ),
            ),
            const SizedBox(height: 10),
            SizedBox(
              width: double.infinity,
              height: 55,
              child: ElevatedButton(
                onPressed: () => Navigator.pop(context),
                style: ElevatedButton.styleFrom(backgroundColor: Colors.orange, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15))),
                child: const Text("Confirm", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
              ),
            )
          ],
        ),
      ),
    );
  }

  void _showSearchablePicker({required String title, required List<String> data, required Function(String) onSelect}) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(25))),
      builder: (context) => Container(
        height: MediaQuery.of(context).size.height * 0.7,
        padding: const EdgeInsets.all(24),
        child: Column(
          children: [
            Container(width: 40, height: 4, decoration: BoxDecoration(color: Colors.grey[300], borderRadius: BorderRadius.circular(10))),
            const SizedBox(height: 20),
            Text(title, style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold, fontFamily: 'Poppins')),
            const SizedBox(height: 20),
            Expanded(
              child: ListView.separated(
                physics: const BouncingScrollPhysics(),
                itemCount: data.length,
                separatorBuilder: (c, i) => const Divider(height: 1),
                itemBuilder: (c, i) => ListTile(
                  contentPadding: EdgeInsets.zero,
                  title: Text(data[i], style: const TextStyle(fontFamily: 'Poppins')),
                  trailing: const Icon(Icons.chevron_right, size: 18),
                  onTap: () {
                    onSelect(data[i]);
                    Navigator.pop(context);
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}