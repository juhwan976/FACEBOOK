// ignore_for_file: file_names

import 'dart:developer';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:rxdart/rxdart.dart';

import '../MainPage/MainPage.dart';
import '../NewAccountPage/NewAccountPage.dart';
import '../Widgets/widget_input_form.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({
    Key? key,
  }) : super(key: key);

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  bool visibleIdButton = false;
  bool visiblePwButton = false;
  bool init = true;

  final Color _borderColor = Colors.white;

  final Duration _animationDuration = const Duration(milliseconds: 250);

  final TextEditingController _idController = TextEditingController();
  final TextEditingController _pwController = TextEditingController();

  final BehaviorSubject<double> _appBarHeightSubject =
      BehaviorSubject<double>();
  final BehaviorSubject<bool> _idButtonSubject = BehaviorSubject<bool>();
  final BehaviorSubject<bool> _pwButtonSubject = BehaviorSubject<bool>();
  final BehaviorSubject<bool> _indicatorSubject = BehaviorSubject<bool>();
  final BehaviorSubject<bool> _loginButtonSubject = BehaviorSubject<bool>();

  final FocusNode _textFocusNode = FocusNode();

  void _activateLoginButton() {
    if (_idController.text.isNotEmpty && _pwController.text.isNotEmpty) {
      _loginButtonSubject.add(true);
    } else {
      _loginButtonSubject.add(false);
    }
  }

  void _inputFormOnChanged() {
    if (_idController.text.isNotEmpty && _pwController.text.isNotEmpty) {
      _loginButtonSubject.add(true);
    }
  }

  @override
  initState() {
    super.initState();
  }

  @override
  dispose() {
    super.dispose();

    _idController.dispose();
    _pwController.dispose();
    _textFocusNode.dispose();

    _appBarHeightSubject.close();
    _idButtonSubject.close();
    _pwButtonSubject.close();
    _indicatorSubject.close();
  }

  @override
  Widget build(BuildContext context) {
    final double appHeight = MediaQuery.of(context).size.height - MediaQuery.of(context).padding.top;
    final double appWidth = MediaQuery.of(context).size.width;

    if (init) {
      _loginButtonSubject.add(false);
      _appBarHeightSubject.add(appHeight * 0.24);
      init = false;
    }

    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
        _appBarHeightSubject.add(appHeight * 0.24);
        _idButtonSubject.add(false);
        _pwButtonSubject.add(false);
        _activateLoginButton();
      },
      child: Scaffold(
        body: Column(
          children: <Widget>[
            StreamBuilder<double>(
              stream: _appBarHeightSubject.stream,
              builder: (context, snapshot) {
                return AnimatedContainer(
                  duration: _animationDuration,
                  height:
                      MediaQuery.of(context).padding.top + (snapshot.data ?? 0),
                  color: Colors.blue,
                );
              },
            ),
            StreamBuilder(
                stream: _appBarHeightSubject.stream,
                builder: (context, snapshot) {
                  return AnimatedContainer(
                    height: (snapshot.data == appHeight * 0.24)
                        ? appHeight * 0.055
                        : appHeight * 0.026,
                    duration: _animationDuration,
                    child: const SizedBox.shrink(),
                  );
                }),
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
                    behaviorSubject: _idButtonSubject,
                    focusNode: _textFocusNode,
                    height: appHeight * 0.0555,
                    visibleBorder: false,
                    existNext: true,
                    hint: '전화번호 또는 이메일',
                    onTap: () {
                      _appBarHeightSubject.add(appHeight * 0.12);
                    },
                    onChanged: _inputFormOnChanged,
                  ),
                  Container(
                    height: 1,
                    color: _borderColor,
                  ),
                  InputForm(
                    controller: _pwController,
                    behaviorSubject: _pwButtonSubject,
                    focusNode: _textFocusNode,
                    height: appHeight * 0.0555,
                    visibleBorder: false,
                    obscureText: true,
                    existNext: false,
                    hint: '비밀번호',
                    onTap: () {
                      _appBarHeightSubject.add(appHeight * 0.12);
                    },
                    onSubmitted: () {
                      _appBarHeightSubject.add(appHeight * 0.24);
                    },
                    onChanged: _inputFormOnChanged,
                  ),
                ],
              ),
            ),
            Container(height: appHeight * 0.0125),
            Container(
              width: appWidth * 0.9,
              height: appHeight * 0.0515,
              decoration: const BoxDecoration(
                borderRadius: BorderRadius.all(Radius.circular(5.0)),
                color: Colors.blue,
              ),
              child: StreamBuilder(
                stream: _loginButtonSubject.stream,
                builder: (context, snapshot) {
                  return MaterialButton(
                    onPressed: snapshot.data == true
                        ? () async {
                            FocusScope.of(context).unfocus();
                            _indicatorSubject.add(true);
                            _textFocusNode.unfocus();
                            _appBarHeightSubject.add(appHeight * 0.24);

                            try {
                              await FirebaseAuth.instance
                                  .signInWithEmailAndPassword(
                                email: _idController.text,
                                password: _pwController.text,
                              );

                              // ignore: use_build_context_synchronously
                              Navigator.of(context).pushReplacement(
                                PageRouteBuilder(
                                  // ignore: prefer_const_constructors
                                  pageBuilder: (context, _, __) => MainPage(
                                  ),
                                  transitionDuration:
                                      const Duration(seconds: 0),
                                ),
                              );
                            } on FirebaseAuthException catch (error) {
                              _indicatorSubject.add(false);
                              if (error.code == 'wrong-password') {
                                showCupertinoDialog(
                                    context: context,
                                    builder: (context) {
                                      return CupertinoAlertDialog(
                                        content: const Text(
                                          '이메일 혹은 비밀번호가 잘못입력되었습니다.',
                                        ),
                                        actions: <Widget>[
                                          CupertinoButton(
                                            child: const Text('확인'),
                                            onPressed: () {
                                              Navigator.of(context).pop();
                                            },
                                          ),
                                        ],
                                      );
                                    });
                              }
                              log('Error : $error');
                            }
                          }
                        : null,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        StreamBuilder(
                            stream: _indicatorSubject.stream,
                            builder: (context, snapshot) {
                              if (snapshot.data == true) {
                                return const CupertinoActivityIndicator(
                                  color: Colors.blue,
                                  animating: false,
                                );
                              } else {
                                return const SizedBox.shrink();
                              }
                            }),
                        const Text(
                          '로그인',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        StreamBuilder(
                          stream: _indicatorSubject.stream,
                          builder: (context, snapshot) {
                            if (snapshot.data == true) {
                              return const CupertinoActivityIndicator();
                            } else {
                              return const SizedBox.shrink();
                            }
                          },
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
            SizedBox(
              height: appHeight * 0.006,
            ),
            CupertinoButton(
              child: const Text(
                '비밀번호를 잊으셨나요?',
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                ),
              ),
              onPressed: () {},
            ),
            StreamBuilder(
                stream: _appBarHeightSubject.stream,
                builder: (context, snapshot) {
                  return AnimatedContainer(
                    height: (snapshot.data == appHeight * 0.24)
                        ? appHeight * 0.276
                        : appHeight * 0.076,
                    duration: _animationDuration,
                    child: const SizedBox.shrink(),
                  );
                }),
            SizedBox(
              height: appHeight * 0.07,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  SizedBox(
                    width: appWidth * 0.27,
                    child: Divider(
                      color: _borderColor,
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.only(
                      left: appWidth * 0.02,
                      right: appWidth * 0.02,
                    ),
                    child: Text(
                      '또는',
                      style: TextStyle(
                        color: _borderColor,
                      ),
                    ),
                  ),
                  SizedBox(
                    width: appWidth * 0.27,
                    child: Divider(
                      color: _borderColor,
                    ),
                  ),
                ],
              ),
            ),
            Container(
              width: appWidth * 0.9,
              height: appHeight * 0.0515,
              margin: EdgeInsets.only(bottom: appHeight * 0.02),
              decoration: const BoxDecoration(
                borderRadius: BorderRadius.all(Radius.circular(5.0)),
                color: Colors.blue,
              ),
              child: MaterialButton(
                highlightColor: Colors.transparent,
                onPressed: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) {
                        // ignore: prefer_const_constructors
                        return NewAccountPage();
                      },
                    ),
                  );
                },
                child: const Text(
                  '새 계정 만들기',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
