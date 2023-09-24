import 'dart:async';
import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';
import 'package:lottie/lottie.dart' as lottie;
import 'package:project_jelly/classes/friend.dart';
import 'package:project_jelly/logic/permissions.dart';
import 'package:project_jelly/pages/loading.dart';
import 'package:project_jelly/service/location_service.dart';
import 'package:project_jelly/widgets/dialogs.dart';
import 'package:project_jelly/widgets/nav_buttons.dart';

class MapWidget extends StatefulWidget {
  const MapWidget({super.key});

  @override
  State<MapWidget> createState() => _MapWidgetState();
}

class _MapWidgetState extends State<MapWidget> with WidgetsBindingObserver {
  final Completer<GoogleMapController> _controller = Completer();
  LocationData? currentLocation;
  Set<Marker> markers = {};
  MapType mapType = MapType.normal;
  String _darkMapStyle = '';
  String _lightMapStyle = '';

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    loadMarkers();
    loadMapStyles();
    getCurrentLocation();
  }

  void loadMarkers() async {
    List<Friend> friendList =
        await Get.find<LocationService>().getFriendsLocation();
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

  @override
  void didChangePlatformBrightness() {
    super.didChangePlatformBrightness();

    Brightness brightness =
        View.of(context).platformDispatcher.platformBrightness;
    if (brightness == Brightness.light) {
      _controller.future.then((value) => value.setMapStyle(_lightMapStyle));
    } else {
      _controller.future.then((value) => value.setMapStyle(_darkMapStyle));
    }
  }

  Future<void> getCurrentLocation() async {
    bool locationPermission = await requestLocationPermission();
    if (locationPermission) {
      Location location = Location();
      location.enableBackgroundMode(enable: true);
      location.getLocation().then((location) {
        log(location.toString());
        setState(() {
          currentLocation = location;
          Get.find<LocationService>().sendLocation(location);
        });
      });
      location.onLocationChanged.listen((newLocation) {
        currentLocation = newLocation;
        Get.find<LocationService>().sendLocation(newLocation);
      });
      // } else {
      //   showDialog(
      //     context: context,
      //     builder: (BuildContext context) {
      //       return Platform.isIOS
      //           ? const IOSDialogWidget(
      //               dialogHeader: 'Oooops...',
      //               dialogText:
      //                   'Please, enable location tracking in the app properties')
      //           : const AndroidDialogWidget(
      //               dialogHeader: 'Oooops...',
      //               dialogText:
      //                   'Please, enable location tracking in the app properties');
      //     },
      //   );
    }
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
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      requestLocationPermission()
          .then((locationGranted) => {if (locationGranted) {}});
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: currentLocation == null
            ? BasicLoadingPage()
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
                NavButtons(),
              ]));
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }
}
