import 'dart:developer';

import 'package:facebook/bloc/login_bloc.dart';
import 'package:flutter/material.dart';

class InputForm extends StatelessWidget {
  const InputForm({
    Key? key,
    required this.controller,
    required this.inputType,
    required this.buttonStream,
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
    this.onButtonPressed()?,
    this.onTap()?,
    this.onSubmitted()?,
    this.onChanged()?,
  }) : super(key: key);

  final TextEditingController controller;
  final InputType inputType;
  final Stream<bool> buttonStream;
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
  final Function? onButtonPressed;
  final Function? onTap;
  final Function? onSubmitted;
  final Function? onChanged;

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
            stream: buttonStream,
            builder: (context, snapshot) {
              if (snapshot.data == true) {
                return IconButton(
                  icon: const Icon(Icons.cancel),
                  color: borderColor,
                  onPressed: () {
                    controller.clear();
                    //_hideButton();
                    onButtonPressed?.call();
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
          //_revealOrHideButton();
          onTap?.call();
        },
        onFieldSubmitted: (_) {
          //_hideButton();
          onSubmitted?.call();
        },
        onChanged: (_) {
          //_revealOrHideButton();
          onChanged?.call();
        },
      ),
    );
  }
}

enum InputType { id, pw }
