import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:waterapp/AppState.dart';
import 'package:waterapp/Home.dart';
import 'package:waterapp/WelcomeScreen.dart';
import 'package:waterapp/ColorTheme.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final prefs = await SharedPreferences.getInstance();
  final userName = prefs.getString('userName');
  runApp(MyApp(userName: userName));
}

class MyApp extends StatelessWidget {
  final String? userName;

  const MyApp({Key? key, this.userName}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => AppState(),
      child: CupertinoApp(
        title: 'Water app',
        debugShowCheckedModeBanner: false,
        theme: AppThemes.cupertinoTheme,
        home: userName != null ? HomePage() : WelcomeScreen(),
      ),
    );
  }
}
