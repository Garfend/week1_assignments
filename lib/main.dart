import 'package:assignment1/ui/pages/home_page.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(AhwaaApp());
}

class AhwaaApp extends StatelessWidget {
  const AhwaaApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Ahwaa App',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: const HomePage(),
    );
  }
}
