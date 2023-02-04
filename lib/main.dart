import 'package:flutter/material.dart';
import 'package:rgb_controller/solid_color.dart';

void main() {
  runApp(const RGBControllerApp());
}

class RGBControllerApp extends StatefulWidget {
  const RGBControllerApp({super.key});

  @override
  State<RGBControllerApp> createState() => _RGBControllerAppState();
}

class _RGBControllerAppState extends State<RGBControllerApp> {
  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: SolidColorPage(),
    );
  }
}
