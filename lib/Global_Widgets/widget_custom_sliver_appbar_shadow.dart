import 'package:flutter/material.dart';

class CustomSliverAppBarShadow extends StatelessWidget {
  CustomSliverAppBarShadow({
    Key? key,
    required this.scrollOffsetStream,
  }) : super(key: key);

  final Stream<double> scrollOffsetStream;

  final double _appBarHeight = const SliverAppBar().toolbarHeight;

  final double shadowHeight = 1.0;

  get height => shadowHeight;

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: scrollOffsetStream,
      builder: (context, snapshot) {
        if (snapshot.data == null) {
          return const SizedBox.shrink();
        }

        return Opacity(
          opacity: ((snapshot.data as double) >= _appBarHeight)
              ? 1
              : ((snapshot.data as double <= 0)
                  ? 0
                  : (snapshot.data as double) / _appBarHeight),
          child: Container(
            height: shadowHeight,
            color: const Color.fromRGBO(206, 206, 206, 1),
          ),
        );
      },
    );
  }
}
