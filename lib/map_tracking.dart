import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';
import 'constants.dart';
import 'package:provider/provider.dart';

late GoogleMapController googleMapController;

class LocationService with ChangeNotifier{
  late UserLocation _currentLocation;

  var location = Location();
  final StreamController<UserLocation> _locationController =
      StreamController<UserLocation>();

  Stream<UserLocation> get locationStream => _locationController.stream;

  LocationService() {
    // Request permission to use location
    location.requestPermission().then((permissionStatus) {
      if (permissionStatus == PermissionStatus.granted) {
        // If granted listen to the onLocationChanged stream and emit over our controller
        location.onLocationChanged.listen((locationData) {
          _locationController.add(UserLocation(
            latitude: locationData.latitude!,
            longitude: locationData.longitude!,
          ));
          //notifyListeners();
          

          //googleMapController = await _controller.future;

          // googleMapController.animateCamera(CameraUpdate.newCameraPosition(
          //   CameraPosition(
          //     zoom: 13.5,
          //     target: LatLng(
          //       locationData.latitude!,
          //       locationData.longitude!,
          //     ),
          //   ),
          // ));
        });
      }
    });
  }

  Future<UserLocation> getLocation() async {
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

class UserLocation with ChangeNotifier {
  final double latitude;
  final double longitude;

  UserLocation({required this.latitude, required this.longitude});
  LatLng latLng() {
    return LatLng(latitude, longitude);
  }
}

class MapTrackingPage extends StatefulWidget {
  const MapTrackingPage({Key? key}) : super(key: key);

  @override
  State<MapTrackingPage> createState() => MapTrackingPageState();
}

class MapTrackingPageState extends State<MapTrackingPage> {
  final Completer<GoogleMapController> _controller = Completer();

  static const LatLng sourceLocation = LatLng(35.118339, 32.850870);
  static const LatLng destination = LatLng(35.106985, 32.856650);

  List<LatLng> polylineCoordinates = [];
  LocationData? currentLocation;

  BitmapDescriptor sourceIcon = BitmapDescriptor.defaultMarker;
  BitmapDescriptor destinationIcon = BitmapDescriptor.defaultMarker;
  BitmapDescriptor currentLocationIcon = BitmapDescriptor.defaultMarker;

  late Location location;
  void setController() async {
    //location = Location();
    googleMapController = await _controller.future;
    updateMap();
  }

  void updateMap() {
    //location = Location();
    // location.onLocationChanged.listen((locationData) {
    googleMapController.animateCamera(CameraUpdate.newCameraPosition(
      CameraPosition(
        zoom: 13.5,
        target: LatLng(
          Provider.of<UserLocation>(context, listen: true).latitude,
          Provider.of<UserLocation>(context, listen: false).longitude,
        ),
      ),
    ));

    //   location.onLocationChanged.listen((newloc) {
    //     currentLocation = newloc;
    //     googleMapController.animateCamera(
    //       CameraUpdate.newCameraPosition(
    //         CameraPosition(
    //           zoom: 13.5,
    //           target: LatLng(
    //             newloc.latitude!,
    //             newloc.longitude!,
    //           ),
    //         ),
    //       ),
    //     );
    //     setState(() {});
    //   });
    //   setState(() {});
  }

  void getPolylinePoints() async {
    PolylinePoints polylinePoints = PolylinePoints();

    PolylineResult result = await polylinePoints.getRouteBetweenCoordinates(
        google_api_key,
        PointLatLng(sourceLocation.latitude, sourceLocation.longitude),
        PointLatLng(destination.latitude, destination.longitude));

    if (result.points.isNotEmpty) {
      result.points.forEach((PointLatLng point) =>
          polylineCoordinates.add(LatLng(point.latitude, point.longitude)));
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

  @override
  void initState() {
    setController();
    //updateMaps();
    //setCustomMarkerIcon();
    getPolylinePoints();
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
    googleMapController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var userLocation = Provider.of<UserLocation>(context);
    return Center(
      child: GoogleMap(
        initialCameraPosition: CameraPosition(
          target: userLocation.latLng(),
          zoom: 13.5,
        ),
        polylines: {
          Polyline(
            polylineId: PolylineId("route"),
            points: polylineCoordinates,
            color: primaryColor,
            width: 6,
          )
        },
        markers: {
          Marker(
            markerId: MarkerId("currentlocation"),
            icon: currentLocationIcon,
            position: userLocation.latLng(),
          ),
          Marker(
            markerId: MarkerId("source"),
            position: sourceLocation,
          ),
          Marker(
            markerId: MarkerId("destination"),
            position: destination,
          ),
        },
        onMapCreated: ((mapController) {
          _controller.complete(mapController);
        }),
      ),
    );
  }
}
