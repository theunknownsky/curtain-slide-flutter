import 'dart:async';
import 'dart:ui';
import 'package:curtainslide/homePage.dart';
import 'package:firebase_database/firebase_database.dart';
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
  if (isLoggedIn()) {
    initializeService();
    FirebaseDatabase.instance.databaseURL =
        'https://curtainslide-test-default-rtdb.asia-southeast1.firebasedatabase.app';
  }
  runApp(const CurtainSlideApp());
}

Future<void> initializeService() async {
  final service = FlutterBackgroundService();
  service.startService();
  print("Initialize Service function used.");
  if(await service.isRunning()){
    print("BGServ now running.");
  }
  await service.configure(
    iosConfiguration: IosConfiguration(
      autoStart: false,
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

@pragma('vm:entry-point')
void onStart(ServiceInstance service) async {
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  await Hive.initFlutter();
  await Hive.openBox(FirebaseAuth.instance.currentUser!.uid);
  final userBox = Hive.box(FirebaseAuth.instance.currentUser!.uid);
  List<dynamic> schedules = userBox.get('schedules') ?? [];
  service.on("stop").listen((event) {
    service.stopSelf();
    print("background process is now stopped");
  });
  service.on("start").listen((event) {
    print("background process is now starting");
  });
  service.on("updateScheds").listen((event) async {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
    await Hive.initFlutter();
    await Hive.openBox(FirebaseAuth.instance.currentUser!.uid);
    final userBox = Hive.box(FirebaseAuth.instance.currentUser!.uid);
    schedules = userBox.get('schedules');
    timer?.cancel();
    startScheduleChecker(schedules);
  });
  startScheduleChecker(schedules);
}

Timer? timer;

void startScheduleChecker(List<dynamic> schedules) {
  print("Start schedule checker: $schedules");
  timer = Timer.periodic(const Duration(seconds: 5), (timer) async {
    for (int i = 0; i < schedules.length; i++) {
      String timeStr = schedules[i]['time'];
      var parts = timeStr.split(':');
      var hour = int.parse(parts[0]);
      var minute = int.parse(parts[1]);
      var timeSchedStr = TimeOfDay(hour: hour, minute: minute);
      if (timeSchedStr == TimeOfDay.now()) {
        print(timeSchedStr);
        timer.cancel();
        DateTime now = DateTime.now();
        int second = now.second;
        Map<String, dynamic> scheduleDetails = {
          'curtainState': schedules[i]['curtainState'],
          'ledInfo': {
            'ledStatus': schedules[i]['ledInfo']['ledStatus'],
            'ledColor': schedules[i]['ledInfo']['ledColor'],
            'ledColorValue': schedules[i]['ledInfo']['ledColorValue'],
            'ledBrightness': schedules[i]['ledInfo']['ledBrightness'],
          }
        };
        print(scheduleDetails);
        print("Schedule runtype: ${scheduleDetails.runtimeType}");
        updateCurtainSlideDetails(scheduleDetails);
        Timer(Duration(seconds: 60 - second), () {
          print("${60 - second} seconds has passed. Checking again.");
          startScheduleChecker(schedules); // Restart the timer after delay
        });
        break;
      }
    }
  });
}

Future<void> updateLEDinRTDB(String userId, Map<String, dynamic> ledInfo) async {
  try {
    DatabaseReference ledInfoRef =
        FirebaseDatabase.instance.ref('users/$userId/ledInfo');
    print(ledInfo);
    await ledInfoRef.update({
      'ledStatus': ledInfo['ledStatus'],
      'ledColor': ledInfo['ledColor'],
      'ledColorValue': ledInfo['ledColorValue'],
      'ledBrightness': ledInfo['ledBrightness']
    });
  } catch (e) {
    print(e);
  }
}

Future<void> updateCurtainStateInRTDB(String userId, bool closeCurtain) async {
  DatabaseReference curtainStateRef =
      FirebaseDatabase.instance.ref('users/$userId/curtainState');
  DatabaseReference isCurtainClosedRef =
      FirebaseDatabase.instance.ref('users/$userId/isCurtainClosed');
  DatabaseReference isCurtainOpenedRef =
      FirebaseDatabase.instance.ref('users/$userId/isCurtainOpened');
  // make it depend on the bool value of the closeCurtain
  try {
    if (closeCurtain) {
      final DatabaseEvent event = await isCurtainClosedRef.once();
      final isCurtainClosed = event.snapshot.value;
      if (isCurtainClosed is bool){
        if (!isCurtainClosed){
          curtainStateRef.set(0);
        }
      }
    } else {
      final DatabaseEvent event = await isCurtainOpenedRef.once();
      final isCurtainOpened = event.snapshot.value;
      if (isCurtainOpened is bool){
        if (!isCurtainOpened){
          curtainStateRef.set(2);
        }
      }
    }
  } catch (e) {
    print(e);
  }
}

void updateCurtainSlideDetails(Map<String, dynamic> schedule) {
  String userId = FirebaseAuth.instance.currentUser!.uid;
  FirebaseDatabase.instance.databaseURL =
      'https://curtainslide-test-default-rtdb.asia-southeast1.firebasedatabase.app';
  final userBox = Hive.box(FirebaseAuth.instance.currentUser!.uid);
  // update LED Info (must be turned into function for esp32 communication)
  Map<String, dynamic> ledInfo = schedule['ledInfo'];
  userBox.put('ledInfo', ledInfo);
  bool curtainState = schedule['curtainState'];
  updateLEDinRTDB(userId, ledInfo);
  updateCurtainStateInRTDB(userId, curtainState);
  print(userBox.values);
  // update curtain (must be turned into function for esp32 communication)
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
  @override
  Widget build(BuildContext context) {
    // Navigate to either home or login page based on user state
    if (isLoggedIn()) {
      return const HomePage();
    } else {
      return const LoginPage();
    }
  }
}
