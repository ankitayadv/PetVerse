import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';

import '../data/lost_pet_data.dart';

class ReportFoundScreen extends StatefulWidget {
  const ReportFoundScreen({super.key});

  @override
  State<ReportFoundScreen> createState() => _ReportFoundScreenState();
}

class _ReportFoundScreenState extends State<ReportFoundScreen> {
  final _formKey = GlobalKey<FormState>();

  final nameController = TextEditingController();
  final breedController = TextEditingController();
  final colorController = TextEditingController();
  final finderController = TextEditingController();
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

  // 🚀 SUBMIT
  void submitForm() {
    if (_formKey.currentState!.validate()) {
      LostPetData.addPet({
        "name": nameController.text,
        "type": "FOUND",
        "location": locationController.text,
        "lat": lat ?? 28.6139,
        "lng": lng ?? 77.2090,
        "breed": breedController.text,
        "color": colorController.text,
        "time": "Just now",
        "image": images.isNotEmpty
            ? images.first.path
            : "assets/images/pet_profile.png",
      });

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Found Pet Report Submitted")),
      );

      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFFF4EC),

      appBar: AppBar(
        title: const Text("Report Found Pet"),
        backgroundColor: Colors.orange,
        elevation: 0,
      ),

      body: SafeArea(
        child: Column(
          children: [

            // 🔥 SCROLL AREA
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(16),
                child: Form(
                  key: _formKey,
                  child: Column(
                    children: [

                      // 🔥 IMAGE CARD
                      _card(
                        child: Column(
                          children: [
                            const Text(
                              "Pet Images",
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16),
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
                                    "Camera",
                                    Icons.camera,
                                    () => pickImage(
                                        ImageSource.camera)),
                                _imgButton(
                                    "Gallery",
                                    Icons.photo,
                                    () => pickImage(
                                        ImageSource.gallery)),
                              ],
                            ),
                          ],
                        ),
                      ),

                      const SizedBox(height: 16),

                      // 🔥 PET DETAILS
                      _card(
                        child: Column(
                          crossAxisAlignment:
                              CrossAxisAlignment.start,
                          children: [
                            const Text("Pet Details",
                                style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16)),

                            const SizedBox(height: 10),

                            _input("Pet Name (if known)", nameController),
                            _input("Breed", breedController),
                            _input("Color", colorController),

                            TextFormField(
                              controller: locationController,
                              decoration: InputDecoration(
                                labelText: "Found Location",
                                filled: true,
                                fillColor: Colors.white,
                                border: OutlineInputBorder(
                                  borderRadius:
                                      BorderRadius.circular(15),
                                ),
                                suffixIcon: IconButton(
                                  icon: const Icon(
                                      Icons.my_location),
                                  onPressed: fetchLocation,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),

                      const SizedBox(height: 16),

                      // 🔥 FINDER DETAILS
                      _card(
                        child: Column(
                          crossAxisAlignment:
                              CrossAxisAlignment.start,
                          children: [
                            const Text("Finder Details",
                                style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16)),

                            const SizedBox(height: 10),

                            _input("Your Name", finderController),
                            _input("Phone Number", phoneController),
                          ],
                        ),
                      ),

                      const SizedBox(height: 80),
                    ],
                  ),
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
                  backgroundColor: Colors.green,
                  minimumSize: const Size(double.infinity, 55),
                  shape: RoundedRectangleBorder(
                    borderRadius:
                        BorderRadius.circular(15),
                  ),
                ),
                child: const Text(
                  "Submit Found Report",
                  style: TextStyle(fontSize: 16),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  // 🔥 CARD
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

  // 🔥 INPUT
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

  // 🔥 BUTTON
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