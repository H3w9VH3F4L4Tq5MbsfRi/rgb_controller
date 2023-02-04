import 'package:flutter/material.dart';
import 'package:flutter_hsvcolor_picker/flutter_hsvcolor_picker.dart';
import 'package:loader_overlay/loader_overlay.dart';
import 'package:rgb_controller/globals.dart';
import 'package:rgb_controller/sequence.dart';

class SolidColorPage extends StatefulWidget {
  const SolidColorPage({super.key});

  @override
  State<SolidColorPage> createState() => _SolidColorPageState();
}

class _SolidColorPageState extends State<SolidColorPage> {
  Color pickedColor = Colors.red;
  String setButtonText = "Set selected color";

  @override
  Widget build(BuildContext context) {
    return LoaderOverlay(
      child: Scaffold(
        backgroundColor: const Color.fromARGB(255, 250, 250, 250),
        appBar: AppBar(
          title: const Text('RGB controller'),
          centerTitle: true,
          backgroundColor: Colors.blueGrey,
          automaticallyImplyLeading: false,
        ),
        body: SizedBox(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              children: [
                AppBar(
                  title: Text(currentState),
                  centerTitle: true,
                  backgroundColor: currColor,
                  automaticallyImplyLeading: false,
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
                        currColor = pickedColor;
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
              switch (value) {
                case 1:
                  {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) => const SequencePage(),
                      ),
                    );
                  }
                  break;
                case 2:
                  {
                    print('dupa2');
                  }
                  break;
                case 3:
                  {
                    print('dupa3');
                  }
                  break;
                default:
                  break;
              }
            });
          },
        ),
      ),
    );
  }
}