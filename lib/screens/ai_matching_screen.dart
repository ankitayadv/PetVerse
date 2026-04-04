import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import '../data/lost_pet_data.dart';
import '../routes/app_routes.dart';

class AiMatchingScreen extends StatefulWidget {
  const AiMatchingScreen({super.key});

  @override
  State<AiMatchingScreen> createState() => _AiMatchingScreenState();
}

class _AiMatchingScreenState extends State<AiMatchingScreen> {

  // 🔥 MATCH LOGIC
  double calculateMatch(Map<String, dynamic> a, Map<String, dynamic> b) {
    double score = 0;

    if (a["breed"]?.toLowerCase() == b["breed"]?.toLowerCase()) score += 40;
    if (a["color"]?.toLowerCase() == b["color"]?.toLowerCase()) score += 20;

    if (a["location"]
        .toLowerCase()
        .contains(b["location"].toLowerCase())) score += 20;

    if (a["name"]
        .toLowerCase()
        .contains(b["name"].toLowerCase())) score += 20;

    return score;
  }

  // 📞 CALL OWNER
  Future<void> callOwner(String phone) async {
    final Uri url = Uri.parse("tel:$phone");

    if (await canLaunchUrl(url)) {
      await launchUrl(url);
    }
  }

  @override
  Widget build(BuildContext context) {
    final pet =
        ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;

    final oppositeType = pet["type"] == "LOST" ? "FOUND" : "LOST";

    final candidates = LostPetData.pets
        .where((p) => p["type"] == oppositeType)
        .toList();

    List<Map<String, dynamic>> results = [];

    for (var c in candidates) {
      double match = calculateMatch(pet, c);

      results.add({
        "pet": c,
        "score": match,
      });
    }

    results.sort((a, b) => b["score"].compareTo(a["score"]));

    return Scaffold(
      backgroundColor: const Color(0xFFFFF4EC),

      appBar: AppBar(
        title: const Text("AI Matching Results"),
        backgroundColor: Colors.orange,
        elevation: 0,
      ),

      body: Padding(
        padding: const EdgeInsets.all(16),
        child: results.isEmpty
            ? const Center(child: Text("No matches found"))
            : ListView.builder(
                itemCount: results.length,
                itemBuilder: (context, index) {
                  final item = results[index];
                  final matchPet = item["pet"];
                  final score = item["score"];
                  final isTop = index == 0;

                  return _card(context, matchPet, score, isTop);
                },
              ),
      ),
    );
  }

  // 🔥 PREMIUM CARD
  Widget _card(BuildContext context, Map pet, double score, bool isTop) {
    Color color;
    if (score > 70) {
      color = Colors.green;
    } else if (score > 40) {
      color = Colors.orange;
    } else {
      color = Colors.red;
    }

    return TweenAnimationBuilder<double>(
      tween: Tween(begin: 0, end: score),
      duration: const Duration(milliseconds: 800),
      builder: (context, value, _) {
        return Container(
          margin: const EdgeInsets.only(bottom: 18),
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: isTop
                  ? [Colors.orange.shade200, Colors.orange.shade50]
                  : [Colors.white, Colors.orange.withOpacity(0.08)],
            ),
            borderRadius: BorderRadius.circular(20),
            boxShadow: [
              BoxShadow(
                color: isTop
                    ? Colors.orange.withOpacity(0.5)
                    : Colors.orange.withOpacity(0.2),
                blurRadius: isTop ? 25 : 12,
              )
            ],
            border:
                isTop ? Border.all(color: Colors.orange, width: 2) : null,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [

              // 🔥 HEADER
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    pet["name"],
                    style: const TextStyle(
                        fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  Text(
                    "${value.toInt()}%",
                    style: TextStyle(
                      color: color,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 8),

              if (isTop)
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                  decoration: BoxDecoration(
                    color: Colors.orange,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: const Text(
                    "🏆 Best Match",
                    style: TextStyle(color: Colors.white),
                  ),
                ),

              const SizedBox(height: 10),

              Text("Breed: ${pet["breed"]}"),
              Text("Color: ${pet["color"]}"),
              Text("Location: ${pet["location"]}"),

              const SizedBox(height: 12),

              LinearProgressIndicator(
                value: value / 100,
                color: color,
                backgroundColor: Colors.grey[200],
                minHeight: 8,
              ),

              const SizedBox(height: 12),

              // 🔥 ACTION BUTTONS
              Row(
                children: [

                  // VIEW DETAILS
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.pushNamed(
                          context,
                          AppRoutes.petDetail,
                          arguments: pet,
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.orange,
                      ),
                      child: const Text("View"),
                    ),
                  ),

                  const SizedBox(width: 10),

                  // CALL
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () =>
                          callOwner(pet["phone"] ?? "1234567890"),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.green,
                      ),
                      child: const Text("Call"),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 10),

              // 🔥 REUNION BUTTON (ONLY TOP MATCH)
              if (isTop && score > 60)
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.pushNamed(
                        context,
                        AppRoutes.reunion,
                        arguments: pet,
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.black,
                    ),
                    child: const Text("Mark as Reunited 🎉"),
                  ),
                ),
            ],
          ),
        );
      },
    );
  }
}