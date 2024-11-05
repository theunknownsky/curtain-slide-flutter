import 'package:curtainslide/homePage.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';

class AddScheduleWidget extends StatefulWidget {
  const AddScheduleWidget({super.key});

  @override
  State<AddScheduleWidget> createState() => _AddScheduleWidgetState();
}

class _AddScheduleWidgetState extends State<AddScheduleWidget> {
  bool ledState = true;
  double currentBrightness = 5;
  String selectedColor = "Red";
  String selectedColorValue = "FF0000";
  double currentCurtainCloseness = 5;
  TimeOfDay? selectedTime = TimeOfDay.now();

  final userBox = Hive.box(FirebaseAuth.instance.currentUser!.uid);

  TextStyle actionTitleStyle = const TextStyle(
    fontSize: 28,
    color: Colors.white,
    fontFamily: 'Inter',
  );
  TextStyle actionDescriptionStyle = const TextStyle(
    fontSize: 16,
    color: Colors.white,
    fontFamily: 'Inter',
  );
  TextStyle notifStyle = const TextStyle(
    fontFamily: 'Inter',
  );

  List<dynamic> schedules = [];

  void _ledChange(bool value) {
    setState(() {
      ledState = value;
      print("Current LED State: $ledState");
    });
  }

  void _brightnessChange(double value) {
    setState(() {
      currentBrightness = value;
      print("Current brightness: $currentBrightness");
    });
  }

  void _colorChange(String value) {
    List<String> color = value.split('-');
    setState(() {
      selectedColor = color[0];
      selectedColorValue = color[1];
    });
  }

  void _curtainCloseness(double value) {
    setState(() {
      currentCurtainCloseness = value;
      print("Current Curtain Closeness: $currentCurtainCloseness");
    });
  }

  bool checkIfTimeExists(TimeOfDay timeToSave) {
    bool timeExists = false;
    List<dynamic> schedules = userBox.get('schedules');
    for (int i = 0; i < schedules.length; i++) {
      String iterateTimeStr = schedules[i]['time'];
      String timeString =
          '${timeToSave.hour.toString().padLeft(2, '0')}:${timeToSave.minute.toString().padLeft(2, '0')}';
      if (timeString == iterateTimeStr) {
        timeExists = true;
        break;
      }
    }
    return timeExists;
  }

  Future<void> addScheduleFunc() async {
    // Get the 'schedules' array
    List<dynamic> schedules = userBox.get('schedules');

    String timeString =
        '${selectedTime?.hour.toString().padLeft(2, '0')}:${selectedTime?.minute.toString().padLeft(2, '0')}';

    // Create the map to add to the schedule
    final newScheduleEntry = {
      'curtainState':
          currentCurtainCloseness, // Replace with your desired value
      'time': timeString, // Get the current timestamp
      'ledInfo': {
        'ledBrightness': currentBrightness, // Replace with your desired value
        'ledColor': selectedColor, // Replace with your desired value
        'ledColorValue': selectedColorValue, // Replace with your desired value
        'ledState': ledState, // Replace with your desired value
      },
    };

    schedules.add(newScheduleEntry);
    schedules.sort((a, b) {
      TimeOfDay timeA = TimeOfDay(
        hour: int.parse(a['time'].split(':')[0]),
        minute: int.parse(a['time'].split(':')[1]),
      );
      TimeOfDay timeB = TimeOfDay(
        hour: int.parse(b['time'].split(':')[0]),
        minute: int.parse(b['time'].split(':')[1]),
      );

      if (timeA.hour == timeB.hour) {
        return timeA.minute.compareTo(timeB.minute);
      } else {
        return timeA.hour.compareTo(timeB.hour);
      }
    });

    // Update the user's schedule in Firestore
    userBox.put('schedules', schedules);

    print('Schedule entry added successfully!');
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => const HomePage()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          Container(
            margin: const EdgeInsets.fromLTRB(24, 16, 24, 0),
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              color: const Color(0xFF191919),
            ),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "LED",
                      style: actionTitleStyle,
                    ),
                    Switch(
                      value: ledState,
                      activeColor: const Color(0xFFd9d9d9),
                      activeTrackColor: const Color(0xFF737373),
                      inactiveThumbColor: const Color(0xFF737373),
                      inactiveTrackColor: const Color(0xFF383838),
                      onChanged: _ledChange,
                    ),
                  ],
                ),
                Container(
                  margin: const EdgeInsets.only(top: 8),
                  child: Row(
                    children: [
                      Text(
                        "Turns the LED on or off.",
                        style: actionDescriptionStyle,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          Container(
            margin: const EdgeInsets.fromLTRB(24, 16, 24, 0),
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              color: const Color(0xFF191919),
            ),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "Color",
                      style: actionTitleStyle,
                    ),
                    AbsorbPointer(
                      absorbing: !ledState,
                      child: Container(
                        decoration: BoxDecoration(
                          color: const Color(0xFF383838),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        padding: const EdgeInsets.fromLTRB(16, 0, 16, 0),
                        child: DropdownButton<String>(
                          hint: Text(
                            selectedColor,
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 18,
                              fontFamily: 'Inter',
                            ),
                          ),
                          style: const TextStyle(
                            fontSize: 16,
                            fontFamily: 'Inter',
                          ),
                          dropdownColor: const Color(0xFF383838),
                          iconSize: 36,
                          borderRadius: BorderRadius.circular(10),
                          onChanged: (String? value) {
                            _colorChange(value!);
                            print(value);
                          },
                          items: const [
                            DropdownMenuItem(
                              value: "Red-FF0000",
                              child: Text("Red"),
                            ),
                            DropdownMenuItem(
                              value: "Orange-FFA500",
                              child: Text("Orange"),
                            ),
                            DropdownMenuItem(
                              value: "Yellow-FFFF00",
                              child: Text("Yellow"),
                            ),
                            DropdownMenuItem(
                              value: "Green-008000",
                              child: Text("Green"),
                            ),
                            DropdownMenuItem(
                              value: "Blue-0000FF",
                              child: Text("Blue"),
                            ),
                            DropdownMenuItem(
                              value: "Indigo-4B0082",
                              child: Text("Indigo"),
                            ),
                            DropdownMenuItem(
                              value: "Violet-EE82EE",
                              child: Text("Violet"),
                            ),
                          ],
                        ),
                      ),
                    )
                  ],
                ),
                Container(
                  margin: const EdgeInsets.only(top: 16),
                  child: Row(
                    children: [
                      Text(
                        "Selects the color of the LED.\nOnly available if LED is on.",
                        style: actionDescriptionStyle,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          Container(
            margin: const EdgeInsets.fromLTRB(24, 16, 24, 0),
            padding: const EdgeInsets.fromLTRB(16, 16, 4, 16),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              color: const Color(0xFF191919),
            ),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "Brightness",
                      style: actionTitleStyle,
                    ),
                    AbsorbPointer(
                      absorbing: !ledState,
                      child: SliderTheme(
                        data: SliderTheme.of(context).copyWith(
                          valueIndicatorTextStyle: const TextStyle(
                            color: Colors.black,
                          ),
                          showValueIndicator: ShowValueIndicator
                              .always, // Always show the value indicator
                        ),
                        child: Slider(
                          value: currentBrightness,
                          onChanged: _brightnessChange,
                          max: 10,
                          divisions: 10,
                          label: currentBrightness.round().toString(),
                          activeColor: const Color(0xFFD9D9D9),
                          inactiveColor: const Color(0xFF737373),
                        ),
                      ),
                    )
                  ],
                ),
                Container(
                  margin: const EdgeInsets.only(top: 16),
                  child: Row(
                    children: [
                      Text(
                        "Controls the brightness of the LED.\nOnly available if LED is on.",
                        style: actionDescriptionStyle,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          Container(
            margin: const EdgeInsets.fromLTRB(24, 16, 24, 0),
            padding: const EdgeInsets.fromLTRB(16, 16, 4, 16),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              color: const Color(0xFF191919),
            ),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "Curtain",
                      style: actionTitleStyle,
                    ),
                    SliderTheme(
                      data: SliderTheme.of(context).copyWith(
                        valueIndicatorTextStyle: const TextStyle(
                          color: Colors.black,
                        ),
                        showValueIndicator: ShowValueIndicator
                            .always, // Always show the value indicator
                      ),
                      child: Slider(
                        value: currentCurtainCloseness,
                        onChanged: _curtainCloseness,
                        max: 5,
                        divisions: 5,
                        label: currentCurtainCloseness.round().toString(),
                        activeColor: const Color(0xFFD9D9D9),
                        inactiveColor: const Color(0xFF737373),
                      ),
                    )
                  ],
                ),
                Container(
                  margin: const EdgeInsets.only(top: 16),
                  child: Row(
                    children: [
                      Text(
                        "Sets the curtain's closeness. \nSlide to 0 if you want it open. \nSlide to 5 if you want it closed.",
                        style: actionDescriptionStyle,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          Container(
            margin: const EdgeInsets.fromLTRB(24, 16, 24, 0),
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              color: const Color(0xFF191919),
            ),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "Time",
                      style: actionTitleStyle,
                    ),
                    FilledButton.icon(
                      label: Text(selectedTime == null
                          ? MaterialLocalizations.of(context)
                              .formatTimeOfDay(TimeOfDay.now())
                          : MaterialLocalizations.of(context)
                              .formatTimeOfDay(selectedTime!)),
                      onPressed: () async {
                        var pickedTime = await showTimePicker(
                          context: context,
                          initialEntryMode: TimePickerEntryMode.dial,
                          initialTime: TimeOfDay.now(),
                        );
                        setState(() {
                          selectedTime = pickedTime;
                          selectedTime ??= TimeOfDay.now();
                          print(selectedTime);
                        });
                      },
                      style: ButtonStyle(
                        backgroundColor:
                            const WidgetStatePropertyAll(Color(0xFF383838)),
                        shape: WidgetStatePropertyAll(
                          RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        textStyle: const WidgetStatePropertyAll(
                          TextStyle(
                            fontFamily: 'Inter',
                            fontSize: 18,
                          ),
                        ),
                      ),
                    )
                  ],
                ),
                Container(
                  margin: const EdgeInsets.only(top: 8),
                  child: Row(
                    children: [
                      Text(
                        "Sets the time of the schedule",
                        style: actionDescriptionStyle,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          Container(
            margin: const EdgeInsets.fromLTRB(24, 16, 24, 16),
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              color: const Color(0xFF191919),
            ),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "Save Schedule",
                      style: actionTitleStyle,
                    ),
                    FilledButton.icon(
                      label: const Text("Save"),
                      onPressed: () {
                        if (!checkIfTimeExists(selectedTime!)) {
                          addScheduleFunc();
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text(
                                "Schedule successfully saved.",
                                style: notifStyle,
                              ),
                              duration: Duration(seconds: 3),
                            ),
                          );
                        } else {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text(
                                "Time already exists.",
                                style: notifStyle,
                              ),
                              duration: Duration(seconds: 3),
                            ),
                          );
                        }
                      },
                      style: ButtonStyle(
                        backgroundColor:
                            const WidgetStatePropertyAll(Color(0xFF383838)),
                        shape: WidgetStatePropertyAll(
                          RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        textStyle: const WidgetStatePropertyAll(
                          TextStyle(
                            fontFamily: 'Inter',
                            fontSize: 18,
                          ),
                        ),
                      ),
                    )
                  ],
                ),
                Container(
                  margin: const EdgeInsets.only(top: 8),
                  child: Row(
                    children: [
                      Text(
                        "Saves the schedule and options for\nCurtainSlide to operate at a later time.",
                        style: actionDescriptionStyle,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
