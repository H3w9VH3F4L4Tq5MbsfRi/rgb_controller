import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_hsvcolor_picker/flutter_hsvcolor_picker.dart';
import 'package:loader_overlay/loader_overlay.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  Color pickedColor = Colors.red;
  Color sentColor = Colors.black;
  bool isLoaderVisible = false;
  String currentState = 'No active animation';
  String setButtonText = "Set selected color";
  int currIndex = 0;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: LoaderOverlay(
        child: Scaffold(
          backgroundColor: const Color.fromARGB(255, 250, 250, 250),
          appBar: AppBar(
            title: const Text('RGB controller'),
            centerTitle: true,
            backgroundColor: Colors.blueGrey,
          ),
          body: SizedBox(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                children: [
                  AppBar(
                    title: Text(currentState),
                    centerTitle: true,
                    backgroundColor: sentColor,
                  ),
                  ColorPicker(
                    onChanged: (value) {
                      setState(
                        () {
                          pickedColor = value;
                          setButtonText = 'Set selected color';
                        },
                      );
                    },
                    color: pickedColor,
                    initialPicker: Picker.paletteHue,
                    pickerOrientation: PickerOrientation.portrait,
                  ),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () async {
                        context.loaderOverlay.show();
                        await Future.delayed(const Duration(seconds: 2));
                        // ignore: use_build_context_synchronously
                        context.loaderOverlay.hide();
                        setState(() {
                          currentState = 'Solid color';
                          setButtonText = 'Success!';
                          sentColor = pickedColor;
                        });
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: pickedColor,
                      ),
                      child: Text(setButtonText),
                    ),
                  ),
                ],
              ),
            ),
          ),
          bottomNavigationBar: BottomNavigationBar(
            backgroundColor: Colors.blueGrey,
            showSelectedLabels: false,
            showUnselectedLabels: false,
            type: BottomNavigationBarType.fixed,
            selectedItemColor: Colors.white,
            items: const [
              BottomNavigationBarItem(
                icon: Icon(Icons.color_lens),
                label: 'Solid',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.flourescent_sharp),
                label: 'Strobo',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.music_note),
                label: 'Music',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.devices),
                label: 'Devices',
              ),
            ],
            currentIndex: currIndex,
            onTap: (value) {
              setState(() {
                currIndex = value;
              });
            },
          ),
        ),
      ),
    );
  }
}
