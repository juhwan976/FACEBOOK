import 'package:flutter/material.dart';

import '../../models/global_model.dart';

class InfoButton extends StatelessWidget {
  const InfoButton({
    Key? key,
    required this.icon,
    required this.info,
    this.onPressed,
    this.isLast = false,
  }) : super(key: key);

  final IconData icon;
  final String info;
  final Function? onPressed;
  final bool isLast;

  final infoColor = const Color.fromRGBO(185, 186, 189, 1);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: appHeight * 0.0525,
      width: appWidth,
      child: MaterialButton(
        padding: EdgeInsets.only(
          left: appWidth * 0.04,
          right: appWidth * 0.04,
        ),
        elevation: 0,
        focusElevation: 0,
        hoverElevation: 0,
        highlightElevation: 0,
        splashColor: Colors.transparent,
        highlightColor: Colors.transparent,
        child: Row(
          children: [
            Container(
              margin: EdgeInsets.only(
                right: appWidth * 0.02,
              ),
              child: Icon(
                icon,
                color: isLast ? Colors.black : infoColor,
                size: 25,
              ),
            ),
            Text(
              info,
              style: TextStyle(
                color: isLast ? Colors.black : infoColor,
                fontSize: 20,
              ),
            ),
          ],
        ),
        onPressed: () {
          onPressed?.call();
        },
      ),
    );
  }
}
