import 'dart:async';
import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:google_map_marker_animation/widgets/animarker.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:internet_checker_banner/internet_checker_banner.dart';
import 'package:project_jelly/classes/friend.dart';
import 'package:project_jelly/logic/permissions.dart';
import 'package:project_jelly/misc/location_mock.dart';
import 'package:project_jelly/pages/loading.dart';
import 'package:project_jelly/service/location_service.dart';
import 'package:project_jelly/widgets/nav_buttons.dart';

class MapWidget extends StatefulWidget {
  const MapWidget({super.key});

  @override
  State<MapWidget> createState() => _MapWidgetState();
}

class _MapWidgetState extends State<MapWidget> with WidgetsBindingObserver {
  final Completer<GoogleMapController> _controller = Completer();
  MockLocationService _locationService = MockLocationService();
  late Timer _timer;
  final markers = <MarkerId, Marker>{};
  final avatars = <MarkerId, BitmapDescriptor>{};
  MapType mapType = MapType.normal;
  String _darkMapStyle = '';
  String _lightMapStyle = '';

  @override
  void initState() {
    InternetCheckerBanner().initialize(context, title: "No internet access");
    _timer = Timer.periodic(Duration(seconds: 1), (timer) {
      _updateMarkers();
    });
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    loadMapStyles();
    Get.find<LocationService>().startPositionStream();
  }

  void loadCustomAvatars() {}

  Marker createMarker(Friend friend) {
    // BitmapDescriptor.fromAssetImage(
    //         const ImageConfiguration(size: Size(300, 300)), friend.avatar)
    //     .then((icon) {
    return Marker(
      markerId: MarkerId(friend.name),
      position: friend.location,
      infoWindow: InfoWindow(
        title: friend.name,
      ),
    );
    // icon: icon);
    // });
    // return null;
  }

  Future<void> _updateMarkers() async {
    List<Friend> friendList = await _locationService.getFriendsLocation();

    setState(() {
      for (Friend friend in friendList) {
        markers[MarkerId(friend.id)] = createMarker(friend);
      }
    });
  }

  MapType getNextMap(MapType currentMapType) {
    switch (currentMapType) {
      case MapType.normal:
        return MapType.satellite;
      case MapType.satellite:
        return MapType.normal;
      case MapType.none:
        return MapType.normal;
      case MapType.hybrid:
        return MapType.normal;
      case MapType.terrain:
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

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      log('State resumed');
      requestLocationPermission().then((locationGranted) {
        if (!locationGranted) {
          Get.find<LocationService>().pausePositionStream();
          Get.snackbar('No Location Avaliable',
              "Try modifying application permissions in the settings",
              icon: Icon(Icons.location_disabled_rounded,
                  color: Colors.white, size: 35),
              snackPosition: SnackPosition.TOP,
              isDismissible: false,
              duration: Duration(days: 1),
              backgroundColor: Colors.red[400],
              margin: EdgeInsets.zero,
              snackStyle: SnackStyle.GROUNDED);
        } else {
          Get.find<LocationService>().resumePositionStream();
          try {
            Get.closeAllSnackbars();
          } catch (LateInitializationError) {
            log('Nothing to close');
          }
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Get.find<LocationService>().getCurrentLocation() == null
            ? BasicLoadingPage()
            : Stack(children: [
                Animarker(
                    shouldAnimateCamera: false,
                    markers: markers.values.toSet(),
                    mapId: _controller.future.then<int>((value) => value.mapId),
                    child: GoogleMap(
                        initialCameraPosition: CameraPosition(
                          target: LatLng(
                            Get.find<LocationService>()
                                .getCurrentLocation()!
                                .latitude,
                            Get.find<LocationService>()
                                .getCurrentLocation()!
                                .longitude,
                          ),
                          zoom: 13,
                        ),
                        onMapCreated: (mapController) {
                          if (Theme.of(context).brightness ==
                              Brightness.light) {
                            mapController.setMapStyle(_lightMapStyle);
                          } else {
                            mapController.setMapStyle(_darkMapStyle);
                          }
                          _controller.complete(mapController);
                        },
                        myLocationButtonEnabled: true,
                        myLocationEnabled: true,
                        padding: EdgeInsets.only(bottom: 100, left: 0, top: 40),
                        mapType: mapType)),
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
    InternetCheckerBanner().dispose();
    WidgetsBinding.instance.removeObserver(this);
    Get.find<LocationService>().pausePositionStream();
    _timer.cancel();
    super.dispose();
  }
}
