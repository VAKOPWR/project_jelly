import 'dart:async';
import 'dart:developer';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:internet_checker_banner/internet_checker_banner.dart';
import 'package:project_jelly/pages/loading.dart';
import 'package:project_jelly/service/location_service.dart';
import 'package:project_jelly/widgets/nav_buttons.dart';
import 'package:project_jelly/widgets/snackbars.dart';

class MapWidget extends StatefulWidget {
  const MapWidget({super.key});

  @override
  State<MapWidget> createState() => _MapWidgetState();
}

class _MapWidgetState extends State<MapWidget> with WidgetsBindingObserver {
  final Completer<GoogleMapController> _controller = Completer();
  // late Timer _locationTimer;
  late Timer _markersTimer;
  late Timer _iconsTimer;
  final _internetCheckerBanner = InternetCheckerBanner();
  Map<MarkerId, Marker> _markers = <MarkerId, Marker>{};
  MapType _mapType = MapType.normal;
  String _darkMapStyle = '';
  String _lightMapStyle = '';

  @override
  void initState() {
    _internetCheckerBanner.initialize(context, title: "No internet access");
    checkLocationAccess();
    _updateMarkers();
    _markersTimer = Timer.periodic(Duration(seconds: 3), (timer) async {
      await Get.find<LocationService>().updateMarkers();
      _updateMarkers();
    });
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    loadMapStyles();
    Get.find<LocationService>().startPositionStream();
  }

  Future<void> _updateMarkers() async {
    setState(() {
      _markers = Get.find<LocationService>().markers;
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
      checkLocationAccess();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Get.find<LocationService>().getCurrentLocation() == null
            ? BasicLoadingPage()
            : Stack(children: [
                GoogleMap(
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
                    if (Theme.of(context).brightness == Brightness.light) {
                      mapController.setMapStyle(_lightMapStyle);
                    } else {
                      mapController.setMapStyle(_darkMapStyle);
                    }
                    _controller.complete(mapController);
                  },
                  myLocationButtonEnabled: true,
                  myLocationEnabled: true,
                  padding: EdgeInsets.only(bottom: 100, left: 0, top: 40),
                  mapType: _mapType,
                  markers: _markers.values.toSet(),
                ),
                Platform.isIOS
                    ? Positioned(
                        top: 50.0,
                        right: 10.0,
                        child: FloatingActionButton(
                            onPressed: () {
                              setState(() {
                                _mapType = getNextMap(_mapType);
                              });
                            },
                            child: Icon(
                              Icons.map_rounded,
                              color: Colors.grey[700],
                            ),
                            backgroundColor: Colors.grey[50]),
                      )
                    : Positioned(
                        top: 100.0,
                        right: 12.0,
                        child: SizedBox(
                          height: 38,
                          width: 38,
                          child: FloatingActionButton(
                            onPressed: () {
                              setState(() {
                                _mapType = getNextMap(_mapType);
                              });
                            },
                            child: Icon(
                              Icons.map_rounded,
                              color: Colors.grey[700],
                            ),
                            backgroundColor: Colors.grey[50],
                            elevation: 2.0,
                            shape: RoundedRectangleBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(0)),
                            ),
                          ),
                        )),
                NavButtons(),
              ]));
  }

  @override
  void dispose() {
    _markersTimer.cancel();
    _iconsTimer.cancel();
    _internetCheckerBanner.dispose();
    WidgetsBinding.instance.removeObserver(this);
    Get.find<LocationService>().pausePositionStream();
    super.dispose();
  }
}
