import 'package:flutter/material.dart';
import 'screens/login_screen.dart';

class Login extends StatelessWidget {
  const Login({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      title: 'חרמ"ש מסייעת 8112',
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        body: LoginPage(),
      ),
    );
  }
}
