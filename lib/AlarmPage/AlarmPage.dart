// ignore_for_file: file_names

import 'dart:developer';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:rxdart/rxdart.dart';

import '../Global_Widgets/widget_custom_sliver_appbar.dart';
import '../Global_Widgets/widget_custom_sliver_appbar_button.dart';
import '../Global_Widgets/widget_custom_sliver_appbar_shadow.dart';

class AlarmPage extends StatefulWidget {
  const AlarmPage({Key? key}) : super(key: key);

  @override
  State<AlarmPage> createState() => _AlarmPageState();
}

class _AlarmPageState extends State<AlarmPage>
    with AutomaticKeepAliveClientMixin<AlarmPage> {
  final ScrollController _scrollController = ScrollController();
  final BehaviorSubject<double> _scrollSubject = BehaviorSubject<double>();

  final activeColor = const Color.fromRGBO(231, 242, 254, 1);
  final activeFontColor = const Color.fromRGBO(0, 90, 204, 1);
  final inActiveColor = const Color.fromRGBO(227, 228, 234, 1);
  final inActiveFontColor = const Color.fromRGBO(8, 8, 8, 1);

  int index = 0;

  @override
  bool get wantKeepAlive => true;

  @override
  void initState() {
    super.initState();

    _scrollController.addListener(() {
      _scrollSubject.add(_scrollController.offset);
    });
  }

  @override
  void dispose() {
    super.dispose();

    _scrollController.removeListener(() {
      _scrollSubject.add(_scrollController.offset);
    });
    _scrollSubject.close();
  }

  @override
  Widget build(BuildContext context) {
    final double appHeight =
        MediaQuery.of(context).size.height - MediaQuery.of(context).padding.top;
    final double appWidth = MediaQuery.of(context).size.width;

    final double appBarHeight = const SliverAppBar().toolbarHeight;
    const double appBarShadowHeight = 1.0;
    final double navigationBarHeight = appHeight * 0.103;
    final double selectButtonHeight = appHeight * 0.078;
    final double beforeAlarmTextHeight = appHeight * 0.035;

    super.build(context);

    return Scaffold(
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
                    title: '알림',
                    buttonList: [
                      CustomSliverAppBarButton(
                        iconData: Icons.search,
                        onPressed: () {},
                      ),
                    ],
                  ),
                  CupertinoSliverRefreshControl(
                    refreshTriggerPullDistance: 100,
                    onRefresh: () async {
                      await Future.delayed(const Duration(seconds: 1))
                          .then((_) {
                        log('refresh done!');
                      });
                    },
                  ),
                  SliverToBoxAdapter(
                    child: Container(
                      margin: EdgeInsets.only(
                        left: appWidth * 0.04,
                      ),
                      height: selectButtonHeight,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: <Widget>[
                          Container(
                            height: appHeight * 0.052,
                            width: appWidth * 0.13,
                            margin: EdgeInsets.only(
                              right: appWidth * 0.03,
                            ),
                            child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                primary:
                                    (index == 0) ? activeColor : inActiveColor,
                                padding: EdgeInsets.zero,
                                shadowColor: Colors.transparent,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(20),
                                ),
                              ),
                              child: Text(
                                '모두',
                                style: TextStyle(
                                  fontSize: 17.5,
                                  color: (index == 0)
                                      ? activeFontColor
                                      : inActiveFontColor,
                                ),
                              ),
                              onPressed: () {
                                setState(() {
                                  index = 0;
                                });
                              },
                            ),
                          ),
                          SizedBox(
                            height: appHeight * 0.052,
                            width: appWidth * 0.20,
                            child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                primary:
                                    (index == 1) ? activeColor : inActiveColor,
                                padding: EdgeInsets.zero,
                                shadowColor: Colors.transparent,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(20),
                                ),
                              ),
                              child: Text(
                                '우선순위',
                                style: TextStyle(
                                  fontSize: 17.5,
                                  color: (index == 1)
                                      ? activeFontColor
                                      : inActiveFontColor,
                                ),
                              ),
                              onPressed: () {
                                setState(() {
                                  index = 1;
                                });
                              },
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  SliverToBoxAdapter(
                    child: Visibility(
                      visible: (index == 0) ? true : false,
                      child: Column(
                        children: <Widget>[
                          Container(
                            alignment: Alignment.topLeft,
                            margin: EdgeInsets.only(
                              top: appHeight * 0.01,
                              left: appWidth * 0.04,
                            ),
                            height: beforeAlarmTextHeight,
                            child: const Text(
                              '이전 알림',
                              style: TextStyle(
                                fontSize: 20,
                              ),
                            ),
                          ),
                          Column(
                            children: List.generate(
                              10,
                              (index) => SizedBox(
                                height: appHeight * 0.12,
                                child: MaterialButton(
                                  padding: EdgeInsets.zero,
                                  splashColor: Colors.transparent,
                                  child: Row(
                                    children: <Widget>[
                                      Container(
                                        height: appHeight * 0.12,
                                        padding: EdgeInsets.only(
                                          top: appHeight * 0.01,
                                        ),
                                        alignment: Alignment.topCenter,
                                        child: Stack(
                                          children: <Widget>[
                                            Container(
                                              height: appHeight * 0.12,
                                              width: appWidth * 0.26,
                                            ),
                                            Container(
                                              margin: EdgeInsets.only(
                                                left: appWidth * 0.04,
                                              ),
                                              decoration: BoxDecoration(
                                                shape: BoxShape.circle,
                                                border: Border.all(
                                                    color: Colors.grey),
                                              ),
                                              height: appHeight * 0.088,
                                              child: Opacity(
                                                opacity: 0.2,
                                                child: Icon(
                                                  Icons.account_circle,
                                                  size: appHeight * 0.088,
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                      Expanded(
                                        child: Container(
                                          padding: EdgeInsets.only(
                                            top: appHeight * 0.01,
                                            bottom: appHeight * 0.01,
                                          ),
                                          alignment: Alignment.topCenter,
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: <Widget>[
                                              Text(
                                                'Hardwell에서 새로운 동영상을 게시했습니다. \'Can\'t wait to be back in NYC again next week. Grab your tickets',
                                                overflow: TextOverflow.ellipsis,
                                                maxLines: 3,
                                                style: TextStyle(
                                                  fontSize: 17,
                                                ),
                                              ),
                                              Text(
                                                '6일',
                                                style: TextStyle(
                                                  fontSize: 17,
                                                  color: Colors.grey,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                      CupertinoButton(
                                        child: Icon(
                                          Icons.more_horiz,
                                          color: Colors.grey,
                                          size: 30,
                                        ),
                                        onPressed: () {
                                          log('pushed more button');
                                        },
                                      ),
                                    ],
                                  ),
                                  onPressed: () {
                                    log('pushed button');
                                  },
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  SliverToBoxAdapter(
                    child: Visibility(
                      visible: (index == 1) ? true : false,
                      child: SizedBox(
                        height: appHeight -
                            navigationBarHeight -
                            selectButtonHeight -
                            appBarShadowHeight,
                        child: const Center(
                          child: Text('우선순위'),
                        ),
                      ),
                    ),
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
