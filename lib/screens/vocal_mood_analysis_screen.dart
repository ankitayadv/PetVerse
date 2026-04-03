import 'dart:async';
import 'package:flutter/material.dart';

class VocalMoodAnalysisScreen extends StatefulWidget {
  const VocalMoodAnalysisScreen({super.key});

  @override
  State<VocalMoodAnalysisScreen> createState() =>
      _VocalMoodAnalysisScreenState();
}

class _VocalMoodAnalysisScreenState
    extends State<VocalMoodAnalysisScreen> {
  bool _isRecording = false;
  bool _isAnalyzing = false;

  Map<String, dynamic>? _result;
  int _index = 0;

  /// ✅ ONLY 2 MOODS
  final List<Map<String, dynamic>> moods = [
    {
      "mood": "Happy 😊",
      "description": "Your dog sounds happy and calm",
      "color": Colors.green,
      "confidence": 0.92,
    },
    {
      "mood": "Aggressive 😡",
      "description": "Your dog may be angry or defensive",
      "color": Colors.red,
      "confidence": 0.88,
    },
  ];

  /// 🎤 Fake Recording
  void _startRecording() {
    setState(() {
      _isRecording = true;
      _result = null;
    });

    Future.delayed(const Duration(seconds: 2), () {
      setState(() => _isRecording = false);
      _analyzeSound();
    });
  }

  /// 🧠 Fake AI Analysis
  Future<void> _analyzeSound() async {
    setState(() => _isAnalyzing = true);

    await Future.delayed(const Duration(seconds: 2));

    final result = moods[_index % moods.length];
    _index++;

    setState(() {
      _result = result;
      _isAnalyzing = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFFE3F2FD), Colors.white],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              children: [
                _header(),
                const SizedBox(height: 30),

                _micButton(),

                const SizedBox(height: 20),

                if (_isRecording) _recordingText(),

                if (_isAnalyzing) _loading(),

                const SizedBox(height: 20),

                if (_result != null) _resultCard(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  /// 🔝 Header
  Widget _header() {
    return Column(
      children: const [
        Text(
          "Vocal Mood AI 🐶",
          style: TextStyle(
            fontSize: 26,
            fontWeight: FontWeight.bold,
          ),
        ),
        SizedBox(height: 5),
        Text(
          "Detect dog emotions instantly",
          style: TextStyle(color: Colors.grey),
        ),
      ],
    );
  }

  /// 🎤 Mic Button
  Widget _micButton() {
    return GestureDetector(
      onTap: _isRecording ? null : _startRecording,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        height: 100,
        width: 100,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: _isRecording ? Colors.red : Colors.blue,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.2),
              blurRadius: 15,
            )
          ],
        ),
        child: Icon(
          _isRecording ? Icons.mic : Icons.mic_none,
          color: Colors.white,
          size: 40,
        ),
      ),
    );
  }

  /// 🎤 Recording Text
  Widget _recordingText() {
    return const Text(
      "Recording dog sound...",
      style: TextStyle(fontWeight: FontWeight.w500),
    );
  }

  /// ⏳ Loading
  Widget _loading() {
    return Column(
      children: const [
        LinearProgressIndicator(),
        SizedBox(height: 10),
        Text("Analyzing vocal patterns..."),
      ],
    );
  }

  /// 🧠 Result Card
  Widget _resultCard() {
    final confidence = (_result!['confidence'] * 100).toInt();

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(25),
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 15,
          )
        ],
      ),
      child: Column(
        children: [
          Text(
            _result!['mood'],
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
              color: _result!['color'],
            ),
          ),
          const SizedBox(height: 10),
          Text(
            _result!['description'],
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 15),
          Text("Confidence: $confidence%"),
          const SizedBox(height: 5),
          LinearProgressIndicator(value: _result!['confidence']),
          const SizedBox(height: 10),
          const Text(
            "⚠️ AI estimation only",
            style: TextStyle(fontSize: 11, color: Colors.grey),
          ),
        ],
      ),
    );
  }
}


