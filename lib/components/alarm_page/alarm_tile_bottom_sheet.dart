import 'package:facebook/components/alarm_page/alarm_tile_bottom_sheet_button.dart';
import 'package:flutter/material.dart';

import '../../models/alarm_data.dart';
import '../../models/global_model.dart';
import 'alarm_tile_profile.dart';

class AlarmTileBottomSheet extends StatelessWidget {
  AlarmTileBottomSheet({
    Key? key,
    required this.alarmData,
  }) : super(key: key);

  final AlarmData alarmData;

  final double _sideMargin = appWidth * 0.04;
  final BorderRadius _handleBorderRadius = BorderRadius.circular(2);

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
    return SizedBox(
      height: appHeight * 0.47,
      child: Column(
        children: [
          ClipRRect(
            borderRadius: _handleBorderRadius,
            child: Container(
              margin: EdgeInsets.only(
                top: appHeight * 0.012,
              ),
              height: appHeight * 0.005,
              width: appWidth * 0.1,
              decoration: BoxDecoration(
                color: Colors.grey,
                borderRadius: _handleBorderRadius,
              ),
            ),
          ),
          Container(
            margin: EdgeInsets.only(
              top: appHeight * 0.012,
            ),
            child: AlarmTileProfile(
              uid: alarmData.uid,
            ),
          ),
          Container(
            margin: EdgeInsets.only(
              top: appHeight * 0.01,
              left: _sideMargin,
              right: _sideMargin,
            ),
            child: RichText(
              overflow: TextOverflow.ellipsis,
              maxLines: 2,
              textAlign: TextAlign.center,
              text: TextSpan(
                style: const TextStyle(
                  color: Colors.black,
                  fontSize: 17,
                ),
                children: [
                  TextSpan(
                    text: alarmData.user,
                  ),
                  TextSpan(
                    text: _writeMessage(),
                  ),
                  TextSpan(
                    text: _writeWhatPosted(),
                  ),
                  TextSpan(text: '\'${alarmData.content}\'.'),
                ],
              ),
            ),
          ),
          Container(
            margin: EdgeInsets.only(
              top: appHeight * 0.01,
              right: _sideMargin,
              left: _sideMargin,
              bottom: appHeight * 0.005,
            ),
            height: 1,
            color: Colors.black26,
          ),
          AlarmTileBottomSheetButton(
            sideMargin: _sideMargin,
            icon: Icons.disabled_by_default,
            text: '이 알림 삭제',
            onPressed: () {},
          ),
          AlarmTileBottomSheetButton(
            sideMargin: _sideMargin,
            icon: Icons.subtitles_off,
            text: '이 페이지의 동영상 알림 해제',
            onPressed: () {},
          ),
          AlarmTileBottomSheetButton(
            sideMargin: _sideMargin,
            icon: Icons.settings,
            text: '알림 설정 관리',
            onPressed: () {},
          ),
        ],
      ),
    );
  }
}
