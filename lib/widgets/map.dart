import 'dart:async';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';
import 'package:location/location.dart';
import 'package:project_jelly/classes/person.dart';

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

  @override
  void initState() {
    super.initState();
    // loadMarkers();
    getCurrentLocation();
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

  void loadMarkers() {
    List<Person> friendList = [];

    BitmapDescriptor.fromAssetImage(
            const ImageConfiguration(size: Size(300, 300)), "assets/N01.png")
        .then((icon) {
      friendList.add(Person(
          name: 'Orest',
          avatar: icon,
          location: LatLng(37.30952302005339, -122.03900959279422)));
      // orestAvatar = icon;
    });
    BitmapDescriptor.fromAssetImage(ImageConfiguration.empty, "assets/N02.png")
        .then((icon) {
      friendList.add(Person(
          name: 'Viktor',
          avatar: icon,
          location: LatLng(37.329863949614406, -122.06115391055518)));
    });
    BitmapDescriptor.fromAssetImage(ImageConfiguration.empty, "assets/N03.png")
        .then((icon) {
      friendList.add(Person(
          name: 'Andrii',
          avatar: icon,
          location: LatLng(37.352109801487344, -122.03506138110038)));
      setState(() {
        markers = friendList.map((friend) => createMarker(friend)).toSet();
      });
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
      });
    });

    GoogleMapController googleMapController = await _controller.future;
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
                    child: const Icon(Icons.map_rounded),
                  ),
                ),
              ]));
  }
}
