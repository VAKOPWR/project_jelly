import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:project_jelly/misc/stealth_choice.dart';
import 'package:project_jelly/service/request_service.dart';

class GhostModeTabGlobal extends StatefulWidget {
  const GhostModeTabGlobal({Key? key}) : super(key: key);

  @override
  State<GhostModeTabGlobal> createState() => _GhostModeTabGlobalState();
}

class _GhostModeTabGlobalState extends State<GhostModeTabGlobal> {
  int locationPrecisionOption = 1;
  int previousLocationPrecisionOption = 1;
  final box = GetStorage();

  @override
  void initState() {
    super.initState();
    int? isSharingLocation = box.read('isSharingLocation');
    if (isSharingLocation != null) {
      locationPrecisionOption = isSharingLocation;
      previousLocationPrecisionOption = locationPrecisionOption;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        color: Theme.of(context).colorScheme.background,
        child: Stack(
          children: [
            Column(
              children: [
                Divider(
                  color: Theme.of(context).colorScheme.background,
                  height: 20.0,
                ),
                Text('Location Precision Visibility',
                    style: TextStyle(fontSize: 20)),
                SizedBox(
                  height: 8,
                ),
                RadioListTile(
                  title: Text('Precise'),
                  value: 1,
                  groupValue: locationPrecisionOption,
                  onChanged: (value) {
                    if (value != null) {
                      setState(() {
                        locationPrecisionOption = value;
                      });
                    }
                  },
                ),
                RadioListTile(
                  title: Text('Hidden'),
                  value: 2,
                  groupValue: locationPrecisionOption,
                  onChanged: (value) {
                    if (value != null) {
                      setState(() {
                        locationPrecisionOption = value;
                      });
                    }
                  },
                ),
                // Row(
                //   children: [
                //     Radio<int>(
                //       value: 1,
                //       groupValue: locationPrecisionOption,
                //       onChanged: (value) {
                //         setState(() {
                //           locationPrecisionOption = value!;
                //         });
                //       },
                //     ),
                //     Text('Precise'),
                //   ],
                // ),
                // Row(
                //   children: [
                //     Radio<int>(
                //       value: 2,
                //       groupValue: locationPrecisionOption,
                //       onChanged: (value) {
                //         setState(() {
                //           locationPrecisionOption = value!;
                //         });
                //       },
                //     ),
                //     Text('Hide my location'),
                //   ],
                // ),
              ],
            ),
            Positioned(
                bottom: 40,
                left: 0,
                right: 0,
                child: SizedBox(
                  height: 80,
                  child: Container(
                      padding: EdgeInsets.all(10.0),
                      child: ElevatedButton(
                        onPressed: () async {
                          if (locationPrecisionOption !=
                              previousLocationPrecisionOption) {
                            StealthChoice choice = locationPrecisionOption == 1
                                ? StealthChoice.PRECISE
                                : StealthChoice.HIDE;
                            bool success = await Get.find<RequestService>()
                                .updateStealthChoiceOnUserLevel(choice);
                            if (success) {
                              previousLocationPrecisionOption =
                                  locationPrecisionOption;
                              box.write(
                                  'isSharingLocation', locationPrecisionOption);
                              Get.snackbar("Congratulations!",
                                  "Your location setting has been updated successfully",
                                  icon: Icon(Icons.add_reaction,
                                      color: Colors.white, size: 35),
                                  snackPosition: SnackPosition.TOP,
                                  isDismissible: false,
                                  duration: Duration(seconds: 2),
                                  backgroundColor: Colors.green[400],
                                  margin: EdgeInsets.zero,
                                  snackStyle: SnackStyle.GROUNDED);
                            }
                          } else {
                            Get.snackbar("No Change",
                                "Your location setting is already set as desired",
                                icon: Icon(Icons.info_outline,
                                    color: Colors.white, size: 35),
                                snackPosition: SnackPosition.TOP,
                                isDismissible: true,
                                duration: Duration(seconds: 2),
                                backgroundColor: Colors.blue[400],
                                margin: EdgeInsets.zero,
                                snackStyle: SnackStyle.GROUNDED);
                          }
                        },
                        style: ElevatedButton.styleFrom(
                            backgroundColor:
                                Theme.of(context).colorScheme.primary),
                        child: Text(
                          'Save',
                          style: TextStyle(fontSize: 32),
                        ),
                      )),
                ))
          ],
        ));
  }
}
