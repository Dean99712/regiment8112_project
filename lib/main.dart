import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:regiment8112_project/login_screen.dart';
import 'gradient_container.dart';

final colors = [
  const Color.fromRGBO(60, 58, 59, 1),
  const Color.fromRGBO(60, 58, 59, 1)
  // const Color.fromRGBO(122, 121, 121, 1),
  // const Color.fromRGBO(60, 58, 59, 1),
];

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        floatingActionButton: FloatingActionButton(
          backgroundColor: const Color.fromRGBO(86, 154, 82, 1),
          elevation: 0,
          isExtended: true,
          onPressed: () {},
          child: SvgPicture.asset("assets/svg/add_image.svg",
              alignment: Alignment.center),
        ),
        // body: GradientContainer(colors),
        body: const LoginPage(),
      ),
    );
  }
}
