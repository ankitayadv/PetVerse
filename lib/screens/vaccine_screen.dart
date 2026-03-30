import 'package:flutter/material.dart';

class VaccineScreen extends StatelessWidget {
  const VaccineScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Vaccine Tracker")),
      body: const Center(
        child: Text(
          "Manage Vaccination Schedule",
          style: TextStyle(fontSize: 18),
        ),
      ),
    );
  }
}