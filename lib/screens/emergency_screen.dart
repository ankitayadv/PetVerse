import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:scrollable_positioned_list/scrollable_positioned_list.dart';

class EmergencyScreen extends StatefulWidget {
  const EmergencyScreen({super.key});

  @override
  State<EmergencyScreen> createState() => _EmergencyScreenState();
}

class _EmergencyScreenState extends State<EmergencyScreen>
    with SingleTickerProviderStateMixin {

  final ItemScrollController itemScrollController = ItemScrollController();

  late AnimationController _pulseController;

  final Map<int, int> sectionIndexMap = {
    0: 3,
    1: 4,
    2: 5,
    3: 6,
    4: 7,
  };

  @override
  void initState() {
    super.initState();

    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    _pulseController.dispose();
    super.dispose();
  }

  Future<void> _makeCall(String phoneNumber) async {
    final Uri uri = Uri(scheme: 'tel', path: phoneNumber);

    if (await canLaunchUrl(uri)) {
      await launchUrl(uri);
    } else {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Could not open dialer")),
        );
      }
    }
  }

  Future<void> _openVideo(String url) async {
    final Uri uri = Uri.parse(url);

    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    } else {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Could not open video")),
        );
      }
    }
  }

  void _scrollToSection(int index) {
    final targetIndex = sectionIndexMap[index];
    if (targetIndex != null) {
      itemScrollController.scrollTo(
        index: targetIndex,
        duration: const Duration(milliseconds: 600),
        curve: Curves.easeInOutCubic,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        leading: const BackButton(color: Colors.black),
        title: const Text(
          "Emergency Help 🚨",
          style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
      ),

      body: ScrollablePositionedList.builder(
        itemCount: 8,
        itemScrollController: itemScrollController,
        padding: const EdgeInsets.all(16),
        itemBuilder: (context, index) {

          switch (index) {

            case 0:
              return _buildHeader();

            case 1:
              return _buildTopGrid();

            case 2:
              return _buildContactSection();

            case 3:
              return _infoCard(
                "CPR",
                Colors.red,
                [
                  "Check breathing immediately",
                  "Lay dog on its side",
                  "Give 30 chest compressions",
                  "Give 2 mouth-to-snout breaths"
                ],
                "https://www.youtube.com/results?search_query=dog+cpr"
              );

            case 4:
              return _infoCard(
                "Choking",
                Colors.blue,
                [
                  "Check mouth for object",
                  "Perform Heimlich maneuver",
                  "Keep pet calm and steady"
                ],
                "https://www.youtube.com/results?search_query=dog+choking+help"
              );

            case 5:
              return _infoCard(
                "Heatstroke",
                Colors.orange,
                [
                  "Move pet to shaded area",
                  "Cool paws and ears gently",
                  "Give small sips of water"
                ],
                "https://www.youtube.com/results?search_query=dog+heatstroke+first+aid"
              );

            case 6:
              return _infoCard(
                "Heat Cycle",
                Colors.purple,
                [
                  "Keep pet indoors",
                  "Use hygiene products",
                  "Expect behavior changes"
                ],
                null
              );

            case 7:
              return _infoCard(
                "Periods",
                Colors.pink,
                [
                  "Check discharge regularly",
                  "Keep bedding clean",
                  "Consult vet if needed"
                ],
                null
              );

            default:
              return const SizedBox();
          }
        },
      ),
    );
  }

  Widget _buildHeader() {
    return Column(
      children: [
        AnimatedBuilder(
          animation: _pulseController,
          builder: (_, child) {
            return Transform.scale(
              scale: 1 + (_pulseController.value * 0.05),
              child: Container(
                height: 55,
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [Colors.orange, Colors.deepOrange],
                  ),
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.orange.withOpacity(0.5),
                      blurRadius: 25,
                      spreadRadius: 2,
                    )
                  ],
                ),
                child: const Center(
                  child: Text(
                    "SOS",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            );
          },
        ),
        const SizedBox(height: 20),
      ],
    );
  }

  Widget _buildTopGrid() {
    return GridView.count(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      crossAxisCount: 3,
      childAspectRatio: 1.1,
      mainAxisSpacing: 12,
      crossAxisSpacing: 12,
      children: [
        _animatedCard(0, Icons.favorite, "CPR", Colors.red),
        _animatedCard(1, Icons.pets, "Choking", Colors.blue),
        _animatedCard(2, Icons.thermostat, "Heat", Colors.orange),
        _animatedCard(3, Icons.cyclone, "Cycle", Colors.purple),
        _animatedCard(4, Icons.water_drop, "Periods", Colors.pink),
        _animatedCard(0, Icons.medical_services, "Bleeding", Colors.redAccent),
      ],
    );
  }

  Widget _animatedCard(int index, IconData icon, String label, Color color) {
    return GestureDetector(
      onTap: () => _scrollToSection(index),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(18),
          boxShadow: [
            BoxShadow(
              color: color.withOpacity(0.25),
              blurRadius: 15,
              offset: const Offset(0, 6),
            ),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, color: color, size: 26),
            const SizedBox(height: 8),
            Text(label, style: const TextStyle(fontSize: 12)),
          ],
        ),
      ),
    );
  }

  Widget _buildContactSection() {
    return Column(
      children: [
        _contactTile("Vet Clinic", "9112345678"),
        _contactTile("Dog Service", "101"),
        _contactTile("Ambulance", "102"),
        const SizedBox(height: 20),
      ],
    );
  }

  Widget _contactTile(String title, String phone) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        boxShadow: [
          BoxShadow(color: Colors.grey.withOpacity(0.2), blurRadius: 12)
        ],
      ),
      child: ListTile(
        leading: const Icon(Icons.phone, color: Colors.green),
        title: Text(title),
        trailing: ElevatedButton(
          onPressed: () => _makeCall(phone),
          child: const Text("Call"),
        ),
      ),
    );
  }

  Widget _infoCard(String title, Color color, List<String> steps, String? url) {
    return Container(
      margin: const EdgeInsets.only(bottom: 18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        boxShadow: [
          BoxShadow(
            color: color.withOpacity(0.15),
            blurRadius: 20,
            offset: const Offset(0, 8),
          )
        ],
      ),
      child: Column(
        children: [

          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: color,
              borderRadius: const BorderRadius.vertical(top: Radius.circular(18)),
            ),
            child: Text(
              title,
              style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
            ),
          ),

          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [

                ...steps.map((e) => Padding(
                  padding: const EdgeInsets.only(bottom: 10),
                  child: Text(
                    "• $e",
                    style: const TextStyle(
                      fontSize: 15, // 🔥 BIGGER TEXT
                      height: 1.5,
                    ),
                  ),
                )),

                if (url != null) ...[
                  const SizedBox(height: 10),
                  ElevatedButton.icon(
                    onPressed: () => _openVideo(url),
                    icon: const Icon(Icons.play_circle),
                    label: const Text("Watch Video"),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: color,
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                  )
                ]
              ],
            ),
          ),
        ],
      ),
    );
  }
}