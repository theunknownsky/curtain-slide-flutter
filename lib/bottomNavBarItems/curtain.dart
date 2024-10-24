import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'dart:async';

class CurtainWidget extends StatefulWidget {
  const CurtainWidget({super.key});

  @override
  State<CurtainWidget> createState() => _CurtainWidgetState();
}

class _CurtainWidgetState extends State<CurtainWidget> {
  final TextStyle _tStyle = TextStyle(fontSize: 22);

  int delay = 5; // full open or close

  bool actionBlock = false;

  void _curtainStateChange(int curtainMoveState) {
    FirebaseFirestore.instance
        .collection('users') // Replace with your collection name
        .doc(
            FirebaseAuth.instance.currentUser!.uid) // Get the current user's ID
        .update({'curtainState': curtainMoveState});
  }

  @override
  Widget build(BuildContext context) {
    if (actionBlock) {
      return AbsorbPointer(
        child: Center(
          child: Column(
            children: [
              CircularProgressIndicator(),
              Text(
                "Curtain operation in progress.",
                style: _tStyle,
              )
            ],
            mainAxisAlignment: MainAxisAlignment.center,
          ),
        ),
      );
    }
    _curtainStateChange(1);
    return SingleChildScrollView(
      child: Column(
        children: [
          Row(
            children: [
              Text(
                "Close Curtain",
                style: _tStyle,
              ),
              FilledButton.icon(
                label: Row(
                  children: [Icon(Icons.curtains_closed), Text("Close")],
                ),
                onPressed: () {
                  setState(() {
                    actionBlock = true;
                  });
                  _curtainStateChange(0);
                  Timer(Duration(seconds: delay), () {
                    setState(() {
                      actionBlock = false;
                    });
                  });
                },
                style: ButtonStyle(
                  backgroundColor: WidgetStatePropertyAll(Colors.black),
                ),
              )
            ],
          ),
          Row(
            children: [
              Text(
                "Open Curtain",
                style: _tStyle,
              ),
              FilledButton.icon(
                label: Row(
                  children: [Icon(Icons.curtains), Text("Open")],
                ),
                onPressed: () {
                  setState(() {
                    actionBlock = true;
                  });
                  _curtainStateChange(2);
                  Timer(Duration(seconds: delay), () {
                    setState(() {
                      actionBlock = false;
                    });
                  });
                },
                style: ButtonStyle(
                  backgroundColor: WidgetStatePropertyAll(Colors.black),
                ),
              )
            ],
          ),
          Row(
            children: [
              Text(
                "Manually Close Curtain",
                style: _tStyle,
              ),
              GestureDetector(
                child: FilledButton.icon(
                  onPressed: () {},
                  label: Row(
                    children: [
                      Icon(Icons.curtains_closed),
                      Text("Close"),
                    ],
                  ),
                  style: ButtonStyle(
                    backgroundColor: WidgetStatePropertyAll(Colors.black),
                  ),
                ),
                onLongPressDown: (_) => _curtainStateChange(0),
                onLongPressEnd: (_) => _curtainStateChange(1),
              ),
            ],
          ),
          Row(
            children: [
              Text(
                "Manually Open Curtain",
                style: _tStyle,
              ),
              GestureDetector(
                child: FilledButton.icon(
                  onPressed: () {},
                  label: Row(
                    children: [
                      Icon(Icons.curtains),
                      Text("Open"),
                    ],
                  ),
                  style: ButtonStyle(
                    backgroundColor: WidgetStatePropertyAll(Colors.black),
                  ),
                ),
                onLongPressDown: (_) => _curtainStateChange(2),
                onLongPressEnd: (_) => _curtainStateChange(1),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
