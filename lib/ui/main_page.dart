// ignore_for_file: file_names
import 'package:facebook/ui/profile_page.dart';
import 'package:facebook/ui/watch_page.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../bloc/main_bloc.dart';
import '../models/global_model.dart';
import '../models/main_data.dart';
import 'alarm_page.dart';
import 'feed_page.dart';
import 'home_page.dart';
import 'menu_page.dart';

class MainPage extends StatefulWidget {
  const MainPage({
    Key? key,
  }) : super(key: key);

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  final PageController _pageController = PageController(initialPage: 0);

  final ScrollController _homePageScrollController = ScrollController();
  final ScrollController _watchPageScrollController = ScrollController();
  final ScrollController _profilePageScrollController = ScrollController();
  final ScrollController _feedPageScrollController = ScrollController();
  final ScrollController _alarmPageScrollController = ScrollController();
  final ScrollController _menuPageScrollController = ScrollController();

  late final List<ScrollController> _scrollControllers = [
    _homePageScrollController,
    _watchPageScrollController,
    _profilePageScrollController,
    _feedPageScrollController,
    _alarmPageScrollController,
    _menuPageScrollController,
  ];

  int currentIndex = 0;
  final int _duration = 80;
  final double _indicatorHeight = 2;
  final Color _activeColor = const Color.fromRGBO(18, 119, 238, 1);
  final Color _inactiveColor = const Color.fromRGBO(100, 100, 100, 1);

  final mainBloc = MainBloc(
    initialDelay: 50,
    initialIndex: 0,
    initialTarget: 0,
  );

  @override
  initState() {
    super.initState();
  }

  @override
  dispose() {
    super.dispose();
    mainBloc.dispose();

    for (int i = 0; i < _scrollControllers.length; i++) {
      _scrollControllers.elementAt(i).dispose();
    }
  }

  @override
  Widget build(BuildContext context) {
    final double imageHeight = appHeight * 0.04;

    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.dark);

    return Scaffold(
        bottomNavigationBar: Container(
          height: appHeight * 0.103,
          color: Colors.white,
          child: Column(
            children: <Widget>[
              Container(
                height: 1,
                color: const Color.fromRGBO(206, 206, 206, 0.25),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: List.generate(
                  navigationData.length,
                  (index) {
                    return SizedBox(
                      height: appHeight * 0.095,
                      width: appWidth / navigationData.length,
                      child: MaterialButton(
                        padding: EdgeInsets.zero,
                        splashColor: Colors.transparent,
                        child: Column(
                          children: <Widget>[
                            Container(
                              width: appWidth / navigationData.length,
                              height: _indicatorHeight,
                              padding: EdgeInsets.zero,
                              child: Row(
                                children: <Widget>[
                                  StreamBuilder(
                                      stream: mainBloc.index,
                                      builder: (context,
                                          AsyncSnapshot<int> snapshot) {
                                        if (snapshot.data == null) {
                                          return const SizedBox.shrink();
                                        }

                                        return AnimatedContainer(
                                          width: (((snapshot.data as int) -
                                                      index) >
                                                  0)
                                              ? appWidth / navigationData.length
                                              : 0,
                                          duration: Duration(
                                              milliseconds:
                                                  mainBloc.currentDelay),
                                          child: null,
                                        );
                                      }),
                                  Expanded(
                                    child: Container(
                                      color: _activeColor,
                                    ),
                                  ),
                                  StreamBuilder(
                                      stream: mainBloc.index,
                                      builder: (context, snapshot) {
                                        if (snapshot.data == null) {
                                          return const SizedBox.shrink();
                                        }

                                        return AnimatedContainer(
                                          width: (((snapshot.data as int) -
                                                      index) <
                                                  0)
                                              ? appWidth / navigationData.length
                                              : 0,
                                          duration: Duration(
                                              milliseconds:
                                                  mainBloc.currentDelay),
                                          child: null,
                                        );
                                      }),
                                ],
                              ),
                            ),
                            const SizedBox(height: 6),
                            StreamBuilder(
                              stream: mainBloc.target,
                              builder: (context, snapshot) {
                                if (snapshot.data == null) {
                                  return const SizedBox.shrink();
                                }

                                return Column(
                                  children: <Widget>[
                                    SizedBox(
                                      height: imageHeight,
                                      child: Center(
                                        child: AnimatedCrossFade(
                                          firstChild: Image.asset(
                                            navigationData
                                                .elementAt(index)
                                                .inActiveImage,
                                            height: (index > 2)
                                                ? imageHeight * 0.8
                                                : imageHeight,
                                            color: _inactiveColor,
                                          ),
                                          secondChild: Image.asset(
                                            navigationData
                                                .elementAt(index)
                                                .activeImage,
                                            height: (index > 2)
                                                ? imageHeight * 0.8
                                                : imageHeight,
                                            color: _activeColor,
                                          ),
                                          crossFadeState:
                                              (snapshot.data == index)
                                                  ? CrossFadeState.showSecond
                                                  : CrossFadeState.showFirst,
                                          duration:
                                              Duration(milliseconds: _duration),
                                        ),
                                      ),
                                    ),
                                    const SizedBox(height: 7),
                                    Text(
                                      navigationData.elementAt(index).label,
                                      style: TextStyle(
                                        color: (index == snapshot.data)
                                            ? _activeColor
                                            : _inactiveColor,
                                        fontSize: 11,
                                      ),
                                    ),
                                  ],
                                );
                              },
                            ),
                          ],
                        ),
                        onPressed: () {
                          mainBloc.updateTarget(index);
                          mainBloc.updateDelay(mainBloc.calDelay(index));

                          _pageController.animateToPage(
                            mainBloc.currentTarget,
                            duration: Duration(milliseconds: 100),
                            curve: Curves.linear,
                          );

                          setState(() {
                            currentIndex = mainBloc.currentTarget;
                          });

                          mainBloc.animateIndicator(index);
                        },
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
        body: PageView(
          physics: const NeverScrollableScrollPhysics(),
          controller: _pageController,
          children: [
            HomePage(),
            WatchPage(),
            ProfilePage(
              scrollController: _profilePageScrollController,
              isOnScreen: currentIndex == 2,
            ),
            FeedPage(),
            AlarmPage(
              scrollController: _alarmPageScrollController,
              isOnScreen: currentIndex == 4,
            ),
            MenuPage(
              scrollController: _menuPageScrollController,
              isOnScreen: currentIndex == 5,
            ),
          ],
        ));
  }
}
