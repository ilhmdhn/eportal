import 'package:eportal/util/toast.dart';
import 'package:flutter/material.dart';
import 'package:location/location.dart';

class LocationProvider with ChangeNotifier {
  final Location _location = Location();
  LocationData? _currentLocation;
  bool _isTracking = true;

  LocationData? get currentLocation => _currentLocation;
  bool get isTracking => _isTracking;

  Future<void> initializeLocation() async {
    // Memeriksa izin lokasi
    bool serviceEnabled = await _location.serviceEnabled();
    if (!serviceEnabled) {
      serviceEnabled = await _location.requestService();
      if (!serviceEnabled){
       return ShowToast.warning('Akses lokasi tidak diizinkan'); 
      }
    }

    PermissionStatus permissionGranted = await _location.hasPermission();
    if (permissionGranted == PermissionStatus.denied) {
      permissionGranted = await _location.requestPermission();
      if (permissionGranted != PermissionStatus.granted) return;
    }

    // Dapatkan lokasi awal
    _currentLocation = await _location.getLocation();

    // Lacak lokasi secara real-time
    _location.onLocationChanged.listen((newLocation) {
      _currentLocation = newLocation;
      notifyListeners(); // Update UI
    });
  }

  void toggleTracking() {
    _isTracking = !_isTracking;
    if (!_isTracking) {
      _location.onLocationChanged.listen(null); // Hentikan listener
    }
    notifyListeners();
  }
}