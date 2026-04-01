import 'package:flutter/material.dart';

class EditPetProfileScreen extends StatelessWidget {
  const EditPetProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Edit Pet Profile")),
      body: const Center(child: Text("Edit Pet Profile Screen")),
    );
  }
}