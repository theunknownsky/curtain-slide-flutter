import 'package:curtainslide/homePage.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:path_provider/path_provider.dart';
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

  Future<void> initUserBox() async {
    await Hive.initFlutter();
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
    userBox.put('schedules', {});
  }

  @override
  Widget build(BuildContext context) {
    // Navigate to either home or login page based on user state
    if (isLoggedIn()) {
      initUserBox();
      return const HomePage();
    } else {
      return const LoginPage();
    }
  }
}
