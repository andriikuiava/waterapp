import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:waterapp/Home.dart';


class SetUpNotifications extends StatefulWidget {
  final int recommendedMl;

  SetUpNotifications({required Key? key,required this.recommendedMl}) : super(key: key);

  @override
  _SetUpNotificationsState createState() => _SetUpNotificationsState();
}

class _SetUpNotificationsState extends State<SetUpNotifications> {
  String wakeUpTime = "08:00";
  String sleepTime = "22:00";

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
        child: SingleChildScrollView(
            child: GestureDetector(
              onTap: () {
                FocusScope.of(context).unfocus();
              },
              child: Center(
                child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
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
                              color: Colors.blue.shade50,
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
                                            color: Colors.blue,
                                            padding: EdgeInsets.all(10),
                                            child: Row(
                                              children: [
                                                Spacer(),
                                                Text(
                                                  wakeUpTime,
                                                  style: TextStyle(
                                                    color: Colors.white,
                                                    fontSize: 16,
                                                    fontWeight: FontWeight.bold,
                                                  ),
                                                ),
                                                Spacer(),
                                              ],
                                            )
                                        ),
                                      ),
                                      onPressed: () async {
                                        showCupertinoModalPopup(
                                          context: context,
                                          builder: (BuildContext context) => Container(
                                            height: 210,
                                            color: Colors.white,
                                            child: Column(
                                              children: [
                                                Container(
                                                  height: 150,
                                                  child: CupertinoDatePicker(
                                                    mode: CupertinoDatePickerMode.time,
                                                    initialDateTime: DateTime.now(),
                                                    onDateTimeChanged: (DateTime newDateTime) {
                                                      setState(() {
                                                        wakeUpTime = newDateTime.hour.toString() + ":" +
                                                            (newDateTime.minute < 10 ? "0" + newDateTime.minute.toString() : newDateTime.minute.toString());
                                                      });
                                                      var prefs = SharedPreferences.getInstance();
                                                      prefs.then((value) {
                                                        value.setInt("wakeUpTimeHour", newDateTime.hour);
                                                      });
                                                      prefs.then((value) {
                                                        value.setInt("wakeUpTimeMinute", newDateTime.minute);
                                                      });
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
                              color: Colors.blue.shade700,
                              child: Padding(
                                padding: EdgeInsets.all(10),
                                child: Column(
                                  children: [
                                    Text(
                                      "Your sleeping hours",
                                      style: TextStyle(
                                        fontSize: 16,
                                        color: Colors.white,
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
                                            color: Colors.blue.shade900,
                                            padding: EdgeInsets.all(10),
                                            child: Row(
                                              children: [
                                                Spacer(),
                                                Text(
                                                  sleepTime,
                                                  style: TextStyle(
                                                    color: Colors.white,
                                                    fontSize: 16,
                                                    fontWeight: FontWeight.bold,
                                                  ),
                                                ),
                                                Spacer(),
                                              ],
                                            )
                                        ),
                                      ),
                                      onPressed: () async {
                                        showCupertinoModalPopup(
                                          context: context,
                                          builder: (BuildContext context) => Container(
                                            height: 210,
                                            color: Colors.white,
                                            child: Column(
                                              children: [
                                                Container(
                                                  height: 150,
                                                  child: CupertinoDatePicker(
                                                    mode: CupertinoDatePickerMode.time,
                                                    initialDateTime: DateTime.now(),
                                                    onDateTimeChanged: (DateTime newDateTime) {
                                                      setState(() {
                                                        sleepTime = newDateTime.hour.toString() + ":" +
                                                            (newDateTime.minute < 10 ? "0" + newDateTime.minute.toString() : newDateTime.minute.toString());
                                                      });
                                                      var prefs = SharedPreferences.getInstance();
                                                      prefs.then((value) {
                                                        value.setInt("sleepTimeHour", newDateTime.hour);
                                                      });
                                                      prefs.then((value) {
                                                        value.setInt("sleepTimeMinute", newDateTime.minute);
                                                      });
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
                                  color: Colors.blue,
                                  padding: EdgeInsets.all(10),
                                  child: Row(
                                    children: [
                                      Spacer(),
                                      Text(
                                        "Back",
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      Spacer(),
                                    ],
                                  )
                              ),
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
                                  color: Colors.blue,
                                  padding: EdgeInsets.all(10),
                                  child: Row(
                                    children: [
                                      Spacer(),
                                      Text(
                                        "Finish",
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      Spacer(),
                                    ],
                                  )
                              ),
                            ),
                            onPressed: () async {
                              var prefs = await SharedPreferences.getInstance();
                              prefs.setInt("recommended_cups", widget.recommendedMl ~/ 250 + 1);
                              Navigator.of(context).pushAndRemoveUntil(
                                MaterialPageRoute(builder: (context) => HomePage()),
                                    (Route<dynamic> route) => false,
                              );
                              },
                          ),
                          Spacer(),
                        ],
                      ),
                    ]
                ),
              ),
            )
        )
    );
  }
}