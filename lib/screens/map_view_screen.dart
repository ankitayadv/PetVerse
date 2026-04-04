import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import '../data/lost_pet_data.dart';
import '../routes/app_routes.dart';

class MapViewScreen extends StatefulWidget {
  const MapViewScreen({super.key});

  @override
  State<MapViewScreen> createState() => _MapViewScreenState();
}

class _MapViewScreenState extends State<MapViewScreen> {
  late GoogleMapController mapController;

  final LatLng initialPosition = const LatLng(28.6139, 77.2090);

  Set<Marker> markers = {};

  @override
  void initState() {
    super.initState();

    // 🔥 REAL-TIME UPDATE LISTENER
    LostPetData.petsNotifier.addListener(_loadMarkers);

    _loadMarkers();
  }

  @override
  void dispose() {
    LostPetData.petsNotifier.removeListener(_loadMarkers);
    super.dispose();
  }

  // 🔥 LOAD MARKERS
  void _loadMarkers() {
    final pets = LostPetData.petsNotifier.value;

    final Set<Marker> loadedMarkers = {};

    for (int i = 0; i < pets.length; i++) {
      final pet = pets[i];

      final marker = Marker(
        markerId: MarkerId(i.toString()),
        position: LatLng(pet["lat"], pet["lng"]),

        infoWindow: InfoWindow(
          title: pet["name"],
          snippet: pet["location"],
        ),

        icon: BitmapDescriptor.defaultMarkerWithHue(
          pet["type"] == "LOST"
              ? BitmapDescriptor.hueRed
              : BitmapDescriptor.hueGreen,
        ),

        onTap: () {
          Navigator.pushNamed(
            context,
            AppRoutes.petDetail,
            arguments: pet,
          );
        },
      );

      loadedMarkers.add(marker);
    }

    setState(() {
      markers = loadedMarkers;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,

      appBar: AppBar(
        title: const Text("Pet Map"),
        centerTitle: true,
        backgroundColor: Colors.white,
        elevation: 0,
        foregroundColor: Colors.black,
      ),

      body: Stack(
        children: [

          // 🔥 GOOGLE MAP
          GoogleMap(
            initialCameraPosition: CameraPosition(
              target: initialPosition,
              zoom: 12,
            ),
            markers: markers,
            onMapCreated: (controller) {
              mapController = controller;
            },
            myLocationEnabled: true,
            myLocationButtonEnabled: true,
          ),

          // 🔥 TOP PREMIUM CARD
          Positioned(
            top: 20,
            left: 20,
            right: 20,
            child: Container(
              padding: const EdgeInsets.all(15),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    Colors.white,
                    Colors.orange.withOpacity(0.1),
                  ],
                ),
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: Colors.orange.withOpacity(0.15),
                    blurRadius: 12,
                  )
                ],
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: const [
                  Text(
                    "Live Pet Tracking",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                  Icon(Icons.pets, color: Colors.orange),
                ],
              ),
            ),
          ),

          // 🔥 LEGEND CARD
          Positioned(
            bottom: 20,
            left: 20,
            right: 20,
            child: Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    Colors.white,
                    Colors.orange.withOpacity(0.08),
                  ],
                ),
                borderRadius: BorderRadius.circular(15),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: 10,
                  )
                ],
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: const [
                  Row(
                    children: [
                      Icon(Icons.location_on, color: Colors.red),
                      SizedBox(width: 5),
                      Text("Lost Pets"),
                    ],
                  ),
                  Row(
                    children: [
                      Icon(Icons.location_on, color: Colors.green),
                      SizedBox(width: 5),
                      Text("Found Pets"),
                    ],
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