import 'package:flutter/material.dart';
import 'dart:io';
import '../routes/app_routes.dart';
import '../data/lost_pet_data.dart';

class NearbyLostFoundScreen extends StatefulWidget {
  const NearbyLostFoundScreen({super.key});

  @override
  State<NearbyLostFoundScreen> createState() =>
      _NearbyLostFoundScreenState();
}

class _NearbyLostFoundScreenState extends State<NearbyLostFoundScreen> {
  String filter = "ALL";
  String searchQuery = "";

  @override
  void initState() {
    super.initState();

    // 🔥 FIX: LOAD INITIAL DATA INTO NOTIFIER
    if (LostPetData.petsNotifier.value.isEmpty) {
      LostPetData.petsNotifier.value = List.from(LostPetData.pets);
    }
  }

  // 🔥 FILTER + SEARCH
  List<Map<String, dynamic>> get filteredPets {
    final pets = LostPetData.petsNotifier.value;

    return pets.where((pet) {
      final matchesFilter =
          filter == "ALL" || pet["type"] == filter;

      final matchesSearch = pet["name"]
          .toString()
          .toLowerCase()
          .contains(searchQuery.toLowerCase());

      return matchesFilter && matchesSearch;
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,

      appBar: AppBar(
        title: const Text("Nearby Pets"),
        centerTitle: true,
        backgroundColor: Colors.white,
        elevation: 0,
        foregroundColor: Colors.black,
      ),

      floatingActionButton: FloatingActionButton.extended(
        backgroundColor: Colors.orange,
        onPressed: () async {
          await Navigator.pushNamed(context, AppRoutes.reportLost);
        },
        label: const Text("Report"),
        icon: const Icon(Icons.add),
      ),

      body: Column(
        children: [

          // 🔥 SEARCH BAR
          Padding(
            padding: const EdgeInsets.all(12),
            child: TextField(
              onChanged: (value) {
                setState(() {
                  searchQuery = value;
                });
              },
              decoration: InputDecoration(
                hintText: "Search pet by name...",
                prefixIcon: const Icon(Icons.search),
                filled: true,
                fillColor: Colors.grey.shade100,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(15),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
          ),

          // 🔥 FILTER
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12),
            child: Row(
              children: [
                _chip("ALL"),
                _chip("LOST"),
                _chip("FOUND"),
              ],
            ),
          ),

          const SizedBox(height: 8),

          // 🔥 ACTIONS
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12),
            child: Row(
              children: [
                _topButton("Map View", Icons.map, () {
                  Navigator.pushNamed(context, AppRoutes.mapView);
                }),
                const SizedBox(width: 10),
                _topButton("My Reports", Icons.list, () {}),
              ],
            ),
          ),

          const SizedBox(height: 10),

          // 🔥 LIST
          Expanded(
            child: ValueListenableBuilder(
              valueListenable: LostPetData.petsNotifier,
              builder: (context, pets, _) {
                final list = filteredPets;

                if (list.isEmpty) return _emptyState();

                return ListView.builder(
                  padding: const EdgeInsets.all(14),
                  itemCount: list.length,
                  itemBuilder: (_, i) {
                    final pet = list[i];
                    return _petCard(context, pet);
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  // 🔥 CHIP
  Widget _chip(String text) {
    final isSelected = filter == text;

    return Padding(
      padding: const EdgeInsets.only(right: 8),
      child: ChoiceChip(
        label: Text(text),
        selected: isSelected,
        selectedColor: Colors.orange.shade200,
        onSelected: (_) => setState(() => filter = text),
      ),
    );
  }

  // 🔥 BUTTON
  Widget _topButton(String text, IconData icon, VoidCallback onTap) {
    return Expanded(
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(15),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 14),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                Colors.orange.shade200,
                Colors.orange.shade100,
              ],
            ),
            borderRadius: BorderRadius.circular(15),
            boxShadow: [
              BoxShadow(
                color: Colors.orange.withOpacity(0.3),
                blurRadius: 15,
                offset: const Offset(0, 6),
              )
            ],
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon),
              const SizedBox(width: 6),
              Text(text,
                  style: const TextStyle(fontWeight: FontWeight.w600)),
            ],
          ),
        ),
      ),
    );
  }

  // 🔥 CARD
  Widget _petCard(BuildContext context, Map<String, dynamic> pet) {
    final isLost = pet["type"] == "LOST";

    return InkWell(
      onTap: () {
        Navigator.pushNamed(
          context,
          AppRoutes.petDetail,
          arguments: pet,
        );
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 18),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          gradient: LinearGradient(
            colors: [Colors.white, Colors.orange.shade50],
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.orange.withOpacity(0.15),
              blurRadius: 20,
              offset: const Offset(0, 10),
            )
          ],
        ),
        child: Column(
          children: [

            ClipRRect(
              borderRadius:
                  const BorderRadius.vertical(top: Radius.circular(20)),
              child: _buildImage(pet["image"]),
            ),

            Padding(
              padding: const EdgeInsets.all(14),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [

                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        pet["name"] ?? "Unknown",
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),

                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 12, vertical: 5),
                        decoration: BoxDecoration(
                          color: isLost
                              ? Colors.red.withOpacity(0.1)
                              : Colors.green.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(30),
                        ),
                        child: Text(
                          pet["type"] ?? "",
                          style: TextStyle(
                            color: isLost ? Colors.red : Colors.green,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 8),

                  Row(
                    children: [
                      const Icon(Icons.location_on, size: 16),
                      const SizedBox(width: 5),
                      Expanded(
                        child: Text(pet["location"] ?? "Unknown"),
                      ),
                    ],
                  ),

                  const SizedBox(height: 4),

                  Text(
                    pet["time"] ?? "",
                    style: const TextStyle(
                        fontSize: 12, color: Colors.grey),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // 🔥 IMAGE
  Widget _buildImage(String? path) {
    if (path == null) {
      return Image.asset(
        "assets/images/pet_profile.png",
        height: 180,
        width: double.infinity,
        fit: BoxFit.cover,
      );
    }

    if (path.startsWith("assets/")) {
      return Image.asset(
        path,
        height: 180,
        width: double.infinity,
        fit: BoxFit.cover,
      );
    } else {
      return Image.file(
        File(path),
        height: 180,
        width: double.infinity,
        fit: BoxFit.cover,
      );
    }
  }

  // 🔥 EMPTY
  Widget _emptyState() {
    return const Center(
      child: Text(
        "No pets found 🐾",
        style: TextStyle(color: Colors.grey),
      ),
    );
  }
}