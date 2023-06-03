import 'package:flutter/material.dart';
import 'widgets/gradient_container.dart';
import 'login_screen.dart';


class Login extends StatefulWidget {
  const Login({Key? key}) : super(key: key);

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  var activeScreen = 'start-screen';

  void switchScreen() {
    setState(() {
      activeScreen = 'login-screen';
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'חרמ"ש מסייעת 8112',
      debugShowCheckedModeBanner: true,
      home: Scaffold(
        body: Container(
          child: activeScreen == 'start-screen'
              ? LoginPage(switchScreen)
              : const GradientContainer([
                  Color.fromRGBO(60, 58, 59, 1),
                  Color.fromRGBO(60, 58, 59, 1)
                ]),
          // body: const LoginPage(),
        ),
      ),
    );
  }
}
