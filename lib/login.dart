import 'package:flutter/material.dart';
import 'package:regiment8112/utils/theme_data.dart';
import 'screens/login_screen.dart';

class Login extends StatelessWidget {
  const Login({super.key});

  @override
  Widget build(BuildContext context) {


    return MaterialApp(
      debugShowCheckedModeBanner: false,
      themeMode: ThemeMode.system,
      theme: MyThemeData.lightTheme,
      darkTheme: MyThemeData.darkTheme,
      home: const Scaffold(
        body: LoginPage(),
      ),
    );
  }
}
