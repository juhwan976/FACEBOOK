import 'package:facebook/firebase_options.dart';
import 'package:facebook/loading_page.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Facebook Clone',
      theme: ThemeData(),
      darkTheme: ThemeData.dark(),
      // ignore: prefer_const_constructors
      home: LoadingPage(),
    );
  }
}