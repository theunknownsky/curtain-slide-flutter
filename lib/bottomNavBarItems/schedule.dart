import 'package:flutter/material.dart';

class ScheduleWidget extends StatefulWidget {
  const ScheduleWidget({super.key, required this.listOfSched});
  
  final List<Widget> listOfSched;

  @override
  State<ScheduleWidget> createState() => _ScheduleWidgetState();
}

class _ScheduleWidgetState extends State<ScheduleWidget> {

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: widget.listOfSched, // _listItems
      ),
      padding: EdgeInsets.symmetric(vertical: 2.0),
    );
  }
}