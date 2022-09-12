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
    required this.inactiveImageList,
    required this.activeImageList,
    required this.labelList,
    required this.onTap,
  }) : super(key: key);

  final int numOfIcon;
  final double indicatorHeight;
  final BehaviorSubject<int> currentIndexSubject;
  final BehaviorSubject<int> delaySubject;
  final int thisIndex;
  final BehaviorSubject<int> targetIndexSubject;
  final List<String> inactiveImageList;
  final List<String> activeImageList;
  final List<String> labelList;
  final Function onTap;

  @override
  State<BottomNavigationButton> createState() => _BottomNavigationButtonState();
}

class _BottomNavigationButtonState extends State<BottomNavigationButton> {
  final int _duration = 80;
  final Color _activeColor = const Color.fromRGBO(18, 119, 238, 1);
  final Color _inactiveColor = const Color.fromRGBO(100, 100, 100, 1);

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
    final double imageHeight = (MediaQuery.of(context).size.height - MediaQuery.of(context).padding.top) * 0.04;

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

                          return SizedBox(
                            height: imageHeight,
                            child: Center(
                              child: AnimatedCrossFade(
                                firstChild: Image.asset(
                                  widget.inactiveImageList.elementAt(widget.thisIndex),
                                  height: (widget.thisIndex > 2) ? imageHeight * 0.8 : imageHeight,
                                  color: _inactiveColor,
                                ),
                                secondChild: Image.asset(
                                  widget.activeImageList.elementAt(widget.thisIndex),
                                  height: (widget.thisIndex > 2) ? imageHeight * 0.8 : imageHeight,
                                  color: _activeColor,
                                ),
                                crossFadeState: (snapshot.data == widget.thisIndex)
                                    ? CrossFadeState.showSecond
                                    : CrossFadeState.showFirst,
                                duration: Duration(milliseconds: _duration),
                              ),
                            ),
                          );
                        }),
                    const SizedBox(height: 7),
                    Text(
                      widget.labelList.elementAt(widget.thisIndex),
                      style: TextStyle(
                        color: (widget.thisIndex == snapshot.data)
                            ? _activeColor
                            : _inactiveColor,
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
          widget.onTap.call();

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
