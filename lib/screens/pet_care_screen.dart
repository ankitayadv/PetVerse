import 'package:flutter/material.dart';
import '../routes/app_routes.dart';

class PetCareScreen extends StatelessWidget {
  const PetCareScreen({super.key});

  void _showSnack(BuildContext context, String text) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(text)),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF7F9FC),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'Pet Care Guide',
          style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.w700,
          ),
        ),
        actions: [
          IconButton(
            onPressed: () => _showSnack(context, "Notifications"),
            icon: const Icon(Icons.notifications_none, color: Colors.black),
          ),
        ],
      ),

      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 10),

            const Text(
              "Categories",
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w700,
              ),
            ),

            const SizedBox(height: 15),

            // 🔹 CATEGORY ROW 1
            Row(
              children: [
                _buildCategoryCard(
                  context,
                  title: 'Training',
                  imagePath: 'assets/images/dog_tranning.jpg',
                  onTap: () =>
                      Navigator.pushNamed(context, AppRoutes.training),
                ),
                const SizedBox(width: 15),
                _buildCategoryCard(
                  context,
                  title: 'Feeding',
                  imagePath: 'assets/images/dog_feeding.jpg',
                  onTap: () =>
                      Navigator.pushNamed(context, AppRoutes.feeding),
                ),
              ],
            ),

            const SizedBox(height: 15),

            // 🔹 CATEGORY ROW 2
            Row(
              children: [
                _buildCategoryCard(
                  context,
                  title: 'Grooming',
                  imagePath: 'assets/images/dog_grooming.jpg',
                  onTap: () => _showSnack(context, "Grooming"),
                ),
                const SizedBox(width: 15),
                _buildCategoryCard(
                  context,
                  title: 'Walking',
                  imagePath: 'assets/images/dog_walking.jpg',
                  onTap: () => _showSnack(context, "Walking"),
                ),
              ],
            ),

            const SizedBox(height: 30),

            const Text(
              'Featured Articles',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w700,
              ),
            ),

            const SizedBox(height: 15),

            _buildArticleCard(
              context,
              title: 'How to Train Your Dog',
              subtitle: 'Daily training techniques',
              imageUrl:
                  'https://images.unsplash.com/photo-1583511655857-d19b40a7a54e',
              onTap: () =>
                  Navigator.pushNamed(context, AppRoutes.trainingArticle),
            ),

            _buildArticleCard(
              context,
              title: 'Best Foods for Pets',
              subtitle: 'Healthy nutrition guide',
              imageUrl:
                  'https://images.unsplash.com/photo-1601758228041-f3b2795255f1',
              onTap: () =>
                  Navigator.pushNamed(context, AppRoutes.bestFood),
            ),

            _buildArticleCard(
              context,
              title: 'Daily Grooming Tips',
              subtitle: 'Keep your pet clean & healthy',
              imageUrl:
                  'https://images.unsplash.com/photo-1518717758536-85ae29035b6d',
              onTap: () => _showSnack(context, "Open Grooming Article"),
            ),

            const SizedBox(height: 25),

            // 🔹 BUTTON
            SizedBox(
              width: double.infinity,
              height: 55,
              child: ElevatedButton(
                onPressed: () => _showSnack(context, "Explore More"),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFEBB16B),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  elevation: 2,
                ),
                child: const Text(
                  'Explore More',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),

            const SizedBox(height: 30),
          ],
        ),
      ),
    );
  }

  // 🔥 CATEGORY CARD WITH BACKGROUND IMAGE
  Widget _buildCategoryCard(BuildContext context,
      {required String title,
      required String imagePath,
      required VoidCallback onTap}) {
    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          height: 140,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            image: DecorationImage(
              image: AssetImage(imagePath),
              fit: BoxFit.cover,
            ),
          ),
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              color: Colors.black.withOpacity(0.35), // overlay
            ),
            child: Center(
              child: Text(
                title,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  // 🔹 ARTICLE CARD
  Widget _buildArticleCard(BuildContext context,
      {required String title,
      required String subtitle,
      required String imageUrl,
      required VoidCallback onTap}) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(bottom: 15),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(18),
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.04),
              blurRadius: 10,
            )
          ],
        ),
        child: Row(
          children: [
            ClipRRect(
              borderRadius:
                  const BorderRadius.horizontal(left: Radius.circular(18)),
              child: Image.network(
                imageUrl,
                width: 90,
                height: 90,
                fit: BoxFit.cover,
              ),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(title,
                        style: const TextStyle(
                            fontWeight: FontWeight.w600)),
                    const SizedBox(height: 5),
                    Text(subtitle,
                        style: const TextStyle(
                            fontSize: 12, color: Colors.grey)),
                  ],
                ),
              ),
            ),
            const Padding(
              padding: EdgeInsets.only(right: 10),
              child: Icon(Icons.arrow_forward_ios,
                  size: 16, color: Colors.grey),
            )
          ],
        ),
      ),
    );
  }
}



