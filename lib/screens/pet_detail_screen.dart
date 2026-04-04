import 'dart:io';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import '../routes/app_routes.dart';

class PetDetailScreen extends StatelessWidget {
  const PetDetailScreen({super.key});

  // 🔥 IMAGE HANDLER
  Widget _buildImage(String? path) {
    if (path == null) {
      return Image.asset(
        "assets/images/pet_profile.png",
        fit: BoxFit.cover,
        width: double.infinity,
        height: 250,
      );
    }

    if (path.startsWith("assets/")) {
      return Image.asset(
        path,
        fit: BoxFit.cover,
        width: double.infinity,
        height: 250,
      );
    } else {
      return Image.file(
        File(path),
        fit: BoxFit.cover,
        width: double.infinity,
        height: 250,
      );
    }
  }

  // 📞 CALL FUNCTION
  Future<void> _callOwner(String phone) async {
    final Uri url = Uri.parse("tel:$phone");

    if (await canLaunchUrl(url)) {
      await launchUrl(url);
    } else {
      throw "Cannot make call";
    }
  }

  @override
  Widget build(BuildContext context) {
    final pet =
        ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>?;

    if (pet == null || pet.isEmpty) {
      return const Scaffold(
        body: Center(child: Text("No data received")),
      );
    }

    final isLost = pet["type"] == "LOST";

    return Scaffold(
      backgroundColor: Colors.white,

      appBar: AppBar(
        title: const Text("Pet Details"),
        backgroundColor: Colors.white,
        elevation: 0,
        foregroundColor: Colors.black,
      ),

      body: Column(
        children: [

          // 🔥 IMAGE
          ClipRRect(
            borderRadius: const BorderRadius.vertical(
              bottom: Radius.circular(25),
            ),
            child: Stack(
              children: [
                _buildImage(pet["image"]),

                // 🔥 slight gradient overlay (premium feel)
                Container(
                  height: 250,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        Colors.black.withOpacity(0.2),
                        Colors.transparent,
                      ],
                      begin: Alignment.bottomCenter,
                      end: Alignment.topCenter,
                    ),
                  ),
                ),
              ],
            ),
          ),

          // 🔥 DETAILS
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(16),

              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [

                  // NAME + STATUS
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        pet["name"] ?? "Unknown",
                        style: const TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                        ),
                      ),

                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 12, vertical: 6),
                        decoration: BoxDecoration(
                          color: isLost
                              ? Colors.red.withOpacity(0.1)
                              : Colors.green.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Text(
                          pet["type"],
                          style: TextStyle(
                            color: isLost ? Colors.red : Colors.green,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 20),

                  // 🔥 INFO CARD
                  _infoCard(
                    children: [
                      _infoRow("Breed", pet["breed"]),
                      _infoRow("Color", pet["color"]),
                      _infoRow("Location", pet["location"]),
                      _infoRow("Reported", pet["time"]),
                    ],
                  ),

                  const SizedBox(height: 20),

                  // 📞 CONTACT OWNER
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton.icon(
                      onPressed: () =>
                          _callOwner(pet["phone"] ?? "1234567890"),
                      icon: const Icon(Icons.call),
                      label: const Text("Contact Owner"),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.orange,
                        padding:
                            const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(
                          borderRadius:
                              BorderRadius.circular(15),
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(height: 15),

                  // 🧠 AI MATCH BUTTON
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.pushNamed(
                          context,
                          AppRoutes.aiMatch,
                          arguments: pet,
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.black,
                        padding:
                            const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(
                          borderRadius:
                              BorderRadius.circular(15),
                        ),
                      ),
                      child: const Text("AI Match"),
                    ),
                  ),

                  const SizedBox(height: 15),

                  // ❤️ FOUND MY PET BUTTON
                  SizedBox(
                    width: double.infinity,
                    child: OutlinedButton(
                      onPressed: () {
                        Navigator.pushNamed(
                          context,
                          AppRoutes.reunion,
                          arguments: pet,
                        );
                      },
                      style: OutlinedButton.styleFrom(
                        padding:
                            const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(
                          borderRadius:
                              BorderRadius.circular(15),
                        ),
                      ),
                      child: const Text("Found My Pet 🎉"),
                    ),
                  ),

                  const SizedBox(height: 25),

                  // 🔥 MATCH LOGIC HINT (makes app feel smart)
                  Container(
                    padding: const EdgeInsets.all(14),
                    decoration: BoxDecoration(
                      color: Colors.orange.withOpacity(0.08),
                      borderRadius: BorderRadius.circular(15),
                    ),
                    child: const Text(
                      "💡 Tip: AI Match helps compare lost and found pets based on breed, color, and location.",
                      style: TextStyle(fontSize: 13),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  // 🔥 CARD
  Widget _infoCard({required List<Widget> children}) {
    return Container(
      padding: const EdgeInsets.all(16),
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
      child: Column(children: children),
    );
  }

  // 🔥 ROW
  Widget _infoRow(String title, dynamic value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(title, style: const TextStyle(color: Colors.grey)),
          Text(value ?? "-",
              style: const TextStyle(fontWeight: FontWeight.w600)),
        ],
      ),
    );
  }
}