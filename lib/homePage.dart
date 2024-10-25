import 'package:curtainslide/bottomNavBarItems/account.dart';
import 'package:curtainslide/bottomNavBarItems/curtain.dart';
import 'package:curtainslide/bottomNavBarItems/led.dart';
import 'package:curtainslide/bottomNavBarItems/schedule.dart';
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
String selectedColor = "";

class _HomePageState extends State<HomePage> {
  int _selectedIndex = 0;

  Future<Map<String, dynamic>>? ledInfo;

  TextStyle _schedTextStyle = TextStyle(
    fontSize: 30,
    fontWeight: FontWeight.bold,
  );

  void _onBotNavBarItemTapped(int index) async {
    setState(() {
      _selectedIndex = index;
      _selectedBotNavBarItem();
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
  }

  void _addSchedule() {
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
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xFF191919),
        title: Text(
          appBarTitle,
          style: TextStyle(fontFamily: 'Inter'),
        ),
        foregroundColor: Colors.white,
      ),
      body: SizedBox.expand(
        child: Container(
          child: (_selectedIndex == 0)
              ? ScheduleWidget(
                  listOfSched: _listOfSchedule,
                )
              : (_selectedIndex == 1)
                  ? LEDWidget()
                  : (_selectedIndex == 2)
                      ? CurtainWidget()
                      : AccountWidget(),
          color: Color(0xFF383838),
        ),
      ),
      floatingActionButton: (_selectedIndex == 0)
          ? FloatingActionButton(
              onPressed: _addSchedule, // _addSchedule
              tooltip: 'Add Schedule',
              child: const Icon(Icons.add),
              backgroundColor: Color(0xFF191919),
              foregroundColor: Colors.white,
              shape: CircleBorder(eccentricity: 0.0),
            )
          : null,
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        backgroundColor: Color(0xFF191919),
        selectedItemColor: Colors.white,
        unselectedItemColor: Colors.grey,
        selectedLabelStyle: TextStyle(
          fontFamily: 'Inter',
        ),
        unselectedLabelStyle: TextStyle(
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
