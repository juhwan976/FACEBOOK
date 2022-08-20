// ignore_for_file: file_names
import 'package:bottom_bar_page_transition/bottom_bar_page_transition.dart';
import 'package:facebook/WatchPage/WatchPage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:rxdart/rxdart.dart';

import '../AlarmPage/AlarmPage.dart';
import '../FriendPage/FriendPage.dart';
import '../HomePage/HomePage.dart';
import '../MenuPage/MenuPage.dart';
import '../ProfilePage/ProfilePage.dart';
import '../Widgets/widget_bottom_navigation_button.dart';

class MainPage extends StatefulWidget {
  const MainPage({Key? key}) : super(key: key);

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  List<Widget> pageList = List<Widget>.empty();
  final List<IconData> inactiveIconList = [
    Icons.home_outlined,
    Icons.people_outline,
    Icons.desktop_windows,
    Icons.account_circle_outlined,
    Icons.notifications_outlined,
    Icons.menu
  ];
  final List<IconData> activeIconList = [
    Icons.home,
    Icons.people,
    Icons.desktop_windows,
    Icons.account_circle,
    Icons.notifications,
    Icons.menu
  ];
  final List<String> labelList = ['홈', '친구', 'Watch', '프로필', '알림', '메뉴'];
  final BehaviorSubject<int> _indexBehaviorSubject = BehaviorSubject<int>();
  final BehaviorSubject<int> _delayBehaviorSubject = BehaviorSubject<int>();
  final BehaviorSubject<int> _targetIndexBehaviorSubject =
      BehaviorSubject<int>();

  @override
  initState() {
    super.initState();

    _indexBehaviorSubject.add(0);
    _delayBehaviorSubject.add(50);
    _targetIndexBehaviorSubject.add(0);

    pageList = [
      ...pageList,
      HomePage(),
      FriendPage(),
      WatchPage(),
      ProfilePage(),
      AlarmPage(),
      MenuPage()
    ];
  }

  @override
  dispose() {
    super.dispose();

    _indexBehaviorSubject.close();
    _delayBehaviorSubject.close();
    _targetIndexBehaviorSubject.close();
  }

  @override
  Widget build(BuildContext context) {
    double appHeight =
        MediaQuery.of(context).size.height - MediaQuery.of(context).padding.top;

    return Theme(
      data: ThemeData(),
      child: Scaffold(
        bottomNavigationBar: SizedBox(
          height: appHeight / 9.721518,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: List.generate(
              pageList.length,
                  (index) {
                return BottomNavigationButton(
                  numOfIcon: pageList.length,
                  delaySubject: _delayBehaviorSubject,
                  currentIndexSubject: _indexBehaviorSubject,
                  thisIndex: index,
                  targetIndexSubject: _targetIndexBehaviorSubject,
                  inactiveIconList: inactiveIconList,
                  activeIconList: activeIconList,
                  labelList: labelList,
                );
              },
            ),
          ),
        ),
        body: StreamBuilder(
          stream: _targetIndexBehaviorSubject.stream,
          builder: (context, snapshot) {
            if (snapshot.data == null) {
              return const Center(
                child: CupertinoActivityIndicator(),
              );
            }
            return BottomBarPageTransition(
              builder: (context, index) {
                SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.dark);

                return pageList.elementAt(index);
              },
              currentIndex: snapshot.data as int,
              totalLength: pageList.length,
              transitionType: TransitionType.slide,
              transitionDuration: const Duration(milliseconds: 100),
            );
          },
        ),
      ),
    );
  }
}
