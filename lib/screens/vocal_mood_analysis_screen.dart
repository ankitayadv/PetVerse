import 'package:flutter/material.dart';

class VocalMoodAnalysisScreen extends StatelessWidget {
  const VocalMoodAnalysisScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Vocal Mood Analysis")),
      body: const Center(child: Text("Voice Mood Screen")),
    );
  }
}