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
      fontWeight: FontWeight.w900);
  TextStyle scheduleDescStyle = const TextStyle(
    fontSize: 16,
    color: Colors.white,
    fontFamily: 'Inter',
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
                      onPressed: () {},
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
