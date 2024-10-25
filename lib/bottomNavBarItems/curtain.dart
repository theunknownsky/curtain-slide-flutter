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
  TextStyle delayTextStyle = const TextStyle(
    fontSize: 22,
    color: Colors.white,
    fontFamily: 'Inter',
  );
  TextStyle notifStyle = const TextStyle(
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
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                margin: const EdgeInsets.only(bottom: 12),
                child: const CircularProgressIndicator(
                  color: Colors.white,
                ),
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
          ),
        ),
      );
    }
    _curtainStateChange(1);
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
                      "Auto Close",
                      style: actionTitleStyle,
                    ),
                    FilledButton.icon(
                      label: const Text("Close"),
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
                      "Auto Open",
                      style: actionTitleStyle,
                    ),
                    FilledButton.icon(
                      label: const Text("Open"),
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
                      "Manual Close",
                      style: actionTitleStyle,
                    ),
                    GestureDetector(
                      child: FilledButton.icon(
                        label: const Text("Close"),
                        onPressed: () {},
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
                      onLongPress: () {
                        _curtainStateChange(0);
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text("Closing curtain...", style: notifStyle,),
                            duration: const Duration(seconds: 1),
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
                  margin: const EdgeInsets.only(top: 8),
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
                      "Manual Open",
                      style: actionTitleStyle,
                    ),
                    GestureDetector(
                      child: FilledButton.icon(
                        label: const Text("Open"),
                        onPressed: () {},
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
                      onLongPress: () {
                        _curtainStateChange(2);
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text("Opening curtain...", style: notifStyle,),
                            duration: const Duration(seconds: 1),
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
                  margin: const EdgeInsets.only(top: 8),
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
          ),
        ],
      ),
    );
  }
}
