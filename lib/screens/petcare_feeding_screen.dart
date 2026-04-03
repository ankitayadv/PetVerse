
import 'package:flutter/material.dart';

class PetcareFeedingScreen extends StatefulWidget {
  const PetcareFeedingScreen({super.key});

  @override
  State<PetcareFeedingScreen> createState() => _PetcareFeedingScreenState();
}

class _PetcareFeedingScreenState extends State<PetcareFeedingScreen> {

  final TextEditingController _searchController = TextEditingController();

  final List<Map<String, dynamic>> allTopics = [
    {
      "title": "Daily Diet Plan",
      "subtitle": "Balanced meals & portions",
      "articles": "9 Articles",
      "icon": "assets/images/diet.jpg",
      "color": Colors.orangeAccent,
    },
    {
      "title": "Best Foods",
      "subtitle": "Healthy food choices",
      "articles": "8 Articles",
      "icon": "assets/images/best.jpeg",
      "color": Colors.green,
    },
    {
      "title": "Foods to Avoid",
      "subtitle": "Dangerous food list",
      "articles": "6 Articles",
      "icon": "assets/images/avoid.jpeg",
      "color": Colors.redAccent,
    },
    {
      "title": "Hydration & Supplements",
      "subtitle": "Water, vitamins & more",
      "articles": "5 Articles",
      "icon": "assets/images/hydration.jpeg",
      "color": Colors.blueAccent,
    },
  ];

  List<Map<String, dynamic>> filteredTopics = [];
  String searchQuery = "";

  @override
  void initState() {
    super.initState();
    filteredTopics = allTopics;
  }

  void _filterSearch(String query) {
    searchQuery = query.toLowerCase();

    final results = allTopics.where((item) {
      final title = item['title'].toLowerCase();
      final subtitle = item['subtitle'].toLowerCase();

      return title.contains(searchQuery) || subtitle.contains(searchQuery);
    }).toList();

    setState(() {
      filteredTopics = results;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFFF6F0), // 🟠 soft orange background

      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          "Feeding",
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),

      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),

        child: Column(
          children: [

            // 🔍 SEARCH BAR
            Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(25),
                boxShadow: [
                  BoxShadow(
                    color: Colors.orange.withOpacity(0.08), // warm shadow
                    blurRadius: 8,
                  ),
                ],
              ),
              child: TextField(
                controller: _searchController,
                onChanged: _filterSearch,
                decoration: const InputDecoration(
                  hintText: "Search feeding topics...",
                  prefixIcon: Icon(Icons.search, color: Colors.grey),
                  border: InputBorder.none,
                  contentPadding: EdgeInsets.symmetric(vertical: 15),
                ),
              ),
            ),

            const SizedBox(height: 20),

            // 📋 LIST
            Expanded(
              child: filteredTopics.isEmpty
                  ? const Center(
                      child: Text(
                        "No results found 😢",
                        style: TextStyle(color: Colors.grey),
                      ),
                    )
                  : ListView.builder(
                      itemCount: filteredTopics.length,
                      itemBuilder: (context, index) {
                        final item = filteredTopics[index];

                        final isHighlighted = searchQuery.isNotEmpty &&
                            (item['title'].toLowerCase().contains(searchQuery) ||
                             item['subtitle'].toLowerCase().contains(searchQuery));

                        return Padding(
                          padding: const EdgeInsets.only(bottom: 12.0),

                          child: InkWell(
                            borderRadius: BorderRadius.circular(16),

                            onTap: () {
                              if (item['title'] == "Best Foods") {
                                Navigator.pushNamed(context, '/bestFood');
                              } else {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text("${item['title']} coming soon 🚀"),
                                  ),
                                );
                              }
                            },

                            child: AnimatedContainer(
                              duration: const Duration(milliseconds: 300),
                              padding: const EdgeInsets.all(12),

                              decoration: BoxDecoration(
                                color: isHighlighted
                                    ? item['color'].withOpacity(0.15)
                                    : Colors.white,
                                borderRadius: BorderRadius.circular(16),

                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.orange.withOpacity(0.05), // warm shadow
                                    blurRadius: 10,
                                    offset: const Offset(0, 4),
                                  ),
                                ],
                              ),

                              child: Row(
                                children: [

                                  // 🖼 IMAGE BOX
                                  Container(
                                    height: 70,
                                    width: 70,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                    clipBehavior: Clip.hardEdge,
                                    child: Image.asset(
                                      item['icon'],
                                      fit: BoxFit.cover,
                                    ),
                                  ),

                                  const SizedBox(width: 16),

                                  // 📄 TEXT
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [

                                        Text(
                                          item['title'],
                                          style: const TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 16,
                                          ),
                                        ),

                                        Text(
                                          item['subtitle'],
                                          style: TextStyle(
                                            color: Colors.grey[600],
                                            fontSize: 14,
                                          ),
                                        ),

                                        const SizedBox(height: 4),

                                        Text(
                                          item['articles'],
                                          style: TextStyle(
                                            color: Colors.grey[400],
                                            fontSize: 12,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),

                                  const Icon(Icons.chevron_right, color: Colors.grey),
                                ],
                              ),
                            ),
                          ),
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }
}





