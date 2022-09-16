// ignore_for_file: file_names

import 'dart:developer';
import 'dart:math' as math;

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:facebook/MenuPage/widgets/just_button.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:rxdart/rxdart.dart';

import '../LoginPage/LoginPage.dart';
import 'menuData.dart';
import 'widgets/big_short_cut_button.dart';
import 'widgets/hidden_menu_button.dart';
import 'widgets/short_cut_button.dart';

class MenuPage extends StatefulWidget {
  const MenuPage({Key? key}) : super(key: key);

  @override
  State<MenuPage> createState() => _MenuPageState();
}

class _MenuPageState extends State<MenuPage>
    with AutomaticKeepAliveClientMixin<MenuPage> {
  final ScrollController _scrollController = ScrollController();
  final BehaviorSubject<double> _scrollSubject = BehaviorSubject<double>();
  final BehaviorSubject<bool> _shortCutSubject = BehaviorSubject<bool>();
  final BehaviorSubject<bool> _communityResourceSubject =
      BehaviorSubject<bool>();
  final BehaviorSubject<bool> _helpSubject = BehaviorSubject<bool>();

  bool isShowingShortCut = false;
  bool isShowingCommunityResource = false;
  bool isShowingHelp = false;
  bool isShowingSetting = false;
  bool isShowingAnotherProduct = false;

  final Duration _seeMoreDuration = const Duration(milliseconds: 200);
  final Duration _opacityDuration = const Duration(milliseconds: 50);
  final Duration _scrollDuration = const Duration(milliseconds: 250);
  final Duration _hiddenMenuDuration = const Duration(milliseconds: 150);

  final MenuData menuData = MenuData();

  @override
  bool get wantKeepAlive => true;

  @override
  initState() {
    super.initState();

    _scrollController.addListener(
      () {
        _scrollSubject.add(_scrollController.offset);
        log(_scrollController.offset.toString());
      },
    );
    _shortCutSubject.add(false);
    _communityResourceSubject.add(false);
    _helpSubject.add(false);
  }

  @override
  dispose() {
    super.dispose();
    _scrollController.removeListener(() {});
    _scrollController.dispose();
    _scrollSubject.close();
    _shortCutSubject.close();
    _communityResourceSubject.close();
    _helpSubject.close();
  }

  @override
  Widget build(BuildContext context) {
    final double appHeight =
        MediaQuery.of(context).size.height - MediaQuery.of(context).padding.top;
    final double appWidth = MediaQuery.of(context).size.width;

    final double appBarHeight = const SliverAppBar().toolbarHeight;
    final double myProfileHeight = appHeight * 0.04;
    final double shortCutMenusHeight = appHeight *
        0.09 *
        math.max(menuData.leftShortCutLabelList.length,
            menuData.rightShortCutLabelList.length);
    final double hiddenMenuHeight = appHeight * 0.215;
    final double justButtonHeight = appHeight * 0.075;
    final double cRHeight = appHeight * 0.3225;
    final double helpHeight = appHeight * 0.375 + appWidth * 0.189;

    super.build(context);

    double _calCRScrollOffset() {
      return 426;
    }

    double _calHelpScrollOffset() {
      return 426;
    }

    return Scaffold(
      backgroundColor: const Color.fromRGBO(240, 241, 245, 1),
      body: SafeArea(
        child: Column(
          children: <Widget>[
            StreamBuilder(
                stream: _scrollSubject.stream,
                builder: (context, snapshot) {
                  if (snapshot.data == null) {
                    return const SizedBox.shrink();
                  }

                  return Visibility(
                    visible: ((snapshot.data as double) >= appBarHeight)
                        ? true
                        : false,
                    child: Opacity(
                      opacity: 0.5,
                      child: Container(
                        height: 1,
                        color: const Color.fromRGBO(206, 206, 206, 1),
                      ),
                    ),
                  );
                }),
            SizedBox(
              height: MediaQuery.of(context).size.height -
                  MediaQuery.of(context).padding.top -
                  (appHeight / 9.721518) -
                  1,
              child: CustomScrollView(
                controller: _scrollController,
                slivers: <Widget>[
                  Theme(
                    data: ThemeData(
                      appBarTheme: const AppBarTheme(
                        systemOverlayStyle: SystemUiOverlayStyle.dark,
                      ),
                    ),
                    child: SliverAppBar(
                      backgroundColor: Colors.transparent,
                      elevation: 0,
                      floating: false,
                      leading: const SizedBox.shrink(),
                      leadingWidth: 0,
                      titleTextStyle: const TextStyle(
                        color: Colors.black,
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                      title: Row(
                        children: <Widget>[
                          const Text(
                            '메뉴',
                            style: TextStyle(
                              fontSize: 30,
                            ),
                          ),
                          const Flexible(
                            fit: FlexFit.tight,
                            child: SizedBox.shrink(),
                          ),
                          Container(
                            width: appHeight * 0.045,
                            height: appHeight * 0.045,
                            decoration: const BoxDecoration(
                              color: Color.fromRGBO(228, 230, 234, 1),
                              shape: BoxShape.circle,
                            ),
                            child: IconButton(
                              splashColor: Colors.transparent,
                              highlightColor: Colors.transparent,
                              padding: EdgeInsets.zero,
                              icon: const Icon(Icons.settings,
                                  color: Colors.black),
                              onPressed: () {},
                            ),
                          ),
                          SizedBox(
                            width: appWidth * 0.025,
                          ),
                          Container(
                            width: appHeight * 0.045,
                            height: appHeight * 0.045,
                            decoration: const BoxDecoration(
                              color: Color.fromRGBO(228, 230, 234, 1),
                              shape: BoxShape.circle,
                            ),
                            child: IconButton(
                              splashColor: Colors.transparent,
                              highlightColor: Colors.transparent,
                              padding: EdgeInsets.zero,
                              icon:
                                  const Icon(Icons.search, color: Colors.black),
                              onPressed: () {},
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  SliverToBoxAdapter(
                    child: MaterialButton(
                      height: appHeight * 0.04,
                      splashColor: Colors.transparent,
                      focusColor: Colors.transparent,
                      highlightElevation: 0,
                      elevation: 0,
                      padding: EdgeInsets.only(
                        left: appWidth * 0.04,
                      ),
                      child: Row(
                        children: <Widget>[
                          Container(
                            width: appWidth * 0.106,
                            height: appWidth * 0.106,
                            padding: EdgeInsets.zero,
                            decoration: const BoxDecoration(
                              shape: BoxShape.circle,
                              color: Color.fromRGBO(200, 200, 200, 1),
                            ),
                            child: FutureBuilder(
                              future: FirebaseStorage.instance
                                  .ref()
                                  .child('users')
                                  .child(
                                      '${FirebaseAuth.instance.currentUser?.uid}')
                                  .child('profileImage.png')
                                  .getDownloadURL(),
                              builder: (context, snapshot) {
                                if (snapshot.hasError) {
                                  log('error : ${snapshot.hasError}');
                                }

                                if (snapshot.hasData) {
                                  return Image.network('${snapshot.data}');
                                } else {
                                  return Padding(
                                    padding: EdgeInsets.zero,
                                    child: Image.asset(
                                      'assets/menuPage/account_default.png',
                                      height: appWidth * 0.10,
                                    ),
                                  );
                                }
                              },
                            ),
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Container(
                                height: appHeight * 0.04,
                                padding: EdgeInsets.only(
                                  top: appHeight * 0.013,
                                  left: appWidth * 0.021,
                                ),
                                child: FutureBuilder(
                                  future: FirebaseFirestore.instance
                                      .collection('user')
                                      .doc(
                                          '${FirebaseAuth.instance.currentUser?.uid}')
                                      .get(),
                                  builder: (context,
                                      AsyncSnapshot<DocumentSnapshot>
                                          snapshot) {
                                    if (snapshot.hasError) {
                                      return const CupertinoActivityIndicator();
                                    }

                                    if (snapshot.hasData) {
                                      return Text(
                                        snapshot.data!['name'].toString(),
                                        style: TextStyle(
                                          fontSize: 20,
                                          fontWeight: FontWeight.lerp(
                                              FontWeight.w400,
                                              FontWeight.w500,
                                              0.5),
                                        ),
                                      );
                                    } else {
                                      return const Text('null');
                                    }
                                  },
                                ),
                              ),
                              Container(
                                  height: appHeight * 0.04,
                                  padding: EdgeInsets.only(
                                    top: appHeight * 0.005,
                                    left: appWidth * 0.021,
                                  ),
                                  child: const Text(
                                    '내 프로필 보기',
                                    style: TextStyle(
                                      fontSize: 17,
                                      color: Colors.grey,
                                    ),
                                  )),
                            ],
                          ),
                        ],
                      ),
                      onPressed: () {},
                    ),
                  ),
                  SliverToBoxAdapter(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Column(
                          children: List.generate(
                            MenuData().leftShortCutLabelList.length,
                            (index) => (ShortCutButton(
                              image: menuData.leftShortCutImageList
                                  .elementAt(index),
                              label: menuData.leftShortCutLabelList
                                  .elementAt(index),
                            )),
                          ),
                        ),
                        Column(
                          children: List.generate(
                            menuData.rightShortCutLabelList.length,
                            (index) => (ShortCutButton(
                              image: menuData.rightShortCutImageList
                                  .elementAt(index),
                              label: menuData.rightShortCutLabelList
                                  .elementAt(index),
                            )),
                          ),
                        ),
                      ],
                    ),
                  ),
                  SliverToBoxAdapter(
                    child: Stack(
                      children: <Widget>[
                        StreamBuilder(
                            stream: _shortCutSubject.stream,
                            builder: (context, AsyncSnapshot<bool> snapshot) {
                              return AnimatedContainer(
                                height: snapshot.data ?? false
                                    ? hiddenMenuHeight
                                    : 0,
                                duration: _seeMoreDuration,
                                child: AnimatedOpacity(
                                  opacity: snapshot.data ?? false ? 1 : 0,
                                  duration: snapshot.data ?? false
                                      ? _opacityDuration
                                      : _seeMoreDuration,
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: <Widget>[
                                      Column(
                                        children: List.generate(
                                          menuData.hiddenLeftShortCutLabelList
                                              .length,
                                          (index) => (ShortCutButton(
                                            image: menuData
                                                .hiddenLeftShortCutImageList
                                                .elementAt(index),
                                            label: menuData
                                                .hiddenLeftShortCutLabelList
                                                .elementAt(index),
                                          )),
                                        ),
                                      ),
                                      Column(
                                        children: List.generate(
                                          menuData.hiddenRightShortCutLabelList
                                              .length,
                                          (index) => (ShortCutButton(
                                            image: menuData
                                                .hiddenRightShortCutImageList
                                                .elementAt(index),
                                            label: menuData
                                                .hiddenRightShortCutLabelList
                                                .elementAt(index),
                                          )),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              );
                            }),
                        StreamBuilder(
                            stream: _shortCutSubject.stream,
                            builder: (context, AsyncSnapshot<bool> snapshot) {
                              return Column(
                                children: <Widget>[
                                  AnimatedContainer(
                                    height: snapshot.data ?? false
                                        ? hiddenMenuHeight
                                        : 0,
                                    duration: _seeMoreDuration,
                                    child: const SizedBox.shrink(),
                                  ),
                                  JustButton(
                                    label: snapshot.data ?? false
                                        ? '간단히 보기'
                                        : '더 보기',
                                    onPress: () {
                                      if (isShowingShortCut) {
                                        _shortCutSubject.add(false);
                                      } else {
                                        _shortCutSubject.add(true);
                                      }
                                      isShowingShortCut = !isShowingShortCut;
                                    },
                                  ),
                                ],
                              );
                            }),
                      ],
                    ),
                  ),
                  SliverToBoxAdapter(
                    child: HiddenMenuButton(
                      label: '커뮤니티 리소스',
                      hiddenMenu: StreamBuilder(
                          stream: _communityResourceSubject.stream,
                          builder: (context, AsyncSnapshot<bool> snapshot) {
                            return AnimatedOpacity(
                              opacity: snapshot.data ?? false ? 1 : 0,
                              duration: snapshot.data ?? false
                                  ? _opacityDuration
                                  : _seeMoreDuration,
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: <Widget>[
                                  Column(
                                    children: List.generate(
                                      (menuData.communityResourceLeftImageList
                                          .length),
                                      (index) => (ShortCutButton(
                                        image: menuData
                                            .communityResourceLeftImageList
                                            .elementAt(index),
                                        label: menuData
                                            .communityResourceLeftLabelList
                                            .elementAt(index),
                                      )),
                                    ),
                                  ),
                                  Column(
                                    children: List.generate(
                                      (menuData.communityResourceRightImageList
                                          .length),
                                      (index) => (ShortCutButton(
                                        image: menuData
                                            .communityResourceRightImageList
                                            .elementAt(index),
                                        label: menuData
                                            .communityResourceRightLabelList
                                            .elementAt(index),
                                      )),
                                    ),
                                  ),
                                ],
                              ),
                            );
                          }),
                      hiddenMenuHeight: cRHeight,
                      onShowingEnd: () async {
                        _communityResourceSubject.add(true);
                        await Future.delayed(_hiddenMenuDuration).then(
                          (_) => (_scrollController.animateTo(
                            _calCRScrollOffset(),
                            duration: _scrollDuration,
                            curve: Curves.linear,
                          )),
                        );
                      },
                      onNShowingEnd: () {
                        _communityResourceSubject.add(false);
                        /*
                        _scrollController.animateTo(
                          _calCRScrollOffset(),
                          duration: _scrollDuration,
                          curve: Curves.linear,
                        );
                         */
                      },
                    ),
                  ),
                  SliverToBoxAdapter(
                    child: HiddenMenuButton(
                      label: '도움말 및 지원',
                      hiddenMenu: StreamBuilder(
                          stream: _helpSubject.stream,
                          builder: (context, AsyncSnapshot<bool> snapshot) {
                            return AnimatedOpacity(
                              opacity: snapshot.data ?? false ? 1 : 0,
                              duration: snapshot.data ?? false
                                  ? _opacityDuration
                                  : _seeMoreDuration,
                              child: Container(
                                margin: EdgeInsets.only(
                                  bottom: appWidth * 0.02,
                                ),
                                child: Column(
                                  children: List.generate(
                                    menuData.helpList.length,
                                        (index) => BigShortCutButton(
                                      label: menuData.helpList.elementAt(index)['label'],
                                      image: menuData.helpList.elementAt(index)['image'],
                                    ),
                                  ),
                                ),
                              ),
                            );
                          }),
                      hiddenMenuHeight: helpHeight,
                      onShowingEnd: () async {
                        _helpSubject.add(true);
                        await Future.delayed(_hiddenMenuDuration).then(
                              (_) => (_scrollController.animateTo(
                            _calHelpScrollOffset(),
                            duration: _scrollDuration,
                            curve: Curves.linear,
                          )),
                        );
                      },
                      onNShowingEnd: () {
                        _helpSubject.add(false);
                        /*
                        _scrollController.animateTo(
                          _calCRScrollOffset(),
                          duration: _scrollDuration,
                          curve: Curves.linear,
                        );
                         */
                      },
                    ),
                  ),
                  SliverToBoxAdapter(
                    child: HiddenMenuButton(
                      label: '설정 및 개인정보',
                      hiddenMenu: SizedBox.shrink(),
                      hiddenMenuHeight: 0,
                    ),
                  ),
                  SliverToBoxAdapter(
                    child: HiddenMenuButton(
                      label: 'Meta의 다른 제품',
                      hiddenMenu: SizedBox.shrink(),
                      hiddenMenuHeight: 0,
                    ),
                  ),
                  SliverToBoxAdapter(
                    child: JustButton(
                      label: '로그아웃',
                      onPress: () {
                        showCupertinoModalPopup(
                          context: context,
                          builder: (context) => Theme(
                            data: ThemeData.light(),
                            child: CupertinoActionSheet(
                              message: const Text(
                                '로그아웃하기 전에 로그인 정보를 저장하시겠어요?',
                                style: TextStyle(
                                  fontSize: 15,
                                  fontWeight: FontWeight.normal,
                                ),
                              ),
                              actions: [
                                CupertinoActionSheetAction(
                                  onPressed: () {},
                                  child: const Text(
                                    '저장 후 로그아웃',
                                    style: TextStyle(
                                      color: Colors.black,
                                    ),
                                  ),
                                ),
                                CupertinoActionSheetAction(
                                  onPressed: () async {
                                    dispose();
                                    await FirebaseAuth.instance.signOut();

                                    // ignore: use_build_context_synchronously
                                    Navigator.of(context).pushReplacement(
                                      PageRouteBuilder(
                                        // ignore: prefer_const_constructors
                                        pageBuilder: (context, _, __) =>
                                            LoginPage(),
                                        transitionDuration:
                                            const Duration(seconds: 0),
                                      ),
                                    );
                                  },
                                  child: const Text(
                                    '저장하지 않고 로그아웃',
                                    style: TextStyle(
                                      color: Colors.red,
                                    ),
                                  ),
                                ),
                              ],
                              cancelButton: CupertinoActionSheetAction(
                                onPressed: () {
                                  Navigator.of(context).pop();
                                },
                                child: const Text('취소'),
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class AppBarHeaderDelegate extends SliverPersistentHeaderDelegate {
  AppBarHeaderDelegate({required this.color});

  final double _height = 1;
  final Color color;

  @override
  Widget build(
      BuildContext context, double shrinkOffset, bool overlapsContent) {
    return SizedBox(
      //width: MediaQuery.of(context).size.width,
      height: _height,
      child: Container(
        color: color,
      ),
    );
  }

  @override
  double get maxExtent => _height;

  @override
  double get minExtent => _height;

  @override
  bool shouldRebuild(covariant SliverPersistentHeaderDelegate oldDelegate) {
    return true;
  }
}
