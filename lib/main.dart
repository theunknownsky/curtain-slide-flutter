import 'dart:async';
import 'dart:ui';

import 'package:curtainslide/homePage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_background_service/flutter_background_service.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'loginPage.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'package:firebase_auth/firebase_auth.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const CurtainSlideApp());
}

Future<void> initializeService() async {
  final service = FlutterBackgroundService();

  await service.configure(
    iosConfiguration: IosConfiguration(
      autoStart: true,
      onForeground: onStart,
      onBackground: onIosBackground,
    ),
    androidConfiguration: AndroidConfiguration(
      autoStart: true,
      onStart: onStart,
      isForegroundMode: false,
      autoStartOnBoot: true,
    ),
  );
}

@pragma('vm:entry-point')
Future<bool> onIosBackground(ServiceInstance service) async {
  WidgetsFlutterBinding.ensureInitialized();
  DartPluginRegistrant.ensureInitialized();

  return true;
}

void onStart(ServiceInstance service) async {
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  await Hive.initFlutter();
  if(isLoggedIn()){
    doScheduleBackgroundTask();
  }
}

void doScheduleBackgroundTask() async {
  Timer.periodic(const Duration(seconds: 5), (timer) async {
    await Hive.openBox(FirebaseAuth.instance.currentUser!.uid);
    final userBox = Hive.box(FirebaseAuth.instance.currentUser!.uid);
    List<dynamic> schedules = userBox.get('schedules');
    for (int i = 0; i < schedules.length; i++) {
      String timeStr = schedules[i]['time'];
      var parts = timeStr.split(':');
      var hour = int.parse(parts[0]);
      var minute = int.parse(parts[1]);
      var timeSchedStr = TimeOfDay(hour: hour, minute: minute);
      if (timeSchedStr == TimeOfDay.now()) {
        print(schedules[i]);
        break;
      }
    }
  });
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

bool isLoggedIn() {
  final user = FirebaseAuth.instance.currentUser;
  return user != null;
}

class _BufferPageState extends State<BufferPage> {
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
      userBox.put('schedules', {});
    } else {
      await Hive.openBox(FirebaseAuth.instance.currentUser!.uid);
    }
  }

  @override
  Widget build(BuildContext context) {
    // Navigate to either home or login page based on user state
    if (isLoggedIn()) {
      initUserBox();
      initializeService();
      return const HomePage();
    } else {
      return const LoginPage();
    }
  }
}
