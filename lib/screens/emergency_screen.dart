import 'package:flutter/material.dart';

class EmergencyScreen extends StatelessWidget {
  const EmergencyScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Emergency First Aid")),
      body: const Center(
        child: Text(
          "Emergency First Aid Guide",
          style: TextStyle(fontSize: 18),
        ),
      ),
    );
  }
}