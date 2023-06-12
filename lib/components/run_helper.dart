// ignore_for_file: unused_field

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
  double dist = 0;
  String displayTime = "";
  int time = 0;
  int _lastTime = 0;
  double speed = 0;

  List<LatLng> liveCoordinates = []; //live distance calcs and polyline tracking

  List<LatLng> routePolylineCoordinates = [];

  //double _dist = 0; //Start/end route coordinates

  startRun() {
    isRunning = true;
    stopwatch.start();
    timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      displayTime =
          "${stopwatch.elapsed.inHours % 24}:${stopwatch.elapsed.inMinutes % 60}:${stopwatch.elapsed.inSeconds % 60}";

      elapsedSeconds += 1;
      speed = dist / (elapsedSeconds / 60 / 60);
      notifyListeners();
    });
  }


  ///returns the calories burned for that run
  double stopRun(double weight) {
    isRunning = false;

    stopwatch.elapsed.inSeconds;
    stopwatch.stop();
    timer?.cancel();
    liveCoordinates.clear();
    return getMet(speed)*weight *(stopwatch.elapsed.inSeconds.toDouble()/60/60);
  }

  getMet(double speed) {
    return 1.0208333333 * speed;
  }

  addLiveCoordinates(UserLocation? userLocation) {
    if (liveCoordinates.isNotEmpty) {
      double appendDist;

      appendDist = getDistance(
          liveCoordinates.last.latitude,
          liveCoordinates.last.longitude,
          userLocation!.latitude,
          userLocation.longitude);
      dist = dist + appendDist;
      if (appendDist > 0) {
        _lastTime = time;
      }
    }
    liveCoordinates.add(userLocation!.latLng());
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
