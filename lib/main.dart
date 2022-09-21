import 'package:flutter/material.dart';

import 'ui/loading_page.dart';


void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {

    return MaterialApp(
      title: 'Facebook Clone',
      theme: ThemeData(),
      darkTheme: ThemeData.dark(),
      home: const LoadingPage(),
    );
  }
}