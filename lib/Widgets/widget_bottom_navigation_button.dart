import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:rxdart/rxdart.dart';

class BottomNavigationButton extends StatefulWidget {
  const BottomNavigationButton({
    Key? key,
    this.indicatorWidth = 50,
    this.indicatorHeight = 5,
    required this.currentIndexSubject,
    required this.delaySubject,
    required this.thisIndex,
  }) : super(key: key);

  final double indicatorWidth;
  final double indicatorHeight;
  final BehaviorSubject<int> currentIndexSubject;
  final BehaviorSubject<int> delaySubject;
  final int thisIndex;

  @override
  State<BottomNavigationButton> createState() => _BottomNavigationButtonState();
}

class _BottomNavigationButtonState extends State<BottomNavigationButton> {

  @override
  initState() {
    super.initState();
  }

  @override
  dispose() {
    super.dispose();
  }

  int _calDelay() {
    if((50 / (widget.thisIndex - widget.currentIndexSubject.stream.value).abs()).isInfinite) {
      return 50;
    }
    return (50 / (widget.thisIndex - widget.currentIndexSubject.stream.value).abs()).round();
  }

  @override
  build(BuildContext context) {
    int before = 0;

    return SizedBox(
      width: widget.indicatorWidth,
      child: Column(
        children: <Widget>[
          Container(
            width: widget.indicatorWidth,
            height: widget.indicatorHeight,
            child: Row(
              children: <Widget>[
                StreamBuilder(
                    stream: widget.currentIndexSubject.stream,
                    builder: (context, snapshot) {
                      if (snapshot.data == null) {
                        return const SizedBox.shrink();
                      }
                      return AnimatedContainer(
                        width: (((snapshot.data as int) - widget.thisIndex) > 0)
                            ? widget.indicatorWidth
                            : 0,
                        duration: Duration(milliseconds: widget.delaySubject.stream.value),
                        child: null,
                      );
                    }),
                Flexible(
                  fit: FlexFit.tight,
                  child: Container(
                    color: Theme.of(context).primaryColor,
                  ),
                ),
                StreamBuilder(
                  stream: widget.currentIndexSubject.stream,
                  builder: (context, snapshot) {
                    if (snapshot.data == null) {
                      return const SizedBox.shrink();
                    }
                    return AnimatedContainer(
                      width: (((snapshot.data as int) - widget.thisIndex) < 0)
                          ? widget.indicatorWidth
                          : 0,
                      duration: Duration(milliseconds: widget.delaySubject.stream.value),
                      child: null,
                    );
                  },
                ),
              ],
            ),
          ),
          IconButton(
            icon: Icon(Icons.settings),
            onPressed: () async {
              widget.delaySubject.add(_calDelay());
              if (widget.thisIndex > widget.currentIndexSubject.stream.value) {
                for (int i = widget.currentIndexSubject.stream.value + 1;
                    i <= widget.thisIndex;
                    i++) {
                  widget.currentIndexSubject.add(i);
                  await Future.delayed(Duration(milliseconds: widget.delaySubject.stream.value));
                }
              } else {
                for (int i = widget.currentIndexSubject.stream.value - 1;
                    i >= widget.thisIndex;
                    i--) {
                  widget.currentIndexSubject.add(i);
                  await Future.delayed(Duration(milliseconds: widget.delaySubject.stream.value));
                }
              }
            },
          ),
        ],
      ),
    );
  }
}
