import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';

class MapViewScreen extends StatefulWidget {
  const MapViewScreen({super.key});

  @override
  State<MapViewScreen> createState() => _MapViewScreenState();
}

class _MapViewScreenState extends State<MapViewScreen> {
  GoogleMapController? mapController;

  LatLng currentPosition = const LatLng(28.6139, 77.2090);
  final Set<Marker> markers = {};

  @override
  void initState() {
    super.initState();
    _getUserLocation();
    _loadPets();
  }

  // 🔥 LOCATION
  Future<void> _getUserLocation() async {
    LocationPermission permission = await Geolocator.requestPermission();

    if (permission == LocationPermission.denied ||
        permission == LocationPermission.deniedForever) {
      return;
    }

    Position position = await Geolocator.getCurrentPosition();

    setState(() {
      currentPosition = LatLng(position.latitude, position.longitude);
    });

    mapController?.animateCamera(
      CameraUpdate.newLatLngZoom(currentPosition, 15),
    );
  }

  // 🔥 BACKEND READY DATA MODEL
  void _loadPets() {
    final List<Map<String, dynamic>> petList = [
      {
        "id": "1",
        "name": "Buddy",
        "type": "Dog",
        "status": "lost",
        "lat": 28.6145,
        "lng": 77.2100,
      },
      {
        "id": "2",
        "name": "Milo",
        "type": "Cat",
        "status": "found",
        "lat": 28.6120,
        "lng": 77.2080,
      },
    ];

    for (var pet in petList) {
      final marker = Marker(
        markerId: MarkerId(pet['id']),
        position: LatLng(
          (pet['lat'] as num).toDouble(),
          (pet['lng'] as num).toDouble(),
        ),
        icon: BitmapDescriptor.defaultMarkerWithHue(
          pet['status'] == 'lost'
              ? BitmapDescriptor.hueRed
              : BitmapDescriptor.hueGreen,
        ),
        onTap: () => _showPetDetails(pet),
      );

      markers.add(marker);
    }

    setState(() {}); // 🔥 IMPORTANT
  }

  // 🔥 BOTTOM SHEET
  void _showPetDetails(Map<String, dynamic> pet) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (_) {
        return Container(
          padding: const EdgeInsets.all(20),
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(25)),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                height: 5,
                width: 50,
                margin: const EdgeInsets.only(bottom: 15),
                decoration: BoxDecoration(
                  color: Colors.grey[300],
                  borderRadius: BorderRadius.circular(10),
                ),
              ),

              Row(
                children: [
                  CircleAvatar(
                    radius: 30,
                    backgroundColor: Colors.orange.shade100,
                    child: const Icon(Icons.pets, color: Colors.orange),
                  ),
                  const SizedBox(width: 15),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        pet['name'],
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        pet['type'],
                        style: const TextStyle(color: Colors.grey),
                      ),
                    ],
                  )
                ],
              ),

              const SizedBox(height: 15),

              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _infoChip(
                    pet['status'] == 'lost' ? "Lost" : "Found",
                    pet['status'] == 'lost'
                        ? Colors.red.shade100
                        : Colors.green.shade100,
                  ),
                  ElevatedButton(
                    onPressed: () {
                      // 🔥 FUTURE: navigate to details page
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.orange,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: const Text("View Details"),
                  )
                ],
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _infoChip(String text, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 6),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        text,
        style: const TextStyle(fontWeight: FontWeight.w600),
      ),
    );
  }

  void _goToCurrentLocation() {
    mapController?.animateCamera(
      CameraUpdate.newLatLngZoom(currentPosition, 15),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,

      appBar: AppBar(
        title: const Text("Nearby Pets"),
        backgroundColor: Colors.orange,
        elevation: 0,
      ),

      body: Stack(
        children: [
          GoogleMap(
            initialCameraPosition: CameraPosition(
              target: currentPosition,
              zoom: 14,
            ),
            myLocationEnabled: true,
            myLocationButtonEnabled: false,
            markers: markers,
            onMapCreated: (controller) {
              mapController = controller;
            },
          ),

          Positioned(
            bottom: 20,
            right: 20,
            child: FloatingActionButton(
              onPressed: _goToCurrentLocation,
              backgroundColor: Colors.orange,
              child: const Icon(Icons.my_location),
            ),
          ),

          Positioned(
            top: 15,
            left: 15,
            right: 15,
            child: Container(
              padding: const EdgeInsets.all(15),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(15),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.05),
                    blurRadius: 10,
                  )
                ],
              ),
              child: const Row(
                children: [
                  Icon(Icons.pets, color: Colors.orange),
                  SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      "Find lost & found pets near you",
                      style: TextStyle(fontWeight: FontWeight.w600),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}