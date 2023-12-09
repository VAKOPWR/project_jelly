import 'dart:async';
import 'dart:convert';
// ignore: unused_import
import 'dart:developer';
import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:project_jelly/misc/geocoding.dart';
import 'package:project_jelly/controller/theme_controller.dart';
import 'package:project_jelly/pages/helper/loading.dart';
import 'package:project_jelly/service/map_service.dart';
import 'package:project_jelly/service/snackbar_service.dart';
import 'package:project_jelly/service/visibility_service.dart';
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
  late Timer _stateTimer;
  late Timer _markersTimer;
  late Timer _debounce;
  MapType _mapType = MapType.normal;
  String _locationName = "The Earth";
  Map<MarkerId, Marker> staticMarkers = <MarkerId, Marker>{};
  ThemeModeOption prevThemeMode = ThemeModeOption.Automatic;
  String prevMapStyle = '';

  final box = GetStorage();

  @override
  void initState() {
    Get.find<SnackbarService>().checkLocationAccess();
    createMarkersFromJSON();
    _markersTimer = Timer.periodic(Duration(seconds: 3), (timer) async {
      await Get.find<MapService>().fetchFriendsData();
      await Get.find<MapService>().updateMarkers();
    });
    _stateTimer = Timer.periodic(Duration(milliseconds: 1), (timer) async {
      setState(() {});
    });
    _debounce = Timer(Duration(seconds: 1), () {});
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    Get.find<MapService>().startPositionStream();
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

  // @override
  // void didChangePlatformBrightness() {
  //   super.didChangePlatformBrightness();
  //   Brightness brightness =
  //       View.of(context).platformDispatcher.platformBrightness;
  //   if (brightness == Brightness.light) {
  //     _mapController.future.then(
  //         (value) => value.setMapStyle(GetStorage().read('lightMapStyle')));
  //   } else {
  //     _mapController.future.then(
  //         (value) => value.setMapStyle(GetStorage().read('darkMapStyle')));
  //   }
  // }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      Get.find<SnackbarService>().checkLocationAccess();
      Get.find<MapService>().updateMarkers();
      Get.find<MapService>().loadImageProviders();
      setState(() {});
    }
  }

  void hideBottomSheet(CameraPosition) {
    setState(() {
      if (Get.find<VisibilityService>().isInfoSheetVisible) {
        Get.find<VisibilityService>().isInfoSheetVisible = false;
      }
      if (Get.find<VisibilityService>().isBottomSheetOpen) {
        Navigator.of(context).pop();
        Get.find<VisibilityService>().isBottomSheetOpen = false;
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
    return GetBuilder<ThemeController>(
      builder: (themeController) {
        String mapStyle;
        prevThemeMode = themeController.themeModeOption;
        switch (themeController.themeModeOption) {
          case ThemeModeOption.Light:
            mapStyle = GetStorage().read('lightMapStyle');
            break;
          case ThemeModeOption.Dark:
            mapStyle = GetStorage().read('darkMapStyle');
            break;
          case ThemeModeOption.Custom:
            if (themeController.mapModeOption == MapModeOption.Light) {
              mapStyle = GetStorage().read('lightMapStyle');
            } else {
              mapStyle = GetStorage().read('darkMapStyle');
            }
            break;
          case ThemeModeOption.Automatic:
            if (Theme.of(context).brightness == Brightness.light) {
              mapStyle = GetStorage().read('lightMapStyle');
            } else {
              mapStyle = GetStorage().read('darkMapStyle');
            }
            break;
        }
        if (prevMapStyle != mapStyle) {
          prevMapStyle = mapStyle;
          _mapController.future.then((value) => value.setMapStyle(mapStyle));
        }
        return Scaffold(
            key: _scaffoldKey,
            body: Get.find<MapService>().getCurrentLocation() == null
                ? BasicLoadingPage()
                : Stack(children: [
                    GoogleMap(
                        compassEnabled: false,
                        rotateGesturesEnabled: false,
                        tiltGesturesEnabled: false,
                        onTap: hideBottomSheet,
                        initialCameraPosition: CameraPosition(
                          target: LatLng(
                            Get.find<MapService>()
                                .getCurrentLocation()!
                                .latitude,
                            Get.find<MapService>()
                                .getCurrentLocation()!
                                .longitude,
                          ),
                          zoom: 13,
                        ),
                        onMapCreated: (mapController) {
                          mapController.setMapStyle(mapStyle);
                          _mapController.complete(mapController);
                        },
                        myLocationButtonEnabled: true,
                        myLocationEnabled: true,
                        padding: EdgeInsets.only(bottom: 100, left: 0, top: 40),
                        mapType: _mapType,
                        markers: Set<Marker>.from(
                                Get.find<MapService>().markers.values.toSet())
                            .union(staticMarkers.values.toSet()),
                        onCameraMove: _onCameraMove),
                    AnimatedContainer(
                        duration: Duration(milliseconds: 300),
                        height: Get.find<VisibilityService>().isInfoSheetVisible
                            ? MediaQuery.of(context).size.height * 0.78
                            : 0,
                        width: MediaQuery.of(context).size.width * 0.9,
                        margin: EdgeInsets.fromLTRB(
                            MediaQuery.of(context).size.width * 0.05, 0, 0, 0),
                        child: Get.find<VisibilityService>()
                                    .highlightedMarker !=
                                null
                            ? MarkerInfoBox(
                                deleteStaticMarker: deleteStaticMarker,
                                isStaticMarker: Get.find<VisibilityService>()
                                        .highlightedMarkerType !=
                                    null,
                                id: Get.find<VisibilityService>()
                                    .highlightedMarker!,
                                markerType: Get.find<VisibilityService>()
                                    .highlightedMarkerType,
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
                                backgroundColor: Colors.white.withOpacity(0.8),
                                elevation: 2.0,
                                shape: RoundedRectangleBorder(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(0)),
                                ),
                              ),
                            )),
                    NavButtons(moveMapToPosition: moveMapToPosition),
                    Platform.isIOS
                        ? Positioned(
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
                          )
                        : Positioned(
                            top: 150.0,
                            right: 12.0,
                            child: SizedBox(
                              height: 38,
                              width: 38,
                              child: FloatingActionButton(
                                heroTag: 'staticIconButton',
                                onPressed: () {
                                  _showMarkerListBottomSheet();
                                },
                                child: Icon(
                                  Icons.place_rounded,
                                  color: Colors.grey[700],
                                ),
                                backgroundColor: Colors.white.withOpacity(0.8),
                                elevation: 2.0,
                                shape: RoundedRectangleBorder(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(0)),
                                ),
                              ),
                            )),
                    Positioned(
                      top: 60.0,
                      left: 25.0,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Text(
                            _locationName,
                            style: themeController.mapModeOption ==
                                    MapModeOption.Automatic
                                ? TextStyle(
                                    fontSize: 32.0,
                                    fontWeight: FontWeight.normal,
                                    decoration: TextDecoration.underline,
                                  )
                                : TextStyle(
                                    color: themeController.mapModeOption ==
                                            MapModeOption.Light
                                        ? Colors.black
                                        : Colors.white,
                                    fontSize: 32.0,
                                    fontWeight: FontWeight.normal,
                                    decoration: TextDecoration.underline,
                                  ),
                          ),
                        ],
                      ),
                    )
                  ]));
      },
    );
  }

  void _showMarkerListBottomSheet() {
    if (!Get.find<VisibilityService>().isBottomSheetOpen) {
      Get.find<VisibilityService>().isInfoSheetVisible = false;
      Get.find<VisibilityService>().isBottomSheetOpen = true;
      _scaffoldKey.currentState?.showBottomSheet(
        (BuildContext context) {
          return Stack(
            children: [
              Container(
                width: MediaQuery.of(context).size.width,
                height: 330.0,
                padding: EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            "Mark your places",
                            style: GoogleFonts.roboto(
                                color:
                                    Theme.of(context).colorScheme.onBackground,
                                fontSize: 28,
                                fontWeight: FontWeight.bold),
                          ),
                          ElevatedButton(
                            onPressed: () {
                              Navigator.of(context).pop();
                              Get.find<VisibilityService>().isBottomSheetOpen =
                                  false;
                            },
                            style: ElevatedButton.styleFrom(
                              shape: CircleBorder(),
                            ),
                            child: Icon(
                              Icons.close,
                              color: Theme.of(context).colorScheme.background,
                            ),
                          ),
                        ]),
                    SizedBox(height: 16.0),
                    Wrap(
                      spacing: 16.0,
                      runSpacing: 16.0,
                      children: [
                        _buildMarkerOption(
                            "Home",
                            Get.find<MapService>()
                                .staticImages[MarkerId("Home")]!),
                        _buildMarkerOption(
                            "Work",
                            Get.find<MapService>()
                                .staticImages[MarkerId("Work")]!),
                        _buildMarkerOption(
                            "School",
                            Get.find<MapService>()
                                .staticImages[MarkerId("School")]!),
                        _buildMarkerOption(
                            "Shop",
                            Get.find<MapService>()
                                .staticImages[MarkerId("Shop")]!),
                        _buildMarkerOption(
                            "Gym",
                            Get.find<MapService>()
                                .staticImages[MarkerId("Gym")]!),
                        _buildMarkerOption(
                            "Favorite",
                            Get.find<MapService>()
                                .staticImages[MarkerId("Favorite")]!),
                      ],
                    ),
                    SizedBox(height: 16.0),
                  ],
                ),
              ),
            ],
          );
        },
      );
    }
  }

  Widget _buildMarkerOption(String markerName, Uint8List iconData) {
    return GestureDetector(
      onTap: () {
        if (Get.find<MapService>().staticMarkerTypeId.containsKey(markerName) &&
            Get.find<MapService>().staticMarkerTypeId[markerName]!.length >=
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
          Get.find<VisibilityService>().isBottomSheetOpen = false;
        }
      },
      child: Container(
        width: 100.0,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 70.0,
              height: 70.0,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Theme.of(context).colorScheme.outline.withOpacity(0.3),
              ),
              child: Center(
                child: Image.memory(
                  iconData,
                  width: 65.0,
                  height: 65.0,
                ),
              ),
            ),
            SizedBox(height: 8.0),
            Text(markerName),
          ],
        ),
      ),
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
    if (Get.find<MapService>().staticMarkerTypeId.containsKey(markerType)) {
      while (Get.find<MapService>()
          .staticMarkerTypeId[markerType]!
          .contains(newMarkerName)) {
        newMarkerName = "${markerType} ${i.toString()}";
        i++;
      }
    }
    markerId = MarkerId(newMarkerName);
    Marker marker = createMarker(markerId, center, markerType);
    setState(() {
      addStaticMarker(marker, markerType, newMarkerName);
    });
  }

  Future<void> createMarkersFromJSON() async {
    String? markerData = box.read('staticMarkers');
    if (markerData != null) {
      List<Map<String, dynamic>> data =
          List<Map<String, dynamic>>.from(json.decode(markerData));
      for (Map<String, dynamic> marker in data) {
        String markerType = marker["id"].toString().split(' ')[0];
        MarkerId markerId = MarkerId(marker["id"].toString());
        LatLng markerPosition = LatLng(marker["latitude"], marker["longitude"]);
        Marker newMarker = createMarker(markerId, markerPosition, markerType);
        staticMarkers[markerId] = newMarker;
        Get.find<MapService>().addStaticPoint(newMarker);
        Get.find<MapService>()
            .addStaticMarkerTypeId(markerType, marker["id"].toString());
      }
    }
  }

  Marker createMarker(
      MarkerId markerId, LatLng markerPosition, String markerType) {
    return Marker(
      markerId: markerId,
      position: markerPosition,
      draggable: true,
      icon: Get.find<MapService>().staticMarkerIcons[MarkerId(markerType)]!,
      onTap: () {
        setState(() {
          Get.find<VisibilityService>().isInfoSheetVisible = true;
          if (Get.find<VisibilityService>().isBottomSheetOpen) {
            Navigator.of(context).pop();
            Get.find<VisibilityService>().isBottomSheetOpen = false;
          }
          Get.find<VisibilityService>().highlightedMarker = markerId;
          Get.find<VisibilityService>().highlightedMarkerType = markerType;
        });
      },
      onDragEnd: (LatLng newPosition) {
        staticMarkers.remove(markerId);
        Get.find<MapService>().deleteStaticPoint(markerId);
        Marker newMarker = createMarker(markerId, newPosition, markerType);
        staticMarkers[markerId] = newMarker;
        Get.find<MapService>().addStaticPoint(newMarker);
        Get.find<MapService>().writeStaticMarkersData(staticMarkers);
      },
    );
  }

  void addStaticMarker(Marker marker, String markerType, String newMarkerName) {
    staticMarkers[marker.markerId] = marker;
    Get.find<MapService>().addStaticPoint(marker);
    Get.find<MapService>().writeStaticMarkersData(staticMarkers);
    Get.find<MapService>().addStaticMarkerTypeId(markerType, newMarkerName);
  }

  void deleteStaticMarker(String markerType, MarkerId markerId) {
    if (staticMarkers.containsKey(markerId)) {
      Marker markerToDelete = staticMarkers[markerId]!;
      staticMarkers.remove(markerId);
      Get.find<VisibilityService>().isInfoSheetVisible = false;
      if (Get.find<MapService>().staticMarkerTypeId.containsKey(markerType)) {
        Get.find<MapService>()
            .staticMarkerTypeId[markerType]!
            .remove(markerToDelete.markerId.value);
      }
    }
    Get.find<MapService>().deleteStaticPoint(markerId);
    Get.find<MapService>().writeStaticMarkersData(staticMarkers);
  }

  Future<void> moveMapToPosition(LatLng newCameraPosition) async {
    GoogleMapController controller = await _mapController.future;
    controller.animateCamera(
      CameraUpdate.newLatLngZoom(
        newCameraPosition,
        15,
      ),
    );
  }

  @override
  void dispose() {
    _debounce.cancel();
    _markersTimer.cancel();
    _stateTimer.cancel();
    Get.find<MapService>().pausePositionStream();
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }
}
