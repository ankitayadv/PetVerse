import 'package:flutter/material.dart';

class DermatologicalScanScreen extends StatelessWidget {
  const DermatologicalScanScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Dermatological Scan")),
      body: const Center(child: Text("Skin Scan Screen")),
    );
  }
}