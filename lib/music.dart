import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:loader_overlay/loader_overlay.dart';
import 'package:http/http.dart' as http;

import 'package:rgb_controller/devices.dart';
import 'package:rgb_controller/globals.dart';
import 'package:rgb_controller/sequence.dart';
import 'package:rgb_controller/solid_color.dart';

class MusicPage extends StatefulWidget {
  const MusicPage({super.key});

  @override
  State<MusicPage> createState() => _MusicPageState();
}

class _MusicPageState extends State<MusicPage> {
  static const int currIndex = 2;
  String setButtonText = "Start pulsing to music";
  String checkText = "Test internet connection to access online features";
  bool showOnline = false;
  String search = '';
  bool searched = false;
  static const Map<String, String> header1 = {
    'X-RapidAPI-Key': 'a5a4a4c5cfmshba8159a4b7cbc56p1e5e7fjsnf8b5c34e7a23',
    'X-RapidAPI-Host': 'spotify23.p.rapidapi.com'
  };
  static const Map<String, String> header2 = {
    'Accept': 'application/json',
    'Content-Type': 'application/json',
    'Authorization':
        'Bearer BQA44EBcjdWze3qOmf0JUjM8sVIk0wBt6T6CArvoCo8hpoC6C0WLFsdFDPTq3GXjiSOjlGo-0Y8ZEWSmudJulXA9wIwsAoKt0SAjL2y1uRxAh5x-37ivh8rAeWbP-V0LHagrPWV-PxHH5Mkn5J6Xv_WZbDW61sO9TI7QA-VmMBwX4WU'
  };
  String title = '';
  String albumName = '';
  String cover64 = '';
  String artist = '';
  double bmp = -1;

  void setFun() {
    setState(
      () {
        currentState = 'Flashing to music';
        currColor = Colors.black;
        setButtonText = "Start flashing to music";
      },
    );
  }

  void apiCommunication() {}

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: LoaderOverlay(
        child: Scaffold(
          backgroundColor: themeColor,
          appBar: AppBar(
            title: const Text(header),
            centerTitle: true,
            backgroundColor: accentColor,
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
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: SizedBox(
                      width: double.infinity,
                      child: Column(
                        children: [
                          const Text(
                            'Offline mode: ',
                            style: TextStyle(
                              fontSize: 20,
                              color: Colors.grey,
                            ),
                          ),
                          MyCustomForm2(funkcja: setFun),
                          const Divider(
                            color: Colors.black,
                            thickness: 2,
                          ),
                          SizedBox(
                            width: double.infinity,
                            child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                  backgroundColor: accentColor),
                              onPressed: () async {
                                bool result = await InternetConnectionChecker()
                                    .hasConnection;
                                setState(
                                  () {
                                    if (result) {
                                      checkText = 'Connected';
                                      showOnline = true;
                                    } else {
                                      checkText = 'Disconnected :( Try again';
                                      showOnline = false;
                                    }
                                  },
                                );
                              },
                              child: Text(checkText),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Visibility(
                    visible: showOnline,
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        children: [
                          const Text(
                            'Online mode: ',
                            style: TextStyle(
                              fontSize: 20,
                              color: Colors.grey,
                            ),
                          ),
                          TextField(
                            decoration: const InputDecoration(
                              labelText: "Enter name and author of the song",
                            ),
                            onChanged: (value) {
                              search = value;
                            },
                          ),
                          ElevatedButton(
                            style: ElevatedButton.styleFrom(
                                backgroundColor: accentColor),
                            onPressed: () async {
                              if (search.isNotEmpty) {
                                setState(() {
                                  setButtonText = "Start flashing to music";
                                });
                                FocusManager.instance.primaryFocus?.unfocus();
                                final response = await http.get(
                                    Uri.parse(
                                        'https://spotify23.p.rapidapi.com/search/?q=$search&type=tracks&offset=0&limit=1&numberOfTopResults=1'),
                                    headers: header1);
                                if (response.statusCode == 200) {
                                  Map<String, dynamic> data =
                                      jsonDecode(response.body);
                                  Map<String, dynamic> data2 = data['tracks'];
                                  List<dynamic> data3 = data2['items'];
                                  Map<String, dynamic> data4 = data3[0];
                                  Map<String, dynamic> data5 = data4['data'];
                                  String id = data5['id'];
                                  title = data5['name'];
                                  Map<String, dynamic> data6 =
                                      data5['albumOfTrack'];
                                  albumName = data6['name'];
                                  Map<String, dynamic> data7 =
                                      data6['coverArt'];
                                  List<dynamic> data8 = data7['sources'];
                                  Map<String, dynamic> data9 = data8[1];
                                  cover64 = data9['url'];
                                  Map<String, dynamic> data10 =
                                      data5['artists'];
                                  List<dynamic> data11 = data10['items'];
                                  Map<String, dynamic> data12 = data11[0];
                                  Map<String, dynamic> data13 =
                                      data12['profile'];
                                  artist = data13['name'];

                                  final response2 = await http.get(
                                      Uri.parse(
                                          'https://api.spotify.com/v1/audio-analysis/$id'),
                                      headers: header2);
                                  if (response2.statusCode == 200) {
                                    Map<String, dynamic> tada =
                                        jsonDecode(response2.body);
                                    Map<String, dynamic> tada2 = tada['track'];
                                    bmp = tada2['tempo'];
                                    setState(
                                      () {
                                        searched = true;
                                      },
                                    );
                                  } else {
                                    // ignore: use_build_context_synchronously
                                    errorPopUp(
                                        jsonDecode(response2.body).toString(),
                                        context);
                                  }
                                } else {
                                  // ignore: use_build_context_synchronously
                                  errorPopUp(
                                      jsonDecode(response.body).toString(),
                                      context);
                                }
                              }
                            },
                            child: const Center(
                              child: Text('Search song for BPM'),
                            ),
                          ),
                          Visibility(
                            visible: searched,
                            child: Column(
                              children: [
                                const Text(
                                  'Result: ',
                                  style: TextStyle(
                                    fontSize: 15,
                                  ),
                                ),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Image.network(cover64),
                                    Center(
                                      child: Column(
                                        children: [
                                          Text('$title - $artist'),
                                          Text(albumName),
                                        ],
                                      ),
                                    ),
                                    Text('BPM: $bmp'),
                                  ],
                                ),
                                SizedBox(
                                  width: double.infinity,
                                  child: ElevatedButton(
                                    style: ElevatedButton.styleFrom(
                                        backgroundColor: accentColor),
                                    onPressed: () async {
                                      if (devicesCount <= 0) {
                                        noDevicesErrorPopUp(context);
                                        return;
                                      }
                                      context.loaderOverlay.show();
                                      await Future.delayed(
                                        const Duration(seconds: 2),
                                      );
                                      // ignore: use_build_context_synchronously
                                      context.loaderOverlay.hide();
                                      setState(
                                        () {
                                          currentState = 'Flashing to music';
                                          currColor = Colors.black;
                                          setButtonText = 'Success!';
                                        },
                                      );
                                    },
                                    child: Text(setButtonText),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          bottomNavigationBar: BottomNavigationBar(
            backgroundColor: accentColor,
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
                },
              );
            },
          ),
        ),
      ),
    );
  }
}

class MyCustomForm2 extends StatefulWidget {
  final void Function() funkcja;
  const MyCustomForm2({super.key, required this.funkcja});

  @override
  MyCustomForm2State createState() {
    return MyCustomForm2State();
  }
}

class MyCustomForm2State extends State<MyCustomForm2> {
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          TextFormField(
            decoration: const InputDecoration(
              labelText: "Enter desired BPM",
            ),
            validator: (value) {
              if (value == null ||
                  value.isEmpty ||
                  int.tryParse(value) == null ||
                  int.parse(value) <= 0) {
                return 'Invalid input';
              }
              return null;
            },
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 16.0),
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(backgroundColor: accentColor),
              onPressed: () {
                if (devicesCount <= 0) {
                  noDevicesErrorPopUp(context);
                  return;
                }
                if (_formKey.currentState!.validate()) {
                  FocusManager.instance.primaryFocus?.unfocus();
                  widget.funkcja();
                }
              },
              child: const Center(
                child: Text('Pulse in provided tempo'),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

void errorPopUp(String errorMessage, BuildContext context) {
  showDialog<String>(
    context: context,
    builder: (BuildContext context) => AlertDialog(
      title: const Text('API connection error'),
      content: Text(errorMessage),
      actions: <Widget>[
        TextButton(
          onPressed: () => Navigator.pop(context, 'OK'),
          child: const Text('OK'),
        ),
      ],
    ),
  );
}
