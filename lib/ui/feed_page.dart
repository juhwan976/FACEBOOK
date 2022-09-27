// ignore_for_file: file_names

import 'package:flutter/material.dart';

class FeedPage extends StatefulWidget {
  const FeedPage({Key? key}) : super(key: key);

  @override
  State<FeedPage> createState() => _FeedPageState();
}

class _FeedPageState extends State<FeedPage> {
  CrossFadeState crossFadeState = CrossFadeState.showFirst;

  @override
  Widget build(BuildContext context) {
    // ignore: prefer_const_constructors
    return Scaffold(
      backgroundColor: Colors.white,
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
              child: Text(
                'Toggle',
                style: TextStyle(
                  color: Colors.black,
                ),
              ),
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
