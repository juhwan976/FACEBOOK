import 'package:flutter/material.dart';

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
    double appHeight =
        MediaQuery.of(context).size.height - MediaQuery.of(context).padding.top;
    double appWidth = MediaQuery.of(context).size.width;

    return ClipRRect(
      borderRadius: _borderRadius,
      child: Container(
        margin: EdgeInsets.only(
          bottom: appWidth * 0.025,
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
            SizedBox(
              height: appHeight * 0.075,
              child: Image.asset(image as String),
            ),
            Text(label as String),
          ],
        ),
      ),
    );
  }
}
