import 'package:flutter/material.dart';

class GhostModeTabEveryone extends StatefulWidget {
  const GhostModeTabEveryone({Key? key}) : super(key: key);

  @override
  State<GhostModeTabEveryone> createState() => _GhostModeTabEveryoneState();
}

class _GhostModeTabEveryoneState extends State<GhostModeTabEveryone> {

  int locationPrecisionOption = 0;
  int otherOption = 0;

  @override
  Widget build(BuildContext context){
    return Container(
      color: Colors.white,
      child: Stack(
        children: [
          Column(
            children: [
              Divider(
                color: Colors.black,
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
                color: Colors.black,
                height: 20.0,
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
            bottom: 0,
            left: 0,
            right: 0,
            child: Container(
              padding: EdgeInsets.all(10.0),
              child: ElevatedButton(
                onPressed: (){

                },
                style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green[600]
                ),
                child: Text('Confirm'),
              ),
            ),
          )
        ],
      )

    );
  }


}