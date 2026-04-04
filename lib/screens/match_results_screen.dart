import 'dart:io';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class MatchResultScreen extends StatelessWidget {
  const MatchResultScreen({super.key});

  Widget _buildImage(String? path) {
    if (path == null) {
      return Image.asset(
        "assets/images/pet_profile.png",
        height: 220,
        width: double.infinity,
        fit: BoxFit.cover,
      );
    }

    if (path.startsWith("assets/")) {
      return Image.asset(
        path,
        height: 220,
        width: double.infinity,
        fit: BoxFit.cover,
      );
    } else {
      return Image.file(
        File(path),
        height: 220,
        width: double.infinity,
        fit: BoxFit.cover,
      );
    }
  }

  Future<void> _call(String phone) async {
    final Uri url = Uri.parse("tel:$phone");
    if (await canLaunchUrl(url)) {
      await launchUrl(url);
    }
  }

  @override
  Widget build(BuildContext context) {
    final pet =
        ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>?;

    return Scaffold(
      backgroundColor: const Color(0xFFFFF4EC),

      appBar: AppBar(
        title: const Text("Match Found"),
        backgroundColor: Colors.orange,
        elevation: 0,
      ),

      body: SingleChildScrollView(
        child: Column(
          children: [

            // 🔥 TOP CELEBRATION
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(20),
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  colors: [Colors.orange, Colors.deepOrange],
                ),
                borderRadius: BorderRadius.vertical(
                  bottom: Radius.circular(30),
                ),
              ),
              child: const Column(
                children: [
                  Icon(Icons.celebration,
                      color: Colors.white, size: 50),
                  SizedBox(height: 10),
                  Text(
                    "We Found a Match! 🎉",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 5),
                  Text(
                    "Your pet is closer than ever 💛",
                    style: TextStyle(color: Colors.white70),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 20),

            // 🔥 PET IMAGE
            ClipRRect(
              borderRadius: BorderRadius.circular(20),
              child: _buildImage(pet?["image"]),
            ),

            const SizedBox(height: 20),

            // 🔥 DETAILS CARD
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 16),
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
                    color: Colors.orange.withOpacity(0.2),
                    blurRadius: 12,
                  )
                ],
              ),
              child: Column(
                children: [

                  _row("Name", pet?["name"]),
                  _row("Breed", pet?["breed"]),
                  _row("Location", pet?["location"]),

                  const SizedBox(height: 15),

                  const Text(
                    "✨ Reunite with your furry friend now!",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.orange,
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 25),

            // 🔥 ACTION BUTTONS
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Column(
                children: [

                  // CALL
                  ElevatedButton.icon(
                    onPressed: () =>
                        _call(pet?["phone"] ?? "1234567890"),
                    icon: const Icon(Icons.call),
                    label: const Text("Call Now"),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green,
                      minimumSize:
                          const Size(double.infinity, 55),
                      shape: RoundedRectangleBorder(
                        borderRadius:
                            BorderRadius.circular(15),
                      ),
                    ),
                  ),

                  const SizedBox(height: 12),

                  // DIRECTIONS (future maps)
                  ElevatedButton.icon(
                    onPressed: () {},
                    icon: const Icon(Icons.map),
                    label: const Text("View Location"),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.orange,
                      minimumSize:
                          const Size(double.infinity, 55),
                    ),
                  ),

                  const SizedBox(height: 12),

                  // DONE
                  OutlinedButton(
                    onPressed: () {
                      Navigator.popUntil(
                          context, (route) => route.isFirst);
                    },
                    child: const Text("Done"),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 30),
          ],
        ),
      ),
    );
  }

  Widget _row(String title, dynamic value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        mainAxisAlignment:
            MainAxisAlignment.spaceBetween,
        children: [
          Text(title,
              style: const TextStyle(color: Colors.grey)),
          Text(value ?? "-",
              style: const TextStyle(
                  fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }
}