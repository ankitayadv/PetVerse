import 'dart:async';
import 'package:flutter/material.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with TickerProviderStateMixin {

  late AnimationController _mainController;
  late AnimationController _floatController;

  late Animation<double> _scaleAnimation;
  late Animation<double> _opacityAnimation;
  late Animation<Offset> _slideAnimation;
  late Animation<double> _floatAnimation;

  @override
  void initState() {
    super.initState();

    // Main animation
    _mainController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2000),
    );

    _scaleAnimation = Tween<double>(begin: 0.5, end: 1.0).animate(
      CurvedAnimation(
        parent: _mainController,
        curve: const Interval(0.0, 0.6, curve: Curves.elasticOut),
      ),
    );

    _opacityAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _mainController,
        curve: const Interval(0.0, 0.5, curve: Curves.easeIn),
      ),
    );

    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.3),
      end: Offset.zero,
    ).animate(
      CurvedAnimation(
        parent: _mainController,
        curve: const Interval(0.4, 1.0, curve: Curves.easeOutBack), // FIXED
      ),
    );

    // Floating animation
    _floatController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 3),
    )..repeat(reverse: true);

    _floatAnimation = Tween<double>(begin: 0, end: 15).animate(
      CurvedAnimation(
        parent: _floatController,
        curve: Curves.easeInOut,
      ),
    );

    _mainController.forward();

    // Navigation
    Timer(const Duration(seconds: 5), () {
      if (mounted) {
        Navigator.pushReplacementNamed(context, '/onboarding');
      }
    });
  }

  @override
  void dispose() {
    _mainController.dispose();
    _floatController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Color(0xFFFFFFFF),
              Color(0xFFFFF3E0),
            ],
          ),
        ),
        child: Stack(
          alignment: Alignment.center,
          children: [

            // Background circles
            _buildAnimatedCircle(size.width * 0.8, const Color(0xFFFFE0B2), 0.2),
            _buildAnimatedCircle(size.width * 0.5, const Color(0xFFFFCC80), 0.1),

            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [

                // Logo
                ScaleTransition(
                  scale: _scaleAnimation,
                  child: FadeTransition(
                    opacity: _opacityAnimation,
                    child: Image.asset(
                      'assets/images/app_symbol.png',
                      height: size.height * 0.12,
                    ),
                  ),
                ),

                const SizedBox(height: 20),

                // Text
                SlideTransition(
                  position: _slideAnimation,
                  child: FadeTransition(
                    opacity: _opacityAnimation,
                    child: Column(
                      children: [
                        const Text(
                          'PetVerse',
                          style: TextStyle(
                            fontFamily: 'Poppins',
                            fontSize: 42,
                            fontWeight: FontWeight.bold,
                            color: Colors.orange,
                          ),
                        ),
                        Text(
                          'Caring for your pet, smarter',
                          style: TextStyle(
                            fontFamily: 'Poppins',
                            fontSize: 16,
                            color: Colors.grey.shade600,
                            fontStyle: FontStyle.italic,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                const SizedBox(height: 50),

                // Floating image
                AnimatedBuilder(
                  animation: _floatAnimation,
                  builder: (context, child) {
                    return Transform.translate(
                      offset: Offset(0, -_floatAnimation.value),
                      child: child,
                    );
                  },
                  child: FadeTransition(
                    opacity: _opacityAnimation,
                    child: Container(
                      padding: const EdgeInsets.all(20),
                      child: Image.asset(
                        'assets/images/onboarding_page1.png',
                        height: size.height * 0.3,
                      ),
                    ),
                  ),
                ),
              ],
            ),

            // Loader
            Positioned(
              bottom: 60,
              child: FadeTransition(
                opacity: _opacityAnimation,
                child: const CircularProgressIndicator(
                  strokeWidth: 2,
                  valueColor:
                      AlwaysStoppedAnimation<Color>(Colors.orangeAccent),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAnimatedCircle(double size, Color color, double opacity) {
    return ScaleTransition(
      scale: _scaleAnimation,
      child: Container(
        width: size,
        height: size,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: color.withValues(alpha: opacity), // FIXED
        ),
      ),
    );
  }
}