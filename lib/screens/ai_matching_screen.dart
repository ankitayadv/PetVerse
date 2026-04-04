import 'package:flutter/material.dart';
import '../data/lost_pet_data.dart';

class AiMatchingScreen extends StatelessWidget {
  const AiMatchingScreen({super.key});

  // 🔥 MATCH LOGIC
  double calculateMatch(Map<String, dynamic> a, Map<String, dynamic> b) {
    double score = 0;

    // BREED
    if (a["breed"]?.toString().toLowerCase() ==
        b["breed"]?.toString().toLowerCase()) {
      score += 40;
    }

    // COLOR
    if (a["color"]?.toString().toLowerCase() ==
        b["color"]?.toString().toLowerCase()) {
      score += 20;
    }

    // LOCATION (simple contains match)
    if (a["location"]
        .toString()
        .toLowerCase()
        .contains(b["location"].toString().toLowerCase())) {
      score += 20;
    }

    // NAME similarity (basic)
    if (a["name"]
        .toString()
        .toLowerCase()
        .contains(b["name"].toString().toLowerCase())) {
      score += 20;
    }

    return score;
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

    // 🔥 SORT BY BEST MATCH
    results.sort((a, b) => b["score"].compareTo(a["score"]));

    return Scaffold(
      appBar: AppBar(
        title: const Text("AI Matching"),
      ),

      body: Padding(
        padding: const EdgeInsets.all(16),
        child: results.isEmpty
            ? const Center(child: Text("No candidates found"))
            : ListView.builder(
                itemCount: results.length,
                itemBuilder: (context, index) {
                  final item = results[index];
                  final matchPet = item["pet"];
                  final score = item["score"];

                  return Container(
                    margin: const EdgeInsets.only(bottom: 15),
                    padding: const EdgeInsets.all(14),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(15),
                      gradient: LinearGradient(
                        colors: [
                          Colors.white,
                          Colors.orange.withOpacity(0.1)
                        ],
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.orange.withOpacity(0.2),
                          blurRadius: 10,
                        )
                      ],
                    ),

                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [

                        // NAME + %
                        Row(
                          mainAxisAlignment:
                              MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              matchPet["name"],
                              style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16),
                            ),

                            Text(
                              "${score.toInt()}% Match",
                              style: TextStyle(
                                color: score > 70
                                    ? Colors.green
                                    : score > 40
                                        ? Colors.orange
                                        : Colors.red,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),

                        const SizedBox(height: 10),

                        // DETAILS
                        Text("Breed: ${matchPet["breed"]}"),
                        Text("Color: ${matchPet["color"]}"),
                        Text("Location: ${matchPet["location"]}"),

                        const SizedBox(height: 10),

                        // PROGRESS BAR
                        LinearProgressIndicator(
                          value: score / 100,
                          backgroundColor: Colors.grey[200],
                          color: score > 70
                              ? Colors.green
                              : score > 40
                                  ? Colors.orange
                                  : Colors.red,
                        ),
                      ],
                    ),
                  );
                },
              ),
      ),
    );
  }
}