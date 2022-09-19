// ignore_for_file: file_names

import 'dart:developer';
import 'dart:math' as math;

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:facebook/MenuPage/widgets/just_button.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:rxdart/rxdart.dart';
import 'package:scrolls_to_top/scrolls_to_top.dart';

import '../LoginPage/LoginPage.dart';
import '../Global_Widgets/widget_custom_sliver_appbar.dart';
import '../Global_Widgets/widget_custom_sliver_appbar_button.dart';
import '../Global_Widgets/widget_custom_sliver_appbar_shadow.dart';
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
  final Duration _showingHiddenMenuDuration = const Duration(milliseconds: 300);

  final MenuData menuData = MenuData();

  @override
  bool get wantKeepAlive => true;

  @override
  initState() {
    super.initState();

    _scrollController.addListener(() {
      _scrollSubject.add(_scrollController.offset);
    });
    _shortCutSubject.add(false);
    _communityResourceSubject.add(false);
    _helpSubject.add(false);
  }

  @override
  dispose() {
    super.dispose();
    _scrollController.removeListener(() {
      _scrollSubject.add(_scrollController.offset);
    });
    _scrollController.dispose();
    _scrollSubject.close();
    _shortCutSubject.close();
    _communityResourceSubject.close();
    _helpSubject.close();
  }

  @override
  Widget build(BuildContext context) {
    // 768
    final double appHeight =
        MediaQuery.of(context).size.height - MediaQuery.of(context).padding.top;
    // 375
    final double appWidth = MediaQuery.of(context).size.width;

    final double appBarHeight = const SliverAppBar().toolbarHeight;
    final double navigationBarHeight = appHeight * 0.103;
    final double myProfileHeight = appHeight * 0.04;
    final double shortCutMenusHeight = appHeight *
        0.09 *
        math.max(menuData.leftShortCutList.length,
            menuData.rightShortCutList.length);
    final double hiddenMenuHeight = appHeight * 0.215;
    final double justButtonHeight = appHeight * 0.075;
    final double cRHeight = appHeight * 0.3225;
    final double helpHeight = appHeight * 0.375 + appWidth * 0.18;

    super.build(context);

    double _calCRScrollOffset() {
      if (isShowingShortCut && isShowingHelp) {
        return appHeight * 0.914;
      }

      if (isShowingShortCut) {
        return appHeight * 0.77;
      }

      if (isShowingHelp) {
        return appHeight * 0.68;
      }

      return appHeight * 0.555;
    }

    double _calHelpScrollOffset() {
      if (isShowingShortCut && isShowingCommunityResource) {
        return appHeight * 1.232;
      }

      if (isShowingShortCut) {
        return appHeight * 0.91;
      }

      if (isShowingCommunityResource) {
        return appHeight * 1.017;
      }

      return appHeight * 0.7;
    }

    return ScrollsToTop(
      onScrollsToTop: (_) async {
        log('scroll to top done!');
      },
      child: Scaffold(
        backgroundColor: const Color.fromRGBO(240, 241, 245, 1),
        body: SafeArea(
          child: Column(
            children: <Widget>[
              CustomSliverAppBarShadow(
                scrollOffsetStream: _scrollSubject.stream,
              ),
              SizedBox(
                height: appHeight - navigationBarHeight - 1,
                child: CustomScrollView(
                  controller: _scrollController,
                  slivers: <Widget>[
                    CustomSliverAppBar(
                      title: '메뉴',
                      buttonList: [
                        CustomSliverAppBarButton(
                          iconData: Icons.settings,
                          onPressed: () {},
                        ),
                        CustomSliverAppBarButton(
                          iconData: Icons.search,
                          onPressed: () {},
                        ),
                      ],
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
                              menuData.leftShortCutList.length,
                                  (index) => (ShortCutButton(
                                image: menuData.leftShortCutList
                                    .elementAt(index)['image'],
                                label: menuData.leftShortCutList
                                    .elementAt(index)['label'],
                              )),
                            ),
                          ),
                          Column(
                            children: List.generate(
                              menuData.rightShortCutList.length,
                                  (index) => (ShortCutButton(
                                image: menuData.rightShortCutList
                                    .elementAt(index)['image'],
                                label: menuData.rightShortCutList
                                    .elementAt(index)['label'],
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
                                            menuData
                                                .hiddenLeftShortCutList.length,
                                                (index) => (ShortCutButton(
                                              image: menuData
                                                  .hiddenLeftShortCutList
                                                  .elementAt(index)['image'],
                                              label: menuData
                                                  .hiddenLeftShortCutList
                                                  .elementAt(index)['label'],
                                            )),
                                          ),
                                        ),
                                        Column(
                                          children: List.generate(
                                            menuData
                                                .hiddenRightShortCutList.length,
                                                (index) => (ShortCutButton(
                                              image: menuData
                                                  .hiddenRightShortCutList
                                                  .elementAt(index)['image'],
                                              label: menuData
                                                  .hiddenRightShortCutList
                                                  .elementAt(index)['label'],
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
                                        (menuData
                                            .communityResourceLeftList.length),
                                            (index) => (ShortCutButton(
                                          image: menuData
                                              .communityResourceLeftList
                                              .elementAt(index)['image'],
                                          label: menuData
                                              .communityResourceLeftList
                                              .elementAt(index)['label'],
                                        )),
                                      ),
                                    ),
                                    Column(
                                      children: List.generate(
                                        (menuData
                                            .communityResourceRightList.length),
                                            (index) => (ShortCutButton(
                                          image: menuData
                                              .communityResourceRightList
                                              .elementAt(index)['image'],
                                          label: menuData
                                              .communityResourceRightList
                                              .elementAt(index)['label'],
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
                          isShowingCommunityResource = true;
                          await Future.delayed(_showingHiddenMenuDuration).then(
                                (_) => (_scrollController.animateTo(
                              _calCRScrollOffset(),
                              duration: _scrollDuration,
                              curve: Curves.linear,
                            )),
                          );
                        },
                        onNShowingEnd: () {
                          _communityResourceSubject.add(false);
                          isShowingCommunityResource = false;
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
                                    top: appHeight * 0.0125,
                                    //bottom: appHeight * 0.01,
                                  ),
                                  child: Column(
                                    children: List.generate(
                                      menuData.helpList.length,
                                          (index) => BigShortCutButton(
                                        label: menuData.helpList
                                            .elementAt(index)['label'],
                                        image: menuData.helpList
                                            .elementAt(index)['image'],
                                      ),
                                    ),
                                  ),
                                ),
                              );
                            }),
                        hiddenMenuHeight: helpHeight,
                        onShowingEnd: () async {
                          _helpSubject.add(true);
                          isShowingHelp = true;
                          await Future.delayed(_showingHiddenMenuDuration).then(
                                (_) => (_scrollController.animateTo(
                              _calHelpScrollOffset(),
                              duration: _scrollDuration,
                              curve: Curves.linear,
                            )),
                          );
                        },
                        onNShowingEnd: () {
                          _helpSubject.add(false);
                          isShowingHelp = false;
                        },
                      ),
                    ),
                    const SliverToBoxAdapter(
                      child: HiddenMenuButton(
                        label: '설정 및 개인정보',
                        hiddenMenu: SizedBox.shrink(),
                        hiddenMenuHeight: 0,
                      ),
                    ),
                    const SliverToBoxAdapter(
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
                                          const LoginPage(),
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
      ),
    );
  }
}
