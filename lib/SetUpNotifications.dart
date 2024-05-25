import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:waterapp/AppState.dart';
import 'package:waterapp/Home.dart';
import 'package:waterapp/ColorTheme.dart';

class SetUpNotifications extends StatefulWidget {
  final int recommendedMl;

  SetUpNotifications({required Key? key, required this.recommendedMl})
      : super(key: key);

  @override
  _SetUpNotificationsState createState() => _SetUpNotificationsState();
}

class _SetUpNotificationsState extends State<SetUpNotifications> {
  String wakeUpTime = "08:00";
  String sleepTime = "22:00";

  @override
  Widget build(BuildContext context) {
    final appState = Provider.of<AppState>(context);
    return CupertinoPageScaffold(
        child: SingleChildScrollView(
            child: GestureDetector(
              onTap: () {
                FocusScope.of(context).unfocus();
              },
              child: Center(
                child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
                  SizedBox(height: MediaQuery.of(context).size.height / 8),
                  Image.asset("assets/images/notification.png", width: 150),
                  SizedBox(height: 20),
                  Text(
                    "Finish setting up your account",
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 10),
                  Text(
                    "You should drink ${widget.recommendedMl} ml of water daily",
                    style: TextStyle(
                      fontSize: 16,
                    ),
                  ),
                  SizedBox(height: 10),
                  Text(
                    "That's about ${(widget.recommendedMl ~/ 250 + 1)} glasses of water",
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 20),
                  Row(
                    children: [
                      Spacer(),
                      ClipRRect(
                        borderRadius: BorderRadius.circular(20),
                        child: Container(
                          width: MediaQuery.of(context).size.width * 0.4,
                          color: AppColors.primary.withOpacity(0.1),
                          child: Padding(
                            padding: EdgeInsets.all(10),
                            child: Column(
                              children: [
                                Text(
                                  "Your waking hours",
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                SizedBox(height: 10),
                                CupertinoButton(
                                  padding: EdgeInsets.all(0),
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(20),
                                    child: Container(
                                        width: MediaQuery.of(context).size.width * 0.3,
                                        color: AppColors.primary,
                                        padding: EdgeInsets.all(10),
                                        child: Row(
                                          children: [
                                            Spacer(),
                                            Text(
                                              wakeUpTime,
                                              style: TextStyle(
                                                color: AppColors.white,
                                                fontSize: 16,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                            Spacer(),
                                          ],
                                        )),
                                  ),
                                  onPressed: () async {
                                    showCupertinoModalPopup(
                                      context: context,
                                      builder: (BuildContext context) => Container(
                                        height: 210,
                                        color: AppColors.white,
                                        child: Column(
                                          children: [
                                            Container(
                                              height: 150,
                                              child: CupertinoDatePicker(
                                                mode: CupertinoDatePickerMode.time,
                                                initialDateTime: DateTime.now(),
                                                onDateTimeChanged:
                                                    (DateTime newDateTime) {
                                                  setState(() {
                                                    wakeUpTime = newDateTime.hour
                                                        .toString() +
                                                        ":" +
                                                        (newDateTime.minute < 10
                                                            ? "0" +
                                                            newDateTime.minute
                                                                .toString()
                                                            : newDateTime.minute
                                                            .toString());
                                                  });
                                                  appState.wakeUpTimeHour =
                                                      newDateTime.hour;
                                                  appState.wakeUpTimeMinute =
                                                      newDateTime.minute;
                                                  appState.notifyListeners();
                                                },
                                              ),
                                            ),
                                            CupertinoButton(
                                              child: Text("Done"),
                                              onPressed: () {
                                                Navigator.pop(context);
                                              },
                                            ),
                                          ],
                                        ),
                                      ),
                                    );
                                  },
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      Spacer(),
                      ClipRRect(
                        borderRadius: BorderRadius.circular(20),
                        child: Container(
                          width: MediaQuery.of(context).size.width * 0.4,
                          color: AppColors.primary,
                          child: Padding(
                            padding: EdgeInsets.all(10),
                            child: Column(
                              children: [
                                Text(
                                  "Your sleeping hours",
                                  style: TextStyle(
                                    fontSize: 16,
                                    color: AppColors.white,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                SizedBox(height: 10),
                                CupertinoButton(
                                  padding: EdgeInsets.all(0),
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(20),
                                    child: Container(
                                        width: MediaQuery.of(context).size.width * 0.3,
                                        color: AppColors.primaryDark,
                                        padding: EdgeInsets.all(10),
                                        child: Row(
                                          children: [
                                            Spacer(),
                                            Text(
                                              sleepTime,
                                              style: TextStyle(
                                                color: AppColors.white,
                                                fontSize: 16,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                            Spacer(),
                                          ],
                                        )),
                                  ),
                                  onPressed: () async {
                                    showCupertinoModalPopup(
                                      context: context,
                                      builder: (BuildContext context) => Container(
                                        height: 210,
                                        color: AppColors.white,
                                        child: Column(
                                          children: [
                                            Container(
                                              height: 150,
                                              child: CupertinoDatePicker(
                                                mode: CupertinoDatePickerMode.time,
                                                initialDateTime: DateTime.now(),
                                                onDateTimeChanged:
                                                    (DateTime newDateTime) {
                                                  setState(() {
                                                    sleepTime = newDateTime.hour.toString() +
                                                        ":" +
                                                        (newDateTime.minute < 10
                                                            ? "0" +
                                                            newDateTime.minute.toString()
                                                            : newDateTime.minute
                                                            .toString());
                                                  });
                                                  appState.sleepTimeHour =
                                                      newDateTime.hour;
                                                  appState.sleepTimeMinute =
                                                      newDateTime.minute;
                                                  appState.notifyListeners();
                                                },
                                              ),
                                            ),
                                            CupertinoButton(
                                              child: Text("Done"),
                                              onPressed: () {
                                                Navigator.pop(context);
                                              },
                                            ),
                                          ],
                                        ),
                                      ),
                                    );
                                  },
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      Spacer(),
                    ],
                  ),
                  SizedBox(height: 20),
                  Row(
                    children: [
                      Spacer(),
                      CupertinoButton(
                        padding: EdgeInsets.all(0),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(20),
                          child: Container(
                              width: MediaQuery.of(context).size.width * 0.2,
                              color: AppColors.primary,
                              padding: EdgeInsets.all(10),
                              child: Row(
                                children: [
                                  Spacer(),
                                  Text(
                                    "Back",
                                    style: TextStyle(
                                      color: AppColors.white,
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  Spacer(),
                                ],
                              )),
                        ),
                        onPressed: () async {
                          Navigator.pop(context);
                        },
                      ),
                      Spacer(),
                      CupertinoButton(
                        padding: EdgeInsets.all(0),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(20),
                          child: Container(
                              width: MediaQuery.of(context).size.width * 0.6,
                              color: AppColors.primary,
                              padding: EdgeInsets.all(10),
                              child: Row(
                                children: [
                                  Spacer(),
                                  Text(
                                    "Finish",
                                    style: TextStyle(
                                      color: AppColors.white,
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  Spacer(),
                                ],
                              )),
                        ),
                        onPressed: () async {
                          var prefs = await SharedPreferences.getInstance();
                          prefs.setInt("recommended_cups",
                          widget.recommendedMl ~/ 250 + 1);
                          appState.loadPreferences();
                          Navigator.of(context).pushAndRemoveUntil(
                          MaterialPageRoute(builder: (context) => HomePage()),
                            (Route<dynamic> route) => false,
                          );
                        },
                      ),
                      Spacer(),
                    ],
                  ),
                ]),
              ),
            )
        )
    );
  }
}
