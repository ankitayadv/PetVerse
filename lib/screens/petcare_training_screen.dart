import 'package:flutter/material.dart';

class PetcareTrainingScreen extends StatefulWidget {
  const PetcareTrainingScreen({super.key});

  @override
  State<PetcareTrainingScreen> createState() =>
      _PetcareTrainingScreenState();
}

class _PetcareTrainingScreenState
    extends State<PetcareTrainingScreen> {
  final TextEditingController _searchController =
      TextEditingController();

  /// ✅ Updated image paths (IMPORTANT)
  final List<Map<String, String>> _allTrainings = [
    {
      "title": "Puppy Training",
      "image": "assets/images/petcare_training_screen.jpg",
    },
    {
      "title": "Obedience Training",
      "image": "assets/images/petcare_obedience_screen.jpeg", // ✅ fixed
    },
    {
      "title": "Behavior Training",
      "image": "assets/images/petcare_behavior_screen.jpg",
    },
  ];

  List<Map<String, String>> _filteredTrainings = [];

  @override
  void initState() {
    super.initState();
    _filteredTrainings = List.from(_allTrainings);
  }

  void _runFilter(String keyword) {
    setState(() {
      if (keyword.isEmpty) {
        _filteredTrainings = List.from(_allTrainings);
      } else {
        _filteredTrainings = _allTrainings
            .where((item) => item['title']!
                .toLowerCase()
                .contains(keyword.toLowerCase()))
            .toList();
      }
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _openTrainingPage(String title) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) =>
            TrainingDetailScreen(title: title),
      ),
    );
  }

  void _openNotifications() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) =>
            const NotificationScreen(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,

      /// 🔝 AppBar
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon:
              const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          "Training",
          style: TextStyle(
              color: Colors.black,
              fontWeight: FontWeight.bold),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.notifications_none,
                color: Colors.black),
            onPressed: _openNotifications,
          )
        ],
      ),

      /// 📱 Body
      body: GestureDetector(
        onTap: () => FocusScope.of(context).unfocus(),
        child: Padding(
          padding:
              const EdgeInsets.symmetric(horizontal: 16),
          child: Column(
            children: [
              const SizedBox(height: 10),

              /// 🔍 Search Bar
              TextField(
                controller: _searchController,
                onChanged: _runFilter,
                decoration: InputDecoration(
                  hintText: "Search training...",
                  prefixIcon: const Icon(Icons.search,
                      color: Colors.grey),
                  filled: true,
                  fillColor: Colors.grey[100],
                  border: OutlineInputBorder(
                    borderRadius:
                        BorderRadius.circular(15),
                    borderSide: BorderSide.none,
                  ),
                ),
              ),

              const SizedBox(height: 20),

              /// 📋 Training List
              Expanded(
                child: _filteredTrainings.isEmpty
                    ? const Center(
                        child: Text(
                          "No training found 🐾",
                          style: TextStyle(
                              color: Colors.grey),
                        ),
                      )
                    : ListView.builder(
                        itemCount:
                            _filteredTrainings.length,
                        itemBuilder:
                            (context, index) {
                          final item =
                              _filteredTrainings[
                                  index];
                          return _buildCard(
                            item['title']!,
                            item['image']!,
                          );
                        },
                      ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  /// 🐾 Training Card
  Widget _buildCard(
      String title, String imagePath) {
    return GestureDetector(
      onTap: () => _openTrainingPage(title),
      child: Container(
        margin: const EdgeInsets.only(bottom: 20),
        child: ClipRRect(
          borderRadius:
              BorderRadius.circular(20),
          child: Stack(
            children: [
              Image.asset(
                imagePath,
                height: 160,
                width: double.infinity,
                fit: BoxFit.cover,
                errorBuilder:
                    (context, error, stackTrace) {
                  return Container(
                    height: 160,
                    color: Colors.grey[300],
                    child: const Center(
                        child:
                            Text("Image not found")),
                  );
                },
              ),

              /// Gradient
              Container(
                height: 160,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      Colors.black
                          .withOpacity(0.6),
                      Colors.transparent
                    ],
                    begin:
                        Alignment.bottomCenter,
                    end: Alignment.topCenter,
                  ),
                ),
              ),

              /// Title
              Positioned(
                left: 16,
                bottom: 16,
                right: 16,
                child: Row(
                  mainAxisAlignment:
                      MainAxisAlignment
                          .spaceBetween,
                  children: [
                    Text(
                      title,
                      style:
                          const TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                        fontWeight:
                            FontWeight.bold,
                      ),
                    ),
                    const Icon(
                        Icons
                            .arrow_forward_ios,
                        color: Colors.white,
                        size: 18),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// 📄 Training Detail Screen
class TrainingDetailScreen
    extends StatelessWidget {
  final String title;

  const TrainingDetailScreen(
      {super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar:
          AppBar(title: Text(title)),
      body: Center(
        child: Text(
          "Details for $title",
          style:
              const TextStyle(fontSize: 18),
        ),
      ),
    );
  }
}

/// 🔔 Notification Screen
class NotificationScreen
    extends StatelessWidget {
  const NotificationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title:
              const Text("Notifications")),
      body: const Center(
        child:
            Text("No notifications yet"),
      ),
    );
  }
}



