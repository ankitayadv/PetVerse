import 'package:flutter/material.dart';

class RemindersAlertsScreen extends StatelessWidget {
  const RemindersAlertsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Reminders & Alerts")),
      body: const Center(child: Text("Reminders Screen")),
    );
  }
}