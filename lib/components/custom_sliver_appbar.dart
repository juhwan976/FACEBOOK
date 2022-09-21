import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../models/global_model.dart';
import 'custom_sliver_appbar_button.dart';

class CustomSliverAppBar extends StatelessWidget {
  const CustomSliverAppBar({
    Key? key,
    required this.title,
    required this.buttonList,
  }) : super(key: key);

  final String title;
  final List<CustomSliverAppBarButton> buttonList;

  @override
  Widget build(BuildContext context) {

    final List<Widget> widgetList = List.generate(
      (buttonList.length.isOdd
              ? (buttonList.length - 1) ~/ 2
              : (buttonList.length ~/ 2)) +
          buttonList.length +
          2,
      (index) {
        if (index == 0) {
          return Text(
            title,
            style: const TextStyle(
              fontSize: 30,
            ),
          );
        } else if (index == 1) {
          return const Flexible(
            fit: FlexFit.tight,
            child: SizedBox.shrink(),
          );
        } else if (index % 2 == 0) {
          return buttonList.elementAt(((index - 1) / 2).floor());
        } else {
          return SizedBox(
            width: appWidth * 0.025,
          );
        }
      },
    );

    return SliverAppBar(
      //toolbarHeight: const SliverAppBar().toolbarHeight - MediaQuery.of(context).padding.top,
      backgroundColor: Colors.transparent,
      elevation: 0,
      floating: false,
      pinned: false,
      leading: const SizedBox.shrink(),
      leadingWidth: 0,
      titleTextStyle: const TextStyle(
        color: Colors.black,
        fontSize: 20,
        fontWeight: FontWeight.bold,
      ),
      title: Row(
        children: widgetList,
      ),
    );
  }
}
