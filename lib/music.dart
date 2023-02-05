import 'package:flutter/material.dart';
import 'package:loader_overlay/loader_overlay.dart';
import 'package:rgb_controller/globals.dart';
import 'package:rgb_controller/sequence.dart';
import 'package:rgb_controller/solid_color.dart';

import 'devices.dart';

class MusicPage extends StatefulWidget {
  const MusicPage({super.key});

  @override
  State<MusicPage> createState() => _MusicPageState();
}

class _MusicPageState extends State<MusicPage> {
  String setButtonText = "Set blinking to the beat";

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
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () async {
                        context.loaderOverlay.show();
                        await Future.delayed(const Duration(seconds: 2));
                        // ignore: use_build_context_synchronously
                        context.loaderOverlay.hide();
                        setState(() {
                          currentState = 'Sequence';
                          currColor = Colors.black;
                          setButtonText = 'Success!';
                        });
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.black,
                      ),
                      child: Text(setButtonText),
                    ),
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
                          currentState = 'Sequence';
                          currColor = Colors.black;
                          setButtonText = 'Success!';
                        });
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.black,
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
                  case 0:
                    {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (context) => const SolidColorPage(),
                        ),
                      );
                    }
                    break;
                  case 1:
                    {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (context) => const SequencePage(),
                        ),
                      );
                    }
                    break;
                  case 3:
                    {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (context) => const DevicesPage(),
                        ),
                      );
                    }
                    break;
                  default:
                    break;
                }
              });
            },
          ),
        ),
      ),
    );
  }
}
