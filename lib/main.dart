import 'package:flutter/material.dart';
import 'package:noteify/pages/dashboard_page.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Noteify',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: DashboardPage(),
    );
  }
}
