import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_native_timezone/flutter_native_timezone.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:timezone/data/latest.dart' as tzdata;
import 'package:timezone/timezone.dart' as tz;

class AppState extends ChangeNotifier {
  int wakeUpTimeHour = 0;
  int wakeUpTimeMinute = 0;
  int sleepTimeHour = 0;
  int sleepTimeMinute = 0;
  int recommendedCups = 0;
  int drankCups = 0;
  String userName = "";
  FlutterLocalNotificationsPlugin localNotificationsPlugin = FlutterLocalNotificationsPlugin();

  AppState() {
    initializeNotifications();
    loadPreferences();
  }

  void initializeNotifications() {
    var initializationSettingsIOS = const DarwinInitializationSettings(
      requestAlertPermission: true,
      requestBadgePermission: true,
      requestSoundPermission: true,
    );
    var initializationSettings = InitializationSettings(
      iOS: initializationSettingsIOS,
    );

    localNotificationsPlugin = FlutterLocalNotificationsPlugin();
    localNotificationsPlugin.initialize(initializationSettings);
  }

  Future<void> _scheduleNotifications() async {
    var prefs = await SharedPreferences.getInstance();
    String scheduleJson = prefs.getString("drinking_schedule") ?? "[]";
    print(scheduleJson);
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
      NotificationDetails notificationDetails = const NotificationDetails(
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
      print("Scheduled notification for $time");
    }
  }

  Future<void> loadPreferences() async {
    var prefs = await SharedPreferences.getInstance();
    wakeUpTimeHour = prefs.getInt("wakeUpTimeHour") ?? 0;
    wakeUpTimeMinute = prefs.getInt("wakeUpTimeMinute") ?? 0;
    sleepTimeHour = prefs.getInt("sleepTimeHour") ?? 0;
    sleepTimeMinute = prefs.getInt("sleepTimeMinute") ?? 0;
    recommendedCups = prefs.getInt("recommended_cups") ?? 0;
    drankCups = prefs.getInt("drank_cups") ?? 0;
    userName = prefs.getString("userName") ?? "";
    prefs.setString("drinking_schedule", generateDrinkingSchedule());
    _scheduleNotifications();
    notifyListeners();
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

  Future<void> resetDrankCups() async {
    var prefs = await SharedPreferences.getInstance();
    await prefs.setInt("drank_cups", 0);
    drankCups = 0;
    notifyListeners();
  }

  Future<void> drinkCup() async {
    var prefs = await SharedPreferences.getInstance();
    int newDrankCups = (prefs.getInt("drank_cups") ?? 0) + 1;
    await prefs.setInt("drank_cups", newDrankCups);
    drankCups = newDrankCups;
    notifyListeners();
  }
}
