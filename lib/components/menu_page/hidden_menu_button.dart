import 'package:flutter/material.dart';
import 'package:rxdart/rxdart.dart';

import '../../models/global_model.dart';

class HiddenMenuButton extends StatefulWidget {
  const HiddenMenuButton({
    Key? key,
    required this.label,
    required this.hiddenMenu,
    required this.hiddenMenuHeight,
    this.onShowingEnd,
    this.onNShowingEnd,
  }) : super(key: key);

  final String label;
  final Widget hiddenMenu;
  final double hiddenMenuHeight;
  final Function? onShowingEnd;
  final Function? onNShowingEnd;

  @override
  State<HiddenMenuButton> createState() => _HiddenMenuButtonState();
}

class _HiddenMenuButtonState extends State<HiddenMenuButton> {
  final _turnsSubject = BehaviorSubject<double>();
  final _turningDuration = const Duration(milliseconds: 150);
  final _animationDuration = const Duration(milliseconds: 300);

  final _dividerColor = const Color.fromRGBO(206, 206, 206, 1);
  final _iconColor = const Color.fromRGBO(180, 200, 210, 1);

  final String _iconImage = 'assets/menuPage/hidden_menu_icon_4.png';

  bool _isShowing = false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    _turnsSubject.add(0);
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();

    _turnsSubject.close();
  }

  @override
  Widget build(BuildContext context) {
    final double buttonHeight = appHeight * 0.07;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
        Container(
          color: _dividerColor,
          width: double.infinity,
          child: const SizedBox(height: 1),
        ),
        Container(
          height: appHeight * 0.071,
          padding: EdgeInsets.only(
            left: appHeight * 0.02,
            right: appHeight * 0.02,
          ),
          child: MaterialButton(
            padding: EdgeInsets.zero,
            splashColor: Colors.transparent,
            highlightColor: Colors.transparent,
            child: StreamBuilder(
                stream: _turnsSubject.stream,
                builder: (context, AsyncSnapshot<double> snapshot) {
                  if(snapshot.hasData) {
                    return Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Row(
                          children: [
                            Image.asset(
                              _iconImage,
                              color: _iconColor,
                              height: appHeight * 0.045,
                            ),
                            SizedBox(
                              width: appHeight * 0.02,
                            ),
                            Text(
                              widget.label,
                              style: TextStyle(
                                color: Colors.black,
                                fontSize: 20,
                                fontWeight: ((snapshot.data!) == 0)
                                    ? FontWeight.w500
                                    : FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                        AnimatedRotation(
                          duration: _turningDuration,
                          turns: snapshot.data!,
                          child: Image.asset(
                            'assets/menuPage/arrow_down.png',
                            height: 20,
                          ),
                          onEnd: () {},
                        ),
                      ],
                    );
                  }

                  return Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Row(
                        children: [
                          Image.asset(
                            _iconImage,
                            color: _iconColor,
                            height: appHeight * 0.045,
                          ),
                          SizedBox(
                            width: appHeight * 0.02,
                          ),
                          Text(
                            widget.label,
                            style: const TextStyle(
                              color: Colors.black,
                              fontSize: 20,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                      AnimatedRotation(
                        duration: const Duration(seconds: 0),
                        turns: 0,
                        child: Image.asset(
                          'assets/menuPage/arrow_down.png',
                          height: 20,
                        ),
                        onEnd: () {},
                      ),
                    ],
                  );
                }),
            onPressed: () {
              if (_isShowing) {
                if (widget.onNShowingEnd != null) {
                  widget.onNShowingEnd?.call();
                }
                _turnsSubject.add(0);
              } else {
                _turnsSubject.add(1 / 2);
                if (widget.onShowingEnd != null) {
                  widget.onShowingEnd?.call();
                }
              }

              _isShowing = !_isShowing;
            },
          ),
        ),
        StreamBuilder(
          stream: _turnsSubject.stream,
          builder: (context, AsyncSnapshot<double> snapshot) {
            if(snapshot.hasData) {
              return AnimatedContainer(
                duration: _animationDuration,
                height: ((snapshot.data!) == 1 / 2)
                    ? widget.hiddenMenuHeight
                    : 0,
                child: widget.hiddenMenu,
              );
            }

            return const SizedBox.shrink();
          },
        ),
      ],
    );
  }
}
