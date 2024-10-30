import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class ScheduleWidget extends StatefulWidget {
  const ScheduleWidget({super.key});

  @override
  State<ScheduleWidget> createState() => _ScheduleWidgetState();
}

class _ScheduleWidgetState extends State<ScheduleWidget> {
  TextStyle scheduleTimeStyle = const TextStyle(
    fontSize: 28,
    color: Colors.white,
    fontFamily: 'Inter',
    fontWeight: FontWeight.w900,
  );
  TextStyle scheduleDescStyle = const TextStyle(
    fontSize: 16,
    color: Colors.white,
    fontFamily: 'Inter',
  );
  TextStyle actionTitleStyle = const TextStyle(
    fontSize: 20,
    color: Colors.white,
    fontFamily: 'Inter',
    fontWeight: FontWeight.bold,
  );

  @override
  void initState() {
    super.initState();
    _fetchScheduleData();
  }

  Future<void> deleteScheduleItem(int index) async {
    try {
      // Get the current user's ID
      String userId = FirebaseAuth.instance.currentUser!.uid;
      // Fetch the 'schedule' array from the document
      DocumentSnapshot doc = await FirebaseFirestore.instance
          .collection('users')
          .doc(userId)
          .get();
      // Get the 'schedule' array
      List<dynamic> schedule = doc.get('schedule');
      // Remove the item at the specified index
      schedule.removeAt(index);
      // Update the entire 'schedule' array in the document
      await FirebaseFirestore.instance
          .collection('users')
          .doc(userId)
          .update({'schedule': schedule});
      setState(() {
        schedules.removeAt(index);
        listOfSchedWidget.removeAt(index);
      });
      print('Schedule item at index $index deleted successfully!');
    } catch (e) {
      print('Error deleting schedule item: $e');
    }
  }

  void showConfirmationDialog(BuildContext context, int index) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Confirmation'),
          content: const Text('Are you sure you want to delete this schedule?'),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                print("Caedrel just canceled");
                Navigator.of(context).pop();
              },
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                // Perform action on confirmation
                print("Caedrel hit malz ult to index $index!");
                Navigator.of(context).pop();
                deleteScheduleItem(index);
                setState(() {});
              },
              child: const Text('Confirm'),
            ),
          ],
        );
      },
    );
  }

  List<dynamic> schedules = [];
  List<Widget> listOfSchedWidget = [];

  Future<void> updateScheduleItem(
      int index, Map<String, dynamic> updatedData) async {
    try {
      // Get the current user's ID

      String userId = FirebaseAuth.instance.currentUser!.uid;

      // Fetch the 'schedule' array from the document

      DocumentSnapshot doc = await FirebaseFirestore.instance
          .collection('users')
          .doc(userId)
          .get();
      // Get the 'schedule' array
      List<dynamic> schedule = doc.get('schedule');
      // Check if the index is valid
      if (index >= 0 && index < schedule.length) {
        // Update the data at the specified index
        schedule[index] = updatedData;
        // Update the entire 'schedule' array in the document
        await FirebaseFirestore.instance
            .collection('users')
            .doc(userId)
            .update({'schedule': schedule});

        _fetchScheduleData();

        print('Schedule item at index $index updated successfully!');
      } else {
        print('Invalid index for schedule item.');
      }
    } catch (e) {
      print('Error updating schedule item: $e');
    }
  }

  void showBottomSheet(BuildContext context, int i) {
    bool schedLedState = schedules[i]['ledInfo']['ledState'];
    double schedLedBrightness = schedules[i]['ledInfo']['ledBrightness'];
    String schedSelectedColor = schedules[i]['ledInfo']['ledColor'];
    String schedSelectedColorValue = schedules[i]['ledInfo']['ledColorValue'];
    double schedCurtainState = schedules[i]['curtainState'];
    String schedTime = schedules[i]['time'];
    List<String> parts = schedTime.split(":");
    int hour = int.parse(parts[0]);
    int minute = int.parse(parts[1]);
    TimeOfDay? schedTimeTOD = TimeOfDay(hour: hour, minute: minute);
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return SizedBox(
              height: 500,
              child: Container(
                color: Color(0xFF383838),
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 16),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            "Edit Schedule",
                            style: actionTitleStyle,
                          ),
                          FilledButton.icon(
                            label: const Text("Save"),
                            onPressed: () {
                              String timeString =
                                  '${schedTimeTOD?.hour.toString().padLeft(2, '0')}:${schedTimeTOD?.minute.toString().padLeft(2, '0')}';
                              Map<String, dynamic> updatedData = {
                                'curtainState': schedCurtainState,
                                'ledInfo': {
                                  'ledState': schedLedState,
                                  'ledColor': schedSelectedColor,
                                  'ledColorValue': schedSelectedColorValue,
                                  'ledBrightness': schedLedBrightness,
                                },
                                'time': timeString,
                              };
                              updateScheduleItem(i, updatedData);
                              Navigator.pop(context);
                            },
                            style: ButtonStyle(
                              backgroundColor: const WidgetStatePropertyAll(
                                  Color.fromARGB(255, 40, 155, 14)),
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
                          ),
                        ],
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            "LED State ",
                            style: actionTitleStyle,
                          ),
                          Switch(
                            value: schedLedState,
                            activeColor: const Color(0xFFd9d9d9),
                            activeTrackColor: const Color(0xFF737373),
                            inactiveThumbColor: const Color(0xFF737373),
                            inactiveTrackColor: const Color(0xFF383838),
                            onChanged: (value) {
                              setState(() {
                                schedLedState = value;
                              });
                            },
                          ),
                        ],
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.only(left: 16),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            "Brightness ",
                            style: actionTitleStyle,
                          ),
                          AbsorbPointer(
                            absorbing: !schedLedState,
                            child: SliderTheme(
                              data: SliderTheme.of(context).copyWith(
                                valueIndicatorTextStyle: const TextStyle(
                                  color: Colors.black,
                                ),
                                showValueIndicator: ShowValueIndicator
                                    .always, // Always show the value indicator
                              ),
                              child: Slider(
                                value: schedLedBrightness,
                                onChanged: (value) {
                                  setState(() {
                                    schedLedBrightness = value;
                                  });
                                },
                                max: 10,
                                divisions: 10,
                                label: schedLedBrightness.round().toString(),
                                activeColor: const Color(0xFFD9D9D9),
                                inactiveColor: const Color(0xFF737373),
                              ),
                            ),
                          )
                        ],
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.symmetric(horizontal: 16),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            "Color",
                            style: actionTitleStyle,
                          ),
                          AbsorbPointer(
                            absorbing: !schedLedState,
                            child: Container(
                              decoration: BoxDecoration(
                                color: const Color(0xFF555555),
                                borderRadius: BorderRadius.circular(10),
                              ),
                              padding: const EdgeInsets.fromLTRB(16, 0, 16, 0),
                              child: DropdownButton<String>(
                                hint: Text(
                                  schedSelectedColor,
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
                                dropdownColor: const Color(0xFF555555),
                                iconSize: 36,
                                borderRadius: BorderRadius.circular(10),
                                onChanged: (String? value) {
                                  List<String> color = value!.split('-');
                                  setState(() {
                                    schedSelectedColor = color[0];
                                    schedSelectedColorValue = color[1];
                                  });
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
                    ),
                    Container(
                      margin: EdgeInsets.symmetric(horizontal: 16),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            "Curtain State",
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
                              value: schedCurtainState,
                              onChanged: (value) {
                                setState(() {
                                  schedCurtainState = value;
                                });
                              },
                              max: 5,
                              divisions: 5,
                              label: schedCurtainState.round().toString(),
                              activeColor: const Color(0xFFD9D9D9),
                              inactiveColor: const Color(0xFF737373),
                            ),
                          )
                        ],
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.symmetric(horizontal: 16),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            "Time",
                            style: actionTitleStyle,
                          ),
                          FilledButton.icon(
                            label: Text(schedTimeTOD == null
                                ? MaterialLocalizations.of(context)
                                    .formatTimeOfDay(TimeOfDay.now())
                                : MaterialLocalizations.of(context)
                                    .formatTimeOfDay(schedTimeTOD!)),
                            onPressed: () async {
                              var pickedTime = await showTimePicker(
                                context: context,
                                initialEntryMode: TimePickerEntryMode.dial,
                                initialTime: TimeOfDay.now(),
                              );
                              setState(() {
                                schedTimeTOD = pickedTime;
                                schedTimeTOD ??= TimeOfDay.now();
                              });
                            },
                            style: ButtonStyle(
                              backgroundColor: const WidgetStatePropertyAll(
                                  Color(0xFF555555)),
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
                    )
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }

  List<Widget> obtainSchedWidgetList(List<dynamic> schedule) {
    List<Widget> currentSchedList = [];
    if (schedule.length > 0) {
      for (int i = 0; i < schedule.length; i++) {
        EdgeInsets normalMargin = const EdgeInsets.fromLTRB(24, 16, 24, 0);
        if (i == schedule.length - 1) {
          normalMargin = const EdgeInsets.fromLTRB(24, 16, 24, 16);
        }
        String ledState = "";
        ledState = schedule[i]['ledInfo']['ledState'] ? "On" : "Off";
        currentSchedList.add(
          Container(
            margin: normalMargin,
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
                      "${schedule[i]['time']}",
                      style: scheduleTimeStyle,
                    ),
                    FilledButton.icon(
                      label: const Text("Edit"),
                      onPressed: () {
                        showBottomSheet(context, i);
                      },
                      style: ButtonStyle(
                        padding: WidgetStatePropertyAll(
                            EdgeInsets.symmetric(horizontal: 35)),
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
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Curtain State: ${schedule[i]['curtainState'].round()}",
                            style: scheduleDescStyle,
                          ),
                          Text(
                            "LED State: $ledState",
                            style: scheduleDescStyle,
                          ),
                          Text(
                            "LED Color: ${schedule[i]['ledInfo']['ledColor']}",
                            style: scheduleDescStyle,
                          ),
                          Text(
                            "Brightness: ${schedule[i]['ledInfo']['ledBrightness'].round()}",
                            style: scheduleDescStyle,
                          ),
                        ],
                      ),
                      FilledButton.icon(
                        label: const Text("Delete"),
                        onPressed: () {
                          showConfirmationDialog(context, i);
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
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      }
    }

    return currentSchedList;
  }

  Future<void> _fetchScheduleData() async {
    DocumentSnapshot doc = await FirebaseFirestore.instance
        .collection('users')
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .get();

    if (doc.exists) {
      setState(() {
        schedules = doc.get('schedule');
        listOfSchedWidget = obtainSchedWidgetList(schedules);
      });
    } else {
      print('User document does not exist.');
    }
  }

  @override
  Widget build(BuildContext context) {
    // printSchedulesProperly();
    return SingleChildScrollView(
      child: Column(
        children: listOfSchedWidget,
      ),
      padding: EdgeInsets.symmetric(vertical: 2.0),
    );
  }
}
