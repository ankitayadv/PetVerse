import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:google_sign_in/google_sign_in.dart';
// Ensure this matches your project structure

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> with SingleTickerProviderStateMixin {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  
  // ✅ Speed Tip: Pre-define scopes for faster token retrieval
  final GoogleSignIn _googleSignIn = GoogleSignIn(
    scopes: ['email', 'profile'],
  );

  final TextEditingController nameController = TextEditingController();
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

  // ✅ OPTIMIZED FASTER GOOGLE AUTH
  Future<void> _handleGoogleAuth() async {
    setState(() => _isLoading = true);
    try {
      // 1. Silent login attempt (Fastest if already logged in)
      GoogleSignInAccount? googleUser = await _googleSignIn.signInSilently();
      
      // 2. If silent fails, trigger normal sign in immediately
      googleUser ??= await _googleSignIn.signIn();
      
      if (googleUser == null) {
        setState(() => _isLoading = false);
        return; 
      }

      // 3. Parallel Execution: Get Auth details while UI shows progress
      final GoogleSignInAuthentication googleAuth = await googleUser.authentication;
      final AuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      // 4. Sign in to Firebase
      UserCredential userCredential = await _auth.signInWithCredential(credential);
      
      // 5. Fire-and-forget Firestore save (Don't wait for it to navigate)
      _saveUserToFirestore(
        userCredential.user!, 
        googleUser.displayName ?? "User", 
        true, 
        'google'
      );
      
      if (mounted) {
        Navigator.pushNamedAndRemoveUntil(context, '/stepone', (route) => false);
      }
    } catch (e) {
      _showSnackBar("Google Connection Failed", Colors.redAccent);
      // Force a full sign out so the next attempt starts fresh
      await _googleSignIn.signOut();
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  Future<void> _handleManualSignUp() async {
    final error = _validateForm();
    if (error != null) {
      _shakeController.forward(from: 0.0);
      _showSnackBar(error, Colors.redAccent);
      return;
    }

    setState(() => _isLoading = true);
    try {
      UserCredential userCredential = await _auth.createUserWithEmailAndPassword(
        email: emailController.text.trim(),
        password: passwordController.text.trim(),
      );

      await userCredential.user?.updateDisplayName(nameController.text.trim());
      await userCredential.user?.sendEmailVerification();
      
      await _saveUserToFirestore(
        userCredential.user!, 
        nameController.text.trim(), 
        false, 
        'manual'
      );
      
      if (mounted) _showVerificationDialog(userCredential.user!);
    } on FirebaseAuthException catch (e) {
      _showSnackBar(e.message ?? "Registration failed", Colors.redAccent);
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  Future<void> _saveUserToFirestore(User user, String name, bool verified, String method) async {
    // We use a shorter timeout or skip 'await' if navigation is the priority
    _firestore.collection('users').doc(user.uid).set({
      'uid': user.uid,
      'name': name,
      'email': user.email,
      'isVerified': verified,
      'authMethod': method,
      'createdAt': FieldValue.serverTimestamp(),
    }, SetOptions(merge: true));
  }

  String? _validateForm() {
    if (nameController.text.trim().isEmpty) return "Name is required.";
    final email = emailController.text.trim();
    if (!RegExp(r"^[a-zA-Z0-9.]+@[a-zA-Z0-9]+\.[a-zA-Z]+").hasMatch(email)) {
      return "Enter a valid email.";
    }
    if (passwordController.text.length < 8) return "Minimum 8 characters required.";
    return null;
  }

  void _showVerificationDialog(User user) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: const Text("Verify Email 📧", style: TextStyle(fontWeight: FontWeight.bold, fontFamily: 'Poppins')),
        content: const Text("Check your inbox and click the link to activate your account."),
        actions: [
          TextButton(
            onPressed: () async {
              await user.reload();
              if (FirebaseAuth.instance.currentUser!.emailVerified) {
                Navigator.pop(context);
                Navigator.pushNamedAndRemoveUntil(context, '/stepone', (route) => false);
              } else {
                _showSnackBar("Not verified yet!", Colors.orange);
              }
            },
            child: const Text("I'VE VERIFIED", style: TextStyle(color: Colors.orange, fontWeight: FontWeight.bold)),
          ),
        ],
      ),
    );
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
              const Text("Create Account 🐾", style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold, fontFamily: 'Poppins')),
              const SizedBox(height: 8),
              const Text("Join the PetVerse community today.", style: TextStyle(color: Colors.grey, fontFamily: 'Poppins')),
              const SizedBox(height: 30),
              
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
                    _buildTextField(
                      controller: emailController, 
                      label: "Email Address", 
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
                  ],
                ),
              ),

              const SizedBox(height: 30),

              ElevatedButton(
                onPressed: _isLoading ? null : _handleManualSignUp,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.orange,
                  minimumSize: const Size(double.infinity, 60),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
                ),
                child: _isLoading
                    ? const SizedBox(height: 24, width: 24, child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2))
                    : const Text("SIGN UP", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontFamily: 'Poppins')),
              ),

              const SizedBox(height: 25),
              const Center(child: Text("OR", style: TextStyle(color: Colors.grey, fontWeight: FontWeight.bold, fontFamily: 'Poppins'))),
              const SizedBox(height: 25),

              // ✅ FAST GOOGLE BUTTON
              _socialButton(
                label: "Continue with Google",
                iconAsset: Icons.g_mobiledata,
                color: Colors.white,
                textColor: Colors.black87,
                onTap: _isLoading ? null : _handleGoogleAuth,
              ),
              const SizedBox(height: 35),
            ],
          ),
        ),
      ),
    );
  }

  // UI Components stay the same to maintain your aesthetic
  Widget _socialButton({required String label, required IconData iconAsset, required Color color, required Color textColor, required VoidCallback? onTap}) {
    return SizedBox(
      width: double.infinity,
      height: 55,
      child: OutlinedButton.icon(
        onPressed: onTap,
        icon: Icon(iconAsset, color: textColor, size: 32),
        label: Text(label, style: TextStyle(color: textColor, fontSize: 16, fontWeight: FontWeight.w600, fontFamily: 'Poppins')),
        style: OutlinedButton.styleFrom(
          backgroundColor: color,
          side: BorderSide(color: Colors.grey.shade300),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
        ),
      ),
    );
  }

  Widget _buildTextField({required TextEditingController controller, required String label, required IconData icon, bool isPassword = false, bool obscureText = false, VoidCallback? toggleVisibility, TextInputType keyboardType = TextInputType.text}) {
    return Container(
      decoration: BoxDecoration(color: Colors.grey.shade50, borderRadius: BorderRadius.circular(15), border: Border.all(color: Colors.grey.shade200)),
      child: TextField(
        controller: controller,
        obscureText: obscureText,
        keyboardType: keyboardType,
        style: const TextStyle(fontFamily: 'Poppins'),
        decoration: InputDecoration(
          hintText: label,
          prefixIcon: Icon(icon, color: Colors.orange),
          suffixIcon: isPassword ? IconButton(icon: Icon(obscureText ? Icons.visibility_off_rounded : Icons.visibility_rounded, color: Colors.grey), onPressed: toggleVisibility) : null,
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(vertical: 18, horizontal: 12),
        ),
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
}