import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  // ✅ CONTROLLERS
  final TextEditingController nameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  // ✅ LOADING STATE
  bool _isLoading = false;

  // ✅ SIGNUP FUNCTION
  Future<void> signUpUser() async {
    // Basic Validation
    if (emailController.text.isEmpty || passwordController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Please fill in all fields")),
      );
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: emailController.text.trim(),
        password: passwordController.text.trim(),
      );

      // ✅ SUCCESS → SHOW NOTIFICATION
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("Account created successfully! Redirecting..."),
            backgroundColor: Colors.green,
            duration: Duration(seconds: 2),
          ),
        );
      }

      // ✅ WAIT A MOMENT THEN GO TO LOGIN
      await Future.delayed(const Duration(seconds: 2));
      
      if (mounted) {
        Navigator.pushReplacementNamed(context, '/login');
      }

    } on FirebaseAuthException catch (e) {
      String message = "Signup Failed";

      if (e.code == 'email-already-in-use') {
        message = "This email is already registered.";
      } else if (e.code == 'weak-password') {
        message = "Password is too weak. Try at least 6 characters.";
      } else if (e.code == 'invalid-email') {
        message = "The email address is not valid.";
      }

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(message), backgroundColor: Colors.red),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  @override
  void dispose() {
    nameController.dispose();
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, color: Colors.orange),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 30.0),
        child: Column(
          children: [
            Image.asset(
              'assets/images/onboarding_page1.png',
              height: height * 0.2,
              errorBuilder: (context, error, stackTrace) => 
                  const Icon(Icons.pets, size: 80, color: Colors.orange),
            ),
            const SizedBox(height: 20),
            const Text(
              'Join PetVerse',
              style: TextStyle(
                fontSize: 32,
                fontWeight: FontWeight.bold,
                color: Colors.orange,
              ),
            ),
            const Text(
              'Create an account to start caring smarter',
              style: TextStyle(color: Colors.grey),
            ),
            const SizedBox(height: 30),

            // ✅ NAME
            _buildField(
              controller: nameController,
              hint: "Full Name",
              icon: Icons.person_outline,
            ),
            const SizedBox(height: 15),

            // ✅ EMAIL
            _buildField(
              controller: emailController,
              hint: "Email",
              icon: Icons.email_outlined,
            ),
            const SizedBox(height: 15),

            // ✅ PASSWORD
            _buildField(
              controller: passwordController,
              hint: "Password",
              icon: Icons.lock_outline,
              isPass: true,
            ),
            const SizedBox(height: 30),

            // 🔥 UPDATED BUTTON WITH LOADING LOGIC
            ElevatedButton(
              onPressed: _isLoading ? null : signUpUser,
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
                      "Create Account",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
            ),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text("Already have an account? "),
                GestureDetector(
                  onTap: () => Navigator.pop(context),
                  child: const Text(
                    "Login",
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
    );
  }

  // ✅ CUSTOM TEXTFIELD
  Widget _buildField({
    required TextEditingController controller,
    required String hint,
    required IconData icon,
    bool isPass = false,
  }) {
    return TextField(
      controller: controller,
      obscureText: isPass,
      decoration: InputDecoration(
        hintText: hint,
        prefixIcon: Icon(icon, color: Colors.orange),
        filled: true,
        fillColor: Colors.grey.shade100,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15),
          borderSide: BorderSide.none,
        ),
      ),
    );
  }
}