import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../components/location_service.dart';
import '../constants.dart';
import 'package:provider/provider.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import '../components/map_helper.dart';

GoogleMapController? googleMapController;
final Completer<GoogleMapController> _controller = Completer();
//Timer.periodic(oneSec, (Timer t) => print('hi!'));

class MapTrackingPage extends StatefulWidget {
  const MapTrackingPage({Key? key}) : super(key: key);

  @override
  State<MapTrackingPage> createState() => MapTrackingPageState();
}

bool liveTrackingToggle = true;

class MapTrackingPageState extends State<MapTrackingPage> {
  bool ongoingRun = false;
  //late var loc;
  static const LatLng sourceLocation = LatLng(35.118339, 32.850870);
  static const LatLng destination = LatLng(35.106985, 32.856650);

  LocationData? currentLocation;

  RunHelper runHelper = RunHelper();

  BitmapDescriptor sourceIcon = BitmapDescriptor.defaultMarker;
  BitmapDescriptor destinationIcon = BitmapDescriptor.defaultMarker;
  BitmapDescriptor currentLocationIcon = BitmapDescriptor.defaultMarker;

  UserLocation? userLocation;
  //Location? userLocation;
  late Location location;
  void setController() async {
    userLocation = context.read<LocationService>().currentlocation;
    //googleMapController = await _controller.future;

    addListener();
  }

  void addListener() {
    context.read<LocationService>().addListener(updateMapValues);
  }

  void removeListener() {
    context.read<LocationService>().removeListener(updateMapValues);
  }

  void updateMapValues() {
    userLocation = context.read<LocationService>().currentlocation;

    runHelper.addLiveCoordinates(userLocation);

    if (liveTrackingToggle) {
      googleMapController?.animateCamera(CameraUpdate.newCameraPosition(
        CameraPosition(
          zoom: 15.5,
          target: LatLng(
            userLocation!.latitude,
            userLocation!.longitude,
          ),
        ),
      ));
    }
    setState(() {});
  }

  void getPolylinePoints() async {
    PolylinePoints polylinePoints = PolylinePoints();
    // add try catch
    PolylineResult result = await polylinePoints.getRouteBetweenCoordinates(
        google_api_key,
        PointLatLng(sourceLocation.latitude, sourceLocation.longitude),
        PointLatLng(destination.latitude, destination.longitude));

    if (result.points.isNotEmpty) {
      for (var point in result.points) {
        runHelper.routePolylineCoordinates
            .add(LatLng(point.latitude, point.longitude));
      }
    }
    if (mounted) setState(() {});
  }

  void setCustomMarkerIcon() {
    BitmapDescriptor.fromAssetImage(
            ImageConfiguration.empty, "assets/Pin_source.png")
        .then((icon) {
      sourceIcon = icon;
    });
    BitmapDescriptor.fromAssetImage(
            ImageConfiguration.empty, "assets/Pin_desetination.png")
        .then((icon) {
      destinationIcon = icon;
    });
    BitmapDescriptor.fromAssetImage(
            ImageConfiguration.empty, "assets/Badge.png")
        .then((icon) {
      currentLocationIcon = icon;
    });
  }

  //shared preferences
  getBoolValuesSF() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    liveTrackingToggle = prefs.getBool('liveTrackingToggle') ?? true;
    if (mounted) {
      setState(() {});
    }
  }

  // ignore: prefer_typing_uninitialized_variables
  var loc;
  @override
  void initState() {
    //setController();
    //setCustomMarkerIcon();
    super.initState();
    getBoolValuesSF();
    loc = context.read<LocationService>();
  }

  @override
  void dispose() {
    loc.removeListener(updateMapValues);
    googleMapController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    userLocation = context.read<LocationService>().currentlocation;
    return Scaffold(
      body: Center(
        child: userLocation == null
            ? const Center(child: Text("Loading"))
            : Stack(
                //alignment: Alignment.bottomCenter,
                children: [
                  GoogleMap(
                    zoomControlsEnabled: false,
                    initialCameraPosition: CameraPosition(
                      target: userLocation!.latLng(),
                      zoom: 15.5,
                    ),
                    polylines: {
                      Polyline(
                        polylineId: PolylineId("route"),
                        points: runHelper.liveCoordinates,
                        color: primaryColor,
                        width: 6,
                      )
                    },
                    markers: {
                      Marker(
                        markerId: MarkerId("currentlocation"),
                        icon: currentLocationIcon,
                        position: userLocation!.latLng(),
                      ),
                      Marker(
                        markerId: MarkerId("source"),
                        position: sourceLocation,
                      ),
                      const Marker(
                        markerId: MarkerId("destination"),
                        position: destination,
                      ),
                    },
                    onMapCreated: ((mapController) {
                      //_controller.complete(mapController);
                      googleMapController = mapController;
                      addListener();
                      getPolylinePoints();
                    }),
                  ),
                  Align(
                    alignment: Alignment.bottomCenter,
                    child: Card(
                      clipBehavior: Clip.antiAlias,
                      elevation: 0,
                      margin: const EdgeInsets.symmetric(),
                      shape: const RoundedRectangleBorder(
                          borderRadius: BorderRadius.vertical(
                              top: Radius.circular(
                        16, //getHorizontalSize(16),
                      ))),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 15, vertical: 15),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                OutlinedButton(
                                  onPressed: () {
                                    if (ongoingRun) {
                                      runHelper.stopRun();
                                    } else {
                                      runHelper.startRun();
                                    }
                                    ongoingRun = !ongoingRun;
                                  },
                                  child: Center(
                                    child: Text(
                                      ongoingRun ? "Stop Run" : "Start Run",
                                      style: const TextStyle(
                                        fontSize: 32,
                                        color: Colors.black,
                                      ),
                                    ),
                                  ),
                                ),
                                OutlinedButton(
                                    onPressed: () {},
                                    child: Text(
                                      runHelper.stopwatch.elapsed.inSeconds
                                          .toString(),
                                      style: const TextStyle(
                                        fontSize: 32,
                                        color: Colors.black,
                                      ),
                                    )),
                                OutlinedButton(
                                  onPressed: () {
                                    googleMapController?.animateCamera(
                                        CameraUpdate.newCameraPosition(
                                      CameraPosition(
                                        zoom: 15.5,
                                        target: LatLng(
                                          userLocation!.latitude,
                                          userLocation!.longitude,
                                        ),
                                      ),
                                    ));
                                  },
                                  child: Icon(
                                    Icons.my_location,
                                    color: Colors.black,
                                  ),
                                )
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  )
                  // FloatingActionButton(onPressed: (() {
                  //   removeListener();
                  //   Navigator.pop(context);
                  // }))
                ],
              ),
      ),
    );
  }
}

Text returnTextBody(String data) {
  return Text(
    data,
    style: const TextStyle(
      color: Colors.black,
      fontSize: 32,
    ),
  );
}

Text returnTextLabel(String data) {
  return Text(
    data,
    style: const TextStyle(
      color: Colors.grey,
      fontSize: 16,
    ),
  );
}
