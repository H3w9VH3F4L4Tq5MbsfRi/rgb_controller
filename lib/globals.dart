library rgb_controller.globals;

import 'package:flutter/material.dart';

String currentState = 'No active action';
int currIndex = 0;
Color currColor = Colors.black;
List<int> times = List.generate(0, (index) => index, growable: true);
int sequences = 0;
