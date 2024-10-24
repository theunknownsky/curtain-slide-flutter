import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class LEDWidget extends StatefulWidget {
  const LEDWidget({super.key});

  @override
  State<LEDWidget> createState() => _LEDWidgetState();
}

class _LEDWidgetState extends State<LEDWidget> {
  _LEDWidgetState();

  final TextStyle _tStyle = TextStyle(fontSize: 22);
  TextEditingController colorController = TextEditingController();
  bool ledState = false;
  double currentBrightness = 1;
  String selectedColor = '';
  String selectedColorValue = '';

  Map<String, dynamic>? ledInfo;

  Future<void> _fetchLedInfo() async {
    DocumentSnapshot doc = await FirebaseFirestore.instance
        .collection('users')
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .get();

    if (doc.exists) {
      setState(() {
        ledInfo = doc.data() as Map<String, dynamic>;
        ledState = ledInfo?['ledInfo']['ledState'];
        selectedColor = ledInfo?['ledInfo']['ledColor'];
        currentBrightness = ledInfo?['ledInfo']['ledBrightness'].toDouble();
        print("LED State: ${ledState}");
        print("LED Color: ${selectedColor}");
        print("LED Brightness: ${currentBrightness}");
      });
    } else {
      // Handle the case where the document doesn't exist
      print('Document does not exist');
    }
  }

  void initState() {
    super.initState();
    _fetchLedInfo();
    print("LED Info");
  }

  void _ledChange(bool value) {
    setState(() {
      ledState = value;
      print("Current LED State: ${ledState}");
    });
    FirebaseFirestore.instance
        .collection('users') // Replace with your collection name
        .doc(
            FirebaseAuth.instance.currentUser!.uid) // Get the current user's ID
        .update({'ledInfo.ledState': ledState});
  }

  void _brightnessChange(double value) {
    setState(() {
      currentBrightness = value;
      print("Current brightness: ${currentBrightness}");
    });
    FirebaseFirestore.instance
        .collection('users') // Replace with your collection name
        .doc(
            FirebaseAuth.instance.currentUser!.uid) // Get the current user's ID
        .update({'ledInfo.ledBrightness': currentBrightness});
  }

  void _colorChange(String value) {
    List<String> color = value.split('-');
    setState(() {
      selectedColor = color[0];
      selectedColorValue = color[1];
    });
    FirebaseFirestore.instance
        .collection('users') // Replace with your collection name
        .doc(
            FirebaseAuth.instance.currentUser!.uid) // Get the current user's ID
        .update({'ledInfo.ledColor': selectedColor});
    FirebaseFirestore.instance
        .collection('users') // Replace with your collection name
        .doc(
            FirebaseAuth.instance.currentUser!.uid) // Get the current user's ID
        .update({'ledInfo.ledColorValue': selectedColorValue});
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          Row(
            children: [
              Text(
                "LED off/on",
                style: _tStyle,
              ),
              Switch(
                value: ledState,
                activeColor: Colors.black,
                onChanged: _ledChange,
              )
            ],
          ),
          AbsorbPointer(
            absorbing: !ledState,
            child: Row(
              children: [
                Text(
                  "LED Color",
                  style: _tStyle,
                ),
                DropdownMenu<String>(
                  initialSelection: "Test 1",
                  onSelected: (value) {
                    _colorChange(value!);
                  },
                  dropdownMenuEntries: [
                    DropdownMenuEntry(value: "Red-FF0000", label: "Red"),
                    DropdownMenuEntry(value: "Orange-FFA500", label: "Orange"),
                    DropdownMenuEntry(value: "Yellow-FFFF00", label: "Yellow"),
                    DropdownMenuEntry(value: "Green-008000", label: "Green"),
                    DropdownMenuEntry(value: "Blue-0000FF", label: "Blue"),
                    DropdownMenuEntry(value: "Indigo-4B0082", label: "Indigo"),
                    DropdownMenuEntry(value: "Violet-EE82EE", label: "Violet"),
                  ],
                  hintText: selectedColor,
                ),
              ],
            ),
          ),
          AbsorbPointer(
            absorbing: !ledState,
            child: Row(
              children: [
                Text(
                  "Brightness",
                  style: _tStyle,
                ),
                Slider(
                  value: currentBrightness,
                  onChanged: _brightnessChange,
                  max: 10,
                  divisions: 10,
                  label: currentBrightness.toString(),
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}
