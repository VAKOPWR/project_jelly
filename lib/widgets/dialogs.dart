import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class IOSDialogWidget extends StatefulWidget {
  final String dialogHeader;
  final String dialogText;

  const IOSDialogWidget({
    Key? key,
    required this.dialogHeader,
    required this.dialogText,
  }) : super(key: key);

  @override
  State<IOSDialogWidget> createState() => _IOSDialogWidgetState();
}

class _IOSDialogWidgetState extends State<IOSDialogWidget> {
  @override
  Widget build(BuildContext context) {
    return CupertinoAlertDialog(
      title: Text(widget.dialogHeader),
      content: Text(widget.dialogText),
      actions: <Widget>[
        CupertinoDialogAction(
          child: const Text('OK'),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
      ],
    );
  }
}

class AndroidDialogWidget extends StatefulWidget {
  final String dialogHeader;
  final String dialogText;
  const AndroidDialogWidget({
    Key? key,
    required this.dialogHeader,
    required this.dialogText,
  }) : super(key: key);

  @override
  State<AndroidDialogWidget> createState() => _AndroidDialogWidgetState();
}

class _AndroidDialogWidgetState extends State<AndroidDialogWidget> {
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(widget.dialogHeader),
      content: Text(widget.dialogText),
      actions: <Widget>[
        TextButton(
          child: const Text('OK'),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
      ],
    );
  }
}
