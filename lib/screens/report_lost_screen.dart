import 'package:flutter/material.dart';

class ReportLostScreen extends StatefulWidget {
  const ReportLostScreen({super.key});

  @override
  State<ReportLostScreen> createState() => _ReportLostScreenState();
}

class _ReportLostScreenState extends State<ReportLostScreen> {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController typeController = TextEditingController();
  final TextEditingController locationController = TextEditingController();
  final TextEditingController descController = TextEditingController();
  final TextEditingController contactController = TextEditingController();

  String? imagePath;

  void submit() {
    final petData = {
      "name": nameController.text,
      "type": typeController.text,
      "status": "lost",
      "location": locationController.text,
      "description": descController.text,
      "contact": contactController.text,
      "image": imagePath,
    };

    print(petData); // 🔥 backend will use this

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("Report Submitted")),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Report Lost Pet"),
        backgroundColor: Colors.orange,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            _input("Pet Name", nameController),
            _input("Pet Type", typeController),
            _input("Last Seen Location", locationController),
            _input("Description", descController),
            _input("Contact Number", contactController),

            const SizedBox(height: 20),

            ElevatedButton(
              onPressed: submit,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.orange,
                minimumSize: const Size(double.infinity, 50),
              ),
              child: const Text("Submit Report"),
            )
          ],
        ),
      ),
    );
  }

  Widget _input(String hint, TextEditingController controller) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 15),
      child: TextField(
        controller: controller,
        decoration: InputDecoration(
          hintText: hint,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
      ),
    );
  }
}