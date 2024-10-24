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

  final TextStyle _tStyle = TextStyle(
    fontSize: 22,
  );
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
          Container(
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "LED",
                      style: TextStyle(
                        fontSize: 32,
                        color: Colors.white,
                      ),
                    ),
                    Switch(
                      value: ledState,
                      activeColor: Color(0xFFd9d9d9),
                      activeTrackColor: Color(0xFF737373),
                      inactiveThumbColor: Color(0xFF191919),
                      inactiveTrackColor: Color(0xFF383838),
                      onChanged: _ledChange,
                    ),
                  ],
                ),
                Container(
                  margin: EdgeInsets.only(top: 8),
                  child: Row(
                    children: [
                      Text(
                        "Turns the LED on or off.",
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            margin: EdgeInsets.fromLTRB(24, 16, 24, 0),
            padding: EdgeInsets.symmetric(vertical: 16, horizontal: 24),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              color: Color(0xFF191919),
            ),
          ),
          Container(
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "Color",
                      style: TextStyle(
                        fontSize: 32,
                        color: Colors.white,
                      ),
                    ),
                    AbsorbPointer(
                      absorbing: !ledState,
                      child: Container(
                        decoration: BoxDecoration(
                          color: Color(0xFF383838),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        padding: EdgeInsets.fromLTRB(16, 0, 16, 0),
                        child: DropdownButton<String>(
                          hint: Text(
                            selectedColor,
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 18,
                            ),
                          ),
                          style: TextStyle(fontSize: 16),
                          dropdownColor: Color(0xFF383838),
                          iconSize: 36,
                          borderRadius: BorderRadius.circular(10),
                          onChanged: (String? value) {
                            _colorChange(value!);
                            print(value);
                          },
                          items: [
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
                  margin: EdgeInsets.only(top: 16),
                  child: Row(
                    children: [
                      Text(
                        "Selects the color of the LED.\nOnly available if LED is on.",
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            margin: EdgeInsets.fromLTRB(24, 16, 24, 0),
            padding: EdgeInsets.symmetric(vertical: 16, horizontal: 24),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              color: Color(0xFF191919),
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
