
import 'package:flutter/material.dart';

class LostPetData {
  static ValueNotifier<List<Map<String, dynamic>>> petsNotifier =
      ValueNotifier([]);

  static List<Map<String, dynamic>> pets = [
    {
      "name": "Alex",
      "type": "LOST",
      "location": "Delhi",
      "lat": 28.6139,
      "lng": 77.2090,
      "breed": "Golden Retriever",
      "color": "Golden",
      "time": "2h ago",
      "image": "assets/images/pet_profile.png",
    },

    {
      "name": "chiku",
      "type": "FOUND",
      "location": "shankar Vihar , Delhi",
      "lat": 28.5355,
      "breed": "Labrador",
      "lng": 77.3910,
      "color": "white-brown",
      "time": "5h ago",
      "image": "assets/images/pet_profile.png",
    },

    {
      "name": "Rocky",
      "type": "LOST",
      "location": "Gurgaon",
      "lat": 28.4595,
      "lng": 77.0266,
      "breed": "Bulldog",
      "color": "Brindle",
      "time": "1d ago",
      "image": "assets/images/pet_profile.png",
    },
  ];

  static void init() {
    petsNotifier.value = List.from(pets);
  }

  static void addPet(Map<String, dynamic> pet) {
    pets.insert(0, pet);
    petsNotifier.value = List.from(pets); // 🔥 refresh UI everywhere
  }
}