import 'package:flutter/material.dart';

import '../models/alarm_data.dart';
import '../models/global_model.dart';

class WatchPageWithData extends StatefulWidget {
  const WatchPageWithData({
    Key? key,
    required this.data,
    required this.pageTransition,
  }) : super(key: key);

  final Function pageTransition;
  final AlarmData data;

  @override
  State<WatchPageWithData> createState() => _WatchPageWithDataState();
}

class _WatchPageWithDataState extends State<WatchPageWithData> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'WatchPageWithData',
              style: TextStyle(
                color: Colors.black,
              ),
            ),
            Text(
              '${widget.data.user}',
              style: TextStyle(
                color: Colors.black,
              ),
            ),
            Text(
              '${widget.data.content}',
              style: TextStyle(
                color: Colors.black,
              ),
            ),
            MaterialButton(
              child: Text('돌아가기',
                style: TextStyle(
                  color: Colors.black,
                ),
              ),
              onPressed: () {
                widget.pageTransition(4);
              },
            ),
          ],
        ),
      ),
    );
  }
}
