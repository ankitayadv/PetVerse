
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
      "image": "assets/images/Golden_Retriever.jpeg",
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
      "image": "assets/images/labrador.jpeg",
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
      "image": "assets/images/bull_dog.jpeg",
    },

    {
      "name": "sheru",
      "type": "FOUND",
      "location": "Delhi",
      "lat": 29.4595,
      "lng": 76.0266,
      "breed": "Golden Retriever",
      "color": "Golden",
      "time": "1d ago",
      "image": "assets/images/sheru.jpeg",
    },

    {
      "name": "SAMMY",
      "type": "FOUND",
      "location": "delhi",
      "lat": 23.4595,
      "lng": 37.0266,
      "breed": "Golden Retriever",
      "color": "Golden",
      "time": "2d ago",
      "image": "assets/images/sammy.jpeg",
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