import 'dart:async';
import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';
import 'package:location/location.dart';
import 'package:project_jelly/classes/friend.dart';
import 'package:project_jelly/service/location_service.dart';
import 'package:project_jelly/service/service_locatior.dart';

class MapWidget extends StatefulWidget {
  const MapWidget({super.key});

  @override
  State<MapWidget> createState() => _MapWidgetState();
}

class _MapWidgetState extends State<MapWidget> {
  final Completer<GoogleMapController> _controller = Completer();
  // bool followMarker = true;
  LocationData? currentLocation;
  Set<Marker> markers = {};
  MapType mapType = MapType.normal;
  String _darkMapStyle = '';
  String _lightMapStyle = '';

  @override
  void initState() {
    super.initState();
    loadMarkers();
    loadMapStyles();
    getCurrentLocation();
  }

  void loadMarkers() async {
    List<Friend> friendList =
        await serviceLocator.get<LocationService>().getFriendsLocation();
    setState(() {
      markers = friendList
          .map((friend) => createMarker(friend))
          .whereType<Marker>()
          .toSet();
    });
  }

  MapType getNextMap(MapType currentMapType) {
    switch (currentMapType) {
      case MapType.normal:
        return MapType.satellite;
      case MapType.satellite:
        return MapType.terrain;
      case MapType.terrain:
        return MapType.hybrid;
      case MapType.hybrid:
        return MapType.normal;
      case MapType.none:
        return MapType.normal;
    }
  }

  Future loadMapStyles() async {
    _darkMapStyle = await rootBundle.loadString('assets/map/dark_map.json');
    _lightMapStyle = await rootBundle.loadString('assets/map/light_map.json');
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
        serviceLocator.get<LocationService>().sendLocation(location);
      });
    });

    GoogleMapController googleMapController = await _controller.future;
  }

  Marker? createMarker(Friend friend) {
    BitmapDescriptor.fromAssetImage(
            const ImageConfiguration(size: Size(300, 300)), friend.avatar)
        .then((icon) {
      return Marker(
          markerId: MarkerId(friend.name),
          position: friend.location,
          infoWindow: InfoWindow(
            title: friend.name,
          ),
          icon: icon);
    });
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: currentLocation == null
            ? const Center(child: Text("Loading"))
            : Stack(children: [
                GoogleMap(
                    initialCameraPosition: CameraPosition(
                      target: LatLng(
                        currentLocation!.latitude!,
                        currentLocation!.longitude!,
                      ),
                      zoom: 13,
                    ),
                    onMapCreated: (mapController) {
                      if (Theme.of(context).brightness == Brightness.light) {
                        mapController.setMapStyle(_lightMapStyle);
                      } else {
                        mapController.setMapStyle(_darkMapStyle);
                      }
                      _controller.complete(mapController);
                    },
                    myLocationButtonEnabled: true,
                    myLocationEnabled: true,
                    padding: EdgeInsets.only(bottom: 100, left: 0),
                    mapType: mapType,
                    markers: markers),
                Positioned(
                  top: 50.0,
                  right: 10.0,
                  child: FloatingActionButton(
                      onPressed: () {
                        setState(() {
                          mapType = getNextMap(mapType);
                        });
                      },
                      child: Icon(
                        Icons.map_rounded,
                        color: Colors.grey[700],
                      ),
                      backgroundColor: Colors.grey[50]),
                ),
              ]));
  }
}
