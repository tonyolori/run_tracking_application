import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../components/location_service.dart';
import '../constants.dart';
import 'package:provider/provider.dart';
import '../components/map_helper.dart';
import '../api_key.dart';
import '../model/entry.dart';
import 'package:intl/intl.dart'; // for date format

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

  UserLocation? userLocation = UserLocation(longitude: 35.118339, latitude: 32.850870);
  //Location? userLocation;
  late Location location;
  void setController() async {
    userLocation = context.read<LocationService>().currentlocation;
    //googleMapController = await _controller.future;

    addMapListener();
  }

  void addMapListener() {
    context.read<LocationService>().addListener(setStateMapValues);
  }

  void removeMapListener() {
    context.read<LocationService>().removeListener(setStateMapValues);
  }

  void addStepListener() {
    runHelper.addListener(setStateRun);
  }

  void removeStepListener() {
    runHelper.removeListener(setStateRun);
  }

  setStateRun() {
    if (mounted) setState(() {});
  }

  void setStateMapValues() {
    userLocation = context.read<LocationService>().currentlocation;

    if (runHelper.isRunning) {
      runHelper.addLiveCoordinates(userLocation);
    }

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

    if (mounted) setState(() {});
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
    loc.removeListener(setStateMapValues);
    googleMapController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    userLocation = context.watch<LocationService>().currentlocation;
    return Scaffold(
      appBar: AppBar(
        title: const Text("Map Page"),
        foregroundColor: Colors.black,
        backgroundColor: Colors.white,
      ),
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
                        polylineId: const PolylineId("route"),
                        points: runHelper.liveCoordinates,
                        color: primaryColor,
                        width: 6,
                      )
                    },
                    markers: {
                      Marker(
                        markerId: const MarkerId("currentlocation"),
                        icon: currentLocationIcon,
                        position: userLocation!.latLng(),
                      ),
                    },
                    onMapCreated: ((mapController) {
                      //_controller.complete(mapController);
                      googleMapController = mapController;
                      addMapListener();
                      getPolylinePoints();
                    }),
                  ),
                  DraggableScrollableSheet(
                    initialChildSize: 0.5,
                    minChildSize: 0.20,
                    maxChildSize: 0.50,
                    builder: (BuildContext context,
                        ScrollController scrollController) {
                      return Card(
                        elevation: 0,
                        margin: const EdgeInsets.symmetric(),
                        shape: const RoundedRectangleBorder(
                          borderRadius: BorderRadius.vertical(
                            top: Radius.circular(16),
                          ),
                        ),
                        child: SingleChildScrollView(
                          controller: scrollController,
                          child: Padding(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 15,
                              vertical: 15,
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Column(
                                      children: [
                                        Text("SPEED (KM/H)",
                                            style: GoogleFonts.montserrat(
                                                fontSize: 10,
                                                fontWeight: FontWeight.w300)),
                                        Text(runHelper.speed.toStringAsFixed(2),
                                            style: GoogleFonts.montserrat(
                                                fontSize: 30,
                                                fontWeight: FontWeight.w300))
                                      ],
                                    ),
                                    Column(
                                      children: [
                                        Text("TIME",
                                            style: GoogleFonts.montserrat(
                                                fontSize: 10,
                                                fontWeight: FontWeight.w300)),
                                        Text(runHelper.displayTime,
                                            style: GoogleFonts.montserrat(
                                                fontSize: 30,
                                                fontWeight: FontWeight.w300))
                                      ],
                                    ),
                                    Column(
                                      children: [
                                        Text("DISTANCE (KM)",
                                            style: GoogleFonts.montserrat(
                                                fontSize: 10,
                                                fontWeight: FontWeight.w300)),
                                        Text(
                                            (runHelper.dist).toStringAsFixed(2),
                                            style: GoogleFonts.montserrat(
                                                fontSize: 30,
                                                fontWeight: FontWeight.w300))
                                      ],
                                    )
                                  ],
                                ),
                                const SizedBox(height: 16),
                                OutlinedButton(
                                  onPressed: () {
                                    if (ongoingRun) {
                                      runHelper.stopRun();

                                      Entry en = Entry(
                                          date: (DateFormat().format(DateTime
                                              .now())), //DateFormat.yMMMMd('en_US').format(DateTime.now()),
                                          duration: runHelper.displayTime,
                                          speed: runHelper.speed,
                                          distance: runHelper.dist);
                                      Navigator.pop(context, en);
                                    } else {
                                      runHelper.startRun();
                                      addStepListener();
                                    }
                                    ongoingRun = !ongoingRun;
                                    if (mounted) setState(() {});
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
                              ],
                            ),
                          ),
                        ),
                      );
                    },
                  ),
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
