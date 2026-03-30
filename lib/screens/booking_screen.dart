import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';

class BookingScreen extends StatefulWidget {
  const BookingScreen({super.key});

  @override
  State<BookingScreen> createState() => _BookingScreenState();
}

class _BookingScreenState extends State<BookingScreen> {
  // PetVerse Design System Colors
  static const Color primary = Color(0xFFFF8A3D);
  static const Color softCream = Color(0xFFFEF9F5);
  static const Color textMain = Color(0xFF2D2D2D);
  static const Color softBorder = Color(0xFFFFEBD2);
  static const Color accentMint = Color(0xFFB5DED3);

  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay;

  @override
  void initState() {
    super.initState();
    _selectedDay = _focusedDay;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: softCream,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        leading: _buildCircleBtn(Icons.arrow_back_ios_new, () => Navigator.pop(context)),
        title: const Text(
          "My Vet Bookings",
          style: TextStyle(color: textMain, fontWeight: FontWeight.bold, fontSize: 18),
        ),
        actions: [
          _buildCircleBtn(Icons.notifications_none, () {}),
          const SizedBox(width: 16),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 10),
            _buildTabHeader(),
            const SizedBox(height: 20),
            _buildRealCalendar(),
            const SizedBox(height: 25),

            // --- TODAY'S BOOKING (Linked to Calendar Selection) ---
            _buildSectionHeader(isSameDay(_selectedDay, DateTime.now()) 
                ? "Today's Booking" 
                : "Selected Date Booking"),
            _buildBookingCard(
              "Happy Tails Vet Clinic",
              "Veterinary Clinic",
              "Tue, Apr 16 • 11:00 AM",
              "Confirmed",
              Icons.local_hospital_outlined,
              const Color(0xFFE3F2FD),
            ),
            
            const SizedBox(height: 20),

            // --- UPCOMING BOOKINGS (Static) ---
            _buildSectionHeader("Upcoming Bookings"),
            _buildBookingCard(
              "PetPaws Hospital",
              "Veterinary Clinic",
              "Wed, Apr 24 • 3:00 PM",
              "Confirmed",
              Icons.healing_outlined,
              const Color(0xFFE8F5E9),
            ),
            _buildBookingCard(
              "AnimalCare Center",
              "Veterinary Clinic",
              "Sat, May 4 • 10:30 AM",
              "Confirmed",
              Icons.medical_services_outlined,
              const Color(0xFFFFF3E0),
            ),

            const SizedBox(height: 20),

            // --- PAST BOOKINGS (Static) ---
            _buildSectionHeader("Past Bookings"),
            _buildBookingCard(
              "Furry Friends Veterinary",
              "Veterinary Clinic",
              "Sat, Apr 6 • 9:00 AM",
              "Completed",
              Icons.check_circle_outline,
              const Color(0xFFF5F5F5),
              isPast: true,
            ),
            const SizedBox(height: 30),
          ],
        ),
      ),
    );
  }

  Widget _buildRealCalendar() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: softBorder),
      ),
      child: TableCalendar(
        firstDay: DateTime.utc(2020, 1, 1),
        lastDay: DateTime.utc(2030, 12, 31),
        focusedDay: _focusedDay,
        selectedDayPredicate: (day) => isSameDay(_selectedDay, day),
        onDaySelected: (selectedDay, focusedDay) {
          setState(() {
            _selectedDay = selectedDay;
            _focusedDay = focusedDay;
          });
        },
        headerStyle: const HeaderStyle(
          formatButtonVisible: false,
          titleCentered: true,
          titleTextStyle: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
        ),
        calendarStyle: const CalendarStyle(
          selectedDecoration: BoxDecoration(color: accentMint, shape: BoxShape.circle),
          todayDecoration: BoxDecoration(color: Color(0xFFFFF3E9), shape: BoxShape.circle),
          todayTextStyle: TextStyle(color: primary, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }

  Widget _buildBookingCard(String title, String sub, String time, String status, IconData icon, Color iconBg, {bool isPast = false}) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: softBorder),
      ),
      child: Row(
        children: [
          Container(
            height: 52, width: 52,
            decoration: BoxDecoration(color: iconBg, borderRadius: BorderRadius.circular(14)),
            child: Icon(icon, color: isPast ? Colors.grey : primary, size: 26),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
                Text(sub, style: const TextStyle(color: Colors.grey, fontSize: 11)),
                const SizedBox(height: 4),
                Text(time, style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 11, color: primary)),
              ],
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: isPast ? Colors.grey.shade100 : const Color(0xFFE8F5E9),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  status,
                  style: TextStyle(
                    color: isPast ? Colors.grey : Colors.green, 
                    fontSize: 10, 
                    fontWeight: FontWeight.bold
                  ),
                ),
              ),
              const SizedBox(height: 8),
              const Icon(Icons.arrow_forward_ios, size: 12, color: Colors.grey),
            ],
          )
        ],
      ),
    );
  }

  Widget _buildTabHeader() {
    return Center(
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 10),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: primary),
        ),
        child: const Text("Calendar", style: TextStyle(color: primary, fontWeight: FontWeight.bold)),
      ),
    );
  }

  Widget _buildSectionHeader(String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12, top: 4),
      child: Text(title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: textMain)),
    );
  }

  Widget _buildCircleBtn(IconData icon, VoidCallback tap) {
    return IconButton(
      onPressed: tap,
      icon: Container(
        padding: const EdgeInsets.all(8),
        decoration: const BoxDecoration(color: Color(0xFFFFF3E9), shape: BoxShape.circle),
        child: Icon(icon, color: primary, size: 18),
      ),
    );
  }
}