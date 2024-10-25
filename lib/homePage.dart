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

  final TextStyle _schedTextStyle = const TextStyle(
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
            shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(10)),
            ),
            color: const Color.fromARGB(255, 201, 201, 201),
            child: Container(
              margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              alignment: Alignment.centerLeft,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Time: ",
                    style: _schedTextStyle,
                  ),
                  const Row(
                    children: [
                      Text("LED Color: "),
                      Text("Blue"),
                    ],
                  ),
                  const Row(
                    children: [
                      Text("Curtain Mode: "),
                      Text("Closed"),
                    ],
                  ),
                ],
              ),
            ),
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
          child: (_selectedIndex == 0)
              ? ScheduleWidget(
                  listOfSched: _listOfSchedule,
                )
              : (_selectedIndex == 1)
                  ? const LEDWidget()
                  : (_selectedIndex == 2)
                      ? const CurtainWidget()
                      : const AccountWidget(),
        ),
      ),
      floatingActionButton: (_selectedIndex == 0)
          ? FloatingActionButton(
              onPressed: _addSchedule, // _addSchedule
              tooltip: 'Add Schedule',
              backgroundColor: const Color(0xFF191919),
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
