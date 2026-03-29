import 'package:flutter/material.dart';

class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,

      bottomNavigationBar: BottomNavigationBar(
        selectedItemColor: Colors.orange,
        unselectedItemColor: Colors.grey,
        items: [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: "Home"),
          BottomNavigationBarItem(icon: Icon(Icons.search), label: "Search"),
          BottomNavigationBarItem(icon: Icon(Icons.favorite), label: "Health"),
          BottomNavigationBarItem(icon: Icon(Icons.local_hospital), label: "Vets"),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: "Profile"),
        ],
      ),

      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [

              // 🏠 Header
              Row(
                children: [
                  Icon(Icons.home),
                  SizedBox(width: 10),
                  Text("Home", style: TextStyle(fontSize: 20)),
                ],
              ),

              SizedBox(height: 20),

              // 🐶 Pet Card
              Container(
                padding: EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.orange.shade200,
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black12,
                      blurRadius: 10,
                      offset: Offset(0, 5),
                    ),
                  ],
                ),
                child: Row(
                  children: [
                    CircleAvatar(
                      radius: 30,
                      backgroundImage: AssetImage("assets/images/dog_illustration.png"),
                    ),
                    SizedBox(width: 10),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Home Back,\nBruno!",
                          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                        ),
                        SizedBox(height: 5),
                        Text("Golden Retriever • 2.3 years"),
                      ],
                    )
                  ],
                ),
              ),

              SizedBox(height: 20),

              // ⚡ Quick Actions
              Text(
                "Quick Actions",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),

              SizedBox(height: 10),

              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  actionBox("Lost", Colors.orange, Icons.search),
                  actionBox("Health", Colors.yellow.shade700, Icons.favorite),
                  actionBox("Vets", Colors.blue, Icons.medical_services),
                  actionBox("Emergency", Colors.deepOrange, Icons.add),
                ],
              ),

              SizedBox(height: 20),

              // 📋 Routine Tracker
              Container(
                padding: EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black12,
                      blurRadius: 10,
                      offset: Offset(0, 5),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [

                    // Header
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "Routine Tracker",
                          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                        ),

                        Container(
                          padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                          decoration: BoxDecoration(
                            color: Colors.orange.shade200,
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Text(
                            "View All",
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                        ),
                      ],
                    ),

                    SizedBox(height: 10),

                    // Feeding
                    Container(
                      padding: EdgeInsets.all(12),
                      margin: EdgeInsets.only(bottom: 10),
                      decoration: BoxDecoration(
                        color: Colors.orange.shade50,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text("Feeding", style: TextStyle(fontWeight: FontWeight.bold)),
                              SizedBox(height: 3),
                              Text("Dry dog food", style: TextStyle(color: Colors.grey)),
                            ],
                          ),
                          Text("6:00 PM"),
                        ],
                      ),
                    ),

                    // Walking
                    Container(
                      padding: EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: Colors.blue.shade50,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text("Walking", style: TextStyle(fontWeight: FontWeight.bold)),
                              SizedBox(height: 3),
                              Text("Evening walk", style: TextStyle(color: Colors.grey)),
                            ],
                          ),
                          Text("7:00 PM"),
                        ],
                      ),
                    ),
                  ],
                ),
              ),

              SizedBox(height: 15),

              // ➕ Add Routine
              Container(
                padding: EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black12,
                      blurRadius: 10,
                      offset: Offset(0, 5),
                    ),
                  ],
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "+ Add Routine",
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    Icon(Icons.add, color: Colors.orange),
                  ],
                ),
              ),

            ],
          ),
        ),
      ),
    );
  }

  // 🔹 Quick Action Box
  Widget actionBox(String text, Color color, IconData icon) {
    return Column(
      children: [
        Container(
          height: 60,
          width: 60,
          decoration: BoxDecoration(
            color: color.withOpacity(0.2),
            borderRadius: BorderRadius.circular(15),
          ),
          child: Icon(icon, color: color),
        ),
        SizedBox(height: 5),
        Text(text),
      ],
    );
  }
}
