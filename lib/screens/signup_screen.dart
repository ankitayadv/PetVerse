import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> with SingleTickerProviderStateMixin {
  // ✅ CONTROLLERS
  final TextEditingController nameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  // ✅ STATE & UI
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

  // ✅ ENHANCED FORM VALIDATION
  String? _validateForm() {
    final name = nameController.text.trim();
    final email = emailController.text.trim();
    final password = passwordController.text.trim();

    if (name.isEmpty) return "Name cannot be empty.";
    if (name.length < 3) return "Please enter your full name.";
    
    final emailRegex = RegExp(r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+");
    if (!emailRegex.hasMatch(email)) return "Enter a valid email address.";

    // Strong Password Requirements
    if (password.length < 8) return "Password must be at least 8 characters.";
    if (!RegExp(r'[A-Z]').hasMatch(password)) return "Add at least one uppercase letter.";
    if (!RegExp(r'[a-z]').hasMatch(password)) return "Add at least one lowercase letter.";
    if (!RegExp(r'[0-9]').hasMatch(password)) return "Add at least one number.";
    
    return null;
  }

  // ✅ UPDATED SIGNUP LOGIC
  Future<void> signUpUser() async {
    final error = _validateForm();
    if (error != null) {
      _shakeController.forward(from: 0.0);
      _showSnackBar(error, Colors.redAccent);
      return;
    }

    setState(() => _isLoading = true);
    
    // Simulate API call
    await Future.delayed(const Duration(seconds: 1));

    if (mounted) {
      setState(() => _isLoading = false);
      _showSnackBar("Account created successfully!", Colors.green);
      
      // SUCCESS FLOW: New users go to Step One for pet setup
      Navigator.pushNamedAndRemoveUntil(context, '/stepone', (route) => false);
    }
  }

  void _showSnackBar(String message, Color color) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message, style: const TextStyle(fontWeight: FontWeight.w600, fontFamily: 'Poppins')),
        backgroundColor: color,
        behavior: SnackBarBehavior.floating,
        margin: const EdgeInsets.all(20),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      ),
    );
  }

  @override
  void dispose() {
    nameController.dispose();
    emailController.dispose();
    passwordController.dispose();
    _shakeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, color: Colors.orange, size: 20),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 30),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                "Create Account 🐾",
                style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold, color: Colors.black87, fontFamily: 'Poppins'),
              ),
              const SizedBox(height: 8),
              const Text(
                "Join the PetVerse community today.", 
                style: TextStyle(color: Colors.grey, fontFamily: 'Poppins')
              ),
              
              const SizedBox(height: 30),

              // Form fields with Shake Animation
              AnimatedBuilder(
                animation: _shakeController,
                builder: (context, child) {
                  final sineValue = sin(3 * pi * _shakeController.value);
                  return Transform.translate(offset: Offset(sineValue * 8, 0), child: child);
                },
                child: Column(
                  children: [
                    _buildTextField(controller: nameController, label: "Full Name", icon: Icons.person_outline),
                    const SizedBox(height: 15),
                    _buildTextField(controller: emailController, label: "Email Address", icon: Icons.email_outlined, keyboardType: TextInputType.emailAddress),
                    const SizedBox(height: 15),
                    _buildTextField(
                      controller: passwordController,
                      label: "Password",
                      icon: Icons.lock_outline,
                      isPassword: true,
                      obscureText: !_isPasswordVisible,
                      toggleVisibility: () => setState(() => _isPasswordVisible = !_isPasswordVisible),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 30),

              // Register Button
              ElevatedButton(
                onPressed: _isLoading ? null : signUpUser,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.orange,
                  minimumSize: const Size(double.infinity, 60),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
                  elevation: 2,
                ),
                child: _isLoading
                    ? const SizedBox(height: 24, width: 24, child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2))
                    : const Text(
                        "SIGN UP", 
                        style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, letterSpacing: 1.1, fontFamily: 'Poppins')
                      ),
              ),

              const SizedBox(height: 25),
              const Center(
                child: Text(
                  "OR", 
                  style: TextStyle(color: Colors.grey, fontWeight: FontWeight.bold, fontFamily: 'Poppins')
                )
              ),
              const SizedBox(height: 25),

              _socialButton(
                label: "Sign up with Google",
                iconAsset: Icons.g_mobiledata,
                color: Colors.white,
                textColor: Colors.black87,
                onTap: () => _showSnackBar("Google Registration Selected", Colors.blue),
              ),
              
              // Apple Sign-in Removed

              const SizedBox(height: 35),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text("Already a member? ", style: TextStyle(fontFamily: 'Poppins')),
                  GestureDetector(
                    onTap: () => Navigator.pushReplacementNamed(context, '/login'),
                    child: const Text(
                      "Login", 
                      style: TextStyle(color: Colors.orange, fontWeight: FontWeight.bold, fontFamily: 'Poppins')
                    ),
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

  // ✅ HELPER FOR SOCIAL BUTTONS
  Widget _socialButton({
    required String label, 
    required IconData iconAsset, 
    required Color color, 
    required Color textColor, 
    required VoidCallback onTap
  }) {
    return SizedBox(
      width: double.infinity,
      height: 55,
      child: OutlinedButton.icon(
        onPressed: onTap,
        icon: Icon(iconAsset, color: textColor, size: 28),
        label: Text(label, style: TextStyle(color: textColor, fontSize: 16, fontWeight: FontWeight.w600, fontFamily: 'Poppins')),
        style: OutlinedButton.styleFrom(
          backgroundColor: color,
          side: BorderSide(color: Colors.grey.shade300),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
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
    VoidCallback? toggleVisibility,
    TextInputType keyboardType = TextInputType.text,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.grey.shade50, 
        borderRadius: BorderRadius.circular(15), 
        border: Border.all(color: Colors.grey.shade200)
      ),
      child: TextField(
        controller: controller,
        obscureText: obscureText,
        keyboardType: keyboardType,
        style: const TextStyle(fontFamily: 'Poppins'),
        decoration: InputDecoration(
          hintText: label,
          hintStyle: const TextStyle(fontFamily: 'Poppins', color: Colors.grey),
          prefixIcon: Icon(icon, color: Colors.orange),
          suffixIcon: isPassword 
            ? IconButton(
                icon: Icon(obscureText ? Icons.visibility_off_rounded : Icons.visibility_rounded, color: Colors.grey), 
                onPressed: toggleVisibility
              ) 
            : null,
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(vertical: 18),
        ),
      ),
    );
  }
}