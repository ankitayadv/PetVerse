import 'package:flutter/material.dart';

class VaccineScreen extends StatefulWidget {
  const VaccineScreen({super.key});

  @override
  State<VaccineScreen> createState() => _VaccineScreenState();
}

class _VaccineScreenState extends State<VaccineScreen> {
  final Map<String, bool> _completedVaccines = {
    'Leptospirosis': true,
  };

  String _selectedPet = "Bruno";

  // ---------------- REMINDER ----------------
  Future<void> _setReminder(String title) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime(2030),
      builder: (context, child) => Theme(
        data: Theme.of(context).copyWith(
          colorScheme: const ColorScheme.light(
            primary: Colors.orange,
            onPrimary: Colors.white,
          ),
        ),
        child: child!,
      ),
    );

    if (picked != null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Reminder set for $title on ${picked.day}/${picked.month}/${picked.year}',
          ),
          backgroundColor: Colors.deepOrangeAccent,
          behavior: SnackBarBehavior.floating,
        ),
      );
    }
  }

  void _markAsCompleted(String title) {
    setState(() {
      _completedVaccines[title] = true;
    });
  }

  // ---------------- UI ----------------
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F4FF),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.deepOrangeAccent),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'Vaccination Tracker',
          style: TextStyle(
            color: Colors.black87,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildPetProfileCard(),
            const SizedBox(height: 25),

            // -------- Upcoming --------
            _buildSectionHeader('Upcoming Vaccinations'),

            if (!(_completedVaccines['Rabies'] ?? false))
              _buildVaccineCard(
                title: 'Rabies',
                subtitle: 'Last Given: Jan 2026',
                dueInfo: 'Due in 2 days',
                color: Colors.orange.shade50,
                iconColor: Colors.orange,
                icon: Icons.colorize_rounded,
                isUrgent: true,
              ),

            if (!(_completedVaccines['Distemper'] ?? false))
              _buildVaccineCard(
                title: 'Distemper',
                subtitle: 'Last Given: Mar 2026',
                dueInfo: 'Due in 3 weeks',
                color: Colors.green.shade50,
                iconColor: Colors.blueAccent,
                icon: Icons.coronavirus_outlined,
              ),

            if (!(_completedVaccines['Bordetella'] ?? false))
              _buildVaccineCard(
                title: 'Bordetella',
                subtitle: 'Last Given: Oct 2025', // FIXED
                dueInfo: 'Due in 6 months',
                color: Colors.purple.shade50,
                iconColor: Colors.purple,
                icon: Icons.science_outlined,
                isUpcoming: true,
              ),

            const SizedBox(height: 25),

            // -------- History --------
            _buildSectionHeader('Vaccination History'),

            _buildHistoryCard(
              title: 'Leptospirosis',
              subtitle: 'Vaccinated in Dec 2025',
              color: Colors.green.shade50,
              icon: Icons.verified_user_rounded,
              isCompleted: true,
            ),

            if (_completedVaccines['Rabies'] ?? false)
              _buildHistoryCard(
                title: 'Rabies',
                subtitle: 'Completed recently',
                color: Colors.green.shade50,
                icon: Icons.check_circle,
                isCompleted: true,
              ),

            _buildHistoryCard(
              title: 'Flu (recommended)',
              subtitle: 'Flu shot to stay healthy',
              color: Colors.blue.shade50,
              icon: Icons.coronavirus_outlined,
              isCompleted: false,
            ),

            const SizedBox(height: 25),

            // -------- Owner Safety --------
            _buildSectionHeader('Vaccines for Owner Safety'),

            _buildHistoryCard(
              title: 'Rabies',
              subtitle: 'For bites or animal workers',
              color: Colors.orange.shade50,
              icon: Icons.colorize_rounded,
              isCompleted: false,
            ),

            _buildHistoryCard(
              title: 'Tetanus',
              subtitle: 'If bitten or deep wound',
              color: Colors.green.shade50,
              icon: Icons.security_rounded,
              isCompleted: false,
            ),

            _buildHistoryCard(
              title: 'Flu (recommended)',
              subtitle: 'Flu shot to stay healthy',
              color: Colors.blue.shade50,
              icon: Icons.coronavirus_outlined,
              isCompleted: false,
            ),

            const SizedBox(height: 20),
          ],
        ),
      ),
      bottomNavigationBar: _buildAddVaccineButton(),
    );
  }

  // ---------------- COMPONENTS ----------------

  Widget _buildPetProfileCard() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
          )
        ],
      ),
      child: Row(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: Image.network(
              'https://images.dog.ceo/breeds/retriever-golden/n02099601_3004.jpg',
              width: 70,
              height: 70,
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) =>
                  const Icon(Icons.pets, size: 50),
            ),
          ),
          const SizedBox(width: 15),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '$_selectedPet 🐾',
                  style: const TextStyle(
                      fontSize: 18, fontWeight: FontWeight.bold),
                ),
                const Text(
                  'Labrador · 2.5 years',
                  style: TextStyle(color: Colors.grey),
                ),
                const SizedBox(height: 8),
                GestureDetector(
                  onTap: () {
                    setState(() {
                      _selectedPet =
                          (_selectedPet == "Bruno") ? "Buddy" : "Bruno";
                    });
                  },
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 12, vertical: 4),
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey.shade300),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: const Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text('Switch Pet',
                            style: TextStyle(fontSize: 12)),
                        Icon(Icons.keyboard_arrow_down, size: 16),
                      ],
                    ),
                  ),
                )
              ],
            ),
          ),
          const Icon(Icons.chevron_right, color: Colors.grey),
        ],
      ),
    );
  }

  Widget _buildSectionHeader(String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 15),
      child: Text(
        title,
        style: const TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.bold,
          color: Colors.black87,
        ),
      ),
    );
  }

  Widget _buildVaccineCard({
    required String title,
    required String subtitle,
    required String dueInfo,
    required Color color,
    required Color iconColor,
    required IconData icon,
    bool isUrgent = false,
    bool isUpcoming = false,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(15),
        border: isUrgent
            ? Border.all(color: Colors.orange, width: 1.5)
            : null,
      ),
      child: Row(
        children: [
          Icon(icon, color: iconColor, size: 30),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: iconColor.withOpacity(0.8),
                    fontSize: 16,
                  ),
                ),
                Text(
                  subtitle,
                  style: const TextStyle(
                      fontSize: 12, color: Colors.black54),
                ),
                if (isUrgent)
                  const Text(
                    '⚠ Urgent',
                    style: TextStyle(
                        fontSize: 12,
                        color: Colors.orange,
                        fontWeight: FontWeight.bold),
                  ),
                if (isUpcoming)
                  const Text(
                    '● Upcoming',
                    style: TextStyle(
                        fontSize: 12,
                        color: Colors.deepOrange,
                        fontWeight: FontWeight.bold),
                  ),
              ],
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                dueInfo,
                style: const TextStyle(
                    fontSize: 12, fontWeight: FontWeight.w500),
              ),
              const SizedBox(height: 8),
              Row(
                children: [
                  TextButton(
                    onPressed: () => _setReminder(title),
                    child: const Text('Reminder',
                        style: TextStyle(fontSize: 11)),
                  ),
                  ElevatedButton(
                    onPressed: () => _markAsCompleted(title),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.white,
                      foregroundColor: Colors.deepOrange,
                      elevation: 0,
                    ),
                    child: const Text('Done',
                        style: TextStyle(fontSize: 11)),
                  ),
                ],
              )
            ],
          )
        ],
      ),
    );
  }

  Widget _buildHistoryCard({
    required String title,
    required String subtitle,
    required Color color,
    required IconData icon,
    bool isCompleted = false,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding:
          const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      decoration: BoxDecoration(
          color: color, borderRadius: BorderRadius.circular(15)),
      child: Row(
        children: [
          Icon(icon,
              color: isCompleted ? Colors.green : Colors.blueAccent),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title,
                    style: const TextStyle(
                        fontWeight: FontWeight.bold, fontSize: 15)),
                Text(subtitle,
                    style: const TextStyle(
                        fontSize: 12, color: Colors.black54)),
              ],
            ),
          ),
          if (isCompleted)
            const Text(
              "Completed",
              style: TextStyle(
                  color: Colors.green,
                  fontSize: 12,
                  fontWeight: FontWeight.bold),
            )
        ],
      ),
    );
  }

  Widget _buildAddVaccineButton() {
    return Container(
      padding: const EdgeInsets.all(20),
      color: const Color(0xFFF8F4FF),
      child: ElevatedButton(
        onPressed: () {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text("Add Vaccine Clicked")),
          );
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.orange.shade800,
          minimumSize: const Size(double.infinity, 55),
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15)),
        ),
        child: const Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.add, color: Colors.white),
            SizedBox(width: 8),
            Text(
              'Add Vaccination',
              style: TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ),
    );
  }
}







