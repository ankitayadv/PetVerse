import 'dart:convert';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:country_picker/country_picker.dart';
import 'package:country_state_city/country_state_city.dart' as csc;
import 'package:geolocator/geolocator.dart';
import 'package:http/http.dart' as http;

class StepTwoScreen extends StatefulWidget {
  const StepTwoScreen({super.key});

  @override
  State<StepTwoScreen> createState() => _StepTwoScreenState();
}

class _StepTwoScreenState extends State<StepTwoScreen> {
  // --- State Variables ---
  Uint8List? _webImage; 
  String _selectedGender = "Male"; 
  String _selectedCountryName = "Select Country";
  String _selectedCountryCode = "";
  String? _selectedState;
  String? _selectedCity;
  String _calculatedAge = "Select DOB";
  bool _isLoadingLocation = false;

  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _addressController = TextEditingController();
  
  List<csc.State> _states = [];
  List<csc.City> _cities = [];

  // --- 1. GPS Auto-Detect with Dropdown Sync ---
  Future<void> _detectLocation() async {
    setState(() => _isLoadingLocation = true);
    try {
      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
      }

      if (permission == LocationPermission.whileInUse || permission == LocationPermission.always) {
        Position position = await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
        
        final url = Uri.parse('https://nominatim.openstreetmap.org/reverse?format=json&lat=${position.latitude}&lon=${position.longitude}');
        final response = await http.get(url, headers: {'User-Agent': 'PetVerse_App'});
        
        if (response.statusCode == 200) {
          final data = json.decode(response.body);
          final addr = data['address'];
          
          setState(() {
            _selectedCountryName = addr['country'] ?? "Select Country";
            _selectedState = addr['state'] ?? addr['province'];
            _selectedCity = addr['city'] ?? addr['town'] ?? addr['village'];
            _addressController.text = data['display_name'] ?? "";
          });
        }
      }
    } catch (e) {
      debugPrint("GPS Error: $e");
    } finally {
      setState(() => _isLoadingLocation = false);
    }
  }

  // --- 2. Image Picker & Logic ---
  Future<void> _pickImage() async {
    final ImagePicker picker = ImagePicker();
    final XFile? image = await picker.pickImage(source: ImageSource.gallery);
    if (image != null) {
      var bytes = await image.readAsBytes();
      setState(() => _webImage = bytes);
    }
  }

  void _showConsentDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Data Consent"),
        content: const Text("Allow PetVerse to store your profile for pet care management?"),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text("Decline")),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: Colors.orange),
            onPressed: () {
              Navigator.pop(context);
              Navigator.pushNamed(context, '/stepthree');
            },
            child: const Text("I Agree"),
          ),
        ],
      ),
    );
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now().subtract(const Duration(days: 6570)),
      firstDate: DateTime(1950),
      lastDate: DateTime.now(),
    );
    if (picked != null) {
      int age = DateTime.now().year - picked.year;
      if (DateTime.now().month < picked.month || (DateTime.now().month == picked.month && DateTime.now().day < picked.day)) age--;
      setState(() => _calculatedAge = "$age Years Old");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        leading: IconButton(icon: const Icon(Icons.arrow_back_ios, color: Colors.orange), onPressed: () => Navigator.pop(context)),
        title: const Text("Step 2 of 5", style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold)),
        centerTitle: true, elevation: 0, backgroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Center(child: Text("Owner Profile", style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold))),
            const SizedBox(height: 20),
            Center(child: _buildProfilePicker()),
            const SizedBox(height: 30),

            _buildSectionLabel("Full Name"),
            _buildField(_nameController, "John Doe", Icons.person_outline),

            _buildSectionLabel("Phone Number"),
            _buildField(_phoneController, "+1 234 567 890", Icons.phone_android_outlined),

            _buildSectionLabel("Your Age"),
            _buildDatePickerField(),

            _buildSectionLabel("Gender"),
            _buildGenderSelection(),

            const Divider(height: 40),

            // Address Section Header
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text("Address Information", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                TextButton.icon(
                  onPressed: _isLoadingLocation ? null : _detectLocation,
                  icon: _isLoadingLocation 
                    ? const SizedBox(width: 15, height: 15, child: CircularProgressIndicator(strokeWidth: 2, color: Colors.orange))
                    : const Icon(Icons.my_location, color: Colors.orange, size: 18),
                  label: Text(_isLoadingLocation ? "Detecting..." : "Auto GPS", style: const TextStyle(color: Colors.orange)),
                )
              ],
            ),

            _buildCountrySelector(),
            const SizedBox(height: 15),
            _buildStateDropdown(),
            const SizedBox(height: 15),
            _buildCityDropdown(),

            _buildSectionLabel("House Address"),
            _buildField(_addressController, "Apartment, Street, Landmark", Icons.home_outlined),

            const SizedBox(height: 40),
            _buildContinueButton(),
            Center(child: TextButton(onPressed: () => Navigator.pushNamed(context, '/stepthree'), child: const Text("Skip for Now", style: TextStyle(color: Colors.grey)))),
            const SizedBox(height: 30),
          ],
        ),
      ),
    );
  }

  // --- UI Build Methods ---

  Widget _buildProfilePicker() {
    return GestureDetector(
      onTap: _pickImage,
      child: Stack(
        alignment: Alignment.bottomRight,
        children: [
          CircleAvatar(
            radius: 55,
            backgroundColor: const Color(0xFFF2F2F2),
            backgroundImage: _webImage != null 
                ? MemoryImage(_webImage!) 
                : const NetworkImage("https://cdn-icons-png.flaticon.com/512/149/149071.png") as ImageProvider,
          ),
          const CircleAvatar(radius: 18, backgroundColor: Colors.orange, child: Icon(Icons.camera_alt, color: Colors.white, size: 16)),
        ],
      ),
    );
  }

  Widget _buildGenderSelection() {
    return Row(
      children: ["Male", "Female", "Other"].map((g) => Padding(
        padding: const EdgeInsets.only(right: 8),
        child: ChoiceChip(
          label: Text(g),
          selected: _selectedGender == g,
          onSelected: (s) => setState(() => _selectedGender = g),
          selectedColor: Colors.orange,
          labelStyle: TextStyle(color: _selectedGender == g ? Colors.white : Colors.black),
        ),
      )).toList(),
    );
  }

  Widget _buildDatePickerField() {
    return InkWell(
      onTap: () => _selectDate(context),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(color: const Color(0xFFF9F9F9), borderRadius: BorderRadius.circular(12)),
        child: Row(children: [const Icon(Icons.calendar_month, color: Colors.orange), const SizedBox(width: 12), Text(_calculatedAge)]),
      ),
    );
  }

  Widget _buildCountrySelector() {
    return GestureDetector(
      onTap: () => showCountryPicker(
        context: context,
        onSelect: (c) async {
          final states = await csc.getStatesOfCountry(c.countryCode);
          setState(() { 
            _selectedCountryName = "${c.flagEmoji} ${c.name}"; 
            _selectedCountryCode = c.countryCode; 
            _states = states; 
            _selectedState = null;
            _cities = [];
            _selectedCity = null;
          });
        },
      ), 
      child: Container(padding: const EdgeInsets.all(16), decoration: BoxDecoration(color: const Color(0xFFF9F9F9), borderRadius: BorderRadius.circular(12)), child: Row(children: [const Icon(Icons.public, color: Colors.orange), const SizedBox(width: 12), Text(_selectedCountryName), const Spacer(), const Icon(Icons.arrow_drop_down)]))
    );
  }

  Widget _buildStateDropdown() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12),
      decoration: BoxDecoration(color: const Color(0xFFF9F9F9), borderRadius: BorderRadius.circular(12)),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          isExpanded: true,
          hint: Text(_selectedState ?? "Select State"),
          value: _states.any((s) => s.name == _selectedState) ? _selectedState : null,
          items: _states.map((s) => DropdownMenuItem(value: s.name, child: Text(s.name))).toList(),
          onChanged: (val) async {
            final stateObj = _states.firstWhere((s) => s.name == val);
            final cities = await csc.getStateCities(_selectedCountryCode, stateObj.isoCode);
            setState(() { _selectedState = val; _cities = cities; _selectedCity = null; });
          },
        ),
      ),
    );
  }

  Widget _buildCityDropdown() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12),
      decoration: BoxDecoration(color: const Color(0xFFF9F9F9), borderRadius: BorderRadius.circular(12)),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          isExpanded: true,
          hint: Text(_selectedCity ?? "Select City"),
          value: _cities.any((c) => c.name == _selectedCity) ? _selectedCity : null,
          items: _cities.map((c) => DropdownMenuItem(value: c.name, child: Text(c.name))).toList(),
          onChanged: (val) => setState(() => _selectedCity = val),
        ),
      ),
    );
  }

  Widget _buildField(TextEditingController controller, String hint, IconData icon) => TextFormField(
    controller: controller, 
    decoration: InputDecoration(hintText: hint, prefixIcon: Icon(icon, color: Colors.orange), filled: true, fillColor: const Color(0xFFF9F9F9), border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none))
  );

  Widget _buildSectionLabel(String label) => Padding(padding: const EdgeInsets.only(bottom: 8, top: 16), child: Text(label, style: const TextStyle(fontWeight: FontWeight.bold)));

  Widget _buildContinueButton() => SizedBox(
    width: double.infinity, height: 58,
    child: ElevatedButton(
      onPressed: _showConsentDialog,
      style: ElevatedButton.styleFrom(backgroundColor: Colors.orange, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15))),
      child: const Text("Continue", style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)),
    ),
  );
}