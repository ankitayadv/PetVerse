import 'package:flutter/material.dart';

class RoutineScreen extends StatelessWidget {
  const RoutineScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Routine Tracker")),
      body: const Center(
        child: Text(
          "Track Daily Pet Routine",
          style: TextStyle(fontSize: 18),
        ),
      ),
    );
  }
}