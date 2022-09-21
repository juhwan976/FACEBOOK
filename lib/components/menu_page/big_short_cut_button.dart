import 'package:flutter/material.dart';

import '../../models/global_model.dart';

class BigShortCutButton extends StatelessWidget {
  BigShortCutButton({
    Key? key,
    required this.image,
    required this.label,
  }) : super(key: key);

  final String? image;
  final String? label;

  final BorderRadius _borderRadius = BorderRadius.circular(10);

  @override
  Widget build(BuildContext context) {

    return ClipRRect(
      borderRadius: _borderRadius,
      child: Container(
        margin: EdgeInsets.only(
          bottom: appWidth * 0.02,
          right: appWidth * 0.0375,
          left: appWidth * 0.0375,
        ),
        height: appHeight * 0.075,
        decoration: BoxDecoration(
          borderRadius: _borderRadius,
          color: Colors.white,
          boxShadow: <BoxShadow>[
            BoxShadow(
              color: Colors.grey.withOpacity(0.1),
              spreadRadius: 0,
              blurRadius: 5,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          children: <Widget>[
            Container(
              margin: EdgeInsets.only(
                left: appWidth * 0.01,
                right: appWidth * 0.015,
              ),
              child: Image.asset(
                image as String,
                height: appHeight * 0.04,
                color: Colors.grey,
              ),
            ),
            Text(
              label as String,
              style: TextStyle(
                color: Colors.black,
                fontSize: 18,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
