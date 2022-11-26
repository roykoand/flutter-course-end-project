import 'homepage.dart' show HomePage;
import 'package:flutter/material.dart';

void main() {
  Widget testWidget = const MediaQuery(
      data: MediaQueryData(), child: MaterialApp(home: HomePage()));
  runApp(testWidget);
}
