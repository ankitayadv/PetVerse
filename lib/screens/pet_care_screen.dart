import 'package:flutter/material.dart';

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
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'Pet Care Guide',
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
        ),
        actions: [
          IconButton(
            onPressed: () => _showSnack(context, "Notifications clicked"),
            icon: Stack(
              children: [
                const Icon(Icons.notifications_none, color: Colors.black),
                Positioned(
                  right: 0,
                  top: 2,
                  child: Container(
                    width: 8,
                    height: 8,
                    decoration: const BoxDecoration(
                      color: Colors.orange,
                      shape: BoxShape.circle,
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 10),
        ],
      ),

      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 10),

            // -------- CATEGORY GRID --------
            Row(
              children: [
                _buildCategoryCard(
                  context,
                  title: 'Training',
                  icon: Icons.pets, // ✅ dog paw
                  color: const Color(0xFFFFEBDD),
                  onTap: () => _showSnack(context, "Training clicked"),
                ),
                const SizedBox(width: 15),
                _buildCategoryCard(
                  context,
                  title: 'Feeding',
                  icon: Icons.restaurant, // ✅ food bowl type
                  color: const Color(0xFFDFF6FF),
                  onTap: () => _showSnack(context, "Feeding clicked"),
                ),
              ],
            ),

            const SizedBox(height: 15),

            Row(
              children: [
                _buildCategoryCard(
                  context,
                  title: 'Grooming',
                  icon: Icons.cleaning_services, // ✅ grooming
                  color: const Color(0xFFFBEFFF),
                  onTap: () => _showSnack(context, "Grooming clicked"),
                ),
                const SizedBox(width: 15),
                _buildCategoryCard(
                  context,
                  title: 'Walking',
                  icon: Icons.directions_walk, // ✅ walking (NO sun)
                  color: const Color(0xFFE5FFED),
                  onTap: () => _showSnack(context, "Walking clicked"),
                ),
              ],
            ),

            const SizedBox(height: 30),

            // -------- ARTICLES --------
            const Text(
              'Featured Articles',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 15),

            _buildArticleTile(
              context,
              title: 'How to Train Your Dog',
              subtitle: 'Your 14 daily training tips',
              imageUrl:
                  'https://images.unsplash.com/photo-1583511655857-d19b40a7a54e',
              onTap: () => _showSnack(context, "Open Training Article"),
            ),

            _buildArticleTile(
              context,
              title: 'Best Foods for Pets',
              subtitle: 'Ensuring good joints',
              imageUrl:
                  'https://images.unsplash.com/photo-1601758228041-f3b2795255f1',
              onTap: () => _showSnack(context, "Open Food Article"),
            ),

            _buildArticleTile(
              context,
              title: 'Daily Grooming Tips',
              subtitle: 'Starts from the head',
              imageUrl:
                  'https://images.unsplash.com/photo-1518717758536-85ae29035b6d',
              onTap: () => _showSnack(context, "Open Grooming Article"),
            ),

            const SizedBox(height: 25),

            // -------- BUTTON --------
            SizedBox(
              width: double.infinity,
              height: 55,
              child: ElevatedButton(
                onPressed: () =>
                    _showSnack(context, "Explore More Clicked"),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFEBB16B),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                  elevation: 0,
                ),
                child: const Text(
                  'Explore More',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
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

  // -------- CATEGORY CARD --------
  Widget _buildCategoryCard(BuildContext context,
      {required String title,
      required IconData icon,
      required Color color,
      required VoidCallback onTap}) {
    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          height: 140,
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(24),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.05),
                blurRadius: 10,
              )
            ],
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.4),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  icon,
                  size: 40,
                  color: Colors.black87,
                ),
              ),
              const SizedBox(height: 12),
              Text(
                title,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // -------- ARTICLE TILE --------
  Widget _buildArticleTile(BuildContext context,
      {required String title,
      required String subtitle,
      required String imageUrl,
      required VoidCallback onTap}) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: Colors.grey.shade100),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.03),
              blurRadius: 8,
            )
          ],
        ),
        child: Row(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: Image.network(
                imageUrl,
                width: 55,
                height: 55,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) =>
                    const Icon(Icons.pets,
                        size: 40, color: Colors.grey),
              ),
            ),
            const SizedBox(width: 15),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    subtitle,
                    style:
                        const TextStyle(fontSize: 13, color: Colors.grey),
                  ),
                ],
              ),
            ),
            const Icon(Icons.chevron_right,
                color: Colors.grey, size: 20),
          ],
        ),
      ),
    );
  }
}







