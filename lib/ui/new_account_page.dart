// ignore_for_file: file_names

import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../bloc/new_account_bloc.dart';
import '../components/login_page/input_form.dart';
import '../models/global_model.dart';

class NewAccountPage extends StatefulWidget {
  const NewAccountPage({Key? key}) : super(key: key);

  @override
  State<NewAccountPage> createState() => _NewAccountPageState();
}

class _NewAccountPageState extends State<NewAccountPage> {
  final Color _borderColor = Colors.white;
  final Color _cursorColor = Colors.white;
  final Color _fontColor = Colors.white;

  final TextEditingController _idController = TextEditingController();
  final TextEditingController _pwController = TextEditingController();
  final TextEditingController _nameController = TextEditingController();

  final FocusNode _textFocusNode = FocusNode();

  final _newAccountBloc = NewAccountBloc();

  @override
  dispose() {
    super.dispose();

    _idController.dispose();
    _pwController.dispose();
    _nameController.dispose();

    _textFocusNode.dispose();

    _newAccountBloc.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
        _newAccountBloc.setButtonFalse();
      },
      child: Scaffold(
        appBar: AppBar(
          elevation: 0.0,
          title: const Text('새 계정 만들기'),
          leading: CupertinoButton(
              child: const Icon(Icons.navigate_before),
              onPressed: () {
                Navigator.of(context).pop();
              }),
          actions: <Widget>[
            CupertinoButton(
              child: const Text('생성하기'),
              onPressed: () async {
                if (_idController.text.isNotEmpty &&
                    _pwController.text.isNotEmpty &&
                    _nameController.text.isNotEmpty) {
                  late BuildContext alertContext;

                  _textFocusNode.unfocus();

                  showCupertinoDialog(
                    context: context,
                    builder: (context) {
                      alertContext = context;

                      return const CupertinoAlertDialog(
                        content: CupertinoActivityIndicator(),
                        actions: <Widget>[
                          SizedBox.shrink(),
                        ],
                      );
                    },
                  );

                  try {
                    UserCredential authCredential = await FirebaseAuth.instance
                        .createUserWithEmailAndPassword(
                      email: _idController.text,
                      password: _pwController.text,
                    );

                    authCredential.user!.sendEmailVerification();
                  } catch (error) {
                    log('Error : $error');
                  }

                  await FirebaseFirestore.instance
                      .collection('user')
                      .doc(FirebaseAuth.instance.currentUser!.uid.toString())
                      .set(
                      {'name': _nameController.text, 'date': DateTime.now()});

                  // ignore: use_build_context_synchronously
                  Navigator.of(alertContext).pop();
                } else {
                  showCupertinoDialog(
                    context: context,
                    builder: (context) {
                      return CupertinoAlertDialog(
                        content: const Text('비어있는 항목이 없도록 모두 작성해주세요.'),
                        actions: <Widget>[
                          CupertinoButton(
                            child: const Text('확인'),
                            onPressed: () {
                              Navigator.of(context).pop();
                            },
                          ),
                        ],
                      );
                    },
                  );
                }
              },
            ),
          ],
        ),
        body: Column(
          children: <Widget>[
            SizedBox(
              width: appWidth,
              height: appHeight * 0.03,
            ),
            Container(
              width: appWidth * 0.9,
              height: appHeight * 0.0575 * 2,
              decoration: BoxDecoration(
                border: Border.all(color: _borderColor),
                borderRadius: const BorderRadius.all(Radius.circular(5.0)),
              ),
              child: Column(
                children: <Widget>[
                  InputForm(
                    controller: _idController,
                    buttonStream: _newAccountBloc.idButton,
                    inputType: InputType.id,
                    focusNode: _textFocusNode,
                    existNext: true,
                    height: appHeight * 0.0555,
                    hint: '전화번호 또는 이메일 주소',
                    visibleBorder: false,
                  ),
                  Container(
                    height: 1,
                    color: _borderColor,
                  ),
                  InputForm(
                    controller: _pwController,
                    buttonStream: _newAccountBloc.pwButton,
                    inputType: InputType.pw,
                    focusNode: _textFocusNode,
                    existNext: true,
                    height: appHeight * 0.0555,
                    hint: '비밀번호',
                    visibleBorder: false,
                    obscureText: true,
                  ),
                ],
              ),
            ),
            SizedBox(
              height: appHeight * 0.03,
            ),
            InputForm(
              controller: _nameController,
              buttonStream: _newAccountBloc.nameButton,
              inputType: InputType.name,
              focusNode: _textFocusNode,
              borderColor: _borderColor,
              fontColor: _fontColor,
              cursorColor: _cursorColor,
              existNext: false,
              hint: '이름',
            ),
          ],
        ),
      ),
    );
  }
}
