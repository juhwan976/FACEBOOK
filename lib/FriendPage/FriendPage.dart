// ignore_for_file: file_names

import 'package:flutter/material.dart';

class FriendPage extends StatefulWidget {
  const FriendPage({Key? key}) : super(key: key);

  @override
  State<FriendPage> createState() => _FriendPageState();
}

class _FriendPageState extends State<FriendPage> {
  CrossFadeState crossFadeState = CrossFadeState.showFirst;

  @override
  Widget build(BuildContext context) {
    // ignore: prefer_const_constructors
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            AnimatedCrossFade(
              firstChild: Icon(Icons.home_outlined),
              secondChild: Icon(
                Icons.home,
                color: Colors.blue,
              ),
              crossFadeState: crossFadeState,
              duration: Duration(milliseconds: 100),
            ),
            MaterialButton(
              child: Text('Toggle'),
              onPressed: () {
                if (crossFadeState == CrossFadeState.showFirst) {
                  crossFadeState = CrossFadeState.showSecond;
                } else {
                  crossFadeState = CrossFadeState.showFirst;
                }

                setState(() {});
              },
            ),
          ],
        ),
      ),
    );
  }
}
