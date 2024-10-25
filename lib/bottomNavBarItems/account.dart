import 'package:curtainslide/loginPage.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AccountWidget extends StatefulWidget {
  const AccountWidget({super.key});

  @override
  State<AccountWidget> createState() => _AccountWidgetState();
}

class _AccountWidgetState extends State<AccountWidget> {
  String? getUserEmail() {
    final user = FirebaseAuth.instance.currentUser;
    return user?.email;
  }

  void signOutUser() async {
    await FirebaseAuth.instance.signOut();
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => const LoginPage()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            "Email: ${getUserEmail()}",
            style: const TextStyle(
              fontSize: 24,
            ),
          ),
          Container(
            margin: const EdgeInsets.only(top: 14),
            child: TextButton(
              onPressed: signOutUser,
              style: TextButton.styleFrom(
                backgroundColor: Colors.black,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8.0),
                ),
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
              ),
              child: const Text(
                "Log Out",
              ),
            ),
          ),
        ],
      ),
    );
  }
}
