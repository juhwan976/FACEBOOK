import 'package:flutter/material.dart';
import 'package:rxdart/rxdart.dart';

class BottomNavigationButton extends StatefulWidget {
  const BottomNavigationButton({
    Key? key,
    required this.numOfIcon,
    this.indicatorHeight = 3,
    required this.currentIndexSubject,
    required this.delaySubject,
    required this.thisIndex,
    required this.targetIndexSubject,
    required this.inactiveIconList,
    required this.activeIconList,
    required this.labelList,
  }) : super(key: key);

  final int numOfIcon;
  final double indicatorHeight;
  final BehaviorSubject<int> currentIndexSubject;
  final BehaviorSubject<int> delaySubject;
  final int thisIndex;
  final BehaviorSubject<int> targetIndexSubject;
  final List<IconData> inactiveIconList;
  final List<IconData> activeIconList;
  final List<String> labelList;

  @override
  State<BottomNavigationButton> createState() => _BottomNavigationButtonState();
}

class _BottomNavigationButtonState extends State<BottomNavigationButton> {
  final int _duration = 80;

  @override
  initState() {
    super.initState();
  }

  @override
  dispose() {
    super.dispose();
  }

  int _calDelay() {
    if ((_duration /
            (widget.thisIndex - widget.currentIndexSubject.stream.value).abs())
        .isInfinite) {
      return _duration;
    }
    return (_duration /
            (widget.thisIndex - widget.currentIndexSubject.stream.value).abs())
        .round();
  }

  @override
  build(BuildContext context) {
    return SizedBox(
      width: MediaQuery.of(context).size.width / widget.numOfIcon,
      child: MaterialButton(
        padding: EdgeInsets.zero,
        splashColor: Colors.transparent,
        child: Column(
          children: <Widget>[
            Container(
              width: MediaQuery.of(context).size.width / widget.numOfIcon,
              height: widget.indicatorHeight,
              padding: EdgeInsets.zero,
              child: Row(
                children: <Widget>[
                  StreamBuilder(
                      stream: widget.currentIndexSubject.stream,
                      builder: (context, snapshot) {
                        if (snapshot.data == null) {
                          return const SizedBox.shrink();
                        }
                        return AnimatedContainer(
                          width:
                              (((snapshot.data as int) - widget.thisIndex) > 0)
                                  ? MediaQuery.of(context).size.width /
                                      widget.numOfIcon
                                  : 0,
                          duration: Duration(
                              milliseconds: widget.delaySubject.stream.value),
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
                            ? MediaQuery.of(context).size.width /
                                widget.numOfIcon
                            : 0,
                        duration: Duration(
                            milliseconds: widget.delaySubject.stream.value),
                        child: null,
                      );
                    },
                  ),
                ],
              ),
            ),
            const SizedBox(height: 6),
            StreamBuilder(
              stream: widget.targetIndexSubject.stream,
              builder: (context, snapshot) {
                if (snapshot.data == null) {
                  return const SizedBox.shrink();
                }
                return Column(
                  children: <Widget>[
                    StreamBuilder(
                        stream: widget.targetIndexSubject.stream,
                        builder: (context, snapshot) {
                          if (snapshot.data == null) {
                            return const SizedBox.shrink();
                          }

                          return AnimatedCrossFade(
                            firstChild: Icon(
                              widget.inactiveIconList
                                  .elementAt(widget.thisIndex),
                              color: Colors.grey,
                            ),
                            secondChild: Icon(
                              widget.activeIconList.elementAt(widget.thisIndex),
                              color: Theme.of(context).primaryColor,
                            ),
                            crossFadeState: (snapshot.data == widget.thisIndex)
                                ? CrossFadeState.showSecond
                                : CrossFadeState.showFirst,
                            duration: Duration(milliseconds: _duration),
                          );
                        }),
                    const SizedBox(height: 7),
                    Text(
                      widget.labelList.elementAt(widget.thisIndex),
                      style: TextStyle(
                        color: (widget.thisIndex == snapshot.data)
                            ? Theme.of(context).primaryColor
                            : Colors.grey,
                        fontSize: 11,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                );
              },
            ),
          ],
        ),
        onPressed: () async {
          widget.delaySubject.add(_calDelay());
          widget.targetIndexSubject.add(widget.thisIndex);

          if (widget.thisIndex > widget.currentIndexSubject.stream.value) {
            for (int i = widget.currentIndexSubject.stream.value + 1;
            i <= widget.thisIndex;
            i++) {
              widget.currentIndexSubject.add(i);
              await Future.delayed(
                  Duration(milliseconds: widget.delaySubject.stream.value));
            }
          } else {
            for (int i = widget.currentIndexSubject.stream.value - 1;
            i >= widget.thisIndex;
            i--) {
              widget.currentIndexSubject.add(i);
              await Future.delayed(
                  Duration(milliseconds: widget.delaySubject.stream.value));
            }
          }
        },
      ),
    );
  }
}
