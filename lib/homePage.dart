import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:curtainslide/bottomNavBarItems/account.dart';
import 'package:curtainslide/bottomNavBarItems/curtain.dart';
import 'package:curtainslide/bottomNavBarItems/led.dart';
import 'package:curtainslide/bottomNavBarItems/schedule.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

// Schedule data
List<Widget> _listOfSchedule = [];

// LED data
bool ledState = false;
double currentBrightness = 5;
ColorLabel? selectedColor;

class _HomePageState extends State<HomePage> {
  int _selectedIndex = 0;

  Future<Map<String, dynamic>>? ledInfo;

  TextStyle _schedTextStyle = TextStyle(
    fontSize: 30,
    fontWeight: FontWeight.bold,
  );

  Future<Map<String, dynamic>> getLedInfo() async {
    DocumentSnapshot<Map<String, dynamic>> doc = await FirebaseFirestore
        .instance
        .collection('users')
        .doc(FirebaseAuth.instance.currentUser?.uid)
        .get();
    return doc.data()?['ledInfo'];
  }

  void _onBotNavBarItemTapped (int index) async {
    setState(() {
      _selectedIndex = index;
      _selectedBotNavBarItem();
    });
    if (index == 0) {
      print("Schedule selected");
    } else if (index == 1) {
      print("LED selected");
      ledInfo = getLedInfo();
      print(ledInfo);
    } else if (index == 2) {
      print("Curtain selected");
    } else if (index == 3){
      print("Account selected.");
    }
  }

  void _addSchedule(){
    setState(() {
      _listOfSchedule.add(
        InkWell(
          onTap: () {},
          child: Card(
            child: Container(
              child: Column(
                children: [
                  Text(
                    "Time: ",
                    style: _schedTextStyle,
                  ),
                  Row(
                    children: [
                      Text("LED Color: "),
                      Text("Blue"),
                    ],
                  ),
                  Row(
                    children: [
                      Text("Curtain Mode: "),
                      Text("Closed"),
                    ],
                  ),
                ],
                crossAxisAlignment: CrossAxisAlignment.start,
              ),
              margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              alignment: Alignment.centerLeft,
            ),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(10)),
            ),
            color: const Color.fromARGB(255, 201, 201, 201),
          ),
        ),
      );
    });
  }
  
  String appBarTitle = "CurtainSlide/Schedule";
  void _selectedBotNavBarItem(){
    setState(() {
      if (_selectedIndex == 0){
        appBarTitle = "CurtainSlide/Schedule";
      } else if (_selectedIndex == 1){
        appBarTitle = "CurtainSlide/LED";
      } else if (_selectedIndex == 2){
        appBarTitle = "CurtainSlide/Curtain";
      } else if (_selectedIndex == 3){
        appBarTitle = "CurtainSlide/Account";
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: Text(appBarTitle),
        foregroundColor: Colors.white,
      ),
      body: (_selectedIndex == 0) ? ScheduleWidget(listOfSched: _listOfSchedule,) :
            (_selectedIndex == 1) ? LEDWidget(ledState: ledState, currentBrightness: currentBrightness, selectedColor: selectedColor,) :
            (_selectedIndex == 2) ? CurtainWidget() :
            AccountWidget() 
      ,
      floatingActionButton: (_selectedIndex == 0) ? FloatingActionButton(
        onPressed: _addSchedule, // _addSchedule
        tooltip: 'Add Schedule',
        child: const Icon(Icons.add),
        backgroundColor: Colors.black,
        foregroundColor: Colors.white,
        shape: CircleBorder(eccentricity: 0.0),
      ) : null,
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        backgroundColor: Colors.black,
        selectedItemColor: Colors.white,
        unselectedItemColor: Colors.grey,
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