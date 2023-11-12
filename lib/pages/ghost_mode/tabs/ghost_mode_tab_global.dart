import 'package:flutter/material.dart';

class GhostModeTabGlobal extends StatefulWidget {
  const GhostModeTabGlobal({Key? key}) : super(key: key);

  @override
  State<GhostModeTabGlobal> createState() => _GhostModeTabGlobalState();
}

class _GhostModeTabGlobalState extends State<GhostModeTabGlobal> {
  int locationPrecisionOption = 0;
  int otherOption = 0;

  @override
  Widget build(BuildContext context) {
    return Container(
        color: Theme.of(context).canvasColor,
        child: Stack(
          children: [
            Column(
              children: [
                Divider(
                  color: Theme.of(context).canvasColor,
                  height: 20.0,
                ),
                Text('Location precision visibility'),
                Row(
                  children: [
                    Radio<int>(
                      value: 1,
                      groupValue: locationPrecisionOption,
                      onChanged: (value) {
                        setState(() {
                          locationPrecisionOption = value!;
                        });
                      },
                    ),
                    Text('Precise'),
                  ],
                ),
                Row(
                  children: [
                    Radio<int>(
                      value: 2,
                      groupValue: locationPrecisionOption,
                      onChanged: (value) {
                        setState(() {
                          locationPrecisionOption = value!;
                        });
                      },
                    ),
                    Text('City district'),
                  ],
                ),
                Row(
                  children: [
                    Radio<int>(
                      value: 3,
                      groupValue: locationPrecisionOption,
                      onChanged: (value) {
                        setState(() {
                          locationPrecisionOption = value!;
                        });
                      },
                    ),
                    Text('City'),
                  ],
                ),
                Row(
                  children: [
                    Radio<int>(
                      value: 4,
                      groupValue: locationPrecisionOption,
                      onChanged: (value) {
                        setState(() {
                          locationPrecisionOption = value!;
                        });
                      },
                    ),
                    Text('Hide my location'),
                  ],
                ),
                Divider(
                  color: Theme.of(context).colorScheme.onBackground,
                  height: 40.0,
                  indent: 20,
                  endIndent: 20,
                ),
                Text('Some other settings'),
                Row(
                  children: [
                    Radio<int>(
                      value: 1,
                      groupValue: otherOption,
                      onChanged: (value) {
                        setState(() {
                          otherOption = value!;
                        });
                      },
                    ),
                    Text('Option 1'),
                  ],
                ),
                Row(
                  children: [
                    Radio<int>(
                      value: 2,
                      groupValue: otherOption,
                      onChanged: (value) {
                        setState(() {
                          otherOption = value!;
                        });
                      },
                    ),
                    Text('Option 2'),
                  ],
                ),
                Row(
                  children: [
                    Radio<int>(
                      value: 3,
                      groupValue: otherOption,
                      onChanged: (value) {
                        setState(() {
                          otherOption = value!;
                        });
                      },
                    ),
                    Text('Option 3'),
                  ],
                ),
                Row(
                  children: [
                    Radio<int>(
                      value: 4,
                      groupValue: otherOption,
                      onChanged: (value) {
                        setState(() {
                          otherOption = value!;
                        });
                      },
                    ),
                    Text('Option 4'),
                  ],
                ),
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
                      onPressed: () {},
                      style: ElevatedButton.styleFrom(
                          backgroundColor:
                              Theme.of(context).colorScheme.primary),
                      child: Text(
                        'Save',
                        style: TextStyle(fontSize: 32),
                      ),
                    ),
                  ),
                ))
          ],
        ));
  }
}
