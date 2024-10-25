import 'dart:ui';

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
  TextStyle actionTitleStyle = TextStyle(
    fontSize: 28,
    color: Colors.white,
    fontFamily: 'Inter',
  );
  TextStyle actionDescriptionStyle = TextStyle(
    fontSize: 16,
    color: Colors.white,
    fontFamily: 'Inter',
  );
  TextStyle delayTextStyle = TextStyle(
    fontSize: 22,
    color: Colors.white,
    fontFamily: 'Inter',
  );
  TextStyle notifStyle = TextStyle(
    fontFamily: 'Inter',
  );

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
              Container(
                child: CircularProgressIndicator(
                  color: Colors.white,
                ),
                margin: EdgeInsets.only(bottom: 12),
              ),
              Text(
                "Curtain operation in progress.",
                style: delayTextStyle,
              ),
              Text(
                "Please standby.",
                style: delayTextStyle,
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
          Container(
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "Auto Close",
                      style: actionTitleStyle,
                    ),
                    FilledButton.icon(
                      label: Text("Close"),
                      onPressed: () {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text("Closing curtain...", style: notifStyle,),
                            duration: Duration(seconds: delay),
                          ),
                        );
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
                        backgroundColor:
                            WidgetStatePropertyAll(Color(0xFF383838)),
                        shape: WidgetStatePropertyAll(
                          RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        textStyle: WidgetStatePropertyAll(
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
                  margin: EdgeInsets.only(top: 8),
                  child: Row(
                    children: [
                      Text(
                        "Automatically closes the curtain.",
                        style: actionDescriptionStyle,
                      ),
                    ],
                  ),
                ),
              ],
            ),
            margin: EdgeInsets.fromLTRB(24, 16, 24, 0),
            padding: EdgeInsets.all(16),
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
                      "Auto Open",
                      style: actionTitleStyle,
                    ),
                    FilledButton.icon(
                      label: Text("Open"),
                      onPressed: () {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text("Opening curtain...", style: notifStyle,),
                            duration: Duration(seconds: delay),
                          ),
                        );
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
                        backgroundColor:
                            WidgetStatePropertyAll(Color(0xFF383838)),
                        shape: WidgetStatePropertyAll(
                          RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        textStyle: WidgetStatePropertyAll(
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
                  margin: EdgeInsets.only(top: 8),
                  child: Row(
                    children: [
                      Text(
                        "Automatically opens the curtain.",
                        style: actionDescriptionStyle,
                      ),
                    ],
                  ),
                ),
              ],
            ),
            margin: EdgeInsets.fromLTRB(24, 16, 24, 0),
            padding: EdgeInsets.all(16),
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
                      "Manual Close",
                      style: actionTitleStyle,
                    ),
                    GestureDetector(
                      child: FilledButton.icon(
                        label: Text("Close"),
                        onPressed: () {},
                        style: ButtonStyle(
                          backgroundColor:
                              WidgetStatePropertyAll(Color(0xFF383838)),
                          shape: WidgetStatePropertyAll(
                            RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                          textStyle: WidgetStatePropertyAll(
                            TextStyle(
                              fontFamily: 'Inter',
                              fontSize: 18,
                            ),
                          ),
                        ),
                      ),
                      onLongPress: () {
                        _curtainStateChange(0);
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text("Closing curtain...", style: notifStyle,),
                            duration: Duration(seconds: 1),
                          ),
                        );
                      },
                      onLongPressUp: () {
                        _curtainStateChange(1);
                      },
                    ),
                  ],
                ),
                Container(
                  margin: EdgeInsets.only(top: 8),
                  child: Row(
                    children: [
                      Text(
                        "Hold to button to manually\nclose the curtain.",
                        style: actionDescriptionStyle,
                      ),
                    ],
                  ),
                ),
              ],
            ),
            margin: EdgeInsets.fromLTRB(24, 16, 24, 0),
            padding: EdgeInsets.all(16),
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
                      "Manual Open",
                      style: actionTitleStyle,
                    ),
                    GestureDetector(
                      child: FilledButton.icon(
                        label: Text("Open"),
                        onPressed: () {},
                        style: ButtonStyle(
                          backgroundColor:
                              WidgetStatePropertyAll(Color(0xFF383838)),
                          shape: WidgetStatePropertyAll(
                            RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                          textStyle: WidgetStatePropertyAll(
                            TextStyle(
                              fontFamily: 'Inter',
                              fontSize: 18,
                            ),
                          ),
                        ),
                      ),
                      onLongPress: () {
                        _curtainStateChange(2);
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text("Opening curtain...", style: notifStyle,),
                            duration: Duration(seconds: 1),
                          ),
                        );
                      },
                      onLongPressUp: () {
                        _curtainStateChange(1);
                      },
                    ),
                  ],
                ),
                Container(
                  margin: EdgeInsets.only(top: 8),
                  child: Row(
                    children: [
                      Text(
                        "Hold to button to manually\nopen the curtain.",
                        style: actionDescriptionStyle,
                      ),
                    ],
                  ),
                ),
              ],
            ),
            margin: EdgeInsets.fromLTRB(24, 16, 24, 0),
            padding: EdgeInsets.all(16),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              color: Color(0xFF191919),
            ),
          ),
        ],
      ),
    );
  }
}
