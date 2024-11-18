import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'dart:async';
import 'package:hive_flutter/hive_flutter.dart';

class CurtainWidget extends StatefulWidget {
  const CurtainWidget({super.key});

  @override
  State<CurtainWidget> createState() => _CurtainWidgetState();
}

class _CurtainWidgetState extends State<CurtainWidget> {
  final userBox = Hive.box(FirebaseAuth.instance.currentUser!.uid);

  late String userId;
  late DatabaseReference curtainStateRef;
  late bool isCurtainAlreadyClosed;
  late bool isCurtainAlreadyOpened;

  void initState() {
    super.initState();
    userId = FirebaseAuth.instance.currentUser!.uid;
    curtainStateRef =
        FirebaseDatabase.instance.ref('users/$userId/curtainState');
    checkIfAlreadyClosed();
    checkIfAlreadyOpened();
  }

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

  Future<void> updateCurtainState(int newCurtainState) async {
    try {
      await curtainStateRef.set(newCurtainState);
    } catch (e) {
      print(e);
    }
  }

  int delay = 5; // full open or close

  bool actionBlock = false;

  void _curtainStateChange(int curtainMoveState) {
    _manualCurtainStateChange(curtainMoveState);
    updateCurtainState(curtainMoveState);
  }

  void checkIfAlreadyClosed() async {
    DatabaseReference isCurtainClosedRef =
        FirebaseDatabase.instance.ref('users/$userId/isCurtainClosed');
    isCurtainClosedRef.onValue.listen((event) {
      final data = event.snapshot.value;
      if (data != null) {
        if (data is bool) {
          setState(() {
            isCurtainAlreadyClosed = data;
            if (isCurtainAlreadyClosed) {
              actionBlock = false;
              _manualCurtainStateChange(1);
            }
          });
        }
      }
    });
  }

  void checkIfAlreadyOpened() async {
    DatabaseReference isCurtainOpenedRef =
        FirebaseDatabase.instance.ref('users/$userId/isCurtainOpened');
    isCurtainOpenedRef.onValue.listen((event) {
      final data = event.snapshot.value;
      if (data != null) {
        if (data is bool) {
          setState(() {
            isCurtainAlreadyOpened = data;
            if (isCurtainAlreadyOpened) {
              actionBlock = false;
              _manualCurtainStateChange(1);
            }
          });
        }
      }
    });
    final DatabaseEvent event = await isCurtainOpenedRef.once();
    final isCurtainOpened = event.snapshot.value;
    if (isCurtainOpened is bool) {
      setState(() {
        isCurtainAlreadyOpened = isCurtainOpened;
      });
    }
  }

  void _manualCurtainStateChange(int curtainMoveState) {
    setState(() {
      userBox.put('curtainState', curtainMoveState);
    });
    updateCurtainState(curtainMoveState);
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
                        if (!isCurtainAlreadyClosed) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text(
                                "Closing curtain...",
                                style: notifStyle,
                              ),
                              duration: Duration(seconds: delay),
                            ),
                          );
                          setState(() {
                            actionBlock = true;
                          });
                          _curtainStateChange(0);
                        } else {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text(
                                "Curtain is already closed.",
                                style: notifStyle,
                              ),
                              duration: const Duration(seconds: 3),
                            ),
                          );
                        }
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
                        if (!isCurtainAlreadyOpened) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text(
                                "Opening curtain...",
                                style: notifStyle,
                              ),
                              duration: Duration(seconds: delay),
                            ),
                          );
                          setState(() {
                            actionBlock = true;
                          });
                          _curtainStateChange(2);
                        } else {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text(
                                "Curtain is already opened.",
                                style: notifStyle,
                              ),
                              duration: const Duration(seconds: 3),
                            ),
                          );
                        }
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
                        if (!isCurtainAlreadyClosed) {
                          _manualCurtainStateChange(0);
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text(
                                "Closing curtain...",
                                style: notifStyle,
                              ),
                              duration: Duration(seconds: delay),
                            ),
                          );
                        } else {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text(
                                "Curtain is already closed.",
                                style: notifStyle,
                              ),
                              duration: Duration(seconds: delay),
                            ),
                          );
                        }
                      },
                      onLongPressUp: () {
                        _manualCurtainStateChange(1);
                        ScaffoldMessenger.of(context).hideCurrentSnackBar();
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
                        if (!isCurtainAlreadyOpened) {
                          _manualCurtainStateChange(2);
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text(
                                "Opening curtain...",
                                style: notifStyle,
                              ),
                              duration: Duration(seconds: delay),
                            ),
                          );
                        } else {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text(
                                "Curtain is already opened.",
                                style: notifStyle,
                              ),
                              duration: Duration(seconds: delay),
                            ),
                          );
                        }
                      },
                      onLongPressUp: () {
                        _manualCurtainStateChange(1);
                        ScaffoldMessenger.of(context).hideCurrentSnackBar();
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
