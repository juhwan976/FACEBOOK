// ignore_for_file: file_names

import 'dart:developer';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../bloc/login_bloc.dart';
import '../components/login_page/input_form.dart';
import '../models/global_model.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({
    Key? key,
  }) : super(key: key);

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  bool init = false;

  final Color borderColor = Colors.white;

  final Duration animationDuration = const Duration(milliseconds: 250);

  final TextEditingController _idController = TextEditingController();
  final TextEditingController _pwController = TextEditingController();

  final FocusNode _textFocusNode = FocusNode();

  final loginBloc = LoginBloc();

  @override
  initState() {
    super.initState();

    _idController.addListener(() {
      loginBloc.updateId(_idController.text);
    });
    _pwController.addListener(() {
      loginBloc.updatePw(_pwController.text);
    });

    loginBloc.updateLoginButton(false);
    loginBloc.setMaxAppBarHeight = appHeight * 0.24;
    loginBloc.setMinAppBarHeight = appHeight * 0.12;
    loginBloc.setAppBarHeightMax();
  }

  @override
  dispose() {
    super.dispose();

    _idController.dispose();
    _pwController.dispose();
    loginBloc.dispose();
  }

  @override
  Widget build(BuildContext context) {

    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
        loginBloc.onUnfocus();
      },
      child: Scaffold(
        body: Column(
          children: <Widget>[
            StreamBuilder<double>(
              stream: loginBloc.appBarHeight,
              builder: (context, snapshot) {
                return AnimatedContainer(
                  duration: animationDuration,
                  height:
                      MediaQuery.of(context).padding.top + (snapshot.data ?? 0),
                  color: Colors.blue,
                );
              },
            ),
            StreamBuilder(
                stream: loginBloc.appBarHeight,
                builder: (context, snapshot) {
                  return AnimatedContainer(
                    height: (snapshot.data == appHeight * 0.24)
                        ? appHeight * 0.055
                        : appHeight * 0.026,
                    duration: animationDuration,
                    child: const SizedBox.shrink(),
                  );
                }),
            Container(
              width: appWidth * 0.9,
              height: appHeight * 0.0575 * 2,
              decoration: BoxDecoration(
                border: Border.all(color: borderColor),
                borderRadius: const BorderRadius.all(Radius.circular(5.0)),
              ),
              child: Column(
                children: <Widget>[
                  InputForm(
                    controller: _idController,
                    inputType: InputType.id,
                    buttonStream: loginBloc.idButton,
                    focusNode: _textFocusNode,
                    height: appHeight * 0.0555,
                    visibleBorder: false,
                    existNext: true,
                    hint: '전화번호 또는 이메일',
                    onTap: () {
                      loginBloc.setAppBarHeightMin();
                      loginBloc.toggleIdButton();
                    },
                    onSubmitted: () {
                      loginBloc.updateIdButton(false);
                    },
                    onChanged: () {
                      loginBloc.toggleIdButton();
                      loginBloc.toggleLoginButton();
                    },
                  ),
                  Container(
                    height: 1,
                    color: borderColor,
                  ),
                  InputForm(
                    controller: _pwController,
                    inputType: InputType.pw,
                    buttonStream: loginBloc.pwButton,
                    focusNode: _textFocusNode,
                    height: appHeight * 0.0555,
                    visibleBorder: false,
                    obscureText: true,
                    existNext: false,
                    hint: '비밀번호',
                    onTap: () {
                      loginBloc.setAppBarHeightMin();
                      loginBloc.togglePwButton();
                    },
                    onSubmitted: () {
                      loginBloc.setAppBarHeightMax();
                      loginBloc.updatePwButton(false);
                    },
                    onChanged: () {
                      loginBloc.toggleLoginButton();
                      loginBloc.togglePwButton();
                    },
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
                stream: loginBloc.loginButton,
                builder: (context, snapshot) {
                  return MaterialButton(
                    onPressed: snapshot.data == true
                        ? () async {
                            FocusScope.of(context).unfocus();
                            loginBloc.setAppBarHeightMax();
                            loginBloc.updateIndicator(true);
                            _textFocusNode.unfocus();

                            try {
                              await FirebaseAuth.instance
                                  .signInWithEmailAndPassword(
                                email: _idController.text,
                                password: _pwController.text,
                              );
                            } on FirebaseAuthException catch (error) {
                              loginBloc.updateIndicator(false);
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
                                  },
                                );
                              }
                              log('Error : $error');
                            }
                          }
                        : null,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        StreamBuilder(
                          stream: loginBloc.indicator,
                          builder: (context, snapshot) {
                            if (snapshot.data == true) {
                              return const CupertinoActivityIndicator(
                                color: Colors.blue,
                                animating: false,
                              );
                            } else {
                              return const SizedBox.shrink();
                            }
                          },
                        ),
                        const Text(
                          '로그인',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        StreamBuilder(
                          stream: loginBloc.indicator,
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
            const Expanded(
              child: SizedBox.shrink(),
            ),
            /*(
            StreamBuilder(
                stream: loginBloc.appBarHeight,
                builder: (context, snapshot) {
                  return AnimatedContainer(
                    height: (snapshot.data == appHeight * 0.24)
                        ? appHeight * 0.276
                        : appHeight * 0.076,
                    duration: animationDuration,
                    child: const SizedBox.shrink(),
                  );
                }),)*/
            SizedBox(
              height: appHeight * 0.07,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  SizedBox(
                    width: appWidth * 0.27,
                    child: Divider(
                      color: borderColor,
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
                        color: borderColor,
                      ),
                    ),
                  ),
                  SizedBox(
                    width: appWidth * 0.27,
                    child: Divider(
                      color: borderColor,
                    ),
                  ),
                ],
              ),
            ),
            SafeArea(
              top:false,
              right: false,
              left: false,
              child: Container(
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
                    /*
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) {
                        // ignore: prefer_const_constructors
                        return NewAccountPage();
                      },
                    ),
                  );

                   */
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
            ),
          ],
        ),
      ),
    );
  }
}
