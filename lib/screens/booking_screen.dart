import 'package:flutter/material.dart';

class BookingScreen extends StatelessWidget {
  const BookingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Your Bookings")),
      body: const Center(
        child: Text(
          "Vet Appointments & Bookings",
          style: TextStyle(fontSize: 18),
        ),
      ),
    );
  }
}