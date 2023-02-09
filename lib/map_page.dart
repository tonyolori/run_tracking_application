import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';
import 'components/location_service.dart';
import 'constants.dart';
import 'package:provider/provider.dart';
import 'dart:math' show cos, sqrt, asin;

late GoogleMapController googleMapController;
final Completer<GoogleMapController> _controller = Completer();
//Timer.periodic(oneSec, (Timer t) => print('hi!'));

class MapTrackingPage extends StatefulWidget {
  const MapTrackingPage({Key? key}) : super(key: key);

  @override
  State<MapTrackingPage> createState() => MapTrackingPageState();
}

class MapTrackingPageState extends State<MapTrackingPage> {
  //late var loc;
  static const LatLng sourceLocation = LatLng(35.118339, 32.850870);
  static const LatLng destination = LatLng(35.106985, 32.856650);

  List<LatLng> polylineCoordinates = [];
  List<LatLng> liveCoordinates = [];

  LocationData? currentLocation;

  BitmapDescriptor sourceIcon = BitmapDescriptor.defaultMarker;
  BitmapDescriptor destinationIcon = BitmapDescriptor.defaultMarker;
  BitmapDescriptor currentLocationIcon = BitmapDescriptor.defaultMarker;

  UserLocation? userLocation;
  //Location? userLocation;
  late Location location;
  void setController() async {
    userLocation = context.read<LocationService>().currentlocation;
    googleMapController = await _controller.future;

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
    liveCoordinates.add(userLocation!.latLng());
    if (liveCoordinates.length > 2) {
      print(getDistance(
          liveCoordinates[liveCoordinates.length - 2].latitude,
          liveCoordinates[liveCoordinates.length - 2].longitude,
          liveCoordinates[liveCoordinates.length - 1].latitude,
          liveCoordinates[liveCoordinates.length - 1].longitude));
    }
    googleMapController.animateCamera(CameraUpdate.newCameraPosition(
      CameraPosition(
        zoom: 15.5,
        target: LatLng(
          userLocation!.latitude,
          userLocation!.longitude,
        ),
      ),
    ));
    setState(() {});
  }

  //KM
  double getDistance(lat1, lon1, lat2, lon2) {
    var p = 0.017453292519943295;
    var c = cos;
    var a = 0.5 -
        c((lat2 - lat1) * p) / 2 +
        c(lat1 * p) * c(lat2 * p) * (1 - c((lon2 - lon1) * p)) / 2;
    return 12742 * asin(sqrt(a));
  }

  //ex distance variation 0.00011963740546565533
  double getTotalDistance(List<UserLocation> data) {
    double totalDistance = 0;
    for (var i = 0; i < data.length - 1; i++) {
      totalDistance += getDistance(data[i], data[i], data[i + 1], data[i + 1]);
    }
    return totalDistance;
  }

  void getPolylinePoints() async {
    PolylinePoints polylinePoints = PolylinePoints();

    PolylineResult result = await polylinePoints.getRouteBetweenCoordinates(
        google_api_key,
        PointLatLng(sourceLocation.latitude, sourceLocation.longitude),
        PointLatLng(destination.latitude, destination.longitude));

    if (result.points.isNotEmpty) {
      for (var point in result.points) {
        polylineCoordinates.add(LatLng(point.latitude, point.longitude));
      }
    }
    setState(() {});
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

  var loc;
  @override
  void initState() {
    setController();
    //setCustomMarkerIcon();
    getPolylinePoints();
    super.initState();
    loc = context.read<LocationService>();
  }

  @override
  void dispose() {
    loc.removeListener(updateMapValues);
    googleMapController.dispose();
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
                        points: liveCoordinates,
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
                    }),
                  ),
                  Align(
                    alignment: Alignment.topCenter,
                    child: Container(
                      height: 200,
                      width: double.infinity,
                      color: Colors.white,
                      child: Column(
                        children: [
                          const Icon(Icons.map),
                          const Text(
                            "00:00:00",
                            style: TextStyle(
                              color: Colors.black,
                              fontSize: 64,
                            ),
                          ),
                          returnTextLabel("duration"),
                          Padding(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 8.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                returnTextBody("0.00"),
                                returnTextBody("0.00"),
                                returnTextBody("00:00"),
                              ],
                            ),
                          ),
                          Padding(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 8.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                returnTextLabel("Distance(KM)"),
                                returnTextLabel("Calories(cal)"),
                                returnTextLabel("Avg. Pace(min/Km)"),
                              ],
                            ),
                          )
                        ],
                      ),
                    ),
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
                                    print("object");
                                    googleMapController.animateCamera(
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
                                  child: const Center(
                                    child: Text(
                                      "Stop Run",
                                      style: TextStyle(
                                        fontSize: 32,
                                        color: Colors.black,
                                      ),
                                    ),
                                  ),
                                ),
                                OutlinedButton(
                                  onPressed: () {},
                                  child: Icon(Icons.my_location,
                                  color: Colors.black,),
                                )
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
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
