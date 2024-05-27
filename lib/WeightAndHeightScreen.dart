import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:waterapp/ColorTheme.dart';
import 'package:waterapp/SetUpNotifications.dart';

class WeightAndHeightScreen extends StatefulWidget {
  @override
  _WeightAndHeightScreenState createState() => _WeightAndHeightScreenState();
}

class _WeightAndHeightScreenState extends State<WeightAndHeightScreen> {
  bool isEverythingValid = false;
  String weight = "";
  String height = "";
  String age = "";

  void checkEverything() {
    bool valid = weight.isNotEmpty && height.isNotEmpty && age.isNotEmpty;
    if (valid) {
      valid = int.parse(weight) > 0 &&
          int.parse(height) > 0 &&
          int.parse(age) > 0 &&
          int.parse(age) < 100 &&
          int.parse(weight) < 200 &&
          int.parse(height) < 250;
    }
    setState(() {
      isEverythingValid = valid;
    });
  }

  int calculateWaterIntake(int weight, int height, int age) {
    int baseAmountPerKg = 30;
    int baseWaterIntake = baseAmountPerKg * weight;
    int additionalWaterForHeight = height;
    int additionalWaterForAge = age * 10;

    int totalWaterIntake = baseWaterIntake +
        additionalWaterForHeight +
        additionalWaterForAge;

    return totalWaterIntake;
  }

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
        child: SingleChildScrollView(
            child: GestureDetector(
              onTap: () {
                FocusScope.of(context).unfocus();
              },
              child: Center(
                child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
                  SizedBox(height: MediaQuery.of(context).size.height / 8),
                  Image.asset("assets/images/bio.png", width: 150),
                  SizedBox(height: 20),
                  Text(
                    "Let's get started",
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 10),
                  Text(
                    "Please enter your biometric details",
                    style: TextStyle(
                      fontSize: 16,
                    ),
                  ),
                  SizedBox(height: 20),
                  Row(
                    children: [
                      Spacer(),
                      Text(
                        "Weight (kg): ",
                        style: TextStyle(
                          fontSize: 16,
                        ),
                      ),
                      Spacer(),
                      Container(
                        width: 80,
                        height: 50,
                        child: CupertinoTextField(
                          padding: EdgeInsets.symmetric(horizontal: 20),
                          placeholder: "",
                          decoration: BoxDecoration(
                            color: Colors.grey[200],
                            borderRadius: BorderRadius.circular(20),
                          ),
                          keyboardType: TextInputType.number,
                          onChanged: (value) {
                            weight = value;
                            checkEverything();
                          },
                        ),
                      ),
                      Spacer(),
                    ],
                  ),
                  SizedBox(height: 10),
                  Row(
                    children: [
                      Spacer(),
                      Text(
                        "Height (cm):",
                        style: TextStyle(
                          fontSize: 16,
                        ),
                      ),
                      Spacer(),
                      Container(
                        width: 80,
                        height: 50,
                        child: CupertinoTextField(
                          padding: EdgeInsets.symmetric(horizontal: 20),
                          placeholder: "",
                          decoration: BoxDecoration(
                            color: Colors.grey[200],
                            borderRadius: BorderRadius.circular(20),
                          ),
                          keyboardType: TextInputType.number,
                          onChanged: (value) {
                            height = value;
                            checkEverything();
                          },
                        ),
                      ),
                      Spacer(),
                    ],
                  ),
                  SizedBox(height: 10),
                  Row(
                    children: [
                      Spacer(),
                      Text(
                        "Age:              ",
                        style: TextStyle(
                          fontSize: 16,
                        ),
                      ),
                      Spacer(),
                      Container(
                        width: 80,
                        height: 50,
                        child: CupertinoTextField(
                          padding: EdgeInsets.symmetric(horizontal: 20),
                          placeholder: "",
                          decoration: BoxDecoration(
                            color: Colors.grey[200],
                            borderRadius: BorderRadius.circular(20),
                          ),
                          keyboardType: TextInputType.number,
                          onChanged: (value) {
                            age = value;
                            checkEverything();
                          },
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
                              color: isEverythingValid
                                  ? AppColors.primary
                                  : AppColors.grey,
                              padding: EdgeInsets.all(10),
                              child: Row(
                                children: [
                                  Spacer(),
                                  Text(
                                    "Continue",
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
                          checkEverything();
                          if (isEverythingValid) {
                            var prefs = await SharedPreferences.getInstance();
                            prefs.setInt("weight", int.parse(weight));
                            prefs.setInt("height", int.parse(height));
                            prefs.setInt("age", int.parse(age));
                            prefs.setInt("recommended_ml", calculateWaterIntake(int.parse(weight), int.parse(height), int.parse(age)));
                            prefs.setInt("wakeUpTimeHour", 8);
                            prefs.setInt("wakeUpTimeMinute", 0);
                            prefs.setInt("sleepTimeHour", 22);
                            prefs.setInt("sleepTimeMinute", 0);
                            int recommendedMl = calculateWaterIntake(int.parse(weight), int.parse(height), int.parse(age));
                            Navigator.push(
                              context,
                              CupertinoPageRoute(builder: (context) => SetUpNotifications(key: null, recommendedMl: recommendedMl)),
                            );
                          }
                        },
                      ),
                      Spacer(),
                    ],
                  ),
                  SizedBox(height: MediaQuery.of(context).size.height / 10),
                ]),
              ),
            )));
  }
}
