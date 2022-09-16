import 'package:flutter/material.dart';
import 'package:rxdart/rxdart.dart';

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
  final BehaviorSubject<double> _turnsSubject = BehaviorSubject<double>();

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
    final double appHeight =
        MediaQuery.of(context).size.height - MediaQuery.of(context).padding.top;

    final double buttonHeight = appHeight * 0.065;

    bool isShowing = false;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
        Container(
          color: Color.fromRGBO(206, 206, 206, 1),
          width: double.infinity,
          child: SizedBox(height: 1),
        ),
        Container(
          height: appHeight * 0.065,
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
                  return Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Row(
                        children: [
                          Image.asset(
                            'assets/menuPage/hidden_menu_icon_4.png',
                            color: Color.fromRGBO(180, 200, 210, 1),
                            height: appHeight * 0.04,
                          ),
                          SizedBox(
                            width: appHeight * 0.02,
                          ),
                          Text(
                            widget.label,
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: ((snapshot.data ?? 0) == 0)
                                  ? FontWeight.w500
                                  : FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                      AnimatedRotation(
                        duration: Duration(milliseconds: 150),
                        turns: snapshot.data ?? 1/2,
                        child: Image.asset('assets/menuPage/arrow_down.png',
                            height: 20),
                        onEnd: () {},
                      ),
                    ],
                  );
                }),
            onPressed: () {
              if (isShowing) {
                if (widget.onNShowingEnd != null) {
                  widget.onNShowingEnd?.call();
                }
                _turnsSubject.add(0);
              } else {
                _turnsSubject.add(1/2);
                if (widget.onShowingEnd != null) {
                  widget.onShowingEnd?.call();
                }
              }

              isShowing = !isShowing;
            },
          ),
        ),
        StreamBuilder(
            stream: _turnsSubject.stream,
            builder: (context, AsyncSnapshot<double> snapshot) {
              return AnimatedContainer(
                duration: Duration(milliseconds: 150),
                height:
                    ((snapshot.data ?? 1/2) == 1/2) ? widget.hiddenMenuHeight : 0,
                child: widget.hiddenMenu,
              );
            }),
      ],
    );
  }
}
