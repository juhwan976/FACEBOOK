import 'package:flutter/material.dart';
import 'package:rxdart/rxdart.dart';

class InputForm extends StatelessWidget {
  const InputForm({
    Key? key,
    required this.controller,
    required this.behaviorSubject,
    required this.focusNode,
    required this.hint,
    this.borderColor = Colors.white,
    this.cursorColor = Colors.white,
    this.fontColor = Colors.white,
    this.existNext = false,
    this.obscureText = false,
    this.height = 0.0,
    this.contentPadding = const EdgeInsets.only(left: 12.5, top: 12.5),
    this.visibleBorder = true,
    this.onTap()?,
    this.onSubmitted()?,
    this.onChanged()?,
  }) : super(key: key);

  final TextEditingController controller;
  final BehaviorSubject behaviorSubject;
  final FocusNode focusNode;
  final String hint;
  final Color borderColor;
  final Color cursorColor;
  final Color fontColor;
  final bool existNext;
  final bool obscureText;
  final double height;
  final EdgeInsets contentPadding;
  final bool visibleBorder;
  final Function? onTap;
  final Function? onSubmitted;
  final Function? onChanged;

  void revealOrHideButton() {
    if (controller.text.isEmpty) {
      behaviorSubject.add(false);
    } else {
      behaviorSubject.add(true);
    }
  }

  @override
  Widget build(BuildContext context) {
    final double appHeight =
        MediaQuery.of(context).size.height - MediaQuery.of(context).padding.top;
    final double appWidth = MediaQuery.of(context).size.width;

    return Container(
      width: appWidth * 0.9,
      height: height == 0.0 ? appHeight * 0.0575 : height,
      decoration: visibleBorder
          ? BoxDecoration(
              borderRadius: BorderRadius.circular(5.0),
              border: Border.all(color: borderColor),
            )
          : null,
      padding: EdgeInsets.zero,
      child: TextFormField(
        textInputAction:
            existNext ? TextInputAction.next : TextInputAction.done,
        controller: controller,
        //focusNode: focusNode,
        cursorColor: cursorColor,
        obscureText: obscureText,
        decoration: InputDecoration(
          isDense: true,
          contentPadding: contentPadding,
          border: InputBorder.none,
          hintText: hint,
          hintStyle: TextStyle(
            color: fontColor,
          ),
          suffixIcon: StreamBuilder(
            stream: behaviorSubject.stream,
            builder: (context, snapshot) {
              if (snapshot.data == true) {
                return IconButton(
                  icon: const Icon(Icons.cancel),
                  color: borderColor,
                  onPressed: () {
                    controller.clear();
                    behaviorSubject.add(false);
                  },
                );
              } else {
                return const SizedBox.shrink();
              }
            },
          ),
        ),
        style: TextStyle(
          color: fontColor,
        ),
        onTap: () {
          revealOrHideButton();
          onTap?.call();
        },
        onFieldSubmitted: (_) {
          behaviorSubject.add(false);
          onSubmitted?.call();
        },
        onChanged: (_) {
          revealOrHideButton();
          onChanged?.call();
        },
      ),
    );
  }
}
