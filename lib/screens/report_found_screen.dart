import 'package:flutter/material.dart';

class ReportFoundScreen extends StatelessWidget {
  const ReportFoundScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Report Found Pet"),
      ),
      body: const Center(
        child: Text(
          "Report Found Pet Screen",
          style: TextStyle(fontSize: 18),
        ),
      ),
    );
  }
}