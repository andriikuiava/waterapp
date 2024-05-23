import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:waterapp/WelcomeScreen.dart';
import 'package:waterapp/Home.dart';
import 'package:shared_preferences/shared_preferences.dart';


void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final prefs = await SharedPreferences.getInstance();
  final userName = prefs.getInt('recommended_ml');
  runApp(MyApp(userName: userName));
}

class MyApp extends StatelessWidget {
  final int? userName;

  const MyApp({Key? key, this.userName}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CupertinoApp(
      title: 'Water app',
      debugShowCheckedModeBanner: false,
      theme: CupertinoThemeData(
        primaryColor: Colors.blue,
        scaffoldBackgroundColor: Colors.white,
        textTheme: CupertinoTextThemeData(
          navTitleTextStyle: TextStyle(
            color: Colors.black,
            fontSize: 20,
          ),
          textStyle: TextStyle(
            color: Colors.black,
            fontSize: 16,
          ),
        ),
      ),
      home: userName != null ? HomePage() : WelcomeScreen(),
    );
  }
}