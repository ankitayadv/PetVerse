import 'package:flutter/material.dart';

class PetcareTrainingFinalScreen extends StatelessWidget {
  const PetcareTrainingFinalScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Training Session"),
        backgroundColor: Colors.orange,
      ),
      body: const Center(
        child: Text(
          "Training in Progress 🐾",
          style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }
}