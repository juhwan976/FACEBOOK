// ignore_for_file: file_names

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:scrolls_to_top/scrolls_to_top.dart';

import '../bloc/profile_bloc.dart';
import '../components/profile_page/info_button.dart';
import '../models/global_model.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({
    Key? key,
    required this.scrollController,
    required this.isOnScreen,
  }) : super(key: key);

  final bool isOnScreen;

  final ScrollController scrollController;

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage>
    with AutomaticKeepAliveClientMixin<ProfilePage> {
  final double appBarButtonHeight = const SliverAppBar().toolbarHeight - 1;
  final double appBarButtonWidth = appWidth * 0.05;

  final _profileBloc = ProfileBloc();

  @override
  bool get wantKeepAlive => true;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    _profileBloc.init();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();

    _profileBloc.dispose();
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
        backgroundColor: Colors.white,
        body: SafeArea(
          child: Column(
            children: [
              SizedBox(
                height: const SliverAppBar().toolbarHeight,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Container(
                      padding: EdgeInsets.only(
                        right: appWidth * 0.04,
                        left: appWidth * 0.04,
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
                            height: appBarButtonHeight,
                            width: appBarButtonWidth,
                            margin: EdgeInsets.only(
                              right: appWidth * 0.04,
                            ),
                            child: const IconButton(
                              padding: EdgeInsets.zero,
                              icon: Icon(
                                Icons.edit,
                                color: Colors.white,
                              ),
                              onPressed: null,
                            ),
                          ),
                          Container(
                            height: appBarButtonHeight,
                            width: appBarButtonWidth,
                            margin: EdgeInsets.only(
                              right: appWidth * 0.04,
                            ),
                            child: const IconButton(
                              padding: EdgeInsets.zero,
                              icon: Icon(
                                Icons.search,
                                color: Colors.white,
                              ),
                              onPressed: null,
                            ),
                          ),
                          Expanded(
                            child: FutureBuilder(
                                future: FirebaseFirestore.instance
                                    .collection('user')
                                    .doc(
                                        '${FirebaseAuth.instance.currentUser?.uid}')
                                    .get(),
                                builder: (context,
                                    AsyncSnapshot<DocumentSnapshot> snapshot) {
                                  if (snapshot.hasError) {
                                    return const CupertinoActivityIndicator();
                                  }

                                  if (snapshot.hasData &&
                                      snapshot.data!.exists) {
                                    _profileBloc.updateUserName(
                                        snapshot.data!['name'].toString());

                                    return Text(
                                      snapshot.data!['name'].toString(),
                                      style: const TextStyle(
                                        color: Colors.black,
                                        fontSize: 20,
                                      ),
                                      textAlign: TextAlign.center,
                                    );
                                  }

                                  return const Text(
                                    'loading...',
                                    style: TextStyle(
                                      color: Colors.black,
                                    ),
                                    textAlign: TextAlign.center,
                                  );
                                }),
                          ),
                          Container(
                            height: appBarButtonHeight,
                            width: appBarButtonWidth,
                            margin: EdgeInsets.only(
                              left: appWidth * 0.04,
                            ),
                            child: IconButton(
                              padding: EdgeInsets.zero,
                              icon: const Icon(
                                Icons.edit,
                                color: Colors.black,
                              ),
                              onPressed: () {},
                            ),
                          ),
                          Container(
                            height: appBarButtonHeight,
                            width: appBarButtonWidth,
                            margin: EdgeInsets.only(
                              left: appWidth * 0.04,
                            ),
                            child: IconButton(
                              padding: EdgeInsets.zero,
                              icon: const Icon(
                                Icons.search,
                                color: Colors.black,
                              ),
                              onPressed: () {},
                            ),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      height: 1,
                      color: Colors.black12,
                    ),
                  ],
                ),
              ),
              Expanded(
                child: CustomScrollView(
                  controller: widget.scrollController,
                  slivers: [
                    CupertinoSliverRefreshControl(
                        refreshTriggerPullDistance: appHeight * 0.1,
                        onRefresh: () async {
                          _profileBloc.refresh();
                        }),
                    SliverToBoxAdapter(
                      child: Container(
                        margin: EdgeInsets.only(
                          top: appWidth * 0.04,
                          right: appWidth * 0.04,
                          left: appWidth * 0.04,
                        ),
                        height: appHeight * 0.37,
                        child: Stack(
                          children: [
                            Positioned(
                              top: 0,
                              right: 0,
                              left: 0,
                              child: Container(
                                height: appHeight * (0.37 - (0.245 / 2)),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.only(
                                    topLeft: Radius.circular(10),
                                    topRight: Radius.circular(10),
                                  ),
                                  color: Colors.grey,
                                ),
                              ),
                            ),
                            Positioned(
                              bottom: 0,
                              right: 0,
                              left: 0,
                              child: Container(
                                height: appHeight * 0.245,
                                width: appHeight * 0.245,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: Colors.grey,
                                  border: Border.all(
                                    color: Colors.white,
                                    width: 5,
                                  ),
                                ),
                                child: FittedBox(
                                  child: Image.asset(
                                    'assets/menuPage/account_default.png',
                                    color: Colors.black,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    SliverToBoxAdapter(
                      child: Container(
                        width: appWidth,
                        margin: EdgeInsets.only(
                          top: appHeight * 0.02,
                          bottom: appHeight * 0.015,
                        ),
                        child: StreamBuilder(
                            stream: _profileBloc.userName,
                            builder: (context, AsyncSnapshot<String> snapshot) {
                              if (snapshot.hasData) {
                                return Text(
                                  snapshot.data!,
                                  style: const TextStyle(
                                    color: Colors.black,
                                    fontSize: 25,
                                  ),
                                  textAlign: TextAlign.center,
                                );
                              }

                              return const Text(
                                'loading...',
                                style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 25,
                                ),
                                textAlign: TextAlign.center,
                              );
                            }),
                      ),
                    ),
                    SliverToBoxAdapter(
                      child: Container(
                        margin: EdgeInsets.only(
                          left: appWidth * 0.04,
                          right: appWidth * 0.04,
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            MaterialButton(
                              height: appHeight * 0.055,
                              minWidth: appWidth * 0.37,
                              color: const Color.fromRGBO(23, 116, 224, 1),
                              elevation: 0,
                              focusElevation: 0,
                              hoverElevation: 0,
                              highlightElevation: 0,
                              splashColor: Colors.transparent,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(5),
                              ),
                              padding: EdgeInsets.zero,
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  Container(
                                    margin: EdgeInsets.only(
                                      right: appWidth * 0.015,
                                    ),
                                    child: const Icon(
                                      Icons.add_circle,
                                      color: Colors.white,
                                      size: 19,
                                    ),
                                  ),
                                  const Text(
                                    '스토리에 추가',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 20,
                                    ),
                                  ),
                                ],
                              ),
                              onPressed: () {},
                            ),
                            MaterialButton(
                              height: appHeight * 0.055,
                              minWidth: appWidth * 0.37,
                              color: const Color.fromRGBO(227, 229, 234, 1),
                              elevation: 0,
                              focusElevation: 0,
                              hoverElevation: 0,
                              highlightElevation: 0,
                              splashColor: Colors.transparent,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(5),
                              ),
                              padding: EdgeInsets.zero,
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  Container(
                                    margin: EdgeInsets.only(
                                      right: appWidth * 0.015,
                                    ),
                                    child: const Icon(
                                      Icons.edit,
                                      color: Colors.black,
                                      size: 19,
                                    ),
                                  ),
                                  const Text(
                                    '프로필 편집',
                                    style: TextStyle(
                                      color: Colors.black,
                                      fontSize: 20,
                                    ),
                                  ),
                                ],
                              ),
                              onPressed: () {},
                            ),
                            MaterialButton(
                              height: appHeight * 0.055,
                              minWidth: appWidth * 0.14,
                              color: const Color.fromRGBO(227, 229, 234, 1),
                              elevation: 0,
                              focusElevation: 0,
                              hoverElevation: 0,
                              highlightElevation: 0,
                              splashColor: Colors.transparent,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(5),
                              ),
                              padding: EdgeInsets.zero,
                              child: const Icon(
                                Icons.more_horiz,
                                color: Colors.black,
                                size: 19,
                              ),
                              onPressed: () {},
                            ),
                          ],
                        ),
                      ),
                    ),
                    SliverToBoxAdapter(
                      child: Container(
                        margin: EdgeInsets.only(
                          top: appHeight * 0.0125,
                          right: appWidth * 0.04,
                          left: appWidth * 0.04,
                        ),
                        height: 1,
                        color: Colors.black12,
                      ),
                    ),
                    SliverToBoxAdapter(
                      child: Column(
                        children: [
                          InfoButton(
                            icon: Icons.home_rounded,
                            info: '거주지',
                            onPressed: () {},
                          ),
                          InfoButton(
                            icon: Icons.business_center_rounded,
                            info: '직장',
                            onPressed: () {},
                          ),
                          InfoButton(
                            icon: Icons.school_rounded,
                            info: '학교',
                            onPressed: () {},
                          ),
                          InfoButton(
                            icon: Icons.location_on_rounded,
                            info: '출신지',
                            onPressed: () {},
                          ),
                          InfoButton(
                            icon: Icons.favorite_rounded,
                            info: '결혼/연애 상태',
                            onPressed: () {},
                          ),
                          InfoButton(
                            icon: Icons.more_horiz_rounded,
                            info: '내 정보 보기',
                            isLast: true,
                            onPressed: () {},
                          ),
                          SizedBox(
                            height: appHeight * 0.0475,
                            width: appWidth,
                            child: MaterialButton(
                              padding: EdgeInsets.zero,
                              color: const Color.fromRGBO(230, 242, 254, 1),
                              elevation: 0,
                              focusElevation: 0,
                              hoverElevation: 0,
                              highlightElevation: 0,
                              splashColor: Colors.transparent,
                              highlightColor: Colors.transparent,
                              child: const Text(
                                '전체 공개 정보 수정',
                                style: TextStyle(
                                  color: Color.fromRGBO(0, 98, 206, 1),
                                  fontSize: 18,
                                ),
                              ),
                              onPressed: () {},
                            ),
                          ),
                        ],
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
