// ignore_for_file: file_names

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
    final double appHeight = MediaQuery.of(context).size.height - MediaQuery.of(context).padding.top;

    return Scaffold(
      body: SafeArea(
        child: Column(
          children: <Widget>[
            StreamBuilder(
              stream: _scrollSubject.stream,
              builder: (context, snapshot) {
                if(snapshot.data == null) {
                  return const SizedBox.shrink();
                }

                return Visibility(
                  visible: ((snapshot.data as double) >= 56.0) ? true : false,
                  child: Opacity(
                    opacity: 0.5,
                    child: Container(
                      height: 1,
                      color: Colors.black,
                    ),
                  ),
                );
              }
            ),
            SizedBox(
              height: MediaQuery.of(context).size.height - MediaQuery.of(context).padding.top - (appHeight / 9.721518) - 1,
              child: CustomScrollView(
                controller: _scrollController,
                slivers: <Widget>[
                  Theme(
                    data: ThemeData(
                      appBarTheme: AppBarTheme(
                        systemOverlayStyle: SystemUiOverlayStyle.dark,
                      ),
                    ),
                    child: SliverAppBar(
                      backgroundColor: Colors.transparent,
                      elevation: 0,
                      floating: true,
                      titleTextStyle: TextStyle(
                        color: Colors.black,
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                      title: Row(
                        children: <Widget>[
                          Text(
                            '메뉴',
                          ),
                          Flexible(
                            fit: FlexFit.tight,
                            child: SizedBox.shrink(),
                          ),
                          IconButton(
                            icon: Icon(Icons.settings, color: Colors.black),
                            onPressed: () {},
                          ),
                          IconButton(
                            icon: Icon(Icons.search, color: Colors.black),
                            onPressed: () {},
                          ),
                        ],
                      ),
                    ),
                  ),
                  SliverList(
                    delegate: SliverChildBuilderDelegate(
                          (context, index) {
                        return SizedBox(
                          height: 30,
                          child: Center(
                            child: Text('$index'),
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
