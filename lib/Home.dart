import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import 'package:flutter_animation_progress_bar/flutter_animation_progress_bar.dart';
import 'package:timezone/timezone.dart' as tz;
import 'package:timezone/data/latest.dart' as tzdata;
import 'package:flutter_native_timezone/flutter_native_timezone.dart';
import 'package:waterapp/WelcomeScreen.dart';

class HomePage extends StatefulWidget {
  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int wakeUpTimeHour = 0;
  int wakeUpTimeMinute = 0;
  int sleepTimeHour = 0;
  int sleepTimeMinute = 0;
  int recommendedCups = 0;
  int drankCups = 0;
  String userName = "";
  FlutterLocalNotificationsPlugin localNotificationsPlugin = FlutterLocalNotificationsPlugin();

  @override
  void initState() {
    super.initState();
    _initializeNotifications();
    _loadPreferences();
  }

  void _initializeNotifications() {
    var prefs = SharedPreferences.getInstance();
    var initializationSettingsIOS = DarwinInitializationSettings(
      requestAlertPermission: true,
      requestBadgePermission: true,
      requestSoundPermission: true,
    );
    var initializationSettings = InitializationSettings(
      iOS: initializationSettingsIOS,
    );

    localNotificationsPlugin = FlutterLocalNotificationsPlugin();
    localNotificationsPlugin.initialize(
      initializationSettings
    );
  }

  Future<void> _scheduleNotifications() async {
    var prefs = await SharedPreferences.getInstance();
    String scheduleJson = prefs.getString("drinking_schedule") ?? "[]";
    List<dynamic> schedule = jsonDecode(scheduleJson);

    for (int i = 0; i < schedule.length; i++) {
      var timeParts = schedule[i].split(":");
      int hour = int.parse(timeParts[0].trim());
      int minute = int.parse(timeParts[1].trim());

      tzdata.initializeTimeZones();
      String timeZoneName = await FlutterNativeTimezone.getLocalTimezone();
      var time = tz.TZDateTime(tz.getLocation(timeZoneName), DateTime.now().year, DateTime.now().month, DateTime.now().day , hour, minute);
      if (time.isBefore(tz.TZDateTime.now(tz.getLocation(timeZoneName))) || time.isAtSameMomentAs(tz.TZDateTime.now(tz.getLocation(timeZoneName)))) {
        time = tz.TZDateTime(tz.getLocation(timeZoneName), DateTime.now().year, DateTime.now().month, DateTime.now().day + 1 , hour, minute);
      }
      NotificationDetails notificationDetails = NotificationDetails(
          iOS: DarwinNotificationDetails(
              presentAlert: true,
              presentBadge: true,
              presentSound: true
          )
      );
      UILocalNotificationDateInterpretation uiLocalNotificationDateInterpretation = UILocalNotificationDateInterpretation.absoluteTime;
      await localNotificationsPlugin.zonedSchedule(
          i,
          'Drink Water!',
          'It is time to drink water!',
          time,
          notificationDetails,
          uiLocalNotificationDateInterpretation: uiLocalNotificationDateInterpretation
      );
      print(time);
    }
  }

  _loadPreferences() async {
    var prefs = await SharedPreferences.getInstance();
    setState(() {
      wakeUpTimeHour = prefs.getInt("wakeUpTimeHour") ?? 0;
      wakeUpTimeMinute = prefs.getInt("wakeUpTimeMinute") ?? 0;
      sleepTimeHour = prefs.getInt("sleepTimeHour") ?? 0;
      sleepTimeMinute = prefs.getInt("sleepTimeMinute") ?? 0;
      recommendedCups = prefs.getInt("recommended_cups") ?? 0;
      drankCups = prefs.getInt("drank_cups") ?? 0;
      userName = prefs.getString("userName") ?? "";
    });
    prefs.setString("drinking_schedule", generateDrinkingSchedule());
    _scheduleNotifications();
  }

  int calculateAwakeTime() {
    int wakeUpTimeInMinutes = wakeUpTimeHour * 60 + wakeUpTimeMinute;
    int sleepTimeInMinutes = sleepTimeHour * 60 + sleepTimeMinute;
    int awakeTimeInMinutes = sleepTimeInMinutes - wakeUpTimeInMinutes;
    if (awakeTimeInMinutes < 0) {
      awakeTimeInMinutes += 24 * 60;
    }
    return awakeTimeInMinutes ~/ 60;
  }

  double calculateCupsPerHour() {
    int awakeTime = calculateAwakeTime();
    if (awakeTime == 0) return 0;
    return recommendedCups / awakeTime;
  }

  String generateDrinkingSchedule() {
    int wakeUpTimeInMinutes = wakeUpTimeHour * 60 + wakeUpTimeMinute;
    int sleepTimeInMinutes = sleepTimeHour * 60 + sleepTimeMinute;
    int awakeTimeInMinutes = sleepTimeInMinutes - wakeUpTimeInMinutes;
    if (awakeTimeInMinutes < 0) {
      awakeTimeInMinutes += 24 * 60;
    }

    if (awakeTimeInMinutes == 0 || recommendedCups == 0) return "[]";

    int intervalInMinutes = awakeTimeInMinutes ~/ recommendedCups;
    int currentTimeInMinutes = wakeUpTimeInMinutes;

    List<String> schedule = [];
    for (int i = 0; i < recommendedCups; i++) {
      int currentHour = currentTimeInMinutes ~/ 60;
      int currentMinute = currentTimeInMinutes % 60;
      schedule.add("$currentHour : $currentMinute");
      currentTimeInMinutes += intervalInMinutes;
      if (currentTimeInMinutes >= sleepTimeInMinutes) {
        break;
      }
    }

    return jsonEncode(schedule);
  }

  void resetDrankCups() async {
    var prefs = await SharedPreferences.getInstance();
    await prefs.setInt("drank_cups", 0);
    setState(() {
      drankCups = 0;
    });
  }

  @override
  Widget build(BuildContext context) {
    Future<void> markTimeAsLogged() async {
      var prefs = await SharedPreferences.getInstance();
      int newDrankCups = (prefs.getInt("drank_cups") ?? 0) + 1;
      await prefs.setInt("drank_cups", newDrankCups);
      setState(() {
        drankCups = newDrankCups;
      });
    }
    return CupertinoPageScaffold(
      child: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(height: MediaQuery.of(context).size.height * 0.065),
            Row(
              children: [
                Spacer(),
                Container(
                  width: 40,
                  height: 200,
                  child: FAProgressBar(
                    borderRadius: BorderRadiusGeometry.lerp(BorderRadius.zero, BorderRadius.circular(10), 1),
                    currentValue: (drankCups == 0 ? 1 : 100 * drankCups / recommendedCups),
                    verticalDirection: VerticalDirection.up,
                    direction: Axis.vertical,
                    displayText: '%',
                    progressGradient: LinearGradient(
                      colors: (drankCups / recommendedCups) < 1
                        ? [Colors.blue, Colors.blue.shade900]
                        : [Colors.green, Colors.green.shade900],
                    ),
                  ),
                ),
                Spacer(),
                ClipRRect(
                  borderRadius: BorderRadius.circular(20),
                  child: Container(
                    padding: EdgeInsets.all(20),
                    height: 200,
                    color: Colors.blue,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        (drankCups / recommendedCups) < 1
                          ? Column(
                          children: [
                            Container(
                                width: MediaQuery.of(context).size.width * 0.7,
                                child: Row(
                                  children: [
                                    Text(
                                      "Welcome, $userName!",
                                      style: TextStyle(fontSize: 16, color: Colors.white, fontWeight: FontWeight.bold),
                                      textAlign: TextAlign.center,
                                    ),
                                    Spacer(),
                                  ],
                                )
                            ),
                            Container(
                                width: MediaQuery.of(context).size.width * 0.7,
                                child: Row(
                                  children: [
                                    Text(
                                      "Drank: $drankCups cups",
                                      style: TextStyle(fontSize: 16, color: Colors.white, fontWeight: FontWeight.bold),
                                      textAlign: TextAlign.center,
                                    ),
                                    Spacer(),
                                  ],
                                )
                            ),
                            Container(
                                width: MediaQuery.of(context).size.width * 0.7,
                                child: Row(
                                  children: [
                                    Text(
                                      "Goal: $recommendedCups cups",
                                      style: TextStyle(fontSize: 16, color: Colors.white, fontWeight: FontWeight.bold),
                                      textAlign: TextAlign.center,
                                    ),
                                    Spacer(),
                                  ],
                                )
                            ),
                            Container(
                                width: MediaQuery.of(context).size.width * 0.7,
                                child: Row(
                                  children: [
                                    Text(
                                      "${recommendedCups - drankCups} cups to go!",
                                      style: TextStyle(fontSize: 16, color: Colors.white, fontWeight: FontWeight.bold),
                                      textAlign: TextAlign.center,
                                    ),
                                    Spacer(),
                                  ],
                                )
                            ),
                            Container(
                                width: MediaQuery.of(context).size.width * 0.7,
                                child: Row(
                                  children: [
                                    Text(
                                      "It is about ${calculateCupsPerHour().toStringAsFixed(2)} cups per hour!",
                                      style: TextStyle(fontSize: 16, color: Colors.white, fontWeight: FontWeight.bold),
                                      textAlign: TextAlign.center,
                                    ),
                                    Spacer(),
                                  ],
                                )
                            ),
                            SizedBox(height: 10)
                          ],
                        )
                        : Container(
                            width: MediaQuery.of(context).size.width * 0.7,
                            child: Row(
                              children: [
                                Spacer(),
                                Text(
                                  "Well done, $userName!\nYou have reached your goal!\n You drank $drankCups cups today!",
                                  style: TextStyle(fontSize: 16, color: Colors.white, fontWeight: FontWeight.bold),
                                  textAlign: TextAlign.center,
                                ),
                                Spacer(),
                              ],
                            )
                        ),
                        Row(
                          children: [
                            Container(
                              width: 50,
                              height: 50,
                              child: CupertinoButton(
                                padding: EdgeInsets.all(0),
                                color: Colors.blue.shade900,
                                child: Icon(
                                  Icons.restart_alt,
                                  color: Colors.white,
                                ),
                                onPressed: resetDrankCups,
                              ),
                            ),
                            SizedBox(width: 10),
                            Container(
                              height: 50,
                              child: CupertinoButton(
                                padding: EdgeInsets.symmetric(horizontal: 20),
                                color: Colors.blue.shade900,
                                child: Text(
                                  "Mark as Drank",
                                  style: TextStyle(fontSize: 16, color: Colors.white, fontWeight: FontWeight.bold),
                                ),
                                onPressed: markTimeAsLogged,
                              ),
                            )
                          ],
                        )
                      ],
                    ),
                  ),
                ),
                Spacer(),
              ],
            ),
            SizedBox(height: 20),
            Row(
              children: [
                SizedBox(width: 20),
                Text(
                  "Your Drinking Schedule",
                  style: TextStyle(fontSize: 20, color: Colors.blue, fontWeight: FontWeight.bold),
                  textAlign: TextAlign.center,
                ),
                Spacer(),
              ],
            ),
            GridView.count(
              padding: EdgeInsets.only(bottom: 10),
              shrinkWrap: true,
              physics: NeverScrollableScrollPhysics(),
              crossAxisCount: 2,
              childAspectRatio: 3,
              children: List.generate(recommendedCups, (index) {
                return buildDrinkingEntry(context, jsonDecode(generateDrinkingSchedule())[index], index == recommendedCups - 1);
              }),
            ),
            CupertinoButton(
              padding: EdgeInsets.all(0),
              child: Container(
                height: 40,
                width: MediaQuery.of(context).size.width * 0.7,
                decoration: BoxDecoration(
                  color: Colors.red,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Center(
                  child: Text(
                    "Reset App",
                    style: TextStyle(fontSize: 16, color: Colors.white, fontWeight: FontWeight.bold),
                    textAlign: TextAlign.center,
                  ),
                )
              ),
              onPressed: () async {
                var prefs = await SharedPreferences.getInstance();
                await prefs.clear();
                localNotificationsPlugin.cancelAll();
                Navigator.of(context).pushAndRemoveUntil(
                  MaterialPageRoute(builder: (context) => WelcomeScreen()),
                      (Route<dynamic> route) => false,
                );
              }
            ),
            SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  Widget buildDrinkingEntry(BuildContext context, String time, bool isLast) {
    var timeParts = time.split(':');
    var hour = int.parse(timeParts[0].trim());
    var minute = int.parse(timeParts[1].trim());

    var formattedHour = hour < 10 ? '0$hour' : hour.toString();
    var formattedMinute = minute < 10 ? '0$minute' : minute.toString();

    return Column(
      children: [
        Container(
          padding: EdgeInsets.all(10),
          margin: EdgeInsets.only(top: 10, left: 20, right: 20),
          decoration: BoxDecoration(
            color: Colors.blue,
            borderRadius: BorderRadius.circular(20),
          ),
          child: Row(
            children: [
              Spacer(),
              Text(
                "$formattedHour : $formattedMinute",
                style: TextStyle(fontSize: 16, color: Colors.white, fontWeight: FontWeight.bold),
                textAlign: TextAlign.center,
              ),
              Spacer(),
            ],
          ),
        ),
        (isLast ? SizedBox(height: 10) : SizedBox()),
      ],
    );
  }
}