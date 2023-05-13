import 'package:flutter/material.dart';
import 'gradient_container.dart';

final colors = [
  const Color.fromRGBO(122, 121, 121, 1),
  const Color.fromRGBO(60, 58, 59, 1),
];

void main() {
  runApp(MaterialApp(
    debugShowCheckedModeBanner: false,
    home: Scaffold(
      body:
          GradientContainer(colors),
    ),
  ));
}
