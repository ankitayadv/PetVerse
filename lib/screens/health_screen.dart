import 'package:flutter/material.dart';
import '../routes/app_routes.dart'; // ✅ IMPORTANT

class HealthScreen extends StatefulWidget {
  const HealthScreen({super.key});

  @override
  State<HealthScreen> createState() => _HealthScreenState();
}

class _HealthScreenState extends State<HealthScreen> {
  static const Color brandOrange = Color(0xFFFF8A3D);
  static const Color softCream = Color(0xFFFEF9F5);
  static const Color textMain = Color(0xFF2D2D2D);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: softCream,
      body: CustomScrollView(
        physics: const BouncingScrollPhysics(),
        slivers: [
          // HEADER
          SliverAppBar(
            expandedHeight: 160,
            pinned: true,
            elevation: 0,
            backgroundColor: brandOrange,
            automaticallyImplyLeading: false,
            flexibleSpace: FlexibleSpaceBar(
              centerTitle: true,
              title: const Text(
                "Wellness Diagnostics",
                style: TextStyle(
                  fontWeight: FontWeight.w800,
                  color: Colors.white,
                  fontSize: 18,
                ),
              ),
              background: Container(
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    colors: [brandOrange, Color(0xFFF27A2A)],
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                  ),
                ),
              ),
            ),
          ),

          SliverPadding(
            padding: const EdgeInsets.fromLTRB(20, 24, 20, 20),
            sliver: SliverList(
              delegate: SliverChildListDelegate([
                const Text(
                  "Specialized Modules",
                  style: TextStyle(
                      fontSize: 19,
                      fontWeight: FontWeight.bold,
                      color: textMain),
                ),
                const SizedBox(height: 6),
                const Text(
                  "Non-invasive screening tools for preventative care",
                  style: TextStyle(fontSize: 13, color: Colors.blueGrey),
                ),
                const SizedBox(height: 24),

                // 🔥 BEHAVIOR
                _buildDiagnosticCard(
                  title: "Behavioral Assessment",
                  desc: "Cognitive pattern analysis & habit tracking",
                  icon: Icons.psychology_outlined,
                  color: Colors.indigo,
                  status: "Available",
                  onTap: () {
                    Navigator.pushNamed(context, AppRoutes.behavior);
                  },
                ),

                // 🔥 VOCAL
                _buildDiagnosticCard(
                  title: "Vocal Mood Analysis",
                  desc: "Acoustic stress detection via sound frequency",
                  icon: Icons.graphic_eq_rounded,
                  color: Colors.teal,
                  status: "Available",
                  onTap: () {
                    Navigator.pushNamed(context, AppRoutes.vocal);
                  },
                ),

                // 🔥 SKIN
                _buildDiagnosticCard(
                  title: "Dermatological Scan",
                  desc: "Advanced visual screening for skin pathologies",
                  icon: Icons.biotech_outlined,
                  color: Colors.blueGrey,
                  status: "Available",
                  onTap: () {
                    Navigator.pushNamed(context, AppRoutes.skin);
                  },
                ),

                const SizedBox(height: 30),

                // DISCLAIMER
                Container(
                  padding: const EdgeInsets.all(18),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20),
                    border:
                        Border.all(color: Colors.blueGrey.withOpacity(0.1)),
                  ),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Icon(Icons.verified_user_outlined,
                          color: Colors.blueGrey.shade300, size: 20),
                      const SizedBox(width: 14),
                      const Expanded(
                        child: Text(
                          "Digital screenings are for informational purposes. Consult a veterinarian for diagnosis.",
                          style: TextStyle(
                              fontSize: 11,
                              color: Colors.blueGrey,
                              height: 1.5),
                        ),
                      ),
                    ],
                  ),
                ),
              ]),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDiagnosticCard({
    required String title,
    required String desc,
    required IconData icon,
    required Color color,
    required String status,
    required VoidCallback onTap,
  }) {
    bool isAvailable = status == "Available";

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      child: InkWell(
        onTap: isAvailable ? onTap : null,
        borderRadius: BorderRadius.circular(24),
        child: Container(
          padding: const EdgeInsets.all(22),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(24),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.04),
                blurRadius: 15,
                offset: const Offset(0, 8),
              )
            ],
          ),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: color.withOpacity(0.08),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Icon(icon, color: color, size: 26),
              ),
              const SizedBox(width: 18),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(title,
                        style: const TextStyle(
                            fontWeight: FontWeight.w700,
                            fontSize: 16)),
                    const SizedBox(height: 4),
                    Text(desc,
                        style: const TextStyle(
                            color: Colors.blueGrey, fontSize: 12)),
                  ],
                ),
              ),
              const Icon(Icons.chevron_right_rounded,
                  color: Colors.grey),
            ],
          ),
        ),
      ),
    );
  }
}