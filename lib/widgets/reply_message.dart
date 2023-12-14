import 'package:flutter/material.dart';

class ReplyMessage extends StatelessWidget {
  const ReplyMessage({
    Key? key,
    required this.message,
    required this.time,
    this.imageUrl,
  });

  final String message;
  final String time;
  final String? imageUrl;

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.centerLeft,
      child: ConstrainedBox(
          constraints: BoxConstraints(
            maxWidth: MediaQuery.of(context).size.width * 0.7,
            minWidth: 80.0,
          ),
          child: Card(
            elevation: 1,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(8),
                topRight: Radius.circular(8),
                bottomRight: Radius.circular(8),
              ),
            ),
            color: Color.fromRGBO(30, 30, 30, 1),
            margin: EdgeInsets.symmetric(horizontal: 15, vertical: 5),
            child: imageUrl != null
                ? Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(20.0),
                          topRight: Radius.circular(20.0),
                          bottomLeft: Radius.circular(20.0),
                          bottomRight: Radius.circular(20.0),
                        ),
                        child: Container(
                          width: 250,
                          decoration: BoxDecoration(
                            border: Border(
                              top: BorderSide(
                                color: Color.fromRGBO(30, 30, 30, 1),
                                width: 2.0,
                              ),
                              left: BorderSide(
                                color: Color.fromRGBO(30, 30, 30, 1),
                                width: 2.0,
                              ),
                              right: BorderSide(
                                color: Color.fromRGBO(30, 30, 30, 1),
                                width: 2.0,
                              ),
                            ),
                          ),
                          child: Image.network(
                            imageUrl!,
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(
                          left: 10,
                          right: 30,
                          top: 5,
                        ),
                        child: Text(
                          message,
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.white,
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(
                          left: 10,
                          right: 10,
                          bottom: 5,
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            Text(
                              time,
                              style: TextStyle(
                                fontSize: 13,
                                color: Colors.grey[300],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  )
                : Stack(children: [
                    Padding(
                      padding: const EdgeInsets.only(
                        left: 10,
                        right: 30,
                        top: 5,
                        bottom: 22,
                      ),
                      child: Text(
                        message,
                        style: TextStyle(fontSize: 16, color: Colors.white),
                      ),
                    ),
                    Positioned(
                      bottom: 4,
                      right: 10,
                      child: Row(
                        children: [
                          Text(
                            time,
                            style: TextStyle(
                              fontSize: 13,
                              color: Colors.grey[300],
                            ),
                          ),
                        ],
                      ),
                    )
                  ]),
          )),
    );
  }
}
