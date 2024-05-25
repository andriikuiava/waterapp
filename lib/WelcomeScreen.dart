import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:waterapp/WeightAndHeightScreen.dart';
import 'package:waterapp/ColorTheme.dart';

class WelcomeScreen extends StatefulWidget {
  @override
  _WelcomeScreenState createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen> {
  bool isNameValid = false;
  String userName = "";

  void checkName() {
    bool valid = userName.isNotEmpty && userName.length <= 30;
    setState(() {
      isNameValid = valid;
    });
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
                  Image.asset("assets/images/waterappicon.png", width: 300),
                  Text(
                    "Welcome to the water app",
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 10),
                  Text(
                    "To get started, please enter your name",
                    style: TextStyle(
                      fontSize: 16,
                    ),
                  ),
                  SizedBox(height: 20),
                  Row(
                    children: [
                      Spacer(),
                      Container(
                        width: MediaQuery.of(context).size.width * 0.7,
                        height: 50,
                        child: CupertinoTextField(
                          padding: EdgeInsets.symmetric(horizontal: 20),
                          placeholder: "Enter your name",
                          decoration: BoxDecoration(
                            color: Colors.grey[200],
                            borderRadius: BorderRadius.circular(20),
                          ),
                          onChanged: (value) {
                            userName = value;
                            checkName();
                          },
                        ),
                      ),
                      Spacer(),
                      CupertinoButton(
                        padding: EdgeInsets.all(0),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(20),
                          child: Container(
                            color: isNameValid ? AppColors.primary : AppColors.grey,
                            padding: EdgeInsets.all(10),
                            child: Icon(
                              CupertinoIcons.arrow_right,
                              color: AppColors.white,
                            ),
                          ),
                        ),
                        onPressed: isNameValid
                            ? () async {
                          var prefs = await SharedPreferences.getInstance();
                          await prefs.setString("userName", userName);
                          Navigator.push(
                            context,
                            CupertinoPageRoute(
                                builder: (context) => WeightAndHeightScreen()),
                          );
                        }
                            : null,
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
