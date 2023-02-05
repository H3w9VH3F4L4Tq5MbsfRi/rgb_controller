library rgb_controller.globals;

import 'package:flutter/material.dart';

String currentState = 'No active action';
const Color accentColor = Colors.blueGrey;
Color currColor = Colors.black;
const Color themeColor = Color.fromARGB(255, 250, 250, 250);
Map<String, bool> devices = {};
int devicesCount = 0;
const String header = "RGB controller";

void noDevicesErrorPopUp(BuildContext context) {
  showDialog<String>(
    context: context,
    builder: (BuildContext context) => AlertDialog(
      title: const Text('No devices connected'),
      content: const Text('Connect device(s) before sending action!'),
      actions: <Widget>[
        TextButton(
          onPressed: () => Navigator.pop(context, 'OK'),
          child: const Text('OK'),
        ),
      ],
    ),
  );
}
