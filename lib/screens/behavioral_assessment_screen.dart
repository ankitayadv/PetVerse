import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class BehavioralAssessmentScreen extends StatefulWidget {
  const BehavioralAssessmentScreen({super.key});

  @override
  State<BehavioralAssessmentScreen> createState() =>
      _BehavioralAssessmentScreenState();
}

class _BehavioralAssessmentScreenState
    extends State<BehavioralAssessmentScreen> {

  // STATES
  bool _eatenWell = false;
  bool _ateLess = false;
  bool _notEating = false;

  bool _drankNormal = false;
  bool _drankLess = false;
  bool _notDrinking = false;

  bool _sleptWell = false;
  bool _disturbedSleep = false;

  bool _active = false;
  bool _lowEnergy = false;

  bool _restless = false;
  bool _aggressive = false;

  List<Map<String, dynamic>> customFields = [];
  String _suggestion = "";

  final TextEditingController _customController = TextEditingController();

  final Color primaryColor = const Color(0xFFFF8A00);
  final Color lightBg = const Color(0xFFFFF3E0);

  // CALL VET
  Future<void> _callVet() async {
    final Uri uri = Uri(scheme: 'tel', path: '9999999999');
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri);
    }
  }

  // ADD CUSTOM FIELD WITH INPUT
  void _addCustomField() {
    if (_customController.text.trim().isEmpty) return;

    setState(() {
      customFields.add({
        "title": _customController.text.trim(),
        "value": false
      });
      _customController.clear();
    });
  }

  // ANALYSIS
  void _generateSuggestion() {
    String result = "";

    if (_notEating || _notDrinking || _lowEnergy || _aggressive) {
      result = "⚠️ Your pet may need urgent care.";
    } else if (_ateLess || _drankLess || _disturbedSleep || _restless) {
      result = "⚠️ Your pet may be unwell.";
    } else if (_eatenWell && _drankNormal && _sleptWell && _active) {
      result = "✅ Your pet seems healthy.";
    } else {
      result = "ℹ️ Monitor your pet regularly.";
    }

    setState(() => _suggestion = result);
  }

  // CHECKBOX
  Widget _checkbox(String title, bool value, Function(bool?) onChanged) {
    return CheckboxListTile(
      title: Text(title),
      value: value,
      onChanged: onChanged,
      activeColor: primaryColor,
      contentPadding: EdgeInsets.zero,
    );
  }

  // SECTION
  Widget _section(String title, IconData icon, List<Widget> children) {
    return Container(
      margin: const EdgeInsets.only(bottom: 15),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(18),
        color: Colors.white,
        boxShadow: [
          BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10),
        ],
      ),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: primaryColor.withOpacity(0.1),
              borderRadius:
                  const BorderRadius.vertical(top: Radius.circular(18)),
            ),
            child: Row(
              children: [
                Icon(icon, color: primaryColor),
                const SizedBox(width: 10),
                Text(title,
                    style: const TextStyle(
                        fontWeight: FontWeight.bold, fontSize: 16)),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(12),
            child: Column(children: children),
          )
        ],
      ),
    );
  }

  Widget _resultCard() {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(18),
        color: Colors.white,
        border: Border.all(color: primaryColor),
      ),
      child: Column(
        children: [
          Text(_suggestion, textAlign: TextAlign.center),
          const SizedBox(height: 15),
          ElevatedButton.icon(
            onPressed: _callVet,
            icon: const Icon(Icons.call),
            label: const Text("Call Vet"),
            style: ElevatedButton.styleFrom(
              backgroundColor: primaryColor,
              foregroundColor: Colors.white,
            ),
          )
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: lightBg,
      appBar: AppBar(
        title: const Text("Pet Assessment"),
        backgroundColor: primaryColor,
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [

            _section("Eating", Icons.fastfood, [
              _checkbox("Ate well", _eatenWell,
                  (v) => setState(() => _eatenWell = v!)),
              _checkbox("Ate less", _ateLess,
                  (v) => setState(() => _ateLess = v!)),
              _checkbox("Not eating", _notEating,
                  (v) => setState(() => _notEating = v!)),
            ]),

            _section("Water Intake", Icons.water_drop, [
              _checkbox("Drank normally", _drankNormal,
                  (v) => setState(() => _drankNormal = v!)),
              _checkbox("Drank less", _drankLess,
                  (v) => setState(() => _drankLess = v!)),
              _checkbox("Not drinking", _notDrinking,
                  (v) => setState(() => _notDrinking = v!)),
            ]),

            _section("Sleep", Icons.bedtime, [
              _checkbox("Slept well", _sleptWell,
                  (v) => setState(() => _sleptWell = v!)),
              _checkbox("Disturbed sleep", _disturbedSleep,
                  (v) => setState(() => _disturbedSleep = v!)),
            ]),

            _section("Activity", Icons.pets, [
              _checkbox("Active", _active,
                  (v) => setState(() => _active = v!)),
              _checkbox("Low energy", _lowEnergy,
                  (v) => setState(() => _lowEnergy = v!)),
            ]),

            _section("Behavior", Icons.psychology, [
              _checkbox("Restless", _restless,
                  (v) => setState(() => _restless = v!)),
              _checkbox("Aggressive", _aggressive,
                  (v) => setState(() => _aggressive = v!)),
            ]),

            /// 🔥 CUSTOM INPUT SECTION
            _section("Custom Symptoms", Icons.edit, [

              TextField(
                controller: _customController,
                decoration: InputDecoration(
                  hintText: "Enter symptom (e.g., Vomiting)",
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ),

              const SizedBox(height: 10),

              ElevatedButton(
                onPressed: _addCustomField,
                style: ElevatedButton.styleFrom(
                  backgroundColor: primaryColor,
                  foregroundColor: Colors.white,
                ),
                child: const Text("Add"),
              ),

              const SizedBox(height: 10),

              ...customFields.map((field) {
                return CheckboxListTile(
                  title: Text(field["title"]),
                  value: field["value"],
                  activeColor: primaryColor,
                  onChanged: (v) {
                    setState(() => field["value"] = v!);
                  },
                );
              }),
            ]),

            const SizedBox(height: 20),

            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _generateSuggestion,
                style: ElevatedButton.styleFrom(
                  backgroundColor: primaryColor,
                  padding: const EdgeInsets.all(16),
                ),
                child: const Text("Analyze",
                    style: TextStyle(color: Colors.white)),
              ),
            ),

            const SizedBox(height: 20),

            if (_suggestion.isNotEmpty) _resultCard(),
          ],
        ),
      ),
    );
  }
}













