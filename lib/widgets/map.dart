import 'dart:async';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';
import 'package:location/location.dart';
import 'package:project_jelly/classes/person.dart';
import 'package:project_jelly/service/location_service.dart';

class MapWidget extends StatefulWidget {
  @override
  _MapWidgetState createState() => _MapWidgetState();
}

class _MapWidgetState extends State<MapWidget> {
  final Completer<GoogleMapController> _controller = Completer();
  // bool followMarker = true;
  LocationData? currentLocation;
  Set<Marker> markers = {};

  @override
  void initState() {
    super.initState();
    loadMarkers();
    getCurrentLocation();
  }

  void loadMarkers() async {
    List<Person> friendList = await LocationService().getFriendsLocation();
      setState(() {
        markers = friendList.map((friend) => createMarker(friend)).toSet();
      });
  }

  void getCurrentLocation() async {
    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      return Future.error("Location services are disabled.");
    }

    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return Future.error("Location permission are denied");
      }
    }
    if (permission == LocationPermission.deniedForever) {
      return Future.error("Location permission are permanently denied");
    }

    Location location = Location();
    location.getLocation().then((location) {
      setState(() {
        currentLocation = location;
        LocationService().sendLocation(location);
      });
    });

    GoogleMapController googleMapController = await _controller.future;
    // location.onLocationChanged.listen((newLoc) {
    //   if (followMarker) {
    //     googleMapController.animateCamera(CameraUpdate.newCameraPosition(
    //       CameraPosition(
    //         target: LatLng(newLoc.latitude!, newLoc.longitude!),
    //         zoom: 15,
    //       ),
    //     ));
    //   }
    // });
  }

  Marker createMarker(Person friend) {
    return Marker(
        markerId: MarkerId(friend.name),
        position: friend.location,
        infoWindow: InfoWindow(
          title: friend.name,
        ),
        icon: friend.avatar);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: currentLocation == null
            ? const Center(child: Text("Loading"))
            : GoogleMap(
                initialCameraPosition: CameraPosition(
                  target: LatLng(
                    currentLocation!.latitude!,
                    currentLocation!.longitude!,
                  ),
                  zoom: 13,
                ),
                onMapCreated: (mapController) {
                  _controller.complete(mapController);
                },
                myLocationButtonEnabled: true,
                myLocationEnabled: true,
                padding: EdgeInsets.only(bottom: 100, left: 0),
                mapType: MapType.satellite,
                markers: markers));
  }
}
