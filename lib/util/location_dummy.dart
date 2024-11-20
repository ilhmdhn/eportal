import 'dart:convert'; // Untuk parsing JSON
import 'package:flutter/services.dart'; // Untuk rootBundle

class Location {
  final String brand;
  final String name;
  final double outletLat;
  final double outletLong;
  double distance;

  Location({
    required this.brand,
    required this.name,
    required this.outletLat,
    required this.outletLong,
    this.distance = 0
  });

  // Factory method untuk parsing JSON
  factory Location.fromJson(Map<String, dynamic> json) {
    return Location(
      brand: json['Brand'] ?? '',
      name: json['Name'] ?? '',
      outletLat: double.parse(json['OutletLat'] ?? '0.0'),
      outletLong: double.parse(json['OutletLong'] ?? '0.0'),
    );
  }
}

// Fungsi untuk memuat file JSON dari assets
Future<List<Location>> loadLocations() async {
  // Memuat file JSON
  final String response =
      await rootBundle.loadString('assets/json/locations.json');
  final data = json.decode(response);

  // Parsing JSON menjadi List<Location>
  return (data['location'] as List)
      .map((item) => Location.fromJson(item))
      .toList();
}
