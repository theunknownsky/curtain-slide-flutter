import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class LEDWidget extends StatefulWidget {
  const LEDWidget({super.key, required this.ledState, required this.currentBrightness, required this.selectedColor});

  final bool ledState; // to be changed from firebase
  final double currentBrightness;
  final ColorLabel? selectedColor;

  @override
  State<LEDWidget> createState() => _LEDWidgetState(ledState: this.ledState, currentBrightness: this.currentBrightness, selectedColor: this.selectedColor);
}

enum ColorLabel {
  red('Red', Colors.red),
  orange('Orange', Colors.orange),
  yellow('Yellow', Colors.yellow),
  green('Green', Colors.green),
  blue('Blue', Colors.blue),
  indigo('Indigo', Colors.indigo),
  violet('Violet', Color.fromARGB(255, 255, 0, 255));

  const ColorLabel(this.label, this.color);
  final String label;
  final Color color;
}

class _LEDWidgetState extends State<LEDWidget> {
  _LEDWidgetState({required this.ledState, required this.currentBrightness, required this.selectedColor});


  final TextStyle _tStyle = TextStyle(fontSize: 22);
  TextEditingController colorController = TextEditingController();
  bool ledState; // to be changed from firebase
  double currentBrightness;
  ColorLabel? selectedColor;
  void _ledChange(bool value) {
    setState(() {
      ledState = value;
      print("Current LED State: ${ledState}");
    });
    FirebaseFirestore.instance
        .collection('users') // Replace with your collection name
        .doc(FirebaseAuth.instance.currentUser!.uid) // Get the current user's ID
        .update({'ledInfo.ledState': ledState});
  }

  void _brightnessChange(double value) {
    setState(() {
      currentBrightness = value;
      print("Current brightness: ${currentBrightness}");
    });
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
                DropdownMenu<ColorLabel>(
                  initialSelection: ColorLabel.green,
                  controller: colorController,
                  // requestFocusOnTap is enabled/disabled by platforms when it is null.
                  // On mobile platforms, this is false by default. Setting this to true will
                  // trigger focus request on the text field and virtual keyboard will appear
                  // afterward. On desktop platforms however, this defaults to true.
                  requestFocusOnTap: true,
                  label: const Text('Color'),
                  onSelected: (ColorLabel? color) {
                    setState(() {
                      selectedColor = color;
                      print(selectedColor);
                    });
                  },
                  dropdownMenuEntries: ColorLabel.values
                      .map<DropdownMenuEntry<ColorLabel>>((ColorLabel color) {
                    return DropdownMenuEntry<ColorLabel>(
                      value: color,
                      label: color.label,
                      enabled: color.label != 'Grey',
                      style: MenuItemButton.styleFrom(
                        foregroundColor: color.color,
                      ),
                    );
                  }).toList(),
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
