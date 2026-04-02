import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

// 1. Data Model for better code organization
class Vet {
  final String name;
  final String specialty;
  final String exp;
  final String rating;
  final String reviews;
  final String distance;
  final String phone;
  final String image;

  Vet({
    required this.name,
    required this.specialty,
    required this.exp,
    required this.rating,
    required this.reviews,
    required this.distance,
    required this.phone,
    required this.image,
  });
}

class VetScreen extends StatefulWidget {
  const VetScreen({super.key});

  @override
  State<VetScreen> createState() => _VetScreenState();
}

class _VetScreenState extends State<VetScreen> {
  // Theme Colors
  static const Color brandOrange = Color(0xFFFF8A3D);
  static const Color softCream = Color(0xFFFEF9F5);
  static const Color textMain = Color(0xFF2D2D2D);
  static const Color softBorder = Color(0xFFFFEBD2);

  String selectedSpecialty = 'Eye Care';

  // 2. Mock Database of Vets
  final List<Vet> allVets = [
    Vet(
      name: "Dr. Sharma",
      specialty: "Eye Care",
      exp: "5 yrs exp",
      rating: "4.8",
      reviews: "168",
      distance: "2.3 km away",
      phone: "9876543210",
      image: "https://api.dicebear.com/7.x/avataaars/png?seed=DrSharma",
    ),
    Vet(
      name: "Dr. Aditi Rao",
      specialty: "Eye Care",
      exp: "10 yrs exp",
      rating: "4.9",
      reviews: "210",
      distance: "1.1 km away",
      phone: "9876543211",
      image: "https://api.dicebear.com/7.x/avataaars/png?seed=Aditi",
    ),
    Vet(
      name: "Dr. Rajesh Kumar",
      specialty: "Surgery",
      exp: "12 yrs exp",
      rating: "4.7",
      reviews: "345",
      distance: "4.5 km away",
      phone: "9876543212",
      image: "https://api.dicebear.com/7.x/avataaars/png?seed=Rajesh",
    ),
    Vet(
      name: "Dr. Sneha Singh",
      specialty: "Grooming",
      exp: "3 yrs exp",
      rating: "4.5",
      reviews: "89",
      distance: "0.5 km away",
      phone: "9876543213",
      image: "https://api.dicebear.com/7.x/avataaars/png?seed=Sneha",
    ),
    Vet(
      name: "Dr. Michael V.",
      specialty: "Vaccine",
      exp: "7 yrs exp",
      rating: "4.8",
      reviews: "120",
      distance: "3.2 km away",
      phone: "9876543214",
      image: "https://api.dicebear.com/7.x/avataaars/png?seed=Michael",
    ),
    Vet(
      name: "Dr. Priya Das",
      specialty: "Surgery",
      exp: "15 yrs exp",
      rating: "5.0",
      reviews: "512",
      distance: "2.8 km away",
      phone: "9876543215",
      image: "https://api.dicebear.com/7.x/avataaars/png?seed=Priya",
    ),
  ];

  Future<void> _makePhoneCall(String phoneNumber) async {
    final Uri launchUri = Uri(scheme: 'tel', path: phoneNumber);
    if (await canLaunchUrl(launchUri)) {
      await launchUrl(launchUri);
    }
  }

  @override
  Widget build(BuildContext context) {
    // 3. Filtered List Logic
    final filteredVets = allVets.where((v) => v.specialty == selectedSpecialty).toList();

    return Scaffold(
      backgroundColor: softCream,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        automaticallyImplyLeading: false,
        title: const Text(
          "Nearby Vets",
          style: TextStyle(color: textMain, fontWeight: FontWeight.bold, fontSize: 20),
        ),
      ),
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 10),
            _buildSearchBar(),
            const SizedBox(height: 25),
            const Text("Specialties", 
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: textMain)),
            const SizedBox(height: 15),
            
            _buildSpecialtiesRow(),
            
            const SizedBox(height: 25),
            
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text("Top $selectedSpecialty Vets", 
                  style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: textMain)),
                TextButton(
                  onPressed: () {}, 
                  child: const Text("See All", style: TextStyle(color: brandOrange, fontWeight: FontWeight.bold))
                ),
              ],
            ),
            const SizedBox(height: 10),
            
            // 4. Dynamic List Generation
            if (filteredVets.isEmpty)
              const Padding(
                padding: EdgeInsets.symmetric(vertical: 40),
                child: Center(child: Text("No vets found in this category", style: TextStyle(color: Colors.grey))),
              )
            else
              ...filteredVets.map((vet) => _buildVetCard(vet)),
            
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  Widget _buildSpecialtiesRow() {
    final specialties = [
      {'icon': Icons.visibility_rounded, 'label': 'Eye Care'},
      {'icon': Icons.content_cut_rounded, 'label': 'Grooming'},
      {'icon': Icons.vaccines_rounded, 'label': 'Vaccine'},
      {'icon': Icons.medication_rounded, 'label': 'Surgery'},
    ];

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      clipBehavior: Clip.none,
      child: Row(
        children: specialties.map((item) {
          bool isSelected = selectedSpecialty == item['label'];
          
          return GestureDetector(
            onTap: () {
              setState(() {
                selectedSpecialty = item['label'] as String;
              });
            },
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 250),
              margin: const EdgeInsets.only(right: 12),
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
              decoration: BoxDecoration(
                color: isSelected ? brandOrange : Colors.white,
                borderRadius: BorderRadius.circular(18),
                border: Border.all(
                  color: isSelected ? brandOrange : softBorder,
                  width: 1.5,
                ),
                boxShadow: isSelected ? [
                  BoxShadow(
                    color: brandOrange.withOpacity(0.3),
                    blurRadius: 10,
                    offset: const Offset(0, 4)
                  )
                ] : [],
              ),
              child: Row(
                children: [
                  Icon(
                    item['icon'] as IconData, 
                    color: isSelected ? Colors.white : brandOrange, 
                    size: 20
                  ),
                  const SizedBox(width: 10),
                  Text(
                    item['label'] as String, 
                    style: TextStyle(
                      fontWeight: FontWeight.bold, 
                      fontSize: 14,
                      color: isSelected ? Colors.white : textMain,
                    ),
                  ),
                ],
              ),
            ),
          );
        }).toList(),
      ),
    );
  }

  Widget _buildSearchBar() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: softBorder),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.03), blurRadius: 10, offset: const Offset(0, 4))],
      ),
      child: const TextField(
        decoration: InputDecoration(
          hintText: "Search vets, clinics...",
          hintStyle: TextStyle(color: Colors.grey, fontSize: 14),
          prefixIcon: Icon(Icons.search, color: brandOrange),
          border: InputBorder.none,
          contentPadding: EdgeInsets.symmetric(vertical: 15),
        ),
      ),
    );
  }

  Widget _buildVetCard(Vet vet) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: softBorder),
      ),
      child: Column(
        children: [
          Row(
            children: [
              Container(
                height: 70, width: 70,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(18),
                  image: DecorationImage(image: NetworkImage(vet.image), fit: BoxFit.cover),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(vet.name, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 17, color: textMain)),
                    Text("${vet.specialty} • ${vet.exp}", style: const TextStyle(color: Colors.grey, fontSize: 12)),
                    const SizedBox(height: 6),
                    Row(
                      children: [
                        const Icon(Icons.star, color: Colors.amber, size: 16),
                        const SizedBox(width: 4),
                        Text(vet.rating, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
                        Text(" (${vet.reviews})", style: const TextStyle(color: Colors.grey, fontSize: 13)),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
          const Divider(height: 24, color: softBorder),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  const Icon(Icons.location_on, color: brandOrange, size: 14),
                  const SizedBox(width: 4),
                  Text(vet.distance, style: const TextStyle(color: Colors.grey, fontSize: 12)),
                ],
              ),
              Row(
                children: [
                  IconButton(
                    onPressed: () => _makePhoneCall(vet.phone),
                    icon: Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(color: Colors.green.withOpacity(0.1), shape: BoxShape.circle),
                      child: const Icon(Icons.phone, color: Colors.green, size: 18),
                    ),
                  ),
                  const SizedBox(width: 4),
                  ElevatedButton(
                    onPressed: () {},
                    style: ElevatedButton.styleFrom(
                      backgroundColor: brandOrange,
                      elevation: 0,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                    ),
                    child: const Text("Book", style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: Colors.white)),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}