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
  int _scanIndex = 0;

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
    _scanIndex++;

    setState(() {
      _analysisResult = result;
      _isAnalyzing = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF6F7FB),

      appBar: AppBar(
        title: const Text("Skin Scanner 🐶"),
        centerTitle: true,
        elevation: 0,
        backgroundColor: Colors.transparent,
        foregroundColor: Colors.black,
      ),

      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            _imageCard(),
            const SizedBox(height: 20),

            if (_isAnalyzing) _loadingCard(),

            if (_analysisResult != null && !_isAnalyzing)
              _resultCard(),

            const SizedBox(height: 25),

            _uploadButtons(),

            const SizedBox(height: 20),

            _scanButton(),
          ],
        ),
      ),
    );
  }

  /// 🖼 IMAGE CARD
  Widget _imageCard() {
    return Container(
      height: 300,
      width: double.infinity,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(24),
        gradient: const LinearGradient(
          colors: [Color(0xFF6A11CB), Color(0xFF2575FC)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 15,
            offset: const Offset(0, 8),
          )
        ],
      ),
      child: _selectedImage == null
          ? const Center(
              child: Text(
                "Upload Dog Skin Image",
                style: TextStyle(color: Colors.white, fontSize: 16),
              ),
            )
          : ClipRRect(
              borderRadius: BorderRadius.circular(24),
              child: Stack(
                children: [
                  Image.file(
                    _selectedImage!,
                    fit: BoxFit.cover,
                    width: double.infinity,
                  ),
                  Positioned(
                    bottom: 10,
                    right: 10,
                    child: Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: Colors.black54,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: const Text(
                        "Preview",
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  )
                ],
              ),
            ),
    );
  }

  /// ⏳ LOADING CARD
  Widget _loadingCard() {
    return Card(
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16)),
      child: const Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          children: [
            CircularProgressIndicator(),
            SizedBox(height: 10),
            Text("Analyzing with AI..."),
          ],
        ),
      ),
    );
  }

  /// 📊 RESULT CARD
  Widget _resultCard() {
    final result = _analysisResult!;
    final confidence = (result['confidence'] * 100).toInt();

    Color riskColor;
    switch (result['riskLevel']) {
      case "High":
        riskColor = Colors.red;
        break;
      case "Medium":
        riskColor = Colors.orange;
        break;
      default:
        riskColor = Colors.green;
    }

    return Card(
      elevation: 6,
      shape:
          RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            _infoRow("Status", result['status'], Colors.red),
            const Divider(),
            _infoRow("Condition", result['condition'], Colors.black),
            _infoRow("Risk Level", result['riskLevel'], riskColor),

            const SizedBox(height: 15),

            Align(
              alignment: Alignment.centerLeft,
              child: Text(
                "Confidence ($confidence%)",
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
            const SizedBox(height: 8),

            LinearProgressIndicator(
              value: result['confidence'],
              minHeight: 8,
              borderRadius: BorderRadius.circular(10),
            ),

            const SizedBox(height: 12),

            const Text(
              "⚠️ Not a medical diagnosis. Consult a vet.",
              style: TextStyle(fontSize: 12, color: Colors.grey),
            ),
          ],
        ),
      ),
    );
  }

  /// ROW UI
  Widget _infoRow(String label, String value, Color color) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label,
              style: const TextStyle(fontWeight: FontWeight.w500)),
          Text(value,
              style:
                  TextStyle(color: color, fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }

  /// 📷 BUTTONS
  Widget _uploadButtons() {
    return Row(
      children: [
        Expanded(
          child: _modernButton(
            icon: Icons.photo_library,
            text: "Gallery",
            onTap: () => _getImage(ImageSource.gallery),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: _modernButton(
            icon: Icons.camera_alt,
            text: "Camera",
            onTap: () => _getImage(ImageSource.camera),
          ),
        ),
      ],
    );
  }

  Widget _modernButton({
    required IconData icon,
    required String text,
    required VoidCallback onTap,
  }) {
    return ElevatedButton.icon(
      style: ElevatedButton.styleFrom(
        padding: const EdgeInsets.symmetric(vertical: 14),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(14),
        ),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 3,
      ),
      onPressed: onTap,
      icon: Icon(icon),
      label: Text(text),
    );
  }

  /// 🔍 SCAN BUTTON (CHANGED COLOR ONLY)
  Widget _scanButton() {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          padding: const EdgeInsets.symmetric(vertical: 16),
          backgroundColor: const Color(0xFFFF8A50), // ✅ NEW COLOR
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
        ),
        onPressed:
            _selectedImage == null || _isAnalyzing
                ? null
                : _performAnalysis,
        child: const Text(
          "Scan Image",
          style: TextStyle(fontSize: 16, color: Colors.white),
        ),
      ),
    );
  }
}




