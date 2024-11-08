import 'dart:ui';
import 'package:curtainslide/bottomNavBarItems/account.dart';
import 'package:curtainslide/bottomNavBarItems/addSchedule.dart';
import 'package:curtainslide/bottomNavBarItems/curtain.dart';
import 'package:curtainslide/bottomNavBarItems/led.dart';
import 'package:curtainslide/bottomNavBarItems/schedule.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';

Future<void> initUserBox() async {
  await Hive.initFlutter();
  Future<bool> boxExist =
      Hive.boxExists(FirebaseAuth.instance.currentUser!.uid);
  if (!(await boxExist)) {
    await Hive.openBox(FirebaseAuth.instance.currentUser!.uid);
    final userBox = Hive.box(FirebaseAuth.instance.currentUser!.uid);
    Map<String, dynamic> ledInfo = {
      'ledStatus': true,
      'ledColor': 'Red',
      'ledColorValue': 'FF0000',
      'ledBrightness': 5.0
    };
    userBox.put('ledInfo', ledInfo);
    userBox.put('curtainState', 1);
    userBox.put('email', FirebaseAuth.instance.currentUser!.email);
    userBox.put('schedules', []);
    print("Init Box: ${userBox.values}");
  } else {
    await Hive.openBox(FirebaseAuth.instance.currentUser!.uid);
  }
}

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _selectedIndex = 0;
  bool _onAddSched = false;

  @override
  void initState() {
    super.initState();
    initUserBox();
  }

  void _onBotNavBarItemTapped(int index) async {
    setState(() {
      if (index >= 0 && index <= 3) {
        _selectedIndex = index;
        _onAddSched = false;
        _selectedBotNavBarItem();
      } else {
        _onAddSched = true;
        _selectedBotNavBarItem();
      }
    });
    if (index == 0) {
      print("Schedule selected");
    } else if (index == 1) {
      print("LED selected");
    } else if (index == 2) {
      print("Curtain selected");
    } else if (index == 3) {
      print("Account selected.");
    }

    if (_onAddSched) {
      print("Add Schedule selected");
    } else {
      setState(() {
        _onAddSched = false;
      });
    }
  }

  void _addSchedule() {
    setState(() {
      _onAddSched == true;
      _onBotNavBarItemTapped(4);
    });
  }

  String appBarTitle = "CurtainSlide/Schedule";
  void _selectedBotNavBarItem() {
    setState(() {
      if (_selectedIndex == 0) {
        appBarTitle = "CurtainSlide/Schedule";
      } else if (_selectedIndex == 1) {
        appBarTitle = "CurtainSlide/LED";
      } else if (_selectedIndex == 2) {
        appBarTitle = "CurtainSlide/Curtain";
      } else if (_selectedIndex == 3) {
        appBarTitle = "CurtainSlide/Account";
      }
      if (_onAddSched) {
        appBarTitle = "CurtainSlide/Schedule/Add";
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: (_onAddSched)
            ? IconButton(
                icon: const Icon(Icons.arrow_back),
                onPressed: () {
                  setState(() {
                    _onAddSched = false;
                  });
                  _onBotNavBarItemTapped(0);
                },
              )
            : null,
        backgroundColor: const Color(0xFF191919),
        title: Text(
          appBarTitle,
          style: const TextStyle(fontFamily: 'Inter'),
        ),
        foregroundColor: Colors.white,
      ),
      body: SizedBox.expand(
        child: Container(
          color: const Color(0xFF383838),
          child: (_onAddSched == true)
              ? const AddScheduleWidget()
              : (_selectedIndex == 0)
                  ? const ScheduleWidget()
                  : (_selectedIndex == 1)
                      ? const LEDWidget()
                      : (_selectedIndex == 2)
                          ? const CurtainWidget()
                          : const AccountWidget(),
        ),
      ),
      floatingActionButton: (_selectedIndex == 0 && !_onAddSched)
          ? FloatingActionButton(
              onPressed: _addSchedule,
              tooltip: 'Add Schedule',
              backgroundColor: const Color(0xFF737373),
              foregroundColor: Colors.white,
              shape: const CircleBorder(eccentricity: 0.0),
              child: const Icon(Icons.add),
            )
          : null,
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        backgroundColor: const Color(0xFF191919),
        selectedItemColor: Colors.white,
        unselectedItemColor: Colors.grey,
        selectedLabelStyle: const TextStyle(
          fontFamily: 'Inter',
        ),
        unselectedLabelStyle: const TextStyle(
          fontFamily: 'Inter',
        ),
        items: const [
          BottomNavigationBarItem(
            label: "Schedule",
            icon: Icon(Icons.timer),
          ),
          BottomNavigationBarItem(
            label: "LED",
            icon: Icon(Icons.light_mode_outlined),
          ),
          BottomNavigationBarItem(
            label: "Curtain",
            icon: Icon(Icons.curtains),
          ),
          BottomNavigationBarItem(
            label: "Account",
            icon: Icon(Icons.person),
          ),
        ],
        currentIndex: _selectedIndex,
        onTap: _onBotNavBarItemTapped,
      ),
    );
  }
}