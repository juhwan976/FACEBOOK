import 'package:flutter/material.dart';

import '../../models/global_model.dart';

class AlarmTileBottomSheetButton extends StatelessWidget {
  const AlarmTileBottomSheetButton({
    Key? key,
    required this.sideMargin,
    required this.icon,
    required this.text,
    required this.onPressed,
  }) : super(key: key);

  final double sideMargin;
  final IconData icon;
  final String text;
  final Function? onPressed;

  final Color _iconBackgroundColor = const Color.fromRGBO(205, 206, 211, 1);
  final Color _onPressedButtonColor = const Color.fromRGBO(228, 228, 228, 1);

  @override
  Widget build(BuildContext context) {
    return MaterialButton(
      padding: EdgeInsets.only(
        left: sideMargin,
        right: sideMargin,
      ),
      height: appHeight * 0.08,
      highlightColor: _onPressedButtonColor,
      splashColor: Colors.transparent,
      child: Row(
        children: [
          Container(
            height: appHeight * 0.055,
            width: appHeight * 0.055,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: _iconBackgroundColor,
            ),
            child: Icon(icon, color: Colors.black),
          ),
          Expanded(
            child: Padding(
              padding: EdgeInsets.only(
                left: sideMargin,
              ),
              child: Text(
                text,
                style: const TextStyle(
                  color: Colors.black,
                  fontSize: 20,
                ),
              ),
            ),
          ),
        ],
      ),
      onPressed: () {
        onPressed?.call();
      },
    );
  }
}
