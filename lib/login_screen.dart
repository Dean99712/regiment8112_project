import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:regiment8112_project/gradient_container.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {


  Widget activeScreen = const LoginPage();

  void switchScreen() {
    setState(() {
      activeScreen = const GradientContainer(
          [Color.fromRGBO(60, 58, 59, 1), Color.fromRGBO(60, 58, 59, 1)]);
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      themeMode: ThemeMode.dark,
      home: Scaffold(
        resizeToAvoidBottomInset: false,
        body: Container(
          padding: const EdgeInsets.all(60),
          width: double.infinity,
          height: double.infinity,
          decoration: const BoxDecoration(
              image: DecorationImage(
                  opacity: 0.12,
                  image: AssetImage("assets/images/Group 126.png"),
                  fit: BoxFit.cover),
              gradient: RadialGradient(radius: 0.9, colors: [
                Color.fromRGBO(121, 121, 121, 1),
                Color.fromRGBO(60, 58, 59, 1),
              ])),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Image.asset("assets/svg/logo.png", height: 210, width: 210),
              Text(
                'חרמ"ש מסייעת',
                style: GoogleFonts.rubikDirt(
                    fontSize: 32, color: const Color.fromRGBO(86, 154, 82, 1)),
              ),
              Text(
                "8112",
                style: GoogleFonts.rubikDirt(
                    fontSize: 90, color: const Color.fromRGBO(86, 154, 82, 1)),
              ),
              const TextField(
                enableSuggestions: false,
                keyboardType: TextInputType.phone,
                maxLength: 10,
                autofocus: true,
                decoration: InputDecoration(
                  filled: true,
                  focusedBorder:
                      OutlineInputBorder(borderSide: BorderSide.none),
                  fillColor: Colors.white,
                  label: Text("מספר טלפון"),
                  labelStyle: TextStyle(color: Color.fromRGBO(
                      190, 190, 190, 1.0)),
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(10))),
                ),
              ),
              SizedBox(
                height: 40,
                width: 170,
                child: MaterialButton(
                  focusElevation: 10,
                  onPressed: () {},
                  color: const Color.fromRGBO(86, 154, 82, 1),
                  child: Text("לקבלת קוד חד פעמי", style: GoogleFonts.heebo(color: Colors.white)),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
