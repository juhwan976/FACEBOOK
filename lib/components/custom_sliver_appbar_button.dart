import 'package:flutter/material.dart';

import '../models/global_model.dart';

class CustomSliverAppBarButton extends StatelessWidget {
  const CustomSliverAppBarButton({
    Key? key,
    required this.iconData,
    this.onPressed,
  }) : super(key: key);

  final IconData iconData;
  final Function? onPressed;

  @override
  Widget build(BuildContext context) {

    return Container(
      width: appHeight * 0.045,
      height: appHeight * 0.045,
      decoration: const BoxDecoration(
        color: Color.fromRGBO(228, 230, 234, 1),
        shape: BoxShape.circle,
      ),
      child: IconButton(
        splashColor: Colors.transparent,
        highlightColor: Colors.transparent,
        padding: EdgeInsets.zero,
        icon: Icon(iconData, color: Colors.black),
        onPressed: onPressed?.call(),
      ),
    );
  }
}
