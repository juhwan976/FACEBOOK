// ignore_for_file: file_names
import 'dart:developer';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:localstorage/localstorage.dart';
import 'package:scrolls_to_top/scrolls_to_top.dart';

import '../bloc/alarm_bloc.dart';
import '../components/alarm_page/alarm_tile.dart';
import '../components/alarm_page/loading_tile.dart';
import '../components/custom_sliver_appbar.dart';
import '../components/custom_sliver_appbar_button.dart';
import '../components/custom_sliver_appbar_shadow.dart';
import '../models/alarm_data.dart';
import '../models/global_model.dart';

class AlarmPage extends StatefulWidget {
  const AlarmPage({
    Key? key,
    required this.scrollController,
    required this.isOnScreen,
  }) : super(key: key);

  final ScrollController scrollController;
  final bool isOnScreen;

  @override
  State<AlarmPage> createState() => _AlarmPageState();
}

class _AlarmPageState extends State<AlarmPage>
    with AutomaticKeepAliveClientMixin<AlarmPage> {
  /*
  final _scrollSubject = BehaviorSubject<double>();
  final _alarmsLengthSubject = BehaviorSubject<int>();
   */
  final _storage = LocalStorage('alarm_page');

  final double appBarHeight = const SliverAppBar().toolbarHeight;
  final double appBarShadowHeight = 1.0;
  final double navigationBarHeight = appHeight * 0.103;
  final double selectButtonHeight = appHeight * 0.078;
  final double beforeAlarmTextHeight = appHeight * 0.035;
  final double loadingTileHeight = appHeight * 0.12;

  final activeColor = const Color.fromRGBO(231, 242, 254, 1);
  final activeFontColor = const Color.fromRGBO(0, 90, 204, 1);
  final inActiveColor = const Color.fromRGBO(227, 228, 234, 1);
  final inActiveFontColor = const Color.fromRGBO(8, 8, 8, 1);

  final alarmBloc = AlarmBloc();
  List<bool> temp = [];

  int index = 0;

  @override
  bool get wantKeepAlive => true;

  void listener() {
    alarmBloc.updateScrollOffset(widget.scrollController.offset);
    if (((widget.scrollController.position.maxScrollExtent -
                loadingTileHeight * 2) <
            widget.scrollController.offset) &&
        alarms.length >= 6) {
      alarmBloc.readMore();
    }
  }

  @override
  void initState() {
    super.initState();

    widget.scrollController.addListener(listener);

    alarmBloc.init();

    temp = [...alarmBloc.parseIsReadsToList(temp)];
    alarmBloc.updateIsReads(temp);
  }

  @override
  void dispose() {
    super.dispose();

    widget.scrollController.removeListener(listener);

    temp.clear();
    alarmBloc.dispose();
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
              CustomSliverAppBarShadow(
                scrollOffsetStream: alarmBloc.scrollOffset,
              ),
              Expanded(
                child: CustomScrollView(
                  controller: widget.scrollController,
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
                      refreshTriggerPullDistance: appHeight * 0.1,
                      onRefresh: () async {
                        alarmBloc.refresh();
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
                                  primary: (index == 0)
                                      ? activeColor
                                      : inActiveColor,
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
                                  primary: (index == 1)
                                      ? activeColor
                                      : inActiveColor,
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
                                  color: Colors.black,
                                  fontSize: 20,
                                ),
                              ),
                            ),
                            StreamBuilder(
                              stream: alarmBloc.alarmLength,
                              builder:
                                  (context, AsyncSnapshot<int> lengthSnapshot) {
                                if (lengthSnapshot.hasData) {
                                  if (lengthSnapshot.data! >= 6) {
                                    return StreamBuilder(
                                      stream: alarmBloc.isReads,
                                      builder: (context,
                                          AsyncSnapshot<List<bool>>
                                              isReadSnapshot) {
                                        if (isReadSnapshot.hasData) {
                                          temp = [];
                                          temp = [...isReadSnapshot.data!];

                                          return Column(
                                            children: List.generate(
                                              lengthSnapshot.data! + 2,
                                              (index) {
                                                if (index <
                                                    lengthSnapshot.data!) {
                                                  return AlarmTile(
                                                    alarmData:
                                                        alarms.elementAt(index),
                                                    isRead: temp[index],
                                                    onPressed: () {
                                                      temp[index] = true;
                                                      alarmBloc.updateIsReads(temp);
                                                      alarms.elementAt(index).isRead = true;
                                                    },
                                                  );
                                                } else {
                                                  return LoadingTile(
                                                    isEndStream:
                                                        alarmBloc.isEnd,
                                                  );
                                                }
                                              },
                                            ),
                                          );
                                        }

                                        return const CupertinoActivityIndicator();
                                      },
                                    );
                                  } else {
                                    return const CupertinoActivityIndicator();
                                      /*StreamBuilder(
                                        stream: alarmBloc.isReads,
                                        builder: (context,
                                            AsyncSnapshot<List<bool>>
                                                snapshot) {
                                          if (snapshot.hasData) {
                                            temp = [...snapshot.data!];

                                            return Column(
                                              children: List.generate(
                                                lengthSnapshot.data!,
                                                (index) {
                                                  return AlarmTile(
                                                    alarmData:
                                                        alarms.elementAt(index),
                                                    isRead: snapshot.data!
                                                        .elementAt(index),
                                                    onPressed: () {
                                                      temp[index] = true;
                                                      alarmBloc
                                                          .updateIsReads(temp);
                                                    },
                                                  );
                                                },
                                              ),
                                            );
                                          }

                                          return const CupertinoActivityIndicator();
                                        })*/;
                                  }
                                }

                                return const CupertinoActivityIndicator();
                              },
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
                            child: Text(
                              '우선순위',
                              style: TextStyle(
                                color: Colors.black,
                              ),
                            ),
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
      ),
    );
  }
}
