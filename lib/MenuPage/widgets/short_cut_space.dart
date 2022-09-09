import 'package:flutter/material.dart';

class ShortCutSpace extends StatelessWidget {
  const ShortCutSpace({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {


    return SizedBox(
      width: MediaQuery.of(context).size.width * 0.025,
    );
  }
}