import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class DermatologicalScanScreen extends StatefulWidget {
  const DermatologicalScanScreen({super.key});

  @override
  State<DermatologicalScanScreen> createState() =>
      _DermatologicalScanScreenState();
}

class _DermatologicalScanScreenState
    extends State<DermatologicalScanScreen> {
  File? _selectedImage;
  bool _isAnalyzing = false;
  Map<String, dynamic>? _analysisResult;

  final ImagePicker _picker = ImagePicker();

  int _scanIndex = 0; // controls order

  /// 📷 Pick Image
  Future<void> _getImage(ImageSource source) async {
    final XFile? pickedFile = await _picker.pickImage(
      source: source,
      imageQuality: 80,
    );

    if (pickedFile != null) {
      setState(() {
        _selectedImage = File(pickedFile.path);
        _analysisResult = null;
      });
    }
  }

  /// 🧠 Controlled Output (ONLY PROBLEMS)
  Future<void> _performAnalysis() async {
    if (_selectedImage == null) return;

    setState(() => _isAnalyzing = true);

    await Future.delayed(const Duration(seconds: 2));

    final List<Map<String, dynamic>> results = [
      {
        "status": "Unhealthy",
        "condition": "Skin Allergy",
        "riskLevel": "Low",
        "confidence": 0.82,
      },
      {
        "status": "Unhealthy",
        "condition": "Skin Rash",
        "riskLevel": "Medium",
        "confidence": 0.85,
      },
      {
        "status": "Unhealthy",
        "condition": "Skin Infection",
        "riskLevel": "High",
        "confidence": 0.90,
      },
    ];

    final result = results[_scanIndex % results.length];
    _scanIndex++; // move to next

    setState(() {
      _analysisResult = result;
      _isAnalyzing = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text("Skin Scanner 🐶"),
        centerTitle: true,
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            _buildImageCard(),
            const SizedBox(height: 20),

            if (_isAnalyzing) _buildLoading(),

            if (_analysisResult != null && !_isAnalyzing)
              _buildResult(),

            const SizedBox(height: 30),

            _buttons(),

            const SizedBox(height: 15),

            _scanButton(),
          ],
        ),
      ),
    );
  }

  Widget _buildImageCard() {
    return Container(
      height: 280,
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.grey[100],
        borderRadius: BorderRadius.circular(20),
      ),
      child: _selectedImage == null
          ? const Center(child: Text("Upload dog skin image"))
          : ClipRRect(
              borderRadius: BorderRadius.circular(20),
              child: Image.file(_selectedImage!, fit: BoxFit.contain),
            ),
    );
  }

  Widget _buildLoading() {
    return Column(
      children: const [
        LinearProgressIndicator(),
        SizedBox(height: 10),
        Text("Analyzing skin using AI..."),
      ],
    );
  }

  Widget _buildResult() {
    final result = _analysisResult!;
    final confidence = (result['confidence'] * 100).toInt();

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        color: Colors.white,
        boxShadow: [
          BoxShadow(color: Colors.black12, blurRadius: 10),
        ],
      ),
      child: Column(
        children: [
          _row("Status", result['status'], Colors.red),
          const Divider(),
          _row("Condition", result['condition'], Colors.black),
          _row("Risk", result['riskLevel'], Colors.orange),
          const SizedBox(height: 10),
          Text("Confidence: $confidence%"),
          LinearProgressIndicator(value: result['confidence']),
          const SizedBox(height: 10),
          const Text(
            "⚠️ Not a medical diagnosis. Consult a vet.",
            style: TextStyle(fontSize: 11, color: Colors.grey),
          ),
        ],
      ),
    );
  }

  Widget _row(String label, String value, Color color) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label),
        Text(value, style: TextStyle(color: color)),
      ],
    );
  }

  Widget _buttons() {
    return Row(
      children: [
        Expanded(
          child: ElevatedButton.icon(
            onPressed: () => _getImage(ImageSource.gallery),
            icon: const Icon(Icons.photo),
            label: const Text("Gallery"),
          ),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: ElevatedButton.icon(
            onPressed: () => _getImage(ImageSource.camera),
            icon: const Icon(Icons.camera),
            label: const Text("Camera"),
          ),
        ),
      ],
    );
  }

  Widget _scanButton() {
    return ElevatedButton(
      onPressed:
          _selectedImage == null || _isAnalyzing ? null : _performAnalysis,
      child: const Text("Scan Image"),
    );
  }
}


