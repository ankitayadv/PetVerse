import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';

import '../data/lost_pet_data.dart';
import '../routes/app_routes.dart'; // ✅ ADDED

class ReportLostScreen extends StatefulWidget {
  const ReportLostScreen({super.key});

  @override
  State<ReportLostScreen> createState() => _ReportLostScreenState();
}

class _ReportLostScreenState extends State<ReportLostScreen> {
  final _formKey = GlobalKey<FormState>();

  final nameController = TextEditingController();
  final breedController = TextEditingController();
  final colorController = TextEditingController();
  final ownerController = TextEditingController();
  final phoneController = TextEditingController();
  final locationController = TextEditingController();

  List<File> images = [];

  double? lat;
  double? lng;

  final ImagePicker picker = ImagePicker();

  // 📸 IMAGE PICK
  Future<void> pickImage(ImageSource source) async {
    final picked = await picker.pickImage(source: source);
    if (picked != null) {
      setState(() {
        images.add(File(picked.path));
      });
    }
  }

  // 📍 LOCATION FETCH
  Future<void> fetchLocation() async {
    Position position = await Geolocator.getCurrentPosition();

    lat = position.latitude;
    lng = position.longitude;

    List<Placemark> placemarks =
        await placemarkFromCoordinates(lat!, lng!);

    final place = placemarks.first;

    String address =
        "${place.subLocality}, ${place.locality}, ${place.administrativeArea}";

    setState(() {
      locationController.text = address;
    });
  }

  // 🚀 SUBMIT (UPDATED WITH AI FLOW)
  void submitForm() {
    if (_formKey.currentState!.validate()) {
      
      final petData = {
        "name": nameController.text,
        "type": "LOST",
        "location": locationController.text,
        "lat": lat ?? 28.6139,
        "lng": lng ?? 77.2090,
        "breed": breedController.text,
        "color": colorController.text,
        "time": "Just now",
        "image": images.isNotEmpty
            ? images.first.path
            : "assets/images/pet_profile.png",
        "phone": phoneController.text,
      };

      // ✅ SAVE LOCALLY (FOR NEARBY + MAP)
      LostPetData.addPet(petData);

      // ✅ GO TO AI MATCHING SCREEN
      Navigator.pushNamed(
        context,
        AppRoutes.aiMatch,
        arguments: petData,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFFF4EC),

      appBar: AppBar(
        title: const Text("Report Lost Pet"),
        backgroundColor: Colors.orange,
        elevation: 0,
      ),

      body: SafeArea(
        child: Column(
          children: [

            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: [

                    // 🔥 IMAGE CARD
                    _card(
                      child: Column(
                        children: [
                          const Text(
                            "Pet Images",
                            style: TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 16),
                          ),
                          const SizedBox(height: 10),

                          Wrap(
                            spacing: 10,
                            children: images
                                .map((img) => ClipRRect(
                                      borderRadius:
                                          BorderRadius.circular(12),
                                      child: Image.file(
                                        img,
                                        height: 75,
                                        width: 75,
                                        fit: BoxFit.cover,
                                      ),
                                    ))
                                .toList(),
                          ),

                          const SizedBox(height: 12),

                          Row(
                            mainAxisAlignment:
                                MainAxisAlignment.spaceEvenly,
                            children: [
                              _imgButton(
                                  "Camera", Icons.camera,
                                  () => pickImage(ImageSource.camera)),
                              _imgButton(
                                  "Gallery", Icons.photo,
                                  () => pickImage(ImageSource.gallery)),
                            ],
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 16),

                    // 🔥 PET DETAILS
                    _card(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text("Pet Details",
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16)),

                          const SizedBox(height: 10),

                          _input("Pet Name", nameController),
                          _input("Breed", breedController),
                          _input("Color", colorController),

                          TextFormField(
                            controller: locationController,
                            decoration: InputDecoration(
                              labelText: "Last Seen Location",
                              filled: true,
                              fillColor: Colors.white,
                              border: OutlineInputBorder(
                                borderRadius:
                                    BorderRadius.circular(15),
                              ),
                              suffixIcon: IconButton(
                                icon: const Icon(Icons.my_location),
                                onPressed: fetchLocation,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 16),

                    // 🔥 OWNER DETAILS
                    _card(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text("Owner Details",
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16)),

                          const SizedBox(height: 10),

                          _input("Owner Name", ownerController),
                          _input("Phone Number", phoneController),
                        ],
                      ),
                    ),

                    const SizedBox(height: 80),
                  ],
                ),
              ),
            ),

            // 🔥 SUBMIT BUTTON
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.08),
                    blurRadius: 10,
                  )
                ],
              ),
              child: ElevatedButton(
                onPressed: submitForm,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.orange,
                  minimumSize: const Size(double.infinity, 55),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                ),
                child: const Text(
                  "Submit Report",
                  style: TextStyle(fontSize: 16),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget _card({required Widget child}) {
    return Container(
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            Colors.white,
            Colors.orange.withOpacity(0.08),
          ],
        ),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.orange.withOpacity(0.15),
            blurRadius: 12,
          )
        ],
      ),
      child: child,
    );
  }

  Widget _input(String label, TextEditingController controller) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: TextFormField(
        controller: controller,
        validator: (val) =>
            val == null || val.isEmpty ? "Required" : null,
        decoration: InputDecoration(
          labelText: label,
          filled: true,
          fillColor: Colors.white,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(15),
          ),
        ),
      ),
    );
  }

  Widget _imgButton(String text, IconData icon, VoidCallback onTap) {
    return ElevatedButton.icon(
      onPressed: onTap,
      icon: Icon(icon),
      label: Text(text),
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.orange.shade200,
        foregroundColor: Colors.black,
        elevation: 4,
      ),
    );
  }
}