import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> with TickerProviderStateMixin {
  // Separate controllers for the Pulse and the Entrance
  late AnimationController _pulseController;
  late AnimationController _entranceController;
  
  late Animation<double> _pulseAnimation;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;

  Color _bgColor = Colors.white;
  final List<Color> _themeColors = [
    Colors.white,
    const Color(0xFFFFF3E0), // Soft Orange
    const Color(0xFFE8EAF6), // Soft Indigo
    const Color(0xFFF1F8E9), // Soft Green
  ];

  @override
  void initState() {
    super.initState();

    // 1. Permanent Pulse Controller
    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    )..repeat(reverse: true);

    _pulseAnimation = Tween<double>(begin: 0.8, end: 1.2).animate(
      CurvedAnimation(parent: _pulseController, curve: Curves.easeInOut),
    );

    // 2. Entrance Animation Controller (Runs once)
    _entranceController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    );

    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _entranceController, curve: Curves.easeIn),
    );

    _slideAnimation = Tween<Offset>(begin: const Offset(0, 0.2), end: Offset.zero).animate(
      CurvedAnimation(parent: _entranceController, curve: Curves.easeOutCubic),
    );

    // Start Entrance
    _entranceController.forward();

    // 3. FIX: Use pushReplacementNamed to prevent 'history is empty' error
    Timer(const Duration(seconds: 4), () {
      if (mounted) {
        Navigator.pushReplacementNamed(context, '/onboarding');
      }
    });
  }

  void _changeBackground() {
    setState(() {
      _bgColor = _themeColors[Random().nextInt(_themeColors.length)];
    });
  }

  @override
  void dispose() {
    _pulseController.dispose();
    _entranceController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;

    return GestureDetector(
      onTap: _changeBackground, // 🔶 Change color on touch
      child: Scaffold(
        // AnimatedContainer makes the color change smooth
        body: AnimatedContainer(
          duration: const Duration(milliseconds: 600),
          color: _bgColor,
          child: Stack(
            children: [
              // Pulsing Background Glow
              Center(
                child: ScaleTransition(
                  scale: _pulseAnimation,
                  child: Container(
                    width: 280, height: 280,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      gradient: RadialGradient(
                        colors: [Colors.orange.withOpacity(0.15), Colors.transparent],
                      ),
                    ),
                  ),
                ),
              ),

              // Content Entrance
              FadeTransition(
                opacity: _fadeAnimation,
                child: SlideTransition(
                  position: _slideAnimation,
                  child: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Image.asset('assets/images/app_symbol.png', height: height * 0.15),
                        const SizedBox(height: 10),
                        const Text(
                          'PetVerse',
                          style: TextStyle(
                            fontFamily: 'Poppins',
                            fontSize: 34,
                            fontWeight: FontWeight.bold,
                            color: Colors.orange,
                          ),
                        ),
                        const Text(
                          'Caring for your pet, smarter',
                          style: TextStyle(fontFamily: 'Poppins', color: Colors.grey),
                        ),
                        const SizedBox(height: 30),
                        // The dog/cat image from your reference
                        Image.asset('assets/images/onboarding_page1.png', height: height * 0.25),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}