import 'package:flutter/material.dart';

class PetcareTrainingArticleScreen extends StatelessWidget {
  const PetcareTrainingArticleScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Pet Training Article"),
        centerTitle: true,
      ),
      body: const Center(
        child: Text(
          "Pet Training Article Screen Working ✅",
          style: TextStyle(fontSize: 18),
        ),
      ),
    );
  }
}













