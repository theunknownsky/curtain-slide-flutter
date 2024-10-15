import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<Widget> _listOfSchedule = [];
  int _selectedIndex = 0;

  TextStyle _schedTextStyle = TextStyle(
    fontSize: 30,
    fontWeight: FontWeight.bold,
  );

  void _onBotNavBarItemTapped(int index){
    setState(() {
      _selectedIndex = index;
    });

    if (index == 0) {
      print("Schedule selected");
    } else if (index == 1) {
      print("LED selected");
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: const Text("CurtainSlide - Schedule"),
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: _listOfSchedule, // _listItems
        ),
        padding: EdgeInsets.symmetric(vertical: 2.0),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _addSchedule, // _addSchedule
        tooltip: 'Add Schedule',
        child: const Icon(Icons.add),
        backgroundColor: Colors.black,
        foregroundColor: Colors.white,
        shape: CircleBorder(eccentricity: 0.0),
      ),
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
