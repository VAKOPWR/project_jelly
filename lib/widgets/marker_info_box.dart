// ignore: unused_import
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:project_jelly/pages/chat/messages/chat_messages_friend.dart';
import 'package:project_jelly/service/map_service.dart';

class MarkerInfoBox extends StatefulWidget {
  final Function deleteStaticMarker;
  final bool isStaticMarker;
  final MarkerId id;
  final String? markerType;
  const MarkerInfoBox(
      {super.key,
      required this.deleteStaticMarker,
      required this.isStaticMarker,
      required this.id,
      this.markerType});

  @override
  State<MarkerInfoBox> createState() => _MarkerInfoBoxState();
}

class _MarkerInfoBoxState extends State<MarkerInfoBox> {
  @override
  Widget build(BuildContext context) {
    return DraggableScrollableSheet(
      expand: false,
      initialChildSize: 0.35,
      minChildSize: 0.1,
      maxChildSize: 1,
      builder: (BuildContext context, ScrollController scrollController) {
        return SingleChildScrollView(
            physics: NeverScrollableScrollPhysics(),
            child: widget.isStaticMarker
                ? _buildStaticDescription()
                : _buildDynamicDescription());
      },
    );
  }

  Widget _buildDynamicDescription() {
    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.background.withOpacity(0.95),
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
                    backgroundColor:
                        Theme.of(context).colorScheme.background.withOpacity(0),
                    radius: 50,
                    backgroundImage:
                        Get.find<MapService>().imageProviders[widget.id],
                  ),
                ],
              ),
              Column(
                children: [
                  _buildSplitText(
                    Get.find<MapService>().friendsData[widget.id]?.name ?? '',
                  ),
                  Divider(
                    height: 5,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.speed, color: Colors.orange),
                      Text(
                          (Get.find<MapService>()
                                          .friendsData[widget.id]
                                          ?.movementSpeed
                                          .toString() ??
                                      '0')
                                  .padLeft(5, ' ') +
                              ' km/h',
                          style: GoogleFonts.montserrat(
                              color:
                                  Theme.of(context).colorScheme.onBackground)),
                    ],
                  ),
                  SizedBox(width: 10),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      calculateBatteryIcon(Get.find<MapService>()
                              .friendsData[widget.id]
                              ?.batteryPercentage ??
                          50),
                      Text(
                          (Get.find<MapService>()
                                          .friendsData[widget.id]
                                          ?.batteryPercentage
                                          .toString() ??
                                      '0')
                                  .padLeft(3, ' ') +
                              '%',
                          style: GoogleFonts.montserrat(
                              color:
                                  Theme.of(context).colorScheme.onBackground)),
                    ],
                  ),
                ],
              ),
              TextButton(
                onPressed: () {
                  Get.to(() => ChatMessagesFriend(
                      chatId: Get.find<MapService>()
                          .getChatKeyByFriendId(int.parse(widget.id.value))));
                },
                style: TextButton.styleFrom(
                  padding:
                      EdgeInsets.symmetric(horizontal: 10.0, vertical: 10.0),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(90.0),
                  ),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    Icon(
                      Icons.telegram_rounded,
                      size: 50.0,
                      color: Theme.of(context).colorScheme.primary,
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSplitText(String text) {
    final maxCharacters = 11;
    final maxWords = 2;

    if (text.length > maxCharacters) {
      List<String> words = text.split(' ');
      if (words.length >= maxWords) {
        int halfLength = (words.length / 2).ceil();
        String firstHalf = words.take(halfLength).join(' ');
        String secondHalf = words.skip(halfLength).join(' ');
        return Column(
          children: [
            Text(
              firstHalf,
              style: GoogleFonts.bebasNeue(
                color: Theme.of(context).colorScheme.onBackground,
                fontSize: 30,
                fontWeight: FontWeight.bold,
                letterSpacing: 2.0,
              ),
            ),
            Text(
              secondHalf,
              style: GoogleFonts.bebasNeue(
                color: Theme.of(context).colorScheme.onBackground,
                fontSize: 30,
                fontWeight: FontWeight.bold,
                letterSpacing: 2.0,
              ),
            ),
          ],
        );
      }
    }

    if (text.length > maxCharacters) {
      text = text.substring(0, maxCharacters - 3) + '...';
    }

    return Text(
      text,
      style: GoogleFonts.bebasNeue(
        color: Theme.of(context).colorScheme.onBackground,
        fontSize: 30,
        fontWeight: FontWeight.bold,
        letterSpacing: 2.0,
      ),
    );
  }

  Widget _buildStaticDescription() {
    return Container(
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.background.withOpacity(0.95),
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
                          Image.memory(
                            Get.find<MapService>().staticImages[
                                MarkerId(widget.markerType ?? '')]!,
                            width: 100,
                            height: 100,
                          ),
                        ],
                      ),
                      Column(
                        children: [
                          Text(
                            widget.id.value,
                            style: GoogleFonts.bebasNeue(
                              color: Theme.of(context).colorScheme.onBackground,
                              fontSize: 30,
                              fontWeight: FontWeight.bold,
                              letterSpacing: 2.0,
                            ),
                          ),
                        ],
                      ),
                      Column(
                        children: [
                          TextButton(
                            onPressed: () {
                              widget.deleteStaticMarker(
                                  widget.markerType!, widget.id);
                            },
                            style: TextButton.styleFrom(
                              backgroundColor: Color.fromRGBO(248, 70, 85, 1),
                              padding: EdgeInsets.symmetric(
                                  horizontal: 10.0, vertical: 10.0),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10.0),
                              ),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: <Widget>[
                                Icon(
                                  Icons.delete_outline_rounded,
                                  size: 50.0,
                                  color: Theme.of(context)
                                      .colorScheme
                                      .onBackground
                                      .withOpacity(0.9),
                                ),
                              ],
                            ),
                          )
                        ],
                      )
                    ]))));
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
