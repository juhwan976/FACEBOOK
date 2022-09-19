import 'package:flutter/material.dart';

class AppBarHeaderDelegate extends SliverPersistentHeaderDelegate {
  AppBarHeaderDelegate({
    required this.color,
  });

  final double _height = 1;
  final Color color;

  @override
  Widget build(
      BuildContext context, double shrinkOffset, bool overlapsContent) {
    return SizedBox(
      //width: MediaQuery.of(context).size.width,
      height: _height,
      child: Container(
        color: color,
      ),
    );
  }

  @override
  double get maxExtent => _height;

  @override
  double get minExtent => _height;

  @override
  bool shouldRebuild(covariant SliverPersistentHeaderDelegate oldDelegate) {
    return true;
  }
}
