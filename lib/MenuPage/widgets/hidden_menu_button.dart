import 'package:flutter/material.dart';
import 'package:rxdart/rxdart.dart';

class HiddenMenuButton extends StatefulWidget {
  const HiddenMenuButton({
    Key? key,
    required this.label,
  }) : super(key: key);

  final String label;

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
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Row(
                  children: [
                    Text(widget.label),
                  ],
                ),
                StreamBuilder(
                    stream: _turnsSubject.stream,
                    builder: (context, AsyncSnapshot<double> snapshot) {
                      return AnimatedRotation(
                        duration: Duration(milliseconds: 150),
                        turns: snapshot.data ?? 0,
                        child: Image.asset('assets/menuPage/arrow_down.png',
                            height: 20),
                        onEnd: () {},
                      );
                    }),
              ],
            ),
            onPressed: () {
              if (!isShowing) {
                _turnsSubject.add(1 / 2);
              } else {
                _turnsSubject.add(0);
              }
              isShowing = !isShowing;
            },
          ),
        ),
      ],
    );
  }
}
