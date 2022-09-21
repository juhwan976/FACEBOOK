import 'package:flutter/material.dart';

import '../../models/global_model.dart';

class ShortCutButton extends StatelessWidget {
  ShortCutButton({
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
            left: appWidth * 0.0125,
            right: appWidth * 0.0125,
            bottom: appWidth * 0.0125 * 2),
        height: appHeight * 0.09,
        width: appWidth * 0.45,
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
        child: GestureDetector(
          onTap: () {},
          child: Container(
            padding: EdgeInsets.only(
              top: appHeight * 0.013,
              left: appWidth * 0.022,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                SizedBox(
                  height: appHeight * 0.04,
                  child: Image.asset(
                    image ?? '',
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(
                    top: appHeight * 0.001,
                    left: appWidth * 0.01,
                  ),
                  child: Text(
                    label ?? 'null',
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 17,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
