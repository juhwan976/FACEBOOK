// ignore_for_file: file_names
/// ****************************************************************************
/// 사용자 개인마다 알림들을 저장해놓는 파일을 만들어서 그 파일을 불러오는 쪽으로 설계
///
///*****************************************************************************

class AlarmData {
  final String user;
  final UserType userType;
  final String uid;
  final PostType postType;
  final String content;
  final String? video;
  final List<String>? images;
  final int timeStamp;
  bool isRead;

  AlarmData({
    required this.user,
    required this.userType,
    required this.uid,
    required this.postType,
    required this.content,
    this.video,
    this.images,
    required this.timeStamp,
    required this.isRead,
  });
      /*: assert(postType == PostType.video && video == null,
            'PostType is video, but video is null'),
        assert(postType == PostType.image && images == null,
            'PostType is image, but images is null');

       */
}

enum UserType {
  individualPerson,
  groupPerson,
  individualPage,
  groupPage,
}

enum PostType {
  video,
  image,
  onlyText,
}

final List<AlarmData> alarms = [
  AlarmData(
    user: 'Hardwell',
    userType: UserType.groupPerson,
    uid: 'asdfqwer',
    postType: PostType.video,
    content:
        'Can\'t wait to be back in NYC again next week. Grab your tickets ..',
    video: '121212',
    timeStamp: 1662897600 * 1000,
    isRead: false,
  ),
];
