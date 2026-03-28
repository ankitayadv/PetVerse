import 'package:flutter/material.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final PageController _controller = PageController();
  int currentIndex = 0;

  final List<Map<String, String>> pages = [
    {"title": "PetVerse", "subtitle": "Your pet's entire universe in one smart app.", "image": "assets/images/onboarding_page1.png"},
    {"title": "Track Health", "subtitle": "Monitor vaccinations, diet, and daily routines.", "image": "assets/images/onboarding_page2.png"},
    {"title": "Find Vets", "subtitle": "Connect with top-rated veterinarians instantly.", "image": "assets/images/onboarding_page3.png"},
    {"title": "Lost & Found", "subtitle": "A community-driven alert system to bring pets home.", "image": "assets/images/onboarding_page4.png"},
  ];

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: PageView.builder(
                controller: _controller,
                onPageChanged: (index) => setState(() => currentIndex = index),
                itemCount: pages.length,
                itemBuilder: (context, index) {
                  return Column(
                    children: [
                      SizedBox(height: height * 0.08),
                      Text(pages[index]["title"]!, style: const TextStyle(fontSize: 32, fontWeight: FontWeight.bold, color: Colors.orange)),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 40),
                        child: Text(pages[index]["subtitle"]!, textAlign: TextAlign.center, style: const TextStyle(fontSize: 16, color: Colors.grey)),
                      ),
                      const Spacer(),
                      Image.asset(pages[index]["image"]!, height: height * 0.4, fit: BoxFit.contain),
                      const Spacer(),
                    ],
                  );
                },
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(pages.length, (index) => AnimatedContainer(
                duration: const Duration(milliseconds: 300),
                margin: const EdgeInsets.symmetric(horizontal: 4),
                height: 8, width: currentIndex == index ? 24 : 8,
                decoration: BoxDecoration(color: currentIndex == index ? Colors.orange : Colors.grey.shade300, borderRadius: BorderRadius.circular(10)),
              )),
            ),
            const SizedBox(height: 30),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 30),
              child: ElevatedButton(
                onPressed: () {
                  if (currentIndex == pages.length - 1) {
                    Navigator.pushReplacementNamed(context, '/login');
                  } else {
                    _controller.nextPage(duration: const Duration(milliseconds: 300), curve: Curves.ease);
                  }
                },
                style: ElevatedButton.styleFrom(backgroundColor: Colors.orange, minimumSize: const Size(double.infinity, 55), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)), elevation: 0),
                child: Text(currentIndex == pages.length - 1 ? "Get Started" : "Next", style: const TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)),
              ),
            ),
            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }
}