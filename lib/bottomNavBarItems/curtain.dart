import 'package:flutter/material.dart';

class CurtainWidget extends StatefulWidget {
  const CurtainWidget({super.key});

  @override
  State<CurtainWidget> createState() => _CurtainWidgetState();
}

class _CurtainWidgetState extends State<CurtainWidget> {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text(
        "This is the Curtain Body",
        style: TextStyle(
          fontSize: 30,
        ),
      ),
    );
  }
}