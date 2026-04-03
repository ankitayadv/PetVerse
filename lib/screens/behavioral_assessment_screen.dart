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
  
  // 🧠 CHECKBOX STATES
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

  // 📞 CALL VET
  Future<void> _callVet() async {
    final Uri uri = Uri(scheme: 'tel', path: '9999999999');
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Cannot make call")),
      );
    }
  }

  // ➕ ADD CUSTOM FIELD
  void _addCustomField() {
    setState(() {
      customFields.add({
        "title": "Custom Field ${customFields.length + 1}",
        "value": false
      });
    });
  }

  // 🧠 ANALYSIS LOGIC
  void _generateSuggestion() {
    String result = "";

    if (_notEating || _notDrinking || _lowEnergy || _aggressive) {
      result =
          "⚠️ Your pet may need urgent care.\nPlease contact a vet immediately.";
    } else if (_ateLess || _drankLess || _disturbedSleep || _restless) {
      result =
          "⚠️ Your pet may be unwell.\nMonitor closely and consider visiting a vet.";
    } else if (_eatenWell && _drankNormal && _sleptWell && _active) {
      result = "✅ Your pet seems healthy.\nKeep monitoring regularly.";
    } else {
      result =
          "ℹ️ Observation needed.\nIf symptoms continue, consult a vet.";
    }

    setState(() {
      _suggestion = result;
    });
  }

  // 🔲 CHECKBOX TILE
  Widget _checkbox(String title, bool value, Function(bool?) onChanged) {
    return CheckboxListTile(
      title: Text(title, style: const TextStyle(color: Colors.black87)),
      value: value,
      onChanged: onChanged,
      activeColor: Colors.orange,
      checkColor: Colors.white,
      contentPadding: EdgeInsets.zero,
    );
  }

  // 🧩 SECTION CARD WITH COLOR
  Widget _section(String title, IconData icon, Color color, List<Widget> children) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 10),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 6,
            offset: Offset(0, 3),
          )
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, color: Colors.black87),
              const SizedBox(width: 10),
              Text(
                title,
                style: const TextStyle(
                  color: Colors.black87,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          ...children,
        ],
      ),
    );
  }

  Widget _card({required Widget child}) {
    return Container(
      margin: const EdgeInsets.only(top: 10),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 6,
            offset: Offset(0, 3),
          )
        ],
      ),
      child: child,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFFF3E0), // light orange background
      appBar: AppBar(
        title: const Text("Pet Assessment"),
        backgroundColor: Colors.orange,
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [

            _section("Eating", Icons.fastfood, const Color(0xFFFFE0B2), [
              _checkbox("Ate well", _eatenWell,
                  (v) => setState(() => _eatenWell = v!)),
              _checkbox("Ate less", _ateLess,
                  (v) => setState(() => _ateLess = v!)),
              _checkbox("Not eating", _notEating,
                  (v) => setState(() => _notEating = v!)),
            ]),

            _section("Water Intake", Icons.water_drop, const Color(0xFFBBDEFB), [
              _checkbox("Drank normally", _drankNormal,
                  (v) => setState(() => _drankNormal = v!)),
              _checkbox("Drank less", _drankLess,
                  (v) => setState(() => _drankLess = v!)),
              _checkbox("Not drinking", _notDrinking,
                  (v) => setState(() => _notDrinking = v!)),
            ]),

            _section("Sleep", Icons.bedtime, const Color(0xFFE1BEE7), [
              _checkbox("Slept well", _sleptWell,
                  (v) => setState(() => _sleptWell = v!)),
              _checkbox("Disturbed sleep", _disturbedSleep,
                  (v) => setState(() => _disturbedSleep = v!)),
            ]),

            _section("Activity", Icons.pets, const Color(0xFFC8E6C9), [
              _checkbox("Active", _active,
                  (v) => setState(() => _active = v!)),
              _checkbox("Low energy", _lowEnergy,
                  (v) => setState(() => _lowEnergy = v!)),
            ]),

            _section("Behavior", Icons.psychology, const Color(0xFFFFCDD2), [
              _checkbox("Restless", _restless,
                  (v) => setState(() => _restless = v!)),
              _checkbox("Aggressive", _aggressive,
                  (v) => setState(() => _aggressive = v!)),
            ]),

            _section("Custom", Icons.add, const Color(0xFFF5F5F5), [
              ...customFields.map((field) {
                return CheckboxListTile(
                  title: Text(field["title"],
                      style: const TextStyle(color: Colors.black87)),
                  value: field["value"],
                  activeColor: Colors.orange,
                  checkColor: Colors.white,
                  onChanged: (v) {
                    setState(() {
                      field["value"] = v!;
                    });
                  },
                );
              }),

              ElevatedButton.icon(
                onPressed: _addCustomField,
                icon: const Icon(Icons.add),
                label: const Text("Add Field"),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.orange,
                  foregroundColor: Colors.white,
                ),
              ),
            ]),

            const SizedBox(height: 20),

            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _generateSuggestion,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.orange,
                  padding: const EdgeInsets.all(16),
                ),
                child: const Text(
                  "Analyze",
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ),

            const SizedBox(height: 20),

            if (_suggestion.isNotEmpty)
              _card(
                child: Column(
                  children: [
                    Text(
                      _suggestion,
                      textAlign: TextAlign.center,
                      style: const TextStyle(color: Colors.black87),
                    ),
                    const SizedBox(height: 15),
                    ElevatedButton.icon(
                      onPressed: _callVet,
                      icon: const Icon(Icons.call),
                      label: const Text("Call Vet"),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.redAccent,
                        foregroundColor: Colors.white,
                      ),
                    ),
                  ],
                ),
              ),
          ],
        ),
      ),
    );
  }
}









