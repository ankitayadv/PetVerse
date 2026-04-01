import 'package:flutter/material.dart';

class ReportLostScreen extends StatelessWidget {
  const ReportLostScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Report Lost Pet"),
      ),
      body: const Center(
        child: Text(
          "Report Lost Pet Screen",
          style: TextStyle(fontSize: 18),
        ),
      ),
    );
  }
}