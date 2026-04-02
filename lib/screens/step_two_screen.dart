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
  // --- Form Key for Validations ---
  final _formKey = GlobalKey<FormState>();

  // --- State Variables ---
  Uint8List? _webImage;
  String _selectedGender = "Male";
  String _selectedCountryName = "Select Country";
  String _selectedCountryCode = "";
  String _selectedPhonePrefix = ""; // Stores the +91, +1, etc.
  String? _selectedState;
  String? _selectedCity;
  String _calculatedAge = "Select DOB";
  bool _isLoadingLocation = false;
  bool _isTermsAccepted = false;

  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _addressController = TextEditingController();

  List<csc.State> _states = [];
  List<csc.City> _cities = [];

  // --- Logic: Consent Dialog (Reverted to original UI) ---
  void _showConsentDialog(Map<String, dynamic> args) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => StatefulBuilder(
        builder: (context, setModalState) {
          return Dialog(
            backgroundColor: Colors.white,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(28)),
            // Add inset padding to make the dialog narrower on tablets/web
            insetPadding: const EdgeInsets.symmetric(horizontal: 40.0, vertical: 24.0), 
            child: Container(
              padding: const EdgeInsets.fromLTRB(24, 30, 24, 24),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(Icons.security, color: Colors.orange, size: 42),
                  const SizedBox(height: 20),
                  const Text(
                    "Privacy & Consent",
                    textAlign: TextAlign.center, // Title centered
                    style: TextStyle(
                      fontSize: 20, 
                      fontWeight: FontWeight.bold, 
                      fontFamily: 'Poppins', 
                      color: Colors.black
                    ),
                  ),
                  const SizedBox(height: 12),
                  const Text(
                    "To provide a personalized experience for you and your pets, PetVerse requires your consent for the following:",
                    textAlign: TextAlign.center, // Body text centered
                    style: TextStyle(
                      fontSize: 12, 
                      color: Colors.black87, 
                      fontFamily: 'Poppins',
                      height: 1.5 // Added line height for readability
                    ),
                  ),
                  const SizedBox(height: 30),

                  // Reverting the 3 specific list items
                  _buildConsentRow(Icons.storage, "Profile Management", "Securely store your contact and pet information.", Colors.orange),
                  _buildConsentRow(Icons.location_on, "Location Services", "Access address data to find nearby veterinary clinics.", Colors.orange),
                  _buildConsentRow(Icons.verified_user, "Data Protection", "Your information is handled according to our Privacy Policy.", Colors.green), // Restored 3rd item

                  const SizedBox(height: 16),

                  // Checkbox Area (Reverted styling)
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 4),
                    decoration: BoxDecoration(
                      color: const Color(0xFFFCF9F3), // Original light background
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Row(
                      children: [
                        Theme(
                          // Customize checkbox color
                          data: ThemeData(unselectedWidgetColor: Colors.grey),
                          child: Checkbox(
                            activeColor: const Color(0xFFC0A071), // Brownish accent from image
                            value: _isTermsAccepted,
                            onChanged: (val) => setModalState(() => _isTermsAccepted = val!),
                          ),
                        ),
                        const Expanded(
                          child: Text("I agree to the Terms & Privacy Policy", 
                            style: TextStyle(fontSize: 12, fontWeight: FontWeight.w500, fontFamily: 'Poppins', color: Colors.black)),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 24),

                  // Buttons (Reverted styling)
                  Row(
                    children: [
                      Expanded(
                        child: TextButton(
                          style: TextButton.styleFrom(
                            padding: const EdgeInsets.symmetric(vertical: 16),
                            backgroundColor: Colors.transparent, // Simple transparent button
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                          ),
                          onPressed: () => Navigator.pop(context),
                          child: const Text("Decline", style: TextStyle(color: Colors.grey, fontSize: 13, fontWeight: FontWeight.bold, fontFamily: 'Poppins')),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: TextButton(
                          style: TextButton.styleFrom(
                            padding: const EdgeInsets.symmetric(vertical: 16),
                            backgroundColor: _isTermsAccepted ? const Color(0xFFC0A071) : Colors.grey[300], // Brown accent
                            elevation: 0,
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                          ),
                          onPressed: _isTermsAccepted ? () {
                            Navigator.pop(context);
                            Navigator.pushNamed(context, '/stepthree', arguments: args);
                          } : null,
                          child: Text("Accept", 
                            style: TextStyle(
                              color: _isTermsAccepted ? Colors.white : Colors.grey[600], 
                              fontSize: 13, 
                              fontWeight: FontWeight.bold, 
                              fontFamily: 'Poppins'
                            )
                          ),
                        ),
                      ),
                    ],
                  )
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  // --- Helper: Build Consent Row (Updated to match original) ---
  Widget _buildConsentRow(IconData icon, String title, String sub, Color iconColor) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 20),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: iconColor, size: 22),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13, fontFamily: 'Poppins', color: Colors.black)),
                const SizedBox(height: 2), // Small gap before subtitle
                Text(sub, style: const TextStyle(fontSize: 11, color: Colors.black87, fontFamily: 'Poppins')),
              ],
            ),
          )
        ],
      ),
    );
  }

  // --- Logic: Navigation & Validation ---
  void _validateAndProceed(Map<String, dynamic> previousArgs) {
    if (_formKey.currentState!.validate()) {
      // Additional check for Country selection
      if (_selectedCountryCode.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Please select your country")),
        );
        return;
      }

      final updatedArgs = {
        ...previousArgs,
        'ownerName': _nameController.text.trim(),
        'ownerPhone': '$_selectedPhonePrefix${_phoneController.text.trim()}',
        'ownerGender': _selectedGender,
        'ownerLocation': _selectedCity ?? "Not Set",
        'ownerImage': _webImage,
      };

      _showConsentDialog(updatedArgs);
    }
  }

  // --- Logic: Location Detection ---
  Future<void> _detectLocation() async {
    setState(() => _isLoadingLocation = true);
    try {
      Position position = await Geolocator.getCurrentPosition();
      final response = await http.get(Uri.parse(
          'https://nominatim.openstreetmap.org/reverse?format=json&lat=${position.latitude}&lon=${position.longitude}'));
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        setState(() {
          _selectedCountryName = data['address']['country'] ?? "Select Country";
          _addressController.text = data['display_name'] ?? "";
        });
      }
    } catch (_) {}
    setState(() => _isLoadingLocation = false);
  }

  @override
  Widget build(BuildContext context) {
    final Map<String, dynamic> argsFromStepOne =
        (ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>?) ?? {};

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        leading: IconButton(icon: const Icon(Icons.arrow_back_ios, color: Colors.orange, size: 18), onPressed: () => Navigator.pop(context)),
        title: const Text("Step 2 of 5", style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 14, fontFamily: 'Poppins')),
        centerTitle: true, elevation: 0, backgroundColor: Colors.white,
      ),
      body: Form(
        key: _formKey,
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Center(child: Text("Owner Profile", style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold, fontFamily: 'Poppins'))),
              const SizedBox(height: 20),
              Center(child: _buildProfilePicker()),
              const SizedBox(height: 30),

              _buildSectionLabel("Full Name *"),
              _buildNameField(),

              _buildSectionLabel("Phone Number *"),
              _buildPhoneField(),

              _buildSectionLabel("Your Age"),
              _buildDatePickerField(),

              _buildSectionLabel("Gender"),
              _buildGenderSelection(),

              const Divider(height: 40),

              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text("Address Details", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, fontFamily: 'Poppins')),
                  TextButton.icon(
                    onPressed: _isLoadingLocation ? null : _detectLocation,
                    icon: _isLoadingLocation
                        ? const SizedBox(width: 15, height: 15, child: CircularProgressIndicator(strokeWidth: 2, color: Colors.orange))
                        : const Icon(Icons.my_location, color: Colors.orange, size: 18),
                    label: Text(_isLoadingLocation ? "Locating..." : "Auto GPS", style: const TextStyle(color: Colors.orange, fontSize: 12)),
                  )
                ],
              ),

              _buildCountrySelector(),
              const SizedBox(height: 15),
              _buildStateDropdown(),
              const SizedBox(height: 15),
              _buildCityDropdown(),

              _buildSectionLabel("Street Address"),
              _buildAddressField(),

              const SizedBox(height: 40),

              SizedBox(
                width: double.infinity,
                height: 58,
                child: ElevatedButton(
                  onPressed: () => _validateAndProceed(argsFromStepOne),
                  style: ElevatedButton.styleFrom(backgroundColor: Colors.orange, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)), elevation: 0),
                  child: const Text("Continue", style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)),
                ),
              ),
              Center(child: TextButton(onPressed: () => Navigator.pushNamed(context, '/stepthree', arguments: argsFromStepOne), child: const Text("Skip for now", style: TextStyle(color: Colors.grey, fontSize: 12)))),
              const SizedBox(height: 30),
            ],
          ),
        ),
      ),
    );
  }

  // --- UI Components ---

  Widget _buildProfilePicker() {
    return GestureDetector(
      onTap: () async {
        final ImagePicker picker = ImagePicker();
        final XFile? image = await picker.pickImage(source: ImageSource.gallery);
        if (image != null) {
          var bytes = await image.readAsBytes();
          setState(() => _webImage = bytes);
        }
      },
      child: Stack(
        alignment: Alignment.bottomRight,
        children: [
          CircleAvatar(
            radius: 55,
            backgroundColor: const Color(0xFFF9F9F9),
            backgroundImage: _webImage != null
                ? MemoryImage(_webImage!)
                : const NetworkImage("https://cdn-icons-png.flaticon.com/512/149/149071.png") as ImageProvider,
          ),
          const CircleAvatar(radius: 18, backgroundColor: Colors.orange, child: Icon(Icons.camera_alt, color: Colors.white, size: 16)),
        ],
      ),
    );
  }

  Widget _buildNameField() {
    return TextFormField(
      controller: _nameController,
      validator: (value) => (value == null || value.isEmpty) ? "Please enter your name" : null,
      decoration: InputDecoration(
          hintText: "Your Name",
          prefixIcon: const Icon(Icons.person_outline, color: Colors.orange),
          filled: true,
          fillColor: const Color(0xFFF9F9F9),
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none)),
    );
  }

  Widget _buildPhoneField() {
    return TextFormField(
      controller: _phoneController,
      keyboardType: TextInputType.phone,
      validator: (value) {
        if (value == null || value.isEmpty) return "Phone number is required";
        if (value.length < 7) return "Invalid phone number";
        return null;
      },
      decoration: InputDecoration(
          hintText: "Enter Number",
          // The prefix displays the code once a country is selected
          prefixIcon: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              const SizedBox(width: 12),
              const Icon(Icons.phone_android_outlined, color: Colors.orange),
              if (_selectedPhonePrefix.isNotEmpty)
                Padding(
                  padding: const EdgeInsets.only(left: 8.0),
                  child: Text(_selectedPhonePrefix, style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.black)),
                ),
              const SizedBox(width: 8),
            ],
          ),
          filled: true,
          fillColor: const Color(0xFFF9F9F9),
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none)),
    );
  }

  Widget _buildAddressField() {
    return TextFormField(
      controller: _addressController,
      decoration: InputDecoration(
          hintText: "House No, Area, Landmark",
          prefixIcon: const Icon(Icons.home_outlined, color: Colors.orange),
          filled: true,
          fillColor: const Color(0xFFF9F9F9),
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none)),
    );
  }

  Widget _buildSectionLabel(String label) => Padding(padding: const EdgeInsets.only(bottom: 8, top: 16), child: Text(label, style: const TextStyle(fontWeight: FontWeight.bold)));

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
      onTap: () async {
        final DateTime? picked = await showDatePicker(context: context, initialDate: DateTime(2000), firstDate: DateTime(1950), lastDate: DateTime.now());
        if (picked != null) {
          int age = DateTime.now().year - picked.year;
          setState(() => _calculatedAge = "$age Years Old");
        }
      },
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
        onSelect: (Country c) async {
          final states = await csc.getStatesOfCountry(c.countryCode);
          setState(() {
            _selectedCountryName = "${c.flagEmoji} ${c.name}";
            _selectedCountryCode = c.countryCode;
            _selectedPhonePrefix = "+${c.phoneCode}"; // Dynamic Phone Code
            _states = states;
            _selectedState = null;
            _selectedCity = null;
          });
        },
      ),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(color: const Color(0xFFF9F9F9), borderRadius: BorderRadius.circular(12)),
        child: Row(children: [
          const Icon(Icons.public, color: Colors.orange),
          const SizedBox(width: 12),
          Text(_selectedCountryName),
          const Spacer(),
          const Icon(Icons.arrow_drop_down)
        ]),
      ),
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
            if (val == null) return;
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
}