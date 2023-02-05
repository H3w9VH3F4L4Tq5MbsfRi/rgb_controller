import 'package:flutter/material.dart';
import 'package:loader_overlay/loader_overlay.dart';
import 'package:rgb_controller/devices.dart';
import 'package:rgb_controller/globals.dart';
import 'package:rgb_controller/solid_color.dart';

import 'music.dart';

class SequencePage extends StatefulWidget {
  const SequencePage({super.key});

  @override
  State<SequencePage> createState() => _SequencePageState();
}

class _SequencePageState extends State<SequencePage> {
  String setButtonText = "Set created sequence";
  List<int> times = List.generate(0, (index) => index, growable: true);

  void addTime(int time) {
    setState(() {
      times.add(time);
    });
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
                            'Enter duration of new segment in ms: ',
                            style: TextStyle(
                              fontSize: 20,
                            ),
                          ),
                          MyCustomForm(
                            funkcja: addTime,
                          ),
                          const Divider(
                            color: Colors.black,
                            thickness: 2,
                          ),
                          const Text(
                            'Current sequence: ',
                            style: TextStyle(
                              fontSize: 20,
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: times.length > 0
                                ? ListView.builder(
                                    scrollDirection: Axis.vertical,
                                    shrinkWrap: true,
                                    itemCount: times.length,
                                    itemBuilder: (context, index) {
                                      return SeqListElem(
                                        child: times[index],
                                        indx: index,
                                      );
                                    },
                                  )
                                : const Text('Empty'),
                          ),
                          SizedBox(
                            width: double.infinity,
                            child: ElevatedButton(
                              onPressed: () {
                                setState(
                                  () {
                                    times = [];
                                  },
                                );
                              },
                              child: const Text('Clear sequence'),
                            ),
                          ),
                          const Divider(
                            color: Colors.black,
                            thickness: 2,
                          ),
                        ],
                      ),
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
                  case 2:
                    {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (context) => const MusicPage(),
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

class MyCustomForm extends StatefulWidget {
  final void Function(int) funkcja;

  const MyCustomForm({super.key, required this.funkcja});

  @override
  MyCustomFormState createState() {
    return MyCustomFormState();
  }
}

class MyCustomFormState extends State<MyCustomForm> {
  final _formKey = GlobalKey<FormState>();
  int time = -1;

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          TextFormField(
            validator: (value) {
              if (value == null ||
                  value.isEmpty ||
                  int.tryParse(value) == null ||
                  int.parse(value) <= 0) {
                return 'Invalid input';
              } else {
                time = int.parse(value);
              }
              return null;
            },
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 16.0),
            child: ElevatedButton(
              onPressed: () {
                if (_formKey.currentState!.validate()) {
                  FocusManager.instance.primaryFocus?.unfocus();
                  widget.funkcja(time);
                }
              },
              child: const Center(
                child: Text('Add'),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class SeqListElem extends StatelessWidget {
  final int child;
  final int indx;

  // ignore: use_key_in_widget_constructors
  const SeqListElem({required this.child, required this.indx});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 50,
      decoration: BoxDecoration(
        color: indx % 2 == 0 ? Colors.white : Colors.black,
        border: Border.all(
          color: Colors.black,
          width: 2,
        ),
      ),
      child: Center(
        child: Text(
          '$child ms',
          style: TextStyle(color: indx % 2 == 0 ? Colors.black : Colors.white),
        ),
      ),
    );
  }
}
