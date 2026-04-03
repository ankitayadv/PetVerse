import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class PetcareFeedingBestfoodPage extends StatefulWidget {
  const PetcareFeedingBestfoodPage({super.key});

  @override
  State<PetcareFeedingBestfoodPage> createState() =>
      _PetcareFeedingBestfoodPageState();
}

class _PetcareFeedingBestfoodPageState
    extends State<PetcareFeedingBestfoodPage> {

  int selectedIndex = 1;

  // ✅ UPDATED VIDEO LIST (USING URL INSTEAD OF videoId)
  final List<Map<String, String>> videoList = [
    {
      "title": "Healthy Homemade Food for Dogs",
      "duration": "7:45",
      "url": "https://www.youtube.com/watch?v=U9DyHthJ6LA",
    },
    {
      "title": "Top 10 Safe Fruits for Dogs",
      "duration": "5:12",
      "url": "https://www.youtube.com/watch?v=7v8X7H7zFZQ",
    },
    {
      "title": "Protein-Rich Diet for Active Dogs",
      "duration": "6:30",
      "url": "https://www.youtube.com/watch?v=k3XzQ9v7m0E",
    },
    {
      "title": "How Much Water Should Dogs Drink?",
      "duration": "4:08",
      "url": "https://www.youtube.com/watch?v=wJ9vF8b2p3I",
    },
  ];

  // 🔥 OPEN VIDEO USING FULL URL
  Future<void> _openVideo(String url) async {
    final uri = Uri.parse(url);

    if (!await launchUrl(uri, mode: LaunchMode.externalApplication)) {
      throw Exception("Could not launch video");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFFF6F0),

      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          "Best Foods for Pets",
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
        ),
      ),

      body: Column(
        children: [
          const SizedBox(height: 10),

          // 🔘 TOGGLE BUTTONS
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              children: [
                Expanded(child: _buildToggleButton("Articles", 0)),
                const SizedBox(width: 12),
                Expanded(child: _buildToggleButton("Videos", 1)),
              ],
            ),
          ),

          const SizedBox(height: 20),

          Expanded(
            child: selectedIndex == 1
                ? _buildVideoList()
                : const Center(child: Text("Articles Content Here")),
          ),
        ],
      ),
    );
  }

  // 🔘 TOGGLE UI
  Widget _buildToggleButton(String title, int index) {
    bool isSelected = selectedIndex == index;

    return GestureDetector(
      onTap: () => setState(() => selectedIndex = index),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12),
        decoration: BoxDecoration(
          color: isSelected ? Colors.orange : Colors.white,
          borderRadius: BorderRadius.circular(25),
        ),
        child: Center(
          child: Text(
            title,
            style: TextStyle(
              color: isSelected ? Colors.white : Colors.grey,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
    );
  }

  // 🎥 VIDEO LIST UI
  Widget _buildVideoList() {
    return ListView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      itemCount: videoList.length,
      itemBuilder: (context, index) {
        final video = videoList[index];
        final url = video['url']!;

        return InkWell(
          onTap: () => _openVideo(url),
          child: Container(
            margin: const EdgeInsets.only(bottom: 16),
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: Colors.orange.withOpacity(0.05),
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Row(
              children: [

                // 🎬 ICON (NO THUMBNAIL = NO ERROR)
                Container(
                  width: 110,
                  height: 70,
                  decoration: BoxDecoration(
                    color: Colors.red[100],
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Icon(
                    Icons.play_circle_fill,
                    color: Colors.red,
                    size: 40,
                  ),
                ),

                const SizedBox(width: 12),

                // 📄 TEXT
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        video['title']!,
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 14,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Row(
                        children: [
                          const Icon(Icons.play_circle_fill,
                              color: Colors.red, size: 16),
                          const SizedBox(width: 4),
                          Text(
                            "YouTube • ${video['duration']}",
                            style: TextStyle(
                              color: Colors.grey[600],
                              fontSize: 12,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),

                const Icon(Icons.chevron_right, color: Colors.grey),
              ],
            ),
          ),
        );
      },
    );
  }
}


