import 'package:flutter/material.dart';

class AccountWidget extends StatefulWidget {
  const AccountWidget({super.key});

  @override
  State<AccountWidget> createState() => _AccountWidgetState();
}

class _AccountWidgetState extends State<AccountWidget> {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text(
        "This is the Account Body",
        style: TextStyle(
          fontSize: 30,
        ),
      ),
    );
  }
}