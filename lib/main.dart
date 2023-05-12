import 'package:flutter/material.dart';
import 'gradient_container.dart';

final colors = [
  Colors.blue.shade700,
  Colors.blue,
  Colors.cyan,
  Colors.cyan.shade200,
];

void main() {
  runApp(MaterialApp(
    debugShowCheckedModeBanner: false,
    home: Scaffold(
      body: GradientContainer(colors),
    ),
  ));
}


