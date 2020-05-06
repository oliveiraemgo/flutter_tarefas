import 'package:flutter/material.dart';
import 'package:tarefas/telas/main/main.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Tarefas',
      theme: ThemeData(
        primarySwatch: Colors.yellow,
      ),
      home: Main(),
    );

  }
}


