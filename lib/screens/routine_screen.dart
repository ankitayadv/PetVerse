import 'package:flutter/material.dart';

class RoutineScreen extends StatefulWidget {
  const RoutineScreen({super.key});

  @override
  State<RoutineScreen> createState() => _RoutineScreenState();
}

class _RoutineScreenState extends State<RoutineScreen> {
  List<Map<String, dynamic>> routines = [
    {
      "title": "Feeding",
      "time": "8:00 AM & 7:00 PM",
      "isOn": true,
      "color": const Color(0xFFFFF1E6),
      "icon": Icons.restaurant,
      "iconColor": Colors.orange,
    },
    {
      "title": "Walk",
      "time": "7:00 PM",
      "isOn": true,
      "color": const Color(0xFFE8F5E9),
      "icon": Icons.pets,
      "iconColor": Colors.green,
    },
    {
      "title": "Medicine",
      "time": "9:00 AM",
      "subtitle": "Antibiotics • Twice daily",
      "isOn": true,
      "color": const Color(0xFFFCE4EC),
      "icon": Icons.medical_services,
      "iconColor": Colors.redAccent,
    },
    {
      "title": "Grooming",
      "time": "2:00 PM",
      "isOn": false,
      "color": const Color(0xFFF3E5F5),
      "icon": Icons.content_cut,
      "iconColor": Colors.purple,
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F7FF),

      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.orange),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          "Routines",
          style: TextStyle(
            color: Color(0xFF333842), // ✅ FIXED
            fontWeight: FontWeight.bold,
          ),
        ),
        actions: [
          IconButton(
            onPressed: _addRoutineDialog,
            icon: Container(
              padding: const EdgeInsets.all(4),
              decoration: const BoxDecoration(
                color: Colors.orange,
                shape: BoxShape.circle,
              ),
              child: const Icon(Icons.add, color: Colors.white, size: 20),
            ),
          ),
          const SizedBox(width: 10),
        ],
      ),

      body: Column(
        children: [
          _buildTabBar(),
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              itemCount: routines.length,
              itemBuilder: (context, index) => _buildRoutineCard(index),
            ),
          ),
          _buildAddButton(),
          const SizedBox(height: 20),
        ],
      ),
    );
  }

  Widget _buildTabBar() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          _tabItem("Daily", true),
          const SizedBox(width: 40),
          _tabItem("Weekly", false),
        ],
      ),
    );
  }

  Widget _tabItem(String label, bool active) {
    return Column(
      children: [
        Text(
          label,
          style: TextStyle(
            color: active ? Colors.orange : Colors.grey,
            fontWeight: FontWeight.bold,
            fontSize: 16,
          ),
        ),
        if (active)
          Container(
            margin: const EdgeInsets.only(top: 4), // ✅ FIXED
            height: 2,
            width: 40,
            color: Colors.orange,
          )
      ],
    );
  }

  Widget _buildRoutineCard(int index) {
    final item = routines[index];

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: item['color'],
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.white.withOpacity(0.5)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.03),
            blurRadius: 10,
            offset: const Offset(0, 4),
          )
        ],
      ),
      child: Column(
        children: [
          ListTile(
            contentPadding: const EdgeInsets.all(16),
            leading: Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(item['icon'], color: item['iconColor']),
            ),
            title: Text(
              item['title'],
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 18,
                color: Colors.brown,
              ),
            ),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(item['time'], style: const TextStyle(color: Colors.black54)),
                if (item.containsKey('subtitle'))
                  Text(
                    item['subtitle'],
                    style: const TextStyle(color: Colors.grey, fontSize: 12),
                  ),
              ],
            ),
            trailing: Switch(
              value: item['isOn'],
              activeThumbColor: Colors.orange,
              onChanged: (val) => setState(() => item['isOn'] = val),
            ),
          ),

          Padding(
            padding: const EdgeInsets.only(bottom: 12, left: 16, right: 16),
            child: Row(
              children: [
                Expanded(
                  child: _actionButton("Edit", () => _editRoutineDialog(index)),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: _actionButton("Edit", () => _editRoutineDialog(index)),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }

  Widget _actionButton(String label, VoidCallback onTap) {
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 8),
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.6),
          borderRadius: BorderRadius.circular(10),
        ),
        alignment: Alignment.center,
        child: Text(
          label,
          style: const TextStyle(
            color: Colors.blueAccent,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
    );
  }

  Widget _buildAddButton() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: SizedBox(
        width: double.infinity,
        height: 55,
        child: ElevatedButton.icon(
          onPressed: _addRoutineDialog,
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.orange,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15),
            ),
          ),
          icon: const Icon(Icons.add, color: Colors.white),
          label: const Text(
            "Add Routine",
            style: TextStyle(color: Colors.white, fontSize: 18),
          ),
        ),
      ),
    );
  }

  void _addRoutineDialog() {
    _showRoutineDialog(null);
  }

  void _editRoutineDialog(int index) {
    _showRoutineDialog(index);
  }

  void _showRoutineDialog(int? index) {
    TextEditingController titleController =
        TextEditingController(text: index != null ? routines[index]['title'] : "");

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(index == null ? "Add Routine" : "Edit Routine"),
        content: TextField(
          controller: titleController,
          decoration: const InputDecoration(hintText: "Routine Name"),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Cancel"),
          ),
          ElevatedButton(
            onPressed: () {
              setState(() {
                if (index == null) {
                  routines.add({
                    "title": titleController.text,
                    "time": "12:00 PM",
                    "isOn": true,
                    "color": Colors.blue[50],
                    "icon": Icons.star,
                    "iconColor": Colors.blue,
                  });
                } else {
                  routines[index]['title'] = titleController.text;
                }
              });
              Navigator.pop(context);
            },
            child: const Text("Save"),
          )
        ],
      ),
    );
  }
}

