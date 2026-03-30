import 'package:flutter/material.dart';

class PetCareScreen extends StatelessWidget {
  const PetCareScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Pet Care Guide")),
      body: const Center(
        child: Text(
          "Learn How to Take Care of Your Pet",
          style: TextStyle(fontSize: 18),
        ),
      ),
    );
  }
}