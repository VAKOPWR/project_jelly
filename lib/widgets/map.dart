import 'dart:async';
// ignore: unused_import
import 'dart:developer';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:project_jelly/misc/geocoding.dart';
import 'package:project_jelly/pages/helper/loading.dart';
import 'package:project_jelly/service/location_service.dart';
import 'package:project_jelly/service/snackbar_service.dart';
import 'package:project_jelly/widgets/nav_buttons.dart';
import 'package:project_jelly/widgets/person_info_box.dart';

class MapWidget extends StatefulWidget {
  const MapWidget({super.key});

  @override
  State<MapWidget> createState() => _MapWidgetState();
}

class _MapWidgetState extends State<MapWidget> with WidgetsBindingObserver {
  final Completer<GoogleMapController> _mapController = Completer();
  late Timer _markersTimer;
  bool _isBottomSheetVisible = false;
  Map<MarkerId, Marker> _markers = <MarkerId, Marker>{};
  MapType _mapType = MapType.normal;
  MarkerId? _highlightedMarker = null;
  String _locationName = "The Earth";
  late Timer _debounce;

  @override
  void initState() {
    Get.find<SnackbarService>().checkLocationAccess();
    _updateMarkers();
    _markersTimer = Timer.periodic(Duration(seconds: 3), (timer) async {
      await Get.find<LocationService>().fetchFriendsData();
      await Get.find<LocationService>().updateMarkers();
      _updateMarkers();
    });
    _debounce = Timer(Duration(seconds: 1), () {});
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    Get.find<LocationService>().startPositionStream();
  }

  Future<void> _updateMarkers() async {
    setState(() {
      for (var markerEntry in Get.find<LocationService>().markers.entries) {
        _markers[markerEntry.key] = Marker(
            markerId: markerEntry.value.markerId,
            position: markerEntry.value.position,
            icon: markerEntry.value.icon,
            onTap: () {
              setState(() {
                _isBottomSheetVisible = true;
                _highlightedMarker = markerEntry.value.markerId;
              });
            });
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

  @override
  void didChangePlatformBrightness() {
    super.didChangePlatformBrightness();
    Brightness brightness =
        View.of(context).platformDispatcher.platformBrightness;
    if (brightness == Brightness.light) {
      _mapController.future.then(
          (value) => value.setMapStyle(GetStorage().read('lightMapStyle')));
    } else {
      _mapController.future.then(
          (value) => value.setMapStyle(GetStorage().read('darkMapStyle')));
    }
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      Get.find<SnackbarService>().checkLocationAccess();
      Get.find<LocationService>().updateMarkers();
      Get.find<LocationService>().loadImageProviders();
      _updateMarkers();
    }
  }

  void hideBottomSheet(CameraPosition) {
    setState(() {
      if (_isBottomSheetVisible == true) {
        _isBottomSheetVisible = false;
      }
    });
  }

  void _onCameraMove(CameraPosition position) {
    if (_debounce.isActive) {
      _debounce.cancel();
    }
    _debounce = Timer(const Duration(milliseconds: 500), () async {
      GoogleMapController controller = await _mapController.future;
      double zoomLevel = await controller.getZoomLevel();
      if (zoomLevel <= 6) {
        setState(() {
          _locationName = "The Earth";
        });
      } else {
        String newCityName =
            await getCityNameFromCoordinates(position.target, zoomLevel);
        setState(() {
          _locationName = newCityName;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Get.find<LocationService>().getCurrentLocation() == null
            ? BasicLoadingPage()
            : Stack(children: [
                GoogleMap(
                    compassEnabled: false,
                    rotateGesturesEnabled: false,
                    tiltGesturesEnabled: false,
                    onTap: hideBottomSheet,
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
                        mapController
                            .setMapStyle(GetStorage().read('lightMapStyle'));
                      } else {
                        mapController
                            .setMapStyle(GetStorage().read('darkMapStyle'));
                      }
                      _mapController.complete(mapController);
                    },
                    myLocationButtonEnabled: true,
                    myLocationEnabled: true,
                    padding: EdgeInsets.only(bottom: 100, left: 0, top: 40),
                    mapType: _mapType,
                    markers: _markers.values.toSet(),
                    onCameraMove: _onCameraMove),
                AnimatedContainer(
                    duration: Duration(milliseconds: 300), // Animation duration
                    height: _isBottomSheetVisible
                        ? MediaQuery.of(context).size.height * 0.78
                        : 0,
                    width: MediaQuery.of(context).size.width * 0.9,
                    margin: EdgeInsets.fromLTRB(
                        MediaQuery.of(context).size.width * 0.05, 0, 0, 0),
                    child: _highlightedMarker != null
                        ? PersonInfoBox(id: _highlightedMarker!)
                        : null),
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
                            backgroundColor: Colors.white.withOpacity(0.95),
                            elevation: 2.0,
                            shape: RoundedRectangleBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(0)),
                            ),
                          ),
                        )),
                NavButtons(),
                Positioned(
                  top: 60.0,
                  left: 25.0,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(
                        _locationName,
                        style: TextStyle(
                          fontSize: 32.0,
                          fontWeight: FontWeight.normal,
                          decoration: TextDecoration.underline,
                        ),
                      ),
                    ],
                  ),
                )
              ]));
  }

  @override
  void dispose() {
    _debounce.cancel();
    _markersTimer.cancel();
    Get.find<LocationService>().pausePositionStream();
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }
}
