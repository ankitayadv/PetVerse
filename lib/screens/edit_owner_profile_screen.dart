import 'package:flutter/material.dart';

class EditOwnerProfileScreen extends StatelessWidget {
  const EditOwnerProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Edit Owner Profile")),
      body: const Center(child: Text("Edit Owner Profile Screen")),
    );
  }
}