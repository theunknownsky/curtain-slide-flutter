import 'package:curtainslide/homePage.dart';
import 'package:flutter/material.dart';
import 'loginPage.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'package:firebase_auth/firebase_auth.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const CurtainSlideApp());
}

class CurtainSlideApp extends StatelessWidget {
  const CurtainSlideApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: BufferPage(),
    );
  }
}

class BufferPage extends StatefulWidget {
  const BufferPage({super.key});

  @override
  State<BufferPage> createState() => _BufferPageState();
}

class _BufferPageState extends State<BufferPage> {
  bool isLoggedIn() {
    final user = FirebaseAuth.instance.currentUser;
    return user != null;
  }

  @override
  Widget build(BuildContext context) {
    // Navigate to either home or login page based on user state
    if (isLoggedIn()) {
      return HomePage();
    } else {
      return LoginPage();
    }

  }
}
