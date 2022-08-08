// ignore_for_file: file_names

import 'package:flutter/material.dart';
import 'package:rxdart/rxdart.dart';

import '../Widgets/widget_bottom_navigation_button.dart';

class WatchPage extends StatefulWidget {
  const WatchPage({Key? key}) : super(key: key);

  @override
  State<WatchPage> createState() => _WatchPageState();
}

class _WatchPageState extends State<WatchPage> {
  final BehaviorSubject<int> _currentIndexSubject = BehaviorSubject<int>();
  final BehaviorSubject<int> _delaySubject = BehaviorSubject<int>();

  @override
  initState() {
    super.initState();

    _currentIndexSubject.add(0);
    _delaySubject.add(50);
  }

  @override
  dispose() {
    super.dispose();

    _currentIndexSubject.close();
    _delaySubject.close();
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget> [
            Row(
              children: <Widget> [
                BottomNavigationButton(
                  currentIndexSubject: _currentIndexSubject,
                  delaySubject: _delaySubject,
                  thisIndex: 0,
                ),
                BottomNavigationButton(
                  currentIndexSubject: _currentIndexSubject,
                  delaySubject: _delaySubject,
                  thisIndex: 1,
                ),
                BottomNavigationButton(
                  currentIndexSubject: _currentIndexSubject,
                  delaySubject: _delaySubject,
                  thisIndex: 2,
                ),
                BottomNavigationButton(
                  currentIndexSubject: _currentIndexSubject,
                  delaySubject: _delaySubject,
                  thisIndex: 3,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}