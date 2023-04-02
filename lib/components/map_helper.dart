import 'dart:async';
import 'dart:math' show cos, sqrt, asin;
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:location/location.dart';
import '../model/entry.dart';

import '../components/location_service.dart';

class RunHelper with ChangeNotifier {
  bool isRunning = false;
  double totalDistance = 0;
  int elapsedSeconds = 0;
  Timer? timer;
  final stopwatch = Stopwatch();
  //un tested stuff
  double dist = 0;
  String displayTime = "";
  int time = 0;
  int _lastTime = 0;
  double speed = 0;
  double _avgSpeed = 0;
  int _speedCounter = 0;
  int rawtime = 0;

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
      speed = dist / (elapsedSeconds/60/60);
      notifyListeners();
    });
  }

  stopRun() {
    isRunning = false;

    stopwatch.elapsed.inSeconds;
    stopwatch.stop();
    timer?.cancel();
    liveCoordinates.clear();
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
      // int timeDuration = (time - _lastTime);

      // if (timeDuration != 0) {
      //   speed = (appendDist / (timeDuration / 100)) * 3.6;
      //   if (speed != 0) {
      //     _avgSpeed = _avgSpeed + speed;
      //     _speedCounter++;
      //   }
      // }
    }
    liveCoordinates.add(userLocation!.latLng());

    _lastTime = time;

    // if (liveCoordinates.length > 2) {
    //   totalDistance += getDistance(
    //       liveCoordinates[liveCoordinates.length - 2].latitude,
    //       liveCoordinates[liveCoordinates.length - 2].longitude,
    //       liveCoordinates[liveCoordinates.length - 1].latitude,
    //       liveCoordinates[liveCoordinates.length - 1].longitude);
    // }
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
