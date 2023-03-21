import 'dart:async';
import 'dart:math' show cos, sqrt, asin;
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import '../components/location_service.dart';

class RunHelper with ChangeNotifier {
  bool isRunning = false;
  double totalDistance = 0;
  int elapsedSeconds = 0;
  Timer? timer;
  final stopwatch = Stopwatch();

  List<LatLng> liveCoordinates = []; //live distance calcs and polyline tracking

  List<LatLng> routePolylineCoordinates = []; //Start/end route coordinates

  startRun() {
    isRunning = true;
    stopwatch.start();
    timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      elapsedSeconds += 1;
      notifyListeners();
    });
  }

  stopRun() {
    isRunning = false;
    stopwatch.stop();
    timer?.cancel();
    liveCoordinates.clear();
  }

  addLiveCoordinates(UserLocation? userLocation) {
    liveCoordinates.add(userLocation!.latLng());
    if (liveCoordinates.length > 2) {
      totalDistance += getDistance(
          liveCoordinates[liveCoordinates.length - 2].latitude,
          liveCoordinates[liveCoordinates.length - 2].longitude,
          liveCoordinates[liveCoordinates.length - 1].latitude,
          liveCoordinates[liveCoordinates.length - 1].longitude);
    }
    //notifyListeners();
  }

  //KM
  static double getDistance(lat1, lon1, lat2, lon2) {
    var p = 0.017453292519943295;
    var c = cos;
    var a = 0.5 -
        c((lat2 - lat1) * p) / 2 +
        c(lat1 * p) * c(lat2 * p) * (1 - c((lon2 - lon1) * p)) / 2;
    return 12742 * asin(sqrt(a));
  }

  //ex distance variation 0.00011963740546565533
  static double getTotalDistance(List<UserLocation> data) {
    double totalDistance = 0;
    for (var i = 0; i < data.length - 1; i++) {
      totalDistance += getDistance(data[i], data[i], data[i + 1], data[i + 1]);
    }
    return totalDistance;
  }
}
