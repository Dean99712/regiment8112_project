import 'package:flutter/material.dart';
import 'package:regiment8112_project/utils/colors.dart';
import 'screens/login_screen.dart';

class Login extends StatelessWidget {
  const Login({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        brightness: Brightness.dark,
        primaryColor: primaryColor,
        splashColor: secondaryColor,
        backgroundColor: backgroundColor,
      ),
      debugShowCheckedModeBanner: false,
      home: const Scaffold(
        body: LoginPage(),
      ),
    );
  }
}
