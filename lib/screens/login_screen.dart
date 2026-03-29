import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> with SingleTickerProviderStateMixin {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

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

  String? _getValidationError() {
    final email = emailController.text.trim();
    final password = passwordController.text.trim();
    final emailRegex = RegExp(r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+");
    
    if (email.isEmpty || password.isEmpty) return "Fields cannot be empty.";
    if (!emailRegex.hasMatch(email)) return "Enter a valid email address.";
    if (password.length < 8) return "Password must be at least 8 characters.";
    return null;
  }

  Future<void> loginUser() async {
    final error = _getValidationError();
    
    if (error != null) {
      _shakeController.forward(from: 0.0);
      _showSnackBar(error, Colors.redAccent);
      return;
    }

    setState(() => _isLoading = true);
    
    // Short delay to show the loading spinner
    await Future.delayed(const Duration(milliseconds: 800));

    if (mounted) {
      // ✅ SUCCESS LOGIC: Existing users go straight to Home
      _showSnackBar("Login Successful!", Colors.green);
      
      // Navigate to Home and clear the stack so they can't go back to Login
      Navigator.pushNamedAndRemoveUntil(context, '/home', (route) => false);
      
      setState(() => _isLoading = false);
    }
  }

  void _showSnackBar(String message, Color color) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: color,
        behavior: SnackBarBehavior.floating,
        margin: const EdgeInsets.all(20),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      ),
    );
  }

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    _shakeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 30.0),
          child: Column(
            children: [
              const SizedBox(height: 40),
              Image.asset(
                'assets/images/onboarding_page1.png', 
                height: 150, 
                errorBuilder: (context, _, _) => const Icon(Icons.pets, size: 80, color: Colors.orange)
              ),
              const SizedBox(height: 20),
              const Text(
                "Welcome Back!", 
                style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold, fontFamily: 'Poppins')
              ),
              const Text(
                "Login to your PetVerse account", 
                style: TextStyle(color: Colors.grey)
              ),
              const SizedBox(height: 30),

              AnimatedBuilder(
                animation: _shakeController,
                builder: (context, child) {
                  final sineValue = sin(3 * pi * _shakeController.value);
                  return Transform.translate(offset: Offset(sineValue * 10, 0), child: child);
                },
                child: Column(
                  children: [
                    _buildTextField(
                      controller: emailController, 
                      label: "Email Address", 
                      icon: Icons.email_outlined
                    ),
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

              Align(
                alignment: Alignment.centerRight,
                child: TextButton(
                  onPressed: () {}, 
                  child: const Text("Forgot Password?", style: TextStyle(color: Colors.orange))
                ),
              ),

              const SizedBox(height: 10),

              ElevatedButton(
                onPressed: _isLoading ? null : loginUser,
                child: _isLoading 
                  ? const SizedBox(
                      height: 20, 
                      width: 20, 
                      child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2)
                    ) 
                  : const Text(
                      "LOG IN", 
                      style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16)
                    ),
              ),

              const SizedBox(height: 25),
              const Text("OR", style: TextStyle(color: Colors.grey, fontWeight: FontWeight.bold)),
              const SizedBox(height: 25),

              _socialButton(
                label: "Continue with Google",
                iconAsset: Icons.g_mobiledata, 
                color: Colors.white,
                textColor: Colors.black87,
                onTap: () => _showSnackBar("Google Sign-In Clicked", Colors.blue),
              ),
              const SizedBox(height: 12),
              _socialButton(
                label: "Continue with Apple",
                iconAsset: Icons.apple,
                color: Colors.black,
                textColor: Colors.white,
                onTap: () => _showSnackBar("Apple Sign-In Clicked", Colors.black),
              ),

              const SizedBox(height: 30),
              Row(
                mainAxisAlignment: MainAxisAlignment.center, 
                children: [
                  const Text("Don't have an account? "),
                  GestureDetector(
                    // ✅ Updated to point to signup which leads to Step 1
                    onTap: () => Navigator.pushNamed(context, '/signup'),
                    child: const Text(
                      "Sign Up", 
                      style: TextStyle(color: Colors.orange, fontWeight: FontWeight.bold)
                    ),
                  ),
                ]
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }

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
  }) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.grey.shade100, 
        borderRadius: BorderRadius.circular(15)
      ),
      child: TextField(
        controller: controller,
        obscureText: obscureText,
        style: const TextStyle(fontFamily: 'Poppins'),
        decoration: InputDecoration(
          hintText: label,
          hintStyle: const TextStyle(fontFamily: 'Poppins'),
          prefixIcon: Icon(icon, color: Colors.orange),
          suffixIcon: isPassword 
            ? IconButton(
                icon: Icon(obscureText ? Icons.visibility_off : Icons.visibility), 
                onPressed: toggleVisibility
              ) 
            : null,
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(vertical: 15),
        ),
      ),
    );
  }
}