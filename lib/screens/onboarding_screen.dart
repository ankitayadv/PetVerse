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
    {
      "title": "PetVerse",
      "subtitle": "Your pet's entire universe in one smart app.",
      "image": "assets/images/onboarding_page1.png"
    },
    {
      "title": "Track Health",
      "subtitle": "Monitor vaccinations, diet, and daily routines.",
      "image": "assets/images/onboarding_page2.png"
    },
    {
      "title": "Find Vets",
      "subtitle": "Connect with top-rated veterinarians instantly.",
      "image": "assets/images/onboarding_page3.png"
    },
    {
      "title": "Lost & Found",
      "subtitle": "A community-driven alert system to bring pets home.",
      "image": "assets/images/onboarding_page4.png"
    },
  ];

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            // Top Bar with Skip Button
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              child: Align(
                alignment: Alignment.centerRight,
                child: TextButton(
                  onPressed: () => Navigator.pushReplacementNamed(context, '/login'),
                  child: const Text(
                    "Skip",
                    style: TextStyle(color: Colors.grey, fontSize: 16, fontWeight: FontWeight.w600),
                  ),
                ),
              ),
            ),

            Expanded(
              child: PageView.builder(
                controller: _controller,
                onPageChanged: (index) => setState(() => currentIndex = index),
                itemCount: pages.length,
                itemBuilder: (context, index) {
                  return AnimatedBuilder(
                    animation: _controller,
                    builder: (context, child) {
                      double value = 1.0;
                      if (_controller.position.hasContentDimensions) {
                        value = _controller.page! - index;
                        value = (1 - (value.abs() * 0.3)).clamp(0.0, 1.0);
                      }
                      return Opacity(
                        opacity: value,
                        child: Transform.scale(
                          scale: value,
                          child: child,
                        ),
                      );
                    },
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 40),
                      child: Column(
                        children: [
                          SizedBox(height: height * 0.02),
                          // Image with a slight bounce effect
                          Image.asset(
                            pages[index]["image"]!,
                            height: height * 0.4,
                            fit: BoxFit.contain,
                          ),
                          const Spacer(),
                          // Content Section
                          Text(
                            pages[index]["title"]!,
                            textAlign: TextAlign.center,
                            style: const TextStyle(
                              fontSize: 32,
                              fontWeight: FontWeight.bold,
                              color: Colors.orange,
                              letterSpacing: 1,
                            ),
                          ),
                          const SizedBox(height: 15),
                          Text(
                            pages[index]["subtitle"]!,
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 17,
                              color: Colors.blueGrey.shade400,
                              height: 1.5,
                            ),
                          ),
                          const Spacer(),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),

            // Indicator Dots
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(
                pages.length,
                (index) => buildDot(index, context),
              ),
            ),

            const SizedBox(height: 30),

            // Action Button
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 30),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                child: ElevatedButton(
                  onPressed: () {
                    if (currentIndex == pages.length - 1) {
                      Navigator.pushReplacementNamed(context, '/login');
                    } else {
                      _controller.nextPage(
                        duration: const Duration(milliseconds: 500),
                        curve: Curves.easeInOutQuint,
                      );
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.orange,
                    minimumSize: const Size(double.infinity, 60),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                    elevation: 5,
                    shadowColor: Colors.orange.withOpacity(0.3),
                  ),
                  child: Text(
                    currentIndex == pages.length - 1 ? "GET STARTED" : "NEXT",
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 1.2,
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }

  // Animated Dot Indicator
  Widget buildDot(int index, BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      margin: const EdgeInsets.symmetric(horizontal: 5),
      height: 10,
      width: currentIndex == index ? 30 : 10,
      decoration: BoxDecoration(
        color: currentIndex == index ? Colors.orange : Colors.grey.shade300,
        borderRadius: BorderRadius.circular(10),
        boxShadow: currentIndex == index 
          ? [BoxShadow(color: Colors.orange.withOpacity(0.2), blurRadius: 4, spreadRadius: 1)]
          : [],
      ),
    );
  }
}