import 'package:flutter/material.dart';

class JustButton extends StatelessWidget {
  const JustButton({
    Key? key,
    required this.label,
    required this.onPress,
  }) : super(key: key);

  final String label;
  final Function onPress;

  @override
  Widget build(BuildContext context) {
    final appHeight =
        MediaQuery.of(context).size.height - MediaQuery.of(context).padding.top;

    return Container(
      height: appHeight * 0.045,
      margin: EdgeInsets.only(
        top: appHeight * 0.01,
        left: appHeight * 0.02,
        right: appHeight * 0.02,
        bottom: appHeight * 0.02,
      ),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(5),
        color: const Color.fromRGBO(227, 227, 234, 1),
      ),
      child: MaterialButton(
        padding: EdgeInsets.zero,
        splashColor: Colors.transparent,
        onPressed: () {
          onPress.call();
        },
        child: Center(
          child: Text(
            label,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
    );
  }
}
