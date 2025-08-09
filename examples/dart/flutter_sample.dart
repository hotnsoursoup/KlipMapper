// <r:imports>
import 'package:flutter/material.dart';

// <r:app>
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // <r:build>
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(title: const Text('Hello')),
        body: const Center(child: Text('World')),
      ),
    );
  }
}
