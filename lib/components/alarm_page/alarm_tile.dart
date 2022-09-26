import 'dart:developer';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../models/alarm_data.dart';
import '../../models/global_model.dart';
import 'alarm_tile_bottom_sheet.dart';
import 'alarm_tile_profile.dart';

class AlarmTile extends StatelessWidget {
  AlarmTile({
    Key? key,
    required this.alarmData,
    required this.isRead,
    this.onPressed,
  }) : super(key: key);

  final AlarmData alarmData;
  final bool isRead;
  final Function()? onPressed;

  final Color _unReadColor = const Color.fromRGBO(231, 242, 254, 1);
  final Color _readColor = Colors.white;

  String _calculateDuration() {
    DateTime now = DateTime.now();
    DateTime postedDate =
        DateTime.fromMillisecondsSinceEpoch(alarmData.timeStamp);

    int diff = now.difference(postedDate).inHours;

    if (diff > 24) {
      if ((diff / 24).round() > 7) {
        return '${((diff / 24) / 7).round()}주';
      } else {
        return '${(diff / 24).round()}일';
      }
    } else {
      return '$diff시간';
    }
  }

  String _writeWhatPosted() {
    switch (alarmData.postType) {
      case PostType.image:
        return '새로운 사진 ${alarmData.images!.length} 개를 게시했습니다: ';
      case PostType.video:
        return '새로운 동영상을 게시했습니다: ';
      case PostType.onlyText:
        return '새로운 게시물을 작성했습니다: ';
      default:
        return '글을 게시했습니다: ';
    }
  }

  String _writeMessage() {
    switch (alarmData.userType) {
      case UserType.individualPerson:
        return '님이 ';
      case UserType.groupPerson:
        return '에서 ';
      case UserType.individualPage:
        return '님이 ';
      case UserType.groupPage:
        return '에서 ';
      default:
        return '님이 ';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: appHeight * 0.12,
      color: isRead ? _readColor : _unReadColor,
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
                    child: AlarmTileProfile(
                      uid: alarmData.uid,
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
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    RichText(
                      overflow: TextOverflow.ellipsis,
                      maxLines: 3,
                      text: TextSpan(
                        style: const TextStyle(
                          color: Colors.black,
                          fontSize: 14,
                        ),
                        children: [
                          TextSpan(
                            text: alarmData.user,
                            style: const TextStyle(
                              color: Colors.black,
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          TextSpan(
                            text: _writeMessage(),
                          ),
                          TextSpan(
                            text: _writeWhatPosted(),
                          ),
                          TextSpan(
                            text: '\'${alarmData.content}\'.',
                          ),
                        ],
                      ),
                    ),
                    Text(
                      _calculateDuration(),
                      style: const TextStyle(
                        fontSize: 14,
                        color: Colors.grey,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            CupertinoButton(
              child: const Icon(
                Icons.more_horiz,
                color: Colors.black,
                size: 30,
              ),
              onPressed: () {
                showModalBottomSheet(
                  context: context,
                  enableDrag: true,
                  clipBehavior: Clip.antiAlias,
                  backgroundColor: Colors.white,
                  shape: const RoundedRectangleBorder(
                    borderRadius: BorderRadius.vertical(
                      top: Radius.circular(25),
                    ),
                  ),
                  builder: (context) {
                    return AlarmTileBottomSheet(
                      alarmData: alarmData,
                    );
                  },
                );
              },
            ),
          ],
        ),
        onPressed: () {
          onPressed?.call();
        },
      ),
    );
  }
}
