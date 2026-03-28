import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class Routine {
  String title;
  String subtitle;
  DateTime? time;
  bool done;

  Routine({
    required this.title,
    this.subtitle = "",
    this.time,
    this.done = false,
  });
}

class RoutineTrackerPage extends StatefulWidget {
  const RoutineTrackerPage({super.key});

  @override
  State<RoutineTrackerPage> createState() => _RoutineTrackerPageState();
}

class _RoutineTrackerPageState extends State<RoutineTrackerPage> {
  List<Routine> todayRoutines = [
    Routine(title: "Feeding", subtitle: "Dry dog food", done: true),
    Routine(title: "Walking", time: DateTime.now(), done: false),
  ];

  List<Routine> yesterdayRoutines = [
    Routine(title: "Feeding", subtitle: "40g dog food", done: true),
    Routine(title: "Walking", subtitle: "25 min walk", done: true),
  ];

  String getTodayFormatted() =>
      DateFormat("EEE, d MMM").format(DateTime.now());

  String getYesterdayFormatted() =>
      DateFormat("EEE, d MMM")
          .format(DateTime.now().subtract(const Duration(days: 1)));

  String formatTime(DateTime time) =>
      DateFormat.jm().format(time);

  void toggleDone(int index) {
    setState(() {
      todayRoutines[index].done = !todayRoutines[index].done;
    });
  }

  void addRoutineDialog() {
    TextEditingController controller = TextEditingController();

    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text("Add Routine"),
        content: TextField(
          controller: controller,
          decoration:
              const InputDecoration(hintText: "Enter routine"),
        ),
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text("Cancel")),
          ElevatedButton(
            onPressed: () {
              if (controller.text.isNotEmpty) {
                setState(() {
                  todayRoutines
                      .add(Routine(title: controller.text));
                });
                Navigator.pop(context);
              }
            },
            child: const Text("Add"),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xffF5F6FA),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: const Text("Routine Tracker",
            style: TextStyle(
                color: Colors.black,
                fontWeight: FontWeight.w600)),
        leading:
            const Icon(Icons.arrow_back, color: Colors.black),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: ListView(
          children: [
            Text("Today: ${getTodayFormatted()}",
                style:
                    const TextStyle(fontWeight: FontWeight.w600)),

            const SizedBox(height: 12),

            _routineCard([
              ...todayRoutines.asMap().entries.map((entry) {
                int index = entry.key;
                Routine routine = entry.value;
                return _routineItem(
                    routine, () => toggleDone(index));
              }),

              GestureDetector(
                onTap: addRoutineDialog,
                child: _addRoutineButton(),
              ),
            ]),

            const SizedBox(height: 20),

            Text("Yesterday: ${getYesterdayFormatted()}",
                style:
                    const TextStyle(fontWeight: FontWeight.w600)),

            const SizedBox(height: 12),

            _routineCard(
              yesterdayRoutines
                  .map((r) => _routineItem(r, null))
                  .toList(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _routineCard(List<Widget> children) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(children: children),
    );
  }

  Widget _routineItem(
      Routine routine, VoidCallback? onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Padding(
        padding:
            const EdgeInsets.symmetric(vertical: 8),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: Colors.grey.shade100,
                borderRadius:
                    BorderRadius.circular(12),
              ),
              child: Icon(Icons.checklist,
                  color: Colors.grey[700]),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment:
                    CrossAxisAlignment.start,
                children: [
                  Text(routine.title,
                      style: const TextStyle(
                          fontWeight:
                              FontWeight.w600)),
                  if (routine.subtitle.isNotEmpty)
                    Text(routine.subtitle,
                        style: TextStyle(
                            color: Colors.grey[600],
                            fontSize: 12)),
                  if (routine.time != null)
                    Text(formatTime(routine.time!),
                        style: TextStyle(
                            color: Colors.grey[500],
                            fontSize: 12)),
                ],
              ),
            ),
            Container(
              padding:
                  const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 4),
              decoration: BoxDecoration(
                color: routine.done
                    ? Colors.green.shade100
                    : Colors.grey.shade200,
                borderRadius:
                    BorderRadius.circular(20),
              ),
              child: Row(
                children: [
                  Icon(
                    routine.done
                        ? Icons.check
                        : Icons.radio_button_unchecked,
                    size: 14,
                    color: routine.done
                        ? Colors.green
                        : Colors.grey,
                  ),
                  const SizedBox(width: 4),
                  Text(
                    routine.done
                        ? "Done"
                        : "Pending",
                    style: TextStyle(
                      color: routine.done
                          ? Colors.green
                          : Colors.grey,
                      fontSize: 12,
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

  Widget _addRoutineButton() {
    return Padding(
      padding:
          const EdgeInsets.symmetric(vertical: 10),
      child: Row(
        children: [
          const Icon(Icons.add,
              color: Colors.black54),
          const SizedBox(width: 6),
          Text("Add Routine",
              style: TextStyle(
                  color: Colors.grey[700],
                  fontWeight:
                      FontWeight.w500)),
        ],
      ),
    );
  }
}