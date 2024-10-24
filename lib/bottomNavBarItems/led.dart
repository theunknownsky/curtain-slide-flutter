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
                    )
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
                      child: DropdownMenu<String>(
                        initialSelection: "Test 1",
                        onSelected: (value) {
                          _colorChange(value!);
                        },
                        dropdownMenuEntries: [
                          DropdownMenuEntry(value: "Red-FF0000", label: "Red", style: ButtonStyle(foregroundColor: WidgetStatePropertyAll(Colors.white))),
                          DropdownMenuEntry(
                              value: "Orange-FFA500", label: "Orange", style: ButtonStyle(foregroundColor: WidgetStatePropertyAll(Colors.white))),
                          DropdownMenuEntry(
                              value: "Yellow-FFFF00", label: "Yellow", style: ButtonStyle(foregroundColor: WidgetStatePropertyAll(Colors.white))),
                          DropdownMenuEntry(
                              value: "Green-008000", label: "Green", style: ButtonStyle(foregroundColor: WidgetStatePropertyAll(Colors.white))),
                          DropdownMenuEntry(
                              value: "Blue-0000FF", label: "Blue", style: ButtonStyle(foregroundColor: WidgetStatePropertyAll(Colors.white))),
                          DropdownMenuEntry(
                              value: "Indigo-4B0082", label: "Indigo", style: ButtonStyle(foregroundColor: WidgetStatePropertyAll(Colors.white))),
                          DropdownMenuEntry(
                              value: "Violet-EE82EE", label: "Violet", style: ButtonStyle(foregroundColor: WidgetStatePropertyAll(Colors.white))),
                        ],
                        hintText: selectedColor,
                        inputDecorationTheme: InputDecorationTheme(
                          fillColor: Color(0xFF383838),
                          filled: true,
                          hintStyle: TextStyle(
                            color: Colors.white,
                            fontSize: 20,
                          ),
                          contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 4)
                        ),
                        menuStyle: MenuStyle(
                          backgroundColor: WidgetStatePropertyAll(Color(0xFF383838)),
                          padding: WidgetStatePropertyAll(EdgeInsets.fromLTRB(4, 4, 4, 4)),
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
