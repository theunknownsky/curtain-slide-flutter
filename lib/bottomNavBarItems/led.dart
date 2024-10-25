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
  TextEditingController colorController = TextEditingController();
  bool ledState = false;
  double currentBrightness = 1;
  String selectedColor = '';
  String selectedColorValue = '';

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
        print("LED State: $ledState");
        print("LED Color: $selectedColor");
        print("LED Brightness: $currentBrightness");
      });
    } else {
      // Handle the case where the document doesn't exist
      print('Document does not exist');
    }
  }

  @override
  void initState() {
    super.initState();
    _fetchLedInfo();
    print("LED Info");
  }

  void _ledChange(bool value) {
    setState(() {
      ledState = value;
      print("Current LED State: $ledState");
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
      print("Current brightness: $currentBrightness");
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
        ],
      ),
    );
  }
}
