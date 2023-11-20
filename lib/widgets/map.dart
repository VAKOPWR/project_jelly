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
import 'package:project_jelly/widgets/marker_info_box.dart';

class MapWidget extends StatefulWidget {
  const MapWidget({super.key});

  @override
  State<MapWidget> createState() => _MapWidgetState();
}

class _MapWidgetState extends State<MapWidget> with WidgetsBindingObserver {
  final Completer<GoogleMapController> _mapController = Completer();
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  late Timer _markersTimer;
  late Timer _debounce;
  Map<MarkerId, Marker> _markers = <MarkerId, Marker>{};
  MarkerId? _highlightedMarker = null;
  String? _highlightedMarkerType = null;
  MapType _mapType = MapType.normal;
  String _locationName = "The Earth";
  bool _isInfoSheetVisible = false;
  bool _isBottomSheetOpen = false;

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
                _isInfoSheetVisible = true;
                if (_isBottomSheetOpen) {
                  Navigator.of(context).pop();
                  _isBottomSheetOpen = false;
                }
                _highlightedMarker = markerEntry.value.markerId;
                _highlightedMarkerType = null;
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
      if (_isInfoSheetVisible) {
        _isInfoSheetVisible = false;
      }
      if (_isBottomSheetOpen) {
        Navigator.of(context).pop();
        _isBottomSheetOpen = false;
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
        key: _scaffoldKey,
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
                    height: _isInfoSheetVisible
                        ? MediaQuery.of(context).size.height * 0.78
                        : 0,
                    width: MediaQuery.of(context).size.width * 0.9,
                    margin: EdgeInsets.fromLTRB(
                        MediaQuery.of(context).size.width * 0.05, 0, 0, 0),
                    child: _highlightedMarker != null
                        ? MarkerInfoBox(
                            isStaticMarker: _highlightedMarkerType != null,
                            id: _highlightedMarker!,
                            markerType: _highlightedMarkerType,
                          )
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
                            heroTag: 'mapTypeButton',
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
                  top: 120.0,
                  right: 10.0,
                  child: FloatingActionButton(
                      heroTag: 'placeIconButton',
                      onPressed: () {
                        _showMarkerListBottomSheet();
                      },
                      child: Icon(
                        Icons.place_rounded,
                        color: Colors.grey[700],
                      ),
                      backgroundColor: Colors.grey[50]),
                ),
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

  void _showMarkerListBottomSheet() {
    if (!_isBottomSheetOpen) {
      _isInfoSheetVisible = false;
      _isBottomSheetOpen = true;
      _scaffoldKey.currentState?.showBottomSheet(
        (BuildContext context) {
          return Container(
            height: 500.0,
            padding: EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text("Marker List"),
                SizedBox(height: 16.0),
                _buildMarkerListItem("Home"),
                _buildMarkerListItem("Work"),
                _buildMarkerListItem("School"),
                _buildMarkerListItem("Shop"),
                _buildMarkerListItem("Gym"),
                SizedBox(height: 16.0),
                ElevatedButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                    _isBottomSheetOpen = false;
                  },
                  child: Text('Close'),
                ),
              ],
            ),
          );
        },
      );
    }
  }

  Widget _buildMarkerListItem(String markerName) {
    return ListTile(
      title: Text(markerName),
      onTap: () {
        if (Get.find<LocationService>()
                .staticMarkerTypeName
                .containsKey(markerName) &&
            Get.find<LocationService>()
                    .staticMarkerTypeName[markerName]!
                    .length >=
                5) {
          Get.dialog(
            AlertDialog(
              title: Text('Ooooops...'),
              content: Text("You can't add more than 5 ${markerName}s"),
              actions: <Widget>[
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: Text('OK'),
                ),
              ],
            ),
          );
        } else {
          _addStaticMarker(markerName);
          Navigator.of(context).pop();
          _isBottomSheetOpen = false;
        }
      },
    );
  }

  void _addStaticMarker(String markerType) async {
    GoogleMapController controller = await _mapController.future;
    LatLng center = await controller.getLatLng(ScreenCoordinate(
      x: MediaQuery.of(context).size.width ~/ 2,
      y: MediaQuery.of(context).size.height ~/ 2,
    ));
    MarkerId markerId = MarkerId(markerType);
    String newMarkerName = markerType;

    int i = 1;
    if (Get.find<LocationService>()
        .staticMarkerTypeName
        .containsKey(markerType)) {
      while (Get.find<LocationService>()
          .staticMarkerTypeName[markerType]!
          .contains(newMarkerName)) {
        newMarkerName = "${newMarkerName} ${i.toString()}";
      }
    }
    markerId = MarkerId(newMarkerName);
    Marker marker = Marker(
      markerId: markerId,
      position: center,
      draggable: true,
      icon: Get.find<LocationService>().staticMarkers[MarkerId(markerType)]!,
      onTap: () {
        setState(() {
          _isInfoSheetVisible = true;
          if (_isBottomSheetOpen) {
            Navigator.of(context).pop();
            _isBottomSheetOpen = false;
          }
          _highlightedMarker = markerId;
          _highlightedMarkerType = markerType;
        });
      },
      onDragEnd: (LatLng newPosition) {
        // TODO: update the marker's position in the data structure
      },
    );
    setState(() {
      _markers[marker.markerId] = marker;
      if (Get.find<LocationService>()
          .staticMarkerTypeName
          .containsKey(markerType)) {
        Get.find<LocationService>()
            .staticMarkerTypeName[markerType]!
            .add(newMarkerName);
      } else {
        Get.find<LocationService>().staticMarkerTypeName[markerType] = {
          newMarkerName
        };
      }
    });
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
