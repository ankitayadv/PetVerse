import 'package:flutter/material.dart';

class VetsBookAppointmentsScreen extends StatelessWidget {
  const VetsBookAppointmentsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Vet Appointments")),
      body: const Center(child: Text("Appointments Screen")),
    );
  }
}