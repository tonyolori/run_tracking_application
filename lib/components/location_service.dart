import 'dart:async';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';

class LocationService with ChangeNotifier {
  UserLocation? _currentLocation;

  var location = Location();

  UserLocation? get currentlocation => _currentLocation;

  LocationService() {
    // Request permission to use location
    location.requestPermission().then((permissionStatus) {
      if (permissionStatus == PermissionStatus.granted) {
        // If granted listen to the onLocationChanged stream and emit over our controller
        location.onLocationChanged.listen((locationData) {
          UserLocation newlocation = UserLocation(
              latitude: locationData.latitude!,
              longitude: locationData.longitude!);

          _currentLocation = newlocation;
          notifyListeners();
        });
      }
    });
  }

  Future<UserLocation?> getLocation() async {
    try {
      var userLocation = await location.getLocation();
      _currentLocation = UserLocation(
        latitude: userLocation.latitude!,
        longitude: userLocation.longitude!,
      );
    } on Exception catch (e) {
      print('Could not get location: ${e.toString()}');
    }

    return _currentLocation;
  }
}

class UserLocation {
  double latitude;
  double longitude;

  UserLocation({required this.latitude, required this.longitude});
  LatLng latLng() {
    return LatLng(latitude, longitude);
  }
}
