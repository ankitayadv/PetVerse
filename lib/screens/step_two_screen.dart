import 'dart:convert';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:country_picker/country_picker.dart';
import 'package:country_state_city/country_state_city.dart' as csc;
import 'package:geolocator/geolocator.dart'; 
import 'package:geocoding/geocoding.dart'; 
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class StepTwoScreen extends StatefulWidget {
  const StepTwoScreen({super.key});

  @override
  State<StepTwoScreen> createState() => _StepTwoScreenState();
}

class _StepTwoScreenState extends State<StepTwoScreen> {
  final _formKey = GlobalKey<FormState>();
  
  // --- State Variables ---
  Uint8List? _profileImageBytes;
  String? _imageBase64; 
  String _selectedGender = "Male";
  String _selectedCountryName = "Select Country";
  String _selectedCountryCode = "";
  String _selectedPhonePrefix = "";
  String? _selectedState;
  String? _selectedCity;
  String _calculatedAge = "Select DOB";
  bool _isSyncing = false;
  bool _isLoadingLocation = false;
  bool _isTermsAccepted = false;

  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _addressController = TextEditingController();

  List<csc.State> _states = [];
  List<csc.City> _cities = [];

  // --- Image Picker (Camera & Gallery) ---
  Future<void> _pickImage(ImageSource source) async {
    final ImagePicker picker = ImagePicker();
    try {
      final XFile? image = await picker.pickImage(
        source: source, 
        imageQuality: 40,
        maxWidth: 500,
      );
      
      if (image != null) {
        final bytes = await image.readAsBytes();
        setState(() {
          _profileImageBytes = bytes;
          _imageBase64 = base64Encode(bytes);
        });
      }
    } catch (e) {
      debugPrint("Image Error: $e");
    }
  }

  void _showImageSourceOptions() {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
      builder: (context) => SafeArea(
        child: Wrap(
          children: [
            ListTile(
              leading: const Icon(Icons.camera_alt, color: Colors.orange),
              title: const Text('Take a Photo'),
              onTap: () {
                Navigator.pop(context);
                _pickImage(ImageSource.camera);
              },
            ),
            ListTile(
              leading: const Icon(Icons.photo_library, color: Colors.orange),
              title: const Text('Choose from Gallery'),
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

  // --- Location Logic ---
  Future<void> _detectLocation() async {
    setState(() => _isLoadingLocation = true);
    try {
      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
      }

      Position position = await Geolocator.getCurrentPosition(
        locationSettings: const LocationSettings(accuracy: LocationAccuracy.high)
      );
      
      List<Placemark> placemarks = await placemarkFromCoordinates(
        position.latitude, position.longitude
      );

      if (placemarks.isNotEmpty) {
        Placemark place = placemarks[0];
        setState(() {
          _addressController.text = "${place.street}, ${place.subLocality}, ${place.locality}";
        });
      }
    } catch (e) {
      if (mounted) ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Location Error: $e")));
    } finally {
      if (mounted) setState(() => _isLoadingLocation = false);
    }
  }

  // --- Navigation & Sync ---
  Future<void> _handleContinue(Map<String, dynamic> previousArgs) async {
    if (!_formKey.currentState!.validate()) return;
    
    final Map<String, dynamic> ownerData = {
      'ownerName': _nameController.text.trim(),
      'ownerPhone': '$_selectedPhonePrefix${_phoneController.text.trim()}',
      'ownerGender': _selectedGender,
      'ownerAge': _calculatedAge,
      'country': _selectedCountryName,
      'state': _selectedState,
      'city': _selectedCity,
      'streetAddress': _addressController.text.trim(),
      'ownerImageBase64': _imageBase64, // Field name fixed for HomeScreen
    };

    final Map<String, dynamic> updatedArgs = Map<String, dynamic>.from(previousArgs)..addAll(ownerData);
    _showPrivacyConsentDialog(updatedArgs);
  }

  void _showPrivacyConsentDialog(Map<String, dynamic> args) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => StatefulBuilder(
        builder: (context, setModalState) => Dialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(28)),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(Icons.shield, color: Colors.orange, size: 48),
                const SizedBox(height: 16),
                const Text("Privacy & Consent", style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, fontFamily: 'Poppins')),
                const SizedBox(height: 12),
                const Text("To provide a personalized experience, PetVerse requires your consent to store profile and location data.", textAlign: TextAlign.center, style: TextStyle(fontSize: 13)),
                const SizedBox(height: 20),
                _buildConsentItem(Icons.storage_rounded, "Profile Management", "Securely store your contact info."),
                _buildConsentItem(Icons.location_on, "Location Services", "Find nearby veterinary clinics."),
                const SizedBox(height: 20),
                CheckboxListTile(
                  value: _isTermsAccepted,
                  activeColor: Colors.orange,
                  title: const Text("I agree to the Terms & Privacy Policy", style: TextStyle(fontSize: 12)),
                  onChanged: (val) => setModalState(() => _isTermsAccepted = val!),
                  controlAffinity: ListTileControlAffinity.leading,
                ),
                const SizedBox(height: 24),
                Row(
                  children: [
                    Expanded(child: OutlinedButton(onPressed: () => Navigator.pop(context), child: const Text("Decline"))),
                    const SizedBox(width: 12),
                    Expanded(child: ElevatedButton(
                      style: ElevatedButton.styleFrom(backgroundColor: Colors.orange),
                      onPressed: _isTermsAccepted ? () => _saveAndNavigate(args) : null,
                      child: const Text("Accept", style: TextStyle(color: Colors.white)),
                    )),
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _saveAndNavigate(Map<String, dynamic> args) async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return;
    setState(() => _isSyncing = true);
    try {
      await FirebaseFirestore.instance.collection('users').doc(user.uid).set({
        'ownerName': args['ownerName'],
        'ownerImageBase64': args['ownerImageBase64'],
        'ownerDetails': args,
        'onboardingStep': 2,
      }, SetOptions(merge: true));
      
      if (mounted) Navigator.pushNamed(context, '/stepthree', arguments: args);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Sync Error: $e")));
    } finally {
      if (mounted) setState(() => _isSyncing = false);
    }
  }

  // --- Build UI ---
  @override
  Widget build(BuildContext context) {
    final Map<String, dynamic> argsFromStepOne = (ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>?) ?? {};

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        leading: IconButton(icon: const Icon(Icons.arrow_back_ios, color: Colors.orange, size: 18), onPressed: () => Navigator.pop(context)),
        title: const Text("Step 2 of 5", style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 14)),
        centerTitle: true, elevation: 0, backgroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 24.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Center(child: Text("Owner Profile", style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold))),
              const SizedBox(height: 20),
              Center(child: _buildProfilePicker()),
              const SizedBox(height: 30),
              _buildSectionLabel("Full Name *"),
              _buildTextField(controller: _nameController, label: "Your Name", icon: Icons.person_outline),
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
                  const Text("Address Details", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                  TextButton.icon(
                    onPressed: _isLoadingLocation ? null : _detectLocation,
                    icon: _isLoadingLocation ? const SizedBox(width: 15, height: 15, child: CircularProgressIndicator(strokeWidth: 2)) : const Icon(Icons.my_location, size: 18),
                    label: Text(_isLoadingLocation ? "Locating..." : "Auto GPS"),
                  )
                ],
              ),
              _buildCountrySelector(),
              const SizedBox(height: 15),
              _buildStateDropdown(),
              const SizedBox(height: 15),
              _buildCityDropdown(),
              _buildSectionLabel("Street Address"),
              _buildTextField(controller: _addressController, label: "House No, Plot No", icon: Icons.home_outlined, maxLines: 2),
              const SizedBox(height: 40),
              SizedBox(
                width: double.infinity, height: 58,
                child: ElevatedButton(
                  onPressed: _isSyncing ? null : () => _handleContinue(argsFromStepOne),
                  style: ElevatedButton.styleFrom(backgroundColor: Colors.orange, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15))),
                  child: _isSyncing ? const CircularProgressIndicator(color: Colors.white) : const Text("Continue", style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)),
                ),
              ),
              const SizedBox(height: 30),
            ],
          ),
        ),
      ),
    );
  }

  // --- Widgets ---
  Widget _buildProfilePicker() {
    return GestureDetector(
      onTap: _showImageSourceOptions,
      child: Stack(alignment: Alignment.bottomRight, children: [
        CircleAvatar(
          radius: 55, backgroundColor: const Color(0xFFF9F9F9),
          backgroundImage: _profileImageBytes != null ? MemoryImage(_profileImageBytes!) : null,
          child: _profileImageBytes == null ? const Icon(Icons.person, size: 50, color: Colors.grey) : null,
        ),
        const CircleAvatar(radius: 18, backgroundColor: Colors.orange, child: Icon(Icons.camera_alt, color: Colors.white, size: 16)),
      ]),
    );
  }

  Widget _buildTextField({required TextEditingController controller, required String label, required IconData icon, int maxLines = 1}) {
    return TextFormField(
      controller: controller,
      maxLines: maxLines,
      validator: (val) => val!.isEmpty ? "Required field" : null,
      decoration: InputDecoration(
        labelText: label, prefixIcon: Icon(icon, color: Colors.orange),
        filled: true, fillColor: const Color(0xFFF9F9F9),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
      ),
    );
  }

  Widget _buildPhoneField() {
    return TextFormField(
      controller: _phoneController,
      keyboardType: TextInputType.phone,
      decoration: InputDecoration(
        hintText: "Enter Number",
        prefixIcon: Row(mainAxisSize: MainAxisSize.min, children: [
          const SizedBox(width: 12),
          const Icon(Icons.phone_android_outlined, color: Colors.orange),
          if (_selectedPhonePrefix.isNotEmpty) Padding(padding: const EdgeInsets.only(left: 8), child: Text(_selectedPhonePrefix)),
          const SizedBox(width: 8),
        ]),
        filled: true, fillColor: const Color(0xFFF9F9F9),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
      ),
    );
  }

  Widget _buildSectionLabel(String label) => Padding(padding: const EdgeInsets.only(bottom: 8, top: 16), child: Text(label, style: const TextStyle(fontWeight: FontWeight.bold)));

  Widget _buildGenderSelection() {
    return Row(children: ["Male", "Female", "Other"].map((g) => Padding(padding: const EdgeInsets.only(right: 8), child: ChoiceChip(
      label: Text(g), selected: _selectedGender == g, onSelected: (s) => setState(() => _selectedGender = g),
      selectedColor: Colors.orange, labelStyle: TextStyle(color: _selectedGender == g ? Colors.white : Colors.black),
    ))).toList());
  }

  Widget _buildDatePickerField() {
    return InkWell(
      onTap: () async {
        final DateTime? picked = await showDatePicker(context: context, initialDate: DateTime(2000), firstDate: DateTime(1950), lastDate: DateTime.now());
        if (picked != null) setState(() => _calculatedAge = "${DateTime.now().year - picked.year} Years Old");
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
      onTap: () => showCountryPicker(context: context, onSelect: (Country c) async {
        final states = await csc.getStatesOfCountry(c.countryCode);
        setState(() {
          _selectedCountryName = "${c.flagEmoji} ${c.name}";
          _selectedCountryCode = c.countryCode;
          _selectedPhonePrefix = "+${c.phoneCode}";
          _states = states;
          _selectedState = null;
          _selectedCity = null;
        });
      }),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(color: const Color(0xFFF9F9F9), borderRadius: BorderRadius.circular(12)),
        child: Row(children: [const Icon(Icons.public, color: Colors.orange), const SizedBox(width: 12), Text(_selectedCountryName), const Spacer(), const Icon(Icons.arrow_drop_down)]),
      ),
    );
  }

  Widget _buildStateDropdown() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12),
      decoration: BoxDecoration(color: const Color(0xFFF9F9F9), borderRadius: BorderRadius.circular(12)),
      child: DropdownButtonHideUnderline(child: DropdownButton<String>(
        isExpanded: true, hint: Text(_selectedState ?? "Select State"),
        items: _states.map((s) => DropdownMenuItem(value: s.name, child: Text(s.name))).toList(),
        onChanged: (val) async {
          if (val == null) return;
          final stateObj = _states.firstWhere((s) => s.name == val);
          final cities = await csc.getStateCities(_selectedCountryCode, stateObj.isoCode);
          setState(() { _selectedState = val; _cities = cities; _selectedCity = null; });
        },
      )),
    );
  }

  Widget _buildCityDropdown() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12),
      decoration: BoxDecoration(color: const Color(0xFFF9F9F9), borderRadius: BorderRadius.circular(12)),
      child: DropdownButtonHideUnderline(child: DropdownButton<String>(
        isExpanded: true, hint: Text(_selectedCity ?? "Select City"),
        items: _cities.map((c) => DropdownMenuItem(value: c.name, child: Text(c.name))).toList(),
        onChanged: (val) => setState(() => _selectedCity = val),
      )),
    );
  }

  Widget _buildConsentItem(IconData icon, String title, String sub) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(children: [
        Icon(icon, color: Colors.orange, size: 20),
        const SizedBox(width: 12),
        Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text(title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
          Text(sub, style: const TextStyle(fontSize: 11, color: Colors.grey)),
        ]))
      ]),
    );
  }
}