import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';

enum ServiceType { vaccine, grooming, checkup, surgery, dental, emergency }

class BookingModel {
  final String id;
  final String petName;
  final String title;
  final String location;
  final DateTime dateTime;
  String status; // "Upcoming", "Confirmed", "Completed"
  final ServiceType type;
  final String price;
  bool reminderOn;

  BookingModel({
    required this.id,
    required this.petName,
    required this.title,
    required this.location,
    required this.dateTime,
    required this.status,
    required this.type,
    required this.price,
    this.reminderOn = false,
  });
}

class BookingScreen extends StatefulWidget {
  const BookingScreen({super.key});

  @override
  State<BookingScreen> createState() => _BookingScreenState();
}

class _BookingScreenState extends State<BookingScreen> with SingleTickerProviderStateMixin {
  static const Color primary = Color(0xFFFF8A3D);
  static const Color bgCream = Color(0xFFFDFBFA);
  static const Color textDark = Color(0xFF2D2D2D);
  static const Color softBorder = Color(0xFFFFEBD2);

  late TabController _tabController;
  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay;

  // --- MOCK DATABASE WITH INDIAN RUPEE (₹) ---
  final List<BookingModel> _allBookings = [
    BookingModel(id: "1", petName: "Buddy", title: "Rabies Jab", location: "Happy Tails Clinic", dateTime: DateTime.now().add(const Duration(days: 1)), status: "Upcoming", type: ServiceType.vaccine, price: "₹1,200", reminderOn: true),
    BookingModel(id: "2", petName: "Luna", title: "Summer Shave", location: "Bubbles Pet Salon", dateTime: DateTime.now().add(const Duration(days: 2)), status: "Confirmed", type: ServiceType.grooming, price: "₹1,500"),
    BookingModel(id: "3", petName: "Max", title: "Teeth Cleaning", location: "City Vet Hospital", dateTime: DateTime.now().add(const Duration(days: 3)), status: "Confirmed", type: ServiceType.dental, price: "₹3,500"),
    BookingModel(id: "4", petName: "Milo", title: "Neutering Surgery", location: "Specialist Center", dateTime: DateTime.now().add(const Duration(days: 7)), status: "Upcoming", type: ServiceType.surgery, price: "₹8,000"),
    BookingModel(id: "5", petName: "Bella", title: "Ear Infection", location: "Emergency Vet 24/7", dateTime: DateTime.now().subtract(const Duration(days: 2)), status: "Completed", type: ServiceType.emergency, price: "₹2,200"),
    BookingModel(id: "6", petName: "Coco", title: "Nail Clipping", location: "Paws & Claws", dateTime: DateTime.now().add(const Duration(hours: 3)), status: "Upcoming", type: ServiceType.grooming, price: "₹450"),
  ];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    _selectedDay = _focusedDay;
  }

  void _toggleReminder(String id) {
    setState(() {
      final b = _allBookings.firstWhere((element) => element.id == id);
      b.reminderOn = !b.reminderOn;
    });
    final status = _allBookings.firstWhere((e) => e.id == id).reminderOn ? "On" : "Off";
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text("Reminder turned $status"), duration: const Duration(seconds: 1), backgroundColor: primary),
    );
  }

  void _markAsDone(String id) {
    setState(() {
      final index = _allBookings.indexWhere((b) => b.id == id);
      _allBookings[index].status = "Completed";
    });
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("Marked as Completed! Moved to History."), backgroundColor: Colors.green),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: bgCream,
      appBar: _buildAppBar(),
      body: Column(
        children: [
          _buildCalendarSection(),
          _buildFilterTabs(),
          const SizedBox(height: 10),
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [
                _buildBookingList("Upcoming"),
                _buildBookingList("Confirmed"),
                _buildBookingList("Completed"),
              ],
            ),
          ),
        ],
      ),
    );
  }

  PreferredSizeWidget _buildAppBar() {
    return AppBar(
      backgroundColor: Colors.transparent,
      elevation: 0,
      centerTitle: true,
      leading: _buildNavBtn(Icons.arrow_back_ios_new, () => Navigator.pop(context)),
      title: const Text("Manage Bookings", style: TextStyle(color: textDark, fontWeight: FontWeight.bold, fontSize: 18)),
      actions: [
        _buildNavBtn(Icons.notifications_none, () {}),
        const SizedBox(width: 16),
      ],
    );
  }

  Widget _buildCalendarSection() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(24), border: Border.all(color: softBorder)),
      child: TableCalendar(
        firstDay: DateTime.utc(2020, 1, 1),
        lastDay: DateTime.utc(2030, 12, 31),
        focusedDay: _focusedDay,
        calendarFormat: CalendarFormat.week,
        selectedDayPredicate: (day) => isSameDay(_selectedDay, day),
        onDaySelected: (selected, focused) => setState(() { _selectedDay = selected; _focusedDay = focused; }),
        headerStyle: const HeaderStyle(formatButtonVisible: false, titleCentered: true),
        calendarStyle: const CalendarStyle(
          selectedDecoration: BoxDecoration(color: primary, shape: BoxShape.circle),
          todayTextStyle: TextStyle(color: primary, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }

  Widget _buildFilterTabs() {
    return Container(
      height: 48,
      margin: const EdgeInsets.symmetric(horizontal: 20),
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(color: Colors.grey.withOpacity(0.1), borderRadius: BorderRadius.circular(16)),
      child: TabBar(
        controller: _tabController,
        indicator: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(12), boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 4)]),
        labelColor: primary,
        unselectedLabelColor: Colors.grey,
        indicatorSize: TabBarIndicatorSize.tab,
        dividerColor: Colors.transparent,
        tabs: const [Tab(text: "Upcoming"), Tab(text: "Confirmed"), Tab(text: "History")],
      ),
    );
  }

  Widget _buildBookingList(String statusFilter) {
    final filtered = _allBookings.where((b) => b.status == statusFilter).toList();

    if (filtered.isEmpty) {
      return Center(child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.calendar_today_outlined, size: 50, color: Colors.grey.shade300),
          const SizedBox(height: 10),
          Text("No $statusFilter items", style: TextStyle(color: Colors.grey.shade400)),
        ],
      ));
    }

    return ListView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      itemCount: filtered.length,
      itemBuilder: (context, index) => _buildServiceCard(filtered[index]),
    );
  }

  Widget _buildServiceCard(BookingModel booking) {
    IconData icon;
    Color color;

    switch (booking.type) {
      case ServiceType.vaccine: icon = Icons.vaccines_outlined; color = const Color(0xFFE3F2FD); break;
      case ServiceType.grooming: icon = Icons.content_cut_outlined; color = const Color(0xFFF3E5F5); break;
      case ServiceType.checkup: icon = Icons.medical_services_outlined; color = const Color(0xFFE8F5E9); break;
      case ServiceType.surgery: icon = Icons.biotech_outlined; color = const Color(0xFFFFEBEE); break;
      case ServiceType.dental: icon = Icons.clean_hands_outlined; color = const Color(0xFFFFF3E0); break;
      case ServiceType.emergency: icon = Icons.emergency_outlined; color = const Color(0xFFFFE0E0); break;
    }

    bool isCompleted = booking.status == "Completed";

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(22),
        border: Border.all(color: isCompleted ? Colors.transparent : softBorder.withOpacity(0.5)),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.03), blurRadius: 10, offset: const Offset(0, 4))],
      ),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(14),
            child: Row(
              children: [
                Container(
                  height: 54, width: 54,
                  decoration: BoxDecoration(color: color, borderRadius: BorderRadius.circular(16)),
                  child: Icon(icon, color: isCompleted ? Colors.grey : primary, size: 26),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("${booking.petName} • ${booking.title}", style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
                      Text(booking.location, style: TextStyle(color: Colors.grey.shade500, fontSize: 11)),
                      const SizedBox(height: 8),
                      Row(
                        children: [
                          Icon(Icons.timer_outlined, size: 12, color: isCompleted ? Colors.grey : primary),
                          const SizedBox(width: 4),
                          const Text("10:30 AM", style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold)),
                          const Spacer(),
                          // RENDER RUPEE PRICE
                          Text(booking.price, style: TextStyle(fontWeight: FontWeight.w900, fontSize: 13, color: isCompleted ? Colors.grey : textDark)),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const Divider(height: 1, indent: 15, endIndent: 15),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                TextButton.icon(
                  onPressed: isCompleted ? null : () => _toggleReminder(booking.id),
                  icon: Icon(
                    booking.reminderOn ? Icons.notifications_active : Icons.notifications_none,
                    size: 18, 
                    color: isCompleted ? Colors.grey : (booking.reminderOn ? primary : Colors.grey),
                  ),
                  label: Text(
                    booking.reminderOn ? "Reminder On" : "Set Reminder",
                    style: TextStyle(fontSize: 11, color: isCompleted ? Colors.grey : (booking.reminderOn ? primary : Colors.grey)),
                  ),
                ),
                if (!isCompleted)
                  ElevatedButton(
                    onPressed: () => _markAsDone(booking.id),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green.withOpacity(0.1),
                      elevation: 0,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      padding: const EdgeInsets.symmetric(horizontal: 12),
                    ),
                    child: const Text("Mark Done", style: TextStyle(color: Colors.green, fontSize: 11, fontWeight: FontWeight.bold)),
                  )
                else
                  const Padding(
                    padding: EdgeInsets.only(right: 12),
                    child: Text("COMPLETED", style: TextStyle(color: Colors.grey, fontSize: 10, fontWeight: FontWeight.w900, letterSpacing: 1)),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNavBtn(IconData icon, VoidCallback tap) {
    return IconButton(
      onPressed: tap,
      icon: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(color: Colors.white, shape: BoxShape.circle, border: Border.all(color: softBorder)),
        child: Icon(icon, color: primary, size: 18),
      ),
    );
  }
}