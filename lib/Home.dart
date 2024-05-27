import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animation_progress_bar/flutter_animation_progress_bar.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:waterapp/AppState.dart';
import 'package:waterapp/ColorTheme.dart';
import 'package:waterapp/WelcomeScreen.dart';
import 'package:waterapp/Widgets/BuildDrinkingEntry.dart';
import 'package:waterapp/Widgets/TextHomeScreenWidget.dart';

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final appState = Provider.of<AppState>(context);
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
                    borderRadius: BorderRadiusGeometry.lerp(
                        BorderRadius.zero, BorderRadius.circular(10), 1),
                    currentValue: (appState.drankCups == 0
                        ? 1
                        : 100 * appState.drankCups / appState.recommendedCups),
                    verticalDirection: VerticalDirection.up,
                    direction: Axis.vertical,
                    displayText: '%',
                    progressGradient: LinearGradient(
                      colors: (appState.drankCups / appState.recommendedCups) < 1
                          ? [AppColors.primary, AppColors.primaryDark]
                          : [AppColors.success, AppColors.successDark],
                    ),
                  ),
                ),
                Spacer(),
                ClipRRect(
                  borderRadius: BorderRadius.circular(20),
                  child: Container(
                    padding: EdgeInsets.all(20),
                    height: 200,
                    color: AppColors.primary,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        (appState.drankCups / appState.recommendedCups) < 1
                            ? Column(
                          children: [
                            TextHomeScreenWidget(context, "Welcome, ${appState.userName}!"),
                            TextHomeScreenWidget(context, "Drank: ${appState.drankCups} cups"),
                            TextHomeScreenWidget(context, "Goal: ${appState.recommendedCups} cups"),
                            TextHomeScreenWidget(context, "${appState.recommendedCups - appState.drankCups} cups to go!"),
                            TextHomeScreenWidget(context, "It is about ${appState.calculateCupsPerHour().toStringAsFixed(2)} cups per hour!"),
                            SizedBox(height: 10)
                          ],
                        )
                            : TextHomeScreenWidget(context, "It is about ${appState.calculateCupsPerHour().toStringAsFixed(2)} cups per hour!"),
                        Row(
                          children: [
                            Container(
                              width: 50,
                              height: 50,
                              child: CupertinoButton(
                                padding: EdgeInsets.all(0),
                                color: AppColors.primaryDark,
                                child: Icon(
                                  Icons.restart_alt,
                                  color: AppColors.white,
                                ),
                                onPressed: appState.resetDrankCups,
                              ),
                            ),
                            SizedBox(width: 10),
                            Container(
                              height: 50,
                              child: CupertinoButton(
                                padding: EdgeInsets.symmetric(horizontal: 20),
                                color: AppColors.primaryDark,
                                child: Text(
                                  "Mark as Drank",
                                  style: TextStyle(
                                      fontSize: 16,
                                      color: AppColors.white,
                                      fontWeight: FontWeight.bold
                                  ),
                                ),
                                onPressed: appState.drinkCup,
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
                  style: TextStyle(
                      fontSize: 20,
                      color: AppColors.primary,
                      fontWeight: FontWeight.bold),
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
              children: List.generate(appState.recommendedCups, (index) {
                return buildDrinkingEntry(
                    context,
                    jsonDecode(appState.generateDrinkingSchedule())[index],
                    index == appState.recommendedCups - 1);
              }),
            ),
            CupertinoButton(
                padding: EdgeInsets.all(0),
                child: Container(
                    height: 40,
                    width: MediaQuery.of(context).size.width * 0.7,
                    decoration: BoxDecoration(
                      color: AppColors.accent,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Center(
                      child: Text(
                        "Reset App",
                        style: TextStyle(
                            fontSize: 16,
                            color: AppColors.white,
                            fontWeight: FontWeight.bold),
                        textAlign: TextAlign.center,
                      ),
                    )),
                onPressed: () async {
                  var prefs = await SharedPreferences.getInstance();
                  await prefs.clear();
                  appState.localNotificationsPlugin.cancelAll();
                  Navigator.of(context).pushAndRemoveUntil(
                    MaterialPageRoute(builder: (context) => WelcomeScreen()),
                        (Route<dynamic> route) => false,
                  );
                }),
            SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}
