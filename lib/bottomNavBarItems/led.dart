import 'package:flutter/material.dart';

class LEDWidget extends StatefulWidget {
  const LEDWidget({super.key});

  @override
  State<LEDWidget> createState() => _LEDWidgetState();
}

class _LEDWidgetState extends State<LEDWidget> {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text(
        "This is the LED Body",
        style: TextStyle(
          fontSize: 30,
        ),
      ),
    );
  }
}