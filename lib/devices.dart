import 'package:flutter/material.dart';
import 'package:loader_overlay/loader_overlay.dart';
import 'package:network_info_plus/network_info_plus.dart';
import 'package:rgb_controller/globals.dart';
import 'package:rgb_controller/sequence.dart';
import 'package:rgb_controller/solid_color.dart';
import 'package:lan_scanner/lan_scanner.dart';

import 'music.dart';

class DevicesPage extends StatefulWidget {
  const DevicesPage({super.key});

  @override
  State<DevicesPage> createState() => _DevicesPageState();
}

class _DevicesPageState extends State<DevicesPage> {
  static const int currIndex = 3;
  String setButtonText = "Scan network for avaible devices";
  bool devicesVisibility = false;
  List<String> devices = [];
  String baner = 'Avaible devices: ';
  int devicesCount = 0;

  void changeConnectedCount(bool newState) {
    if (newState) {
      setState(
        () {
          devicesCount++;
        },
      );
    } else {
      setState(
        () {
          devicesCount--;
        },
      );
    }
  }

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
                    title: Text('$devicesCount devices connected'),
                    centerTitle: true,
                    backgroundColor: currColor,
                    automaticallyImplyLeading: false,
                  ),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () async {
                        setState(
                          () {
                            devices = [];
                            devicesCount = 0;
                          },
                        );

                        var wifiIP = await (NetworkInfo().getWifiIP());
                        var subnet = ipToCSubnet(wifiIP!);
                        final scanner = LanScanner();
                        final stream = scanner.icmpScan(subnet);
                        stream.listen(
                          (HostModel device) {
                            setState(
                              () {
                                devices.add(device.ip);
                              },
                            );
                          },
                        );
                        setState(
                          () {
                            currColor = Colors.black;
                            devicesVisibility = true;
                          },
                        );
                      },
                      child: Text(setButtonText),
                    ),
                  ),
                  Visibility(
                    visible: devicesVisibility,
                    child: Column(
                      children: [
                        Text(
                          baner,
                          style: const TextStyle(
                            fontSize: 20,
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: devices.isNotEmpty
                              ? ListView.builder(
                                  scrollDirection: Axis.vertical,
                                  shrinkWrap: true,
                                  itemCount: devices.length,
                                  itemBuilder: (context, index) {
                                    return SeqListElem2(
                                      child: devices[index],
                                      funkcja: changeConnectedCount,
                                    );
                                  },
                                )
                              : const Text('Empty'),
                        ),
                      ],
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
              setState(
                () {
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
                    case 2:
                      {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (context) => const MusicPage(),
                          ),
                        );
                      }
                      break;
                    default:
                      break;
                  }
                },
              );
            },
          ),
        ),
      ),
    );
  }
}

class SeqListElem2 extends StatefulWidget {
  final String child;
  final void Function(bool) funkcja;
  const SeqListElem2({super.key, required this.child, required this.funkcja});

  @override
  State<SeqListElem2> createState() => _SeqListElem2State();
}

class _SeqListElem2State extends State<SeqListElem2> {
  bool state = false;
  @override
  Widget build(BuildContext context) {
    return CheckboxListTile(
      title: Text('IP: ${widget.child}'),
      value: state,
      onChanged: (bool? newValue) {
        setState(
          () {
            state = newValue!;
          },
        );
        widget.funkcja(newValue!);
      },
    );
  }
}
