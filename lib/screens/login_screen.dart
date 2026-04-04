import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> with SingleTickerProviderStateMixin {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController forgotPassController = TextEditingController();

  bool _isLoading = false;
  bool _isPasswordVisible = false;
  late AnimationController _shakeController;

  @override
  void initState() {
    super.initState();
    _shakeController = AnimationController(
      duration: const Duration(milliseconds: 500),
      vsync: this,
    );
  }

  // ✅ VALIDATION LOGIC
  String? _getValidationError() {
    final email = emailController.text.trim();
    final password = passwordController.text.trim();
    final emailRegex = RegExp(r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+");
    
    if (email.isEmpty || password.isEmpty) return "Fields cannot be empty.";
    if (!emailRegex.hasMatch(email)) return "Enter a valid email address.";
    if (password.length < 8) return "Password must be at least 8 characters.";
    return null;
  }

  // 🔥 REAL FIREBASE LOGIN
  Future<void> loginUser() async {
    final error = _getValidationError();
    
    if (error != null) {
      _shakeController.forward(from: 0.0);
      _showSnackBar(error, Colors.redAccent);
      return;
    }

    setState(() => _isLoading = true);

    try {
      await _auth.signInWithEmailAndPassword(
        email: emailController.text.trim(),
        password: passwordController.text.trim(),
      );

      if (mounted) {
        _showSnackBar("Welcome back to PetVerse!", Colors.green);
        Navigator.pushNamedAndRemoveUntil(context, '/home', (route) => false);
      }
    } on FirebaseAuthException catch (e) {
      _shakeController.forward(from: 0.0);
      String msg = "Login failed";
      if (e.code == 'user-not-found') msg = "No account found for this email.";
      else if (e.code == 'wrong-password') msg = "Incorrect password.";
      else if (e.code == 'invalid-credential') msg = "Invalid email or password.";
      
      _showSnackBar(msg, Colors.redAccent);
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  // 🔥 REAL FIREBASE PASSWORD RESET
  Future<void> _resetPassword() async {
    final email = forgotPassController.text.trim();

    if (email.isEmpty) {
      _showSnackBar("Please enter your email address.", Colors.redAccent);
      return;
    }

    try {
      await _auth.sendPasswordResetEmail(email: email);
      if (mounted) {
        Navigator.pop(context); // Close the bottom sheet
        _showSnackBar("Reset link sent to $email!", Colors.orange);
        forgotPassController.clear();
      }
    } on FirebaseAuthException catch (e) {
      _showSnackBar(e.message ?? "Failed to send reset link.", Colors.redAccent);
    } catch (e) {
      _showSnackBar("Something went wrong. Try again.", Colors.redAccent);
    }
  }

  void _showForgotPasswordSheet() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(30)),
        ),
        padding: EdgeInsets.only(
          bottom: MediaQuery.of(context).viewInsets.bottom,
          left: 24, right: 24, top: 32
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Container(
                width: 50, height: 5,
                decoration: BoxDecoration(color: Colors.grey[300], borderRadius: BorderRadius.circular(10)),
              ),
            ),
            const SizedBox(height: 20),
            const Text("Forgot Password?", style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, fontFamily: 'Poppins')),
            const SizedBox(height: 8),
            const Text("Enter your registered email to receive a recovery link.", style: TextStyle(color: Colors.grey, fontSize: 14, fontFamily: 'Poppins')),
            const SizedBox(height: 24),
            _buildTextField(
              controller: forgotPassController, 
              label: "Recovery Email", 
              icon: Icons.email_outlined
            ),
            const SizedBox(height: 30),
            ElevatedButton(
              onPressed: _resetPassword, // ✅ Real logic linked here
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.orange,
                minimumSize: const Size(double.infinity, 55),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                elevation: 0,
              ),
              child: const Text("SEND RESET LINK", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16)),
            ),
            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }

  void _showSnackBar(String message, Color color) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message, style: const TextStyle(fontFamily: 'Poppins', fontWeight: FontWeight.w500)),
        backgroundColor: color,
        behavior: SnackBarBehavior.floating,
        margin: const EdgeInsets.all(20),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      ),
    );
  }

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    forgotPassController.dispose();
    _shakeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          child: Column(
            children: [
              const SizedBox(height: 60),
              // Brand Logo Illustration
              Container(
                height: 160,
                width: 160,
                decoration: BoxDecoration(
                  color: Colors.orange.withOpacity(0.1),
                  shape: BoxShape.circle,
                ),
                child: Center(
                  child: Image.asset(
                    'assets/images/onboarding_page1.png', 
                    height: 100, 
                    errorBuilder: (context, _, _) => const Icon(Icons.pets_rounded, size: 80, color: Colors.orange)
                  ),
                ),
              ),
              const SizedBox(height: 32),
              const Text("Welcome Back!", style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold, fontFamily: 'Poppins', letterSpacing: -0.5)),
              const SizedBox(height: 8),
              const Text("PetVerse: Your Pet's Best Friend", style: TextStyle(color: Colors.grey, fontSize: 15, fontFamily: 'Poppins')),
              const SizedBox(height: 40),

              // Inputs with Shake Animation
              AnimatedBuilder(
                animation: _shakeController,
                builder: (context, child) {
                  final sineValue = sin(4 * pi * _shakeController.value);
                  return Transform.translate(offset: Offset(sineValue * 8, 0), child: child);
                },
                child: Column(
                  children: [
                    _buildTextField(
                      controller: emailController, 
                      label: "Email Address", 
                      icon: Icons.email_outlined
                    ),
                    const SizedBox(height: 20),
                    _buildTextField(
                      controller: passwordController, 
                      label: "Password", 
                      icon: Icons.lock_outline_rounded,
                      isPassword: true,
                      obscureText: !_isPasswordVisible,
                      toggleVisibility: () => setState(() => _isPasswordVisible = !_isPasswordVisible),
                    ),
                  ],
                ),
              ),

              Align(
                alignment: Alignment.centerRight,
                child: TextButton(
                  onPressed: _showForgotPasswordSheet,
                  child: const Text("Forgot Password?", style: TextStyle(color: Colors.orange, fontWeight: FontWeight.w600, fontFamily: 'Poppins'))
                ),
              ),

              const SizedBox(height: 20),

              // Login Button
              ElevatedButton(
                onPressed: _isLoading ? null : loginUser,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.orange,
                  minimumSize: const Size(double.infinity, 60),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                  elevation: 4,
                  shadowColor: Colors.orange.withOpacity(0.3),
                ),
                child: _isLoading
                    ? const SizedBox(height: 24, width: 24, child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2.5))
                    : const Text("LOG IN", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16, letterSpacing: 1.2, fontFamily: 'Poppins')),
              ),
              
              const SizedBox(height: 30),
              Row(
                children: [
                  Expanded(child: Divider(color: Colors.grey.shade300, thickness: 1)),
                  const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 16),
                    child: Text("OR", style: TextStyle(color: Colors.grey, fontWeight: FontWeight.w600, fontFamily: 'Poppins')),
                  ),
                  Expanded(child: Divider(color: Colors.grey.shade300, thickness: 1)),
                ],
              ),
              const SizedBox(height: 30),

              // Google Social Button
              _socialButton(
                label: "Continue with Google",
                iconAsset: Icons.g_mobiledata_rounded, 
                onTap: () {
                  // Link your GoogleSignIn method here later
                }, 
              ),

              const SizedBox(height: 40),
              Row(
                mainAxisAlignment: MainAxisAlignment.center, 
                children: [
                  const Text("Don't have an account? ", style: TextStyle(fontFamily: 'Poppins', color: Colors.black54)),
                  GestureDetector(
                    onTap: () => Navigator.pushNamed(context, '/signup'),
                    child: const Text("Sign Up", style: TextStyle(color: Colors.orange, fontWeight: FontWeight.bold, fontFamily: 'Poppins')),
                  ),
                ],
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }

  Widget _socialButton({required String label, required IconData iconAsset, required VoidCallback onTap}) {
    return SizedBox(
      width: double.infinity,
      height: 58,
      child: OutlinedButton.icon(
        onPressed: onTap,
        icon: Icon(iconAsset, color: Colors.black, size: 32),
        label: Text(label, style: const TextStyle(color: Colors.black87, fontSize: 16, fontWeight: FontWeight.w600, fontFamily: 'Poppins')),
        style: OutlinedButton.styleFrom(
          backgroundColor: Colors.white,
          side: BorderSide(color: Colors.grey.shade200, width: 1.5),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        ),
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller, 
    required String label, 
    required IconData icon, 
    bool isPassword = false, 
    bool obscureText = false, 
    VoidCallback? toggleVisibility
  }) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.03),
            blurRadius: 15,
            offset: const Offset(0, 5),
          )
        ]
      ),
      child: TextField(
        controller: controller,
        obscureText: obscureText,
        style: const TextStyle(fontFamily: 'Poppins', fontWeight: FontWeight.w500),
        decoration: InputDecoration(
          hintText: label,
          hintStyle: TextStyle(fontFamily: 'Poppins', color: Colors.grey.shade400, fontSize: 15),
          prefixIcon: Icon(icon, color: Colors.orange, size: 22),
          suffixIcon: isPassword 
            ? IconButton(
                icon: Icon(obscureText ? Icons.visibility_off_outlined : Icons.visibility_outlined, color: Colors.grey.shade400), 
                onPressed: toggleVisibility
              ) 
            : null,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(20),
            borderSide: BorderSide(color: Colors.grey.shade100),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(20),
            borderSide: BorderSide(color: Colors.grey.shade100),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(20),
            borderSide: const BorderSide(color: Colors.orange, width: 1.5),
          ),
          contentPadding: const EdgeInsets.symmetric(vertical: 20, horizontal: 20),
        ),
      ),
    );
  }
}