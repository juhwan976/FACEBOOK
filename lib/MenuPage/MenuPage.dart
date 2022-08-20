// ignore_for_file: file_names

import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:rxdart/rxdart.dart';

class MenuPage extends StatefulWidget {
  const MenuPage({Key? key}) : super(key: key);

  @override
  State<MenuPage> createState() => _MenuPageState();
}

class _MenuPageState extends State<MenuPage> {
  final ScrollController _scrollController = ScrollController();
  final BehaviorSubject<double> _scrollSubject = BehaviorSubject<double>();

  @override
  initState() {
    super.initState();

    _scrollController.addListener(
      () {
        _scrollSubject.add(_scrollController.offset);
      },
    );
  }

  @override
  dispose() {
    super.dispose();

    _scrollController.dispose();
    _scrollSubject.close();
  }

  @override
  Widget build(BuildContext context) {
    final double appHeight =
        MediaQuery.of(context).size.height - MediaQuery.of(context).padding.top;
    final double appWidth = MediaQuery.of(context).size.width;
    final double appBarHeight = const SliverAppBar().toolbarHeight;

    log('appHeight : $appHeight');
    log('appWidth : $appWidth');

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
                        color: Colors.black,
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
                      floating: true,
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
                              onPressed: () {

                              },
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
                      height: appHeight * 0.08,
                      splashColor: Colors.transparent,
                      focusColor: Colors.transparent,
                      highlightElevation: 0,
                      elevation: 0,
                      color: Colors.yellow,
                      padding: EdgeInsets.only(
                        left: appWidth * 0.04,
                      ),
                      child: Row(
                        children: <Widget>[
                          Container(
                            width: appWidth * 0.106,
                            height: appWidth * 0.106,
                            padding: EdgeInsets.zero,
                            decoration: BoxDecoration(
                              border: Border.all(color: Colors.black12),
                              //shape: BoxShape.circle,
                              color: Colors.red,
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
                                  return Icon(
                                    Icons.account_circle,
                                    size: appWidth * 0.106,
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
                                              FontWeight.w500,
                                              FontWeight.w600,
                                              0.5),
                                        ),
                                      );
                                    } else {
                                      return Text('null');
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
