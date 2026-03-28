import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  // ✅ 1. CONTROLLERS
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  // ✅ 2. STATE VARIABLES
  bool _isLoading = false;
  bool _isPasswordVisible = false; // Toggle for password visibility

  // ✅ 3. FORM VALIDATION LOGIC
  bool _isValid() {
    final email = emailController.text.trim();
    final password = passwordController.text.trim();

    if (email.isEmpty || password.isEmpty) {
      _showSnackBar("Please fill in all fields.", Colors.red);
      return false;
    }
    if (!RegExp(r"^[a-zA-Z0-9+_.-]+@[a-zA-Z0-9.-]+$").hasMatch(email)) {
      _showSnackBar("Please enter a valid email address.", Colors.red);
      return false;
    }
    return true;
  }

  // ✅ 4. LOGIN FUNCTION
  Future<void> loginUser() async {
    if (!_isValid()) return;

    setState(() => _isLoading = true);

    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: emailController.text.trim(),
        password: passwordController.text.trim(),
      );

      if (mounted) {
        _showSnackBar("Welcome back!", Colors.green);
        // Navigate and clear the stack so user can't go back to login
        Navigator.pushNamedAndRemoveUntil(context, '/home', (route) => false);
      }
    } on FirebaseAuthException catch (e) {
      String message = "Login Failed";
      if (e.code == 'user-not-found') {
        message = "No user found with this email.";
      } else if (e.code == 'wrong-password') message = "Incorrect password.";
      else if (e.code == 'invalid-email') message = "Email format is incorrect.";
      
      if (mounted) _showSnackBar(message, Colors.red);
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  // ✅ 5. FORGOT PASSWORD FUNCTION
  Future<void> resetPassword() async {
    if (emailController.text.isEmpty) {
      _showSnackBar("Enter email to receive reset link", Colors.orange);
      return;
    }
    try {
      await FirebaseAuth.instance.sendPasswordResetEmail(email: emailController.text.trim());
      _showSnackBar("Reset link sent to your email!", Colors.blue);
    } catch (e) {
      _showSnackBar("Error sending reset email", Colors.red);
    }
  }

  // ✅ 6. GOOGLE SIGN-IN
  Future<void> signInWithGoogle() async {
    setState(() => _isLoading = true);
    try {
      final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();
      final GoogleSignInAuthentication? googleAuth = await googleUser?.authentication;
      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth?.accessToken,
        idToken: googleAuth?.idToken,
      );
      await FirebaseAuth.instance.signInWithCredential(credential);
      if (mounted) Navigator.pushReplacementNamed(context, '/home');
    } catch (e) {
      if (mounted) _showSnackBar("Google Sign-In cancelled or failed.", Colors.red);
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  void _showSnackBar(String message, Color color) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message), backgroundColor: color, behavior: SnackBarBehavior.floating),
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
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 30.0),
          child: Column(
            children: [
              const SizedBox(height: 20),
              // Use a placeholder if asset is missing
              Image.asset('assets/images/onboarding_page1.png', height: 180, 
                errorBuilder: (context, _, _) => const Icon(Icons.lock_person, size: 100, color: Colors.orange)),
              const SizedBox(height: 15),
              const Text("Welcome\nBack!", textAlign: TextAlign.center,
                style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold)),
              const SizedBox(height: 30),

              _buildTextField(
                controller: emailController,
                label: "Email",
                icon: Icons.email_outlined,
                keyboardType: TextInputType.emailAddress,
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

              Align(
                alignment: Alignment.centerRight,
                child: TextButton(onPressed: resetPassword, child: const Text("Forgot password?", style: TextStyle(color: Colors.orange))),
              ),
              const SizedBox(height: 10),

              ElevatedButton(
                onPressed: _isLoading ? null : loginUser,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.orange,
                  minimumSize: const Size(double.infinity, 55),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                ),
                child: _isLoading 
                  ? const CircularProgressIndicator(color: Colors.white) 
                  : const Text("Login", style: TextStyle(fontSize: 18, color: Colors.white)),
              ),

              const SizedBox(height: 20),
              const Text("or", style: TextStyle(color: Colors.grey)),
              const SizedBox(height: 20),

              OutlinedButton.icon(
                onPressed: _isLoading ? null : signInWithGoogle,
                icon: const Icon(Icons.g_mobiledata, size: 30, color: Colors.black),
                label: const Text("Continue with Google", style: TextStyle(color: Colors.black)),
                style: OutlinedButton.styleFrom(
                  minimumSize: const Size(double.infinity, 55),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                ),
              ),
              const SizedBox(height: 25),

              Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                const Text("Don't have an account? "),
                GestureDetector(
                  onTap: () => Navigator.pushNamed(context, '/signup'),
                  child: const Text("Sign Up", style: TextStyle(color: Colors.orange, fontWeight: FontWeight.bold)),
                ),
              ]),
            ],
          ),
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
      decoration: BoxDecoration(color: Colors.grey.shade100, borderRadius: BorderRadius.circular(15)),
      child: TextField(
        controller: controller,
        obscureText: obscureText,
        keyboardType: keyboardType,
        decoration: InputDecoration(
          hintText: label,
          prefixIcon: Icon(icon, color: Colors.orange),
          suffixIcon: isPassword 
            ? IconButton(icon: Icon(obscureText ? Icons.visibility_off : Icons.visibility), onPressed: toggleVisibility) 
            : null,
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(vertical: 15),
        ),
      ),
    );
  }
}