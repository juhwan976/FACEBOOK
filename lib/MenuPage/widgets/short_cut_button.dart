import 'package:flutter/material.dart';
import 'package:rxdart/rxdart.dart';

class ShortCutButton extends StatelessWidget {
  const ShortCutButton({
    Key? key,
    required this.image,
    required this.label,
  }) : super(key: key);

  final String image;
  final String label;

  @override
  Widget build(BuildContext context) {
    final double appHeight =
        MediaQuery.of(context).size.height - MediaQuery.of(context).padding.top;
    final double appWidth = MediaQuery.of(context).size.width;

    return ClipRRect(
      borderRadius: BorderRadius.circular(5.0),
      child: Container(
        margin: EdgeInsets.only(
            left: appWidth * 0.0125,
            right: appWidth * 0.0125,
            bottom: appWidth * 0.0125 * 2),
        height: appHeight * 0.09,
        width: appWidth * 0.45,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(5.0),
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
                    image,
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(
                    top: appHeight * 0.001,
                    left: appWidth * 0.01,
                  ),
                  child: Text(
                    this.label,
                    style: TextStyle(
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
