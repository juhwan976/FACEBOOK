import 'package:flutter/material.dart';

import '../../models/global_model.dart';

class AlarmTileProfile extends StatelessWidget {
  const AlarmTileProfile({
    Key? key,
    required this.uid,
  }) : super(key: key);

  final String uid;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(color: Colors.grey),
      ),
      height: appHeight * 0.088,
      child: Opacity(
        opacity: 0.2,
        child: Icon(
          Icons.account_circle,
          size: appHeight * 0.088,
          color: Colors.grey,
        ),
      ),
    );
  }
}
