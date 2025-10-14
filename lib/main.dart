import 'package:flutter/material.dart';
import 'package:havadurumu/screens/homepage.dart';

void main() {
  runApp(const Home());
}

class Home extends StatelessWidget {
  const Home({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: "Hava Durumu",
      home: Homepage(),
    );
  }
}
