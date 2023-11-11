// ignore: unused_import
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:project_jelly/service/location_service.dart';

class PersonInfoBox extends StatefulWidget {
  final MarkerId id;
  const PersonInfoBox({super.key, required this.id});

  @override
  State<PersonInfoBox> createState() => _PersonInfoBoxState();
}

class _PersonInfoBoxState extends State<PersonInfoBox> {
  @override
  Widget build(BuildContext context) {
    return DraggableScrollableSheet(
      expand: false,
      initialChildSize: 0.21,
      minChildSize: 0.1,
      maxChildSize: 1,
      builder: (BuildContext context, ScrollController scrollController) {
        return SingleChildScrollView(
            physics: NeverScrollableScrollPhysics(),
            child: Container(
              decoration: BoxDecoration(
                color: Theme.of(context).primaryColor,
                borderRadius: BorderRadius.all(
                  Radius.circular(10.0),
                ),
                border: Border.all(
                  color: Theme.of(context).colorScheme.primary,
                  width: 3.0,
                ),
              ),
              child: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Column(
                        children: [
                          SizedBox(
                            height: 5,
                          ),
                          CircleAvatar(
                            backgroundColor: Theme.of(context).primaryColor,
                            radius: 50,
                            backgroundImage: Get.find<LocationService>()
                                .imageProviders[widget.id],
                          ),
                        ],
                      ),
                      Column(
                        children: [
                          Text(
                            Get.find<LocationService>()
                                    .friendsData[widget.id]
                                    ?.name ??
                                '',
                            style: GoogleFonts.bebasNeue(
                              color: Theme.of(context).colorScheme.onBackground,
                              fontSize: 30,
                              fontWeight: FontWeight.bold,
                              letterSpacing: 2.0,
                            ),
                          ),
                          Divider(
                            height: 5,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(Icons.speed, color: Colors.orange),
                              Text(
                                  (Get.find<LocationService>()
                                                  .friendsData[widget.id]
                                                  ?.movementSpeed
                                                  .toString() ??
                                              '0')
                                          .padLeft(5, ' ') +
                                      ' km/h',
                                  style: GoogleFonts.montserrat(
                                      color: Theme.of(context)
                                          .colorScheme
                                          .onBackground)),
                            ],
                          ),
                          SizedBox(width: 10),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              calculateBatteryIcon(Get.find<LocationService>()
                                      .friendsData[widget.id]
                                      ?.batteryPercentage ??
                                  50),
                              Text(
                                  (Get.find<LocationService>()
                                                  .friendsData[widget.id]
                                                  ?.batteryPercentage
                                                  .toString() ??
                                              '0')
                                          .padLeft(3, ' ') +
                                      '%',
                                  style: GoogleFonts.montserrat(
                                      color: Theme.of(context)
                                          .colorScheme
                                          .onBackground)),
                            ],
                          ),
                        ],
                      ),
                      TextButton(
                        onPressed: () {
                          // TODO: Open chat
                        },
                        style: TextButton.styleFrom(
                          padding: EdgeInsets.symmetric(
                              horizontal: 10.0, vertical: 10.0),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(90.0),
                          ),
                          // backgroundColor: Theme.of(context)
                          //     .colorScheme
                          //     .primary, // Set the background color
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: <Widget>[
                            Icon(
                              Icons.telegram_rounded,
                              size: 50.0,
                              color: Theme.of(context)
                                  .colorScheme
                                  .primary, // Set the icon color
                            ),
                          ],
                        ),
                      )
                    ],
                  ),
                ),
              ),
            ));
      },
    );
  }

  Icon calculateBatteryIcon(int battery) {
    if (battery <= 95 && battery > 80) {
      return Icon(
        Icons.battery_6_bar_rounded,
        color: Colors.green,
      );
    } else if (battery <= 80 && battery > 60) {
      return Icon(Icons.battery_5_bar_rounded, color: Colors.green);
    } else if (battery <= 60 && battery > 49) {
      return Icon(Icons.battery_4_bar_rounded, color: Colors.green);
    } else if (battery <= 49 && battery > 20) {
      return Icon(
        Icons.battery_3_bar_rounded,
        color: Colors.amber,
      );
    } else if (battery <= 20 && battery > 10) {
      return Icon(
        Icons.battery_2_bar_rounded,
        color: Colors.red,
      );
    } else if (battery <= 10 && battery > 5) {
      return Icon(
        Icons.battery_1_bar_rounded,
        color: Colors.red,
      );
    } else if (battery <= 5) {
      return Icon(
        Icons.battery_0_bar_rounded,
        color: Colors.red,
      );
    } else {
      return Icon(Icons.battery_full_rounded, color: Colors.green);
    }
  }
}
