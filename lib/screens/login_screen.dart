import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  // ✅ CONTROLLERS
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  // ✅ LOADING STATE
  bool _isLoading = false;

  // ✅ LOGIN FUNCTION
  Future<void> loginUser() async {
    // 1. Basic empty check validation
    if (emailController.text.trim().isEmpty || passwordController.text.trim().isEmpty) {
      _showSnackBar("Please enter both email and password", Colors.red);
      return;
    }

    setState(() => _isLoading = true);

    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: emailController.text.trim(),
        password: passwordController.text.trim(),
      );

      // ✅ SUCCESS → SHOW NOTIFICATION
      if (mounted) {
        _showSnackBar("Login Successful! Welcome back.", Colors.green);
      }

      // Small delay so user can see the success message
      await Future.delayed(const Duration(seconds: 1));

      if (mounted) {
        Navigator.pushReplacementNamed(context, '/onboarding');
      }

    } on FirebaseAuthException catch (e) {
      String message = "Login Failed";

      // 2. Specific Firebase Error Handling
      if (e.code == 'user-not-found') {
        message = "No account found with this email.";
      } else if (e.code == 'wrong-password') {
        message = "Incorrect password. Please try again.";
      } else if (e.code == 'invalid-email') {
        message = "The email format is invalid.";
      } else if (e.code == 'user-disabled') {
        message = "This user account has been disabled.";
      }

      if (mounted) {
        _showSnackBar(message, Colors.red);
      }
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  // Helper function for SnackBars
  void _showSnackBar(String message, Color color) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: color,
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
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
          icon: const Icon(Icons.arrow_back_ios_new, color: Colors.orange),
          onPressed: () => Navigator.pushReplacementNamed(context, '/onboarding'),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 30.0),
          child: Column(
            children: [
              const SizedBox(height: 20),
              Image.asset(
                'assets/images/onboarding_page1.png',
                height: 180,
                errorBuilder: (context, error, stackTrace) =>
                    const Icon(Icons.pets, size: 100, color: Colors.orange),
              ),
              const SizedBox(height: 15),
              const Text(
                "Welcome\nBack!",
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 30),

              // ✅ EMAIL FIELD
              _buildTextField(
                controller: emailController,
                label: "Email",
                icon: Icons.email_outlined,
              ),
              const SizedBox(height: 15),

              // ✅ PASSWORD FIELD
              _buildTextField(
                controller: passwordController,
                label: "Password",
                icon: Icons.lock_outline,
                isPassword: true,
              ),

              Align(
                alignment: Alignment.centerRight,
                child: TextButton(
                  onPressed: () {
                    // Handle Forgot Password logic here
                  },
                  child: const Text(
                    "Forgot password?",
                    style: TextStyle(color: Colors.orange),
                  ),
                ),
              ),
              const SizedBox(height: 10),

              // 🔥 LOGIN BUTTON WITH LOADING INDICATOR
              ElevatedButton(
                onPressed: _isLoading ? null : loginUser,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.orange,
                  disabledBackgroundColor: Colors.orange.shade200,
                  minimumSize: const Size(double.infinity, 55),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                ),
                child: _isLoading
                    ? const SizedBox(
                        height: 20,
                        width: 20,
                        child: CircularProgressIndicator(
                          color: Colors.white,
                          strokeWidth: 2,
                        ),
                      )
                    : const Text(
                        "Login",
                        style: TextStyle(
                          fontSize: 18,
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
              ),
              const SizedBox(height: 20),
              const Text("or", style: TextStyle(color: Colors.grey)),
              const SizedBox(height: 20),

              // GOOGLE BUTTON (Placeholder style)
              OutlinedButton.icon(
                onPressed: () {},
                icon: const Icon(Icons.g_mobiledata, size: 30, color: Colors.black),
                label: const Text(
                  "Continue with Google",
                  style: TextStyle(color: Colors.black),
                ),
                style: OutlinedButton.styleFrom(
                  minimumSize: const Size(double.infinity, 55),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                ),
              ),
              const SizedBox(height: 25),

              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text("Don't have an account? "),
                  GestureDetector(
                    onTap: () => Navigator.pushNamed(context, '/signup'),
                    child: const Text(
                      "Sign Up",
                      style: TextStyle(
                        color: Colors.orange,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  // ✅ REUSABLE TEXTFIELD
  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    bool isPassword = false,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.grey.shade100,
        borderRadius: BorderRadius.circular(15),
      ),
      child: TextField(
        controller: controller,
        obscureText: isPassword,
        decoration: InputDecoration(
          hintText: label,
          prefixIcon: Icon(icon, color: Colors.orange),
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(vertical: 15),
        ),
      ),
    );
  }
}