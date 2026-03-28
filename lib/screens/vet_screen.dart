import 'package:flutter/material.dart';

class VetScreen extends StatelessWidget {
  const VetScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Vets")),
      body: const Center(
        child: Text(
          "Vet Screen",
          style: TextStyle(fontSize: 20),
        ),
      ),
    );
  }
}