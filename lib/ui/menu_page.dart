// ignore_for_file: file_names

import 'dart:math' as math;

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:scrolls_to_top/scrolls_to_top.dart';

import '../bloc/menu_bloc.dart';
import '../components/custom_sliver_appbar.dart';
import '../components/custom_sliver_appbar_button.dart';
import '../components/custom_sliver_appbar_shadow.dart';
import '../components/menu_page/big_short_cut_button.dart';
import '../components/menu_page/hidden_menu_button.dart';
import '../components/menu_page/just_button.dart';
import '../components/menu_page/short_cut_button.dart';
import '../models/global_model.dart';
import '../models/menu_data.dart';

class MenuPage extends StatefulWidget {
  const MenuPage({
    Key? key,
    required this.scrollController,
    required this.isOnScreen,
    required this.pageTransition,
  }) : super(key: key);

  final ScrollController scrollController;
  final bool isOnScreen;
  final Function pageTransition;

  @override
  State<MenuPage> createState() => _MenuPageState();
}

class _MenuPageState extends State<MenuPage>
    with AutomaticKeepAliveClientMixin<MenuPage> {
  final double appBarHeight = const SliverAppBar().toolbarHeight;
  final double navigationBarHeight = appHeight * 0.103;
  final double myProfileHeight = appHeight * 0.04;
  final double shortCutMenusHeight = appHeight *
      0.09 *
      math.max(leftShortCutList.length, rightShortCutList.length);
  final double hiddenMenuHeight = appHeight * 0.215;
  final double justButtonHeight = appHeight * 0.075;
  final double cRHeight = appHeight * 0.31;
  final double helpHeight = appHeight * 0.46;

  final Duration _seeMoreDuration = const Duration(milliseconds: 200);
  final Duration _opacityDuration = const Duration(milliseconds: 200);
  final Duration _scrollDuration = const Duration(milliseconds: 250);
  final Duration _showingHiddenMenuDuration = const Duration(milliseconds: 300);

  final _menuBloc = MenuBloc();

  void _listener() {
    _menuBloc.updateScrollOffset(widget.scrollController.offset);
  }

  @override
  bool get wantKeepAlive => true;

  @override
  initState() {
    super.initState();

    widget.scrollController.addListener(() {
      _listener();
    });

    _menuBloc.init();
  }

  @override
  dispose() {
    super.dispose();

    widget.scrollController.removeListener(() {
      _listener();
    });

    _menuBloc.dispose();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);

    return ScrollsToTop(
      onScrollsToTop: (event) async {
        if (!widget.isOnScreen) {
          return;
        }

        if (widget.scrollController.hasClients) {
          widget.scrollController.animateTo(
            event.to,
            duration: event.duration,
            curve: event.curve,
          );
        }
      },
      child: Scaffold(
        backgroundColor: const Color.fromRGBO(240, 241, 245, 1),
        body: SafeArea(
          child: Column(
            children: <Widget>[
              CustomSliverAppBarShadow(
                scrollOffsetStream: _menuBloc.scrollOffset,
              ),
              Expanded(
                child: CustomScrollView(
                  controller: widget.scrollController,
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
                              child: Padding(
                                padding: EdgeInsets.zero,
                                child: Image.asset(
                                  'assets/menuPage/account_default.png',
                                  height: appWidth * 0.10,
                                ),
                              ),
                              /*
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
                                    log('error : ${snapshot.error}');
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
                              */
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

                                      if (snapshot.hasData &&
                                          snapshot.data!.exists) {
                                        return Text(
                                          snapshot.data!['name'].toString(),
                                          style: TextStyle(
                                            color: Colors.black,
                                            fontSize: 20,
                                            fontWeight: FontWeight.lerp(
                                                FontWeight.w400,
                                                FontWeight.w500,
                                                0.5),
                                          ),
                                        );
                                      } else {
                                        return const Text(
                                          'loading...',
                                          style: TextStyle(
                                            color: Colors.black,
                                          ),
                                        );
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
                        onPressed: () {
                          widget.pageTransition(2);
                        },
                      ),
                    ),
                    SliverToBoxAdapter(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Column(
                            children: List.generate(
                              leftShortCutList.length,
                              (index) => (ShortCutButton(
                                image: leftShortCutList.elementAt(index).image,
                                label: leftShortCutList.elementAt(index).label,
                              )),
                            ),
                          ),
                          Column(
                            children: List.generate(
                              rightShortCutList.length,
                              (index) => (ShortCutButton(
                                image: rightShortCutList.elementAt(index).image,
                                label: rightShortCutList.elementAt(index).label,
                              )),
                            ),
                          ),
                        ],
                      ),
                    ),
                    SliverToBoxAdapter(
                      child: StreamBuilder(
                        stream: _menuBloc.isShowingShortCut,
                        builder: (context, AsyncSnapshot<bool> snapshot) {
                          return AnimatedContainer(
                            height:
                                snapshot.data ?? false ? hiddenMenuHeight : 0,
                            duration: _seeMoreDuration,
                            child: SingleChildScrollView(
                              padding: EdgeInsets.zero,
                              physics: const NeverScrollableScrollPhysics(),
                              child: AnimatedOpacity(
                                opacity: snapshot.data ?? false ? 1 : 0,
                                duration: _seeMoreDuration,
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: <Widget>[
                                    Column(
                                      children: List.generate(
                                        hiddenLeftShortCutList.length,
                                        (index) => (ShortCutButton(
                                          image: hiddenLeftShortCutList
                                              .elementAt(index)
                                              .image,
                                          label: hiddenLeftShortCutList
                                              .elementAt(index)
                                              .label,
                                        )),
                                      ),
                                    ),
                                    Column(
                                      children: List.generate(
                                        hiddenRightShortCutList.length,
                                        (index) => (ShortCutButton(
                                          image: hiddenRightShortCutList
                                              .elementAt(index)
                                              .image,
                                          label: hiddenRightShortCutList
                                              .elementAt(index)
                                              .label,
                                        )),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                    SliverToBoxAdapter(
                      child: StreamBuilder(
                        stream: _menuBloc.isShowingShortCut,
                        builder: (context, AsyncSnapshot<bool> snapshot) {
                          return JustButton(
                            label: snapshot.data ?? false ? '간단히 보기' : '더 보기',
                            onPress: () async {
                              if (snapshot.data!) {
                                _menuBloc.updateIsShowingShortCut(false);
                              } else {
                                _menuBloc.updateIsShowingShortCut(true);
                              }
                              //_isShowingShortCut = !_isShowingShortCut;
                            },
                          );
                        },
                      ),
                    ),
                    SliverToBoxAdapter(
                      child: HiddenMenuButton(
                        label: '커뮤니티 리소스',
                        hiddenMenu: StreamBuilder(
                            stream: _menuBloc.isShowingCommunityResource,
                            builder: (context, AsyncSnapshot<bool> snapshot) {
                              return SingleChildScrollView(
                                padding: EdgeInsets.zero,
                                physics: const NeverScrollableScrollPhysics(),
                                child: AnimatedOpacity(
                                  opacity: snapshot.data ?? false ? 1 : 0,
                                  duration: _opacityDuration,
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: <Widget>[
                                      SizedBox(
                                        height: cRHeight,
                                        child: Column(
                                          children: List.generate(
                                            (communityResourceLeftList.length),
                                            (index) => (ShortCutButton(
                                              image: communityResourceLeftList
                                                  .elementAt(index)
                                                  .image,
                                              label: communityResourceLeftList
                                                  .elementAt(index)
                                                  .label,
                                            )),
                                          ),
                                        ),
                                      ),
                                      SizedBox(
                                        height: cRHeight,
                                        child: Column(
                                          children: List.generate(
                                            (communityResourceRightList.length),
                                            (index) => (ShortCutButton(
                                              image: communityResourceRightList
                                                  .elementAt(index)
                                                  .image,
                                              label: communityResourceRightList
                                                  .elementAt(index)
                                                  .label,
                                            )),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              );
                            }),
                        hiddenMenuHeight: cRHeight,
                        onShowingEnd: () async {
                          _menuBloc.updateIsShowingCommunityResource(true);

                          await Future.delayed(_showingHiddenMenuDuration).then(
                            (_) => (widget.scrollController.animateTo(
                              _menuBloc.calCRScrollOffset(),
                              duration: _scrollDuration,
                              curve: Curves.linear,
                            )),
                          );
                        },
                        onNShowingEnd: () {
                          _menuBloc.updateIsShowingCommunityResource(false);
                        },
                      ),
                    ),
                    SliverToBoxAdapter(
                      child: HiddenMenuButton(
                        label: '도움말 및 지원',
                        hiddenMenu: StreamBuilder(
                          stream: _menuBloc.isShowingHelp,
                          builder: (context, AsyncSnapshot<bool> snapshot) {
                            return SingleChildScrollView(
                              padding: EdgeInsets.zero,
                              physics: const NeverScrollableScrollPhysics(),
                              child: AnimatedOpacity(
                                opacity: snapshot.data ?? false ? 1 : 0,
                                duration: _opacityDuration,
                                child: Container(
                                  margin: EdgeInsets.only(
                                    top: appHeight * 0.010,
                                    //bottom: appHeight * 0.01,
                                  ),
                                  child: Column(
                                    children: List.generate(
                                      helpList.length,
                                      (index) => BigShortCutButton(
                                        label: helpList.elementAt(index).label,
                                        image: helpList.elementAt(index).image,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            );
                          },
                        ),
                        hiddenMenuHeight: helpHeight,
                        onShowingEnd: () async {
                          _menuBloc.updateIsShowingHelp(true);

                          await Future.delayed(_showingHiddenMenuDuration).then(
                            (_) => (widget.scrollController.animateTo(
                              _menuBloc.calHelpScrollOffset(),
                              duration: _scrollDuration,
                              curve: Curves.linear,
                            )),
                          );
                        },
                        onNShowingEnd: () {
                          _menuBloc.updateIsShowingHelp(false);
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
                                      Navigator.of(context).pop();

                                      await FirebaseAuth.instance.signOut();
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
