// ignore_for_file: file_names
import 'package:facebook/WatchPage/WatchPage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:rxdart/rxdart.dart';

import '../AlarmPage/AlarmPage.dart';
import '../FriendPage/FriendPage.dart';
import '../HomePage/HomePage.dart';
import '../MenuPage/MenuPage.dart';
import '../ProfilePage/ProfilePage.dart';

class MainPage extends StatefulWidget {
  const MainPage({Key? key}) : super(key: key);

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  List<Widget> pageList = List<Widget>.empty();
  BehaviorSubject<int> indexBehaviorSubject = BehaviorSubject<int>();

  @override
  initState() {
    super.initState();

    indexBehaviorSubject.add(0);
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

    indexBehaviorSubject.close();
  }

  @override
  Widget build(BuildContext context) {
    //indexBehaviorSubject.add(0);

    return Theme(
      data: ThemeData(),
      child: Scaffold(
        bottomNavigationBar: BottomNavigationBar(
          selectedIconTheme: IconThemeData(color: Colors.black),
          selectedLabelStyle: TextStyle(color: Colors.black),
          unselectedIconTheme: IconThemeData(color: Colors.black),
          unselectedLabelStyle: TextStyle(color: Colors.black),
          type: BottomNavigationBarType.fixed,
          items: const [
            BottomNavigationBarItem(
              label: '홈',
              icon: Icon(Icons.home_outlined),
              activeIcon: Icon(Icons.home),
            ),
            BottomNavigationBarItem(
              label: '친구',
              icon: Icon(Icons.people),
              activeIcon: Icon(Icons.people_alt_outlined),
            ),
            BottomNavigationBarItem(
              label: 'Watch',
              icon: Icon(Icons.live_tv),
              activeIcon: Icon(Icons.live_tv_outlined),
            ),
            BottomNavigationBarItem(
              label: '프로필',
              icon: Icon(Icons.account_circle),
              activeIcon: Icon(Icons.account_circle_outlined),
            ),
            BottomNavigationBarItem(
              label: '알림',
              icon: Icon(Icons.notifications),
              activeIcon: Icon(Icons.notifications_outlined),
            ),
            BottomNavigationBarItem(
              label: '메뉴',
              icon: Icon(Icons.menu),
              activeIcon: Icon(Icons.menu_outlined),
            ),
          ],
          onTap: (index) {
            indexBehaviorSubject.add(index);
          },
        ),
        body: StreamBuilder(
            stream: indexBehaviorSubject.stream,
            builder: (context, snapshot) {
              if (snapshot.data == null) {
                return const Center(
                  child: CupertinoActivityIndicator(),
                );
              }
              return pageList.elementAt(snapshot.data as int);
            }),
      ),
    );
  }
}
