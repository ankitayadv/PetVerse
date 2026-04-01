import 'package:flutter/material.dart';

class PetcareFeedingScreen extends StatelessWidget {
  const PetcareFeedingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Feeding Guide")),
      body: const Center(child: Text("Pet Feeding Screen")),
    );
  }
}